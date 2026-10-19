# ======================================================================
# analyse_resolution_performance_and_imputation.R
#
# PURPOSE
#   1) Scan all results_tuning_* folders directly below this script.
#   2) Parse task, feature variant, 11-part skeletal level vector, and model
#      from each folder name.
#   3) Extract the best-config cross-validated accuracy and RF hyperparameters.
#   4) Re-estimate whole-skeleton and section-level resolution effects while
#      optionally adjusting for RF hyperparameters if they vary across runs.
#   5) If native_resolution_by_site.csv is present, quantify:
#        - exact native resolution distribution
#        - cumulative native support for each requested level
#        - upward-imputation burden of every tested level vector
#        - accuracy vs imputation-burden trade-off
#        - Pareto-efficient candidate vectors
#
# EXPECTED RESULT FOLDER NAME
#   results_tuning_fc_vs_rest_ProportionalRep_MNIbased_L4_1_1_1_1_1_3_4_2_3_5_RandomForest
#
# LEVEL ORDER
#   Cranium, Teeth, Hyoid, Vertebrae, Thorax, Shoulder,
#   Arm, Hand, Pelvis, Leg, Foot
#
# OPTIONAL INPUT FOR IMPUTATION ANALYSIS
#   native_resolution_by_site.csv
#
# Minimum format:
#   site_id,cranium,teeth,hyoid,vertebrae,thorax,shoulder,arm,hand,pelvis,leg,foot
#
# Each section value = highest resolution level genuinely supported by the
# original/pre-imputation source data for that site. Use NA where the native
# resolution is not known/applicable. If you have a more precise imputation
# audit from the data loader, that is preferable to this site-level proxy.
#
# IMPORTANT
#   This script treats each results folder as ONE tested skeletal-level vector.
#   It does not claim that the best observed vector is a universally optimal
#   coding scheme.
# ======================================================================

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg[1]),
                                  winslash = "/", mustWork = TRUE)))
  }

  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    ofile <- frames[[i]]$ofile
    if (!is.null(ofile) && nzchar(ofile)) {
      return(dirname(normalizePath(ofile, winslash = "/", mustWork = TRUE)))
    }
  }

  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

PROJECT_ROOT <- get_script_dir()
OUTPUT_DIR <- file.path(PROJECT_ROOT, "results_resolution_imputation_tradeoff")
NATIVE_FILE <- file.path(PROJECT_ROOT, "native_resolution_by_site.csv")

dir.create(OUTPUT_DIR, recursive = TRUE, showWarnings = FALSE)

required_packages <- c(
  "readr", "dplyr", "tidyr", "ggplot2", "stringr", "purrr",
  "sandwich", "lmtest", "car", "patchwork"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages)) {
  stop(
    "Missing package(s): ", paste(missing_packages, collapse = ", "),
    "\nInstall with:\ninstall.packages(c(",
    paste(sprintf('"%s"', missing_packages), collapse = ", "),
    "))"
  )
}

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(stringr)
  library(purrr)
  library(sandwich)
  library(lmtest)
  library(car)
  library(patchwork)
})

SECTIONS <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax",
  "shoulder", "arm", "hand", "pelvis", "leg", "foot"
)

SECTION_LABELS <- c(
  cranium = "Cranium",
  teeth = "Teeth",
  hyoid = "Hyoid",
  vertebrae = "Vertebrae",
  thorax = "Thorax",
  shoulder = "Shoulder",
  arm = "Arm",
  hand = "Hand",
  pelvis = "Pelvis",
  leg = "Leg",
  foot = "Foot"
)

TASKS <- c("4class", "cannibalism_vs_fc", "fc_vs_rest")

cat("Project root: ", PROJECT_ROOT, "\n", sep = "")
cat("Output dir  : ", OUTPUT_DIR, "\n\n", sep = "")

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------

first_file <- function(folder, pattern) {
  x <- list.files(
    folder,
    pattern = pattern,
    full.names = TRUE,
    ignore.case = TRUE,
    recursive = FALSE
  )
  if (!length(x)) return(NA_character_)
  x[1]
}

read_csv_quiet <- function(path) {
  if (is.na(path) || !file.exists(path)) return(NULL)
  tryCatch(
    readr::read_csv(path, show_col_types = FALSE, progress = FALSE),
    error = function(e) NULL
  )
}

parse_folder_name <- function(folder) {
  nm <- basename(folder)

  # Task is constrained to the three tasks used in this experiment.
  pat <- paste0(
    "^results_tuning_",
    "(4class|cannibalism_vs_fc|fc_vs_rest)_",
    "(.+)_",
    "L((?:[0-9]+_){10}[0-9]+)_",
    "([^_]+)$"
  )

  m <- stringr::str_match(nm, pat)
  if (all(is.na(m))) return(NULL)

  lev <- as.integer(strsplit(m[1, 4], "_", fixed = TRUE)[[1]])
  if (length(lev) != 11L) return(NULL)

  out <- tibble(
    folder = folder,
    folder_name = nm,
    task = m[1, 2],
    variant = m[1, 3],
    level_vector = paste0("L", m[1, 4]),
    model = m[1, 5]
  )

  for (j in seq_along(SECTIONS)) {
    out[[SECTIONS[j]]] <- lev[j]
  }

  out$total_detail <- sum(lev)
  out
}

metric_row <- function(metrics, metric_name) {
  if (is.null(metrics) || !".metric" %in% names(metrics)) return(NULL)

  row <- metrics |>
    filter(.metric == metric_name) |>
    slice(1)

  if (!nrow(row)) return(NULL)
  row
}

