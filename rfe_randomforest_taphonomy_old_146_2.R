# =====================================================================
#  Recursive Feature Elimination (RFE) with randomForest
#  Target: taphonomic_context
#
#  Procedure (adapted):
#    * at EACH step run K-fold cross-validation (default K = 3)
#        - train one RF per fold (on that fold's training split)
#        - record per-fold accuracy on the held-out fold
#        - record per-fold feature importance (MeanDecreaseGini)
#    * accuracy reported per step = MEAN of the K fold accuracies
#    * importance used to eliminate  = MEAN of the K fold importances
#    * while > small_threshold features remain -> drop the big_step least important
#    * once <= small_threshold (but > min_features) -> drop `small_step`
#      (small_step defaults to 5 and is controllable from run_rfe())
#    * once <= min_features -> train once more, stop & plot
#    * write a step-by-step ranked CSV of eliminated features
# =====================================================================

library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(readr)
library(randomForest)
library(rlang)

# ---------------------------------------------------------------------
# 0. Metadata columns to remove (everything except the target).
#    taphonomic_context is intentionally NOT here -- it is the label.
# ---------------------------------------------------------------------
meta_cols <- c(
  "site_name", "ind_name", "site_id", "individual_id", "layer_name",
  "count_type", "geological_period", "cultural_period", "culture_period_2",
  "start_date_cal_bp", "end_date_cal_bp", "mis_stage",
  "karstic_system", "karstic_system_2", "open_air_site", "open_air_site_2",
  "region", "country", "mni", "age_category",
  "n_infant", "n_juvenil", "n_subadult", "n_adult", "gender",
  "funerary_context", "discovery_context", "degree_of_excavation",
  "hominin_species", "observation", "reference"
)

# ---------------------------------------------------------------------
# 1. Your task recoder (unchanged) — builds the labelled data frame.
# ---------------------------------------------------------------------
task_recode_data <- function(raw_df,
                             task_name,
                             target_variable = "taphonomic_context") {
  tvsym <- rlang::sym(target_variable)
  if (task_name == "4class") {
    class_levels <- c("Cannibalism", "Carnivore",
                      "Funerary Context", "Geological transport")
    df <- raw_df %>%
      dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
    use_downsample <- FALSE
  } else if (task_name == "cannibalism_vs_fc") {
    class_levels <- c("Cannibalism", "Funerary Context")
    df <- raw_df %>%
      dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
    use_downsample <- TRUE
  } else if (task_name == "fc_vs_rest") {
    rest_classes <- c("Cannibalism", "Carnivore", "Geological transport")
    class_levels <- c("Funerary Context", "rest")
    df <- raw_df %>%
      dplyr::mutate(!!tvsym := dplyr::case_when(
        .data[[target_variable]] %in% rest_classes      ~ "rest",
        .data[[target_variable]] == "Funerary Context"  ~ "Funerary Context",
        TRUE                                            ~ NA_character_)) %>%
      dplyr::filter(!is.na(.data[[target_variable]])) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
    use_downsample <- TRUE
  } else {
    stop("Unknown task_name: ", task_name)
  }
  message("Class distribution (", task_name, "):")
  print(table(df[[target_variable]], useNA = "ifany"))
  missing_classes <- setdiff(levels(df[[target_variable]]), unique(df[[target_variable]]))
  if (length(missing_classes))
    warning("Some expected classes missing: ", paste(missing_classes, collapse = ", "))
  list(df = df, class_levels = levels(df[[target_variable]]),
       use_downsample = use_downsample)
}

# ---------------------------------------------------------------------
# 2. Drop meta + non-usable columns; keep target + clean numeric features.
#    (unchanged)
# ---------------------------------------------------------------------
prep_features <- function(df,
                          target_variable = "taphonomic_context",
                          drop_meta       = meta_cols) {

  y <- df[[target_variable]]
  if (!is.factor(y)) y <- factor(y)

  X <- df %>%
    dplyr::select(-dplyr::any_of(setdiff(drop_meta, target_variable))) %>%
    dplyr::select(-dplyr::any_of(target_variable)) %>%
    dplyr::select(where(~ !is.list(.x))) %>%          # drop list-columns
    dplyr::select(where(~ is.numeric(.x) || is.logical(.x))) %>%
    dplyr::mutate(dplyr::across(where(is.logical), as.numeric)) %>%
    dplyr::mutate(dplyr::across(everything(),
                                ~ ifelse(is.nan(.x) | is.infinite(.x), NA_real_, .x)))

  # drop all-NA or zero-variance predictors
  keep <- vapply(X, function(col) {
    v <- col[!is.na(col)]
    length(v) > 0 && stats::var(v) > 0
  }, logical(1))
  X <- X[, keep, drop = FALSE]

  # median-impute remaining NAs
  X <- X %>% dplyr::mutate(dplyr::across(everything(),
              ~ ifelse(is.na(.x), stats::median(.x, na.rm = TRUE), .x)))

  message("Predictors kept after cleaning: ", ncol(X))
  list(X = X, y = y)
}

