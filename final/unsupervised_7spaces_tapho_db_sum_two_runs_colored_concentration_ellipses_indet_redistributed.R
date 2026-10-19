# ==============================================================================
# Unsupervised SPR analysis: 7 feature spaces, TWO RUNS
# DIRECT SUMMED DATASET (tapho_db_sum); COLORED PLOTS; 90% CONCENTRATION ELLIPSES
#
# INPUT:
#   final/tapho_db_sum.csv
#
# RUN A -- REFERENCE FIT + SPECIAL-CONTEXT PROJECTION
#   * k-selection, scaling, PCA and K-means use only the four known contexts:
#       Funerary Context, Cannibalism, Carnivore-related, Geological transport.
#   * Historical / early named records remain INSIDE the known fit.
#   * Unknown/Unkown and Cuevas Sepulcrales/Sepulchral Cave are projected later.
#
# RUN B -- ALL REQUESTED CONTEXTS INCLUDED IN FIT
#   * k-selection, scaling, PCA and K-means use:
#       the four known contexts + Unknown/Unkown +
#       Cuevas Sepulcrales/Sepulchral Cave.
#   * Unknown and sepulchral rows therefore influence k and cluster centers.
#   * Archaeological label-association statistics are still evaluated only on
#     the four known labelled contexts. Unknown/sepulchral rows are not relabelled.
#
# COMMON DESIGN
#   * tapho_db_sum is used directly. No site_id is required and no row collapse.
#   * C / abundance = Mean_part_abundance.
#   * Evenness = mnau_heip_evenness (Heip evenness).
#   * FIRST PREPROCESSING STEP: bilateral *_indet values are redistributed
#     as evenly as possible onto matching *_left / *_right columns.
#   * %MNAU = stored ProportionalRep_MNIbased_* values after that redistribution.
#     Added values cannot push either side above 1.0 (100%); unassignable remainder
#     stays in the corresponding *_indet column and is reported in an audit table.
#   * ReMNAU = stored ReMNAU_* values after the same 50:50 bilateral redistribution
#     (no artificial 1.0 cap is imposed on ReMNAU).
#   * No adjusted transformation and no Hellinger transformation.
#   * Median imputation + z-standardization are numerical preprocessing only.
#   * K-means is fitted in the FULL standardized feature space.
#   * PCA is visualization/interpretation only when dimension > 2.
#   * 2D ellipses are 90% group-specific CONCENTRATION/DATA ellipses.
#     They use each cluster covariance matrix and the chi-square(2) Mahalanobis contour.
#     They describe within-cluster dispersion; they are NOT confidence regions for means.
#   * 1D bars are analogous 90% concentration intervals around the observed distribution,
#     not confidence intervals for the cluster mean.
#   * Cluster colors are consistent within each feature-space plot.
#
# IMPORTANT PRIOR EXCLUSION RETAINED:
#   * Sima de los Huesos PNAS is excluded from Unknown analyses by default.
#     Set EXCLUDE_SIMA_PNAS <- FALSE below if you want to include it.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. Preflight paths and output folders BEFORE package loading
# ------------------------------------------------------------------------------

RUN_WD <- getwd()
INPUT_FILE <- file.path(RUN_WD, "final", "tapho_db_sum.csv")
ROOT_OUT <- file.path(
  RUN_WD,
  "unsupervised_7spaces_tapho_db_sum_TWO_RUNS_R_outputs_3"
)

RUN_A_OUT <- file.path(ROOT_OUT, "run_A_reference_fit_projection")
RUN_B_OUT <- file.path(ROOT_OUT, "run_B_all_contexts_in_kmeans_fit")

cat("\n=== UNSUPERVISED 7-SPACE TWO-RUN ANALYSIS ===\n")
cat("Working directory :", RUN_WD, "\n")
cat("Input file        :", INPUT_FILE, "\n")
cat("Root output       :", ROOT_OUT, "\n\n")

if (!file.exists(INPUT_FILE)) {
  stop(
    "Input file not found: ", INPUT_FILE, "\n",
    "Current working directory: ", RUN_WD, "\n",
    "Set the working directory to the project root containing final/tapho_db_sum.csv."
  )
}

dir.create(ROOT_OUT, showWarnings = TRUE, recursive = TRUE)
dir.create(RUN_A_OUT, showWarnings = TRUE, recursive = TRUE)
dir.create(RUN_B_OUT, showWarnings = TRUE, recursive = TRUE)

if (!dir.exists(ROOT_OUT) || !dir.exists(RUN_A_OUT) || !dir.exists(RUN_B_OUT)) {
  stop("Could not create one or more output directories under: ", ROOT_OUT)
}

INPUT_FILE <- normalizePath(INPUT_FILE, winslash = "/", mustWork = TRUE)
ROOT_OUT <- normalizePath(ROOT_OUT, winslash = "/", mustWork = TRUE)
RUN_A_OUT <- normalizePath(RUN_A_OUT, winslash = "/", mustWork = TRUE)
RUN_B_OUT <- normalizePath(RUN_B_OUT, winslash = "/", mustWork = TRUE)

writeLines(
  c(
    paste("Run started:", Sys.time()),
    paste("Working directory:", RUN_WD),
    paste("Input file:", INPUT_FILE),
    paste("Run A output:", RUN_A_OUT),
    paste("Run B output:", RUN_B_OUT)
  ),
  file.path(ROOT_OUT, "RUN_STARTED.txt")
)

required_packages <- c("tidyverse", "cluster", "vegan", "ggrepel")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  msg <- paste0(
    "Missing required R package(s): ",
    paste(missing_packages, collapse = ", "),
    ". Install them and rerun."
  )
  writeLines(msg, file.path(ROOT_OUT, "RUN_STOPPED_MISSING_PACKAGES.txt"))
  stop(msg)
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(cluster)
  library(vegan)
  library(ggrepel)
})

set.seed(42)

SEED <- 42
B_PERM <- 4999
CI_LEVEL <- 0.90
EXCLUDE_SIMA_PNAS <- TRUE

# Bilateral indeterminate handling.
# The paired *_indet values are redistributed BEFORE feature-space construction.
REDISTRIBUTE_BILATERAL_INDET <- TRUE
PCTMNAU_MAX <- 1.0

# After redistribution, the paired *_indet columns are excluded as clustering
# dimensions to avoid double-counting the same anatomical information.
# Any %MNAU amount that cannot be assigned because both sides are already at 1
# remains in *_indet and is retained in the audit files, but not as a clustering feature.
DROP_REDISTRIBUTED_INDET_FROM_CLUSTERING <- TRUE

# ------------------------------------------------------------------------------
# 1. Plot palettes
# ------------------------------------------------------------------------------

CLUSTER_COLOURS <- c(
  "#1B9E77", "#D95F02", "#7570B3", "#E7298A",
  "#66A61E", "#E6AB02", "#A6761D", "#1F78B4"
)

METRIC_COLOURS <- c(
  Relative_inertia = "#0072B2",
  Silhouette = "#D55E00"
)

DISPLAY_SHAPES <- c(
  "Funerary" = 16,
  "Cannibalism" = 17,
  "Carnivore-related" = 15,
  "Geological transport" = 18,
  "Unknown" = 4,
  "Sepulchral" = 8
)

SPECIAL_COLOURS <- c(
  "Unknown" = "#111111",
  "Sepulchral" = "#CC79A7"
)

SPECIAL_SHAPES <- c(
  "Unknown" = 4,
  "Sepulchral" = 8
)

PANEL_COLOURS <- c(
  "Historical" = "#0072B2",
  "Early" = "#D55E00",
  "Both panels" = "#6A3D9A"
)

PANEL_SHAPES <- c(
  "Historical" = 21,
  "Early" = 24,
  "Both panels" = 23
)

cluster_colour_values <- function(cluster_factor) {
  lev <- levels(cluster_factor)
  setNames(CLUSTER_COLOURS[seq_along(lev)], lev)
}

# ------------------------------------------------------------------------------
# 2. Read tapho_db_sum directly
# ------------------------------------------------------------------------------

d_raw <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

writeLines(
  c(
    paste("Input read successfully:", Sys.time()),
    paste("Rows:", nrow(d_raw)),
    paste("Columns:", ncol(d_raw))
  ),
  file.path(ROOT_OUT, "RUN_INPUT_OK.txt")
)

C_VAR <- "Mean_part_abundance"
E_VAR <- "mnau_heip_evenness"

required_metadata <- c("site_name", "taphonomic_context", "funerary_context")
missing_metadata <- setdiff(required_metadata, names(d_raw))
if (length(missing_metadata) > 0) {
  stop(
    "Missing required metadata column(s): ",
    paste(missing_metadata, collapse = ", ")
  )
}

if (!C_VAR %in% names(d_raw)) stop("Missing C variable: ", C_VAR)
if (!E_VAR %in% names(d_raw)) stop("Missing Heip variable: ", E_VAR)

if (!"layer_name" %in% names(d_raw)) d_raw$layer_name <- NA_character_

# Synthetic record ID for bookkeeping only; never a clustering variable.
d <- d_raw %>%
  mutate(record_id = row_number(), .before = 1)

# ------------------------------------------------------------------------------
# 3. FIRST PREPROCESSING STEP: redistribute bilateral *_indet values
# ------------------------------------------------------------------------------
#
# Only exact bilateral triplets are touched:
#   <base>_indet, <base>_left, <base>_right
# Examples in these data include clavicle, scapula, humerus, radius and ulna.
# Generic pooled variables such as thorax_indet / shoulder_indet / arms_indet are
# NOT redistributed because there is no exact left/right counterpart for the same base.
#
# ReMNAU: split the indeterminate amount 50:50 between left and right.
# %MNAU: do the same, but never add beyond 1.0 on either side. If one side lacks
# capacity, its share is transferred to the other side. If both sides are saturated,
# the unassignable remainder stays in *_indet rather than being discarded.

find_bilateral_triplets <- function(data_names, prefix, feature_type) {
  indet <- data_names[
    stringr::str_starts(data_names, prefix) &
      stringr::str_ends(data_names, "_indet")
  ]

  if (length(indet) == 0) return(tibble())

  out <- tibble(
    feature_type = feature_type,
    indet_col = indet,
    base = stringr::str_remove(indet, "_indet$"),
    left_col = paste0(base, "_left"),
    right_col = paste0(base, "_right")
  ) %>%
    filter(left_col %in% data_names, right_col %in% data_names) %>%
    mutate(
      anatomical_part = stringr::str_remove(base, paste0("^", prefix))
    )

  out
}

indet_pairs <- bind_rows(
  find_bilateral_triplets(
    names(d),
    "ProportionalRep_MNIbased_",
    "%MNAU"
  ),
  find_bilateral_triplets(
    names(d),
    "ReMNAU_",
    "ReMNAU"
  )
)

if (nrow(indet_pairs) == 0) {
  warning("No exact *_indet / *_left / *_right feature triplets were found.")
}

# Report pre-existing out-of-range %MNAU values rather than silently changing them.
# The redistribution itself will never create a value > 1.
pct_pair_side_cols <- indet_pairs %>%
  filter(feature_type == "%MNAU") %>%
  select(left_col, right_col) %>%
  unlist(use.names = FALSE) %>%
  unique()

