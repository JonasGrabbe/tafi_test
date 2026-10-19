# ============================================================
# TAPHO.LOADER REGRESSION / STRESS TEST SUITE
# ============================================================
#
# Runs normal, edge, and stress tests against tapho.loader()
# without stopping at the first error.
#
# OUTPUTS CREATED IN YOUR R WORKING DIRECTORY:
#   tapho_targeted_report.csv   -> one-row-per-test summary
#   tapho_targeted_results.rds  -> full results incl. successful tapho_db objects
#
# This script does NOT modify your source files.
# ============================================================

# ------------------------------------------------------------
# 0. USER SETTINGS
# ------------------------------------------------------------

LOADER_FILE <- "tapho_loader_new.R"
EXCEL_PATH  <- "hspa.xlsx"
RUN_RANDOM_STRESS <- FALSE
N_RANDOM <- 5
MASTER_SEED <- 123

# Run only the currently relevant regression tests.
TARGET_TESTS <- c(
  "08_indet_FALSE_up",
  "09_indet_FALSE_dist",
  "10_regression_foot_metatarsal",
  "11_ribs_level3_indet_TRUE",
  "12_ribs_level3_up",
  "13_ribs_level3_dist",
  "14_ribs_level4_dist",
  "15_fragments_per_bone_1",
  "16_fragments_per_bone_3",
  "17_fragments_per_bone_100"
)

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
    ". Check that the active function in that file is named tapho.loader."
  )
}

if (!exists("random_vectors", mode = "function") && RUN_RANDOM_STRESS) {
  warning(
    "random_vectors() was not found. Fixed tests will run, ",
    "but random stress tests will be skipped."
  )
  RUN_RANDOM_STRESS <- FALSE
}

# ------------------------------------------------------------
# 2. STANDARD LEVEL VECTORS
# ------------------------------------------------------------
# Order:
# cranium, teeth, hyoid, vertebrae, thorax, shoulder,
# arms, hands, pelvic, legs, foot

LEVEL_MIN <- c(1,1,1,1,1,1,1,1,1,1,1)
LEVEL_MID <- c(3,3,1,2,2,2,2,3,2,2,3)
LEVEL_MAX <- c(5,5,1,3,4,3,3,5,4,3,5)

# Previously failing foot / metatarsal case.
LEVEL_FOOT_TEST <- c(4,1,1,2,3,2,2,2,2,1,4)

# Isolate thorax levels.
LEVEL_RIB3 <- c(1,1,1,1,3,1,1,1,1,1,1)
LEVEL_RIB4 <- c(1,1,1,1,4,1,1,1,1,1,1)

# ------------------------------------------------------------
# 3. ERROR CLASSIFIER
# ------------------------------------------------------------
# Maps known error text to the most likely source file/function.
# This is diagnostic guidance, not proof of cause.

