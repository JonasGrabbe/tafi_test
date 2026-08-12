# =====================================================================
# q1_level_accuracy_analysis.R
#
# Version 4: empirical-standardization section effects; EMMeans is not used.
# Paper-oriented analysis of how skeletal-section detail levels affect
# cross-validated classification performance.
#
# Input (beside this script):
#   accuracy_f1_RandomForest_by_level.csv
#
# Required columns:
#   task, level, f1_mean,
#   cranium, teeth, hyoid, vertebrae, thorax, shoulder,
#   arms, hands, pelvic, legs, foot
#
# Main questions:
#   1) Does total representational detail predict performance?
#   2) Which section-specific levels affect performance after adjustment
#      for all other varying sections?
#   3) Are the effects linear, nonlinear, task-specific, and practically
#      meaningful rather than merely statistically significant?
#
# Output folder (created beside this script):
#   results_q1_level_accuracy/
#
# The script prints each plot in an interactive R/RStudio session and saves
# publication-resolution PNG and vector PDF files.
# =====================================================================

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
INPUT_CSV <- file.path(PROJECT_ROOT, "accuracy_f1_RandomForest_by_level.csv")
OUTPUT_DIR <- file.path(PROJECT_ROOT, "results_q1_level_accuracy")

cat("SCRIPT VERSION: V4_NO_EMMEANS\n")
cat("This script does not call emmeans::emmeans().\n")

# The integrity check is retained for reproducibility but is quiet by default.
# It verifies the sample size; it does not test whether detail affects accuracy.
STRICT_EXPECTED_N <- FALSE
PRINT_INTEGRITY_TABLE <- FALSE
EXPECTED_N_PER_TASK <- 1000L
SEED <- 20260714L

# accuracy_by_level.R extracts the row class == "accuracy" and stores it in
# the column f1_mean. Therefore the scientific label is "accuracy", although
# the historical column name is f1_mean. Change these two settings only if
# the input is rebuilt from a true macro-F1 row.
OUTCOME_COL <- "f1_mean"
OUTCOME_LABEL <- "Cross-validated accuracy"

dir.create(OUTPUT_DIR, recursive = TRUE, showWarnings = FALSE)
if (!dir.exists(OUTPUT_DIR)) stop("Could not create output folder: ", OUTPUT_DIR)

required_packages <- c(
  "readr", "dplyr", "tidyr", "ggplot2", "mgcv",
  "sandwich", "lmtest", "car", "patchwork"
)
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop(
    "Missing R package(s): ", paste(missing_packages, collapse = ", "),
    "\nInstall them with:\ninstall.packages(c(",
    paste(sprintf('"%s"', missing_packages), collapse = ", "), "))"
  )
}

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(mgcv)
  library(sandwich)
  library(lmtest)
  library(car)
  library(patchwork)
})

PART_COLS <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax",
  "shoulder", "arms", "hands", "pelvic", "legs", "foot"
)
PART_LABELS <- c(
  "Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
  "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot"
)
PART_LOOKUP <- data.frame(
  section = PART_COLS,
  section_label = PART_LABELS,
  stringsAsFactors = FALSE
)

safe_name <- function(x) gsub("[^A-Za-z0-9._-]+", "_", x)

save_plot_pair <- function(plot_object, stem, width, height) {
  png_path <- file.path(OUTPUT_DIR, paste0(stem, ".png"))
  pdf_path <- file.path(OUTPUT_DIR, paste0(stem, ".pdf"))

  if (interactive()) print(plot_object)

  ggplot2::ggsave(
    filename = png_path, plot = plot_object,
    width = width, height = height, dpi = 400, bg = "white"
  )
  ggplot2::ggsave(
    filename = pdf_path, plot = plot_object,
    width = width, height = height, device = grDevices::cairo_pdf,
    bg = "white"
  )

  cat("Saved: ", normalizePath(png_path, winslash = "/"), "\n", sep = "")
  cat("Saved: ", normalizePath(pdf_path, winslash = "/"), "\n", sep = "")
  invisible(c(png_path, pdf_path))
}

if (!file.exists(INPUT_CSV)) {
  stop("Input CSV not found: ", normalizePath(INPUT_CSV, winslash = "/", mustWork = FALSE))
}

