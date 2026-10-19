# =====================================================================
# imputation_burden_analysis.R
#
# Purpose
# -------
# Quantify how much each tested skeletal-resolution vector exceeds the
# site-specific "natural" anatomical resolution and test whether that
# imputation/reconstruction burden predicts classification performance
# independently of total anatomical detail.
#
# PRIMARY NATURAL BASELINE
#   sum = TRUE
#   calc_level = "min"
#   observed sections only (NA sections are NOT treated as observations)
#
# PRIMARY CLASSIFICATION OUTCOMES
#   accuracy_mean
#   macro_f1_mean
#   balanced_accuracy
#
# The historical column f1_mean is NOT used as macro-F1.
#
# Inputs expected beside this script:
#   natural_level_vectors_observed_only.csv
#   accuracy_f1_RandomForest_by_level*.csv
#
# Optional:
#   05_section_level_adjusted_means*.csv
#
# Outputs:
#   results_imputation_burden/
#     01_imputation_burden_by_vector.csv
#     02_adjusted_imputation_models_HC3.csv
#     03_section_level_imputation_exposure.csv
#     04_section_accuracy_vs_imputation.csv      (if optional file exists)
#     05_unadjusted_spearman_correlations.csv
#     RESULTS_IMPUTATION_BURDEN.md
#     figure_*.png / figure_*.pdf
#
# Interpretation
# --------------
# A tested target level greater than a site's natural-min level requires
# upward expansion/reconstruction in tapho.loader. The burden variables
# below quantify the STRUCTURAL EXPOSURE to such reconstruction. They do
# not yet measure the actual count-level reconstruction error.
#
# The strongest model is:
#
#   performance ~ factor(sum_level) + imputed_cell_fraction
#
# factor(sum_level) means the imputation coefficient is estimated by
# comparing vectors with exactly the same total detail score.
# =====================================================================


# ---------------------------------------------------------------------
# 0. Locate script directory and inputs
# ---------------------------------------------------------------------

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)

  if (length(file_arg)) {
    return(dirname(normalizePath(
      sub("^--file=", "", file_arg[1]),
      winslash = "/",
      mustWork = TRUE
    )))
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

ROOT <- get_script_dir()
OUTPUT_DIR <- file.path(ROOT, "results_imputation_burden")
dir.create(OUTPUT_DIR, recursive = TRUE, showWarnings = FALSE)

find_input <- function(exact_name = NULL, regex = NULL, required = TRUE) {
  if (!is.null(exact_name)) {
    exact_path <- file.path(ROOT, exact_name)
    if (file.exists(exact_path)) return(exact_path)
  }

  if (!is.null(regex)) {
    candidates <- list.files(
      ROOT,
      pattern = regex,
      full.names = TRUE,
      ignore.case = TRUE
    )

    if (length(candidates)) {
      # Prefer the shortest basename, which usually selects the unnumbered
      # file if both numbered and unnumbered copies exist.
      candidates <- candidates[
        order(nchar(basename(candidates)), basename(candidates))
      ]
      return(candidates[1])
    }
  }

  if (required) {
    stop(
      "Required input file not found.\n",
      "exact_name: ", ifelse(is.null(exact_name), "<none>", exact_name), "\n",
      "regex: ", ifelse(is.null(regex), "<none>", regex), "\n",
      "Directory: ", ROOT
    )
  }

  NULL
}

NATURAL_FILE <- find_input(
  exact_name = "natural_level_vectors_observed_only.csv",
  regex = "^natural_level_vectors_observed_only.*\\.csv$"
)

CLASSIFICATION_FILE <- find_input(
  exact_name = "accuracy_f1_RandomForest_by_level.csv",
  regex = "^accuracy_f1_RandomForest_by_level.*\\.csv$"
)

ADJUSTED_MEANS_FILE <- find_input(
  exact_name = "05_section_level_adjusted_means.csv",
  regex = "^05_section_level_adjusted_means.*\\.csv$",
  required = FALSE
)


# ---------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------

required_packages <- c(
  "readr", "dplyr", "tidyr", "purrr", "ggplot2",
  "sandwich"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages)) {
  stop(
    "Missing R package(s): ",
    paste(missing_packages, collapse = ", "),
    "\nInstall with:\ninstall.packages(c(",
    paste(sprintf('"%s"', missing_packages), collapse = ", "),
    "))"
  )
}

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(ggplot2)
  library(sandwich)
})