classify_error <- function(msg) {
  if (is.na(msg) || !nzchar(msg)) {
    return(list(
      bug = NA_character_, file = NA_character_,
      location = NA_character_, suggestion = NA_character_
    ))
  }

  x <- tolower(msg)

  if (grepl("object 'meta' not found", x, fixed = TRUE) ||
      grepl('object "meta" not found', x, fixed = TRUE)) {
    return(list(
      bug = "META_NOT_RETURNED",
      file = "meta_set.R + tapho_loader_new.R",
      location = "meta_set(); tapho.loader() setup",
      suggestion = paste(
        "Make meta_set() return invisible(meta), then use",
        "meta <- meta_set(indet) inside tapho.loader()."
      )
    ))
  }

  if (grepl("list.*cannot be coerced", x) ||
      grepl("'list' object cannot be coerced", x, fixed = TRUE)) {
    return(list(
      bug = "LEVEL_IS_LIST",
      file = "calling script / tapho_loader_new.R",
      location = "level argument validation",
      suggestion = paste(
        "random_vectors(1) returns a list.",
        "Use random_vectors(1)[[1]] or level = lvl."
      )
    ))
  }

  if (grepl("cannot distribute surplus", x, fixed = TRUE)) {
    return(list(
      bug = "COLLAPSE_DOWN_SURPLUS",
      file = "tapho_loader_new.R",
      location = "collapse_down_step(); surplus calculation",
      suggestion = paste(
        "Inspect parent_count versus existing child counts.",
        "Parent MNE should not be added again if already represented by children."
      )
    ))
  }

  if (grepl("not enough open slots", x, fixed = TRUE)) {
    return(list(
      bug = "DISTRIBUTION_CAPACITY",
      file = "tapho_loader_new.R / indet.R",
      location = "distribute_surplus() or indeterminate/fragment distribution",
      suggestion = paste(
        "Inspect counts, max_counts, MNI, and sibling selection.",
        "For ribs, confirm rib_fragments is excluded from its own destinations."
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
      file = "indet.R + meta_indet_TRUE.R",
      location = "get_indet_parent()",
      suggestion = "Check that the indeterminate element exists as a child in the expected hierarchy mapping."
    ))
  }

  if (grepl("parent not found in mapping", x, fixed = TRUE)) {
    return(list(
      bug = "PARENT_NOT_IN_MAPPING",
      file = "indet.R + meta_indet_TRUE.R",
      location = "get_indet_siblings()/get_siblings_excluding()",
      suggestion = "Check mapping names and space/dot normalization for the reported parent."
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
      file = "calling script / tapho_loader_new.R",
      location = "level argument",
      suggestion = "Provide one numeric vector with exactly 11 anatomical section levels."
    ))
  }

  if (grepl("subscript out of bounds", x, fixed = TRUE)) {
    return(list(
      bug = "INDEX_OR_HIERARCHY_SHAPE",
      file = "inspect traceback",
      location = "likely hierarchy lookup or list-column extraction",
      suggestion = "Inspect the reported section/level and confirm the hierarchy entry exists with the expected shape."
    ))
  }

  if (grepl("replacement has", x, fixed = TRUE) ||
      grepl("arguments imply differing number of rows", x, fixed = TRUE)) {
    return(list(
      bug = "OUTPUT_LENGTH_MISMATCH",
      file = "tapho_loader_new.R / convertMNEtovariables_new.R",
      location = "alignment or final feature assembly",
      suggestion = "Compare element, count, skeleton, and derived-feature vector lengths."
    ))
  }

  list(
    bug = "UNCLASSIFIED",
    file = "inspect error message",
    location = "unknown",
    suggestion = "Search the exact error text in the source files and inspect this test's parameters in the CSV report."
  )
}

# ------------------------------------------------------------
# 4. SAFE TEST RUNNER
# ------------------------------------------------------------

run_one_test <- function(test_name, description, args, seed = MASTER_SEED) {
  warnings_here <- character(0)
  start_time <- Sys.time()
  set.seed(seed)

  result <- withCallingHandlers(
    tryCatch({
      db <- do.call(tapho.loader, c(list(data = EXCEL_PATH), args))
      list(success = TRUE, error = NA_character_, db = db)
    }, error = function(e) {
      list(success = FALSE, error = conditionMessage(e), db = NULL)
    }),
    warning = function(w) {
      warnings_here <<- c(warnings_here, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )

  elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  error_info <- classify_error(result$error)

  level_value <- args$level
  if (is.null(level_value)) {
    level_txt <- "NULL"
  } else if (is.list(level_value)) {
    level_txt <- paste("LIST:", paste(unlist(level_value), collapse = ","))
  } else {
    level_txt <- paste(level_value, collapse = ",")
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
  }

  if (length(warnings_here) > 0) {
    cat("  WARNINGS: ", length(warnings_here), "\n", sep = "")
  }

  list(
    test_name = test_name,
    description = description,
    args = args,
    level = level_txt,
    success = result$success,
    warnings = warnings_here,
    error = result$error,
    likely_bug = error_info$bug,
    likely_file = error_info$file,
    likely_location = error_info$location,
    suggestion = error_info$suggestion,
    elapsed_seconds = elapsed,
    db = result$db
  )
}

# ------------------------------------------------------------
# 5. FIXED REGRESSION / EDGE TESTS
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
    description = "Maximum anatomical detail; strong collapse-down stress test.",
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
    args = list(sum = FALSE, level = LEVEL_MID, indet = FALSE, indet_method = "delet")
  ),
  list(
    name = "08_indet_FALSE_up",
    description = "Resolve indeterminate data by collapsing upward.",
    args = list(sum = FALSE, level = LEVEL_MID, indet = FALSE, indet_method = "up")
  ),
  list(
    name = "09_indet_FALSE_dist",
    description = "Resolve indeterminate data by stochastic distribution.",
    args = list(sum = FALSE, level = LEVEL_MID, indet = FALSE, indet_method = "dist")
  ),
  list(
    name = "10_regression_foot_metatarsal",
    description = "Previously failing foot_4_to_3 metatarsal surplus case.",
    args = list(
      sum = FALSE, level = LEVEL_FOOT_TEST, recalc_method = "direct",
      indet = FALSE, indet_method = "dist"
    )
  ),
  list(
    name = "11_ribs_level3_indet_TRUE",
    description = "Thorax Level 3 while retaining indeterminate/fragment categories.",
    args = list(sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct", indet = TRUE)
  ),
  list(
    name = "12_ribs_level3_up",
    description = "Thorax Level 3; resolve rib fragments/indeterminate upward.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct",
      indet = FALSE, indet_method = "up", fragments_per_bone = 3
    )
  ),
  list(
    name = "13_ribs_level3_dist",
    description = "Thorax Level 3; stochastic fragment/indeterminate distribution.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct",
      indet = FALSE, indet_method = "dist", fragments_per_bone = 3
    )
  ),
  list(
    name = "14_ribs_level4_dist",
    description = "Maximum thorax detail with stochastic distribution.",
    args = list(
      sum = FALSE, level = LEVEL_RIB4, recalc_method = "direct",
      indet = FALSE, indet_method = "dist", fragments_per_bone = 3
    )
  ),
  list(
    name = "15_fragments_per_bone_1",
    description = "Fragment conversion edge: 1 fragment per bone.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct",
      indet = FALSE, indet_method = "dist", fragments_per_bone = 1
    )
  ),
  list(
    name = "16_fragments_per_bone_3",
    description = "Fragment conversion normal test: 3 fragments per bone.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct",
      indet = FALSE, indet_method = "dist", fragments_per_bone = 3
    )
  ),
  list(
    name = "17_fragments_per_bone_100",
    description = "Fragment conversion extreme: very large fragments-per-bone value.",
    args = list(
      sum = FALSE, level = LEVEL_RIB3, recalc_method = "direct",
      indet = FALSE, indet_method = "dist", fragments_per_bone = 100
    )
  ),
  list(
    name = "18_recalc_direct",
    description = "Grouped data recalculated directly to requested levels.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "direct",
      indet = FALSE, indet_method = "delet"
    )
  ),
  list(
    name = "19_recalc_min",
    description = "Grouped data recalculated to minimum common level.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "min",
      indet = FALSE, indet_method = "delet"
    )
  ),
  list(
    name = "20_recalc_filter",
    description = "Grouped data filtered/recalculated against requested levels.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "filter",
      indet = FALSE, indet_method = "delet"
    )
  ),
  list(
    name = "21_sum_FALSE",
    description = "Do not aggregate input records.",
    args = list(sum = FALSE, level = LEVEL_MID, indet = TRUE)
  ),
  list(
    name = "22_sum_TRUE",
    description = "Aggregate by site_id using default sum=TRUE behavior.",
    args = list(sum = TRUE, level = LEVEL_MID, indet = TRUE)
  ),
  list(
    name = "23_group_cultural_period",
    description = "Aggregate by site_id plus cultural_period.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period")
    )
  ),
  list(
    name = "24_group_multi",
    description = "Aggregate by site_id plus multiple metadata fields.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period", "mis_stage", "gender")
    )
  ),
  list(
    name = "25_select_gender_indet",
    description = "Selection/filter branch. May fail if the exact category value is absent.",
    args = list(
      sum = TRUE, level = LEVEL_MID, recalc_method = "direct",
      indet = FALSE, indet_method = "delet",
      group_by = c("cultural_period", "mis_stage", "gender"),
      select = c("gender" = "Indet")
    )
  ),
  list(
    name = "26_exclude_default_teeth",
    description = "Explicit default section exclusion.",
    args = list(
      sum = FALSE, level = LEVEL_MID, indet = TRUE,
      exclude_sections = c("teeth")
    )
  ),
  list(
    name = "27_exclude_none",
    description = "Retain all skeletal sections including teeth.",
    args = list(
      sum = FALSE, level = LEVEL_MID, indet = TRUE,
      exclude_sections = character(0)
    )
  ),
  list(
    name = "28_exclude_many",
    description = "Remove several major skeletal sections.",
    args = list(
      sum = FALSE, level = LEVEL_MID, indet = TRUE,
      exclude_sections = c("teeth", "arms", "legs", "cranium", "shoulder", "hands")
    )
  ),
  list(
    name = "29_exclude_everything",
    description = "Extreme empty-output test. Expected to reveal empty-data handling.",
    args = list(
      sum = FALSE, level = LEVEL_MID, indet = TRUE,
      exclude_sections = c(
        "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
        "arms", "hands", "pelvic", "legs", "foot"
      )
    )
  )
)