cat("Input CSV   : ", normalizePath(INPUT_CSV, winslash = "/"), "\n", sep = "")
cat("Output folder: ", normalizePath(OUTPUT_DIR, winslash = "/"), "\n\n", sep = "")

raw <- readr::read_csv(INPUT_CSV, show_col_types = FALSE)
required_cols <- c("task", "level", OUTCOME_COL, PART_COLS)
missing_cols <- setdiff(required_cols, names(raw))
if (length(missing_cols)) {
  stop("Missing required column(s): ", paste(missing_cols, collapse = ", "))
}

df <- raw |>
  mutate(
    across(all_of(c(OUTCOME_COL, PART_COLS)), ~ suppressWarnings(as.numeric(.))),
    .outcome = .data[[OUTCOME_COL]],
    sum_level = rowSums(across(all_of(PART_COLS)), na.rm = FALSE)
  )

if (any(!is.finite(df$.outcome))) stop("Outcome contains missing/non-finite values.")
if (any(!is.finite(df$sum_level))) stop("One or more level vectors contain missing/non-numeric values.")
if (any(df$.outcome < 0 | df$.outcome > 1)) stop("Outcome must be between 0 and 1.")

# ---------------------------------------------------------------------
# 1. Data-integrity checks: verify that 1,000 distinct vectors are present
# ---------------------------------------------------------------------
quality <- df |>
  group_by(task) |>
  summarise(
    n_rows = n(),
    n_unique_vectors = n_distinct(level),
    n_duplicate_rows = n_rows - n_unique_vectors,
    expected_n = EXPECTED_N_PER_TASK,
    complete = n_rows == EXPECTED_N_PER_TASK &
               n_unique_vectors == EXPECTED_N_PER_TASK,
    .groups = "drop"
  )
readr::write_csv(quality, file.path(OUTPUT_DIR, "01_sample_size_and_integrity.csv"))
if (isTRUE(PRINT_INTEGRITY_TABLE)) print(quality)

if (isTRUE(STRICT_EXPECTED_N) && any(!quality$complete)) {
  stop(
    "The script is configured to require exactly ", EXPECTED_N_PER_TASK,
    " unique level vectors per task. See 01_sample_size_and_integrity.csv.\n",
    paste(
      sprintf("%s: rows=%d, unique=%d", quality$task,
              quality$n_rows, quality$n_unique_vectors),
      collapse = "\n"
    )
  )
}
if (any(quality$n_duplicate_rows > 0)) {
  stop("Duplicate task/level vectors detected; inference would overweight duplicates.")
}

# ---------------------------------------------------------------------
# Helpers for inferential analysis
# ---------------------------------------------------------------------
fit_overall_models <- function(d, task_name) {
  lm_fit <- lm(.outcome ~ sum_level, data = d)
  robust_vcov <- sandwich::vcovHC(lm_fit, type = "HC3")
  robust_test <- lmtest::coeftest(lm_fit, vcov. = robust_vcov)
  robust_ci <- lmtest::coefci(lm_fit, vcov. = robust_vcov, level = 0.95)

  slope <- unname(robust_test["sum_level", "Estimate"])
  slope_se <- unname(robust_test["sum_level", "Std. Error"])
  slope_p <- unname(robust_test["sum_level", "Pr(>|t|)"])
  slope_low <- unname(robust_ci["sum_level", 1])
  slope_high <- unname(robust_ci["sum_level", 2])

  rho_test <- suppressWarnings(
    cor.test(d$sum_level, d$.outcome, method = "spearman", exact = FALSE)
  )

  unique_x <- dplyr::n_distinct(d$sum_level)
  gam_fit <- NULL
  gam_edf <- NA_real_
  gam_p <- NA_real_
  gam_deviance <- NA_real_
  gam_aic <- NA_real_

  if (unique_x >= 6) {
    gam_fit <- mgcv::gam(
      .outcome ~ s(sum_level, k = 5, bs = "cr"),
      data = d, method = "REML"
    )
    gam_summary <- summary(gam_fit)
    gam_edf <- unname(gam_summary$s.table[1, "edf"])
    gam_p <- unname(gam_summary$s.table[1, "p-value"])
    gam_deviance <- unname(gam_summary$dev.expl)
    gam_aic <- AIC(gam_fit)
  }

  list(
    lm_fit = lm_fit,
    gam_fit = gam_fit,
    row = tibble(
      task = task_name,
      n = nrow(d),
      n_unique_sum_values = unique_x,
      slope_per_1_level = slope,
      slope_hc3_se = slope_se,
      slope_hc3_ci_low = slope_low,
      slope_hc3_ci_high = slope_high,
      slope_hc3_p = slope_p,
      effect_per_5_levels = 5 * slope,
      effect_per_5_ci_low = 5 * slope_low,
      effect_per_5_ci_high = 5 * slope_high,
      adjusted_r2 = summary(lm_fit)$adj.r.squared,
      spearman_rho = unname(rho_test$estimate),
      spearman_p = rho_test$p.value,
      gam_edf = gam_edf,
      gam_p = gam_p,
      gam_deviance_explained = gam_deviance,
      lm_aic = AIC(lm_fit),
      gam_aic = gam_aic
    )
  )
}