pct_preexisting_over_one <- if (length(pct_pair_side_cols) > 0) {
  sum(
    vapply(
      d[pct_pair_side_cols],
      function(z) sum(is.finite(z) & z > PCTMNAU_MAX + 1e-12, na.rm = TRUE),
      numeric(1)
    )
  )
} else {
  0
}

if (pct_preexisting_over_one > 0) {
  warning(
    pct_preexisting_over_one,
    " pre-existing paired %MNAU side value(s) already exceed 1.0. ",
    "They are not silently corrected; no additional indeterminate amount will be ",
    "assigned to a side without available capacity."
  )
}

redistribute_bilateral_pair <- function(
  dat, indet_col, left_col, right_col,
  feature_type, anatomical_part, max_value = Inf
) {
  i_before <- dat[[indet_col]]
  l_before <- dat[[left_col]]
  r_before <- dat[[right_col]]

  i_after <- i_before
  l_after <- l_before
  r_after <- r_before

  audit_rows <- list()
  ai <- 1L

  rows <- which(is.finite(i_before) & i_before > 0)

  for (j in rows) {
    amount <- i_before[j]

    # If a side is missing but there is an indeterminate amount to redistribute,
    # zero is used only as the starting value for that side. Missing sides with no
    # indeterminate amount remain missing and are handled later by ordinary imputation.
    l0 <- if (is.na(l_before[j])) 0 else l_before[j]
    r0 <- if (is.na(r_before[j])) 0 else r_before[j]

    if (is.finite(max_value)) {
      cap_l <- max(0, max_value - l0)
      cap_r <- max(0, max_value - r0)
    } else {
      cap_l <- Inf
      cap_r <- Inf
    }

    # First attempt an exact 50:50 split.
    add_l <- if (is.finite(cap_l)) min(amount / 2, cap_l) else amount / 2
    add_r <- if (is.finite(cap_r)) min(amount / 2, cap_r) else amount / 2

    remaining <- amount - add_l - add_r

    # If one side hit its %MNAU ceiling, transfer the remaining amount to whichever
    # side still has capacity. With unbounded ReMNAU, remaining is normally zero.
    if (remaining > 0) {
      cap_l2 <- if (is.finite(cap_l)) max(0, cap_l - add_l) else Inf
      take_l <- if (is.finite(cap_l2)) min(remaining, cap_l2) else remaining
      add_l <- add_l + take_l
      remaining <- remaining - take_l
    }

    if (remaining > 0) {
      cap_r2 <- if (is.finite(cap_r)) max(0, cap_r - add_r) else Inf
      take_r <- if (is.finite(cap_r2)) min(remaining, cap_r2) else remaining
      add_r <- add_r + take_r
      remaining <- remaining - take_r
    }

    l_after[j] <- l0 + add_l
    r_after[j] <- r0 + add_r
    i_after[j] <- max(0, remaining)

    # Numerical guard: the redistribution may not create %MNAU values > 1.
    if (is.finite(max_value)) {
      if (l0 <= max_value + 1e-12) l_after[j] <- min(l_after[j], max_value)
      if (r0 <= max_value + 1e-12) r_after[j] <- min(r_after[j], max_value)
    }

    audit_rows[[ai]] <- tibble(
      record_id = dat$record_id[j],
      site_name = dat$site_name[j],
      taphonomic_context = dat$taphonomic_context[j],
      feature_type = feature_type,
      anatomical_part = anatomical_part,
      indet_col = indet_col,
      left_col = left_col,
      right_col = right_col,
      indet_before = i_before[j],
      left_before = l_before[j],
      right_before = r_before[j],
      assigned_left = add_l,
      assigned_right = add_r,
      residual_indet = i_after[j],
      left_after = l_after[j],
      right_after = r_after[j],
      pct_cap = if (is.finite(max_value)) max_value else NA_real_
    )
    ai <- ai + 1L
  }

  dat[[indet_col]] <- i_after
  dat[[left_col]] <- l_after
  dat[[right_col]] <- r_after

  list(
    data = dat,
    audit = if (length(audit_rows) > 0) bind_rows(audit_rows) else tibble()
  )
}

indet_audit_parts <- list()

if (REDISTRIBUTE_BILATERAL_INDET && nrow(indet_pairs) > 0) {
  for (ii in seq_len(nrow(indet_pairs))) {
    pair <- indet_pairs[ii, ]

    max_val <- if (pair$feature_type == "%MNAU") PCTMNAU_MAX else Inf

    rr <- redistribute_bilateral_pair(
      dat = d,
      indet_col = pair$indet_col,
      left_col = pair$left_col,
      right_col = pair$right_col,
      feature_type = pair$feature_type,
      anatomical_part = pair$anatomical_part,
      max_value = max_val
    )

    d <- rr$data
    indet_audit_parts[[paste(pair$feature_type, pair$anatomical_part, sep = "_")]] <- rr$audit
  }
}

indet_redistribution_audit <- bind_rows(indet_audit_parts)

if (ncol(indet_redistribution_audit) == 0) {
  indet_redistribution_audit <- tibble(
    record_id = integer(),
    site_name = character(),
    taphonomic_context = character(),
    feature_type = character(),
    anatomical_part = character(),
    indet_col = character(),
    left_col = character(),
    right_col = character(),
    indet_before = numeric(),
    left_before = numeric(),
    right_before = numeric(),
    assigned_left = numeric(),
    assigned_right = numeric(),
    residual_indet = numeric(),
    left_after = numeric(),
    right_after = numeric(),
    pct_cap = numeric()
  )
}

if (nrow(indet_redistribution_audit) > 0) {
  indet_redistribution_summary <- indet_redistribution_audit %>%
    group_by(feature_type, anatomical_part, indet_col, left_col, right_col) %>%
    summarise(
      n_records_redistributed = n(),
      total_indet_before = sum(indet_before, na.rm = TRUE),
      total_assigned_left = sum(assigned_left, na.rm = TRUE),
      total_assigned_right = sum(assigned_right, na.rm = TRUE),
      total_residual_indet = sum(residual_indet, na.rm = TRUE),
      n_with_residual = sum(residual_indet > 1e-12, na.rm = TRUE),
      .groups = "drop"
    )
} else {
  indet_redistribution_summary <- indet_pairs %>%
    transmute(
      feature_type, anatomical_part, indet_col, left_col, right_col,
      n_records_redistributed = 0L,
      total_indet_before = 0,
      total_assigned_left = 0,
      total_assigned_right = 0,
      total_residual_indet = 0,
      n_with_residual = 0L
    )
}

write_csv(indet_pairs, file.path(ROOT_OUT, "indet_bilateral_pairs_detected.csv"))
write_csv(
  indet_redistribution_audit,
  file.path(ROOT_OUT, "indet_redistribution_audit.csv")
)
write_csv(
  indet_redistribution_summary,
  file.path(ROOT_OUT, "indet_redistribution_summary.csv")
)

writeLines(
  c(
    "BILATERAL INDETERMINATE REDISTRIBUTION",
    "",
    "This step is performed before feature-space construction, scaling, PCA, k-selection and K-means in both runs.",
    "Only exact *_indet / *_left / *_right triplets are redistributed.",
    "Generic pooled *_indet variables without exact bilateral counterparts are left unchanged.",
    "ReMNAU indeterminate values are split 50:50 between matching left/right variables.",
    paste0("%MNAU indeterminate values are split as evenly as possible with a hard addition ceiling of ", PCTMNAU_MAX, " per side."),
    "If one %MNAU side is saturated, the unassigned share is transferred to the opposite side when capacity exists.",
    "If both %MNAU sides are saturated, the remainder stays in *_indet and is recorded; it is never discarded.",
    "Paired redistributed *_indet columns are excluded from clustering to avoid double-counting.",
    "Precomputed Mean_part_abundance, mnau_heip_evenness and engineered variables are not recomputed by this script.",
    paste0("Pre-existing paired %MNAU side values > 1 detected: ", pct_preexisting_over_one)
  ),
  file.path(ROOT_OUT, "REPORTING_NOTES_INDET_REDISTRIBUTION.txt")
)

# ------------------------------------------------------------------------------
# 4. Feature columns (after bilateral indeterminate redistribution)
# ------------------------------------------------------------------------------

prop_cols <- names(d)[
  stringr::str_starts(names(d), "ProportionalRep_MNIbased_")
]

rem_cols <- names(d)[
  stringr::str_starts(names(d), "ReMNAU_")
]

# Exclude exactly those paired *_indet columns that were eligible for bilateral
# redistribution. Unpaired pooled *_indet variables remain available as raw features.
prop_indet_exclude <- indet_pairs %>%
  filter(feature_type == "%MNAU") %>%
  pull(indet_col)

rem_indet_exclude <- indet_pairs %>%
  filter(feature_type == "ReMNAU") %>%
  pull(indet_col)

if (DROP_REDISTRIBUTED_INDET_FROM_CLUSTERING) {
  prop_cols <- setdiff(prop_cols, prop_indet_exclude)
  rem_cols <- setdiff(rem_cols, rem_indet_exclude)
}

eng_cols <- c(
  "mnau_proximal_appendicular_mean",
  "mnau_lower_appendicular_mean",
  "mnau_distal_appendicular_mean",
  "mnau_appendicular_mean",
  "mnau_postcranial_total_mean",
  "mnau_top2_share_mcnaughton",
  "mnau_upper_appendicular_mean",
  "low_density_survival_index",
  "mnau_vertebrae_to_thorax_ratio",
  "all_sections_dominance",
  "mnau_lower_upper_appendicular_diff",
  "mnau_heip_evenness",
  "mnau_girdle_appendicular_logratio",
  "postcranial_continuity_hm",
  "mnau_girdle_to_appendicular_ratio",
  "mnau_gini",
  "density_representation_r2",
  "mnau_cv",
  "mnau_girdle_appendicular_diff",
  "mnau_full_axial_mean",
  "mnau_arms",
  "dominance_gap_all",
  "mnau_girdle_share_of_appendicular",
  "section_completeness_025_all",
  "whole_body_continuity_hm",
  "density_representation_slope",
  "mnau_limb_shaft_proxy_mean",
  "density_residual_sd"
)
eng_cols <- intersect(eng_cols, names(d))

BASE_FEATURE_SETS <- list(
  `C only` = C_VAR,
  `Heip evenness only` = E_VAR,
  `C + Heip evenness` = c(C_VAR, E_VAR),
  `%MNAU raw` = prop_cols,
  `ReMNAU raw` = rem_cols,
  `Engineered` = eng_cols,
  `Combined` = unique(c(prop_cols, rem_cols, eng_cols))
)

# ------------------------------------------------------------------------------
# 5. Archaeological labels and special contexts
# ------------------------------------------------------------------------------

class4_fun <- function(x) {
  case_when(
    x == "Funerary Context" ~ "Funerary",
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)"
    ) ~ "Carnivore-related",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

