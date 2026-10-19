# ==============================================================================
# F vs NF probability surfaces in C x Heip evenness space
# Models: ridge logistic regression + RBF-SVM
#
# Purpose
# -------
# Re-run the main Funerary Context (F) vs Rest (NF) task using ONLY:
#   x = Mean_part_abundance
#   y = mnau_heip_evenness
#
# The same core validation logic as the previous supervised workflow is used:
#   - grouped CV by site_name
#   - 3 folds x 5 repeats
#   - training-fold median imputation
#   - training-fold standardization
#   - random oversampling in the training fold only
#   - fixed model settings (no hyperparameter tuning)
#
# For each model, the 15 fitted CV models are also used as an ensemble to predict:
#   1) the Unknown/Unkown sites
#   2) a dense C x Heip grid
#
# The plotted background is the MEAN P(F) across those 15 fitted models.
# Four probability zones are shown:
#   <25%, 25-50%, 50-75%, >=75%.
#
# IMPORTANT
# ---------
# These are C + Heip models. They are NOT the %MNAU best-performing SVM projected
# into two dimensions. A %MNAU model cannot be represented exactly by only C and
# Heip because its predictions depend on many skeletal-part variables.
#
# P(F) is best interpreted as Funerary-reference affinity under the balanced
# classification problem, not as the literal probability that a site was a burial.
# ==============================================================================


# ------------------------------------------------------------------------------
# 0. User settings
# ------------------------------------------------------------------------------

INPUT_FILE <- "final/tapho_db_sum.csv"
OUT_DIR <- "F_vs_NF_C_Heip_probability_surfaces"

SEED <- 42L
CV_FOLDS <- 3L
CV_REPEATS <- 5L

LOGISTIC_LAMBDA <- 1
SVM_COST <- 1

# Previous request omitted Sima de los Huesos PNAS from the Unknown-site table.
# TRUE keeps it off these plots too. Change to FALSE if you want it shown.
EXCLUDE_SIMA_PNAS_FROM_UNKNOWN <- TRUE
SIMA_PNAS_NAMES <- c("Sima de los Huesos PNAS")

# Probability boundaries requested for the map.
PROB_BREAKS <- c(0.25, 0.50, 0.75)

# Resolution of the background probability grid.
GRID_N <- 260L

# Four probability-zone colours.
ZONE_COLOURS <- c(
  "<25% F"   = "#d6c9e5",
  "25-50% F" = "#c9dce8",
  "50-75% F" = "#cce8dc",
  ">=75% F"  = "#f2e3a2"
)

# Point colours.
REFERENCE_NF_COLOUR <- "#5b9bc5"
REFERENCE_F_COLOUR <- "#e6a15e"
UNKNOWN_COLOUR <- "#2f8f2f"


# ------------------------------------------------------------------------------
# 1. Packages and data
# ------------------------------------------------------------------------------

required_packages <- c("tidyverse", "glmnet", "e1071", "ggrepel")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
]

if (length(missing_packages) > 0) {
  stop(
    "Install these packages and rerun: ",
    paste(missing_packages, collapse = ", ")
  )
}

library(tidyverse)
library(ggrepel)

set.seed(SEED)

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(INPUT_FILE)) {
  stop(
    "Input file not found: ", INPUT_FILE,
    "\nCurrent working directory: ", getwd()
  )
}

d <- readr::read_csv(INPUT_FILE, show_col_types = FALSE) %>%
  mutate(record_id = row_number())

required_columns <- c(
  "site_name",
  "taphonomic_context",
  "Mean_part_abundance",
  "mnau_heip_evenness"
)

