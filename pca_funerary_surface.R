# =====================================================================
#  PCA decision-surface for "Funerary Context"  (3-fold CV ensemble)
#
#  1. take the best `n_features` from the RFE result
#  2. PCA them -> keep PC1, PC2   (ONE shared rotation, see note below)
#  3. K-fold CV (default K = 3): train one RF on (PC1, PC2) per fold
#     -> we end up with K models (the CV ensemble)
#  4. fill a square grid over the PC1/PC2 range; colour each cell by the
#     MEAN over the K models of P(class == "Funerary Context")
#  5. project the UNKNOWN instances through the SAME 20 features + SAME
#     PCA rotation, get each model's probability, then average:
#        - predicted class  = argmax of the MEAN class probabilities
#        - p_focus          = MEAN P("Funerary Context") over the K models
#     and PRINT every unknown site's per-model and mean probabilities.
#
#  NOTE on "train the PCA on the 3-fold CV":
#    A probability *surface* must live in a single coordinate system, so
#    the PCA rotation is fit once on all known rows (it only defines the
#    axes / where points land). The cross-validation lives in the RF
#    layer: K models are trained on the K CV training splits of those PC
#    scores, and the prediction / colouring / predict-proba are the MEAN
#    of those K models. Per-fold held-out accuracy is also reported.
# =====================================================================

library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(randomForest)
# ggrepel is optional but gives non-overlapping site labels
has_repel <- requireNamespace("ggrepel", quietly = TRUE)

# ---------------------------------------------------------------------
# helper: select + clean a fixed feature set the SAME way for any df.
# If `medians` is supplied (from the training/known data) it is reused,
# so unknown instances are imputed with TRAINING medians (no leakage).
# ---------------------------------------------------------------------
.clean_features <- function(df, feats, medians = NULL) {
  X <- as.data.frame(df)[, intersect(feats, names(df)), drop = FALSE]
  for (m in setdiff(feats, names(X))) X[[m]] <- NA_real_   # add any missing
  X <- X[, feats, drop = FALSE]
  X[] <- lapply(X, function(col) {
    v <- suppressWarnings(as.numeric(col))
    v[is.nan(v) | is.infinite(v)] <- NA_real_
    v
  })
  if (is.null(medians))
    medians <- vapply(X, function(c) stats::median(c, na.rm = TRUE), numeric(1))
  for (nm in names(X)) X[[nm]][is.na(X[[nm]])] <- medians[[nm]]
  list(X = X, medians = medians)
}

# ---------------------------------------------------------------------
# helper: mean class-probability across a list of RF models.
# Returns a matrix [nrow(newdata) x n_classes] aligned to `classes`,
# tolerant of a fold model that never saw a given class.
# ---------------------------------------------------------------------
.ensemble_prob <- function(models, newdata, classes) {
  acc <- matrix(0, nrow = nrow(newdata), ncol = length(classes),
                dimnames = list(NULL, classes))
  for (m in models) {
    pp <- stats::predict(m, newdata, type = "prob")
    for (cl in intersect(classes, colnames(pp)))
      acc[, cl] <- acc[, cl] + pp[, cl]
  }
  acc / length(models)
}