# ------------------------------------------------------------
# 6. RUN FIXED TESTS
# ------------------------------------------------------------

cat(
  "\n============================================================\n",
  "TAPHO FIXED REGRESSION TESTS\n",
  "============================================================\n",
  sep = ""
)

all_test_names <- vapply(tests, `[[`, character(1), "name")

missing_tests <- setdiff(TARGET_TESTS, all_test_names)
if (length(missing_tests) > 0) {
  stop(
    "Unknown TARGET_TESTS: ",
    paste(missing_tests, collapse = ", ")
  )
}

selected_tests <- tests[all_test_names %in% TARGET_TESTS]

cat(
  "Targeted tests: ",
  paste(vapply(selected_tests, `[[`, character(1), "name"), collapse = ", "),
  "\n",
  sep = ""
)

fixed_results <- vector("list", length(selected_tests))

for (i in seq_along(selected_tests)) {
  test_i <- selected_tests[[i]]

  # Preserve the seed the test had in the full suite.
  original_index <- match(test_i$name, all_test_names)

  fixed_results[[i]] <- run_one_test(
    test_name = test_i$name,
    description = test_i$description,
    args = test_i$args,
    seed = MASTER_SEED + original_index
  )
}

# ------------------------------------------------------------
# 7. RANDOM STRESS TESTS
# ------------------------------------------------------------