fit_section_model <- function(d, task_name) {
  varying <- PART_COLS[
    vapply(PART_COLS, function(x) dplyr::n_distinct(d[[x]]) > 1, logical(1))
  ]
  constant <- setdiff(PART_COLS, varying)

  model_data <- d
  for (x in varying) {
    model_data[[x]] <- factor(
      model_data[[x]], levels = sort(unique(model_data[[x]]))
    )
  }

  model_formula <- reformulate(varying, response = ".outcome")
  fit <- lm(model_formula, data = model_data)
  robust_vcov <- sandwich::vcovHC(fit, type = "HC3")

  # Type-II global tests ask whether any level of a section contributes after
  # controlling for all other varying sections. HC3 protects against
  # heteroskedastic residuals.
  global_raw <- as.data.frame(
    car::Anova(fit, type = 2, white.adjust = "hc3")
  )
  global_raw$section <- rownames(global_raw)
  rownames(global_raw) <- NULL

  f_col <- grep("^F", names(global_raw), value = TRUE)[1]
  p_col <- grep("Pr\\(>F\\)", names(global_raw), value = TRUE)[1]
  df_col <- grep("^Df$", names(global_raw), value = TRUE)[1]

  global <- tibble(
    task = task_name,
    section = global_raw$section,
    df1 = global_raw[[df_col]],
    df2 = df.residual(fit),
    F_hc3 = global_raw[[f_col]],
    p = global_raw[[p_col]]
  ) |>
    mutate(
      p_fdr = p.adjust(p, method = "BH"),
      partial_eta2 = (F_hc3 * df1) / (F_hc3 * df1 + df2),
      significant_fdr = p_fdr < 0.05
    )

  if (length(constant)) {
    global <- bind_rows(
      global,
      tibble(
        task = task_name, section = constant, df1 = NA_real_,
        df2 = df.residual(fit), F_hc3 = NA_real_, p = NA_real_,
        p_fdr = NA_real_, partial_eta2 = NA_real_,
        significant_fdr = FALSE
      )
    )
  }

  contrast_list <- list()
  adjusted_mean_list <- list()

  raw_counts <- d |>
    select(all_of(PART_COLS)) |>
    pivot_longer(everything(), names_to = "section", values_to = "level") |>
    count(section, level, name = "n")

  # Empirical-standardization helper. For one target section and level, set
  # that section to the requested level for every observed vector, retain the
  # observed values of all other sections, and average the model predictions.
  # This estimates an adjusted marginal mean without constructing the full
  # Cartesian reference grid (162,000 combinations in this dataset).
  standardized_row <- function(sec, lev) {
    nd <- model_data
    nd[[sec]] <- factor(as.character(lev), levels = levels(model_data[[sec]]))

    X <- model.matrix(
      stats::delete.response(stats::terms(fit)),
      data = nd,
      contrasts.arg = fit$contrasts
    )

    beta <- stats::coef(fit)
    if (anyNA(beta)) {
      stop(
        "Aliased coefficients detected in the section model for task '",
        task_name, "'. Remove redundant predictors before inference."
      )
    }

    X <- X[, names(beta), drop = FALSE]
    a <- colMeans(X)
    estimate <- as.numeric(crossprod(a, beta))
    variance <- as.numeric(t(a) %*% robust_vcov %*% a)
    se <- sqrt(max(variance, 0))
    df_res <- stats::df.residual(fit)
    crit <- stats::qt(0.975, df = df_res)

    list(
      level = suppressWarnings(as.numeric(as.character(lev))),
      a = a,
      estimate = estimate,
      se = se,
      df = df_res,
      ci_low = estimate - crit * se,
      ci_high = estimate + crit * se
    )
  }

  for (sec in varying) {
    factor_levels <- levels(model_data[[sec]])
    rows <- lapply(factor_levels, function(lev) standardized_row(sec, lev))
    names(rows) <- factor_levels

    adjusted_mean_list[[sec]] <- bind_rows(lapply(rows, function(z) {
      tibble(
        task = task_name,
        section = sec,
        level = z$level,
        adjusted_mean = z$estimate,
        robust_se = z$se,
        ci_low = z$ci_low,
        ci_high = z$ci_high,
        estimability = "empirically standardized"
      )
    }))

    reference_level_chr <- factor_levels[1]
    reference <- rows[[reference_level_chr]]

    if (length(factor_levels) > 1) {
      contrast_list[[sec]] <- bind_rows(lapply(factor_levels[-1], function(lev) {
        current <- rows[[lev]]
        delta_a <- current$a - reference$a
        estimate <- as.numeric(crossprod(delta_a, stats::coef(fit)))
        variance <- as.numeric(t(delta_a) %*% robust_vcov %*% delta_a)
        se <- sqrt(max(variance, 0))
        df_res <- stats::df.residual(fit)
        statistic <- if (se > 0) estimate / se else NA_real_
        p_value <- if (is.finite(statistic)) {
          2 * stats::pt(-abs(statistic), df = df_res)
        } else {
          NA_real_
        }
        crit <- stats::qt(0.975, df = df_res)

        tibble(
          task = task_name,
          section = sec,
          level = suppressWarnings(as.numeric(as.character(lev))),
          reference_level = suppressWarnings(as.numeric(reference_level_chr)),
          contrast = paste0(sec, ": level ", lev, " - level ", reference_level_chr),
          estimate = estimate,
          robust_se = se,
          df = df_res,
          ci_low = estimate - crit * se,
          ci_high = estimate + crit * se,
          p = p_value
        )
      }))
    }
  }

  contrasts <- bind_rows(contrast_list) |>
    mutate(
      p_fdr = p.adjust(p, method = "BH"),
      significant_fdr = !is.na(p_fdr) & p_fdr < 0.05
    )

  adjusted_means <- bind_rows(adjusted_mean_list)

  # Preserve constant sections in the section x level map, but label them as
  # non-estimable effects because there is no variation to test.
  if (length(constant)) {
    constant_rows <- lapply(constant, function(sec) {
      lev <- unique(d[[sec]])
      tibble(
        task = task_name,
        section = sec,
        level = lev[1],
        adjusted_mean = mean(d$.outcome),
        robust_se = NA_real_, ci_low = NA_real_, ci_high = NA_real_,
        estimability = "constant; effect not estimable"
      )
    }) |>
      bind_rows()
    adjusted_means <- bind_rows(adjusted_means, constant_rows)
  }

  adjusted_means <- adjusted_means |>
    left_join(raw_counts, by = c("section", "level"))

  list(
    fit = fit,
    varying = varying,
    constant = constant,
    global = global,
    contrasts = contrasts,
    adjusted_means = adjusted_means
  )
}

