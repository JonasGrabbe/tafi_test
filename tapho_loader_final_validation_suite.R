# ============================================================
# TAPHO.LOADER FINAL VALIDATION SUITE
# ============================================================
#
# Purpose
#   1) Run a broad fixed regression suite across tapho.loader()
#      arguments and known historical failure cases.
#   2) Run reproducible random anatomical-level stress tests.
#   3) Continue after failures and write detailed diagnostics.
#
# This script DOES NOT modify tapho.loader source files or hspa.xlsx.
#
# Recommended workflow
#   Development check:
#       N_RANDOM <- 5
#
#   Final validation:
#       N_RANDOM <- 100
#
# Test 29 ("exclude everything") remains defined but is skipped by
# default because it intentionally creates an empty skeletal result.
# ============================================================


# ------------------------------------------------------------
# 0. USER SETTINGS
# ------------------------------------------------------------

LOADER_FILE <- "tapho_loader_new.R"
EXCEL_PATH  <- "hspa.xlsx"

RUN_FIXED_TESTS   <- TRUE
RUN_RANDOM_STRESS <- TRUE

# Start with 5. If clean, change to 100 for final validation.
N_RANDOM   <- 5
MASTER_SEED <- 123

# All four indeterminate-data modes used by the original random suite.
RANDOM_MODES <- c(
  "indet_TRUE",
  "FALSE_delete",
  "FALSE_up",
  "FALSE_dist"
)

# NULL = run all fixed tests except SKIP_TESTS.
# Or provide specific names, e.g.
# TARGET_TESTS <- c("08_indet_FALSE_up", "09_indet_FALSE_dist")
TARGET_TESTS <- NULL

# Kept in the suite for documentation, but not run by default.
SKIP_TESTS <- c("29_exclude_everything")

# Metadata warnings are currently known and are NOT treated as failures.
# To avoid gigantic CSV files, store only a short warning sample.
MAX_WARNING_SAMPLE <- 10L

# Keeping every successful tapho_db object makes the RDS large.
# FALSE is recommended for the 100-vector validation.
KEEP_SUCCESSFUL_DB <- FALSE


# ------------------------------------------------------------
# 1. LOAD CODE
# ------------------------------------------------------------

if (!file.exists(LOADER_FILE)) {
  stop(
    "Cannot find loader file: ", LOADER_FILE,
    "\nCurrent working directory: ", getwd(),
    "\nUse setwd(...) or change LOADER_FILE."
  )
}

if (!file.exists(EXCEL_PATH)) {
  stop(
    "Cannot find Excel file: ", EXCEL_PATH,
    "\nCurrent working directory: ", getwd(),
    "\nUse setwd(...) or change EXCEL_PATH."
  )
}

source(LOADER_FILE)

if (!exists("tapho.loader", mode = "function")) {
  stop(
    "tapho.loader() was not created after sourcing ", LOADER_FILE,
    ". Check that the active function is named tapho.loader."
  )
}


# ------------------------------------------------------------
# 2. STANDARD / VALID ANATOMICAL LEVELS
# ------------------------------------------------------------
#
# Order:
# cranium, teeth, hyoid, vertebrae, thorax, shoulder,
# arms, hands, pelvic, legs, foot
#
# Maximum valid levels:
#     5,      5,    1,         3,      4,        3,
#     3,     5,      4,    3,    5
# ------------------------------------------------------------

SECTION_NAMES <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax",
  "shoulder", "arms", "hands", "pelvic", "legs", "foot"
)

SECTION_MAX_LEVEL <- c(5, 5, 1, 3, 4, 3, 3, 5, 4, 3, 5)

LEVEL_MIN <- c(1,1,1,1,1,1,1,1,1,1,1)
LEVEL_MID <- c(3,3,1,2,2,2,2,3,2,2,3)
LEVEL_MAX <- SECTION_MAX_LEVEL

# Previously failing foot / metatarsal case.
LEVEL_FOOT_TEST <- c(4,1,1,2,3,2,2,2,2,1,4)