# ---------------------------------------------------------------------
# 3. K-fold CV fit used at EVERY RFE step.
#    Trains one RF per fold and returns:
#      * accuracy   = mean of the K held-out fold accuracies
#      * importance = mean MeanDecreaseGini across the K fold models
#      * fold_acc   = the individual fold accuracies (for inspection)
#    Folds are derived deterministically from `seed` and the number of
#    rows, so they stay identical across RFE steps (only X columns shrink).
# ---------------------------------------------------------------------
cv_fit_importance <- function(X, y, ntree, folds, seed) {
  set.seed(seed)
  fold_id <- sample(rep_len(seq_len(folds), length(y)))

  feat_names <- names(X)
  imp_mat <- matrix(NA_real_, nrow = length(feat_names), ncol = folds,
                    dimnames = list(feat_names, NULL))
  accs <- rep(NA_real_, folds)

  for (f in seq_len(folds)) {
    tr <- fold_id != f
    te <- !tr
    if (length(unique(y[tr])) < 2) next   # cannot train a classifier on 1 class

    set.seed(seed + f)                     # reproducible per-fold model
    m <- randomForest::randomForest(x = X[tr, , drop = FALSE], y = y[tr],
                                    ntree = ntree)

    pr      <- predict(m, X[te, , drop = FALSE])
    accs[f] <- mean(pr == y[te])

    imp <- randomForest::importance(m, type = 2)        # MeanDecreaseGini
    imp_mat[rownames(imp), f] <- imp[, 1]
  }

  list(accuracy   = mean(accs, na.rm = TRUE),
       importance = rowMeans(imp_mat, na.rm = TRUE),    # MEAN over folds
       fold_acc   = accs)
}

# ---------------------------------------------------------------------
# 4. The RFE loop — now driven by K-fold CV mean importance.
# ---------------------------------------------------------------------
rfe_rf <- function(X, y,
                   big_step        = 40,
                   small_threshold = 40,
                   small_step      = 5,     # <- smaller steps, set from run_rfe()
                   min_features    = 10,
                   ntree           = 500,
                   cv_folds        = 3,     # <- 3-fold CV by default
                   guard_overshoot = TRUE,  # avoid skipping the small-step phase
                   seed            = 42) {

  if (is.null(cv_folds) || cv_folds < 2)
    stop("cv_folds must be >= 2 for cross-validated importance.")

  current    <- names(X)
  history    <- list()   # accuracy at each model size
  eliminated <- list()   # features removed at each step
  step       <- 0L

  repeat {
    step <- step + 1L
    Xc   <- X[, current, drop = FALSE]

    # ---- K-fold CV: per-fold models -> mean accuracy + mean importance ----
    fit <- cv_fit_importance(Xc, y, ntree = ntree, folds = cv_folds, seed = seed)
    acc <- fit$accuracy

    imp_df <- tibble::tibble(feature    = names(fit$importance),
                             importance = as.numeric(fit$importance)) %>%
              dplyr::arrange(importance)              # least important first

    history[[step]] <- tibble::tibble(step = step,
                                      n_features = length(current),
                                      accuracy   = acc)
    n <- length(current)
    message(sprintf("step %2d | %3d features | mean CV accuracy = %.4f (folds: %s)",
                    step, n, acc,
                    paste(sprintf("%.3f", fit$fold_acc), collapse = ", ")))

    if (n <= min_features) break                       # final model trained; stop

    k <- if (n > small_threshold) big_step else small_step
    if (guard_overshoot && n > small_threshold)
      k <- min(k, n - small_threshold)                 # land at/above threshold
    k <- min(k, n - 1L)                                # never drop every feature

    drop_feats <- imp_df$feature[seq_len(k)]
    eliminated[[step]] <- tibble::tibble(
      step              = step,
      n_features_before = n,
      accuracy_before   = acc,
      feature           = drop_feats,
      importance        = imp_df$importance[seq_len(k)]  # mean-of-folds importance
    )
    current <- setdiff(current, drop_feats)
  }

  history    <- dplyr::bind_rows(history)
  eliminated <- dplyr::bind_rows(eliminated)
  retained   <- current

  # global elimination ranking: order of removal = ascending mean importance.
  # rank 1 = eliminated first (least useful); retained features rank last.
  elim_ranked <- eliminated %>%
    dplyr::mutate(status = "eliminated") %>%
    dplyr::arrange(step, importance) %>%
    dplyr::mutate(elimination_rank = dplyr::row_number())

  retained_tbl <- tibble::tibble(
    step              = NA_integer_,
    n_features_before = length(retained),
    accuracy_before   = dplyr::last(history$accuracy),
    feature           = retained,
    importance        = NA_real_,
    status            = "retained",
    elimination_rank  = nrow(elim_ranked) + seq_along(retained)
  )

  ranking <- dplyr::bind_rows(elim_ranked, retained_tbl)

  best <- history %>% dplyr::slice_max(accuracy, n = 1, with_ties = FALSE)

  list(history = history,
       eliminated = eliminated,
       ranking = ranking,
       retained = retained,
       best = best)
}

