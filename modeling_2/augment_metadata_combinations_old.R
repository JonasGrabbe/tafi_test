# =============================================================================
# Metadata-combination data augmentation for archaeological ML workflows
#
# Strategy:
#   1. Define named buckets of metadata columns
#   2. Generate all valid combos (1–3 buckets, exactly 1 column per bucket)
#   3. For each combo: group_by those columns, summarise
#        - numeric features    → mean()  of the group
#        - non-numeric features → NA     (ambiguous across mixed group values)
#        - grouping columns     → kept   (constant within group by definition)
#   4. Discard any synthetic row that is an exact copy of an original row
#   5. bind_rows(original, all_synthetic)  — same column width throughout
#
# Drop-in replacement for:  identity_aug <- function(x) x
# Becomes:                  identity_aug <- function(x) bind_rows(x, new_rows)
# =============================================================================

library(dplyr)
library(purrr)
library(stringr)
library(tibble)


# ── 0. Bucket definitions ─────────────────────────────────────────────────────

buckets <- list(
  temporal     = c("geological_period", "cultural_period", "culture_period_2",
                   "start_date_cal_bp", "end_date_cal_bp", "mis_stage"),
  spatial      = c("region", "country"),
  site_context = c("karstic_system", "open_air_site"),
  biological   = c("age_category", "gender"),
  taxonomy     = c("hominin_species")
)


# ── 1. Generate all valid combinations ───────────────────────────────────────
#
# A valid combo = choose 1–3 buckets (never repeat a bucket),
# then pick exactly one column from each chosen bucket.
#
# Approximate counts:
#   1-bucket combos:  6+2+2+2+1        =  13
#   2-bucket combos:  all bucket pairs  =  78
#   3-bucket combos:  all bucket triples = 174
#   Total                               ~ 265
#
# Each combo produces at most N synthetic rows (one per group of size >= 2),
# so the augmented dataset grows by 0–265*N rows total.

generate_combos <- function(buckets,
                             min_buckets = 1L,
                             max_buckets = 3L) {
  bucket_names <- names(buckets)

  # All subsets of bucket_names of size min_buckets..max_buckets
  bucket_subsets <- unlist(
    lapply(seq(min_buckets, max_buckets), function(k)
      combn(bucket_names, k, simplify = FALSE)
    ),
    recursive = FALSE
  )

  # For each subset: Cartesian product of the columns within those buckets
  all_combos <- lapply(bucket_subsets, function(bnames) {
    col_lists <- buckets[bnames]
    grid      <- do.call(expand.grid,
                         c(col_lists, stringsAsFactors = FALSE))
    lapply(seq_len(nrow(grid)), function(i)
      as.list(grid[i, , drop = FALSE])
    )
  })

  unlist(all_combos, recursive = FALSE)
}


# ── 2. Augment for one specific combination ───────────────────────────────────
#
# @param df             Original tibble
# @param combo          Named list, one column name per bucket,
#                       e.g. list(spatial = "region", temporal = "cultural_period")
# @param aug_id         Character tag for traceability
# @param feature_cols   Character vector of columns used as ML features
#                       (everything except site_id, target, mni, etc.)
# @param min_group_size Groups smaller than this are skipped (default 2)
#
# @return Tibble with the same columns as df + .aug_id, or empty tibble if
#         no qualifying groups exist.

augment_with_combination <- function(df,
  combo,
  aug_id,
  feature_cols,
  integer_cols   = character(0),  # ✅ new: cols to round
  required_cols  = character(0),  # ✅ new: cols that cannot be NA
  min_group_size = 2L) {

combo_cols <- unlist(combo, use.names = FALSE)

missing_cols <- setdiff(combo_cols, names(df))
if (length(missing_cols) > 0) {
warning("Skipping ", aug_id, ": columns not in df: ",
paste(missing_cols, collapse = ", "))
return(tibble::tibble())
}

df_valid <- df |>
dplyr::filter(dplyr::if_all(dplyr::all_of(combo_cols), ~ !is.na(.x)))

if (nrow(df_valid) == 0) return(tibble::tibble())

feature_cols_present     <- intersect(feature_cols, names(df))
numeric_features         <- feature_cols_present[sapply(df[feature_cols_present], is.numeric)]
non_numeric_features     <- setdiff(feature_cols_present, numeric_features)
non_numeric_non_grouping <- setdiff(non_numeric_features, combo_cols)

new_rows <- df_valid |>
dplyr::group_by(dplyr::across(dplyr::all_of(combo_cols))) |>
dplyr::filter(dplyr::n() >= min_group_size) |>
dplyr::summarise(
dplyr::across(dplyr::all_of(numeric_features),         ~ mean(.x, na.rm = TRUE)),
dplyr::across(dplyr::all_of(non_numeric_non_grouping), ~ NA),
.groups = "drop"
) |>
# ✅ Round integer columns (e.g. mni) — mean of counts must stay integer
dplyr::mutate(
dplyr::across(
dplyr::all_of(intersect(integer_cols, names(pick(everything())))),
~ as.integer(round(.x))
)
) |>
dplyr::mutate(.aug_id = aug_id)

if (nrow(new_rows) == 0) return(tibble::tibble())

absent_cols <- setdiff(names(df), names(new_rows))
for (col in absent_cols) {
new_rows[[col]] <- NA
}

new_rows <- new_rows |>
dplyr::select(dplyr::all_of(names(df)), .aug_id) |>
tibble::as_tibble()

# ✅ Drop any synthetic row where a required column ended up NA or NaN
# (happens when every value in that group was NA → mean() returns NaN)
if (length(required_cols) > 0) {
required_present <- intersect(required_cols, names(new_rows))
new_rows <- new_rows |>
dplyr::filter(
dplyr::if_all(dplyr::all_of(required_present), ~ !is.na(.x) & !is.nan(.x))
)
}

new_rows |>
dplyr::anti_join(
dplyr::select(df, dplyr::all_of(feature_cols_present)),
by = feature_cols_present
)
}