# Thorax-specific test vectors.
LEVEL_RIB3 <- c(1,1,1,1,3,1,1,1,1,1,1)
LEVEL_RIB4 <- c(1,1,1,1,4,1,1,1,1,1,1)


# ------------------------------------------------------------
# 3. SELF-CONTAINED RANDOM LEVEL GENERATOR
# ------------------------------------------------------------

generate_random_vectors <- function(n, seed = MASTER_SEED) {

  n <- as.integer(n)

  if (is.na(n) || n < 1L) {
    return(list())
  }

  set.seed(seed)

  out  <- vector("list", n)
  seen <- character(0)
  i <- 1L

  while (i <= n) {

    lvl <- vapply(
      SECTION_MAX_LEVEL,
      function(mx) sample.int(mx, size = 1L),
      integer(1)
    )

    key <- paste(lvl, collapse = ",")

    if (!key %in% seen) {
      out[[i]] <- lvl
      seen <- c(seen, key)
      i <- i + 1L
    }
  }

  out
}


# ------------------------------------------------------------
# 4. ERROR CLASSIFIER
# ------------------------------------------------------------
#
# Diagnostic guidance only. The captured error call and call stack
# are also written to the report / failure log.
# ------------------------------------------------------------

classify_error <- function(msg) {

  if (is.na(msg) || !nzchar(msg)) {
    return(list(
      bug = NA_character_,
      file = NA_character_,
      location = NA_character_,
      suggestion = NA_character_
    ))
  }

  x <- tolower(msg)

  if (grepl("rib destination already exceeds anatomical capacity", x, fixed = TRUE)) {
    return(list(
      bug = "RIB_EXISTING_OVER_CAPACITY",
      file = "indet.R / input data",
      location = "distribute_fragments()",
      suggestion = paste(
        "Inspect the reported rib element, existing count, maximum and MNI.",
        "Determine whether the input record or hierarchy maximum is wrong."
      )
    ))
  }

  if (grepl("not enough rib capacity to distribute fragments", x, fixed = TRUE)) {
    return(list(
      bug = "RIB_FRAGMENT_CAPACITY",
      file = "indet.R",
      location = "distribute_fragments()",
      suggestion = paste(
        "Inspect siblings, existing_counts, max_counts and whole_count.",
        "Check whether rib representations overlap at this hierarchy level."
      )
    ))
  }

  if (grepl("no valid destinations found for rib fragments", x, fixed = TRUE)) {
    return(list(
      bug = "RIB_FRAGMENT_NO_DESTINATION",
      file = "indet.R + hierarchy metadata",
      location = "distribute_fragments()/get_siblings_excluding()",
      suggestion = "Inspect the thorax mapping at the reported current_level."
    ))
  }

  if (grepl("cannot distribute surplus", x, fixed = TRUE)) {
    return(list(
      bug = "COLLAPSE_DOWN_SURPLUS",
      file = "tapho_loader_new.R / collapse_down_step.R",
      location = "collapse_down_step()",
      suggestion = paste(
        "Inspect parent_count, existing child counts, max_counts and MNI.",
        "Confirm the raw record does not exceed anatomical capacity."
      )
    ))
  }

  if (grepl("not enough open slots", x, fixed = TRUE)) {
    return(list(
      bug = "DISTRIBUTION_CAPACITY",
      file = "tapho_loader_new.R / indet.R",
      location = "distribute_surplus() or indeterminate distribution",
      suggestion = paste(
        "Inspect counts, max_counts, MNI and sibling selection.",
        "Check for a raw-data overcapacity or an overlapping hierarchy representation."
      )
    ))
  }

  if (grepl("no parent found for rib_fragments", x, fixed = TRUE)) {
    return(list(
      bug = "RIB_FRAGMENT_PARENT_MAPPING",
      file = "indet.R + meta_indet_TRUE.R",
      location = "collapse_fragments_up()/get_indet_parent()",
      suggestion = "Check thorax hierarchy mapping for rib_fragments at the detected level."
    ))
  }

  if (grepl("no parent found for", x, fixed = TRUE)) {
    return(list(
      bug = "INDET_PARENT_MAPPING",
      file = "indet.R + hierarchy metadata",
      location = "get_indet_parent()",
      suggestion = "Check that the reported element exists as a child in the expected mapping."
    ))
  }

  if (grepl("parent not found in mapping", x, fixed = TRUE)) {
    return(list(
      bug = "PARENT_NOT_IN_MAPPING",
      file = "indet.R + hierarchy metadata",
      location = "get_indet_siblings()/get_siblings_excluding()",
      suggestion = "Check mapping names and space/dot normalization."
    ))
  }

  if (grepl("missing mapping:", x, fixed = TRUE)) {
    return(list(
      bug = "MISSING_HIERARCHY_MAPPING",
      file = "meta_indet_TRUE.R / meta_indet_FALSE.R",
      location = "category_hierarchy",
      suggestion = "Add or correct the reported section_level_to_level mapping."
    ))
  }

  if (grepl("must contain exactly 11", x, fixed = TRUE) ||
      grepl("numeric vector of length 11", x, fixed = TRUE)) {
    return(list(
      bug = "INVALID_LEVEL_VECTOR",
      file = "test script / tapho_loader_new.R",
      location = "level argument",
      suggestion = "Provide one numeric vector with exactly 11 anatomical section levels."
    ))
  }

  if (grepl("subscript out of bounds", x, fixed = TRUE)) {
    return(list(
      bug = "INDEX_OR_HIERARCHY_SHAPE",
      file = "inspect captured stack",
      location = "hierarchy lookup or list-column extraction",
      suggestion = "Inspect the reported section/level and captured call stack."
    ))
  }

  if (grepl("replacement has", x, fixed = TRUE) ||
      grepl("arguments imply differing number of rows", x, fixed = TRUE) ||
      grepl("can't recycle", x, fixed = TRUE)) {
    return(list(
      bug = "OUTPUT_LENGTH_MISMATCH",
      file = "tapho_loader_new.R / downstream feature assembly",
      location = "alignment or final list-column assembly",
      suggestion = "Compare element/count/derived-feature lengths in the captured call stack."
    ))
  }

  if (grepl("object 'meta' not found", x, fixed = TRUE) ||
      grepl('object "meta" not found', x, fixed = TRUE)) {
    return(list(
      bug = "META_NOT_RETURNED",
      file = "meta_set.R + tapho_loader_new.R",
      location = "metadata setup",
      suggestion = "Inspect meta_set() return value and tapho.loader() metadata initialization."
    ))
  }

  list(
    bug = "UNCLASSIFIED",
    file = "inspect captured error / call stack",
    location = "unknown",
    suggestion = "Use error_call and call_stack from the diagnostic report."
  )
}