# ---------------------------------------------------------------------
# 2. Run analyses per task
# ---------------------------------------------------------------------
set.seed(SEED)
all_overall <- list()
all_global <- list()
all_contrasts <- list()
all_adjusted_means <- list()
all_saved <- character(0)

for (task_name in sort(unique(df$task))) {
  d <- df |> filter(task == task_name)
  n_task <- nrow(d)
  safe_task <- safe_name(task_name)

  overall <- fit_overall_models(d, task_name)
  sections <- fit_section_model(d, task_name)

  all_overall[[task_name]] <- overall$row
  all_global[[task_name]] <- sections$global
  all_contrasts[[task_name]] <- sections$contrasts
  all_adjusted_means[[task_name]] <- sections$adjusted_means

  # -------------------------------------------------------------------
  # Figure A: total detail. Every row is plotted once. The linear model
  # is the interpretable primary trend; the GAM is a nonlinear check.
  # -------------------------------------------------------------------
  s <- overall$row
  annotation <- sprintf(
    paste0(
      "N = %d unique vectors; HC3 slope = %.4f per level ",
      "(95%% CI %.4f to %.4f); adjusted R² = %.3f; ",
      "Spearman rho = %.3f; GAM deviance explained = %.1f%%"
    ),
    s$n, s$slope_per_1_level, s$slope_hc3_ci_low,
    s$slope_hc3_ci_high, s$adjusted_r2, s$spearman_rho,
    100 * s$gam_deviance_explained
  )

  p_overall <- ggplot(d, aes(x = sum_level, y = .outcome)) +
    geom_point(
      position = position_jitter(width = 0.14, height = 0, seed = SEED),
      alpha = 0.38, size = 1.5
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = TRUE, linewidth = 0.9) +
    labs(
      title = paste0("A. Total skeletal detail and performance - ", task_name),
      subtitle = annotation,
      x = "Sum of the 11-section level vector",
      y = OUTCOME_LABEL,
      caption = paste0(
        "Exactly ", n_task, " points are drawn. Horizontal jitter only; ",
        "solid line = linear model with 95% CI; dashed line = GAM nonlinear check."
      )
    ) +
    theme_minimal(base_size = 11) +
    theme(panel.grid.minor = element_blank())

  if (!is.null(overall$gam_fit)) {
    p_overall <- p_overall +
      geom_smooth(
        method = "gam", formula = y ~ s(x, k = 5, bs = "cr"),
        method.args = list(method = "REML"),
        se = FALSE, linetype = 2, linewidth = 0.9
      )
  }

  # -------------------------------------------------------------------
  # Figure B: adjusted section-level effects. This is the central
  # inferential figure. It avoids the mathematical collinearity that would
  # occur if sum_level and all section levels were entered together.
  # -------------------------------------------------------------------
  ctr <- sections$contrasts |>
    left_join(PART_LOOKUP, by = "section") |>
    mutate(
      effect_label = paste0(
        section_label, ": level ", level,
        " vs level ", reference_level
      ),
      effect_label = factor(effect_label, levels = rev(effect_label)),
      fdr_result = ifelse(significant_fdr, "BH-FDR q < 0.05", "not significant")
    )

  p_adjusted <- ggplot(ctr, aes(x = estimate, y = effect_label)) +
    geom_vline(xintercept = 0, linetype = 2, linewidth = 0.5) +
    geom_errorbarh(
      aes(xmin = ci_low, xmax = ci_high),
      height = 0.18, linewidth = 0.55
    ) +
    geom_point(aes(shape = fdr_result), size = 2.3) +
    scale_shape_manual(values = c("BH-FDR q < 0.05" = 16, "not significant" = 1)) +
    labs(
      title = "B. Mutually adjusted section-level effects",
      subtitle = paste0(
        "Difference from each section's lowest level, adjusted for all other varying sections; ",
        "HC3 95% CIs; BH correction across ", nrow(ctr), " contrasts"
      ),
      x = paste0("Adjusted change in ", tolower(OUTCOME_LABEL)),
      y = NULL,
      shape = NULL,
      caption = paste0(
        "Positive values indicate higher performance than the section-specific baseline. ",
        "Constant sections: ",
        ifelse(length(sections$constant),
               paste(PART_LABELS[match(sections$constant, PART_COLS)], collapse = ", "),
               "none"), "."
      )
    ) +
    theme_minimal(base_size = 10) +
    theme(
      panel.grid.minor = element_blank(),
      legend.position = "bottom"
    )

  main_figure <- p_overall / p_adjusted +
    patchwork::plot_layout(heights = c(1, 1.65)) +
    patchwork::plot_annotation(
      title = paste0("Level-vector resolution and classification performance: ", task_name),
      subtitle = paste0(
        "Primary summary-level analysis; N = ", n_task,
        " unique randomly sampled level vectors"
      )
    )

  all_saved <- c(
    all_saved,
    save_plot_pair(
      main_figure,
      paste0("figure_main_total_and_adjusted_sections_", safe_task),
      width = 12, height = 14
    )
  )

  # -------------------------------------------------------------------
  # Supplementary raw response plot: 1,000 points in EACH section panel.
  # Means and descriptive 95% CIs are shown, but formal inference comes
  # from the adjusted model above.
  # -------------------------------------------------------------------
  long <- d |>
    select(task, level, .outcome, all_of(PART_COLS)) |>
    pivot_longer(
      cols = all_of(PART_COLS), names_to = "section", values_to = "detail_level"
    ) |>
    left_join(PART_LOOKUP, by = "section") |>
    mutate(
      section_label = factor(section_label, levels = PART_LABELS),
      detail_level_factor = factor(detail_level, levels = sort(unique(detail_level)))
    )

  raw_summary <- long |>
    group_by(section, section_label, detail_level) |>
    summarise(
      n = n(),
      mean = mean(.outcome),
      sd = sd(.outcome),
      se = sd / sqrt(n),
      ci_low = mean - qt(0.975, pmax(n - 1, 1)) * se,
      ci_high = mean + qt(0.975, pmax(n - 1, 1)) * se,
      .groups = "drop"
    ) |>
    mutate(detail_level_factor = factor(detail_level))

  p_raw <- ggplot(long, aes(x = factor(detail_level), y = .outcome)) +
    geom_point(
      position = position_jitter(width = 0.16, height = 0, seed = SEED),
      alpha = 0.20, size = 0.7
    ) +
    geom_line(
      data = raw_summary,
      aes(x = detail_level_factor, y = mean, group = 1),
      inherit.aes = FALSE, linewidth = 0.55
    ) +
    geom_pointrange(
      data = raw_summary,
      aes(x = detail_level_factor, y = mean, ymin = ci_low, ymax = ci_high),
      inherit.aes = FALSE, shape = 18, size = 0.35
    ) +
    geom_text(
      data = raw_summary,
      aes(x = detail_level_factor, y = Inf, label = paste0("n=", n)),
      inherit.aes = FALSE, vjust = 1.15, size = 2.4
    ) +
    facet_wrap(~ section_label, ncol = 4, scales = "free_x") +
    labs(
      title = paste0("Raw section-level responses - ", task_name),
      subtitle = paste0(
        "Each panel contains exactly ", n_task,
        " points (one per level vector); diamond and bars = mean and descriptive 95% CI"
      ),
      x = "Section detail level",
      y = OUTCOME_LABEL,
      caption = paste0(
        "Total raw points in this figure = ", n_task * length(PART_COLS),
        ". Empty higher levels are not drawn because section-specific maxima differ."
      )
    ) +
    theme_minimal(base_size = 10) +
    theme(
      panel.grid.minor = element_blank(),
      strip.text = element_text(face = "bold")
    )

  all_saved <- c(
    all_saved,
    save_plot_pair(
      p_raw,
      paste0("figure_supplement_raw_section_responses_", safe_task),
      width = 14, height = 10
    )
  )

  # -------------------------------------------------------------------
  # Creative section x level map: adjusted mean performance in each cell.
  # This merges body section, detail level, actual sample size and accuracy.
  # -------------------------------------------------------------------
  map_data <- sections$adjusted_means |>
    left_join(PART_LOOKUP, by = "section") |>
    mutate(
      section_label = factor(section_label, levels = PART_LABELS),
      level_factor = factor(level, levels = sort(unique(df[PART_COLS] |> unlist()))),
      cell_label = ifelse(
        estimability == "empirically standardized",
        sprintf("%.3f\nn=%d", adjusted_mean, n),
        sprintf("%.3f\nn=%d\nconstant", adjusted_mean, n)
      )
    )

  p_map <- ggplot(map_data, aes(x = section_label, y = level_factor, fill = adjusted_mean)) +
    geom_tile(linewidth = 0.35) +
    geom_text(aes(label = cell_label), size = 3) +
    labs(
      title = paste0("Adjusted section x level performance map - ", task_name),
      subtitle = paste0(
        "Cell value = model-adjusted mean ", tolower(OUTCOME_LABEL),
        "; n = observed vectors at that level"
      ),
      x = "Skeletal section",
      y = "Detail level",
      fill = OUTCOME_LABEL,
      caption = "Constant sections have no estimable level effect and are retained only for completeness."
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )

  all_saved <- c(
    all_saved,
    save_plot_pair(
      p_map,
      paste0("figure_section_by_level_accuracy_map_", safe_task),
      width = 12, height = 6.5
    )
  )
}