parse_mean_sd_string <- function(x) {
  # Handles strings such as "0.823 (0.018)"
  if (length(x) == 0 || is.na(x)) return(c(mean = NA_real_, sd = NA_real_))
  nums <- stringr::str_extract_all(as.character(x), "[0-9]*\\.?[0-9]+")[[1]]
  nums <- suppressWarnings(as.numeric(nums))
  if (!length(nums)) return(c(mean = NA_real_, sd = NA_real_))
  c(
    mean = nums[1],
    sd = ifelse(length(nums) >= 2, nums[2], NA_real_)
  )
}

extract_one_run <- function(folder) {
  meta <- parse_folder_name(folder)
  if (is.null(meta)) return(NULL)

  metrics_file <- first_file(
    folder,
    "^summary_metrics_best_config.*\\.csv$"
  )
  acc_file <- first_file(
    folder,
    "^accuracy_summary_all_combos.*\\.csv$"
  )
  tune_file <- first_file(
    folder,
    "^tuning_results_.*\\.csv$"
  )
  class_file <- first_file(
    folder,
    "^classification_report_best_config.*\\.csv$"
  )

  metrics <- read_csv_quiet(metrics_file)
  acc_sum <- read_csv_quiet(acc_file)
  tuning <- read_csv_quiet(tune_file)
  class_rep <- read_csv_quiet(class_file)

  # ---------- accuracy ----------
  a <- metric_row(metrics, "accuracy")

  accuracy_mean <- NA_real_
  accuracy_se <- NA_real_
  accuracy_sd <- NA_real_
  cv_n <- NA_integer_

  if (!is.null(a)) {
    if ("mean" %in% names(a)) accuracy_mean <- as.numeric(a$mean[1])
    if ("std_err" %in% names(a)) accuracy_se <- as.numeric(a$std_err[1])
    if ("std_dev" %in% names(a)) accuracy_sd <- as.numeric(a$std_dev[1])
    if ("n" %in% names(a)) cv_n <- as.integer(a$n[1])
  }

  # Fallback: accuracy summary table
  if (!is.finite(accuracy_mean) && !is.null(acc_sum) && nrow(acc_sum)) {
    if ("rank_by_accuracy" %in% names(acc_sum)) {
      acc_sum <- acc_sum |> arrange(rank_by_accuracy)
    } else if ("mean" %in% names(acc_sum)) {
      acc_sum <- acc_sum |> arrange(desc(mean))
    }

    best <- acc_sum |> slice(1)
    if ("mean" %in% names(best)) accuracy_mean <- as.numeric(best$mean[1])
    if ("std_err" %in% names(best)) accuracy_se <- as.numeric(best$std_err[1])
    if ("n" %in% names(best)) cv_n <- as.integer(best$n[1])
  }

  # Fallback: classification report accuracy row
  if (!is.finite(accuracy_mean) && !is.null(class_rep) &&
      all(c("Class", "F1") %in% names(class_rep))) {
    row <- class_rep |>
      filter(tolower(Class) == "accuracy") |>
      slice(1)

    if (nrow(row)) {
      z <- parse_mean_sd_string(row$F1[1])
      accuracy_mean <- unname(z["mean"])
      accuracy_sd <- unname(z["sd"])
    }
  }

  if (!is.finite(accuracy_sd) &&
      is.finite(accuracy_se) && is.finite(cv_n) && cv_n > 0) {
    accuracy_sd <- accuracy_se * sqrt(cv_n)
  }

  if (!is.finite(accuracy_se) &&
      is.finite(accuracy_sd) && is.finite(cv_n) && cv_n > 0) {
    accuracy_se <- accuracy_sd / sqrt(cv_n)
  }

  # Descriptive t interval across saved CV resamples.
  # Do not interpret this as an independent-sample biological CI.
  accuracy_ci_low <- NA_real_
  accuracy_ci_high <- NA_real_
  if (is.finite(accuracy_mean) &&
      is.finite(accuracy_se) &&
      is.finite(cv_n) && cv_n > 1) {
    crit <- qt(0.975, df = cv_n - 1)
    accuracy_ci_low <- accuracy_mean - crit * accuracy_se
    accuracy_ci_high <- accuracy_mean + crit * accuracy_se
  }

  # ---------- other metrics ----------
  pull_metric_mean <- function(metric_name) {
    z <- metric_row(metrics, metric_name)
    if (is.null(z) || !"mean" %in% names(z)) return(NA_real_)
    as.numeric(z$mean[1])
  }

  f_meas_mean <- pull_metric_mean("f_meas")
  precision_mean <- pull_metric_mean("precision")
  recall_mean <- pull_metric_mean("recall")

  # Macro-F1 from classification report, if available.
  macro_f1 <- NA_real_
  if (!is.null(class_rep) && all(c("Class", "F1") %in% names(class_rep))) {
    row <- class_rep |>
      filter(tolower(Class) == "macro_avg") |>
      slice(1)
    if (nrow(row)) {
      macro_f1 <- unname(parse_mean_sd_string(row$F1[1])["mean"])
    }
  }

  # ---------- hyperparameters ----------
  hp <- NULL
  if (!is.null(acc_sum) && nrow(acc_sum)) {
    if ("rank_by_accuracy" %in% names(acc_sum)) {
      hp <- acc_sum |> arrange(rank_by_accuracy) |> slice(1)
    } else if ("mean" %in% names(acc_sum)) {
      hp <- acc_sum |> arrange(desc(mean)) |> slice(1)
    }
  }

  if (is.null(hp) && !is.null(tuning) && nrow(tuning)) {
    if ("rank" %in% names(tuning)) {
      hp <- tuning |> arrange(rank) |> slice(1)
    } else if ("mean" %in% names(tuning)) {
      hp <- tuning |> arrange(desc(mean)) |> slice(1)
    }
  }

  get_hp <- function(name) {
    if (is.null(hp) || !name %in% names(hp)) return(NA_real_)
    suppressWarnings(as.numeric(hp[[name]][1]))
  }

  n_hyperparameter_combos <- NA_integer_
  if (!is.null(acc_sum)) {
    n_hyperparameter_combos <- nrow(acc_sum)
  } else if (!is.null(tuning)) {
    n_hyperparameter_combos <- nrow(tuning)
  }

  meta |>
    mutate(
      accuracy_mean = accuracy_mean,
      accuracy_se = accuracy_se,
      accuracy_sd = accuracy_sd,
      cv_n = cv_n,
      accuracy_ci_low = accuracy_ci_low,
      accuracy_ci_high = accuracy_ci_high,
      f_meas_mean = f_meas_mean,
      macro_f1 = macro_f1,
      precision_mean = precision_mean,
      recall_mean = recall_mean,
      mtry = get_hp("mtry"),
      trees = get_hp("trees"),
      min_n = get_hp("min_n"),
      n_hyperparameter_combos = n_hyperparameter_combos,
      metrics_file = metrics_file,
      accuracy_file = acc_file,
      tuning_file = tune_file
    )
}