# ---------------------------------------------------------------------
# 5. Driver: run end-to-end, plot, and write CSV.
#     `small_step` is the controllable "n" for the fine elimination phase.
# ---------------------------------------------------------------------
run_rfe <- function(tapho_db,
                    task_name  = "4class",
                    out_csv    = "feature_elimination_ranking.csv",
                    out_plot   = "feature_elimination_curve.png",
                    cv_folds   = 3,    # 3-fold cross-validation
                    small_step = 5,    # <- n: fine elimination step size (external control)
                    seed       = 42) {

  rec  <- task_recode_data(tapho_db, task_name = task_name,
                           target_variable = "taphonomic_context")
  prep <- prep_features(rec$df, target_variable = "taphonomic_context")

  res <- rfe_rf(prep$X, prep$y,
                small_step = small_step,
                cv_folds   = cv_folds,
                seed       = seed)

  # ---- plot: accuracy vs number of features (elimination read left->right) ----
  p <- ggplot(res$history, aes(x = n_features, y = accuracy)) +
    geom_line(linewidth = 0.7, colour = "grey40") +
    geom_point(size = 2) +
    geom_point(data = res$best, colour = "firebrick", size = 3.5) +
    geom_text(data = res$best,
              aes(label = sprintf("best: %d feats\nacc %.3f", n_features, accuracy)),
              vjust = -0.8, hjust = 0.5, size = 3, colour = "firebrick") +
    scale_x_reverse() +
    labs(title = paste0("RFE (randomForest, ", cv_folds, "-fold CV) — ", task_name),
         subtitle = "Mean CV accuracy as features are recursively eliminated (mean-importance)",
         x = "Number of features (eliminated left to right)",
         y = "Mean CV accuracy") +
    theme_minimal(base_size = 12)

  ggsave(out_plot, p, width = 8, height = 5, dpi = 150)
  print(p)

  # ---- ranked CSV of eliminated (then retained) features ----
  readr::write_csv(res$ranking, out_csv)
  message("Wrote ranking -> ", out_csv)
  message("Wrote plot    -> ", out_plot)
  message(sprintf("Best subset: %d features at mean CV accuracy %.4f",
                  res$best$n_features, res$best$accuracy))

  invisible(res)
}

# ---------------------------------------------------------------------
# 6. Example call
# ---------------------------------------------------------------------
# res <- run_rfe(tapho_db, task_name = "4class")                       # 3-fold CV, step n = 5
# res <- run_rfe(tapho_db, task_name = "fc_vs_rest", small_step = 5)   # control the fine step
# res <- run_rfe(tapho_db, task_name = "4class", cv_folds = 5, small_step = 3)
# res$best        # best feature-count / mean CV accuracy
# res$retained    # the surviving features