# ---------------------------------------------------------------------
# 2. Constants and input validation
# ---------------------------------------------------------------------

PARTS <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax",
  "shoulder", "arms", "hands", "pelvic", "legs", "foot"
)

PART_LABELS <- c(
  cranium = "Cranium",
  teeth = "Teeth",
  hyoid = "Hyoid",
  vertebrae = "Vertebrae",
  thorax = "Thorax",
  shoulder = "Shoulder",
  arms = "Arm",
  hands = "Hand",
  pelvic = "Pelvis",
  legs = "Leg",
  foot = "Foot"
)

OUTCOMES <- c(
  "accuracy_mean",
  "macro_f1_mean",
  "balanced_accuracy"
)

OUTCOME_LABELS <- c(
  accuracy_mean = "Accuracy",
  macro_f1_mean = "Macro-F1",
  balanced_accuracy = "Balanced accuracy"
)

cat("Natural-level input : ", NATURAL_FILE, "\n", sep = "")
cat("Classification input: ", CLASSIFICATION_FILE, "\n", sep = "")
if (!is.null(ADJUSTED_MEANS_FILE)) {
  cat("Adjusted means input: ", ADJUSTED_MEANS_FILE, "\n", sep = "")
}
cat("Output directory    : ", OUTPUT_DIR, "\n\n", sep = "")

natural_raw <- readr::read_csv(NATURAL_FILE, show_col_types = FALSE)
perf_raw <- readr::read_csv(CLASSIFICATION_FILE, show_col_types = FALSE)

missing_nat <- setdiff(c("sum", "calc_level", PARTS), names(natural_raw))
if (length(missing_nat)) {
  stop(
    "Natural-level file is missing required column(s): ",
    paste(missing_nat, collapse = ", ")
  )
}

missing_perf <- setdiff(c("task", "level", PARTS, OUTCOMES), names(perf_raw))
if (length(missing_perf)) {
  stop(
    "Classification file is missing required column(s): ",
    paste(missing_perf, collapse = ", ")
  )
}

true_flag <- function(x) {
  if (is.logical(x)) return(!is.na(x) & x)
  tolower(trimws(as.character(x))) %in% c("true", "t", "1", "yes")
}


# ---------------------------------------------------------------------
# 3. Natural-min site-level matrix
# ---------------------------------------------------------------------

natural_sites <- natural_raw |>
  mutate(.sum_true = true_flag(.data$sum)) |>
  filter(.sum_true, .data$calc_level == "min") |>
  select(any_of(c(
    "unit_index", "unit_id", "site_id", "site_name",
    PARTS
  )))

if (nrow(natural_sites) == 0) {
  stop(
    "No rows found for sum = TRUE and calc_level = 'min' in ",
    basename(NATURAL_FILE)
  )
}

natural_sites <- natural_sites |>
  mutate(across(all_of(PARTS), as.numeric))

n_sites <- nrow(natural_sites)
n_observed_cells <- sum(!is.na(as.matrix(natural_sites[, PARTS])))

cat("Natural-min site rows          : ", n_sites, "\n", sep = "")
cat("Observed site x section cells  : ", n_observed_cells, "\n\n", sep = "")


# ---------------------------------------------------------------------
# 4. Unique tested level vectors
# ---------------------------------------------------------------------

perf <- perf_raw |>
  mutate(
    across(all_of(c(PARTS, OUTCOMES)), as.numeric),
    sum_level = rowSums(across(all_of(PARTS)), na.rm = FALSE)
  )

if (any(!is.finite(perf$sum_level))) {
  stop("One or more classification level vectors contain non-numeric/missing levels.")
}

if (any(vapply(OUTCOMES, function(z) any(!is.finite(perf[[z]])), logical(1)))) {
  stop("One or more requested classification outcomes contain non-finite values.")
}

vector_table <- perf |>
  distinct(.data$level, across(all_of(PARTS))) |>
  arrange(.data$level)