# ----------------------------------------------------------------------
# 1. Scan all direct child result folders
# ----------------------------------------------------------------------

all_dirs <- list.dirs(PROJECT_ROOT, recursive = FALSE, full.names = TRUE)

result_dirs <- all_dirs[
  grepl(
    "^results_tuning_(4class|cannibalism_vs_fc|fc_vs_rest)_.*_L([0-9]+_){10}[0-9]+_[^_]+$",
    basename(all_dirs)
  )
]

cat("Matching result folders found: ", length(result_dirs), "\n", sep = "")

if (!length(result_dirs)) {
  stop(
    "No result folders matched the expected naming pattern.\n",
    "Example:\n",
    "results_tuning_fc_vs_rest_ProportionalRep_MNIbased_",
    "L4_1_1_1_1_1_3_4_2_3_5_RandomForest"
  )
}

run_list <- vector("list", length(result_dirs))

for (i in seq_along(result_dirs)) {
  if (i %% 100 == 0 || i == 1 || i == length(result_dirs)) {
    cat("Reading run ", i, " / ", length(result_dirs), "\n", sep = "")
  }
  run_list[[i]] <- extract_one_run(result_dirs[i])
}

runs <- bind_rows(run_list) |>
  filter(is.finite(accuracy_mean)) |>
  arrange(task, desc(accuracy_mean))

if (!nrow(runs)) {
  stop("Folders were found, but no accuracy values could be extracted.")
}

readr::write_csv(
  runs,
  file.path(OUTPUT_DIR, "01_master_run_results.csv")
)

integrity <- runs |>
  group_by(task) |>
  summarise(
    n_runs = n(),
    n_unique_vectors = n_distinct(level_vector),
    n_duplicate_vectors = n_runs - n_unique_vectors,
    mean_accuracy = mean(accuracy_mean, na.rm = TRUE),
    sd_accuracy = sd(accuracy_mean, na.rm = TRUE),
    .groups = "drop"
  )

readr::write_csv(
  integrity,
  file.path(OUTPUT_DIR, "02_run_integrity.csv")
)

cat("\nRuns extracted by task:\n")
print(integrity)

# ----------------------------------------------------------------------
# 2. Hyperparameter diagnostic
#
# This is important because if every skeletal vector was evaluated with one
# different random RF hyperparameter configuration, resolution and RF tuning
# are partly confounded.
# ----------------------------------------------------------------------

hp_diag <- runs |>
  group_by(task) |>
  summarise(
    n_runs = n(),
    n_unique_mtry = n_distinct(mtry[is.finite(mtry)]),
    n_unique_trees = n_distinct(trees[is.finite(trees)]),
    n_unique_min_n = n_distinct(min_n[is.finite(min_n)]),
    median_n_hyperparameter_combos =
      median(n_hyperparameter_combos, na.rm = TRUE),
    min_n_hyperparameter_combos =
      suppressWarnings(min(n_hyperparameter_combos, na.rm = TRUE)),
    max_n_hyperparameter_combos =
      suppressWarnings(max(n_hyperparameter_combos, na.rm = TRUE)),
    .groups = "drop"
  )

readr::write_csv(
  hp_diag,
  file.path(OUTPUT_DIR, "03_hyperparameter_diagnostic.csv")
)

cat("\nHyperparameter diagnostic:\n")
print(hp_diag)

if (any(hp_diag$n_unique_mtry > 1 |
        hp_diag$n_unique_trees > 1 |
        hp_diag$n_unique_min_n > 1, na.rm = TRUE)) {
  warning(
    "RF hyperparameters vary across level-vector runs. ",
    "Unadjusted level effects may contain hyperparameter variation. ",
    "This script therefore adds available RF hyperparameters as covariates ",
    "in the adjusted sensitivity models."
  )
}

# ----------------------------------------------------------------------
# 3. Whole-skeleton effect, adjusted for RF hyperparameters when possible
# ----------------------------------------------------------------------