# ---------------------------------------------------------------------
# main
# ---------------------------------------------------------------------
pca_surface_plot <- function(tapho_db,
                             res,                       # output of rfe_rf / run_rfe
                             task_name   = "4class",
                             focus_class = "Funerary Context",
                             n_features  = 20,
                             ntree       = 500,
                             cv_folds    = 3,           # <- 3-fold CV ensemble
                             grid_n      = 200,         # cells per axis
                             seed        = 42,
                             unknown_sites = NULL,      # only plot these site_names (NULL = all)
                             pc2_min     = -4,          # crop PC2 below this (NULL = no crop)
                             out_plot    = "pca_funerary_surface.png") {

  set.seed(seed)
  if (is.null(cv_folds) || cv_folds < 2)
    stop("cv_folds must be >= 2.")

  # --- best features (highest importance = retained longest) ----------------
  top_feats <- res$ranking %>%
    dplyr::arrange(dplyr::desc(elimination_rank)) %>%
    dplyr::slice_head(n = n_features) %>%
    dplyr::pull(feature)
  message("Best features used: ", paste(top_feats, collapse = ", "))

  # --- split known (used so far) vs unknown (never considered) --------------
  db   <- tapho_db %>% dplyr::mutate(.row_id = dplyr::row_number())
  rec  <- task_recode_data(db, task_name = task_name,
                           target_variable = "taphonomic_context")
  known_df   <- rec$df
  unknown_df <- db %>% dplyr::filter(!(.row_id %in% known_df$.row_id))
  if (!is.null(unknown_sites)) {
    unknown_df <- unknown_df %>% dplyr::filter(site_name %in% unknown_sites)
    missing_sites <- setdiff(unknown_sites, unique(db$site_name))
    if (length(missing_sites))
      warning("site_name(s) not found in data: ",
              paste(missing_sites, collapse = ", "))
  }
  message(nrow(known_df), " known / ", nrow(unknown_df), " unknown instances")

  # --- clean known features, drop any zero-variance among them --------------
  ck <- .clean_features(known_df, top_feats)
  Xk <- ck$X
  nzv <- vapply(Xk, function(c) stats::var(c) > 0, logical(1))
  if (any(!nzv)) {
    message("Dropping zero-variance feature(s): ",
            paste(names(Xk)[!nzv], collapse = ", "))
    Xk        <- Xk[, nzv, drop = FALSE]
    top_feats <- names(Xk)
    ck$medians <- ck$medians[top_feats]
  }
  yk <- known_df[["taphonomic_context"]]
  if (!is.factor(yk)) yk <- factor(yk)
  if (!focus_class %in% levels(yk))
    stop("focus_class '", focus_class, "' is not a level of taphonomic_context")
  classes <- levels(yk)

  # --- PCA on known features (centre + scale), keep PC1/PC2 -----------------
  #     ONE shared rotation: defines the coordinate system for the surface.
  pca <- stats::prcomp(Xk, center = TRUE, scale. = TRUE)
  sc_k <- as.data.frame(stats::predict(pca, Xk)[, 1:2, drop = FALSE])
  names(sc_k) <- c("PC1", "PC2")

  # --- K-fold CV in PC space: train one RF per fold -------------------------
  set.seed(seed)
  fold_id <- sample(rep_len(seq_len(cv_folds), nrow(sc_k)))
  rf_list  <- vector("list", cv_folds)
  fold_acc <- rep(NA_real_, cv_folds)

  for (f in seq_len(cv_folds)) {
    tr <- fold_id != f
    te <- !tr
    train_f <- dplyr::mutate(sc_k[tr, , drop = FALSE], .y = yk[tr])
    if (length(unique(train_f$.y)) < 2) next
    set.seed(seed + f)
    rf_list[[f]] <- randomForest::randomForest(.y ~ PC1 + PC2,
                                               data = train_f, ntree = ntree)
    pr_te       <- stats::predict(rf_list[[f]], sc_k[te, , drop = FALSE])
    fold_acc[f] <- mean(pr_te == yk[te])
  }
  rf_list <- rf_list[!vapply(rf_list, is.null, logical(1))]
  if (!length(rf_list)) stop("No fold model could be trained.")
  message(sprintf("Per-fold held-out accuracy: %s | mean = %.4f",
                  paste(sprintf("%.3f", fold_acc), collapse = ", "),
                  mean(fold_acc, na.rm = TRUE)))

  # --- square probability grid: MEAN P(focus_class) over the K models -------
  pc2_lo <- if (is.null(pc2_min)) min(sc_k$PC2) else max(min(sc_k$PC2), pc2_min)
  g1 <- seq(min(sc_k$PC1), max(sc_k$PC1), length.out = grid_n)
  g2 <- seq(pc2_lo,        max(sc_k$PC2), length.out = grid_n)
  grid <- expand.grid(PC1 = g1, PC2 = g2)
  grid$prob <- .ensemble_prob(rf_list, grid[, c("PC1", "PC2")], classes)[, focus_class]

  # --- project unknown instances through the SAME features + rotation -------
  unk_scores <- NULL
  if (nrow(unknown_df) > 0) {
    cu  <- .clean_features(unknown_df, top_feats, medians = ck$medians)
    scu <- as.data.frame(stats::predict(pca, cu$X)[, 1:2, drop = FALSE])
    names(scu) <- c("PC1", "PC2")

    # per-model focus probability (for transparency) + mean class probs
    per_model_focus <- vapply(rf_list, function(m)
      stats::predict(m, scu[, c("PC1", "PC2")], type = "prob")[, focus_class],
      numeric(nrow(scu)))
    if (is.null(dim(per_model_focus)))               # single unknown row -> vector
      per_model_focus <- matrix(per_model_focus, nrow = 1)
    colnames(per_model_focus) <- paste0("p_model", seq_len(ncol(per_model_focus)))

    mean_probs <- .ensemble_prob(rf_list, scu[, c("PC1", "PC2")], classes)
    pred_class <- classes[max.col(mean_probs, ties.method = "first")]

    scu$site_name <- unknown_df$site_name
    scu$pred      <- factor(pred_class, levels = classes)
    scu$p_focus   <- mean_probs[, focus_class]       # MEAN over the K models
    scu <- cbind(scu, as.data.frame(per_model_focus))
    unk_scores <- scu
  }

  known_pts <- dplyr::mutate(sc_k, class = yk)

  # --- crop PC2 outliers from the points too --------------------------------
  if (!is.null(pc2_min)) {
    known_pts <- dplyr::filter(known_pts, PC2 >= pc2_min)
    if (!is.null(unk_scores)) unk_scores <- dplyr::filter(unk_scores, PC2 >= pc2_min)
  }

  # --- plot -----------------------------------------------------------------
  p <- ggplot() +
    geom_raster(data = grid, aes(PC1, PC2, fill = prob), interpolate = TRUE) +
    geom_contour(data = grid, aes(PC1, PC2, z = prob),
                 breaks = 0.5, colour = "white", linewidth = 0.4) +
    scale_fill_gradientn(
      colours = c("#3b4cc0", "#7b9ff9", "#f7f7f7", "#f4987a", "#b40426"),
      limits = c(0, 1), name = paste0("mean P(", focus_class, ")")) +
    geom_point(data = known_pts, aes(PC1, PC2, colour = class),
               size = 2, alpha = 0.9) +
    scale_colour_brewer(palette = "Dark2", name = "Known class")

  if (!is.null(unk_scores)) {
    p <- p + geom_point(data = unk_scores, aes(PC1, PC2),
                        shape = 4, size = 2.6, stroke = 1.1, colour = "black")
    lab <- aes(PC1, PC2, label = site_name)
    p <- p + if (has_repel)
      ggrepel::geom_text_repel(data = unk_scores, lab, size = 3,
                               max.overlaps = Inf, box.padding = 0.4,
                               min.segment.length = 0)
    else
      geom_text(data = unk_scores, lab, size = 3, vjust = -0.8)
  }

  p <- p +
    labs(title = paste0("RF probability surface (", length(rf_list),
                        "-model CV mean) — ", focus_class),
         subtitle = paste0(task_name, " | mean of ", length(rf_list),
                           " RF models on PC1/PC2 of best ",
                           length(top_feats), " features | x = unknown sites"),
         x = sprintf("PC1 (%.1f%% var)", 100 * summary(pca)$importance[2, 1]),
         y = sprintf("PC2 (%.1f%% var)", 100 * summary(pca)$importance[2, 2])) +
    coord_cartesian(ylim = c(pc2_lo, max(sc_k$PC2)), expand = FALSE) +
    theme_minimal(base_size = 12)

  ggsave(out_plot, p, width = 9, height = 7, dpi = 150)
  print(p)
  message("Wrote surface -> ", out_plot)

  # --- PRINT the predict-proba of every unknown site -----------------------
  if (!is.null(unk_scores) && nrow(unk_scores) > 0) {
    prob_cols <- grep("^p_model", names(unk_scores), value = TRUE)
    out_tbl <- unk_scores %>%
      dplyr::select(site_name, predicted = pred,
                    dplyr::all_of(prob_cols), p_focus_mean = p_focus) %>%
      dplyr::mutate(dplyr::across(c(dplyr::all_of(prob_cols), p_focus_mean),
                                  ~ round(.x, 4))) %>%
      dplyr::arrange(dplyr::desc(p_focus_mean))

    message("\n=== Predicted probability of '", focus_class,
            "' per unknown site (mean over ", length(rf_list), " models) ===")
    print(as.data.frame(out_tbl), row.names = FALSE)
  }

  invisible(list(plot = p, pca = pca, rf_list = rf_list, fold_acc = fold_acc,
                 top_feats = top_feats, medians = ck$medians,
                 known = known_pts, grid = grid, unknown = unk_scores))
}

# ---------------------------------------------------------------------
# Example
# ---------------------------------------------------------------------
# res <- run_rfe(tapho_db, task_name = "4class")          # 3-fold CV RFE
# focus_sites <- c(
#   "Kleine Feldhofer Grotte", "Bilzingsleben", "Weimar-Ehringsdorf",
#   "Scladina Cave", "Engis / Schmerling Cave", "Trou de la Naulette",
#   "Bolomor Cave", "Cova de les Malladetes (Barx, Valencia, Spain)",
#   "Cova del Parpalló (Parpalló Cave)", "Saint-Césaire",
#   "Steinheim an der Murr", "Ochoz 1, Ochoz 2", "Peștera Muierii",
#   "Sima de los Huesos"
# )
# pr  <- pca_surface_plot(tapho_db, res, task_name = "4class",
#                         cv_folds = 3, unknown_sites = focus_sites)
# pr$unknown    # projected unknown sites: predicted class, per-model & mean P(focus)