# ── 3. Apply across all combinations & bind with original ─────────────────────
#
# This is the drop-in replacement for:
#   identity_aug <- function(x) x
# becoming:
#   identity_aug <- function(x) bind_rows(x, new_rows)
#
# @param df             Original tibble
# @param combos         List of combos from generate_combos()
# @param feature_cols   Passed through to augment_with_combination()
# @param min_group_size Passed through to augment_with_combination()
#
# @return Tibble: original rows (tagged .aug_id = "original") +
#                 all non-duplicate synthetic rows

build_augmented_dataset <- function(df,
  combos,
  feature_cols,
  integer_cols   = character(0),
  required_cols  = character(0),
  min_group_size = 2L) {

original_tagged <- df |> dplyr::mutate(.aug_id = "original")

synthetic_rows <- purrr::imap_dfr(combos, function(combo, idx) {
aug_id <- paste0(
"aug_", stringr::str_pad(idx, width = 4, pad = "0"),
"_", paste(unlist(combo), collapse = "+")
)
augment_with_combination(
df             = df,
combo          = combo,
aug_id         = aug_id,
feature_cols   = feature_cols,
integer_cols   = integer_cols,    # ✅
required_cols  = required_cols,   # ✅
min_group_size = min_group_size
)
})

dplyr::bind_rows(original_tagged, synthetic_rows) |>
tibble::as_tibble()
}


# ── 4. Plug into the existing recipe workflow ──────────────────────────────────
#
# Pass as augment_fun = my_augment_fun to step_meta_smote().
# The .aug_id column is dropped before SMOTE sees the data.

make_augment_fun <- function(combos,
  feature_cols,
  integer_cols   = character(0),
  required_cols  = character(0),
  min_group_size = 2L) {
function(x) {
build_augmented_dataset(
df             = x,
combos         = combos,
feature_cols   = feature_cols,
integer_cols   = integer_cols,
required_cols  = required_cols,
min_group_size = min_group_size
) |>
dplyr::select(-.aug_id)
}
}


# =============================================================================
# USAGE EXAMPLES
# =============================================================================

# ── A. Generate combos (do once, reuse) ───────────────────────────────────────

# combos <- generate_combos(buckets)
# cat("Total combinations:", length(combos), "\n")   # ~265


# ── B. Inspect a single combo ─────────────────────────────────────────────────

# one_combo <- list(spatial = "region", temporal = "cultural_period")
#
# augment_with_combination(
#   df             = your_df,
#   combo          = one_combo,
#   aug_id         = "test",
#   feature_cols   = feature_cols,
#   min_group_size = 2L
# )


# ── C. Build the full augmented dataset standalone ────────────────────────────

# augmented_df <- build_augmented_dataset(
#   df             = your_df,
#   combos         = combos,
#   feature_cols   = feature_cols,
#   min_group_size = 2L
# )
#
# augmented_df |> count(.aug_id, sort = TRUE)   # rows per augmentation pass
# nrow(augmented_df) - nrow(your_df)            # total synthetic rows added


# ── D. Drop-in for step_meta_smote ────────────────────────────────────────────

# combos       <- generate_combos(buckets)
# my_augment_fun <- make_augment_fun(combos, feature_cols, min_group_size = 2L)
#
# recipe_obj <- build_recipe_for_task(df = model_df, ...) |>
#   step_meta_smote(
#     raw_df_id    = raw_df_id,
#     raw_df_sum   = raw_df_sum,
#     site_id_col  = site_id_col,
#     target_col   = target_variable,
#     mni_col      = mni_col,
#     feature_cols = feature_cols,
#     augment_fun  = my_augment_fun,   # <-- replaces identity_aug
#     neighbors    = 1,
#     over_ratio   = 1,
#     skip         = TRUE
#   )