norm_fun_subtype <- function(x) {
  xl <- stringr::str_to_lower(stringr::str_trim(x))

  case_when(
    is.na(x) ~ "Missing",
    xl == "inhumation single" ~ "Single inhumation",
    stringr::str_starts(xl, "inhumation single; inhumation multiple") ~
      "Single + multiple",
    xl == "inhumation multiple" ~ "Multiple inhumation",
    xl == "inhumation single; collective burial" ~ "Single + collective",
    stringr::str_starts(xl, "collective burial") &
      stringr::str_detect(xl, "secondary") ~ "Collective-secondary",
    stringr::str_starts(xl, "collective burial") ~ "Collective burial",
    xl == "cremation" ~ "Cremation",
    xl == "funerary caching" ~ "Funerary caching",
    xl == "possible burial" ~ "Possible burial",
    xl == "no inhumation" ~ "No inhumation",
    TRUE ~ stringr::str_trim(x)
  )
}

historical <- c(
  "La Chapelle-aux-Saints", "La Ferrassie", "Regourdou", "Roc de Marsal",
  "Shanidar Cave", "Krapina", "La Quina", "Moula-Guercy", "Grotta Guattari",
  "Mladeč Caves", "Cro-Magnon I", "Brno II", "Teshik-Tash Cave",
  "Cueva de los Torrejones", "Crow Creek", "Goat’s Hole (Paviland Cave)"
)

early <- c(
  "El Sidrón J1", "Mancos 5MT-10010 Feature 3", "Yellow Jacket 5MT-3",
  "Qafzeh Cave", "Tabun Cave (Mugharet et-Tabun)", "Mugharet es-Skhul",
  "Grotte de Fontbrégoua", "Cova Gran de Santa Linya", "Sima de las Palomas",
  "Kebara Cave", "La Ferrassie"
)

test_names <- union(historical, early)

SEPULCHRAL_CONTEXTS <- c("Cuevas Sepulcrales", "Sepulchral Cave")
UNKNOWN_CONTEXTS <- c("Unknown", "Unkown")

# Labels are defined for interpretation only; they are never used by k-means.
d <- d %>%
  mutate(
    class4 = class4_fun(taphonomic_context),
    binary_label = case_when(
      class4 == "Funerary" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    ),
    funerary_subtype_norm = norm_fun_subtype(funerary_context),
    named_panel = case_when(
      site_name %in% historical & site_name %in% early ~ "Both panels",
      site_name %in% historical ~ "Historical",
      site_name %in% early ~ "Early",
      TRUE ~ NA_character_
    ),
    special_type = case_when(
      taphonomic_context %in% UNKNOWN_CONTEXTS ~ "Unknown",
      taphonomic_context %in% SEPULCHRAL_CONTEXTS ~ "Sepulchral",
      TRUE ~ NA_character_
    ),
    display_group = case_when(
      !is.na(class4) ~ class4,
      special_type == "Unknown" ~ "Unknown",
      special_type == "Sepulchral" ~ "Sepulchral",
      TRUE ~ NA_character_
    )
  )

ignored_pnas <- d %>%
  filter(
    special_type == "Unknown",
    site_name == "Sima de los Huesos PNAS"
  )

analysis_pool <- d
if (EXCLUDE_SIMA_PNAS) {
  analysis_pool <- analysis_pool %>%
    filter(
      !(
        special_type == "Unknown" &
          site_name == "Sima de los Huesos PNAS"
      )
    )
}

known_reference <- analysis_pool %>%
  filter(!is.na(class4))

special_contexts <- analysis_pool %>%
  filter(special_type %in% c("Unknown", "Sepulchral"))

other_excluded <- analysis_pool %>%
  filter(is.na(class4), is.na(special_type))

run_A_fit <- known_reference
run_A_projection <- special_contexts

run_B_fit <- analysis_pool %>%
  filter(!is.na(class4) | special_type %in% c("Unknown", "Sepulchral"))

root_partition <- tibble(
  dataset = c(
    "Known four-context rows",
    "Unknown/Unkown rows used (PNAS rule applied)",
    "Sepulchral Cave / Cuevas Sepulcrales rows",
    "Historical/early named rows among known",
    "Ignored Sima de los Huesos PNAS rows",
    "Other contexts excluded"
  ),
  n_rows = c(
    nrow(known_reference),
    sum(special_contexts$special_type == "Unknown"),
    sum(special_contexts$special_type == "Sepulchral"),
    sum(!is.na(known_reference$named_panel)),
    nrow(ignored_pnas),
    nrow(other_excluded)
  )
)

write_csv(root_partition, file.path(ROOT_OUT, "sample_partition_root.csv"))
print(root_partition)

# ------------------------------------------------------------------------------
# 5. Generic helpers
# ------------------------------------------------------------------------------

informative <- function(data, vars) {
  vars[
    vapply(
      vars,
      function(v) {
        z <- data[[v]]
        sum(!is.na(z)) > 1 &&
          dplyr::n_distinct(z, na.rm = TRUE) > 1
      },
      logical(1)
    )
  ]
}

make_preprocessor <- function(train, vars) {
  missing_vars <- setdiff(vars, names(train))
  if (length(missing_vars) > 0) {
    stop("Missing variables: ", paste(missing_vars, collapse = ", "))
  }

  med <- map_dbl(
    vars,
    function(v) {
      x <- train[[v]]
      if (all(is.na(x))) return(NA_real_)
      median(x, na.rm = TRUE)
    }
  )
  names(med) <- vars

  if (any(!is.finite(med))) {
    bad <- names(med)[!is.finite(med)]
    stop(
      "Cannot impute feature(s) with no finite fit values: ",
      paste(bad, collapse = ", ")
    )
  }

  x0 <- as.data.frame(train[, vars, drop = FALSE])
  for (v in vars) x0[[v]][is.na(x0[[v]])] <- med[[v]]

  X0 <- as.matrix(x0)
  mu <- colMeans(X0)
  sdv <- apply(X0, 2, sd)
  sdv[!is.finite(sdv) | sdv == 0] <- 1

  X <- sweep(sweep(X0, 2, mu, "-"), 2, sdv, "/")

  list(
    vars = vars,
    medians = med,
    means = mu,
    sds = sdv,
    X_train_raw = X0,
    X_train = X
  )
}

apply_preprocessor <- function(prep, newdata) {
  if (is.null(newdata) || nrow(newdata) == 0) {
    return(list(
      raw = matrix(numeric(0), nrow = 0, ncol = length(prep$vars)),
      scaled = matrix(numeric(0), nrow = 0, ncol = length(prep$vars))
    ))
  }

  x0 <- as.data.frame(newdata[, prep$vars, drop = FALSE])
  for (v in prep$vars) x0[[v]][is.na(x0[[v]])] <- prep$medians[[v]]

  X0 <- as.matrix(x0)
  X <- sweep(sweep(X0, 2, prep$means, "-"), 2, prep$sds, "/")

  list(raw = X0, scaled = X)
}

elbow_distance <- function(k, inertia) {
  if (length(k) < 3) return(NA_integer_)

  xn <- (k - min(k)) / (max(k) - min(k))
  yn <- (inertia - min(inertia)) / (max(inertia) - min(inertia))

  p1 <- c(xn[1], yn[1])
  p2 <- c(xn[length(xn)], yn[length(yn)])
  line <- p2 - p1

  denom <- sqrt(sum(line^2))
  if (!is.finite(denom) || denom == 0) return(NA_integer_)

  dd <- map_dbl(seq_along(k), function(i) {
    p <- c(xn[i], yn[i])
    abs(
      line[1] * (p[2] - p1[2]) -
        line[2] * (p[1] - p1[1])
    ) / denom
  })

  inner <- 2:(length(k) - 1)
  k[inner[which.max(dd[inner])]]
}

choose_k <- function(kvals, inertia, silhouettes) {
  elbow_k <- elbow_distance(kvals, inertia)
  sil_k <- kvals[which.max(replace_na(silhouettes, -Inf))]
  max_sil <- max(silhouettes, na.rm = TRUE)

  sil_at_elbow <- if (!is.na(elbow_k)) {
    silhouettes[match(elbow_k, kvals)]
  } else {
    NA_real_
  }

  if (
    !is.na(elbow_k) && elbow_k >= 2 &&
      is.finite(sil_at_elbow) &&
      sil_at_elbow >= max_sil - 0.02
  ) {
    chosen_k <- elbow_k
    rule <- "Elbow; silhouette within 0.02 of maximum"
  } else {
    chosen_k <- sil_k
    rule <- "Maximum silhouette"
  }

  list(
    elbow_k = elbow_k,
    silhouette_k = sil_k,
    chosen_k = chosen_k,
    rule = rule
  )
}

choose2 <- function(n) n * (n - 1) / 2

ARI <- function(a, b) {
  tab <- table(a, b)
  sum_comb <- sum(choose2(tab))
  row_comb <- sum(choose2(rowSums(tab)))
  col_comb <- sum(choose2(colSums(tab)))
  total_comb <- choose2(sum(tab))
  if (total_comb == 0) return(NA_real_)
  expected <- row_comb * col_comb / total_comb
  max_index <- 0.5 * (row_comb + col_comb)
  if (max_index == expected) return(0)
  (sum_comb - expected) / (max_index - expected)
}

NMI <- function(a, b) {
  tab <- table(a, b)
  pxy <- tab / sum(tab)
  px <- rowSums(pxy)
  py <- colSums(pxy)
  nz <- which(pxy > 0, arr.ind = TRUE)
  mi <- sum(pxy[nz] * log(pxy[nz] / (px[nz[, 1]] * py[nz[, 2]])))
  hx <- -sum(px[px > 0] * log(px[px > 0]))
  hy <- -sum(py[py > 0] * log(py[py > 0]))
  if (hx == 0 || hy == 0) return(0)
  mi / sqrt(hx * hy)
}

purity <- function(labels, clusters) {
  tab <- table(clusters, labels)
  sum(apply(tab, 1, max)) / sum(tab)
}

bias_corrected_cramers_v <- function(labels, clusters) {
  tab <- table(clusters, labels)
  if (nrow(tab) < 2 || ncol(tab) < 2) return(NA_real_)

  chi <- suppressWarnings(chisq.test(tab, correct = FALSE))
  n <- sum(tab)
  phi2 <- as.numeric(chi$statistic) / n
  r <- nrow(tab)
  k <- ncol(tab)

  phi2_corr <- max(0, phi2 - ((k - 1) * (r - 1)) / (n - 1))
  r_corr <- r - ((r - 1)^2) / (n - 1)
  k_corr <- k - ((k - 1)^2) / (n - 1)
  denom <- min(k_corr - 1, r_corr - 1)

  if (!is.finite(denom) || denom <= 0) return(NA_real_)
  sqrt(phi2_corr / denom)
}

chisq_perm <- function(labels, clusters, B = B_PERM, seed = 1) {
  tab <- table(clusters, labels)
  if (nrow(tab) < 2 || ncol(tab) < 2) {
    return(c(Chi_square = NA_real_, Permutation_p = NA_real_))
  }

  obs <- as.numeric(suppressWarnings(chisq.test(tab, correct = FALSE)$statistic))
  set.seed(seed)
  null <- replicate(B, {
    tab0 <- table(clusters, sample(labels))
    as.numeric(suppressWarnings(chisq.test(tab0, correct = FALSE)$statistic))
  })

  c(
    Chi_square = obs,
    Permutation_p = (1 + sum(null >= obs)) / (B + 1)
  )
}