# ---------------------------------------------------------------------
# 3. Save statistical tables
# ---------------------------------------------------------------------
overall_results <- bind_rows(all_overall) |>
  mutate(
    slope_p_fdr = p.adjust(slope_hc3_p, method = "BH"),
    spearman_p_fdr = p.adjust(spearman_p, method = "BH")
  )
global_results <- bind_rows(all_global) |>
  left_join(PART_LOOKUP, by = "section") |>
  arrange(task, match(section, PART_COLS))
contrast_results <- bind_rows(all_contrasts) |>
  left_join(PART_LOOKUP, by = "section") |>
  arrange(task, match(section, PART_COLS), level)
adjusted_mean_results <- bind_rows(all_adjusted_means) |>
  left_join(PART_LOOKUP, by = "section") |>
  arrange(task, match(section, PART_COLS), level)

readr::write_csv(overall_results, file.path(OUTPUT_DIR, "02_overall_total_detail_models.csv"))
readr::write_csv(global_results, file.path(OUTPUT_DIR, "03_section_global_tests_HC3_FDR.csv"))
readr::write_csv(contrast_results, file.path(OUTPUT_DIR, "04_section_level_adjusted_contrasts_HC3_FDR.csv"))
readr::write_csv(adjusted_mean_results, file.path(OUTPUT_DIR, "05_section_level_adjusted_means.csv"))