random_results <- list()

if (RUN_RANDOM_STRESS) {
  cat(
    "\n============================================================\n",
    "TAPHO RANDOM STRESS TESTS\n",
    "============================================================\n",
    sep = ""
  )

  set.seed(MASTER_SEED)
  random_levels <- random_vectors(N_RANDOM)

  random_modes <- list(
    list(
      suffix = "indet_TRUE",
      args = list(sum = FALSE, recalc_method = "direct", indet = TRUE)
    ),
    list(
      suffix = "FALSE_delete",
      args = list(
        sum = FALSE, recalc_method = "direct",
        indet = FALSE, indet_method = "delet"
      )
    ),
    list(
      suffix = "FALSE_up",
      args = list(
        sum = FALSE, recalc_method = "direct",
        indet = FALSE, indet_method = "up"
      )
    ),
    list(
      suffix = "FALSE_dist",
      args = list(
        sum = FALSE, recalc_method = "direct",
        indet = FALSE, indet_method = "dist"
      )
    )
  )

  counter <- 1L

  for (i in seq_along(random_levels)) {
    lvl <- random_levels[[i]]

    for (mode in random_modes) {
      args_here <- mode$args
      args_here$level <- lvl

      random_results[[counter]] <- run_one_test(
        test_name = sprintf("R%03d_%s", i, mode$suffix),
        description = paste(
          "Random level stress test.",
          "Vector:", paste(lvl, collapse = ","),
          "Mode:", mode$suffix
        ),
        args = args_here,
        seed = MASTER_SEED + (i * 100L) + counter
      )

      counter <- counter + 1L
    }
  }
}