association_summary <- function(
  labels, clusters, feature_space, label_level, k,
  B = B_PERM, seed = 1
) {
  ok <- complete.cases(labels, clusters)
  labels <- labels[ok]
  clusters <- clusters[ok]

  if (length(unique(labels)) < 2 || length(unique(clusters)) < 2) {
    return(tibble(
      Feature_space = feature_space,
      Label_level = label_level,
      n = length(labels),
      k = k,
      ARI = NA_real_,
      NMI = NA_real_,
      Purity = NA_real_,
      Chi_square = NA_real_,
      Permutation_p = NA_real_,
      Bias_corrected_Cramers_V = NA_real_
    ))
  }

  ch <- chisq_perm(labels, clusters, B = B, seed = seed)

  tibble(
    Feature_space = feature_space,
    Label_level = label_level,
    n = length(labels),
    k = k,
    ARI = ARI(labels, clusters),
    NMI = NMI(labels, clusters),
    Purity = purity(labels, clusters),
    Chi_square = unname(ch["Chi_square"]),
    Permutation_p = unname(ch["Permutation_p"]),
    Bias_corrected_Cramers_V = bias_corrected_cramers_v(labels, clusters)
  )
}

permanova_dispersion <- function(
  X, labels, feature_space, label_level, permutations = B_PERM
) {
  ok <- complete.cases(labels)
  X2 <- X[ok, , drop = FALSE]
  labs <- droplevels(factor(labels[ok]))

  if (nrow(X2) < 4 || nlevels(labs) < 2) {
    return(tibble(
      Feature_space = feature_space,
      Label_level = label_level,
      n = nrow(X2),
      Pseudo_F = NA_real_,
      R2 = NA_real_,
      PERMANOVA_p = NA_real_,
      Dispersion_F = NA_real_,
      Dispersion_p = NA_real_
    ))
  }

  dd <- dist(X2)
  dat <- tibble(label = labs)

  set.seed(SEED)
  ad <- vegan::adonis2(dd ~ label, data = dat, permutations = permutations)
  bd <- vegan::betadisper(dd, labs)
  set.seed(SEED)
  bp <- vegan::permutest(bd, permutations = min(999, permutations))

  tibble(
    Feature_space = feature_space,
    Label_level = label_level,
    n = nrow(X2),
    Pseudo_F = ad$F[1],
    R2 = ad$R2[1],
    PERMANOVA_p = ad$`Pr(>F)`[1],
    Dispersion_F = bp$tab$F[1],
    Dispersion_p = bp$tab$`Pr(>F)`[1]
  )
}

cliffs_delta <- function(x, y) {
  x <- x[is.finite(x)]
  y <- y[is.finite(y)]
  if (length(x) == 0 || length(y) == 0) return(NA_real_)
  mean(outer(x, y, ">")) - mean(outer(x, y, "<"))
}

nearest_center <- function(Xnew, centers) {
  if (nrow(Xnew) == 0) return(integer(0))
  apply(Xnew, 1, function(z) {
    which.min(rowSums(sweep(centers, 2, z, "-")^2))
  })
}

# Group-specific concentration/data ellipse in a 2D display plane.
# This describes the distribution of observations, NOT uncertainty in the mean.
# Under a bivariate-normal reference model, the contour is
#   (x - mean)' S^{-1} (x - mean) = qchisq(level, df = 2),
# where S is the sample covariance matrix of the observations in that cluster.
ellipse_concentration <- function(x, y, level = CI_LEVEL, n_points = 200) {
  xy <- cbind(x, y)
  xy <- xy[complete.cases(xy), , drop = FALSE]
  if (nrow(xy) < 3) return(NULL)

  mu <- colMeans(xy)
  S <- cov(xy)

  if (any(!is.finite(S))) return(NULL)

  ev <- eigen(S, symmetric = TRUE)
  radii <- sqrt(qchisq(level, df = 2) * pmax(ev$values, 0))
  theta <- seq(0, 2 * pi, length.out = n_points)
  unit <- rbind(cos(theta), sin(theta))
  ell <- t(ev$vectors %*% diag(radii) %*% unit)

  tibble(x = ell[, 1] + mu[1], y = ell[, 2] + mu[2])
}

# 1D analogue of a concentration interval. This summarizes the spread of
# individual observations under a normal-reference interpretation; it is NOT a
# confidence interval for the mean and therefore does not divide SD by sqrt(n).
concentration_interval_1d <- function(x, level = CI_LEVEL) {
  x <- x[is.finite(x)]
  n <- length(x)
  if (n == 0) {
    return(tibble(n = 0, mean = NA_real_, lower = NA_real_, upper = NA_real_))
  }
  if (n == 1) {
    return(tibble(n = 1, mean = x[1], lower = NA_real_, upper = NA_real_))
  }

  m <- mean(x)
  s <- sd(x)
  crit <- qnorm((1 + level) / 2)
  tibble(n = n, mean = m, lower = m - crit * s, upper = m + crit * s)
}

partial_cor <- function(x, y, z) {
  ok <- complete.cases(x, y, z)
  x <- x[ok]; y <- y[ok]; z <- z[ok]
  n <- length(x)
  if (n < 4) return(c(r = NA_real_, p = NA_real_, n = n))

  rx <- resid(lm(x ~ z))
  ry <- resid(lm(y ~ z))
  r <- cor(rx, ry)

  if (!is.finite(r) || abs(r) >= 1) {
    p <- ifelse(abs(r) == 1, 0, NA_real_)
  } else {
    tval <- r * sqrt((n - 3) / (1 - r^2))
    p <- 2 * pt(-abs(tval), df = n - 3)
  }

  c(r = r, p = p, n = n)
}

safe_cor <- function(x, y) {
  ok <- complete.cases(x, y)
  if (sum(ok) < 3 || sd(x[ok]) == 0 || sd(y[ok]) == 0) {
    return(c(r = NA_real_, p = NA_real_, n = sum(ok)))
  }
  tst <- suppressWarnings(cor.test(x[ok], y[ok], method = "pearson"))
  c(r = unname(tst$estimate), p = tst$p.value, n = sum(ok))
}


write_csv_or_note <- function(x, path, note = "No rows for this output in this run") {
  if (is.null(x) || ncol(x) == 0) {
    readr::write_csv(tibble(Note = note), path)
  } else {
    readr::write_csv(x, path)
  }
}

# ------------------------------------------------------------------------------
# 6. Scalar C / Heip statistics on the known archaeological labels
# ------------------------------------------------------------------------------

