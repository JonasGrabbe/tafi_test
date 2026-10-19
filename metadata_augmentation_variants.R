# metadata_augmentation_variants.R
#
# Separate, task-aware metadata augmentation helpers.
#
# Expected companion files:
#   metadata_core.R
#   augment_metadata_combinations.R

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
  library(tibble)
})

source("metadata_core.R")
source("augment_metadata_combinations.R")


# ------------------------------------------------------------------
# Fix/override: preserve the target class on every augmented row.
# The original augmentation factory padded the target column with NA
# after summarising. This wrapper explicitly restores the class label.
# ------------------------------------------------------------------
make_augment_fun <- function(combos,
                             feature_cols,
                             target_col,
                             integer_cols = character(0),
                             required_cols = character(0),
                             min_group_size = 2L) {
  function(x) {
    class_levels <- unique(x[[target_col]])
    class_levels <- class_levels[!is.na(class_levels)]

    per_class <- purrr::map(class_levels, function(lvl) {
      df_class <- dplyr::filter(x, .data[[target_col]] == lvl)

      out <- build_augmented_dataset(
        df = df_class,
        combos = combos,
        feature_cols = feature_cols,
        integer_cols = integer_cols,
        required_cols = required_cols,
        min_group_size = min_group_size
      )

      out[[target_col]] <- lvl
      out
    })

    dplyr::bind_rows(per_class) |>
      dplyr::select(-.aug_id)
  }
}

augmentation_buckets_for_task <- function(
    task_target = "taphonomic_context",
    variant = c("conservative", "context_rich", "sensitivity_recovery")) {

  variant <- match.arg(variant)

  # IMPORTANT:
  # For taphonomic_context prediction, never use funerary_context,
  # funerary_subtype, taphonomic_detail, or taphonomic_context itself as
  # augmentation metadata. They encode the target or a nested target label.

  base <- list(
    temporal = c(
      "geological_period", "cultural_period", "culture_period_2",
      "start_date_cal_bp", "end_date_cal_bp", "mis_stage"
    ),
    spatial = c("region", "country"),

    # One bucket: a combination can use either broad environment OR detailed
    # environment, but never karstic_system + open_air_site as independent fields.
    environment = c(
      "site_environment",
      "site_environment_detail"
    ),

    biological = c("age_category", "gender"),
    taxonomy = c("hominin_species")
  )

  if (variant == "conservative") {
    return(base)
  }

  if (variant == "context_rich") {
    base$recovery <- c("degree_of_excavation", "discovery_context")
    return(base)
  }

  if (variant == "sensitivity_recovery") {
    return(list(
      environment = c("site_environment", "site_environment_detail"),
      recovery = c("degree_of_excavation", "discovery_context")
    ))
  }
}

prepare_augmentation_input <- function(tb,
                                       task_target = "taphonomic_context",
                                       verbose = TRUE,
                                       strict = FALSE) {
  prepare_project_metadata(tb, verbose = verbose, strict = strict)
}

make_task_augmentation <- function(
    tb,
    feature_cols,
    target_col = "taphonomic_context",
    variant = c("conservative", "context_rich", "sensitivity_recovery"),
    min_group_size = 2L,
    min_buckets = 1L,
    max_buckets = 3L) {

  variant <- match.arg(variant)

  tb_clean <- prepare_augmentation_input(
    tb,
    task_target = target_col,
    verbose = FALSE
  )

  buckets_task <- augmentation_buckets_for_task(
    task_target = target_col,
    variant = variant
  )

  # Remove metadata fields absent from this dataset before generating combos.
  buckets_task <- purrr::map(
    buckets_task,
    ~ intersect(.x, names(tb_clean))
  )
  buckets_task <- buckets_task[lengths(buckets_task) > 0]

  combos <- generate_combos(
    buckets_task,
    min_buckets = min_buckets,
    max_buckets = min(max_buckets, length(buckets_task))
  )

  augment_fun <- make_augment_fun(
    combos = combos,
    feature_cols = feature_cols,
    target_col = target_col,
    integer_cols = intersect("mni", names(tb_clean)),
    required_cols = intersect("mni", names(tb_clean)),
    min_group_size = min_group_size
  )

  list(
    data = tb_clean,
    buckets = buckets_task,
    combos = combos,
    augment_fun = augment_fun,
    variant = variant,
    target_col = target_col
  )
}

run_augmentation_variant <- function(
    tb,
    feature_cols,
    target_col = "taphonomic_context",
    variant = c("conservative", "context_rich", "sensitivity_recovery"),
    min_group_size = 2L,
    min_buckets = 1L,
    max_buckets = 3L) {

  spec <- make_task_augmentation(
    tb = tb,
    feature_cols = feature_cols,
    target_col = target_col,
    variant = variant,
    min_group_size = min_group_size,
    min_buckets = min_buckets,
    max_buckets = max_buckets
  )

  augmented <- spec$augment_fun(spec$data)

  summary <- tibble::tibble(
    variant = spec$variant,
    n_original = nrow(spec$data),
    n_augmented_total = nrow(augmented),
    n_synthetic = nrow(augmented) - nrow(spec$data),
    n_metadata_combinations = length(spec$combos),
    min_group_size = min_group_size,
    min_buckets = min_buckets,
    max_buckets = max_buckets
  )

  list(
    augmented = augmented,
    summary = summary,
    buckets = spec$buckets,
    combos = spec$combos,
    data_clean = spec$data
  )
}

compare_augmentation_variants <- function(
    tb,
    feature_cols,
    target_col = "taphonomic_context",
    min_group_sizes = c(2L, 3L, 5L),
    variants = c("conservative", "context_rich"),
    max_buckets_values = c(1L, 2L, 3L)) {

  grid <- tidyr::crossing(
    variant = variants,
    min_group_size = min_group_sizes,
    max_buckets = max_buckets_values
  )

  results <- purrr::pmap(
    grid,
    function(variant, min_group_size, max_buckets) {
      run_augmentation_variant(
        tb = tb,
        feature_cols = feature_cols,
        target_col = target_col,
        variant = variant,
        min_group_size = min_group_size,
        min_buckets = 1L,
        max_buckets = max_buckets
      )
    }
  )

  summary <- dplyr::bind_rows(purrr::map(results, "summary"))

  list(
    summary = summary,
    results = results
  )
}
