# =====================================================================
#  Profound EDA — taphonomy dataset
#  Focus: the 20 most important features vs taphonomic_context,
#         with metadata used as context / confound checks.
#
#  run_eda(tb) writes figures (.png) and tables (.csv) to out_dir
#  and prints a short headline summary to the console.
# =====================================================================

library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(readr)
library(purrr)
library(forcats)

# ---------------------------------------------------------------------
# Column sets
# ---------------------------------------------------------------------
important_features <- c(
  "ProportionalRep_MNIbased_os_coxae", "mnau_shoulder",
  "ProportionalRep_MNIbased_femur", "mnau_arms",
  "density_adjusted_appendicular_axial_contrast", "mnau_column_trunk_mean",
  "mne_vertebrae_to_thorax_ratio", "ReMNAU_cervical",
  "ProportionalRep_MNIbased_metacarpal", "mne_arms_to_legs_ratio",
  "mnau_legs", "mnau_postcranial_total_mean", "mnau_appendicular_mean",
  "mnau_upper_appendicular_mean", "mnau_lower_appendicular_mean",
  "mnau_girdle_mean", "mnau_distal_appendicular_mean",
  "mnau_proximal_appendicular_mean", "all_sections_dominance",
  "low_density_survival_index"
)

meta_cols <- c(
  "site_id", "ind_name", "individual_id", "site_name", "layer_name",
  "count_type", "geological_period", "cultural_period", "culture_period_2",
  "start_date_cal_bp", "end_date_cal_bp", "mis_stage",
  "karstic_system", "karstic_system_2", "open_air_site", "open_air_site_2",
  "region", "country", "mni", "age_category",
  "n_infant", "n_juvenil", "n_subadult", "n_adult", "gender",
  "funerary_context", "discovery_context", "degree_of_excavation",
  "hominin_species", "observation", "reference"
)

# metadata worth cross-tabbing against the target
context_vars <- c("geological_period", "cultural_period", "mis_stage",
                  "region", "country", "hominin_species", "age_category",
                  "open_air_site")

# ---------------------------------------------------------------------
# small helpers
# ---------------------------------------------------------------------
.num <- function(x) {                      # coerce + neutralise Inf/NaN
  v <- suppressWarnings(as.numeric(x))
  v[is.nan(v) | is.infinite(v)] <- NA_real_
  v
}
.savep <- function(p, file, w = 11, h = 8) {
  ggsave(file, p, width = w, height = h, dpi = 150)
  message("  fig  -> ", file)
}
.savecsv <- function(d, file) {
  readr::write_csv(d, file)
  message("  csv  -> ", file)
}