# ------------------------------------------------------------
# 8. BUILD SUMMARY TABLE
# ------------------------------------------------------------

all_results <- c(fixed_results, random_results)

report <- do.call(
  rbind,
  lapply(all_results, function(x) {
    data.frame(
      test_name = x$test_name,
      description = x$description,
      level = x$level,
      success = x$success,
      warning_count = length(x$warnings),
      warnings = paste(unique(x$warnings), collapse = " | "),
      error = ifelse(is.na(x$error), "", x$error),
      likely_bug = ifelse(is.na(x$likely_bug), "", x$likely_bug),
      likely_file = ifelse(is.na(x$likely_file), "", x$likely_file),
      likely_location = ifelse(is.na(x$likely_location), "", x$likely_location),
      suggestion = ifelse(is.na(x$suggestion), "", x$suggestion),
      elapsed_seconds = round(x$elapsed_seconds, 3),
      stringsAsFactors = FALSE
    )
  })
)

# ------------------------------------------------------------
# 9. SAVE OUTPUTS
# ------------------------------------------------------------

write.csv(
  report,
  "tapho_targeted_report.csv",
  row.names = FALSE,
  na = ""
)

saveRDS(
  all_results,
  "tapho_targeted_results.rds"
)

# ------------------------------------------------------------
# 10. CONSOLE SUMMARY
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

if (n_fail > 0) {
  cat("\nFAILED TESTS\n------------------------------------------------------------\n")
  failed <- report[!report$success, , drop = FALSE]

  for (i in seq_len(nrow(failed))) {
    cat(
      "\nTEST:       ", failed$test_name[i],
      "\nLEVEL:      ", failed$level[i],
      "\nERROR:      ", failed$error[i],
      "\nLIKELY BUG: ", failed$likely_bug[i],
      "\nFILE:       ", failed$likely_file[i],
      "\nLOCATION:   ", failed$likely_location[i],
      "\nSUGGESTION: ", failed$suggestion[i],
      "\n",
      sep = ""
    )
  }
} else {
  cat("\nAll tests passed.\n")
}

cat(
  "\nFiles written:\n",
  "  tapho_targeted_report.csv\n",
  "  tapho_targeted_results.rds\n",
  "\nUseful commands after the run:\n",
  "  report <- read.csv('tapho_targeted_report.csv')\n",
  "  subset(report, success == FALSE)\n",
  "  subset(report, warning_count > 0)\n",
  "  table(report$likely_bug)\n",
  "\nFull successful tapho_db objects:\n",
  "  results <- readRDS('tapho_targeted_results.rds')\n",
  "  results[[1]]$db\n",
  sep = ""
)

# ------------------------------------------------------------
# 11. SHOW FAILURES IMMEDIATELY IN R
# ------------------------------------------------------------

failed_tests <- report[
  !report$success,
  c(
    "test_name", "level", "error", "likely_bug",
    "likely_file", "likely_location", "suggestion"
  ),
  drop = FALSE
]

print(failed_tests, row.names = FALSE)