fit_whole_task <- function(d) {
  rhs <- "total_detail"

  if (sum(is.finite(d$mtry)) == nrow(d) && n_distinct(d$mtry) > 1) {
    d$hp_mtry <- scale(log1p(d$mtry))[, 1]
    rhs <- paste(rhs, "+ hp_mtry")
  }

  if (sum(is.finite(d$trees)) == nrow(d) && n_distinct(d$trees) > 1) {
    d$hp_trees <- scale(log1p(d$trees))[, 1]
    rhs <- paste(rhs, "+ hp_trees")
  }

  if (sum(is.finite(d$min_n)) == nrow(d) && n_distinct(d$min_n) > 1) {
    d$hp_min_n <- scale(d$min_n)[, 1]
    rhs <- paste(rhs, "+ hp_min_n")
  }

  fit <- lm(as.formula(paste("accuracy_mean ~", rhs)), data = d)
  vc <- sandwich::vcovHC(fit, type = "HC3")
  ct <- lmtest::coeftest(fit, vcov. = vc)
  ci <- lmtest::coefci(fit, vcov. = vc, level = 0.95)

  coefs <- tibble(
    term = rownames(ct),
    estimate = ct[, "Estimate"],
    robust_se = ct[, "Std. Error"],
    statistic = ct[, grep(" value$", colnames(ct), value = TRUE)[1]],
    p = ct[, grep("^Pr\\(", colnames(ct), value = TRUE)[1]],
    ci_low = ci[, 1],
    ci_high = ci[, 2]
  )

  list(
    fit = fit,
    data = d,
    coefficients = coefs,
    adjusted_r2 = summary(fit)$adj.r.squared
  )
}

whole_results <- list()
whole_fits <- list()

for (task_name in intersect(TASKS, unique(runs$task))) {
  d <- runs |> filter(task == task_name)
  z <- fit_whole_task(d)

  whole_fits[[task_name]] <- z

  tab <- z$coefficients |>
    mutate(
      task = task_name,
      adjusted_r2 = z$adjusted_r2,
      .before = 1
    )

  whole_results[[task_name]] <- tab

  p <- ggplot(z$data, aes(x = total_detail, y = accuracy_mean)) +
    geom_point(alpha = 0.35, size = 1.5) +
    geom_smooth(method = "lm", formula = y ~ x, se = TRUE, linewidth = 0.8) +
    labs(
      title = paste0("Total skeletal detail vs accuracy - ", task_name),
      subtitle = paste0(
        "N = ", nrow(z$data),
        " tested vectors. Line shown is the raw visual trend; ",
        "saved coefficient table additionally adjusts for varying RF hyperparameters."
      ),
      x = "Sum of the 11 section detail levels",
      y = "Cross-validated accuracy"
    ) +
    theme_minimal(base_size = 11) +
    theme(panel.grid.minor = element_blank())

  print(p)

  ggsave(
    file.path(
      OUTPUT_DIR,
      paste0("figure_total_detail_vs_accuracy_", task_name, ".png")
    ),
    p,
    width = 9,
    height = 6,
    dpi = 350,
    bg = "white"
  )
}

whole_table <- bind_rows(whole_results) |>
  group_by(task) |>
  mutate(p_fdr_within_task = p.adjust(p, method = "BH")) |>
  ungroup()

readr::write_csv(
  whole_table,
  file.path(
    OUTPUT_DIR,
    "04_whole_skeleton_models_hyperparameter_adjusted_HC3.csv"
  )
)

# ----------------------------------------------------------------------
# 4. Section-level adjusted effects
#
# Factor-based additive model:
#   accuracy ~ factor(section 1) + ... + factor(section 11)
#              + varying RF hyperparameters
#
# Empirical standardization is used to estimate adjusted section x level means
# without constructing the full 162,000-combination Cartesian grid.
# ----------------------------------------------------------------------