# ---------------------------------------------------------------------
# main
# ---------------------------------------------------------------------
run_eda <- function(tb,
                    class_col    = "taphonomic_context",
                    features     = important_features,
                    out_dir      = "eda_out",
                    collapse_rest = FALSE,   # TRUE -> Funerary Context vs rest
                    seed         = 42) {

  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  set.seed(seed)

  feats <- intersect(features, names(tb))
  if (length(feats) < length(features))
    warning("Missing feature(s): ",
            paste(setdiff(features, names(tb)), collapse = ", "))

  # numeric copy of the features (Inf/NaN -> NA), plus class + metadata
  num <- tb %>% dplyr::transmute(dplyr::across(dplyr::all_of(feats), .num))
  cls_raw <- tb[[class_col]]
  if (collapse_rest) {
    cls <- forcats::fct_other(
      factor(cls_raw), keep = "Funerary Context", other_level = "rest")
  } else {
    cls <- factor(cls_raw)
  }
  dat <- dplyr::bind_cols(num, .class = cls)

  # =================================================================
  # 1. DATA HEALTH
  # =================================================================
  message("[1/7] data health")
  health <- tibble::tibble(
    feature   = feats,
    n         = nrow(tb),
    n_missing = vapply(num, function(c) sum(is.na(c)), integer(1)),
    n_inf_or_nan = vapply(feats, function(f)
      sum(is.nan(suppressWarnings(as.numeric(tb[[f]]))) |
          is.infinite(suppressWarnings(as.numeric(tb[[f]])))), integer(1)),
    n_distinct = vapply(num, function(c) dplyr::n_distinct(c, na.rm = TRUE), integer(1)),
    min = vapply(num, function(c) suppressWarnings(min(c, na.rm = TRUE)), numeric(1)),
    median = vapply(num, function(c) stats::median(c, na.rm = TRUE), numeric(1)),
    max = vapply(num, function(c) suppressWarnings(max(c, na.rm = TRUE)), numeric(1))
  ) %>% dplyr::mutate(pct_missing = round(100 * n_missing / n, 1))
  .savecsv(health, file.path(out_dir, "01_feature_health.csv"))

  class_tab <- tibble::as_tibble(table(class = cls_raw, useNA = "ifany"))
  .savecsv(class_tab, file.path(out_dir, "01_class_distribution.csv"))

  p_class <- dat %>% dplyr::count(.class) %>%
    ggplot(aes(forcats::fct_reorder(.class, n), n)) +
    geom_col(fill = "steelblue") + geom_text(aes(label = n), hjust = -0.2) +
    coord_flip() + labs(title = "Class distribution", x = NULL, y = "n individuals") +
    theme_minimal(base_size = 12)
  .savep(p_class, file.path(out_dir, "01_class_distribution.png"), 8, 5)

  p_miss <- health %>%
    ggplot(aes(forcats::fct_reorder(feature, pct_missing), pct_missing)) +
    geom_col(fill = "grey50") + coord_flip() +
    labs(title = "Missing / non-finite per feature", x = NULL, y = "% missing") +
    theme_minimal(base_size = 11)
  .savep(p_miss, file.path(out_dir, "01_missingness.png"), 9, 7)

  # =================================================================
  # 2. UNIVARIATE DISTRIBUTIONS
  # =================================================================
  message("[2/7] univariate distributions")
  long <- dat %>%
    tidyr::pivot_longer(dplyr::all_of(feats), names_to = "feature", values_to = "value") %>%
    dplyr::filter(!is.na(value))

  p_hist <- ggplot(long, aes(value)) +
    geom_histogram(bins = 30, fill = "steelblue", colour = "white") +
    facet_wrap(~ feature, scales = "free", ncol = 4) +
    labs(title = "Univariate distributions (20 important features)", x = NULL, y = NULL) +
    theme_minimal(base_size = 9)
  .savep(p_hist, file.path(out_dir, "02_histograms.png"), 13, 11)

  # =================================================================
  # 3. DISTRIBUTION BY CLASS
  # =================================================================
  message("[3/7] distributions by class")
  long_cls <- long %>% dplyr::filter(!is.na(.class))

  p_box <- ggplot(long_cls, aes(.class, value, fill = .class)) +
    geom_violin(alpha = 0.35, colour = NA, scale = "width") +
    geom_boxplot(width = 0.25, outlier.size = 0.6, alpha = 0.8) +
    facet_wrap(~ feature, scales = "free_y", ncol = 4) +
    scale_fill_brewer(palette = "Dark2") +
    labs(title = "Feature value by taphonomic context", x = NULL, y = NULL) +
    theme_minimal(base_size = 9) +
    theme(axis.text.x = element_text(angle = 35, hjust = 1), legend.position = "none")
  .savep(p_box, file.path(out_dir, "03_by_class_violin.png"), 13, 12)

  by_class_stats <- long_cls %>%
    dplyr::group_by(feature, .class) %>%
    dplyr::summarise(n = dplyr::n(), mean = mean(value), sd = stats::sd(value),
                     median = stats::median(value),
                     q25 = stats::quantile(value, .25),
                     q75 = stats::quantile(value, .75), .groups = "drop")
  .savecsv(by_class_stats, file.path(out_dir, "03_by_class_summary.csv"))

  # =================================================================
  # 4. DISCRIMINATIVE POWER (Kruskal-Wallis + epsilon-squared)
  # =================================================================
  message("[4/7] discriminative ranking")
  kw <- long_cls %>%
    dplyr::group_by(feature) %>%
    dplyr::group_modify(function(d, key) {
      d <- d %>% dplyr::filter(!is.na(value), !is.na(.class))
      n <- nrow(d); k <- dplyr::n_distinct(d$.class)
      if (k < 2 || n < (k + 1)) return(tibble::tibble(
        H = NA_real_, p_value = NA_real_, epsilon_sq = NA_real_, n = n, k = k))
      ht <- stats::kruskal.test(value ~ .class, data = d)
      tibble::tibble(H = unname(ht$statistic), p_value = ht$p.value,
                     epsilon_sq = unname(ht$statistic) / (n - 1), n = n, k = k)
    }) %>% dplyr::ungroup() %>%
    dplyr::mutate(p_adj = stats::p.adjust(p_value, "BH")) %>%
    dplyr::arrange(dplyr::desc(epsilon_sq))
  .savecsv(kw, file.path(out_dir, "04_discriminative_ranking.csv"))

  p_eps <- kw %>% dplyr::filter(!is.na(epsilon_sq)) %>%
    ggplot(aes(forcats::fct_reorder(feature, epsilon_sq), epsilon_sq,
               fill = p_adj < 0.05)) +
    geom_col() + coord_flip() +
    scale_fill_manual(values = c(`TRUE` = "firebrick", `FALSE` = "grey60"),
                      name = "BH p < .05") +
    labs(title = "How well each feature separates the classes",
         subtitle = "Kruskal-Wallis rank effect size (epsilon^2)",
         x = NULL, y = "epsilon^2") +
    theme_minimal(base_size = 11)
  .savep(p_eps, file.path(out_dir, "04_discriminative_ranking.png"), 9, 7)

  # =================================================================
  # 5. CORRELATION STRUCTURE (Spearman, clustered)
  # =================================================================
  message("[5/7] correlation structure")
  cmat <- suppressWarnings(stats::cor(num, use = "pairwise.complete.obs",
                                      method = "spearman"))
  cmat[is.na(cmat)] <- 0
  ord <- stats::hclust(stats::as.dist(1 - abs(cmat)))$order
  cdf <- as.data.frame(cmat[ord, ord]) %>%
    tibble::rownames_to_column("f1") %>%
    tidyr::pivot_longer(-f1, names_to = "f2", values_to = "rho") %>%
    dplyr::mutate(f1 = factor(f1, levels = rownames(cmat)[ord]),
                  f2 = factor(f2, levels = rownames(cmat)[ord]))
  .savecsv(tibble::as_tibble(cmat, rownames = "feature"),
           file.path(out_dir, "05_correlation_matrix.csv"))

  p_cor <- ggplot(cdf, aes(f1, f2, fill = rho)) +
    geom_tile() +
    scale_fill_gradient2(low = "#3b4cc0", mid = "white", high = "#b40426",
                         midpoint = 0, limits = c(-1, 1), name = "Spearman") +
    labs(title = "Feature correlation (clustered)", x = NULL, y = NULL) +
    theme_minimal(base_size = 8) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
  .savep(p_cor, file.path(out_dir, "05_correlation_heatmap.png"), 11, 10)

  # redundant pairs (|rho| > .9)
  redundant <- cdf %>%
    dplyr::filter(as.integer(f1) < as.integer(f2), abs(rho) > 0.9) %>%
    dplyr::arrange(dplyr::desc(abs(rho)))
  .savecsv(redundant, file.path(out_dir, "05_redundant_pairs.csv"))

  # =================================================================
  # 6. PCA (multivariate view, coloured by class)
  # =================================================================
  message("[6/7] PCA")
  Xi <- num
  keep <- vapply(Xi, function(c) stats::var(c, na.rm = TRUE) > 0 &
                   sum(!is.na(c)) > 1, logical(1))
  Xi <- Xi[, keep, drop = FALSE]
  Xi[] <- lapply(Xi, function(c) { c[is.na(c)] <- stats::median(c, na.rm = TRUE); c })
  pca <- stats::prcomp(Xi, center = TRUE, scale. = TRUE)
  varexp <- summary(pca)$importance[2, ]

  scree <- tibble::tibble(PC = factor(seq_along(varexp), levels = seq_along(varexp)),
                          var = as.numeric(varexp)) %>% dplyr::slice_head(n = 12)
  p_scree <- ggplot(scree, aes(PC, var)) +
    geom_col(fill = "steelblue") +
    geom_text(aes(label = scales::percent(var, accuracy = 0.1)), vjust = -0.4, size = 3) +
    labs(title = "PCA scree", x = "Component", y = "Variance explained") +
    theme_minimal(base_size = 11)
  .savep(p_scree, file.path(out_dir, "06_pca_scree.png"), 8, 5)

  scores <- tibble::tibble(PC1 = pca$x[, 1], PC2 = pca$x[, 2], class = cls)
  p_pca <- ggplot(scores, aes(PC1, PC2, colour = class)) +
    geom_point(size = 2, alpha = 0.85) +
    stat_ellipse(type = "norm", linewidth = 0.4, na.rm = TRUE) +
    scale_colour_brewer(palette = "Dark2", na.value = "grey70") +
    labs(title = "PCA of important features",
         x = sprintf("PC1 (%.1f%%)", 100 * varexp[1]),
         y = sprintf("PC2 (%.1f%%)", 100 * varexp[2])) +
    theme_minimal(base_size = 12)
  .savep(p_pca, file.path(out_dir, "06_pca_scatter.png"), 9, 7)

  loadings <- as.data.frame(pca$rotation[, 1:3]) %>%
    tibble::rownames_to_column("feature") %>%
    dplyr::rename(PC1 = PC1, PC2 = PC2, PC3 = PC3)
  .savecsv(loadings, file.path(out_dir, "06_pca_loadings.csv"))

  # =================================================================
  # 7. METADATA CONTEXT / CONFOUND CHECK
  # =================================================================
  message("[7/7] metadata cross-tabs")
  ctx <- intersect(context_vars, names(tb))
  ct_list <- purrr::map(ctx, function(v) {
    tb %>% dplyr::count(.data[[v]], .class = cls, name = "n") %>%
      dplyr::rename(level = 1) %>% dplyr::mutate(variable = v, .before = 1)
  })
  crosstabs <- dplyr::bind_rows(ct_list)
  .savecsv(crosstabs, file.path(out_dir, "07_metadata_crosstabs.csv"))

  # one stacked-bar panel per context variable
  p_ctx <- crosstabs %>% dplyr::filter(!is.na(.class)) %>%
    ggplot(aes(level, n, fill = .class)) +
    geom_col(position = "fill") +
    facet_wrap(~ variable, scales = "free_x", ncol = 2) +
    scale_fill_brewer(palette = "Dark2", name = "class") +
    scale_y_continuous(labels = scales::percent) +
    labs(title = "Class composition within metadata strata",
         subtitle = "watch for classes confounded with period / region / species",
         x = NULL, y = "share") +
    theme_minimal(base_size = 9) +
    theme(axis.text.x = element_text(angle = 40, hjust = 1))
  .savep(p_ctx, file.path(out_dir, "07_metadata_composition.png"), 13, 11)

  # =================================================================
  # headline summary to console
  # =================================================================
  message("\n================ EDA SUMMARY ================")
  message("rows: ", nrow(tb), " | features analysed: ", length(feats))
  message("\nclass balance:")
  print(table(cls_raw, useNA = "ifany"))
  top5 <- kw %>% dplyr::filter(!is.na(epsilon_sq)) %>% dplyr::slice_head(n = 5)
  message("\ntop discriminators (epsilon^2):")
  print(top5 %>% dplyr::select(feature, epsilon_sq, p_adj) %>%
          dplyr::mutate(dplyr::across(where(is.numeric), ~ round(.x, 4))))
  if (nrow(redundant)) {
    message("\nhighly redundant pairs (|rho| > .9): ", nrow(redundant))
    print(utils::head(redundant, 5))
  }
  message("\nPC1+PC2 variance captured: ",
          round(100 * sum(varexp[1:2]), 1), "%")
  worst <- health %>% dplyr::slice_max(pct_missing, n = 3)
  message("most-missing features: ",
          paste0(worst$feature, " (", worst$pct_missing, "%)", collapse = ", "))
  message("============================================")
  message("all outputs in: ", normalizePath(out_dir))

  invisible(list(health = health, by_class_stats = by_class_stats,
                 discriminative = kw, correlation = cmat,
                 redundant = redundant, pca = pca, crosstabs = crosstabs))
}

# ---------------------------------------------------------------------
# Example
# ---------------------------------------------------------------------
# eda <- run_eda(tb)                          # multiclass taphonomic_context
# eda <- run_eda(tb, collapse_rest = TRUE)    # Funerary Context vs rest
# eda$discriminative                          # ranked separability table