# ------------------------------------------------------------
# 5. SAFE TEST RUNNER WITH ERROR CALL / STACK CAPTURE
# ------------------------------------------------------------

run_one_test <- function(
  test_name,
  description,
  args,
  seed = MASTER_SEED,
  test_group = "fixed",
  mode = NA_character_
) {

  warnings_here <- character(0)
  start_time <- Sys.time()
  set.seed(seed)

  result <- withCallingHandlers(

    tryCatch({

      db <- do.call(
        tapho.loader,
        c(list(data = EXCEL_PATH), args)
      )

      list(
        success = TRUE,
        error = NA_character_,
        error_call = NA_character_,
        call_stack = NA_character_,
        db = if (KEEP_SUCCESSFUL_DB) db else NULL
      )

    }, error = function(e) {

      calls <- sys.calls()

      stack_txt <- paste(
        vapply(
          calls,
          function(z) paste(deparse(z, width.cutoff = 500L), collapse = " "),
          character(1)
        ),
        collapse = "\n"
      )

      call_txt <- if (is.null(conditionCall(e))) {
        NA_character_
      } else {
        paste(deparse(conditionCall(e), width.cutoff = 500L), collapse = " ")
      }

      list(
        success = FALSE,
        error = conditionMessage(e),
        error_call = call_txt,
        call_stack = stack_txt,
        db = NULL
      )
    }),

    warning = function(w) {
      warnings_here <<- c(warnings_here, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )

  elapsed <- as.numeric(
    difftime(Sys.time(), start_time, units = "secs")
  )

  error_info <- classify_error(result$error)

  level_value <- args$level

  if (is.null(level_value)) {
    level_txt <- "NULL"
  } else if (is.list(level_value)) {
    level_txt <- paste("LIST:", paste(unlist(level_value), collapse = ","))
  } else {
    level_txt <- paste(level_value, collapse = ",")
  }

  warning_unique <- unique(warnings_here)

  warning_sample <- if (length(warning_unique) == 0L) {
    ""
  } else {
    paste(
      utils::head(warning_unique, MAX_WARNING_SAMPLE),
      collapse = " | "
    )
  }

  cat(sprintf(
    "\n[%s] %s | %.2f sec\n",
    if (result$success) "PASS" else "FAIL",
    test_name,
    elapsed
  ))

  if (!result$success) {
    cat("  ERROR: ", result$error, "\n", sep = "")
    cat("  BUG:   ", error_info$bug, "\n", sep = "")
    cat("  FILE:  ", error_info$file, "\n", sep = "")
    cat("  WHERE: ", error_info$location, "\n", sep = "")

    if (!is.na(result$error_call) && nzchar(result$error_call)) {
      cat("  CALL:  ", result$error_call, "\n", sep = "")
    }
  }

  if (length(warnings_here) > 0L) {
    cat("  WARNINGS: ", length(warnings_here), "\n", sep = "")
  }

  list(
    test_name = test_name,
    test_group = test_group,
    mode = mode,
    description = description,
    args = args,
    seed = seed,
    level = level_txt,
    success = result$success,
    warning_count = length(warnings_here),
    warning_unique_count = length(warning_unique),
    warning_sample = warning_sample,
    error = result$error,
    error_call = result$error_call,
    call_stack = result$call_stack,
    likely_bug = error_info$bug,
    likely_file = error_info$file,
    likely_location = error_info$location,
    suggestion = error_info$suggestion,
    elapsed_seconds = elapsed,
    db = result$db
  )
}


# ------------------------------------------------------------
# 6. FIXED REGRESSION / EDGE TESTS
# ------------------------------------------------------------

tests <- list(

  list(
    name = "01_baseline_min_indet_TRUE",
    description = "Minimum anatomical resolution; retain indeterminate observations.",
    args = list(sum = FALSE, level = LEVEL_MIN, indet = TRUE)
  ),

  list(
    name = "02_baseline_mid_indet_TRUE",
    description = "Middle anatomical resolution; retain indeterminate observations.",
    args = list(sum = FALSE, level = LEVEL_MID, indet = TRUE)
  ),

  list(
    name = "03_extreme_max_indet_TRUE",
    description = "Maximum anatomical detail.",
    args = list(sum = FALSE, level = LEVEL_MAX, indet = TRUE)
  ),

  list(
    name = "04_auto_level_min",
    description = "Automatic level calculation using minimum.",
    args = list(sum = FALSE, level = NULL, calc_level = "min", indet = TRUE)
  ),

  list(
    name = "05_auto_level_max",
    description = "Automatic level calculation using maximum.",
    args = list(sum = FALSE, level = NULL, calc_level = "max", indet = TRUE)
  ),

  list(
    name = "06_auto_level_mode",
    description = "Automatic level calculation using mode.",
    args = list(sum = FALSE, level = NULL, calc_level = "mode", indet = TRUE)
  ),

  list(
    name = "07_indet_FALSE_delete",
    description = "Resolve indeterminate data by deletion.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = FALSE, indet_method = "delet"
    )
  ),

  list(
    name = "08_indet_FALSE_up",
    description = "Resolve indeterminate data by collapsing upward.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = FALSE, indet_method = "up"
    )
  ),

  list(
    name = "09_indet_FALSE_dist",
    description = "Resolve indeterminate data by stochastic distribution.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = FALSE, indet_method = "dist"
    )
  ),

  list(
    name = "10_regression_foot_metatarsal",
    description = "Previously failing foot/metatarsal capacity case.",
    args = list(
      sum = FALSE, level = LEVEL_FOOT_TEST,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist"
    )
  ),

  list(
    name = "11_ribs_level3_indet_TRUE",
    description = "Thorax Level 3 retaining indeterminate/fragment categories.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct", indet = TRUE
    )
  ),

  list(
    name = "12_ribs_level3_up",
    description = "Thorax Level 3; resolve rib fragments/indeterminate upward.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct",
      indet = FALSE, indet_method = "up",
      fragments_per_bone = 3
    )
  ),

  list(
    name = "13_ribs_level3_dist",
    description = "Thorax Level 3; stochastic rib fragment/indeterminate distribution.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist",
      fragments_per_bone = 3
    )
  ),

  list(
    name = "14_ribs_level4_dist",
    description = "Maximum thorax detail with stochastic distribution.",
    args = list(
      sum = FALSE, level = LEVEL_RIB4,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist",
      fragments_per_bone = 3
    )
  ),

  list(
    name = "15_fragments_per_bone_1",
    description = "Fragment conversion edge: 1 fragment per bone.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist",
      fragments_per_bone = 1
    )
  ),

  list(
    name = "16_fragments_per_bone_3",
    description = "Fragment conversion normal test: 3 fragments per bone.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist",
      fragments_per_bone = 3
    )
  ),

  list(
    name = "17_fragments_per_bone_100",
    description = "Fragment conversion extreme: 100 fragments per bone.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3,
      recalc_method = "direct",
      indet = FALSE, indet_method = "dist",
      fragments_per_bone = 100
    )
  ),

  list(
    name = "18_recalc_direct",
    description = "Grouped data recalculated directly to requested levels.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE, indet_method = "delet"
    )
  ),

  list(
    name = "19_recalc_min",
    description = "Grouped data recalculated to minimum common level.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "min",
      indet = FALSE, indet_method = "delet"
    )
  ),

  list(
    name = "20_recalc_filter",
    description = "Grouped data filtered/recalculated against requested levels.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "filter",
      indet = FALSE, indet_method = "delet"
    )
  ),

  list(
    name = "21_sum_FALSE",
    description = "Do not aggregate input records.",
    args = list(
      sum = FALSE, level = LEVEL_MID, indet = TRUE
    )
  ),

  list(
    name = "22_sum_TRUE",
    description = "Aggregate using default sum=TRUE behavior.",
    args = list(
      sum = TRUE, level = LEVEL_MID, indet = TRUE
    )
  ),

  list(
    name = "23_group_cultural_period",
    description = "Aggregate with cultural_period.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period")
    )
  ),

  list(
    name = "24_group_multi",
    description = "Aggregate with multiple metadata fields.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period", "mis_stage", "gender")
    )
  ),

  list(
    name = "25_select_gender_indet",
    description = "Selection/filter branch using gender = Indet.",
    args = list(
      sum = TRUE, level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period", "mis_stage", "gender"),
      select = c("gender" = "Indet")
    )
  ),

  list(
    name = "26_exclude_default_teeth",
    description = "Explicit default teeth exclusion.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = TRUE,
      exclude_sections = c("teeth")
    )
  ),

  list(
    name = "27_exclude_none",
    description = "Retain all skeletal sections including teeth.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = TRUE,
      exclude_sections = character(0)
    )
  ),

  list(
    name = "28_exclude_many",
    description = "Remove several major skeletal sections.",
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = TRUE,
      exclude_sections = c(
        "teeth", "arms", "legs",
        "cranium", "shoulder", "hands"
      )
    )
  ),

  # Intentionally retained but skipped by default.
  list(
    name = "29_exclude_everything",
    description = paste(
      "Extreme empty-output test.",
      "All skeletal sections are excluded."
    ),
    args = list(
      sum = FALSE, level = LEVEL_MID,
      indet = TRUE,
      exclude_sections = c(
        "cranium", "teeth", "hyoid", "vertebrae",
        "thorax", "shoulder", "arms", "hands",
        "pelvic", "legs", "foot"
      )
    )
  ),

  # ---- Additional coverage added after debugging ----

  list(
    name = "30_unique_level_FALSE",
    description = "Explicitly exercise unique_level = FALSE.",
    args = list(
      sum = TRUE,
      unique_level = FALSE,
      level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "delet"
    )
  ),

  list(
    name = "31_unique_level_TRUE_explicit",
    description = "Explicit control for unique_level = TRUE.",
    args = list(
      sum = TRUE,
      unique_level = TRUE,
      level = LEVEL_MID,
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "delet"
    )
  ),

  list(
    name = "32_verbose_FALSE",
    description = "Exercise verbose = FALSE without changing calculation settings.",
    args = list(
      sum = FALSE,
      level = LEVEL_MID,
      indet = TRUE,
      verbose = FALSE
    )
  ),

  list(
    name = "33_auto_level_min_FALSE_up",
    description = "Automatic level calculation combined with indet_method = up.",
    args = list(
      sum = FALSE,
      level = NULL,
      calc_level = "min",
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "up"
    )
  ),

  list(
    name = "34_auto_level_mode_FALSE_dist",
    description = "Automatic level calculation combined with stochastic distribution.",
    args = list(
      sum = FALSE,
      level = NULL,
      calc_level = "mode",
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "dist"
    )
  ),

  list(
    name = "35_recalc_filter_FALSE_dist",
    description = "Cross-check recalc_method = filter with stochastic indeterminate distribution.",
    args = list(
      sum = TRUE,
      level = LEVEL_MID,
      recalc_method = "filter",
      indet = FALSE,
      indet_method = "dist"
    )
  )
)