fit_section_task <- function(d, task_name) {
  varying_sections <- SECTIONS[
    vapply(SECTIONS, function(x) n_distinct(d[[x]]) > 1, logical(1))
  ]

  model_data <- d

  for (sec in varying_sections) {
    model_data[[sec]] <- factor(
      model_data[[sec]],
      levels = sort(unique(model_data[[sec]]))
    )
  }

  rhs <- paste(varying_sections, collapse = " + ")

  hp_terms <- character(0)

  if (sum(is.finite(model_data$mtry)) == nrow(model_data) &&
      n_distinct(model_data$mtry) > 1) {
    model_data$hp_mtry <- scale(log1p(model_data$mtry))[, 1]
    hp_terms <- c(hp_terms, "hp_mtry")
  }

  if (sum(is.finite(model_data$trees)) == nrow(model_data) &&
      n_distinct(model_data$trees) > 1) {
    model_data$hp_trees <- scale(log1p(model_data$trees))[, 1]
    hp_terms <- c(hp_terms, "hp_trees")
  }

  if (sum(is.finite(model_data$min_n)) == nrow(model_data) &&
      n_distinct(model_data$min_n) > 1) {
    model_data$hp_min_n <- scale(model_data$min_n)[, 1]
    hp_terms <- c(hp_terms, "hp_min_n")
  }

  if (length(hp_terms)) {
    rhs <- paste(c(rhs, hp_terms), collapse = " + ")
  }

  fit <- lm(
    as.formula(paste("accuracy_mean ~", rhs)),
    data = model_data
  )

  vc <- sandwich::vcovHC(fit, type = "HC3")

  # Type-II global tests
  global_raw <- as.data.frame(
    car::Anova(fit, type = 2, white.adjust = "hc3")
  )

  global_raw$term <- rownames(global_raw)
  rownames(global_raw) <- NULL

  f_col <- grep("^F", names(global_raw), value = TRUE)[1]
  p_col <- grep("Pr\\(>F\\)", names(global_raw), value = TRUE)[1]
  df_col <- grep("^Df$", names(global_raw), value = TRUE)[1]

  global <- tibble(
    task = task_name,
    term = global_raw$term,
    df1 = global_raw[[df_col]],
    df2 = df.residual(fit),
    F_hc3 = global_raw[[f_col]],
    p = global_raw[[p_col]]
  ) |>
    mutate(
      p_fdr = p.adjust(p, method = "BH"),
      partial_eta2 = (F_hc3 * df1) / (F_hc3 * df1 + df2),
      significant_fdr = !is.na(p_fdr) & p_fdr < 0.05
    )

  # Empirical-standardization helper
  standardized_row <- function(sec, lev) {
    nd <- model_data
    nd[[sec]] <- factor(
      as.character(lev),
      levels = levels(model_data[[sec]])
    )

    X <- model.matrix(
      delete.response(terms(fit)),
      data = nd,
      contrasts.arg = fit$contrasts
    )

    beta <- coef(fit)

    if (anyNA(beta)) {
      stop(
        "Aliased coefficients in section model for task ", task_name,
        ". Check redundant predictors or hyperparameters."
      )
    }

    X <- X[, names(beta), drop = FALSE]
    a <- colMeans(X)

    est <- as.numeric(crossprod(a, beta))
    var <- as.numeric(t(a) %*% vc %*% a)
    se <- sqrt(max(var, 0))

    list(
      estimate = est,
      se = se,
      a = a
    )
  }

  adjusted_means <- list()
  contrasts <- list()

  for (sec in varying_sections) {
    levs <- levels(model_data[[sec]])
    rows <- lapply(levs, function(lev) standardized_row(sec, lev))
    names(rows) <- levs

    adjusted_means[[sec]] <- bind_rows(
      lapply(names(rows), function(lev) {
        z <- rows[[lev]]
        tibble(
          task = task_name,
          section = sec,
          level = as.integer(lev),
          adjusted_mean = z$estimate,
          robust_se = z$se
        )
      })
    )

    ref <- rows[[1]]
    ref_level <- as.integer(names(rows)[1])

    if (length(rows) > 1) {
      contrasts[[sec]] <- bind_rows(
        lapply(names(rows)[-1], function(lev) {
          cur <- rows[[lev]]
          delta_a <- cur$a - ref$a
          est <- as.numeric(crossprod(delta_a, coef(fit)))
          var <- as.numeric(t(delta_a) %*% vc %*% delta_a)
          se <- sqrt(max(var, 0))
          stat <- if (se > 0) est / se else NA_real_
          p <- if (is.finite(stat)) {
            2 * pt(-abs(stat), df = df.residual(fit))
          } else {
            NA_real_
          }
          crit <- qt(0.975, df = df.residual(fit))

          tibble(
            task = task_name,
            section = sec,
            level = as.integer(lev),
            reference_level = ref_level,
            estimate = est,
            robust_se = se,
            ci_low = est - crit * se,
            ci_high = est + crit * se,
            p = p
          )
        })
      )
    }
  }

  adjusted_means <- bind_rows(adjusted_means)

  contrasts <- bind_rows(contrasts) |>
    mutate(
      p_fdr = p.adjust(p, method = "BH"),
      significant_fdr = !is.na(p_fdr) & p_fdr < 0.05
    )

  list(
    fit = fit,
    global = global,
    adjusted_means = adjusted_means,
    contrasts = contrasts
  )
}

section_results <- list()

for (task_name in intersect(TASKS, unique(runs$task))) {
  d <- runs |> filter(task == task_name)
  section_results[[task_name]] <- fit_section_task(d, task_name)
}

section_global <- bind_rows(lapply(section_results, `[[`, "global"))
section_means <- bind_rows(lapply(section_results, `[[`, "adjusted_means"))
section_contrasts <- bind_rows(lapply(section_results, `[[`, "contrasts"))

readr::write_csv(
  section_global,
  file.path(
    OUTPUT_DIR,
    "05_section_global_tests_hyperparameter_adjusted_HC3_FDR.csv"
  )
)

readr::write_csv(
  section_means,
  file.path(
    OUTPUT_DIR,
    "06_section_level_adjusted_means_hyperparameter_adjusted.csv"
  )
)

readr::write_csv(
  section_contrasts,
  file.path(
    OUTPUT_DIR,
    "07_section_level_contrasts_hyperparameter_adjusted_HC3_FDR.csv"
  )
)

# ----------------------------------------------------------------------
# 5. Performance heatmaps
# ----------------------------------------------------------------------

for (task_name in intersect(TASKS, unique(section_means$task))) {
  plot_data <- section_means |>
    filter(task == task_name) |>
    mutate(
      section_label = factor(
        SECTION_LABELS[section],
        levels = unname(SECTION_LABELS)
      ),
      level_factor = factor(level)
    )

  p <- ggplot(
    plot_data,
    aes(x = section_label, y = level_factor, fill = adjusted_mean)
  ) +
    geom_tile(linewidth = 0.3) +
    geom_text(aes(label = sprintf("%.3f", adjusted_mean)), size = 3) +
    labs(
      title = paste0(
        "Adjusted section x level performance map - ", task_name
      ),
      subtitle = paste0(
        "Empirically standardized mean accuracy; adjusted for other ",
        "skeletal sections and for RF hyperparameters when they vary."
      ),
      x = "Skeletal section",
      y = "Requested detail level",
      fill = "Adjusted accuracy"
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )

  print(p)

  ggsave(
    file.path(
      OUTPUT_DIR,
      paste0("figure_adjusted_accuracy_map_", task_name, ".png")
    ),
    p,
    width = 12,
    height = 6.5,
    dpi = 350,
    bg = "white"
  )
}

# ----------------------------------------------------------------------
# 6. OPTIONAL: native support / imputation burden
# ----------------------------------------------------------------------