# Verify that a level string is not mapped to more than one vector.
level_integrity <- perf |>
  group_by(.data$level) |>
  summarise(
    n_vectors = n_distinct(
      interaction(across(all_of(PARTS)), drop = TRUE, lex.order = TRUE)
    ),
    .groups = "drop"
  )

if (any(level_integrity$n_vectors != 1)) {
  stop("At least one `level` identifier maps to more than one skeletal vector.")
}

cat("Unique tested level vectors    : ", nrow(vector_table), "\n\n", sep = "")


# ---------------------------------------------------------------------
# 5. Structural imputation/coarsening burden
# ---------------------------------------------------------------------
#
# For one tested vector V and one observed natural site-section level N:
#
#   upward_steps   = max(V - N, 0)
#   downward_steps = max(N - V, 0)
#
# If V > N, the target asks for finer resolution than the site's natural-min
# level and therefore exposes that site-section to upward reconstruction.
# ---------------------------------------------------------------------

natural_matrix <- as.matrix(natural_sites[, PARTS])
storage.mode(natural_matrix) <- "double"

calculate_vector_burden <- function(target_row) {

  target <- as.numeric(target_row[PARTS])
  names(target) <- PARTS

  # Repeat target across sites.
  target_matrix <- matrix(
    target,
    nrow = n_sites,
    ncol = length(PARTS),
    byrow = TRUE,
    dimnames = list(NULL, PARTS)
  )

  observed <- !is.na(natural_matrix)

  upward <- pmax(target_matrix - natural_matrix, 0)
  downward <- pmax(natural_matrix - target_matrix, 0)

  # pmax() preserves NA where natural level is absent.
  imputed_cells <- observed & target_matrix > natural_matrix
  coarsened_cells <- observed & target_matrix < natural_matrix
  matched_cells <- observed & target_matrix == natural_matrix

  site_any_imputation <- apply(
    imputed_cells,
    1,
    function(x) any(x, na.rm = TRUE)
  )

  site_any_coarsening <- apply(
    coarsened_cells,
    1,
    function(x) any(x, na.rm = TRUE)
  )

  tibble(
    level = as.character(target_row$level),
    sum_level = sum(target),

    observed_site_section_cells = sum(observed),

    imputed_cell_count = sum(imputed_cells, na.rm = TRUE),
    imputed_cell_fraction = mean(imputed_cells[observed]),

    total_upward_steps = sum(upward, na.rm = TRUE),
    mean_upward_steps_per_observed_cell =
      sum(upward, na.rm = TRUE) / sum(observed),

    imputed_site_count = sum(site_any_imputation),
    imputed_site_fraction = mean(site_any_imputation),

    coarsened_cell_count = sum(coarsened_cells, na.rm = TRUE),
    coarsened_cell_fraction = mean(coarsened_cells[observed]),

    total_downward_steps = sum(downward, na.rm = TRUE),
    mean_downward_steps_per_observed_cell =
      sum(downward, na.rm = TRUE) / sum(observed),

    coarsened_site_count = sum(site_any_coarsening),
    coarsened_site_fraction = mean(site_any_coarsening),

    exact_match_cell_count = sum(matched_cells, na.rm = TRUE),
    exact_match_cell_fraction = mean(matched_cells[observed])
  )
}

burden <- purrr::map_dfr(
  seq_len(nrow(vector_table)),
  function(i) calculate_vector_burden(vector_table[i, ])
)

readr::write_csv(
  burden,
  file.path(OUTPUT_DIR, "01_imputation_burden_by_vector.csv")
)

cat("Saved vector-level burden table.\n")


# ---------------------------------------------------------------------
# 6. Section x target-level exposure
# ---------------------------------------------------------------------