# ------------------------------------------------------------
# 7. SELECT / RUN FIXED TESTS
# ------------------------------------------------------------

fixed_results <- list()

if (RUN_FIXED_TESTS) {

  cat(
    "\n============================================================\n",
    "TAPHO FIXED REGRESSION TESTS\n",
    "============================================================\n",
    sep = ""
  )

  all_test_names <- vapply(
    tests, `[[`, character(1), "name"
  )

  if (is.null(TARGET_TESTS)) {

    selected_names <- setdiff(
      all_test_names,
      SKIP_TESTS
    )

  } else {

    missing_tests <- setdiff(
      TARGET_TESTS,
      all_test_names
    )

    if (length(missing_tests) > 0L) {
      stop(
        "Unknown TARGET_TESTS: ",
        paste(missing_tests, collapse = ", ")
      )
    }

    selected_names <- setdiff(
      TARGET_TESTS,
      SKIP_TESTS
    )
  }

  selected_tests <- tests[
    match(selected_names, all_test_names)
  ]

  cat(
    "Fixed tests selected: ",
    length(selected_tests),
    "\nSkipped: ",
    if (length(SKIP_TESTS) == 0L) "none" else paste(SKIP_TESTS, collapse = ", "),
    "\n",
    sep = ""
  )

  fixed_results <- vector(
    "list",
    length(selected_tests)
  )

  for (i in seq_along(selected_tests)) {

    test_i <- selected_tests[[i]]

    original_index <- match(
      test_i$name,
      all_test_names
    )

    fixed_results[[i]] <- run_one_test(
      test_name = test_i$name,
      description = test_i$description,
      args = test_i$args,
      seed = MASTER_SEED + original_index,
      test_group = "fixed",
      mode = "fixed"
    )
  }
}