# ---------------------------------------------------------------------
# 4. Automatically generated, cautious results summary
# ---------------------------------------------------------------------
report_path <- file.path(OUTPUT_DIR, "RESULTS_AND_METHODS.md")
con <- file(report_path, open = "wt", encoding = "UTF-8")
write_report <- function(fmt, ...) {
  args <- list(...)
  line <- if (length(args)) do.call(sprintf, c(list(fmt), args)) else fmt
  writeLines(line, con)
}

write_report("# Skeletal detail levels and classification performance\n")
write_report("## Research question\n")
write_report(paste0(
  "Across 1,000 randomly sampled skeletal-section level vectors per task, ",
  "does increasing total representational detail change out-of-sample classification ",
  "performance, and which anatomical sections show independent dose-response effects ",
  "after controlling for the detail levels assigned to all other sections? The analysis ",
  "also asks whether effects are linear or nonlinear, task-specific, and large enough to ",
  "be practically relevant rather than only statistically detectable.\n"
))

write_report("## Primary statistical strategy\n")
write_report(paste0(
  "1. **Data integrity:** sample size and vector uniqueness are recorded for each task; ",
  "duplicates are rejected. The expected design size is ", EXPECTED_N_PER_TASK, ".\n",
  "2. **Whole-vector effect:** ordinary least squares estimates the interpretable change ",
  "in performance per one-unit increase in total detail. HC3 heteroskedasticity-robust ",
  "confidence intervals are primary; Spearman correlation and a REML-fitted GAM are ",
  "sensitivity checks for monotonic and nonlinear structure.\n",
  "3. **Section effects:** all varying sections enter one factor-based multivariable model. ",
  "Type-II HC3 tests assess each section globally; adjusted level contrasts compare each ",
  "level with that section's lowest observed level. Benjamini-Hochberg FDR controls ",
  "multiplicity. Total detail is deliberately excluded from this model because it is the ",
  "exact sum of the section predictors and would cause deterministic collinearity.\n",
  "4. **Effect emphasis:** adjusted R-squared, GAM deviance explained, partial eta-squared, ",
  "estimated changes and 95% CIs are reported alongside p/q values.\n"
))