section_exposure <- purrr::map_dfr(PARTS, function(sec) {

  observed_natural <- natural_sites[[sec]]
  observed_natural <- observed_natural[!is.na(observed_natural)]

  target_levels <- sort(unique(vector_table[[sec]]))

  purrr::map_dfr(target_levels, function(target) {

    upward <- pmax(target - observed_natural, 0)
    downward <- pmax(observed_natural - target, 0)

    tibble(
      section = sec,
      section_label = unname(PART_LABELS[sec]),
      target_level = target,
      n_sites_section_observed = length(observed_natural),

      fraction_sites_imputed = mean(target > observed_natural),
      n_sites_imputed = sum(target > observed_natural),
      mean_upward_steps = mean(upward),
      mean_upward_steps_among_imputed =
        if (any(upward > 0)) mean(upward[upward > 0]) else 0,

      fraction_sites_coarsened = mean(target < observed_natural),
      n_sites_coarsened = sum(target < observed_natural),
      mean_downward_steps = mean(downward),
      mean_downward_steps_among_coarsened =
        if (any(downward > 0)) mean(downward[downward > 0]) else 0,

      fraction_sites_exact_match = mean(target == observed_natural)
    )
  })
})

readr::write_csv(
  section_exposure,
  file.path(OUTPUT_DIR, "03_section_level_imputation_exposure.csv")
)

cat("Saved section-level exposure table.\n")


# ---------------------------------------------------------------------
# 7. Join burden to all classification results
# ---------------------------------------------------------------------

analysis_df <- perf |>
  left_join(burden, by = c("level", "sum_level"))

if (any(is.na(analysis_df$imputed_cell_fraction))) {
  stop("Burden join failed for one or more classification rows.")
}


# ---------------------------------------------------------------------
# 8. HC3 helper using Wald-z inference
# ---------------------------------------------------------------------
#
# Wald-z is used here intentionally to reproduce the accompanying workbook.
# The scientific emphasis should remain on effect sizes and CIs rather than
# treating the 1,000 vector-level summary scores as independent biological
# observations.
# ---------------------------------------------------------------------

extract_hc3_term <- function(fit, term) {

  V <- sandwich::vcovHC(fit, type = "HC3")

  beta <- coef(fit)
  if (!term %in% names(beta)) {
    stop("Term not found in model: ", term)
  }

  est <- unname(beta[term])
  se <- sqrt(unname(V[term, term]))
  z <- est / se
  p <- 2 * pnorm(-abs(z))
  crit <- qnorm(0.975)

  tibble(
    estimate = est,
    robust_se = se,
    statistic_z = z,
    p = p,
    ci_low = est - crit * se,
    ci_high = est + crit * se
  )
}


# ---------------------------------------------------------------------
# 9. Primary adjusted models
# ---------------------------------------------------------------------
#
# Model A:
#   performance ~ sum_level + imputed_cell_fraction
#
# Model B (stronger control):
#   performance ~ factor(sum_level) + imputed_cell_fraction
#
# Model B compares vectors WITH THE SAME TOTAL DETAIL SCORE and asks whether
# allocating that fixed amount of detail into sections that exceed natural-min
# resolution changes performance.
# ---------------------------------------------------------------------

model_rows <- list()

for (task_name in sort(unique(analysis_df$task))) {

  d <- analysis_df |>
    filter(.data$task == task_name)

  for (outcome in OUTCOMES) {

    # ----- Linear total-detail adjustment -----
    f_linear <- as.formula(
      paste0(outcome, " ~ sum_level + imputed_cell_fraction")
    )
    fit_linear <- lm(f_linear, data = d)
    imp_linear <- extract_hc3_term(
      fit_linear,
      "imputed_cell_fraction"
    )

    model_rows[[length(model_rows) + 1]] <- tibble(
      task = task_name,
      outcome = outcome,
      outcome_label = unname(OUTCOME_LABELS[outcome]),
      model = "linear_total_detail",
      n = nrow(d),
      n_unique_sum_levels = n_distinct(d$sum_level),
      estimate_per_1_fraction = imp_linear$estimate,
      robust_se_per_1_fraction = imp_linear$robust_se,
      ci95_low_per_1_fraction = imp_linear$ci_low,
      ci95_high_per_1_fraction = imp_linear$ci_high,
      p = imp_linear$p,

      effect_per_10pct_imputed_cells =
        0.10 * imp_linear$estimate,
      ci95_low_per_10pct =
        0.10 * imp_linear$ci_low,
      ci95_high_per_10pct =
        0.10 * imp_linear$ci_high,

      r2 = summary(fit_linear)$r.squared,
      adjusted_r2 = summary(fit_linear)$adj.r.squared
    )

    # ----- Exact total-detail strata -----
    f_strata <- as.formula(
      paste0(outcome, " ~ factor(sum_level) + imputed_cell_fraction")
    )
    fit_strata <- lm(f_strata, data = d)
    imp_strata <- extract_hc3_term(
      fit_strata,
      "imputed_cell_fraction"
    )

    model_rows[[length(model_rows) + 1]] <- tibble(
      task = task_name,
      outcome = outcome,
      outcome_label = unname(OUTCOME_LABELS[outcome]),
      model = "exact_total_detail_strata",
      n = nrow(d),
      n_unique_sum_levels = n_distinct(d$sum_level),
      estimate_per_1_fraction = imp_strata$estimate,
      robust_se_per_1_fraction = imp_strata$robust_se,
      ci95_low_per_1_fraction = imp_strata$ci_low,
      ci95_high_per_1_fraction = imp_strata$ci_high,
      p = imp_strata$p,

      effect_per_10pct_imputed_cells =
        0.10 * imp_strata$estimate,
      ci95_low_per_10pct =
        0.10 * imp_strata$ci_low,
      ci95_high_per_10pct =
        0.10 * imp_strata$ci_high,

      r2 = summary(fit_strata)$r.squared,
      adjusted_r2 = summary(fit_strata)$adj.r.squared
    )
  }
}