# ------------------------------------------------------------
# 8. RANDOM STRESS TESTS
# ------------------------------------------------------------

random_results <- list()

if (RUN_RANDOM_STRESS) {

  cat(
    "\n============================================================\n",
    "TAPHO RANDOM STRESS TESTS\n",
    "============================================================\n",
    sep = ""
  )

  allowed_modes <- c(
    "indet_TRUE",
    "FALSE_delete",
    "FALSE_up",
    "FALSE_dist"
  )

  bad_modes <- setdiff(
    RANDOM_MODES,
    allowed_modes
  )

  if (length(bad_modes) > 0L) {
    stop(
      "Unknown RANDOM_MODES: ",
      paste(bad_modes, collapse = ", ")
    )
  }

  random_levels <- generate_random_vectors(
    N_RANDOM,
    seed = MASTER_SEED
  )

  random_mode_definitions <- list(

    indet_TRUE = list(
      sum = FALSE,
      recalc_method = "direct",
      indet = TRUE
    ),

    FALSE_delete = list(
      sum = FALSE,
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "delet"
    ),

    FALSE_up = list(
      sum = FALSE,
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "up"
    ),

    FALSE_dist = list(
      sum = FALSE,
      recalc_method = "direct",
      indet = FALSE,
      indet_method = "dist"
    )
  )

  cat(
    "Random vectors: ", length(random_levels), "\n",
    "Modes/vector:   ", length(RANDOM_MODES), "\n",
    "Random tests:   ", length(random_levels) * length(RANDOM_MODES), "\n",
    "Modes:          ", paste(RANDOM_MODES, collapse = ", "), "\n",
    sep = ""
  )

  counter <- 1L

  for (i in seq_along(random_levels)) {

    lvl <- random_levels[[i]]

    for (mode_name in RANDOM_MODES) {

      args_here <- random_mode_definitions[[mode_name]]
      args_here$level <- lvl

      random_results[[counter]] <- run_one_test(
        test_name = sprintf(
          "R%03d_%s",
          i,
          mode_name
        ),
        description = paste(
          "Random level stress test.",
          "Vector:",
          paste(lvl, collapse = ","),
          "Mode:",
          mode_name
        ),
        args = args_here,
        seed = MASTER_SEED + (i * 100L) + counter,
        test_group = "random",
        mode = mode_name
      )

      counter <- counter + 1L
    }
  }
}