missing_columns <- setdiff(required_columns, names(d))
if (length(missing_columns) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

C_VAR <- "Mean_part_abundance"
E_VAR <- "mnau_heip_evenness"
VARS <- c(C_VAR, E_VAR)

collapse_class4 <- function(x) {
  dplyr::case_when(
    x == "Funerary Context" ~ "Funerary Context",
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore",
      "Carnivore-related",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)",
      "Carnivore den (transport)"
    ) ~ "Carnivore",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

d <- d %>%
  mutate(class4 = collapse_class4(taphonomic_context))

reference <- d %>%
  filter(!is.na(class4)) %>%
  mutate(
    task_label = if_else(
      class4 == "Funerary Context",
      "Funerary Context",
      "Rest"
    ),
    task_label = factor(
      task_label,
      levels = c("Rest", "Funerary Context")
    )
  )

unknown <- d %>%
  filter(taphonomic_context %in% c("Unknown", "Unkown"))

if (EXCLUDE_SIMA_PNAS_FROM_UNKNOWN) {
  unknown <- unknown %>%
    filter(!site_name %in% SIMA_PNAS_NAMES)
}

cat("\nReference rows:", nrow(reference), "\n")
cat("Unique reference sites:", n_distinct(reference$site_name), "\n")
cat("Reference labels:\n")
print(reference %>% count(task_label))
cat("\nUnknown rows plotted/predicted:", nrow(unknown), "\n")


# ------------------------------------------------------------------------------
# 2. Grouped stratified 3-fold x 5-repeat map
# ------------------------------------------------------------------------------

make_grouped_stratified_folds <- function(
  dat,
  v = 3L,
  repeats = 5L,
  seed = 42L
) {
  if (any(is.na(dat$site_name) | dat$site_name == "")) {
    stop("site_name contains missing/blank values.")
  }

  group_labels <- dat %>%
    distinct(site_name, task_label)

  inconsistent <- group_labels %>%
    count(site_name, name = "n_labels") %>%
    filter(n_labels > 1)

  if (nrow(inconsistent) > 0) {
    stop(
      "At least one site_name has multiple F-vs-NF labels: ",
      paste(inconsistent$site_name, collapse = ", ")
    )
  }

  maps <- vector("list", repeats)

  for (r in seq_len(repeats)) {
    set.seed(seed + r * 1009L)

    maps[[r]] <- group_labels %>%
      group_by(task_label) %>%
      group_modify(~ {
        shuffled <- sample(.x$site_name, length(.x$site_name), replace = FALSE)

        tibble(
          site_name = shuffled,
          fold = rep(seq_len(v), length.out = length(shuffled))
        )
      }) %>%
      ungroup() %>%
      mutate(repeat_id = r)
  }

  bind_rows(maps)
}

fold_map <- make_grouped_stratified_folds(
  reference,
  v = CV_FOLDS,
  repeats = CV_REPEATS,
  seed = SEED
)

write_csv(
  fold_map,
  file.path(OUT_DIR, "grouped_cv_fold_map_C_Heip.csv")
)


# ------------------------------------------------------------------------------
# 3. Fold-specific preprocessing
# ------------------------------------------------------------------------------

fit_preprocessor <- function(train, vars) {
  medians <- vapply(
    vars,
    function(v) {
      m <- suppressWarnings(median(train[[v]], na.rm = TRUE))
      if (is.finite(m)) m else 0
    },
    numeric(1)
  )

  impute_raw <- function(dat) {
    x <- as.data.frame(dat[, vars, drop = FALSE])

    for (v in vars) {
      bad <- is.na(x[[v]]) | !is.finite(x[[v]])
      x[[v]][bad] <- medians[[v]]
    }

    as.matrix(x)
  }

  x_train_raw <- impute_raw(train)

  means <- colMeans(x_train_raw)
  sds <- apply(x_train_raw, 2, sd)

  if (any(!is.finite(sds) | sds <= 0)) {
    stop("C or Heip has zero variance in a training fold.")
  }

  transform_scaled <- function(dat) {
    x <- impute_raw(dat)
    sweep(sweep(x, 2, means, "-"), 2, sds, "/")
  }

  list(
    medians = medians,
    means = means,
    sds = sds,
    train_scaled = transform_scaled(train),
    transform_scaled = transform_scaled
  )
}


# ------------------------------------------------------------------------------
# 4. Random oversampling inside training folds only
# ------------------------------------------------------------------------------

balance_indices <- function(y, seed) {
  y <- as.character(y)
  classes <- sort(unique(y))
  counts <- table(y)
  target_n <- max(counts)

  set.seed(seed)

  idx <- unlist(
    lapply(classes, function(cl) {
      ii <- which(y == cl)

      if (length(ii) < target_n) {
        c(ii, sample(ii, target_n - length(ii), replace = TRUE))
      } else {
        ii
      }
    }),
    use.names = FALSE
  )

  sample(idx, length(idx), replace = FALSE)
}


# ------------------------------------------------------------------------------
# 5. Models
# ------------------------------------------------------------------------------

CLASSES <- c("Rest", "Funerary Context")
MODELS <- c("Logistic regression", "RBF-SVM")

align_probability_matrix <- function(P, classes = CLASSES) {
  P <- as.matrix(P)

  if (is.null(colnames(P))) {
    if (ncol(P) != length(classes)) {
      stop("Probability matrix has an unexpected number of columns.")
    }
    colnames(P) <- classes
  }

  missing <- setdiff(classes, colnames(P))
  if (length(missing) > 0) {
    stop("Probability output is missing class(es): ", paste(missing, collapse = ", "))
  }

  P <- P[, classes, drop = FALSE]
  P[P < 0] <- 0

  rs <- rowSums(P)
  rs[!is.finite(rs) | rs <= 0] <- 1

  P / rs
}

fit_predict_logistic <- function(X_train, y_train, X_new) {
  fit <- glmnet::glmnet(
    x = X_train,
    y = factor(y_train, levels = CLASSES),
    family = "binomial",
    alpha = 0,
    lambda = LOGISTIC_LAMBDA,
    standardize = FALSE
  )

  p_f <- as.numeric(
    predict(
      fit,
      newx = X_new,
      type = "response",
      s = LOGISTIC_LAMBDA
    )
  )

  P <- cbind(
    Rest = 1 - p_f,
    `Funerary Context` = p_f
  )

  align_probability_matrix(P)
}

fit_predict_svm <- function(X_train, y_train, X_new) {
  fit <- e1071::svm(
    x = X_train,
    y = factor(y_train, levels = CLASSES),
    kernel = "radial",
    cost = SVM_COST,
    gamma = 1 / ncol(X_train),
    scale = FALSE,
    probability = TRUE
  )

  pred <- predict(
    fit,
    X_new,
    probability = TRUE,
    decision.values = FALSE
  )

  P <- attr(pred, "probabilities")
  align_probability_matrix(P)
}

fit_predict_model <- function(model_name, X_train, y_train, X_new) {
  if (model_name == "Logistic regression") {
    return(fit_predict_logistic(X_train, y_train, X_new))
  }

  if (model_name == "RBF-SVM") {
    return(fit_predict_svm(X_train, y_train, X_new))
  }

  stop("Unknown model: ", model_name)
}


# ------------------------------------------------------------------------------
# 6. Metrics
# ------------------------------------------------------------------------------

binary_auc <- function(y01, score) {
  ok <- is.finite(score) & !is.na(y01)

  y01 <- y01[ok]
  score <- score[ok]

  n1 <- sum(y01 == 1)
  n0 <- sum(y01 == 0)

  if (n1 == 0 || n0 == 0) return(NA_real_)

  r <- rank(score, ties.method = "average")

  (
    sum(r[y01 == 1]) -
      n1 * (n1 + 1) / 2
  ) / (n1 * n0)
}

calc_binary_metrics <- function(truth, p_f) {
  truth <- as.character(truth)
  truth_f <- truth == "Funerary Context"
  pred_f <- p_f >= 0.50

  TP <- sum(truth_f & pred_f)
  FN <- sum(truth_f & !pred_f)
  TN <- sum(!truth_f & !pred_f)
  FP <- sum(!truth_f & pred_f)

  sensitivity <- if ((TP + FN) > 0) TP / (TP + FN) else NA_real_
  specificity <- if ((TN + FP) > 0) TN / (TN + FP) else NA_real_
  precision <- if ((TP + FP) > 0) TP / (TP + FP) else NA_real_
  recall <- sensitivity

  tibble(
    balanced_accuracy = mean(c(sensitivity, specificity), na.rm = TRUE),
    roc_auc = binary_auc(as.integer(truth_f), p_f),
    precision = precision,
    recall = recall,
    specificity = specificity,
    brier = mean((p_f - as.integer(truth_f))^2, na.rm = TRUE)
  )
}


# ------------------------------------------------------------------------------
# 7. Define the raw C x Heip grid
# ------------------------------------------------------------------------------

# Use both reference and Unknown coordinates to choose plotting limits.
coords_for_limits <- bind_rows(
  reference %>% select(all_of(VARS)),
  unknown %>% select(all_of(VARS))
)

x_obs <- coords_for_limits[[C_VAR]]
y_obs <- coords_for_limits[[E_VAR]]

x_obs <- x_obs[is.finite(x_obs)]
y_obs <- y_obs[is.finite(y_obs)]

expand_range <- function(z, fraction = 0.04) {
  rr <- range(z, na.rm = TRUE)
  span <- diff(rr)

  if (!is.finite(span) || span == 0) span <- 1

  c(
    rr[1] - fraction * span,
    rr[2] + fraction * span
  )
}

xlim_raw <- expand_range(x_obs)
ylim_raw <- expand_range(y_obs)

# C and Heip are normally bounded by 0 and 1. If the observed data are inside
# that range, keep the plotting window inside it.
if (all(x_obs >= 0 & x_obs <= 1)) {
  xlim_raw <- c(max(0, xlim_raw[1]), min(1, xlim_raw[2]))
}

if (all(y_obs >= 0 & y_obs <= 1)) {
  ylim_raw <- c(max(0, ylim_raw[1]), min(1, ylim_raw[2]))
}

grid_raw <- tidyr::expand_grid(
  Mean_part_abundance = seq(xlim_raw[1], xlim_raw[2], length.out = GRID_N),
  mnau_heip_evenness = seq(ylim_raw[1], ylim_raw[2], length.out = GRID_N)
)


# ------------------------------------------------------------------------------
# 8. Repeated grouped CV, OOF predictions, Unknown predictions, grid predictions
# ------------------------------------------------------------------------------

oof_parts <- list()
unknown_parts <- list()
grid_parts <- list()
fold_metric_parts <- list()

ii_oof <- 1L
ii_unknown <- 1L
ii_grid <- 1L
ii_metric <- 1L

for (r in seq_len(CV_REPEATS)) {
  cat("\nRepeat", r, "of", CV_REPEATS, "\n")

  one_repeat <- fold_map %>%
    filter(repeat_id == r)

  for (f in seq_len(CV_FOLDS)) {
    cat("  Fold", f, "of", CV_FOLDS, "\n")

    valid_sites <- one_repeat %>%
      filter(fold == f) %>%
      pull(site_name)

    train <- reference %>%
      filter(!site_name %in% valid_sites)

    valid <- reference %>%
      filter(site_name %in% valid_sites)

    if (any(train$site_name %in% valid$site_name)) {
      stop("Grouped-CV leakage detected.")
    }

    pp <- fit_preprocessor(train, VARS)

    X_train <- pp$train_scaled
    X_valid <- pp$transform_scaled(valid)
    X_unknown <- pp$transform_scaled(unknown)
    X_grid <- pp$transform_scaled(grid_raw)

    y_train <- as.character(train$task_label)

    bal_idx <- balance_indices(
      y_train,
      seed = SEED + r * 1000L + f * 100L
    )

    X_train_bal <- X_train[bal_idx, , drop = FALSE]
    y_train_bal <- y_train[bal_idx]

    for (model_name in MODELS) {
      P_valid <- fit_predict_model(
        model_name,
        X_train_bal,
        y_train_bal,
        X_valid
      )

      P_unknown <- fit_predict_model(
        model_name,
        X_train_bal,
        y_train_bal,
        X_unknown
      )

      P_grid <- fit_predict_model(
        model_name,
        X_train_bal,
        y_train_bal,
        X_grid
      )

      p_valid_f <- P_valid[, "Funerary Context"]
      p_unknown_f <- P_unknown[, "Funerary Context"]
      p_grid_f <- P_grid[, "Funerary Context"]

      oof_parts[[ii_oof]] <- valid %>%
        transmute(
          model = model_name,
          repeat_id = r,
          fold = f,
          record_id,
          site_name,
          truth = as.character(task_label),
          C = .data[[C_VAR]],
          Heip = .data[[E_VAR]],
          P_F = p_valid_f
        )
      ii_oof <- ii_oof + 1L

      unknown_parts[[ii_unknown]] <- unknown %>%
        transmute(
          model = model_name,
          repeat_id = r,
          fold = f,
          record_id,
          site_name,
          C = .data[[C_VAR]],
          Heip = .data[[E_VAR]],
          P_F = p_unknown_f
        )
      ii_unknown <- ii_unknown + 1L

      grid_parts[[ii_grid]] <- grid_raw %>%
        transmute(
          model = model_name,
          repeat_id = r,
          fold = f,
          C = .data[[C_VAR]],
          Heip = .data[[E_VAR]],
          P_F = p_grid_f
        )
      ii_grid <- ii_grid + 1L

      fold_metric_parts[[ii_metric]] <- calc_binary_metrics(
        truth = valid$task_label,
        p_f = p_valid_f
      ) %>%
        mutate(
          model = model_name,
          repeat_id = r,
          fold = f,
          n_train_before_balance = nrow(train),
          n_train_after_balance = length(bal_idx),
          n_validation = nrow(valid),
          .before = 1
        )
      ii_metric <- ii_metric + 1L
    }
  }
}

oof_long <- bind_rows(oof_parts)
unknown_long <- bind_rows(unknown_parts)
grid_long <- bind_rows(grid_parts)
fold_metrics <- bind_rows(fold_metric_parts)

write_csv(
  oof_long,
  file.path(OUT_DIR, "C_Heip_OOF_predictions_long.csv")
)

write_csv(
  unknown_long,
  file.path(OUT_DIR, "C_Heip_Unknown_predictions_15fits_long.csv")
)

write_csv(
  fold_metrics,
  file.path(OUT_DIR, "C_Heip_fold_metrics.csv")
)


# ------------------------------------------------------------------------------
# 9. Pooled OOF performance
# ------------------------------------------------------------------------------

# Each reference row has one held-out prediction per repeat = five OOF
# predictions. Average them before calculating the principal pooled metrics.
oof_ensemble <- oof_long %>%
  group_by(model, record_id, site_name, truth) %>%
  summarise(
    P_F = mean(P_F, na.rm = TRUE),
    n_OOF_predictions = n(),
    .groups = "drop"
  )

pooled_performance <- oof_ensemble %>%
  group_by(model) %>%
  group_modify(~ calc_binary_metrics(.x$truth, .x$P_F)) %>%
  ungroup()

fold_performance_summary <- fold_metrics %>%
  group_by(model) %>%
  summarise(
    n_folds = n(),
    BA_mean = mean(balanced_accuracy, na.rm = TRUE),
    BA_sd = sd(balanced_accuracy, na.rm = TRUE),
    AUC_mean = mean(roc_auc, na.rm = TRUE),
    AUC_sd = sd(roc_auc, na.rm = TRUE),
    Precision_mean = mean(precision, na.rm = TRUE),
    Precision_sd = sd(precision, na.rm = TRUE),
    Recall_mean = mean(recall, na.rm = TRUE),
    Recall_sd = sd(recall, na.rm = TRUE),
    Brier_mean = mean(brier, na.rm = TRUE),
    Brier_sd = sd(brier, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(
  pooled_performance,
  file.path(OUT_DIR, "C_Heip_pooled_OOF_performance.csv")
)

write_csv(
  fold_performance_summary,
  file.path(OUT_DIR, "C_Heip_fold_performance_mean_SD.csv")
)


# ------------------------------------------------------------------------------
# 10. Mean probability surface across the 15 fold-trained models
# ------------------------------------------------------------------------------

grid_mean <- grid_long %>%
  group_by(model, C, Heip) %>%
  summarise(
    Mean_P_F = mean(P_F, na.rm = TRUE),
    SD_P_F = sd(P_F, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    Probability_zone = cut(
      Mean_P_F,
      breaks = c(-Inf, 0.25, 0.50, 0.75, Inf),
      labels = c("<25% F", "25-50% F", "50-75% F", ">=75% F"),
      right = FALSE
    )
  )

write_csv(
  grid_mean,
  file.path(OUT_DIR, "C_Heip_probability_surface_grid.csv")
)


# ------------------------------------------------------------------------------
# 11. Unknown-site mean P(F) for each of the two models
# ------------------------------------------------------------------------------

# Average repeated rows within site and then across the 15 fitted models.
unknown_site_model <- unknown_long %>%
  group_by(model, repeat_id, fold, site_name) %>%
  summarise(
    C = mean(C, na.rm = TRUE),
    Heip = mean(Heip, na.rm = TRUE),
    P_F = mean(P_F, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(model, site_name) %>%
  summarise(
    C = mean(C, na.rm = TRUE),
    Heip = mean(Heip, na.rm = TRUE),
    Mean_P_F = mean(P_F, na.rm = TRUE),
    SD_P_F = sd(P_F, na.rm = TRUE),
    n_fitted_models = n(),
    .groups = "drop"
  ) %>%
  mutate(
    label = paste0(
      site_name,
      " (",
      sprintf("%.0f%%", 100 * Mean_P_F),
      ")"
    )
  )

write_csv(
  unknown_site_model,
  file.path(OUT_DIR, "C_Heip_Unknown_site_probabilities_LR_SVM.csv")
)


# ------------------------------------------------------------------------------
# 12. Reference plotting data
# ------------------------------------------------------------------------------

reference_plot <- reference %>%
  transmute(
    site_name,
    C = .data[[C_VAR]],
    Heip = .data[[E_VAR]],
    Reference_class = if_else(
      task_label == "Funerary Context",
      "Reference F",
      "Reference NF"
    )
  ) %>%
  filter(is.finite(C), is.finite(Heip))

unknown_plot <- unknown_site_model %>%
  filter(is.finite(C), is.finite(Heip))

unknown_not_plottable <- unknown_site_model %>%
  filter(!is.finite(C) | !is.finite(Heip))

if (nrow(unknown_not_plottable) > 0) {
  write_csv(
    unknown_not_plottable,
    file.path(OUT_DIR, "Unknown_sites_not_plottable_missing_C_or_Heip.csv")
  )
}


# ------------------------------------------------------------------------------
# 13. Plot function
# ------------------------------------------------------------------------------

make_probability_plot <- function(model_name) {
  surf <- grid_mean %>%
    filter(model == model_name)

  unk <- unknown_plot %>%
    filter(model == model_name)

  pooled_row <- pooled_performance %>%
    filter(model == model_name)

  ba_txt <- if (nrow(pooled_row) == 1) {
    sprintf("%.3f", pooled_row$balanced_accuracy)
  } else {
    "NA"
  }

  auc_txt <- if (nrow(pooled_row) == 1) {
    sprintf("%.3f", pooled_row$roc_auc)
  } else {
    "NA"
  }

  ggplot() +
    geom_raster(
      data = surf,
      aes(
        x = C,
        y = Heip,
        fill = Probability_zone
      ),
      interpolate = FALSE
    ) +

    # 25%, 50%, and 75% probability boundaries.
    geom_contour(
      data = surf,
      aes(
        x = C,
        y = Heip,
        z = Mean_P_F
      ),
      breaks = c(0.25, 0.75),
      colour = "grey35",
      linewidth = 0.55
    ) +
    geom_contour(
      data = surf,
      aes(
        x = C,
        y = Heip,
        z = Mean_P_F
      ),
      breaks = 0.50,
      colour = "black",
      linewidth = 0.9
    ) +

    # Reference observations.
    geom_point(
      data = reference_plot %>% filter(Reference_class == "Reference NF"),
      aes(x = C, y = Heip),
      shape = 21,
      size = 2.5,
      stroke = 0.35,
      colour = REFERENCE_NF_COLOUR,
      fill = REFERENCE_NF_COLOUR,
      alpha = 0.62
    ) +
    geom_point(
      data = reference_plot %>% filter(Reference_class == "Reference F"),
      aes(x = C, y = Heip),
      shape = 24,
      size = 2.7,
      stroke = 0.35,
      colour = REFERENCE_F_COLOUR,
      fill = REFERENCE_F_COLOUR,
      alpha = 0.72
    ) +

    # Unknown sites.
    geom_point(
      data = unk,
      aes(x = C, y = Heip),
      shape = 4,
      size = 3.8,
      stroke = 1.25,
      colour = UNKNOWN_COLOUR
    ) +
    ggrepel::geom_text_repel(
      data = unk,
      aes(x = C, y = Heip, label = label),
      size = 3.0,
      min.segment.length = 0,
      segment.alpha = 0.45,
      box.padding = 0.25,
      point.padding = 0.15,
      max.overlaps = Inf,
      seed = SEED,
      colour = "black"
    ) +

    scale_fill_manual(
      values = ZONE_COLOURS,
      drop = FALSE,
      name = "Mean P(F) zone"
    ) +

    coord_cartesian(
      xlim = xlim_raw,
      ylim = ylim_raw,
      expand = FALSE
    ) +

    labs(
      title = paste0(
        "F vs NF probability surface — ",
        model_name
      ),
      subtitle = paste0(
        "C + Heip; mean across 3-fold × 5-repeat grouped-CV fits; ",
        "boundaries at 25%, 50% and 75% | OOF BA=",
        ba_txt,
        ", AUROC=",
        auc_txt
      ),
      x = "Mean skeletal-part abundance C",
      y = "Heip anatomical evenness",
      caption = paste0(
        "Reference NF = circles; Reference F = triangles; Unknown sites = crosses. ",
        "Unknown labels show mean P(F). ",
        "P(F) is Funerary-reference affinity under balanced training, ",
        "not a literal burial probability."
      )
    ) +

    theme_bw(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      plot.subtitle = element_text(size = 10.5),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
}


# ------------------------------------------------------------------------------
# 14. Save Logistic regression and RBF-SVM maps
# ------------------------------------------------------------------------------

p_lr <- make_probability_plot("Logistic regression")
p_svm <- make_probability_plot("RBF-SVM")

ggsave(
  filename = file.path(
    OUT_DIR,
    "F_vs_NF_C_Heip_probability_surface_Logistic_regression.png"
  ),
  plot = p_lr,
  width = 13,
  height = 8.5,
  dpi = 320
)

ggsave(
  filename = file.path(
    OUT_DIR,
    "F_vs_NF_C_Heip_probability_surface_RBF_SVM.png"
  ),
  plot = p_svm,
  width = 13,
  height = 8.5,
  dpi = 320
)

# Two-page PDF containing both maps.
pdf(
  file.path(
    OUT_DIR,
    "F_vs_NF_C_Heip_probability_surfaces_LR_and_SVM.pdf"
  ),
  width = 13,
  height = 8.5
)
print(p_lr)
print(p_svm)
dev.off()


# ------------------------------------------------------------------------------
# 15. Console summary
# ------------------------------------------------------------------------------

cat("\n============================================================\n")
cat("FINISHED\n")
cat("============================================================\n\n")

cat("Pooled out-of-fold performance:\n")
print(pooled_performance)

cat("\nFold performance mean +/- SD:\n")
print(fold_performance_summary)

cat("\nUnknown-site probabilities:\n")
print(
  unknown_site_model %>%
    arrange(model, desc(Mean_P_F)) %>%
    select(model, site_name, Mean_P_F, SD_P_F, C, Heip)
)

cat("\nMain outputs written to:\n")
cat("  ", OUT_DIR, "/C_Heip_pooled_OOF_performance.csv\n", sep = "")
cat("  ", OUT_DIR, "/C_Heip_fold_performance_mean_SD.csv\n", sep = "")
cat("  ", OUT_DIR, "/C_Heip_Unknown_site_probabilities_LR_SVM.csv\n", sep = "")
cat("  ", OUT_DIR, "/F_vs_NF_C_Heip_probability_surface_Logistic_regression.png\n", sep = "")
cat("  ", OUT_DIR, "/F_vs_NF_C_Heip_probability_surface_RBF_SVM.png\n", sep = "")
cat("  ", OUT_DIR, "/F_vs_NF_C_Heip_probability_surfaces_LR_and_SVM.pdf\n", sep = "")