write_report("## Results by task\n")
for (task_name in sort(unique(df$task))) {
  o <- overall_results |> filter(task == task_name)
  g <- global_results |> filter(task == task_name, !is.na(p_fdr))
  ctab <- contrast_results |> filter(task == task_name)

  sig_g <- g |> filter(p_fdr < 0.05) |> arrange(p_fdr)
  sig_c <- ctab |> filter(p_fdr < 0.05) |> arrange(desc(abs(estimate)))
  top_global <- g |> arrange(desc(partial_eta2)) |> slice(1)
  top_contrast <- ctab |> arrange(desc(abs(estimate))) |> slice(1)

  write_report("### %s\n", task_name)
  write_report(
    paste0(
      "- **Sample:** %d unique vectors.\n",
      "- **Total-detail trend:** slope = %.5f per level (HC3 95%% CI %.5f to %.5f; ",
      "p = %.4g; BH q = %.4g). A five-level increase corresponds to %.4f points of ",
      "performance. Adjusted R-squared = %.3f; Spearman rho = %.3f; GAM edf = %.2f ",
      "and deviance explained = %.1f%%.\n"
    ),
    o$n, o$slope_per_1_level, o$slope_hc3_ci_low, o$slope_hc3_ci_high,
    o$slope_hc3_p, o$slope_p_fdr, o$effect_per_5_levels,
    o$adjusted_r2, o$spearman_rho, o$gam_edf,
    100 * o$gam_deviance_explained
  )

  if (nrow(sig_g)) {
    write_report(
      "- **Adjusted section tests:** %d of %d varying sections remained significant after BH-FDR: %s.\n",
      nrow(sig_g), nrow(g), paste(sig_g$section_label, collapse = ", ")
    )
  } else {
    write_report(
      "- **Adjusted section tests:** no section remained significant after BH-FDR among %d varying sections.\n",
      nrow(g)
    )
  }

  if (nrow(top_global)) {
    write_report(
      "- **Largest global section effect:** %s, partial eta-squared = %.4f, q = %.4g.\n",
      top_global$section_label, top_global$partial_eta2, top_global$p_fdr
    )
  }
  if (nrow(top_contrast)) {
    write_report(
      paste0(
        "- **Largest adjusted level contrast:** %s level %s versus level %s, ",
        "delta = %.4f (95%% CI %.4f to %.4f; q = %.4g).\n"
      ),
      top_contrast$section_label, top_contrast$level,
      top_contrast$reference_level, top_contrast$estimate,
      top_contrast$ci_low, top_contrast$ci_high, top_contrast$p_fdr
    )
  }
  if (!nrow(sig_c)) {
    write_report("- No individual adjusted level contrast survived BH-FDR.\n")
  }
  write_report("")
}