# ------------------------------------------------------------
# 9. BUILD SUMMARY TABLE
# ------------------------------------------------------------

all_results <- c(
  fixed_results,
  random_results
)

if (length(all_results) == 0L) {
  stop(
    "No tests were configured to run.",
    "\nSet RUN_FIXED_TESTS and/or RUN_RANDOM_STRESS to TRUE."
  )
}

report <- do.call(
  rbind,
  lapply(
    all_results,
    function(x) {

      data.frame(
        test_name = x$test_name,
        test_group = x$test_group,
        mode = x$mode,
        description = x$description,
        seed = x$seed,
        level = x$level,
        success = isTRUE(x$success),
        warning_count = x$warning_count,
        warning_unique_count = x$warning_unique_count,
        warning_sample = x$warning_sample,
        error = ifelse(
          is.na(x$error), "", x$error
        ),
        error_call = ifelse(
          is.na(x$error_call), "", x$error_call
        ),
        likely_bug = ifelse(
          is.na(x$likely_bug), "", x$likely_bug
        ),
        likely_file = ifelse(
          is.na(x$likely_file), "", x$likely_file
        ),
        likely_location = ifelse(
          is.na(x$likely_location), "", x$likely_location
        ),
        suggestion = ifelse(
          is.na(x$suggestion), "", x$suggestion
        ),
        elapsed_seconds = round(
          x$elapsed_seconds,
          3
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)


# ------------------------------------------------------------
# 10. SAVE OUTPUTS
# ------------------------------------------------------------

REPORT_CSV <- "tapho_validation_report.csv"
RESULTS_RDS <- "tapho_validation_results.rds"
FAILURE_LOG <- "tapho_validation_failures.txt"

write.csv(
  report,
  REPORT_CSV,
  row.names = FALSE,
  na = ""
)

saveRDS(
  all_results,
  RESULTS_RDS
)


# ------------------------------------------------------------
# 11. DETAILED FAILURE LOG
# ------------------------------------------------------------

failed_index <- which(
  !report$success
)

con <- file(
  FAILURE_LOG,
  open = "wt"
)

writeLines(
  c(
    "TAPHO.LOADER VALIDATION FAILURE LOG",
    paste0("Generated: ", Sys.time()),
    paste0("Loader: ", LOADER_FILE),
    paste0("Excel: ", EXCEL_PATH),
    paste0("MASTER_SEED: ", MASTER_SEED),
    paste0("N_RANDOM: ", N_RANDOM),
    paste0("RANDOM_MODES: ", paste(RANDOM_MODES, collapse = ", ")),
    ""
  ),
  con
)

if (length(failed_index) == 0L) {

  writeLines(
    "All executed tests passed.",
    con
  )

} else {

  for (idx in failed_index) {

    x <- all_results[[idx]]

    writeLines(
      c(
        "============================================================",
        paste0("TEST: ", x$test_name),
        paste0("GROUP: ", x$test_group),
        paste0("MODE: ", x$mode),
        paste0("SEED: ", x$seed),
        paste0("LEVEL: ", x$level),
        paste0("DESCRIPTION: ", x$description),
        "",
        paste0("ERROR: ", x$error),
        paste0("ERROR CALL: ", x$error_call),
        paste0("LIKELY BUG: ", x$likely_bug),
        paste0("LIKELY FILE: ", x$likely_file),
        paste0("LIKELY LOCATION: ", x$likely_location),
        paste0("SUGGESTION: ", x$suggestion),
        "",
        "CALL STACK:",
        x$call_stack,
        ""
      ),
      con
    )
  }
}

close(con)


# ------------------------------------------------------------
# 12. CONSOLE SUMMARY
# ------------------------------------------------------------

n_total <- nrow(report)
n_pass  <- sum(report$success)
n_fail  <- sum(!report$success)

cat(
  "\n============================================================\n",
  "FINAL TEST SUMMARY\n",
  "============================================================\n",
  "Total tests: ", n_total, "\n",
  "Passed:      ", n_pass, "\n",
  "Failed:      ", n_fail, "\n",
  sep = ""
)

cat(
  "\nBY TEST GROUP\n",
  "------------------------------------------------------------\n",
  sep = ""
)
print(
  with(
    report,
    table(test_group, success)
  )
)

cat(
  "\nBY RANDOM MODE\n",
  "------------------------------------------------------------\n",
  sep = ""
)

random_report <- report[
  report$test_group == "random",
  ,
  drop = FALSE
]

if (nrow(random_report) > 0L) {
  print(
    with(
      random_report,
      table(mode, success)
    )
  )
} else {
  cat("No random tests were run.\n")
}

if (n_fail > 0L) {

  cat(
    "\nFAILED TESTS\n",
    "------------------------------------------------------------\n",
    sep = ""
  )

  failed <- report[
    !report$success,
    ,
    drop = FALSE
  ]

  for (i in seq_len(nrow(failed))) {

    cat(
      "\nTEST:       ", failed$test_name[i],
      "\nGROUP:      ", failed$test_group[i],
      "\nMODE:       ", failed$mode[i],
      "\nSEED:       ", failed$seed[i],
      "\nLEVEL:      ", failed$level[i],
      "\nERROR:      ", failed$error[i],
      "\nERROR CALL: ", failed$error_call[i],
      "\nLIKELY BUG: ", failed$likely_bug[i],
      "\nFILE:       ", failed$likely_file[i],
      "\nLOCATION:   ", failed$likely_location[i],
      "\nSUGGESTION: ", failed$suggestion[i],
      "\n",
      sep = ""
    )
  }

} else {

  cat(
    "\nAll executed tests passed.\n"
  )
}

cat(
  "\nFiles written:\n",
  "  ", REPORT_CSV, "\n",
  "  ", RESULTS_RDS, "\n",
  "  ", FAILURE_LOG, "\n",
  "\nUseful commands:\n",
  "  report <- read.csv('", REPORT_CSV, "')\n",
  "  subset(report, success == FALSE)\n",
  "  subset(report, test_group == 'random' & success == FALSE)\n",
  "  with(subset(report, test_group == 'random'), table(mode, success))\n",
  "  table(report$likely_bug)\n",
  sep = ""
)


# ------------------------------------------------------------
# 13. SHOW FAILURES IMMEDIATELY IN R
# ------------------------------------------------------------

failed_tests <- report[
  !report$success,
  c(
    "test_name",
    "test_group",
    "mode",
    "seed",
    "level",
    "error",
    "error_call",
    "likely_bug",
    "likely_file",
    "likely_location",
    "suggestion"
  ),
  drop = FALSE
]

print(
  failed_tests,
  row.names = FALSE
)