write_scalar_label_stats <- function(fit_data, out_dir) {
  known <- fit_data %>% filter(!is.na(class4))

  broad_descriptives <- known %>%
    group_by(class4) %>%
    summarise(
      n = n(),
      Median_C = median(.data[[C_VAR]], na.rm = TRUE),
      Q1_C = quantile(.data[[C_VAR]], .25, na.rm = TRUE),
      Q3_C = quantile(.data[[C_VAR]], .75, na.rm = TRUE),
      Median_Heip = median(.data[[E_VAR]], na.rm = TRUE),
      Q1_Heip = quantile(.data[[E_VAR]], .25, na.rm = TRUE),
      Q3_Heip = quantile(.data[[E_VAR]], .75, na.rm = TRUE),
      .groups = "drop"
    )

  kw_broad <- map_dfr(c(C_VAR, E_VAR), function(v) {
    dat <- known %>% filter(is.finite(.data[[v]]))
    tst <- kruskal.test(dat[[v]] ~ dat$class4)
    tibble(
      Variable = v,
      Kruskal_H = unname(tst$statistic),
      df = unname(tst$parameter),
      p = tst$p.value
    )
  })

  classes <- c("Funerary", "Cannibalism", "Carnivore-related", "Geological transport")

  pairwise_broad <- map_dfr(c(C_VAR, E_VAR), function(v) {
    combn(classes, 2, simplify = FALSE) %>%
      map_dfr(function(pair) {
        x <- known %>% filter(class4 == pair[1]) %>% pull(all_of(v))
        y <- known %>% filter(class4 == pair[2]) %>% pull(all_of(v))
        x <- x[is.finite(x)]; y <- y[is.finite(y)]
        wt <- wilcox.test(x, y, exact = FALSE)
        tibble(
          Variable = v,
          Group1 = pair[1], Group2 = pair[2],
          n1 = length(x), n2 = length(y),
          Median1 = median(x), Median2 = median(y),
          Cliffs_delta = cliffs_delta(x, y),
          p_raw = wt$p.value
        )
      })
  }) %>%
    group_by(Variable) %>%
    mutate(p_BH = p.adjust(p_raw, method = "BH")) %>%
    ungroup()

  funerary <- known %>% filter(class4 == "Funerary")

  funerary_descriptives <- funerary %>%
    group_by(funerary_subtype_norm) %>%
    summarise(
      n = n(),
      Median_C = median(.data[[C_VAR]], na.rm = TRUE),
      Q1_C = quantile(.data[[C_VAR]], .25, na.rm = TRUE),
      Q3_C = quantile(.data[[C_VAR]], .75, na.rm = TRUE),
      Median_Heip = median(.data[[E_VAR]], na.rm = TRUE),
      Q1_Heip = quantile(.data[[E_VAR]], .25, na.rm = TRUE),
      Q3_Heip = quantile(.data[[E_VAR]], .75, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(n))

  common_fun_subtypes <- funerary_descriptives %>%
    filter(n >= 3) %>%
    pull(funerary_subtype_norm)

  fun_common <- funerary %>%
    filter(funerary_subtype_norm %in% common_fun_subtypes)

  kw_fun <- map_dfr(c(C_VAR, E_VAR), function(v) {
    if (n_distinct(fun_common$funerary_subtype_norm) < 2) {
      return(tibble(Variable = v, Kruskal_H = NA_real_, df = NA_real_, p = NA_real_))
    }
    dat <- fun_common %>% filter(is.finite(.data[[v]]))
    tst <- kruskal.test(dat[[v]] ~ dat$funerary_subtype_norm)
    tibble(
      Variable = v,
      Kruskal_H = unname(tst$statistic),
      df = unname(tst$parameter),
      p = tst$p.value
    )
  })

  pairwise_fun <- map_dfr(c(C_VAR, E_VAR), function(v) {
    groups <- sort(unique(fun_common$funerary_subtype_norm))
    if (length(groups) < 2) return(tibble())

    combn(groups, 2, simplify = FALSE) %>%
      map_dfr(function(pair) {
        x <- fun_common %>% filter(funerary_subtype_norm == pair[1]) %>% pull(all_of(v))
        y <- fun_common %>% filter(funerary_subtype_norm == pair[2]) %>% pull(all_of(v))
        x <- x[is.finite(x)]; y <- y[is.finite(y)]
        wt <- wilcox.test(x, y, exact = FALSE)
        tibble(
          Variable = v,
          Group1 = pair[1], Group2 = pair[2],
          n1 = length(x), n2 = length(y),
          Median1 = median(x), Median2 = median(y),
          Cliffs_delta = cliffs_delta(x, y),
          p_raw = wt$p.value
        )
      })
  })

  if (nrow(pairwise_fun) > 0) {
    pairwise_fun <- pairwise_fun %>%
      group_by(Variable) %>%
      mutate(p_BH = p.adjust(p_raw, method = "BH")) %>%
      ungroup()
  }

  write_csv(broad_descriptives, file.path(out_dir, "broad_context_C_Heip_descriptives.csv"))
  write_csv(kw_broad, file.path(out_dir, "broad_context_C_Heip_kruskal.csv"))
  write_csv(pairwise_broad, file.path(out_dir, "broad_context_C_Heip_pairwise_BH.csv"))
  write_csv(funerary_descriptives, file.path(out_dir, "funerary_subtype_descriptives.csv"))
  write_csv(kw_fun, file.path(out_dir, "funerary_subtype_C_Heip_kruskal_n_ge_3.csv"))
  write_csv(pairwise_fun, file.path(out_dir, "funerary_subtype_C_Heip_pairwise_BH_n_ge_3.csv"))
}

# ------------------------------------------------------------------------------
# 7. Main reusable analysis function
# ------------------------------------------------------------------------------

run_unsupervised <- function(
  run_label,
  fit_data,
  out_dir,
  projection_data = NULL,
  special_rows_are_in_fit = FALSE
) {
  message("\n============================================================")
  message(run_label)
  message("Fit rows: ", nrow(fit_data))
  if (!is.null(projection_data)) message("Projection rows: ", nrow(projection_data))
  message("Output: ", out_dir)
  message("============================================================\n")

  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  run_partition <- fit_data %>%
    mutate(
      Fit_category = case_when(
        !is.na(class4) ~ class4,
        special_type == "Unknown" ~ "Unknown",
        special_type == "Sepulchral" ~ "Sepulchral",
        TRUE ~ "Other"
      )
    ) %>%
    count(Fit_category, name = "n_rows")

  if (!is.null(projection_data) && nrow(projection_data) > 0) {
    projection_partition <- projection_data %>%
      count(special_type, name = "n_rows") %>%
      rename(Fit_category = special_type) %>%
      mutate(Fit_category = paste0("Projected: ", Fit_category))
    run_partition <- bind_rows(run_partition, projection_partition)
  }

  write_csv(run_partition, file.path(out_dir, "sample_partition.csv"))

  # Feature sets are filtered for informativeness separately within each run.
  feature_sets <- imap(BASE_FEATURE_SETS, function(vars, nm) {
    informative(fit_data, vars)
  })

  empty_spaces <- names(feature_sets)[lengths(feature_sets) == 0]
  if (length(empty_spaces) > 0) {
    stop(
      "No informative variables remain for feature space(s): ",
      paste(empty_spaces, collapse = ", ")
    )
  }

  feature_manifest <- imap_dfr(feature_sets, ~ tibble(Feature_space = .y, variable = .x))
  write_csv(feature_manifest, file.path(out_dir, "feature_manifest.csv"))

  diag_all <- list()
  assoc_all <- list()
  permanova_all <- list()
  profile_all <- list()
  corr_all <- list()
  fit_all <- list()
  projection_all <- list()
  special_fit_all <- list()
  named_panel_all <- list()
  binary_tabs <- list()
  class4_tabs <- list()
  nonfun_tabs <- list()
  fun_subtype_tabs <- list()
  fun_subtype_common_tabs <- list()

  for (space in names(feature_sets)) {
    message(run_label, " | ", space)

    vars <- feature_sets[[space]]
    prep <- make_preprocessor(fit_data, vars)
    X <- prep$X_train
    Xraw <- prep$X_train_raw
    p <- ncol(X)

    # Projection data, if this run has true withheld special rows.
    pdat <- apply_preprocessor(prep, projection_data)
    Xp <- pdat$scaled
    Xpraw <- pdat$raw

    # k candidates cannot exceed number of distinct fitted profiles.
    n_distinct_profiles <- nrow(unique(as.data.frame(X)))
    kmax <- min(8, nrow(X) - 1, n_distinct_profiles)
    if (kmax < 2) stop("Too few distinct profiles for k-means in: ", space)

    kvals <- 1:kmax

    inertia <- map_dbl(kvals, function(k) {
      set.seed(SEED)
      kmeans(X, centers = k, nstart = 100, iter.max = 300)$tot.withinss
    })

    silhouettes <- rep(NA_real_, length(kvals))
    for (i in seq_along(kvals)) {
      k <- kvals[i]
      if (k >= 2) {
        set.seed(SEED)
        km0 <- kmeans(X, centers = k, nstart = 100, iter.max = 300)
        silhouettes[i] <- mean(cluster::silhouette(km0$cluster, dist(X))[, 3])
      }
    }

    ks <- choose_k(kvals, inertia, silhouettes)
    chosen_k <- ks$chosen_k

    diag <- tibble(
      Feature_space = space,
      k = kvals,
      Inertia = inertia,
      Silhouette = silhouettes,
      Elbow_k = ks$elbow_k,
      Silhouette_best_k = ks$silhouette_k,
      Chosen_k = chosen_k,
      Rule = ks$rule
    )
    diag_all[[space]] <- diag

    # Colored elbow/silhouette plot.
    diag_plot <- diag %>%
      mutate(Relative_inertia = Inertia / first(Inertia)) %>%
      select(k, Relative_inertia, Silhouette) %>%
      pivot_longer(-k, names_to = "metric", values_to = "value")

    gp_k <- ggplot(diag_plot, aes(k, value, colour = metric, linetype = metric, shape = metric)) +
      geom_line(na.rm = TRUE, linewidth = .85) +
      geom_point(na.rm = TRUE, size = 2.6) +
      geom_vline(xintercept = chosen_k, linetype = 2, colour = "grey35") +
      scale_colour_manual(values = METRIC_COLOURS) +
      scale_x_continuous(breaks = kvals) +
      labs(
        x = "k",
        y = "Relative inertia / mean silhouette",
        title = paste0(space, ": elbow and silhouette"),
        subtitle = paste0("Chosen k = ", chosen_k, " (", ks$rule, ")"),
        colour = NULL, linetype = NULL, shape = NULL
      ) +
      theme_bw()

    ggsave(
      file.path(out_dir, paste0("k_", make.names(space), ".png")),
      gp_k, width = 8.5, height = 5.8, dpi = 300
    )

    # Final K-means.
    set.seed(SEED)
    km <- kmeans(X, centers = chosen_k, nstart = 300, iter.max = 500)
    cl_raw <- km$cluster

    # Order cluster labels by increasing median raw C across ALL fitted rows.
    cluster_map <- fit_data %>%
      mutate(Cluster_raw = cl_raw) %>%
      group_by(Cluster_raw) %>%
      summarise(
        Median_C_order = median(.data[[C_VAR]], na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(Median_C_order, Cluster_raw) %>%
      mutate(Cluster = row_number())

    relabel_cluster <- function(x) {
      cluster_map$Cluster[match(x, cluster_map$Cluster_raw)]
    }

    cl <- relabel_cluster(cl_raw)
    cl_factor <- factor(paste0("C", cl), levels = paste0("C", seq_len(chosen_k)))
    cluster_cols <- cluster_colour_values(cl_factor)

    dfit <- sqrt(rowSums((X - km$centers[cl_raw, , drop = FALSE])^2))

    # True projection in Run A only.
    if (!is.null(projection_data) && nrow(projection_data) > 0) {
      clp_raw <- nearest_center(Xp, km$centers)
      clp <- relabel_cluster(clp_raw)
      dproj <- sqrt(rowSums((Xp - km$centers[clp_raw, , drop = FALSE])^2))
    } else {
      clp_raw <- integer(0)
      clp <- integer(0)
      dproj <- numeric(0)
    }

    # PCA for display and axis interpretation.
    pc <- prcomp(X, center = FALSE, scale. = FALSE)
    Zf <- predict(pc, X)
    Zp <- if (nrow(Xp) > 0) predict(pc, Xp) else matrix(numeric(0), nrow = 0, ncol = ncol(Zf))
    pc1 <- Zf[, 1]

    allC <- safe_cor(pc1, fit_data[[C_VAR]])
    allE <- safe_cor(pc1, fit_data[[E_VAR]])
    allPartial <- partial_cor(pc1, fit_data[[E_VAR]], fit_data[[C_VAR]])

    known_idx <- !is.na(fit_data$class4)
    knownC <- safe_cor(pc1[known_idx], fit_data[[C_VAR]][known_idx])
    knownE <- safe_cor(pc1[known_idx], fit_data[[E_VAR]][known_idx])
    knownPartial <- partial_cor(
      pc1[known_idx],
      fit_data[[E_VAR]][known_idx],
      fit_data[[C_VAR]][known_idx]
    )

    corr_all[[space]] <- tibble(
      Feature_space = space,
      n_features = p,
      n_fit_all = nrow(fit_data),
      n_known = sum(known_idx),
      PC1_variance = summary(pc)$importance[2, 1],
      PC2_variance = if (p >= 2) summary(pc)$importance[2, 2] else NA_real_,
      r_PC1_C_fit_all = unname(allC["r"]),
      p_PC1_C_fit_all = unname(allC["p"]),
      r_PC1_Heip_fit_all = unname(allE["r"]),
      p_PC1_Heip_fit_all = unname(allE["p"]),
      partial_r_PC1_Heip_given_C_fit_all = unname(allPartial["r"]),
      partial_p_PC1_Heip_given_C_fit_all = unname(allPartial["p"]),
      r_PC1_C_known = unname(knownC["r"]),
      p_PC1_C_known = unname(knownC["p"]),
      r_PC1_Heip_known = unname(knownE["r"]),
      p_PC1_Heip_known = unname(knownE["p"]),
      partial_r_PC1_Heip_given_C_known = unname(knownPartial["r"]),
      partial_p_PC1_Heip_given_C_known = unname(knownPartial["p"])
    )

    # Cluster profiles: total fit + known composition + special counts.
    tmp <- fit_data %>%
      mutate(
        Cluster = cl,
        Cluster_name = cl_factor,
        Cluster_raw = cl_raw,
        Distance_to_centroid = dfit
      )

    prof <- tmp %>%
      group_by(Cluster, Cluster_name) %>%
      summarise(
        n_total = n(),
        n_known = sum(!is.na(class4)),
        n_unknown = sum(special_type == "Unknown", na.rm = TRUE),
        n_sepulchral = sum(special_type == "Sepulchral", na.rm = TRUE),
        F_n = sum(binary_label == "F", na.rm = TRUE),
        NF_n = sum(binary_label == "NF", na.rm = TRUE),
        F_percent_known = if_else(
          n_known > 0,
          100 * F_n / n_known,
          NA_real_
        ),
        Funerary_n = sum(class4 == "Funerary", na.rm = TRUE),
        Cannibalism_n = sum(class4 == "Cannibalism", na.rm = TRUE),
        Carnivore_n = sum(class4 == "Carnivore-related", na.rm = TRUE),
        Geological_transport_n = sum(class4 == "Geological transport", na.rm = TRUE),
        Median_C = median(.data[[C_VAR]], na.rm = TRUE),
        Median_Heip = median(.data[[E_VAR]], na.rm = TRUE),
        Median_distance = median(Distance_to_centroid),
        .groups = "drop"
      ) %>%
      mutate(Feature_space = space, .before = 1)

    profile_all[[space]] <- prof

    # Associations use ONLY the four known archaeological contexts.
    kcl <- cl[known_idx]
    kdata <- fit_data[known_idx, , drop = FALSE]
    kX <- X[known_idx, , drop = FALSE]

    assoc_all[[paste(space, "binary")]] <- association_summary(
      kdata$binary_label, kcl, space, "Funerary vs non-funerary", chosen_k,
      B = B_PERM, seed = 101
    )

    assoc_all[[paste(space, "four")]] <- association_summary(
      kdata$class4, kcl, space, "Broad four-context", chosen_k,
      B = B_PERM, seed = 102
    )

    nf <- kdata$class4 != "Funerary"
    assoc_all[[paste(space, "nonfun")]] <- association_summary(
      kdata$class4[nf], kcl[nf], space, "Within non-funerary: 3 processes", chosen_k,
      B = B_PERM, seed = 103
    )

    fm <- kdata$class4 == "Funerary"
    assoc_all[[paste(space, "fsub_all")]] <- association_summary(
      kdata$funerary_subtype_norm[fm], kcl[fm], space,
      "Within funerary: all subtypes", chosen_k,
      B = B_PERM, seed = 104
    )

    ftab <- table(kdata$funerary_subtype_norm[fm])
    common_fsub <- names(ftab[ftab >= 3])
    fm_common <- fm & kdata$funerary_subtype_norm %in% common_fsub

    assoc_all[[paste(space, "fsub_common")]] <- association_summary(
      kdata$funerary_subtype_norm[fm_common], kcl[fm_common], space,
      "Within funerary: subtypes n>=3", chosen_k,
      B = B_PERM, seed = 105
    )

    permanova_all[[paste(space, "binary")]] <- permanova_dispersion(
      kX, kdata$binary_label, space, "Funerary vs non-funerary", B_PERM
    )
    permanova_all[[paste(space, "four")]] <- permanova_dispersion(
      kX, kdata$class4, space, "Broad four-context", B_PERM
    )
    permanova_all[[paste(space, "nonfun")]] <- permanova_dispersion(
      kX[nf, , drop = FALSE], kdata$class4[nf], space,
      "Within non-funerary: 3 processes", B_PERM
    )
    if (sum(fm_common) >= 6) {
      permanova_all[[paste(space, "fsub_common")]] <- permanova_dispersion(
        kX[fm_common, , drop = FALSE],
        kdata$funerary_subtype_norm[fm_common],
        space, "Within funerary: subtypes n>=3", B_PERM
      )
    }

    # Known-only contingency tables.
    binary_tabs[[space]] <- as.data.frame.matrix(
      table(Cluster = kcl, Binary = kdata$binary_label)
    ) %>%
      rownames_to_column("Cluster") %>%
      mutate(Feature_space = space, .before = 1)

    class4_tabs[[space]] <- as.data.frame.matrix(
      table(Cluster = kcl, Context = kdata$class4)
    ) %>%
      rownames_to_column("Cluster") %>%
      mutate(Feature_space = space, .before = 1)

    nonfun_tabs[[space]] <- as.data.frame.matrix(
      table(Cluster = kcl[nf], Context = kdata$class4[nf])
    ) %>%
      rownames_to_column("Cluster") %>%
      mutate(Feature_space = space, .before = 1)

    fun_subtype_tabs[[space]] <- as.data.frame.matrix(
      table(Cluster = kcl[fm], Funerary_subtype = kdata$funerary_subtype_norm[fm])
    ) %>%
      rownames_to_column("Cluster") %>%
      mutate(Feature_space = space, .before = 1)

    fun_subtype_common_tabs[[space]] <- as.data.frame.matrix(
      table(
        Cluster = kcl[fm_common],
        Funerary_subtype = kdata$funerary_subtype_norm[fm_common]
      )
    ) %>%
      rownames_to_column("Cluster") %>%
      mutate(Feature_space = space, .before = 1)

    # Lookup: F percentage and dominant context among KNOWN rows in each cluster.
    profile_lookup <- prof %>%
      select(Cluster, Cluster_name, Cluster_F_percent = F_percent_known)

    dominant_lookup <- tibble(Cluster = integer(), Cluster_dominant_class4 = character())
    known_tmp <- tmp %>% filter(!is.na(class4))
    if (nrow(known_tmp) > 0) {
      dominant_lookup <- known_tmp %>%
        count(Cluster, class4, name = "n") %>%
        group_by(Cluster) %>%
        arrange(desc(n), class4) %>%
        slice(1) %>%
        ungroup() %>%
        transmute(Cluster, Cluster_dominant_class4 = class4)
    }

    fit_out <- fit_data %>%
      transmute(
        Feature_space = space,
        record_id, site_name, layer_name,
        taphonomic_context,
        special_type, named_panel,
        class4, binary_label,
        funerary_subtype = funerary_subtype_norm,
        Cluster = cl,
        Cluster_name = cl_factor,
        Cluster_raw = cl_raw,
        Distance_to_centroid = dfit,
        PC1 = Zf[, 1],
        PC2 = if (ncol(Zf) >= 2) Zf[, 2] else NA_real_
      ) %>%
      left_join(profile_lookup, by = c("Cluster", "Cluster_name")) %>%
      left_join(dominant_lookup, by = "Cluster")

    fit_out$Distance_percentile_within_cluster <- map2_dbl(
      fit_out$Cluster,
      fit_out$Distance_to_centroid,
      function(k, x) {
        100 * mean(
          fit_out$Distance_to_centroid[fit_out$Cluster == k] <= x
        )
      }
    )

    fit_all[[space]] <- fit_out
    named_panel_all[[space]] <- fit_out %>% filter(!is.na(named_panel))
    special_fit_all[[space]] <- fit_out %>% filter(special_type %in% c("Unknown", "Sepulchral"))

    # True projection output for Run A.
    if (!is.null(projection_data) && nrow(projection_data) > 0) {
      projection_out <- projection_data %>%
        transmute(
          Feature_space = space,
          record_id, site_name, layer_name,
          taphonomic_context,
          special_type,
          Cluster = clp,
          Cluster_name = factor(paste0("C", clp), levels = levels(cl_factor)),
          Cluster_raw = clp_raw,
          Distance_to_centroid = dproj,
          PC1 = Zp[, 1],
          PC2 = if (ncol(Zp) >= 2) Zp[, 2] else NA_real_
        ) %>%
        left_join(profile_lookup, by = c("Cluster", "Cluster_name")) %>%
        left_join(dominant_lookup, by = "Cluster")

      projection_out$Distance_percentile_vs_fit_cluster <- map2_dbl(
        projection_out$Cluster,
        projection_out$Distance_to_centroid,
        function(k, x) 100 * mean(dfit[cl == k] <= x)
      )

      projection_all[[space]] <- projection_out
    }

    # ------------------------------------------------------------------------
    # Colored visualization
    # ------------------------------------------------------------------------

    display_group <- ifelse(
      !is.na(fit_data$class4),
      fit_data$class4,
      fit_data$special_type
    )

    if (p == 1) {
      ref_plot <- tibble(
        x = Xraw[, 1],
        Cluster = cl_factor,
        Cluster_num = cl,
        Display_group = display_group,
        site_name = fit_data$site_name,
        named_panel = fit_data$named_panel,
        special_type = fit_data$special_type
      ) %>%
        mutate(y = Cluster_num)

      ci_df <- ref_plot %>%
        group_by(Cluster) %>%
        group_modify(~ concentration_interval_1d(.x$x, CI_LEVEL)) %>%
        ungroup() %>%
        mutate(
          Cluster_num = as.integer(factor(Cluster, levels = levels(ref_plot$Cluster))),
          y = Cluster_num
        )

      gp_cluster <- ggplot(ref_plot, aes(x, y)) +
        geom_jitter(
          aes(colour = Cluster, shape = Display_group),
          height = .08, width = 0, size = 2.8, alpha = .9
        ) +
        geom_segment(
          data = ci_df,
          aes(x = lower, xend = upper, y = y, yend = y, colour = Cluster),
          inherit.aes = FALSE, linewidth = 1.1
        ) +
        geom_point(
          data = ci_df,
          aes(x = mean, y = y, colour = Cluster),
          inherit.aes = FALSE, shape = 18, size = 3.5
        ) +
        scale_colour_manual(values = cluster_cols) +
        scale_shape_manual(values = DISPLAY_SHAPES, drop = FALSE) +
        scale_y_continuous(
          breaks = seq_len(chosen_k),
          labels = paste0("C", seq_len(chosen_k))
        ) +
        labs(
          x = vars[1], y = "K-means cluster",
          title = paste0(space, ": k-means solution, k=", chosen_k),
          subtitle = "Colored by cluster; 90% concentration intervals describe within-cluster spread",
          colour = "Cluster", shape = "Context"
        ) +
        theme_bw()

      # Special display (projected in A; included in fit in B).
      if (!is.null(projection_data) && nrow(projection_data) > 0) {
        special_plot <- tibble(
          x = Xpraw[, 1], y = clp,
          site_name = projection_data$site_name,
          special_type = projection_data$special_type
        )
        special_title <- paste0(space, ": Unknown + sepulchral projection")
        special_subtitle <- "Special rows were excluded from k-selection and fitting"
      } else {
        special_plot <- ref_plot %>%
          filter(special_type %in% c("Unknown", "Sepulchral"))
        special_title <- paste0(space, ": Unknown + sepulchral rows inside fitted solution")
        special_subtitle <- "Special rows contributed to scaling, k-selection and K-means"
      }

      gp_special <- ggplot() +
        geom_jitter(
          data = ref_plot,
          aes(x = x, y = y, fill = Cluster),
          shape = 21, colour = "grey55",
          height = .06, width = 0, alpha = .28, size = 2.3
        ) +
        geom_point(
          data = special_plot,
          aes(x = x, y = y, colour = special_type, shape = special_type),
          size = 3.3, stroke = 1
        ) +
        ggrepel::geom_text_repel(
          data = special_plot,
          aes(x = x, y = y, label = site_name, colour = special_type),
          size = 2.4, show.legend = FALSE
        ) +
        scale_fill_manual(values = cluster_cols) +
        scale_colour_manual(values = SPECIAL_COLOURS) +
        scale_shape_manual(values = SPECIAL_SHAPES) +
        scale_y_continuous(
          breaks = seq_len(chosen_k),
          labels = paste0("C", seq_len(chosen_k))
        ) +
        labs(
          x = vars[1], y = "K-means cluster",
          title = special_title, subtitle = special_subtitle,
          fill = "Cluster", colour = "Special context", shape = "Special context"
        ) +
        theme_bw()

      panel_plot <- ref_plot %>% filter(!is.na(named_panel))
      gp_panel <- ggplot() +
        geom_jitter(
          data = ref_plot,
          aes(x = x, y = y, fill = Cluster),
          shape = 21, colour = "grey55",
          height = .06, width = 0, alpha = .22, size = 2.2
        ) +
        geom_point(
          data = panel_plot,
          aes(x = x, y = y, colour = named_panel, shape = named_panel),
          size = 3.3, stroke = .9
        ) +
        ggrepel::geom_text_repel(
          data = panel_plot,
          aes(x = x, y = y, label = site_name, colour = named_panel),
          size = 2.3, show.legend = FALSE
        ) +
        scale_fill_manual(values = cluster_cols) +
        scale_colour_manual(values = PANEL_COLOURS) +
        scale_shape_manual(values = PANEL_SHAPES) +
        scale_y_continuous(
          breaks = seq_len(chosen_k),
          labels = paste0("C", seq_len(chosen_k))
        ) +
        labs(
          x = vars[1], y = "K-means cluster",
          title = paste0(space, ": historical/early named records"),
          subtitle = "These named records are included in the fit in both runs",
          fill = "Cluster", colour = "Panel", shape = "Panel"
        ) +
        theme_bw()

    } else {
      # C + Heip uses original axes; >2D uses PCA display only.
      if (p == 2 && identical(vars, c(C_VAR, E_VAR))) {
        ref_plot <- tibble(
          x = Xraw[, 1], y = Xraw[, 2],
          Cluster = cl_factor,
          Display_group = display_group,
          site_name = fit_data$site_name,
          named_panel = fit_data$named_panel,
          special_type = fit_data$special_type
        )

        if (nrow(Xpraw) > 0) {
          projected_coords <- tibble(
            x = Xpraw[, 1], y = Xpraw[, 2],
            site_name = projection_data$site_name,
            special_type = projection_data$special_type
          )
        } else {
          projected_coords <- tibble()
        }

        xl <- "Mean part abundance (C)"
        yl <- "Heip evenness"
        display_note <- "90% concentration ellipses: group-specific covariance / Mahalanobis contours"
      } else {
        ref_plot <- tibble(
          x = Zf[, 1], y = Zf[, 2],
          Cluster = cl_factor,
          Display_group = display_group,
          site_name = fit_data$site_name,
          named_panel = fit_data$named_panel,
          special_type = fit_data$special_type
        )

        if (nrow(Zp) > 0) {
          projected_coords <- tibble(
            x = Zp[, 1], y = Zp[, 2],
            site_name = projection_data$site_name,
            special_type = projection_data$special_type
          )
        } else {
          projected_coords <- tibble()
        }

        xl <- paste0("PC1 (", round(100 * summary(pc)$importance[2, 1], 1), "%)")
        yl <- paste0("PC2 (", round(100 * summary(pc)$importance[2, 2], 1), "%)")
        display_note <- "PCA display only; K-means used full standardized space; ellipses are 90% concentration regions"
      }

      ell <- map_dfr(levels(ref_plot$Cluster), function(z) {
        q <- ref_plot %>% filter(Cluster == z)
        e <- ellipse_concentration(q$x, q$y, level = CI_LEVEL)
        if (is.null(e)) return(tibble())
        mutate(e, Cluster = factor(z, levels = levels(ref_plot$Cluster)))
      })

      gp_cluster <- ggplot(ref_plot, aes(x, y)) +
        geom_point(
          aes(colour = Cluster, shape = Display_group),
          size = 2.8, alpha = .9
        ) +
        geom_path(
          data = ell,
          aes(x, y, colour = Cluster, group = Cluster),
          inherit.aes = FALSE, linewidth = .95
        ) +
        scale_colour_manual(values = cluster_cols) +
        scale_shape_manual(values = DISPLAY_SHAPES, drop = FALSE) +
        labs(
          x = xl, y = yl,
          title = paste0(space, ": k-means solution, k=", chosen_k),
          subtitle = display_note,
          colour = "Cluster", shape = "Context"
        ) +
        theme_bw()

      if (!is.null(projection_data) && nrow(projection_data) > 0) {
        special_plot <- projected_coords
        special_title <- paste0(space, ": Unknown + sepulchral projection")
        special_subtitle <- "Special rows were excluded from scaling, k-selection and K-means fitting"
      } else {
        special_plot <- ref_plot %>%
          filter(special_type %in% c("Unknown", "Sepulchral"))
        special_title <- paste0(space, ": Unknown + sepulchral rows inside fitted solution")
        special_subtitle <- "Special rows contributed to scaling, k-selection and K-means fitting"
      }

      gp_special <- ggplot() +
        geom_point(
          data = ref_plot,
          aes(x, y, fill = Cluster),
          shape = 21, colour = "grey65", alpha = .28, size = 2.3
        ) +
        geom_path(
          data = ell,
          aes(x, y, group = Cluster),
          colour = "grey55", linewidth = .8
        ) +
        geom_point(
          data = special_plot,
          aes(x, y, colour = special_type, shape = special_type),
          size = 3.4, stroke = 1
        ) +
        ggrepel::geom_text_repel(
          data = special_plot,
          aes(x, y, label = site_name, colour = special_type),
          size = 2.35, show.legend = FALSE, max.overlaps = Inf
        ) +
        scale_fill_manual(values = cluster_cols) +
        scale_colour_manual(values = SPECIAL_COLOURS) +
        scale_shape_manual(values = SPECIAL_SHAPES) +
        labs(
          x = xl, y = yl,
          title = special_title,
          subtitle = special_subtitle,
          fill = "Cluster", colour = "Special context", shape = "Special context"
        ) +
        theme_bw()

      panel_plot <- ref_plot %>% filter(!is.na(named_panel))
      gp_panel <- ggplot() +
        geom_point(
          data = ref_plot,
          aes(x, y, fill = Cluster),
          shape = 21, colour = "grey65", alpha = .22, size = 2.3
        ) +
        geom_path(
          data = ell,
          aes(x, y, group = Cluster),
          colour = "grey60", linewidth = .75
        ) +
        geom_point(
          data = panel_plot,
          aes(x, y, colour = named_panel, shape = named_panel),
          size = 3.4, stroke = .8
        ) +
        ggrepel::geom_text_repel(
          data = panel_plot,
          aes(x, y, label = site_name, colour = named_panel),
          size = 2.25, show.legend = FALSE, max.overlaps = Inf
        ) +
        scale_fill_manual(values = cluster_cols) +
        scale_colour_manual(values = PANEL_COLOURS) +
        scale_shape_manual(values = PANEL_SHAPES) +
        labs(
          x = xl, y = yl,
          title = paste0(space, ": historical/early named records"),
          subtitle = "These named records are included in the fit in both runs",
          fill = "Cluster", colour = "Panel", shape = "Panel"
        ) +
        theme_bw()
    }

    ggsave(
      file.path(out_dir, paste0("clusters_", make.names(space), ".png")),
      gp_cluster, width = 10.5, height = 7.4, dpi = 300
    )
    ggsave(
      file.path(out_dir, paste0("special_Unknown_Sepulchral_", make.names(space), ".png")),
      gp_special, width = 11.5, height = 7.8, dpi = 300
    )
    ggsave(
      file.path(out_dir, paste0("named_panels_", make.names(space), ".png")),
      gp_panel, width = 11.5, height = 7.8, dpi = 300
    )
  }

  # --------------------------------------------------------------------------
  # Consolidate and save this run
  # --------------------------------------------------------------------------

  diagnostics <- bind_rows(diag_all)
  associations <- bind_rows(assoc_all)
  permanova_results <- bind_rows(permanova_all)
  profiles <- bind_rows(profile_all)
  pca_correlations <- bind_rows(corr_all)
  fit_assignments <- bind_rows(fit_all)
  projection_assignments <- bind_rows(projection_all)
  special_in_fit_assignments <- bind_rows(special_fit_all)
  named_panel_assignments <- bind_rows(named_panel_all)

  binary_contingencies <- bind_rows(binary_tabs)
  fourclass_contingencies <- bind_rows(class4_tabs)
  nonfunerary_contingencies <- bind_rows(nonfun_tabs)
  funerary_subtype_contingencies <- bind_rows(fun_subtype_tabs)
  funerary_common_subtype_contingencies <- bind_rows(fun_subtype_common_tabs)

  k_summary <- diagnostics %>%
    group_by(Feature_space) %>%
    summarise(
      Elbow_k = first(Elbow_k),
      Silhouette_best_k = first(Silhouette_best_k),
      Chosen_k = first(Chosen_k),
      Rule = first(Rule),
      Max_silhouette = max(Silhouette, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    left_join(pca_correlations, by = "Feature_space")

  known_fit_assignments <- fit_assignments %>% filter(!is.na(class4))

  cluster_binary_percent <- known_fit_assignments %>%
    count(Feature_space, Cluster, Cluster_name, binary_label, name = "n") %>%
    group_by(Feature_space, Cluster, Cluster_name) %>%
    mutate(
      known_cluster_n = sum(n),
      percent_within_known_cluster = 100 * n / known_cluster_n
    ) %>%
    ungroup()

  cluster_class4_percent <- known_fit_assignments %>%
    count(Feature_space, Cluster, Cluster_name, class4, name = "n") %>%
    group_by(Feature_space, Cluster, Cluster_name) %>%
    mutate(
      known_cluster_n = sum(n),
      percent_within_known_cluster = 100 * n / known_cluster_n
    ) %>%
    ungroup()

  cluster_funerary_subtype_percent <- known_fit_assignments %>%
    filter(class4 == "Funerary") %>%
    count(Feature_space, Cluster, Cluster_name, funerary_subtype, name = "n") %>%
    group_by(Feature_space, Cluster, Cluster_name) %>%
    mutate(
      funerary_cluster_n = sum(n),
      percent_within_funerary_cluster = 100 * n / funerary_cluster_n
    ) %>%
    ungroup()

  cluster_special_counts <- fit_assignments %>%
    filter(special_type %in% c("Unknown", "Sepulchral")) %>%
    count(Feature_space, Cluster, Cluster_name, special_type, name = "n")

  # Consensus for true projections in Run A.
  if (nrow(projection_assignments) > 0) {
    projection_consensus <- projection_assignments %>%
      mutate(F_enriched = Cluster_F_percent >= 50) %>%
      group_by(record_id, site_name, special_type) %>%
      summarise(
        Feature_spaces = n_distinct(Feature_space),
        F_enriched_spaces = sum(F_enriched, na.rm = TRUE),
        Median_cluster_F_percent = median(Cluster_F_percent, na.rm = TRUE),
        Mean_cluster_F_percent = mean(Cluster_F_percent, na.rm = TRUE),
        Median_distance_percentile = median(Distance_percentile_vs_fit_cluster, na.rm = TRUE),
        Max_distance_percentile = max(Distance_percentile_vs_fit_cluster, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(special_type, desc(Median_cluster_F_percent), site_name)
  } else {
    projection_consensus <- tibble()
  }

  # Consensus for Unknown/Sepulchral rows that were IN the fit (Run B).
  if (nrow(special_in_fit_assignments) > 0) {
    special_fit_consensus <- special_in_fit_assignments %>%
      mutate(F_enriched = Cluster_F_percent >= 50) %>%
      group_by(record_id, site_name, special_type) %>%
      summarise(
        Feature_spaces = n_distinct(Feature_space),
        F_enriched_spaces = sum(F_enriched, na.rm = TRUE),
        Median_cluster_F_percent = median(Cluster_F_percent, na.rm = TRUE),
        Mean_cluster_F_percent = mean(Cluster_F_percent, na.rm = TRUE),
        Median_distance_percentile = median(Distance_percentile_within_cluster, na.rm = TRUE),
        Max_distance_percentile = max(Distance_percentile_within_cluster, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(special_type, desc(Median_cluster_F_percent), site_name)
  } else {
    special_fit_consensus <- tibble()
  }

  # Historical/early named records are in fit in BOTH runs.
  named_panel_consensus <- named_panel_assignments %>%
    mutate(
      F_enriched = Cluster_F_percent >= 50,
      Posthoc_binary_cluster = if_else(F_enriched, "F", "NF"),
      Posthoc_binary_match = Posthoc_binary_cluster == binary_label,
      Posthoc_class4_match = Cluster_dominant_class4 == class4
    ) %>%
    group_by(record_id, site_name, named_panel, class4, binary_label) %>%
    summarise(
      Feature_spaces = n_distinct(Feature_space),
      F_enriched_spaces = sum(F_enriched, na.rm = TRUE),
      Posthoc_binary_matches = sum(Posthoc_binary_match, na.rm = TRUE),
      Posthoc_class4_matches = sum(Posthoc_class4_match, na.rm = TRUE),
      Median_cluster_F_percent = median(Cluster_F_percent, na.rm = TRUE),
      Median_distance_percentile = median(Distance_percentile_within_cluster, na.rm = TRUE),
      Max_distance_percentile = max(Distance_percentile_within_cluster, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(named_panel, site_name, record_id)

  write_csv(diagnostics, file.path(out_dir, "k_diagnostics.csv"))
  write_csv(k_summary, file.path(out_dir, "k_summary.csv"))
  write_csv(associations, file.path(out_dir, "cluster_label_associations_known_labels_only.csv"))
  write_csv(permanova_results, file.path(out_dir, "permanova_dispersion_known_labels_only.csv"))
  write_csv(profiles, file.path(out_dir, "cluster_profiles.csv"))
  write_csv(pca_correlations, file.path(out_dir, "pca_correlations.csv"))
  write_csv(fit_assignments, file.path(out_dir, "fit_assignments.csv"))
  write_csv(cluster_binary_percent, file.path(out_dir, "cluster_binary_percent_known_only.csv"))
  write_csv(cluster_class4_percent, file.path(out_dir, "cluster_class4_percent_known_only.csv"))
  write_csv(cluster_funerary_subtype_percent, file.path(out_dir, "cluster_funerary_subtype_percent.csv"))
  write_csv_or_note(
    cluster_special_counts,
    file.path(out_dir, "cluster_Unknown_Sepulchral_counts_in_fit.csv"),
    "No Unknown/Sepulchral rows were included in this fit"
  )
  write_csv(binary_contingencies, file.path(out_dir, "binary_contingencies_known_only.csv"))
  write_csv(fourclass_contingencies, file.path(out_dir, "fourclass_contingencies_known_only.csv"))
  write_csv(nonfunerary_contingencies, file.path(out_dir, "nonfunerary_threeclass_contingencies.csv"))
  write_csv(funerary_subtype_contingencies, file.path(out_dir, "funerary_subtype_contingencies_all.csv"))
  write_csv(funerary_common_subtype_contingencies, file.path(out_dir, "funerary_subtype_contingencies_n_ge_3.csv"))
  write_csv_or_note(
    projection_assignments,
    file.path(out_dir, "special_projection_assignments.csv"),
    "This run has no withheld special-context projection because those rows were included in the fit"
  )
  write_csv_or_note(
    projection_consensus,
    file.path(out_dir, "special_projection_consensus.csv"),
    "This run has no withheld special-context projection because those rows were included in the fit"
  )
  write_csv_or_note(
    special_in_fit_assignments,
    file.path(out_dir, "Unknown_Sepulchral_assignments_inside_fit.csv"),
    "No Unknown/Sepulchral rows were included in this fit; see special_projection_assignments.csv instead"
  )
  write_csv_or_note(
    special_fit_consensus,
    file.path(out_dir, "Unknown_Sepulchral_consensus_inside_fit.csv"),
    "No Unknown/Sepulchral rows were included in this fit; see special_projection_consensus.csv instead"
  )
  write_csv(named_panel_assignments, file.path(out_dir, "named_historical_early_assignments.csv"))
  write_csv(named_panel_consensus, file.path(out_dir, "named_historical_early_consensus.csv"))

  write_scalar_label_stats(fit_data, out_dir)

  saveRDS(
    list(
      run_label = run_label,
      input_file = INPUT_FILE,
      feature_sets = feature_sets,
      fit_data = fit_data,
      projection_data = projection_data,
      k_summary = k_summary,
      diagnostics = diagnostics,
      profiles = profiles,
      fit_assignments = fit_assignments,
      projection_assignments = projection_assignments,
      special_in_fit_assignments = special_in_fit_assignments,
      named_panel_assignments = named_panel_assignments
    ),
    file.path(out_dir, "analysis_objects.rds")
  )

  writeLines(
    c(
      paste("Run completed:", Sys.time()),
      paste("Run label:", run_label),
      paste("Fit rows:", nrow(fit_data)),
      paste("Projection rows:", ifelse(is.null(projection_data), 0, nrow(projection_data))),
      paste("Output directory:", out_dir)
    ),
    file.path(out_dir, "RUN_FINISHED.txt")
  )

  invisible(list(
    k_summary = k_summary,
    profiles = profiles,
    associations = associations,
    fit_assignments = fit_assignments,
    projection_assignments = projection_assignments,
    special_in_fit_assignments = special_in_fit_assignments
  ))
}

# ------------------------------------------------------------------------------
# 8. RUN A
# Four known contexts define k and K-means; Unknown + Sepulchral projected later.
# ------------------------------------------------------------------------------

run_A <- run_unsupervised(
  run_label = "RUN A: known-reference K-means + later Unknown/Sepulchral projection",
  fit_data = run_A_fit,
  projection_data = run_A_projection,
  out_dir = RUN_A_OUT,
  special_rows_are_in_fit = FALSE
)

# ------------------------------------------------------------------------------
# 9. RUN B
# Known + Unknown + Sepulchral ALL define preprocessing, k and K-means.
# ------------------------------------------------------------------------------

run_B <- run_unsupervised(
  run_label = "RUN B: known + Unknown + Sepulchral included in k-selection and K-means",
  fit_data = run_B_fit,
  projection_data = NULL,
  out_dir = RUN_B_OUT,
  special_rows_are_in_fit = TRUE
)

# ------------------------------------------------------------------------------
# 10. Cross-run comparison of selected k
# ------------------------------------------------------------------------------

cross_run_k <- bind_rows(
  run_A$k_summary %>% mutate(Run = "A_reference_fit_projection", .before = 1),
  run_B$k_summary %>% mutate(Run = "B_all_contexts_in_fit", .before = 1)
)

write_csv(cross_run_k, file.path(ROOT_OUT, "COMPARE_selected_k_two_runs.csv"))

cross_run_profiles <- bind_rows(
  run_A$profiles %>% mutate(Run = "A_reference_fit_projection", .before = 1),
  run_B$profiles %>% mutate(Run = "B_all_contexts_in_fit", .before = 1)
)

write_csv(cross_run_profiles, file.path(ROOT_OUT, "COMPARE_cluster_profiles_two_runs.csv"))

cross_run_associations <- bind_rows(
  run_A$associations %>% mutate(Run = "A_reference_fit_projection", .before = 1),
  run_B$associations %>% mutate(Run = "B_all_contexts_in_fit", .before = 1)
)

write_csv(
  cross_run_associations,
  file.path(ROOT_OUT, "COMPARE_known_label_associations_two_runs.csv")
)

# Text guide to the two analyses.
writeLines(
  c(
    "TWO-RUN UNSUPERVISED ANALYSIS",
    "",
    "RUN A: run_A_reference_fit_projection",
    "  The four known archaeological contexts alone determine preprocessing, k and K-means.",
    "  Unknown/Unkown and Sepulchral Cave/Cuevas Sepulcrales are projected afterward.",
    "",
    "RUN B: run_B_all_contexts_in_kmeans_fit",
    "  Known + Unknown/Unkown + Sepulchral Cave/Cuevas Sepulcrales all determine preprocessing, k and K-means.",
    "  Label-association tests remain restricted to known archaeological labels.",
    "",
    "Historical/early named records are included in the fit in BOTH runs.",
    "Before either run, exact bilateral *_indet features are redistributed as evenly as possible to matching left/right features.",
    "For %MNAU, redistribution cannot push a side above 1.0; any unassignable remainder stays in *_indet and is audited.",
    "For ReMNAU, the indeterminate value is split 50:50 without an artificial 1.0 cap.",
    "Paired redistributed *_indet columns are then excluded from clustering to avoid double-counting.",
    "Precomputed C, Heip evenness and engineered variables are retained as supplied and are not recomputed after redistribution.",
    paste0("Sima de los Huesos PNAS excluded from Unknown analyses: ", EXCLUDE_SIMA_PNAS),
    "Plots use cluster colors and 90% group-specific concentration/data ellipses (or 1D concentration intervals).",
    "Concentration regions describe within-cluster dispersion and covariance; they are not confidence regions for centroids.",
    "Ellipse overlap/non-overlap is not used as a significance test; formal group inference is reported separately via permutation association tests and PERMANOVA with dispersion checks."
  ),
  file.path(ROOT_OUT, "README_TWO_RUNS.txt")
)

writeLines(
  c(
    "REPORTING NOTES FOR PCA / CLUSTER FIGURES",
    "",
    paste0("Ellipse probability level: ", 100 * CI_LEVEL, "%"),
    "Definition: group-specific concentration/data ellipse in the displayed 2D plane.",
    "Calculation: each cluster mean and sample covariance matrix S are used with",
    "  (t - mean)' S^{-1} (t - mean) <= qchisq(level, df = 2).",
    "The covariance matrix is NOT divided by n.",
    "Therefore the ellipse visualizes within-cluster dispersion/covariance, not precision of the estimated centroid.",
    "For 1D feature spaces, the horizontal interval is the analogous normal-reference concentration interval mean +/- z * SD.",
    "PCA is used for visualization/interpretation only when the clustering space has >2 dimensions; K-means uses the full standardized feature matrix.",
    "Axis labels report PC1/PC2 explained variance.",
    "Ellipse overlap or non-overlap is not interpreted as statistical significance.",
    "Formal group comparisons are reported separately using post-hoc cluster-label association tests and PERMANOVA with multivariate-dispersion checks.",
    "",
    "Suggested figure-caption wording:",
    paste0(
      "Points represent individual summed assemblage records. Ellipses represent group-specific ",
      100 * CI_LEVEL,
      "% concentration regions in the displayed score space, calculated from each K-means cluster's covariance matrix using the chi-square(2) Mahalanobis-distance contour. ",
      "Ellipses describe within-cluster dispersion and were not used as tests of between-group differences. For feature spaces with >2 dimensions, PCA is visualization only and K-means was fitted to the full standardized feature space."
    )
  ),
  file.path(ROOT_OUT, "REPORTING_NOTES_PCA_ELLIPSES.txt")
)

capture.output(sessionInfo(), file = file.path(ROOT_OUT, "sessionInfo.txt"))

writeLines(
  c(
    paste("Both runs finished:", Sys.time()),
    paste("Root output:", ROOT_OUT)
  ),
  file.path(ROOT_OUT, "RUN_FINISHED.txt")
)

message("\nBoth analyses finished successfully.")
message("Outputs are in: ", ROOT_OUT)
message("Run A: ", RUN_A_OUT)
message("Run B: ", RUN_B_OUT)
message("Indeterminate redistribution audit: ", file.path(ROOT_OUT, "indet_redistribution_audit.csv"))