if (!file.exists(NATIVE_FILE)) {

  template <- tibble(site_id = character())
  for (sec in SECTIONS) template[[sec]] <- integer()

  readr::write_csv(
    template,
    file.path(OUTPUT_DIR, "TEMPLATE_native_resolution_by_site.csv")
  )

  cat(
    "\nNo native_resolution_by_site.csv found.\n",
    "Performance/hyperparameter analysis is complete.\n",
    "Imputation-burden analysis was skipped.\n",
    "A template was written to:\n",
    file.path(OUTPUT_DIR, "TEMPLATE_native_resolution_by_site.csv"),
    "\n\n",
    sep = ""
  )

} else {

  native <- readr::read_csv(
    NATIVE_FILE,
    show_col_types = FALSE,
    progress = FALSE
  )

  # Accept common plural aliases.
  alias_map <- c(
    arms = "arm",
    hands = "hand",
    pelvic = "pelvis",
    legs = "leg"
  )

  for (old in names(alias_map)) {
    new <- unname(alias_map[old])
    if (old %in% names(native) && !new %in% names(native)) {
      names(native)[names(native) == old] <- new
    }
  }

  missing_native_cols <- setdiff(SECTIONS, names(native))
  if (length(missing_native_cols)) {
    stop(
      "native_resolution_by_site.csv is missing section column(s): ",
      paste(missing_native_cols, collapse = ", ")
    )
  }

  if (!"site_id" %in% names(native)) {
    native$site_id <- paste0("site_", seq_len(nrow(native)))
  }

  native <- native |>
    mutate(
      across(
        all_of(SECTIONS),
        ~ suppressWarnings(as.numeric(.))
      )
    )

  native_long <- native |>
    select(site_id, all_of(SECTIONS)) |>
    pivot_longer(
      cols = all_of(SECTIONS),
      names_to = "section",
      values_to = "native_level"
    )

  # Exact native level distribution: e.g. 30% at L1, 60% at L2, ...
  exact_distribution <- native_long |>
    filter(is.finite(native_level)) |>
    count(section, native_level, name = "n_sites") |>
    group_by(section) |>
    mutate(
      n_known = sum(n_sites),
      proportion_exact = n_sites / n_known
    ) |>
    ungroup()

  readr::write_csv(
    exact_distribution,
    file.path(
      OUTPUT_DIR,
      "08_native_exact_level_distribution.csv"
    )
  )

  p_native_exact <- exact_distribution |>
    mutate(
      section_label = factor(
        SECTION_LABELS[section],
        levels = unname(SECTION_LABELS)
      ),
      native_level = factor(native_level)
    ) |>
    ggplot(
      aes(x = section_label, y = native_level, fill = proportion_exact)
    ) +
    geom_tile(linewidth = 0.3) +
    geom_text(
      aes(label = sprintf("%.0f%%", 100 * proportion_exact)),
      size = 3
    ) +
    labs(
      title = "Native skeletal-resolution distribution",
      subtitle = paste0(
        "Percentage of sites originally supporting each exact level ",
        "before upward imputation."
      ),
      x = "Skeletal section",
      y = "Native detail level",
      fill = "Proportion"
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )

  print(p_native_exact)

  ggsave(
    file.path(
      OUTPUT_DIR,
      "figure_native_exact_level_distribution.png"
    ),
    p_native_exact,
    width = 12,
    height = 6.5,
    dpi = 350,
    bg = "white"
  )

  # Cumulative support:
  # P(native_level >= requested target level)
  max_tested <- runs |>
    summarise(across(all_of(SECTIONS), max, na.rm = TRUE))

  support_rows <- list()

  for (sec in SECTIONS) {
    x <- native[[sec]]
    x <- x[is.finite(x)]

    max_lev <- as.integer(max_tested[[sec]][1])

    for (lev in seq_len(max_lev)) {
      support_rows[[length(support_rows) + 1]] <- tibble(
        section = sec,
        target_level = lev,
        n_known = length(x),
        n_native_support = sum(x >= lev),
        native_support_fraction =
          ifelse(length(x), mean(x >= lev), NA_real_),
        upward_imputation_fraction =
          ifelse(length(x), mean(x < lev), NA_real_),
        mean_upward_steps =
          ifelse(length(x), mean(pmax(0, lev - x)), NA_real_)
      )
    }
  }

  support <- bind_rows(support_rows)

  readr::write_csv(
    support,
    file.path(
      OUTPUT_DIR,
      "09_native_support_and_imputation_by_section_level.csv"
    )
  )

  p_support <- support |>
    mutate(
      section_label = factor(
        SECTION_LABELS[section],
        levels = unname(SECTION_LABELS)
      ),
      target_level = factor(target_level)
    ) |>
    ggplot(
      aes(
        x = section_label,
        y = target_level,
        fill = native_support_fraction
      )
    ) +
    geom_tile(linewidth = 0.3) +
    geom_text(
      aes(
        label = paste0(
          sprintf("%.0f%%", 100 * native_support_fraction),
          "\nn=", n_known
        )
      ),
      size = 2.8
    ) +
    labs(
      title = "Native support for each requested analytical level",
      subtitle = paste0(
        "Cell = proportion of sites with native resolution >= requested ",
        "level; no upward imputation required for those sites."
      ),
      x = "Skeletal section",
      y = "Requested detail level",
      fill = "Native support"
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )

  print(p_support)

  ggsave(
    file.path(
      OUTPUT_DIR,
      "figure_native_support_by_requested_level.png"
    ),
    p_support,
    width = 12,
    height = 6.5,
    dpi = 350,
    bg = "white"
  )

  # ------------------------------------------------------------
  # 6a. Vector-level imputation burden
  #
  # Equal-weight site x section definition:
  #   fraction_site_section_imputed
  #       = proportion of known site-section cells where requested > native
  #
  #   mean_upward_steps
  #       = mean(max(0, requested - native))
  #
  #   fraction_sites_any_imputation
  #       = proportion of sites requiring upward imputation in >=1 section
  #
  # If your actual imputation operates at bone-count level, a future
  # imputation_audit.csv should replace this equal-site proxy with a
  # count-weighted burden.
  # ------------------------------------------------------------

  native_mat <- as.matrix(native[, SECTIONS])
  storage.mode(native_mat) <- "numeric"

  calc_burden <- function(row) {
    target <- as.numeric(row[SECTIONS])

    delta <- sweep(
      native_mat,
      MARGIN = 2,
      STATS = target,
      FUN = function(native_value, target_value) {
        target_value - native_value
      }
    )

    valid <- is.finite(delta)
    need <- valid & delta > 0
    upsteps <- ifelse(valid, pmax(delta, 0), NA_real_)

    site_any <- apply(need, 1, any)
    sections_per_site <- rowSums(need, na.rm = TRUE)

    tibble(
      fraction_site_section_imputed =
        sum(need, na.rm = TRUE) / sum(valid),
      mean_upward_steps =
        mean(upsteps[valid], na.rm = TRUE),
      fraction_sites_any_imputation =
        mean(site_any),
      mean_sections_imputed_per_site =
        mean(sections_per_site),
      n_known_site_section_cells =
        sum(valid)
    )
  }

  burden_list <- vector("list", nrow(runs))

  for (i in seq_len(nrow(runs))) {
    if (i %% 250 == 0 || i == 1 || i == nrow(runs)) {
      cat(
        "Calculating imputation burden ",
        i, " / ", nrow(runs), "\n",
        sep = ""
      )
    }

    burden_list[[i]] <- calc_burden(runs[i, ])
  }

  burden <- bind_cols(
    runs |>
      select(
        folder_name, task, variant, model, level_vector,
        all_of(SECTIONS), total_detail,
        accuracy_mean, accuracy_se, accuracy_sd, cv_n,
        mtry, trees, min_n
      ),
    bind_rows(burden_list)
  )

  # Pareto frontier: maximize accuracy, minimize imputation burden.
  pareto_flag <- function(acc, burden) {
    n <- length(acc)
    keep <- rep(TRUE, n)

    for (i in seq_len(n)) {
      dominates_i <- (
        acc >= acc[i] &
        burden <= burden[i] &
        (acc > acc[i] | burden < burden[i])
      )
      dominates_i[i] <- FALSE
      if (any(dominates_i, na.rm = TRUE)) keep[i] <- FALSE
    }

    keep
  }

  burden <- burden |>
    group_by(task) |>
    mutate(
      pareto = pareto_flag(
        accuracy_mean,
        fraction_site_section_imputed
      )
    ) |>
    ungroup()

  readr::write_csv(
    burden,
    file.path(
      OUTPUT_DIR,
      "10_run_accuracy_and_imputation_burden.csv"
    )
  )

  pareto <- burden |>
    filter(pareto) |>
    arrange(task, fraction_site_section_imputed, desc(accuracy_mean))

  readr::write_csv(
    pareto,
    file.path(
      OUTPUT_DIR,
      "11_pareto_efficient_vectors.csv"
    )
  )

  # Candidate vectors.
  # These are descriptive candidates, NOT a claim of universal optimality.
  candidate_rows <- list()

  for (task_name in unique(burden$task)) {
    d <- burden |>
      filter(task == task_name) |>
      arrange(desc(accuracy_mean))

    best <- d |> slice(1)

    within_half_point <- d |>
      filter(accuracy_mean >= best$accuracy_mean - 0.005) |>
      arrange(
        fraction_site_section_imputed,
        desc(accuracy_mean)
      ) |>
      slice(1)

    threshold_1se <- ifelse(
      is.finite(best$accuracy_se),
      best$accuracy_mean - best$accuracy_se,
      best$accuracy_mean - 0.005
    )

    within_1se <- d |>
      filter(accuracy_mean >= threshold_1se) |>
      arrange(
        fraction_site_section_imputed,
        desc(accuracy_mean)
      ) |>
      slice(1)

    pf <- d |> filter(pareto)

    if (nrow(pf) > 0) {
      acc_rng <- range(pf$accuracy_mean, na.rm = TRUE)
      bur_rng <- range(
        pf$fraction_site_section_imputed,
        na.rm = TRUE
      )

      norm01 <- function(x, rng) {
        if (!is.finite(diff(rng)) || diff(rng) == 0) {
          return(rep(0.5, length(x)))
        }
        (x - rng[1]) / diff(rng)
      }

      pf <- pf |>
        mutate(
          acc_norm = norm01(accuracy_mean, acc_rng),
          burden_norm = norm01(
            fraction_site_section_imputed,
            bur_rng
          ),
          distance_to_ideal =
            sqrt((1 - acc_norm)^2 + burden_norm^2)
        ) |>
        arrange(distance_to_ideal)

      closest_ideal <- pf |> slice(1)
    } else {
      closest_ideal <- best
    }

    add_candidate <- function(x, rule) {
      x |>
        mutate(selection_rule = rule) |>
        select(
          selection_rule,
          everything()
        )
    }

    candidate_rows[[length(candidate_rows) + 1]] <-
      add_candidate(best, "maximum_observed_accuracy")

    candidate_rows[[length(candidate_rows) + 1]] <-
      add_candidate(
        within_half_point,
        "lowest_imputation_within_0.5_percentage_points_of_best"
      )

    candidate_rows[[length(candidate_rows) + 1]] <-
      add_candidate(
        within_1se,
        "lowest_imputation_within_1SE_of_best"
      )

    candidate_rows[[length(candidate_rows) + 1]] <-
      add_candidate(
        closest_ideal,
        "closest_to_accuracy_imputation_ideal_on_pareto_front"
      )
  }

  candidates <- bind_rows(candidate_rows)

  readr::write_csv(
    candidates,
    file.path(
      OUTPUT_DIR,
      "12_candidate_operating_vectors_descriptive.csv"
    )
  )

  # ------------------------------------------------------------
  # 6b. Trade-off plots
  # ------------------------------------------------------------

  for (task_name in unique(burden$task)) {
    d <- burden |> filter(task == task_name)
    pf <- d |>
      filter(pareto) |>
      arrange(fraction_site_section_imputed)

    p_trade <- ggplot(
      d,
      aes(
        x = fraction_site_section_imputed,
        y = accuracy_mean
      )
    ) +
      geom_point(alpha = 0.35, size = 1.5) +
      geom_point(
        data = pf,
        size = 2.5,
        shape = 21,
        stroke = 0.9
      ) +
      geom_line(
        data = pf,
        aes(
          x = fraction_site_section_imputed,
          y = accuracy_mean
        ),
        linewidth = 0.7
      ) +
      labs(
        title = paste0(
          "Accuracy vs upward-imputation burden - ",
          task_name
        ),
        subtitle = paste0(
          "Each point = one tested level vector. ",
          "Outlined points = Pareto-efficient vectors."
        ),
        x = paste0(
          "Fraction of known site-section cells requiring ",
          "upward imputation"
        ),
        y = "Cross-validated accuracy"
      ) +
      theme_minimal(base_size = 11) +
      theme(panel.grid.minor = element_blank())

    print(p_trade)

    ggsave(
      file.path(
        OUTPUT_DIR,
        paste0(
          "figure_accuracy_vs_imputation_burden_",
          task_name,
          ".png"
        )
      ),
      p_trade,
      width = 9,
      height = 6,
      dpi = 350,
      bg = "white"
    )

    # Side-by-side: adjusted accuracy map vs native support map
    perf_data <- section_means |>
      filter(task == task_name) |>
      mutate(
        section_label = factor(
          SECTION_LABELS[section],
          levels = unname(SECTION_LABELS)
        ),
        level_factor = factor(level)
      )

    p_perf <- ggplot(
      perf_data,
      aes(
        x = section_label,
        y = level_factor,
        fill = adjusted_mean
      )
    ) +
      geom_tile(linewidth = 0.3) +
      geom_text(
        aes(label = sprintf("%.3f", adjusted_mean)),
        size = 2.8
      ) +
      labs(
        title = "A. Adjusted classification performance",
        x = "Skeletal section",
        y = "Requested detail level",
        fill = "Accuracy"
      ) +
      theme_minimal(base_size = 10) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      )

    support_plot_data <- support |>
      mutate(
        section_label = factor(
          SECTION_LABELS[section],
          levels = unname(SECTION_LABELS)
        ),
        level_factor = factor(target_level)
      )

    p_sup <- ggplot(
      support_plot_data,
      aes(
        x = section_label,
        y = level_factor,
        fill = native_support_fraction
      )
    ) +
      geom_tile(linewidth = 0.3) +
      geom_text(
        aes(
          label = sprintf(
            "%.0f%%",
            100 * native_support_fraction
          )
        ),
        size = 2.8
      ) +
      labs(
        title = "B. Native empirical support",
        x = "Skeletal section",
        y = "Requested detail level",
        fill = "Native support"
      ) +
      theme_minimal(base_size = 10) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      )

    combined <- p_perf + p_sup +
      patchwork::plot_annotation(
        title = paste0(
          "Resolution-performance trade-off - ",
          task_name
        ),
        subtitle = paste0(
          "Left: performance after adjustment for other sections and ",
          "varying RF hyperparameters. Right: proportion of original ",
          "site profiles that support the requested level without ",
          "upward imputation."
        )
      )

    print(combined)

    ggsave(
      file.path(
        OUTPUT_DIR,
        paste0(
          "figure_side_by_side_performance_native_support_",
          task_name,
          ".png"
        )
      ),
      combined,
      width = 16,
      height = 7.5,
      dpi = 350,
      bg = "white"
    )
  }
}