write_report("## Essential limitation for a high-tier paper\n")
write_report(paste0(
  "These 1,000 rows are summary cross-validation scores calculated from repeated reuse of ",
  "the same underlying assemblages. They are therefore not 1,000 independent biological ",
  "observations. The present analysis rigorously characterizes the sampled level-vector ",
  "design space, but conventional standard errors cannot represent all uncertainty created ",
  "by cross-validation and hyperparameter selection. The strongest confirmatory design is ",
  "to save performance for every outer repeat/fold and level vector, use identical outer ",
  "splits across vectors, perform tuning only inside each outer training split, and analyse ",
  "the fold-level outcomes with a paired mixed-effects model (random intercepts for outer ",
  "repeat/fold). An untouched external test set is preferable when available.\n"
))

write_report("## Recommended interpretation rule\n")
write_report(paste0(
  "Treat a result as substantively convincing only when the direction is stable across the ",
  "linear, rank-based and GAM summaries; the adjusted effect and its 95% CI are meaningful ",
  "on the performance scale; multiplicity-controlled q < 0.05; and the pattern persists in ",
  "outer-fold or external-test sensitivity analyses. Do not infer that greater anatomical ",
  "resolution is universally beneficial merely from an unadjusted mean or a visually dense ",
  "parallel-coordinate plot.\n"
))

close(con)

cat("\nAnalysis complete.\n")
cat("Report: ", normalizePath(report_path, winslash = "/"), "\n", sep = "")
cat("All outputs: ", normalizePath(OUTPUT_DIR, winslash = "/"), "\n", sep = "")