model_results <- bind_rows(model_rows) |>
  group_by(.data$model) |>
  mutate(
    p_fdr = p.adjust(.data$p, method = "BH"),
    significant_fdr = .data$p_fdr < 0.05
  ) |>
  ungroup() |>
  arrange(.data$model, .data$task, match(.data$outcome, OUTCOMES))

readr::write_csv(
  model_results,
  file.path(OUTPUT_DIR, "02_adjusted_imputation_models_HC3.csv")
)

cat("Saved adjusted HC3 models.\n")


# ---------------------------------------------------------------------
# 10. Descriptive Spearman associations
# ---------------------------------------------------------------------
#
# These are descriptive only. They are NOT the primary inference because
# imputation exposure is correlated with total detail.
# ---------------------------------------------------------------------

spearman_rows <- list()

for (task_name in sort(unique(analysis_df$task))) {

  d <- analysis_df |>
    filter(.data$task == task_name)

  for (outcome in OUTCOMES) {

    for (predictor in c(
      "imputed_cell_fraction",
      "mean_upward_steps_per_observed_cell",
      "imputed_site_fraction",
      "coarsened_cell_fraction",
      "mean_downward_steps_per_observed_cell",
      "exact_match_cell_fraction"
    )) {

      ct <- suppressWarnings(
        cor.test(
          d[[predictor]],
          d[[outcome]],
          method = "spearman",
          exact = FALSE
        )
      )

      spearman_rows[[length(spearman_rows) + 1]] <- tibble(
        task = task_name,
        outcome = outcome,
        outcome_label = unname(OUTCOME_LABELS[outcome]),
        predictor = predictor,
        spearman_rho = unname(ct$estimate),
        p = ct$p.value
      )
    }
  }
}

spearman_results <- bind_rows(spearman_rows) |>
  group_by(.data$predictor) |>
  mutate(p_fdr = p.adjust(.data$p, method = "BH")) |>
  ungroup()

readr::write_csv(
  spearman_results,
  file.path(OUTPUT_DIR, "05_unadjusted_spearman_correlations.csv")
)

cat("Saved descriptive Spearman correlations.\n")


# ---------------------------------------------------------------------
# 11. Optional merge with previous adjusted section-level accuracy means
# ---------------------------------------------------------------------