# ----------------------------------------------------------------------
# 7. Short automatic notes
# ----------------------------------------------------------------------

notes <- c(
  "# Resolution / performance / imputation analysis",
  "",
  paste0("Result folders scanned: ", length(result_dirs)),
  paste0("Usable runs extracted: ", nrow(runs)),
  "",
  "## Interpretation rules",
  "",
  paste0(
    "- `accuracy_mean` is the saved cross-validated mean for each tested ",
    "level vector."
  ),
  paste0(
    "- If `n_hyperparameter_combos = 1`, the folder does not contain a ",
    "hyperparameter landscape; it contains only one RF configuration."
  ),
  paste0(
    "- When RF hyperparameters vary among level-vector runs, the adjusted ",
    "models include available mtry, trees, and min_n covariates."
  ),
  paste0(
    "- The 1,000 level vectors are unique representation configurations, ",
    "not 1,000 independent archaeological datasets."
  ),
  paste0(
    "- Native-support and imputation-burden outputs are produced only when ",
    "`native_resolution_by_site.csv` is available."
  ),
  paste0(
    "- The site-level imputation burden is a proxy. If the actual loader ",
    "randomly reallocates individual skeletal counts, a count-level ",
    "imputation audit is preferable."
  ),
  paste0(
    "- Pareto and candidate-vector outputs are descriptive tools for ",
    "choosing representations to validate; they do not prove a universal ",
    "optimal vector."
  )
)

writeLines(
  notes,
  file.path(OUTPUT_DIR, "README_INTERPRETATION.md"),
  useBytes = TRUE
)

cat("\nDone.\nOutputs saved in:\n", OUTPUT_DIR, "\n", sep = "")