if (!is.null(ADJUSTED_MEANS_FILE)) {

  adjusted_means <- readr::read_csv(
    ADJUSTED_MEANS_FILE,
    show_col_types = FALSE
  )

  required_adjusted <- c(
    "task", "section", "level", "adjusted_mean"
  )

  if (all(required_adjusted %in% names(adjusted_means))) {

    section_diagnostic <- adjusted_means |>
      transmute(
        task = .data$task,
        section = .data$section,
        level = as.numeric(.data$level),
        adjusted_accuracy = as.numeric(.data$adjusted_mean),
        accuracy_ci_low =
          if ("ci_low" %in% names(adjusted_means))
            as.numeric(.data$ci_low) else NA_real_,
        accuracy_ci_high =
          if ("ci_high" %in% names(adjusted_means))
            as.numeric(.data$ci_high) else NA_real_,
        n_vectors_at_level =
          if ("n" %in% names(adjusted_means))
            as.numeric(.data$n) else NA_real_
      ) |>
      left_join(
        section_exposure,
        by = c(
          "section" = "section",
          "level" = "target_level"
        )
      ) |>
      arrange(.data$task, match(.data$section, PARTS), .data$level)

    readr::write_csv(
      section_diagnostic,
      file.path(
        OUTPUT_DIR,
        "04_section_accuracy_vs_imputation.csv"
      )
    )

    cat("Saved section accuracy vs imputation diagnostic table.\n")
  } else {
    warning(
      "Optional adjusted-means file was found but did not contain: ",
      paste(required_adjusted, collapse = ", "),
      ". Section diagnostic was skipped."
    )
  }
}


# ---------------------------------------------------------------------
# 12. Figures
# ---------------------------------------------------------------------

save_plot_pair <- function(plot_object, stem, width, height) {

  png_path <- file.path(OUTPUT_DIR, paste0(stem, ".png"))
  pdf_path <- file.path(OUTPUT_DIR, paste0(stem, ".pdf"))

  if (interactive()) print(plot_object)

  ggplot2::ggsave(
    png_path,
    plot_object,
    width = width,
    height = height,
    dpi = 400,
    bg = "white"
  )

  ggplot2::ggsave(
    pdf_path,
    plot_object,
    width = width,
    height = height,
    device = grDevices::cairo_pdf,
    bg = "white"
  )
}

# Distribution of structural exposure across the 1,000 vectors.
p_burden <- ggplot(
  burden,
  aes(x = 100 * imputed_cell_fraction)
) +
  geom_histogram(bins = 25) +
  labs(
    title = "Structural upward-reconstruction burden across tested vectors",
    subtitle = paste0(
      nrow(burden),
      " unique level vectors; natural baseline = site-specific calc_level = min"
    ),
    x = "Observed site-section cells requiring upward reconstruction (%)",
    y = "Number of tested vectors"
  ) +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank())

save_plot_pair(
  p_burden,
  "figure_01_imputation_burden_distribution",
  width = 8,
  height = 5.5
)


# Exact-total-detail-strata effect plot.
plot_effects <- model_results |>
  filter(.data$model == "exact_total_detail_strata") |>
  mutate(
    label = paste(.data$task, .data$outcome_label, sep = " — "),
    label = factor(label, levels = rev(unique(label)))
  )

p_effect <- ggplot(
  plot_effects,
  aes(
    x = effect_per_10pct_imputed_cells,
    y = label
  )
) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(
    aes(
      xmin = ci95_low_per_10pct,
      xmax = ci95_high_per_10pct
    ),
    height = 0.18
  ) +
  geom_point(aes(shape = significant_fdr), size = 2.5) +
  labs(
    title = "Additional performance effect of structural imputation exposure",
    subtitle = paste0(
      "HC3 model controlling for exact total-detail score; ",
      "effect shown per +10 percentage points of observed cells requiring reconstruction"
    ),
    x = "Adjusted change in classification performance",
    y = NULL,
    shape = "BH-FDR q < 0.05"
  ) +
  theme_minimal(base_size = 10) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "bottom"
  )

save_plot_pair(
  p_effect,
  "figure_02_adjusted_imputation_effects",
  width = 9,
  height = 6
)


# Section × target level imputation heatmap.
p_exposure <- ggplot(
  section_exposure,
  aes(
    x = section_label,
    y = factor(target_level),
    fill = 100 * fraction_sites_imputed
  )
) +
  geom_tile(linewidth = 0.35) +
  geom_text(
    aes(label = sprintf("%.1f%%", 100 * fraction_sites_imputed)),
    size = 3
  ) +
  labs(
    title = "Where target resolution exceeds site-specific natural-min resolution",
    subtitle = "Cell value = percentage of sites with observed material in that section requiring upward reconstruction",
    x = "Skeletal section",
    y = "Target detail level",
    fill = "Sites imputed (%)"
  ) +
  theme_minimal(base_size = 10) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )

save_plot_pair(
  p_exposure,
  "figure_03_section_level_imputation_exposure",
  width = 11,
  height = 6.5
)


# ---------------------------------------------------------------------
# 13. Human-readable results summary
# ---------------------------------------------------------------------

primary <- model_results |>
  filter(.data$model == "exact_total_detail_strata")

report_file <- file.path(
  OUTPUT_DIR,
  "RESULTS_IMPUTATION_BURDEN.md"
)

con <- file(report_file, open = "wt", encoding = "UTF-8")

write_report <- function(...) {
  writeLines(paste0(...), con)
}

write_report("# Imputation burden and classification performance\n")
write_report("## Design\n")
write_report(
  "Natural resolution was defined using the site-specific `calc_level = \"min\"` vectors from the observed-only natural-level analysis. "
)
write_report(
  "Only genuinely observed site-section cells were used; absent sections were ignored rather than interpreted from stored default levels. "
)
write_report(
  "For every tested classification vector, a site-section was classified as exposed to upward reconstruction when its requested target level exceeded that site's natural-min level.\n"
)

write_report("## Dataset\n")
write_report("- Sites: ", n_sites, "\n")
write_report("- Observed site-section cells: ", n_observed_cells, "\n")
write_report("- Tested level vectors: ", nrow(burden), "\n")
write_report(
  sprintf(
    "- Mean imputed-cell fraction across vectors: %.2f%%\n",
    100 * mean(burden$imputed_cell_fraction)
  )
)
write_report(
  sprintf(
    "- Median imputed-cell fraction: %.2f%%\n",
    100 * median(burden$imputed_cell_fraction)
  )
)
write_report(
  sprintf(
    "- Maximum imputed-cell fraction: %.2f%%\n",
    100 * max(burden$imputed_cell_fraction)
  )
)
write_report(
  sprintf(
    "- Mean fraction of sites requiring any upward reconstruction: %.2f%%\n",
    100 * mean(burden$imputed_site_fraction)
  )
)

write_report("\n## Primary model\n")
write_report(
  "`performance ~ factor(sum_level) + imputed_cell_fraction`\n\n"
)
write_report(
  "Because total detail is entered as a factor, the imputation coefficient is estimated from comparisons among vectors with exactly the same total level sum. It therefore asks whether redistributing a fixed amount of anatomical detail into sections that exceed site-specific natural-min resolution is associated with additional performance change.\n"
)

for (i in seq_len(nrow(primary))) {

  rr <- primary[i, ]

  write_report(
    sprintf(
      "- **%s — %s:** +10 percentage points of imputed site-section cells = %+0.4f performance points (95%% CI %+0.4f to %+0.4f; p = %.4g; BH-FDR q = %.4g).\n",
      rr$task,
      rr$outcome_label,
      rr$effect_per_10pct_imputed_cells,
      rr$ci95_low_per_10pct,
      rr$ci95_high_per_10pct,
      rr$p,
      rr$p_fdr
    )
  )
}

write_report("\n## Interpretation boundary\n")
write_report(
  "This analysis quantifies structural exposure to upward reconstruction, not the realized count-level reconstruction error. A site-section is counted as exposed whenever target level > natural-min level. The next causal-style experiment should use genuinely fine-resolution sites, collapse them to a coarser level, reconstruct them back upward, and compare reconstructed values and classification performance with the original fine data.\n"
)

write_report("\n## Statistical limitation\n")
write_report(
  "The 1,000 level-vector rows per task reuse the same underlying assemblages through cross-validation and therefore are not 1,000 independent biological observations. HC3 inference is useful for mapping the sampled level-vector design space but should be treated as exploratory. The confirmatory design should retain outer-fold performance for every level vector using identical outer splits and analyse paired fold-level outcomes with mixed-effects models.\n"
)

close(con)

cat("\nAnalysis complete.\n")
cat("Results: ", OUTPUT_DIR, "\n", sep = "")
cat("Report : ", report_file, "\n", sep = "")
