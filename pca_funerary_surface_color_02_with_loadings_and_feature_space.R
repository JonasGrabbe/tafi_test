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
# PCA loading helpers for biplot-style overlays.
#
# pca$rotation contains the ORIGINAL FEATURE loadings.  The raw loadings
# are kept for interpretation, while the plotted endpoints are multiplied
# by ONE common factor so that loading vectors are visible in score space.
# The common multiplier changes only visual length, never angle or relative
# length between features.
# ---------------------------------------------------------------------
.pca_loading_table <- function(pca, pcs = 1:2, score_df,
                               scale_fraction = 0.70, top_n = NULL) {
  axes <- paste0("PC", pcs)
  if (!all(axes %in% colnames(pca$rotation)))
    stop("Requested PCA component(s) not available in pca$rotation.")
  if (!all(axes %in% names(score_df)))
    stop("score_df must contain: ", paste(axes, collapse = ", "))

  L <- as.data.frame(pca$rotation[, axes, drop = FALSE])
  L$feature <- rownames(L)

  # Preserve raw loadings explicitly before creating display coordinates.
  for (ax in axes) L[[paste0(ax, "_loading")]] <- L[[ax]]

  L$loading_strength <- sqrt(rowSums(as.matrix(L[, axes, drop = FALSE])^2))
  L$representation_pct <- 100 * L$loading_strength^2

  # Optional: retain only the strongest vectors in the displayed PC space.
  L <- L[order(L$loading_strength, decreasing = TRUE), , drop = FALSE]
  if (!is.null(top_n)) {
    top_n <- max(1L, min(as.integer(top_n), nrow(L)))
    L <- L[seq_len(top_n), , drop = FALSE]
  }

  # Find one common display multiplier that fits every vector in the current
  # score-space extent.  This is the standard biplot idea: raw loadings live
  # around [-1, 1], whereas PCA scores usually span a much larger range.
  score_extent <- vapply(axes, function(ax)
    max(abs(score_df[[ax]]), na.rm = TRUE), numeric(1))
  load_extent <- vapply(axes, function(ax)
    max(abs(L[[ax]]), na.rm = TRUE), numeric(1))

  ratio <- score_extent / load_extent
  ratio <- ratio[is.finite(ratio) & ratio > 0]
  mult <- if (length(ratio)) scale_fraction * min(ratio) else 1

  for (ax in axes) L[[ax]] <- L[[ax]] * mult
  L$display_multiplier <- mult

  # Human-readable hover for the interactive 3D plot.
  raw_cols <- paste0(axes, "_loading")
  hover_parts <- lapply(seq_len(nrow(L)), function(i) {
    vals <- paste0(axes, " loading: ",
                   sprintf("%.3f", as.numeric(unlist(L[i, raw_cols, drop = FALSE], use.names = FALSE))),
                   collapse = "<br>")
    paste0("<b>", L$feature[i], "</b><br>", vals,
           "<br>Displayed-space strength: ", sprintf("%.3f", L$loading_strength[i]),
           "<br>Representation in shown PCs: ",
           sprintf("%.1f%%", L$representation_pct[i]))
  })
  L$hover <- unlist(hover_parts)
  rownames(L) <- NULL
  L
}

.add_pca_loadings_plotly <- function(p, loadings, labels = TRUE) {
  if (is.null(loadings) || !nrow(loadings)) return(p)

  n <- nrow(loadings)
  seg_x <- as.vector(rbind(rep(0, n), loadings$PC1, rep(NA_real_, n)))
  seg_y <- as.vector(rbind(rep(0, n), loadings$PC2, rep(NA_real_, n)))
  seg_z <- as.vector(rbind(rep(0, n), loadings$PC3, rep(NA_real_, n)))

  # Vector shafts. NA separators keep all vectors in one efficient trace.
  p <- plotly::add_trace(
    p, x = seg_x, y = seg_y, z = seg_z,
    type = "scatter3d", mode = "lines",
    line = list(color = "rgba(25,25,25,0.70)", width = 5),
    hoverinfo = "skip", showlegend = FALSE, inherit = FALSE
  )

  # Vector tips + labels. Hover reports the UN-SCALED loadings.
  p <- plotly::add_trace(
    p, data = loadings,
    x = ~PC1, y = ~PC2, z = ~PC3,
    type = "scatter3d",
    mode = if (isTRUE(labels)) "markers+text" else "markers",
    text = if (isTRUE(labels)) ~feature else NULL,
    textposition = "top center",
    hovertext = ~hover, hoverinfo = "text",
    marker = list(size = 3.5, color = "black", symbol = "diamond"),
    name = "PCA feature loadings",
    inherit = FALSE
  )

  p
}

# ---------------------------------------------------------------------
# helper: scalarize assemblage-level list-columns for raw feature plots.
# Some tapho.loader outputs (e.g. Mean_part_abundance) are stored as a
# repeated vector inside each row.  For feature-space plotting we use the
# FIRST value from each row, leaving the original tapho_db untouched.
# ---------------------------------------------------------------------
.scalarize_first_list_value <- function(df, feature_names) {
  out <- df

  for (nm in intersect(feature_names, names(out))) {
    if (is.list(out[[nm]])) {
      out[[nm]] <- vapply(out[[nm]], function(x) {
        if (is.null(x) || length(x) == 0L) return(NA_real_)
        suppressWarnings(as.numeric(x[[1]]))
      }, numeric(1))
    }
  }

  out
}

# ---------------------------------------------------------------------
# main
# ---------------------------------------------------------------------
pca_surface_plot <- function(tapho_db,
                             res,                       # output of rfe_rf / run_rfe
                             task_name   = "4class",
                             focus_class = "Funerary Context",
                             n_features  =15,
                             ntree       = 500,
                             cv_folds    = 3,           # <- 3-fold CV ensemble
                             grid_n      = 200,         # cells per axis
                             seed        = 35,
                             unknown_sites = NULL,      # only plot these site_names (NULL = all)
                             pc2_max     =  NULL,
                             pc2_min     = NULL,          # crop PC2 below this (NULL = no crop)

                             # PCA biplot loading vectors
                             show_loadings = TRUE,
                             loading_scale_fraction = 0.70,
                             loading_top_n = NULL,        # NULL = all selected features
                             loading_labels = TRUE,

                             # second plot in ORIGINAL feature space
                             show_feature_space = TRUE,
                             out_feature_plot = "feature_surface_MeanPartAbundance_allSectionsDominance.png",

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
  pc2_hi <- if (is.null(pc2_max)) max(sc_k$PC2) else min(max(sc_k$PC2), pc2_max)
  
  g1 <- seq(min(sc_k$PC1), max(sc_k$PC1), length.out = grid_n)
  g2 <- seq(pc2_lo, pc2_hi, length.out = grid_n)


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
  # carry each known row's site_name so it can be labelled in the plot
  known_pts$site_name <- if ("site_name" %in% names(known_df))
    as.character(known_df$site_name) else NA_character_

  # --- crop PC2 outliers from the points too --------------------------------
  if (!is.null(pc2_min)) {
    known_pts <- dplyr::filter(known_pts, PC2 >= pc2_min)
    if (!is.null(unk_scores)) unk_scores <- dplyr::filter(unk_scores, PC2 >= pc2_min)
  }
  
  if (!is.null(pc2_max)) {
    known_pts <- dplyr::filter(known_pts, PC2 <= pc2_max)
    if (!is.null(unk_scores)) unk_scores <- dplyr::filter(unk_scores, PC2 <= pc2_max)
  }

  # --- PCA loadings: original feature directions in the PC1/PC2 plane ------
  loading_tbl <- NULL
  if (isTRUE(show_loadings)) {
    score_extent_df <- data.frame(
      PC1 = range(sc_k$PC1, na.rm = TRUE),
      PC2 = c(pc2_lo, pc2_hi)
    )
    loading_tbl <- .pca_loading_table(
      pca, pcs = 1:2, score_df = score_extent_df,
      scale_fraction = loading_scale_fraction,
      top_n = loading_top_n
    )
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

  # Biplot-style loading arrows.  All endpoints use one shared multiplier,
  # therefore angles and relative vector lengths are preserved exactly.
  if (!is.null(loading_tbl) && nrow(loading_tbl) > 0) {
    p <- p +
      geom_segment(
        data = loading_tbl,
        aes(x = 0, y = 0, xend = PC1, yend = PC2),
        inherit.aes = FALSE,
        linewidth = 0.55, alpha = 0.80, colour = "black",
        arrow = grid::arrow(length = grid::unit(0.12, "inches"))
      )

    if (isTRUE(loading_labels)) {
      load_lab <- aes(PC1, PC2, label = feature)
      p <- p + if (has_repel)
        ggrepel::geom_text_repel(
          data = loading_tbl, load_lab, inherit.aes = FALSE,
          size = 2.7, colour = "black", max.overlaps = Inf,
          box.padding = 0.25, min.segment.length = 0
        )
      else
        geom_text(
          data = loading_tbl, load_lab, inherit.aes = FALSE,
          size = 2.7, colour = "black", vjust = -0.4
        )
    }
  }

  ## --- label every KNOWN site, coloured by its class ------------------------
  #known_lab <- aes(PC1, PC2, label = site_name, colour = class)
  #p <- p + if (has_repel)
  #  ggrepel::geom_text_repel(data = known_pts, known_lab, size = 3,
  #                           max.overlaps = Inf, box.padding = 0.4,
  #                           min.segment.length = 0, show.legend = FALSE)
  #else
  #  geom_text(data = known_pts, known_lab, size = 3, vjust = -0.8,
  #            show.legend = FALSE)

  # --- unknown sites: black x markers + black labels ------------------------
  if (!is.null(unk_scores)) {
    p <- p + geom_point(data = unk_scores, aes(PC1, PC2),
                        shape = 4, size = 2.6, stroke = 1.1, colour = "black")
    lab <- aes(PC1, PC2, label = site_name)
    p <- p + if (has_repel)
      ggrepel::geom_text_repel(data = unk_scores, lab, size = 3,
                               colour = "black",
                               max.overlaps = Inf, box.padding = 0.4,
                               min.segment.length = 0)
    else
      geom_text(data = unk_scores, lab, size = 3, vjust = -0.8,
                colour = "black")
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
  message("Wrote PCA surface -> ", out_plot)

  # --- SECOND GRAPH: raw feature-space RF surface --------------------------
  # X = Mean_part_abundance
  # Y = all_sections_dominance
  # Mean_part_abundance can be a repeated list-column, so take the first
  # value from each row only for this feature-space plot.
  feature_plot <- NULL
  if (isTRUE(show_feature_space)) {
    feature_db <- .scalarize_first_list_value(
      tapho_db,
      c("Mean_part_abundance", "all_sections_dominance")
    )

    feature_plot <- feature_surface_plot(
      tapho_db = feature_db,
      res = res,
      features = c("Mean_part_abundance", "all_sections_dominance"),
      task_name = task_name,
      focus_class = focus_class,
      n_features = n_features,
      ntree = ntree,
      cv_folds = cv_folds,
      grid_n = grid_n,
      seed = seed,
      unknown_sites = unknown_sites,
      label_var = "site_name",
      label_unknown = TRUE,
      out_plot = out_feature_plot
    )
  }

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

  invisible(list(plot = p, feature_plot = feature_plot,
                 pca = pca, rf_list = rf_list, fold_acc = fold_acc,
                 top_feats = top_feats, medians = ck$medians,
                 loadings = loading_tbl,
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


# ---------------------------------------------------------------------
# main: 3D plotly version using PC1/PC2/PC3
# ---------------------------------------------------------------------
pca_surface_plotly <- function(tapho_db,
  res,                       # output of rfe_rf / run_rfe
  task_name   = "4class",
  focus_class = "Funerary Context",
  n_features  = 20,
  ntree       = 500,
  cv_folds    = 3,
  seed        = 42,
  unknown_sites = NULL,

  # optional PCA-axis cropping
  pc1_min = NULL,
  pc1_max = NULL,
  pc2_min = NULL,
  pc2_max = NULL,
  pc3_min = NULL,
  pc3_max = NULL,

  # labels in 3D can get messy
  label_known   = FALSE,
  label_unknown = TRUE,

  # PCA biplot loading vectors
  show_loadings = TRUE,
  loading_scale_fraction = 0.70,
  loading_top_n = NULL,       # NULL = all selected features
  loading_labels = TRUE,

  # second 3D plot in ORIGINAL feature space
  show_feature_space = TRUE,
  out_feature_html = "feature_surface_3d_MeanPartAbundance_allSectionsDominance_upperAppendicular.html",

  out_html = NULL) {

if (!requireNamespace("plotly", quietly = TRUE)) {
stop("Package 'plotly' is required. Install it with install.packages('plotly').")
}

if (!is.null(out_html) && !requireNamespace("htmlwidgets", quietly = TRUE)) {
stop("Package 'htmlwidgets' is required to save HTML. Install it with install.packages('htmlwidgets').")
}

set.seed(seed)
if (is.null(cv_folds) || cv_folds < 2)
stop("cv_folds must be >= 2.")

# --- best features --------------------------------------------------------
top_feats <- res$ranking %>%
dplyr::arrange(dplyr::desc(elimination_rank)) %>%
dplyr::slice_head(n = n_features) %>%
dplyr::pull(feature)

message("Best features used: ", paste(top_feats, collapse = ", "))

# --- split known vs unknown ----------------------------------------------
db <- tapho_db %>% dplyr::mutate(.row_id = dplyr::row_number())

rec <- task_recode_data(
db,
task_name = task_name,
target_variable = "taphonomic_context"
)

known_df   <- rec$df
unknown_df <- db %>% dplyr::filter(!(.row_id %in% known_df$.row_id))

if (!is.null(unknown_sites)) {
unknown_df <- unknown_df %>% dplyr::filter(site_name %in% unknown_sites)

missing_sites <- setdiff(unknown_sites, unique(db$site_name))
if (length(missing_sites)) {
warning(
"site_name(s) not found in data: ",
paste(missing_sites, collapse = ", ")
)
}
}

message(nrow(known_df), " known / ", nrow(unknown_df), " unknown instances")

# --- clean known features -------------------------------------------------
ck <- .clean_features(known_df, top_feats)
Xk <- ck$X

# --- drop unusable / zero-variance features --------------------------------
# var() can be NA if the feature is all NA, all non-finite, or otherwise
# cannot produce a valid variance. Treat those as unusable.

# --- drop unusable / zero-variance features --------------------------------
feat_var <- vapply(Xk, function(c) {
  c <- suppressWarnings(as.numeric(c))
  c <- c[is.finite(c)]

  if (length(c) < 2) return(NA_real_)

  stats::var(c)
}, numeric(1))

keep_feat <- is.finite(feat_var) & feat_var > 0

# optional diagnostic print
print(data.frame(
  feature  = names(feat_var),
  variance = feat_var,
  keep     = keep_feat
))

if (any(!keep_feat)) {
  message(
    "Dropping unusable / zero-variance feature(s): ",
    paste(names(Xk)[!keep_feat], collapse = ", ")
  )

  Xk <- Xk[, keep_feat, drop = FALSE]
  top_feats <- names(Xk)
  ck$medians <- ck$medians[top_feats]
}

if (ncol(Xk) < 3) {
  stop(
    "Fewer than 3 usable non-zero-variance features remain after cleaning. ",
    "Cannot compute PC1/PC2/PC3."
  )
}
yk <- known_df[["taphonomic_context"]]
if (!is.factor(yk)) yk <- factor(yk)

if (!focus_class %in% levels(yk)) {
stop("focus_class '", focus_class, "' is not a level of taphonomic_context")
}

classes <- levels(yk)

# --- PCA on known features: keep PC1, PC2, PC3 ----------------------------
pca <- stats::prcomp(Xk, center = TRUE, scale. = TRUE)

scores_all <- stats::predict(pca, Xk)

if (ncol(scores_all) < 3) {
stop("PCA returned fewer than 3 components. Use more non-zero-variance features/rows.")
}

sc_k <- as.data.frame(scores_all[, 1:3, drop = FALSE])
names(sc_k) <- c("PC1", "PC2", "PC3")

# --- K-fold CV in 3D PC space --------------------------------------------
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

rf_list[[f]] <- randomForest::randomForest(
.y ~ PC1 + PC2 + PC3,
data = train_f,
ntree = ntree
)

pr_te <- stats::predict(rf_list[[f]], sc_k[te, , drop = FALSE])
fold_acc[f] <- mean(pr_te == yk[te])
}

rf_list <- rf_list[!vapply(rf_list, is.null, logical(1))]

if (!length(rf_list)) stop("No fold model could be trained.")

message(sprintf(
"Per-fold held-out accuracy: %s | mean = %.4f",
paste(sprintf("%.3f", fold_acc), collapse = ", "),
mean(fold_acc, na.rm = TRUE)
))

# --- helper: one-model focus probability, tolerant of missing classes -----
.focus_prob_one_model <- function(model, newdata, focus_class) {
pp <- stats::predict(model, newdata, type = "prob")

if (focus_class %in% colnames(pp)) {
pp[, focus_class]
} else {
rep(0, nrow(newdata))
}
}

# --- known point probabilities, for hover text ----------------------------
known_probs <- .ensemble_prob(
rf_list,
sc_k[, c("PC1", "PC2", "PC3")],
classes
)

known_pred <- classes[max.col(known_probs, ties.method = "first")]

known_pts <- dplyr::mutate(
sc_k,
class   = yk,
pred    = factor(known_pred, levels = classes),
p_focus = known_probs[, focus_class]
)

known_pts$site_name <- if ("site_name" %in% names(known_df)) {
as.character(known_df$site_name)
} else {
NA_character_
}

# --- project unknown instances through SAME features + SAME PCA rotation --
unk_scores <- NULL

if (nrow(unknown_df) > 0) {
cu <- .clean_features(unknown_df, top_feats, medians = ck$medians)

scu_all <- stats::predict(pca, cu$X)
scu <- as.data.frame(scu_all[, 1:3, drop = FALSE])
names(scu) <- c("PC1", "PC2", "PC3")

per_model_focus <- vapply(
rf_list,
function(m) .focus_prob_one_model(m, scu[, c("PC1", "PC2", "PC3")], focus_class),
numeric(nrow(scu))
)

if (is.null(dim(per_model_focus))) {
per_model_focus <- matrix(per_model_focus, nrow = 1)
}

colnames(per_model_focus) <- paste0("p_model", seq_len(ncol(per_model_focus)))

mean_probs <- .ensemble_prob(
rf_list,
scu[, c("PC1", "PC2", "PC3")],
classes
)

pred_class <- classes[max.col(mean_probs, ties.method = "first")]

scu$site_name <- unknown_df$site_name
scu$pred      <- factor(pred_class, levels = classes)
scu$p_focus   <- mean_probs[, focus_class]

scu <- cbind(scu, as.data.frame(per_model_focus))
unk_scores <- scu
}

# --- axis ranges / cropping ----------------------------------------------
.axis_range <- function(x, lo_arg, hi_arg, axis_name) {
lo <- if (is.null(lo_arg)) min(x, na.rm = TRUE) else max(min(x, na.rm = TRUE), lo_arg)
hi <- if (is.null(hi_arg)) max(x, na.rm = TRUE) else min(max(x, na.rm = TRUE), hi_arg)

if (!is.finite(lo) || !is.finite(hi) || lo >= hi) {
stop("Invalid range for ", axis_name, ": lower bound must be below upper bound.")
}

c(lo, hi)
}

pc1_rng <- .axis_range(sc_k$PC1, pc1_min, pc1_max, "PC1")
pc2_rng <- .axis_range(sc_k$PC2, pc2_min, pc2_max, "PC2")
pc3_rng <- .axis_range(sc_k$PC3, pc3_min, pc3_max, "PC3")

.crop_3pc <- function(df) {
if (is.null(df) || nrow(df) == 0) return(df)

df %>%
dplyr::filter(
PC1 >= pc1_rng[1], PC1 <= pc1_rng[2],
PC2 >= pc2_rng[1], PC2 <= pc2_rng[2],
PC3 >= pc3_rng[1], PC3 <= pc3_rng[2]
)
}

known_pts_plot <- .crop_3pc(known_pts)
unk_scores_plot <- .crop_3pc(unk_scores)

# --- PCA loadings: original feature directions in PC1/PC2/PC3 -------------
loading_tbl <- NULL
if (isTRUE(show_loadings)) {
  score_extent_df <- data.frame(
    PC1 = pc1_rng,
    PC2 = pc2_rng,
    PC3 = pc3_rng
  )
  loading_tbl <- .pca_loading_table(
    pca, pcs = 1:3, score_df = score_extent_df,
    scale_fraction = loading_scale_fraction,
    top_n = loading_top_n
  )
}

# --- hover text -----------------------------------------------------------
known_pts_plot$hover <- paste0(
"<b>", known_pts_plot$site_name, "</b>",
"<br>Known class: ", known_pts_plot$class,
"<br>Ensemble predicted: ", known_pts_plot$pred,
"<br>Mean P(", focus_class, "): ", round(known_pts_plot$p_focus, 4),
"<br>PC1: ", round(known_pts_plot$PC1, 3),
"<br>PC2: ", round(known_pts_plot$PC2, 3),
"<br>PC3: ", round(known_pts_plot$PC3, 3)
)

if (!is.null(unk_scores_plot) && nrow(unk_scores_plot) > 0) {
unk_scores_plot$hover <- paste0(
"<b>", unk_scores_plot$site_name, "</b>",
"<br>UNKNOWN site",
"<br>Predicted class: ", unk_scores_plot$pred,
"<br>Mean P(", focus_class, "): ", round(unk_scores_plot$p_focus, 4),
"<br>PC1: ", round(unk_scores_plot$PC1, 3),
"<br>PC2: ", round(unk_scores_plot$PC2, 3),
"<br>PC3: ", round(unk_scores_plot$PC3, 3)
)
}

# --- plotly colour strategy ----------------------------------------------
# In 3D, a probability raster/heat surface is usually cluttered.
# So:
#   - known points are coloured by true known class
#   - unknown points are black diamonds
#   - probabilities are shown in hover text
# This is much easier to read interactively.

var_pct <- 100 * summary(pca)$importance[2, 1:3]

class_cols <- stats::setNames(
grDevices::hcl.colors(length(classes), palette = "Dark 3"),
classes
)

p <- plotly::plot_ly()

p <- plotly::add_markers(
p,
data = known_pts_plot,
x = ~PC1,
y = ~PC2,
z = ~PC3,
type = "scatter3d",
mode = if (label_known) "markers+text" else "markers",
text = if (label_known) ~site_name else NULL,
textposition = "top center",
color = ~class,
colors = class_cols,
hovertext = ~hover,
hoverinfo = "text",
marker = list(
size = 4,
opacity = 0.75,
line = list(width = 0.4, color = "rgba(60,60,60,0.35)")
),
name = "Known"
)

if (!is.null(unk_scores_plot) && nrow(unk_scores_plot) > 0) {
p <- plotly::add_markers(
p,
data = unk_scores_plot,
x = ~PC1,
y = ~PC2,
z = ~PC3,
type = "scatter3d",
mode = if (label_unknown) "markers+text" else "markers",
text = if (label_unknown) ~site_name else NULL,
textposition = "top center",
hovertext = ~hover,
hoverinfo = "text",
marker = list(
color = "black",
size = 7,
symbol = "diamond",
opacity = 1,
line = list(width = 1, color = "white")
),
name = "Unknown"
)
}

# PCA loading vectors are added last so they remain visible over the points.
if (!is.null(loading_tbl) && nrow(loading_tbl) > 0) {
  p <- .add_pca_loadings_plotly(p, loading_tbl, labels = loading_labels)
}

p <- plotly::layout(
p,
title = list(
text = paste0(
"3D PCA RF ensemble — ", focus_class,
"<br><sup>",
task_name, " | mean of ", length(rf_list),
" RF models on PC1/PC2/PC3 of best ",
length(top_feats), " features",
"</sup>"
)
),
legend = list(
orientation = "h",
x = 0,
y = -0.12
),
scene = list(
xaxis = list(
title = sprintf("PC1 (%.1f%% var)", var_pct[1]),
range = pc1_rng
),
yaxis = list(
title = sprintf("PC2 (%.1f%% var)", var_pct[2]),
range = pc2_rng
),
zaxis = list(
title = sprintf("PC3 (%.1f%% var)", var_pct[3]),
range = pc3_rng
),
aspectmode = "cube"
)
)

print(p)

if (!is.null(out_html)) {
htmlwidgets::saveWidget(p, out_html, selfcontained = TRUE)
message("Wrote PCA plotly HTML -> ", out_html)
}

# --- SECOND GRAPH: 3D raw feature-space plot ------------------------------
# X = Mean_part_abundance
# Y = all_sections_dominance
# Z = mnau_upper_appendicular_mean
feature_plot <- NULL
if (isTRUE(show_feature_space)) {
  feature_db <- .scalarize_first_list_value(
    tapho_db,
    c("Mean_part_abundance",
      "all_sections_dominance",
      "mnau_upper_appendicular_mean")
  )

  feature_plot <- feature_surface_plotly(
    tapho_db = feature_db,
    res = res,
    features = c(
      "Mean_part_abundance",
      "all_sections_dominance",
      "mnau_upper_appendicular_mean"
    ),
    task_name = task_name,
    focus_class = focus_class,
    n_features = n_features,
    ntree = ntree,
    cv_folds = cv_folds,
    seed = seed,
    unknown_sites = unknown_sites,
    label_var = "site_name",
    label_known = label_known,
    label_unknown = label_unknown,
    show_probability_surface = FALSE,
    out_html = out_feature_html
  )
}

# --- PRINT unknown probabilities -----------------------------------------
if (!is.null(unk_scores) && nrow(unk_scores) > 0) {
prob_cols <- grep("^p_model", names(unk_scores), value = TRUE)

out_tbl <- unk_scores %>%
dplyr::select(
site_name,
predicted = pred,
dplyr::all_of(prob_cols),
p_focus_mean = p_focus
) %>%
dplyr::mutate(
dplyr::across(
c(dplyr::all_of(prob_cols), p_focus_mean),
~ round(.x, 4)
)
) %>%
dplyr::arrange(dplyr::desc(p_focus_mean))

message(
"\n=== Predicted probability of '", focus_class,
"' per unknown site, using PC1/PC2/PC3",
" mean over ", length(rf_list), " models ==="
)

print(as.data.frame(out_tbl), row.names = FALSE)
}

invisible(list(
plot = p,
feature_plot = feature_plot,
pca = pca,
rf_list = rf_list,
fold_acc = fold_acc,
top_feats = top_feats,
medians = ck$medians,
known = known_pts,
known_plot = known_pts_plot,
unknown = unk_scores,
unknown_plot = unk_scores_plot,
loadings = loading_tbl
))
}


# ---------------------------------------------------------------------
# main: 3D plotly version using PC1/PC2/PC3 + probability isosurfaces
#       individual/site label selectable through label_var
# ---------------------------------------------------------------------
pca_surface_plotly_ind <- function(tapho_db,
  res,                       # output of rfe_rf / run_rfe
  task_name   = "4class",
  focus_class = "Funerary Context",
  n_features  = 20,
  ntree       = 500,
  cv_folds    = 3,
  seed        = 42,
  unknown_sites = NULL,

  # which column should be used for labels?
  # examples: "ind_name", "site_name"
  label_var = "ind_name",

  # optional PCA-axis cropping
  pc1_min = NULL,
  pc1_max = NULL,
  pc2_min = NULL,
  pc2_max = NULL,
  pc3_min = NULL,
  pc3_max = NULL,

  # labels in 3D can get messy
  label_known   = FALSE,
  label_unknown = TRUE,

  # PCA biplot loading vectors
  show_loadings = TRUE,
  loading_scale_fraction = 0.70,
  loading_top_n = NULL,       # NULL = all selected features
  loading_labels = TRUE,

  # 3D probability shell(s)
  show_probability_surface = TRUE,
  prob_grid_n = 25,
  iso_probs = c(0.5),
  surface_opacity = 0.18,

  # debugging
  print_feature_variance = FALSE,

  # second 3D plot in ORIGINAL feature space
  show_feature_space = TRUE,
  out_feature_html = "feature_surface_3d_ind_MeanPartAbundance_allSectionsDominance_upperAppendicular.html",

  out_html = NULL) {

# --- package checks -------------------------------------------------------
if (!requireNamespace("plotly", quietly = TRUE)) {
stop("Package 'plotly' is required. Install it with install.packages('plotly').")
}

if (!is.null(out_html) && !requireNamespace("htmlwidgets", quietly = TRUE)) {
stop("Package 'htmlwidgets' is required to save HTML. Install it with install.packages('htmlwidgets').")
}

set.seed(seed)

if (is.null(cv_folds) || cv_folds < 2) {
stop("cv_folds must be >= 2.")
}

# --- helper: flexible plotting label --------------------------------------
.get_plot_label <- function(df, label_var, fallback_var = "site_name") {
if (label_var %in% names(df)) {
out <- as.character(df[[label_var]])
} else if (fallback_var %in% names(df)) {
warning(
"label_var '", label_var, "' not found. Falling back to '",
fallback_var, "'."
)
out <- as.character(df[[fallback_var]])
} else {
warning(
"Neither label_var '", label_var, "' nor fallback_var '",
fallback_var, "' found. Using row numbers as labels."
)
out <- as.character(seq_len(nrow(df)))
}

bad <- is.na(out) | out == ""
out[bad] <- paste0("row_", which(bad))
out
}

# --- best features --------------------------------------------------------
top_feats <- res$ranking %>%
dplyr::arrange(dplyr::desc(elimination_rank)) %>%
dplyr::slice_head(n = n_features) %>%
dplyr::pull(feature)

message("Best features used: ", paste(top_feats, collapse = ", "))

# --- split known vs unknown ----------------------------------------------
db <- tapho_db %>%
dplyr::mutate(.row_id = dplyr::row_number())

rec <- task_recode_data(
db,
task_name = task_name,
target_variable = "taphonomic_context"
)

known_df <- rec$df

unknown_df <- db %>%
dplyr::filter(!(.row_id %in% known_df$.row_id))

# Filter unknown items using the same variable that is used for labels.
# This makes unknown_sites work for either ind_name or site_name.
if (!is.null(unknown_sites)) {
if (!label_var %in% names(db)) {
stop("unknown_sites supplied, but label_var '", label_var, "' is not in tapho_db.")
}

missing_sites <- setdiff(unknown_sites, unique(as.character(db[[label_var]])))
if (length(missing_sites)) {
warning(
"Requested unknown item(s) not found in ", label_var, ": ",
paste(missing_sites, collapse = ", ")
)
}

unknown_df <- unknown_df %>%
dplyr::filter(.data[[label_var]] %in% unknown_sites)
}

message(nrow(known_df), " known / ", nrow(unknown_df), " unknown instances")

# --- clean known features -------------------------------------------------
ck <- .clean_features(known_df, top_feats)
Xk <- ck$X

# --- drop unusable / zero-variance features -------------------------------
feat_var <- vapply(Xk, function(c) {
c <- suppressWarnings(as.numeric(c))
c <- c[is.finite(c)]

if (length(c) < 2) return(NA_real_)

stats::var(c)
}, numeric(1))

keep_feat <- is.finite(feat_var) & feat_var > 0

if (isTRUE(print_feature_variance)) {
print(data.frame(
feature  = names(feat_var),
variance = feat_var,
keep     = keep_feat
))
}

if (any(!keep_feat)) {
message(
"Dropping unusable / zero-variance feature(s): ",
paste(names(Xk)[!keep_feat], collapse = ", ")
)

Xk <- Xk[, keep_feat, drop = FALSE]
top_feats <- names(Xk)
ck$medians <- ck$medians[top_feats]
}

if (ncol(Xk) < 3) {
stop(
"Fewer than 3 usable non-zero-variance features remain after cleaning. ",
"Cannot compute PC1/PC2/PC3."
)
}

# --- target variable ------------------------------------------------------
yk <- known_df[["taphonomic_context"]]

if (!is.factor(yk)) {
yk <- factor(yk)
}

if (!focus_class %in% levels(yk)) {
stop("focus_class '", focus_class, "' is not a level of taphonomic_context")
}

classes <- levels(yk)

# --- PCA on known features: keep PC1, PC2, PC3 ----------------------------
pca <- stats::prcomp(Xk, center = TRUE, scale. = TRUE)

scores_all <- stats::predict(pca, Xk)

if (ncol(scores_all) < 3) {
stop("PCA returned fewer than 3 components. Use more non-zero-variance features/rows.")
}

sc_k <- as.data.frame(scores_all[, 1:3, drop = FALSE])
names(sc_k) <- c("PC1", "PC2", "PC3")

# --- K-fold CV in 3D PC space --------------------------------------------
set.seed(seed)

fold_id <- sample(rep_len(seq_len(cv_folds), nrow(sc_k)))
rf_list  <- vector("list", cv_folds)
fold_acc <- rep(NA_real_, cv_folds)

for (f in seq_len(cv_folds)) {
tr <- fold_id != f
te <- !tr

train_f <- dplyr::mutate(
sc_k[tr, , drop = FALSE],
.y = yk[tr]
)

if (length(unique(train_f$.y)) < 2) next

set.seed(seed + f)

rf_list[[f]] <- randomForest::randomForest(
.y ~ PC1 + PC2 + PC3,
data = train_f,
ntree = ntree
)

pr_te <- stats::predict(
rf_list[[f]],
sc_k[te, , drop = FALSE]
)

fold_acc[f] <- mean(pr_te == yk[te])
}

rf_list <- rf_list[!vapply(rf_list, is.null, logical(1))]

if (!length(rf_list)) {
stop("No fold model could be trained.")
}

message(sprintf(
"Per-fold held-out accuracy: %s | mean = %.4f",
paste(sprintf("%.3f", fold_acc), collapse = ", "),
mean(fold_acc, na.rm = TRUE)
))

# --- helper: one-model focus probability ---------------------------------
.focus_prob_one_model <- function(model, newdata, focus_class) {
pp <- stats::predict(model, newdata, type = "prob")

if (focus_class %in% colnames(pp)) {
pp[, focus_class]
} else {
rep(0, nrow(newdata))
}
}

# --- known point probabilities -------------------------------------------
known_probs <- .ensemble_prob(
rf_list,
sc_k[, c("PC1", "PC2", "PC3")],
classes
)

known_pred <- classes[max.col(known_probs, ties.method = "first")]

known_pts <- dplyr::mutate(
sc_k,
class   = yk,
pred    = factor(known_pred, levels = classes),
p_focus = known_probs[, focus_class]
)

known_pts$site_name <- if ("site_name" %in% names(known_df)) {
as.character(known_df$site_name)
} else {
NA_character_
}

known_pts$label <- .get_plot_label(
known_df,
label_var = label_var,
fallback_var = "site_name"
)

# --- project unknown instances through SAME features + SAME PCA rotation --
unk_scores <- NULL

if (nrow(unknown_df) > 0) {
cu <- .clean_features(
unknown_df,
top_feats,
medians = ck$medians
)

scu_all <- stats::predict(pca, cu$X)

scu <- as.data.frame(scu_all[, 1:3, drop = FALSE])
names(scu) <- c("PC1", "PC2", "PC3")

per_model_focus <- vapply(
rf_list,
function(m) {
.focus_prob_one_model(
m,
scu[, c("PC1", "PC2", "PC3")],
focus_class
)
},
numeric(nrow(scu))
)

if (is.null(dim(per_model_focus))) {
per_model_focus <- matrix(per_model_focus, nrow = 1)
}

colnames(per_model_focus) <- paste0(
"p_model",
seq_len(ncol(per_model_focus))
)

mean_probs <- .ensemble_prob(
rf_list,
scu[, c("PC1", "PC2", "PC3")],
classes
)

pred_class <- classes[max.col(mean_probs, ties.method = "first")]

scu$site_name <- if ("site_name" %in% names(unknown_df)) {
as.character(unknown_df$site_name)
} else {
NA_character_
}

scu$label <- .get_plot_label(
unknown_df,
label_var = label_var,
fallback_var = "site_name"
)

scu$pred    <- factor(pred_class, levels = classes)
scu$p_focus <- mean_probs[, focus_class]

scu <- cbind(scu, as.data.frame(per_model_focus))

unk_scores <- scu
}

# --- axis ranges / cropping ----------------------------------------------
.axis_range <- function(x, lo_arg, hi_arg, axis_name) {
lo <- if (is.null(lo_arg)) {
min(x, na.rm = TRUE)
} else {
max(min(x, na.rm = TRUE), lo_arg)
}

hi <- if (is.null(hi_arg)) {
max(x, na.rm = TRUE)
} else {
min(max(x, na.rm = TRUE), hi_arg)
}

if (!is.finite(lo) || !is.finite(hi) || lo >= hi) {
stop(
"Invalid range for ",
axis_name,
": lower bound must be below upper bound."
)
}

c(lo, hi)
}

pc1_rng <- .axis_range(sc_k$PC1, pc1_min, pc1_max, "PC1")
pc2_rng <- .axis_range(sc_k$PC2, pc2_min, pc2_max, "PC2")
pc3_rng <- .axis_range(sc_k$PC3, pc3_min, pc3_max, "PC3")

.crop_3pc <- function(df) {
if (is.null(df) || nrow(df) == 0) return(df)

df %>%
dplyr::filter(
PC1 >= pc1_rng[1], PC1 <= pc1_rng[2],
PC2 >= pc2_rng[1], PC2 <= pc2_rng[2],
PC3 >= pc3_rng[1], PC3 <= pc3_rng[2]
)
}

known_pts_plot  <- .crop_3pc(known_pts)
unk_scores_plot <- .crop_3pc(unk_scores)

# --- PCA loadings: original feature directions in PC1/PC2/PC3 -------------
loading_tbl <- NULL
if (isTRUE(show_loadings)) {
  score_extent_df <- data.frame(
    PC1 = pc1_rng,
    PC2 = pc2_rng,
    PC3 = pc3_rng
  )
  loading_tbl <- .pca_loading_table(
    pca, pcs = 1:3, score_df = score_extent_df,
    scale_fraction = loading_scale_fraction,
    top_n = loading_top_n
  )
}

# --- probability grid for 3D isosurfaces ---------------------------------
prob_grid <- NULL

if (isTRUE(show_probability_surface)) {
if (is.null(prob_grid_n) || prob_grid_n < 5) {
stop("prob_grid_n must be >= 5 when show_probability_surface = TRUE.")
}

iso_probs <- sort(unique(iso_probs))
iso_probs <- iso_probs[is.finite(iso_probs)]

if (!length(iso_probs)) {
stop("iso_probs must contain at least one finite probability value.")
}

if (any(iso_probs < 0 | iso_probs > 1)) {
stop("All iso_probs values must be between 0 and 1.")
}

g1 <- seq(pc1_rng[1], pc1_rng[2], length.out = prob_grid_n)
g2 <- seq(pc2_rng[1], pc2_rng[2], length.out = prob_grid_n)
g3 <- seq(pc3_rng[1], pc3_rng[2], length.out = prob_grid_n)

prob_grid <- expand.grid(
PC1 = g1,
PC2 = g2,
PC3 = g3,
KEEP.OUT.ATTRS = FALSE
)

prob_grid$p_focus <- .ensemble_prob(
rf_list,
prob_grid[, c("PC1", "PC2", "PC3")],
classes
)[, focus_class]
} else {
iso_probs <- numeric(0)
}

# --- hover text -----------------------------------------------------------
known_pts_plot$hover <- paste0(
"<b>", known_pts_plot$label, "</b>",
"<br>Label variable: ", label_var,
"<br>Known class: ", known_pts_plot$class,
"<br>Ensemble predicted: ", known_pts_plot$pred,
"<br>Mean P(", focus_class, "): ", round(known_pts_plot$p_focus, 4),
"<br>PC1: ", round(known_pts_plot$PC1, 3),
"<br>PC2: ", round(known_pts_plot$PC2, 3),
"<br>PC3: ", round(known_pts_plot$PC3, 3)
)

if (!is.null(unk_scores_plot) && nrow(unk_scores_plot) > 0) {
unk_scores_plot$hover <- paste0(
"<b>", unk_scores_plot$label, "</b>",
"<br>Label variable: ", label_var,
"<br>UNKNOWN site",
"<br>Predicted class: ", unk_scores_plot$pred,
"<br>Mean P(", focus_class, "): ", round(unk_scores_plot$p_focus, 4),
"<br>PC1: ", round(unk_scores_plot$PC1, 3),
"<br>PC2: ", round(unk_scores_plot$PC2, 3),
"<br>PC3: ", round(unk_scores_plot$PC3, 3)
)
}

# --- colours --------------------------------------------------------------
var_pct <- 100 * summary(pca)$importance[2, 1:3]

class_cols <- stats::setNames(
grDevices::hcl.colors(length(classes), palette = "Dark 3"),
classes
)

iso_cols <- grDevices::hcl.colors(
max(length(iso_probs), 3),
palette = "BluGrn"
)[seq_along(iso_probs)]

# --- plotly plot ----------------------------------------------------------
p <- plotly::plot_ly()

# Add P(focus_class) isosurface(s) first, so points sit visually on top.
if (!is.null(prob_grid) && nrow(prob_grid) > 0 && length(iso_probs) > 0) {
for (i in seq_along(iso_probs)) {
iso <- iso_probs[i]
col <- iso_cols[i]

p <- plotly::add_trace(
p,
x = prob_grid$PC1,
y = prob_grid$PC2,
z = prob_grid$PC3,
value = prob_grid$p_focus,
type = "isosurface",
isomin = iso,
isomax = iso,
surface = list(count = 1),
caps = list(
x = list(show = FALSE),
y = list(show = FALSE),
z = list(show = FALSE)
),
opacity = surface_opacity,
colorscale = list(
list(0, col),
list(1, col)
),
showscale = FALSE,
hoverinfo = "skip",
name = paste0("P(", focus_class, ") = ", iso),
inherit = FALSE
)
}
}

# Known points: colour by observed class.
p <- plotly::add_markers(
p,
data = known_pts_plot,
x = ~PC1,
y = ~PC2,
z = ~PC3,
type = "scatter3d",
mode = if (label_known) "markers+text" else "markers",
text = if (label_known) ~label else NULL,
textposition = "top center",
color = ~class,
colors = class_cols,
hovertext = ~hover,
hoverinfo = "text",
marker = list(
size = 4,
opacity = 0.78,
line = list(
width = 0.4,
color = "rgba(60,60,60,0.35)"
)
),
name = "Known"
)

# Unknown points: black diamonds.
if (!is.null(unk_scores_plot) && nrow(unk_scores_plot) > 0) {
p <- plotly::add_markers(
p,
data = unk_scores_plot,
x = ~PC1,
y = ~PC2,
z = ~PC3,
type = "scatter3d",
mode = if (label_unknown) "markers+text" else "markers",
text = if (label_unknown) ~label else NULL,
textposition = "top center",
hovertext = ~hover,
hoverinfo = "text",
marker = list(
color = "black",
size = 7,
symbol = "diamond",
opacity = 1,
line = list(
width = 1,
color = "white"
)
),
name = "Unknown"
)
}

# PCA loading vectors: angle = loading direction; length = loading strength
# in the displayed PC1/PC2/PC3 subspace.
if (!is.null(loading_tbl) && nrow(loading_tbl) > 0) {
  p <- .add_pca_loadings_plotly(p, loading_tbl, labels = loading_labels)
}

p <- plotly::layout(
p,
title = list(
text = paste0(
"3D PCA RF ensemble — ", focus_class,
"<br><sup>",
task_name,
" | label_var = ",
label_var,
" | mean of ",
length(rf_list),
" RF models on PC1/PC2/PC3 of best ",
length(top_feats),
" features",
"</sup>"
)
),
legend = list(
orientation = "h",
x = 0,
y = -0.12
),
scene = list(
xaxis = list(
title = sprintf("PC1 (%.1f%% var)", var_pct[1]),
range = pc1_rng
),
yaxis = list(
title = sprintf("PC2 (%.1f%% var)", var_pct[2]),
range = pc2_rng
),
zaxis = list(
title = sprintf("PC3 (%.1f%% var)", var_pct[3]),
range = pc3_rng
),
aspectmode = "cube"
)
)

print(p)

if (!is.null(out_html)) {
htmlwidgets::saveWidget(p, out_html, selfcontained = TRUE)
message("Wrote PCA plotly HTML -> ", out_html)
}

# --- SECOND GRAPH: 3D raw feature-space plot ------------------------------
# X = Mean_part_abundance
# Y = all_sections_dominance
# Z = mnau_upper_appendicular_mean
feature_plot <- NULL
if (isTRUE(show_feature_space)) {
  feature_db <- .scalarize_first_list_value(
    tapho_db,
    c("Mean_part_abundance",
      "all_sections_dominance",
      "mnau_upper_appendicular_mean")
  )

  feature_plot <- feature_surface_plotly(
    tapho_db = feature_db,
    res = res,
    features = c(
      "Mean_part_abundance",
      "all_sections_dominance",
      "mnau_upper_appendicular_mean"
    ),
    task_name = task_name,
    focus_class = focus_class,
    n_features = n_features,
    ntree = ntree,
    cv_folds = cv_folds,
    seed = seed,
    unknown_sites = unknown_sites,
    label_var = label_var,
    label_known = label_known,
    label_unknown = label_unknown,
    show_probability_surface = show_probability_surface,
    prob_grid_n = prob_grid_n,
    iso_probs = iso_probs,
    surface_opacity = surface_opacity,
    out_html = out_feature_html
  )
}

# --- print unknown probabilities -----------------------------------------
if (!is.null(unk_scores) && nrow(unk_scores) > 0) {
prob_cols <- grep("^p_model", names(unk_scores), value = TRUE)

out_tbl <- unk_scores %>%
dplyr::select(
label,
dplyr::any_of("site_name"),
predicted = pred,
dplyr::all_of(prob_cols),
p_focus_mean = p_focus
) %>%
dplyr::mutate(
dplyr::across(
c(dplyr::all_of(prob_cols), p_focus_mean),
~ round(.x, 4)
)
) %>%
dplyr::arrange(dplyr::desc(p_focus_mean))

message(
"\n=== Predicted probability of '",
focus_class,
"' per unknown item, using PC1/PC2/PC3",
" mean over ",
length(rf_list),
" models | label_var = ",
label_var,
" ==="
)

print(as.data.frame(out_tbl), row.names = FALSE)
}

invisible(list(
plot = p,
feature_plot = feature_plot,
pca = pca,
rf_list = rf_list,
fold_acc = fold_acc,
top_feats = top_feats,
medians = ck$medians,
known = known_pts,
known_plot = known_pts_plot,
unknown = unk_scores,
unknown_plot = unk_scores_plot,
prob_grid = prob_grid,
iso_probs = iso_probs,
label_var = label_var,
loadings = loading_tbl
))
}

# =====================================================================
# GENERAL FEATURE-SPACE RF SURFACES
#
# These functions extend the PCA plotting workflow above so the plotting
# coordinates are supplied explicitly. Coordinates may be raw feature
# names, PCA coordinates ("PC1", "PC2", ...), or a mixture of the two.
# "PCA1", "PCA2", ... are accepted as aliases for "PC1", "PC2", ... .
#
# The RF is trained ONLY on the selected 2D/3D plotting coordinates.
# When PCs are requested, the PCA is still fitted once on the best
# `n_features` RFE features, preserving the coordinate logic used above.
# Cross-validation remains in the RF layer and probabilities are averaged
# over the fold models.
# =====================================================================

.normalize_surface_coordinate <- function(x) {
  x <- as.character(x)
  u <- toupper(x)
  is_pca <- grepl("^PCA[1-9][0-9]*$", u)
  is_pc  <- grepl("^PC[1-9][0-9]*$", u)
  u[is_pca] <- sub("^PCA", "PC", u[is_pca])
  out <- x
  out[is_pca | is_pc] <- u[is_pca | is_pc]
  out
}

.is_pc_coordinate <- function(x) {
  grepl("^PC[1-9][0-9]*$", x)
}

.pc_coordinate_index <- function(x) {
  as.integer(sub("^PC", "", x))
}

.surface_axis_range <- function(x, lo = NULL, hi = NULL, axis_name = "axis") {
  base_lo <- min(x, na.rm = TRUE)
  base_hi <- max(x, na.rm = TRUE)
  use_lo <- if (is.null(lo)) base_lo else max(base_lo, lo)
  use_hi <- if (is.null(hi)) base_hi else min(base_hi, hi)

  if (!is.finite(use_lo) || !is.finite(use_hi) || use_lo >= use_hi) {
    stop("Invalid range for ", axis_name, ": lower bound must be below upper bound.")
  }
  c(use_lo, use_hi)
}

.surface_label <- function(df, label_var = "site_name", fallback_var = "site_name") {
  if (label_var %in% names(df)) {
    out <- as.character(df[[label_var]])
  } else if (fallback_var %in% names(df)) {
    warning("label_var '", label_var, "' not found; using '", fallback_var, "'.")
    out <- as.character(df[[fallback_var]])
  } else {
    out <- as.character(seq_len(nrow(df)))
  }
  bad <- is.na(out) | !nzchar(out)
  out[bad] <- paste0("row_", which(bad))
  out
}

.surface_fit_coordinates <- function(tapho_db,
                                     res,
                                     features,
                                     task_name = "4class",
                                     focus_class = "Funerary Context",
                                     n_features = 20,
                                     ntree = 500,
                                     cv_folds = 3,
                                     seed = 42,
                                     unknown_sites = NULL,
                                     label_var = "site_name") {
  features <- .normalize_surface_coordinate(features)

  if (!length(features) %in% c(2L, 3L)) {
    stop("features must contain exactly 2 or 3 coordinates.")
  }
  if (anyDuplicated(features)) {
    stop("features must be unique after PC/PCA name normalization.")
  }
  if (is.null(cv_folds) || cv_folds < 2) {
    stop("cv_folds must be >= 2.")
  }

  raw_features <- features[!.is_pc_coordinate(features)]
  missing_raw <- setdiff(raw_features, names(tapho_db))
  if (length(missing_raw)) {
    stop("Feature(s) not found in tapho_db: ", paste(missing_raw, collapse = ", "))
  }

  db <- tapho_db %>% dplyr::mutate(.row_id = dplyr::row_number())
  rec <- task_recode_data(
    db,
    task_name = task_name,
    target_variable = "taphonomic_context"
  )

  known_df <- rec$df
  unknown_df <- db %>% dplyr::filter(!(.row_id %in% known_df$.row_id))

  if (!is.null(unknown_sites)) {
    if (!label_var %in% names(db)) {
      stop("unknown_sites was supplied but label_var '", label_var,
           "' is not a column in tapho_db.")
    }
    missing_items <- setdiff(unknown_sites, unique(as.character(db[[label_var]])))
    if (length(missing_items)) {
      warning("Requested unknown item(s) not found in ", label_var, ": ",
              paste(missing_items, collapse = ", "))
    }
    unknown_df <- unknown_df %>%
      dplyr::filter(.data[[label_var]] %in% unknown_sites)
  }

  yk <- known_df[["taphonomic_context"]]
  if (!is.factor(yk)) yk <- factor(yk)
  if (!focus_class %in% levels(yk)) {
    stop("focus_class '", focus_class, "' is not a level of taphonomic_context")
  }
  classes <- levels(yk)

  # ---- Raw plotting coordinates ------------------------------------------
  raw_known <- NULL
  raw_unknown <- NULL
  raw_medians <- numeric(0)

  if (length(raw_features)) {
    cr <- .clean_features(known_df, raw_features)
    raw_known <- cr$X
    raw_medians <- cr$medians

    raw_var <- vapply(raw_known, function(v) {
      v <- suppressWarnings(as.numeric(v))
      v <- v[is.finite(v)]
      if (length(v) < 2) return(NA_real_)
      stats::var(v)
    }, numeric(1))

    bad_raw <- !is.finite(raw_var) | raw_var <= 0
    if (any(bad_raw)) {
      stop("Selected raw coordinate(s) are unusable/zero variance in known data: ",
           paste(names(raw_var)[bad_raw], collapse = ", "))
    }

    if (nrow(unknown_df) > 0) {
      raw_unknown <- .clean_features(
        unknown_df,
        raw_features,
        medians = raw_medians
      )$X
    } else {
      raw_unknown <- raw_known[0, , drop = FALSE]
    }
  }

  # ---- PCA plotting coordinates, only if requested -----------------------
  pca <- NULL
  pca_top_feats <- character(0)
  pca_medians <- numeric(0)
  pca_known_scores <- NULL
  pca_unknown_scores <- NULL
  pca_var_pct <- numeric(0)

  pc_features <- features[.is_pc_coordinate(features)]

  if (length(pc_features)) {
    if (is.null(res$ranking)) {
      stop("PC coordinates require res$ranking from run_rfe()/rfe_rf().")
    }

    pca_top_feats <- res$ranking %>%
      dplyr::arrange(dplyr::desc(elimination_rank)) %>%
      dplyr::slice_head(n = n_features) %>%
      dplyr::pull(feature)

    ck <- .clean_features(known_df, pca_top_feats)
    Xk <- ck$X

    feat_var <- vapply(Xk, function(v) {
      v <- suppressWarnings(as.numeric(v))
      v <- v[is.finite(v)]
      if (length(v) < 2) return(NA_real_)
      stats::var(v)
    }, numeric(1))

    keep <- is.finite(feat_var) & feat_var > 0
    if (any(!keep)) {
      message("Dropping unusable / zero-variance PCA input feature(s): ",
              paste(names(Xk)[!keep], collapse = ", "))
      Xk <- Xk[, keep, drop = FALSE]
      pca_top_feats <- names(Xk)
      ck$medians <- ck$medians[pca_top_feats]
    }

    max_pc <- max(.pc_coordinate_index(pc_features))
    max_possible_pc <- min(nrow(Xk), ncol(Xk))
    if (ncol(Xk) < 2 || max_pc > max_possible_pc) {
      stop("Requested ", paste(pc_features, collapse = ", "),
           " but PCA has only ", max_possible_pc, " available component(s).")
    }

    pca <- stats::prcomp(Xk, center = TRUE, scale. = TRUE)
    pca_known_scores <- as.data.frame(stats::predict(pca, Xk))
    pca_var_pct <- 100 * summary(pca)$importance[2, ]
    pca_medians <- ck$medians

    if (nrow(unknown_df) > 0) {
      Xu <- .clean_features(
        unknown_df,
        pca_top_feats,
        medians = pca_medians
      )$X
      pca_unknown_scores <- as.data.frame(stats::predict(pca, Xu))
    } else {
      pca_unknown_scores <- pca_known_scores[0, , drop = FALSE]
    }
  }

  # ---- Assemble model coordinates in user-supplied order -----------------
  make_coords <- function(raw_df, pca_df) {
    out <- vector("list", length(features))
    for (j in seq_along(features)) {
      nm <- features[j]
      if (.is_pc_coordinate(nm)) {
        out[[j]] <- pca_df[[nm]]
      } else {
        out[[j]] <- raw_df[[nm]]
      }
    }
    out <- as.data.frame(out, check.names = FALSE)
    names(out) <- paste0(".d", seq_along(features))
    out
  }

  coords_known <- make_coords(raw_known, pca_known_scores)
  coords_unknown <- make_coords(raw_unknown, pca_unknown_scores)

  # ---- K-fold RF ensemble in selected coordinate space -------------------
  set.seed(seed)
  fold_id <- sample(rep_len(seq_len(cv_folds), nrow(coords_known)))
  rf_list <- vector("list", cv_folds)
  fold_acc <- rep(NA_real_, cv_folds)

  for (f in seq_len(cv_folds)) {
    tr <- fold_id != f
    te <- !tr
    if (length(unique(yk[tr])) < 2) next

    set.seed(seed + f)
    rf_list[[f]] <- randomForest::randomForest(
      x = coords_known[tr, , drop = FALSE],
      y = yk[tr],
      ntree = ntree
    )

    pred_te <- stats::predict(rf_list[[f]], coords_known[te, , drop = FALSE])
    fold_acc[f] <- mean(pred_te == yk[te])
  }

  rf_list <- rf_list[!vapply(rf_list, is.null, logical(1))]
  if (!length(rf_list)) stop("No fold model could be trained.")

  message(sprintf(
    "Selected coordinates: %s | per-fold accuracy: %s | mean = %.4f",
    paste(features, collapse = ", "),
    paste(sprintf("%.3f", fold_acc), collapse = ", "),
    mean(fold_acc, na.rm = TRUE)
  ))

  known_probs <- .ensemble_prob(rf_list, coords_known, classes)
  known_pred <- classes[max.col(known_probs, ties.method = "first")]

  known_pts <- coords_known
  known_pts$.row_id <- known_df$.row_id
  known_pts$label <- .surface_label(known_df, label_var = label_var)
  known_pts$site_name <- if ("site_name" %in% names(known_df)) as.character(known_df$site_name) else NA_character_
  known_pts$ind_name <- if ("ind_name" %in% names(known_df)) as.character(known_df$ind_name) else NA_character_
  known_pts$class <- yk
  known_pts$pred <- factor(known_pred, levels = classes)
  known_pts$p_focus <- known_probs[, focus_class]

  unknown_pts <- NULL
  if (nrow(coords_unknown) > 0) {
    mean_probs <- .ensemble_prob(rf_list, coords_unknown, classes)
    pred_class <- classes[max.col(mean_probs, ties.method = "first")]

    per_model_focus <- vapply(
      rf_list,
      function(m) {
        pp <- stats::predict(m, coords_unknown, type = "prob")
        if (focus_class %in% colnames(pp)) pp[, focus_class] else rep(0, nrow(coords_unknown))
      },
      numeric(nrow(coords_unknown))
    )
    if (is.null(dim(per_model_focus))) {
      per_model_focus <- matrix(per_model_focus, nrow = nrow(coords_unknown))
    }
    colnames(per_model_focus) <- paste0("p_model", seq_len(ncol(per_model_focus)))

    unknown_pts <- coords_unknown
    unknown_pts$.row_id <- unknown_df$.row_id
    unknown_pts$label <- .surface_label(unknown_df, label_var = label_var)
    unknown_pts$site_name <- if ("site_name" %in% names(unknown_df)) as.character(unknown_df$site_name) else NA_character_
    unknown_pts$ind_name <- if ("ind_name" %in% names(unknown_df)) as.character(unknown_df$ind_name) else NA_character_
    unknown_pts$pred <- factor(pred_class, levels = classes)
    unknown_pts$p_focus <- mean_probs[, focus_class]
    unknown_pts <- cbind(unknown_pts, as.data.frame(per_model_focus))
  }

  axis_titles <- features
  if (length(pc_features)) {
    for (j in seq_along(features)) {
      if (.is_pc_coordinate(features[j])) {
        ii <- .pc_coordinate_index(features[j])
        axis_titles[j] <- sprintf("%s (%.1f%% var)", features[j], pca_var_pct[ii])
      }
    }
  }

  invisible(list(
    features = features,
    axis_titles = axis_titles,
    rf_list = rf_list,
    fold_acc = fold_acc,
    classes = classes,
    focus_class = focus_class,
    task_name = task_name,
    known = known_pts,
    unknown = unknown_pts,
    pca = pca,
    pca_top_feats = pca_top_feats,
    pca_medians = pca_medians,
    raw_medians = raw_medians,
    label_var = label_var
  ))
}


# ---------------------------------------------------------------------
# 2D PNG probability surface using any two raw/PCA coordinates.
# ---------------------------------------------------------------------
feature_surface_plot <- function(tapho_db,
                                 res,
                                 features = c(
                                   "mnau_upper_appendicular_mean",
                                   "all_sections_dominance"
                                 ),
                                 task_name = "4class",
                                 focus_class = "Funerary Context",
                                 n_features = 20,
                                 ntree = 500,
                                 cv_folds = 3,
                                 grid_n = 200,
                                 seed = 42,
                                 unknown_sites = NULL,
                                 label_var = "site_name",
                                 x_min = NULL,
                                 x_max = NULL,
                                 y_min = NULL,
                                 y_max = NULL,
                                 label_unknown = TRUE,
                                 out_plot = "pca_funerary_surface.png") {
  if (length(features) != 2L) stop("feature_surface_plot() needs exactly 2 features.")

  fit <- .surface_fit_coordinates(
    tapho_db = tapho_db,
    res = res,
    features = features,
    task_name = task_name,
    focus_class = focus_class,
    n_features = n_features,
    ntree = ntree,
    cv_folds = cv_folds,
    seed = seed,
    unknown_sites = unknown_sites,
    label_var = label_var
  )

  known <- fit$known
  unknown <- fit$unknown
  xr <- .surface_axis_range(known$.d1, x_min, x_max, fit$features[1])
  yr <- .surface_axis_range(known$.d2, y_min, y_max, fit$features[2])

  grid <- expand.grid(
    .d1 = seq(xr[1], xr[2], length.out = grid_n),
    .d2 = seq(yr[1], yr[2], length.out = grid_n),
    KEEP.OUT.ATTRS = FALSE
  )
  grid$prob <- .ensemble_prob(
    fit$rf_list,
    grid[, c(".d1", ".d2"), drop = FALSE],
    fit$classes
  )[, focus_class]

  p <- ggplot2::ggplot() +
    ggplot2::geom_raster(
      data = grid,
      ggplot2::aes(x = .d1, y = .d2, fill = prob),
      interpolate = TRUE
    ) +
    ggplot2::geom_contour(
      data = grid,
      ggplot2::aes(x = .d1, y = .d2, z = prob),
      breaks = 0.5,
      colour = "white",
      linewidth = 0.4
    ) +
    ggplot2::scale_fill_gradientn(
      colours = c("#3b4cc0", "#7b9ff9", "#f7f7f7", "#f4987a", "#b40426"),
      limits = c(0, 1),
      name = paste0("mean P(", focus_class, ")")
    ) +
    ggplot2::geom_point(
      data = known,
      ggplot2::aes(x = .d1, y = .d2, colour = class),
      size = 2,
      alpha = 0.9
    ) +
    ggplot2::scale_colour_brewer(palette = "Dark2", name = "Known class")

  if (!is.null(unknown) && nrow(unknown) > 0) {
    p <- p + ggplot2::geom_point(
      data = unknown,
      ggplot2::aes(x = .d1, y = .d2),
      shape = 4,
      size = 3,
      stroke = 1.1,
      colour = "black"
    )

    if (isTRUE(label_unknown)) {
      if (requireNamespace("ggrepel", quietly = TRUE)) {
        p <- p + ggrepel::geom_text_repel(
          data = unknown,
          ggplot2::aes(x = .d1, y = .d2, label = label),
          size = 3,
          colour = "black",
          max.overlaps = Inf,
          box.padding = 0.4,
          min.segment.length = 0
        )
      } else {
        p <- p + ggplot2::geom_text(
          data = unknown,
          ggplot2::aes(x = .d1, y = .d2, label = label),
          size = 3,
          vjust = -0.8,
          colour = "black"
        )
      }
    }
  }

  p <- p +
    ggplot2::labs(
      title = paste0("RF probability surface — ", focus_class),
      subtitle = paste0(
        task_name, " | ", length(fit$rf_list), "-model CV mean | coordinates: ",
        paste(fit$features, collapse = " + ")
      ),
      x = fit$axis_titles[1],
      y = fit$axis_titles[2]
    ) +
    ggplot2::coord_cartesian(xlim = xr, ylim = yr, expand = FALSE) +
    ggplot2::theme_minimal(base_size = 12)

  ggplot2::ggsave(out_plot, p, width = 9, height = 7, dpi = 150)
  print(p)
  message("Wrote surface -> ", out_plot)

  if (!is.null(unknown) && nrow(unknown) > 0) {
    prob_cols <- grep("^p_model", names(unknown), value = TRUE)
    out_tbl <- unknown %>%
      dplyr::select(
        label,
        dplyr::any_of(c("site_name", "ind_name")),
        predicted = pred,
        dplyr::all_of(prob_cols),
        p_focus_mean = p_focus
      ) %>%
      dplyr::mutate(
        dplyr::across(
          c(dplyr::all_of(prob_cols), p_focus_mean),
          ~ round(.x, 4)
        )
      )
    print(as.data.frame(out_tbl), row.names = FALSE)
  }

  fit$plot <- p
  fit$grid <- grid
  invisible(fit)
}


# ---------------------------------------------------------------------
# 3D Plotly probability view using any three raw/PCA coordinates.
# ---------------------------------------------------------------------
feature_surface_plotly <- function(tapho_db,
                                   res,
                                   features = c(
                                     "mnau_upper_appendicular_mean",
                                     "all_sections_dominance",
                                     "mnau_vertebrae_to_thorax_ratio"
                                   ),
                                   task_name = "4class",
                                   focus_class = "Funerary Context",
                                   n_features = 20,
                                   ntree = 500,
                                   cv_folds = 3,
                                   seed = 42,
                                   unknown_sites = NULL,
                                   label_var = "site_name",
                                   x_min = NULL,
                                   x_max = NULL,
                                   y_min = NULL,
                                   y_max = NULL,
                                   z_min = NULL,
                                   z_max = NULL,
                                   label_known = FALSE,
                                   label_unknown = TRUE,
                                   show_probability_surface = TRUE,
                                   prob_grid_n = 25,
                                   iso_probs = c(0.5),
                                   surface_opacity = 0.18,
                                   out_html = NULL) {
  if (length(features) != 3L) stop("feature_surface_plotly() needs exactly 3 features.")
  if (!requireNamespace("plotly", quietly = TRUE)) {
    stop("Package 'plotly' is required.")
  }
  if (!is.null(out_html) && !requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("Package 'htmlwidgets' is required to save HTML.")
  }

  fit <- .surface_fit_coordinates(
    tapho_db = tapho_db,
    res = res,
    features = features,
    task_name = task_name,
    focus_class = focus_class,
    n_features = n_features,
    ntree = ntree,
    cv_folds = cv_folds,
    seed = seed,
    unknown_sites = unknown_sites,
    label_var = label_var
  )

  known <- fit$known
  unknown <- fit$unknown
  xr <- .surface_axis_range(known$.d1, x_min, x_max, fit$features[1])
  yr <- .surface_axis_range(known$.d2, y_min, y_max, fit$features[2])
  zr <- .surface_axis_range(known$.d3, z_min, z_max, fit$features[3])

  crop3 <- function(df) {
    if (is.null(df) || nrow(df) == 0) return(df)
    df %>% dplyr::filter(
      .d1 >= xr[1], .d1 <= xr[2],
      .d2 >= yr[1], .d2 <= yr[2],
      .d3 >= zr[1], .d3 <= zr[2]
    )
  }

  known_plot <- crop3(known)
  unknown_plot <- crop3(unknown)

  known_plot$hover <- paste0(
    "<b>", known_plot$label, "</b>",
    "<br>Known class: ", known_plot$class,
    "<br>Ensemble predicted: ", known_plot$pred,
    "<br>Mean P(", focus_class, "): ", round(known_plot$p_focus, 4),
    "<br>", fit$features[1], ": ", round(known_plot$.d1, 4),
    "<br>", fit$features[2], ": ", round(known_plot$.d2, 4),
    "<br>", fit$features[3], ": ", round(known_plot$.d3, 4)
  )

  if (!is.null(unknown_plot) && nrow(unknown_plot) > 0) {
    unknown_plot$hover <- paste0(
      "<b>", unknown_plot$label, "</b>",
      "<br>UNKNOWN item",
      "<br>Predicted class: ", unknown_plot$pred,
      "<br>Mean P(", focus_class, "): ", round(unknown_plot$p_focus, 4),
      "<br>", fit$features[1], ": ", round(unknown_plot$.d1, 4),
      "<br>", fit$features[2], ": ", round(unknown_plot$.d2, 4),
      "<br>", fit$features[3], ": ", round(unknown_plot$.d3, 4)
    )
  }

  prob_grid <- NULL
  iso_probs <- sort(unique(iso_probs))
  iso_probs <- iso_probs[is.finite(iso_probs) & iso_probs >= 0 & iso_probs <= 1]

  if (isTRUE(show_probability_surface)) {
    if (prob_grid_n < 5) stop("prob_grid_n must be >= 5.")
    if (!length(iso_probs)) stop("iso_probs must include a value between 0 and 1.")

    prob_grid <- expand.grid(
      .d1 = seq(xr[1], xr[2], length.out = prob_grid_n),
      .d2 = seq(yr[1], yr[2], length.out = prob_grid_n),
      .d3 = seq(zr[1], zr[2], length.out = prob_grid_n),
      KEEP.OUT.ATTRS = FALSE
    )
    prob_grid$p_focus <- .ensemble_prob(
      fit$rf_list,
      prob_grid[, c(".d1", ".d2", ".d3"), drop = FALSE],
      fit$classes
    )[, focus_class]
  }

  class_cols <- stats::setNames(
    grDevices::hcl.colors(length(fit$classes), palette = "Dark 3"),
    fit$classes
  )
  iso_cols <- grDevices::hcl.colors(max(length(iso_probs), 3), palette = "BluGrn")[seq_along(iso_probs)]

  p <- plotly::plot_ly()

  if (!is.null(prob_grid) && nrow(prob_grid) > 0) {
    for (i in seq_along(iso_probs)) {
      iso <- iso_probs[i]
      col <- iso_cols[i]
      p <- plotly::add_trace(
        p,
        x = prob_grid$.d1,
        y = prob_grid$.d2,
        z = prob_grid$.d3,
        value = prob_grid$p_focus,
        type = "isosurface",
        isomin = iso,
        isomax = iso,
        surface = list(count = 1),
        caps = list(
          x = list(show = FALSE),
          y = list(show = FALSE),
          z = list(show = FALSE)
        ),
        opacity = surface_opacity,
        colorscale = list(list(0, col), list(1, col)),
        showscale = FALSE,
        hoverinfo = "skip",
        name = paste0("P(", focus_class, ") = ", iso),
        inherit = FALSE
      )
    }
  }

  p <- plotly::add_markers(
    p,
    data = known_plot,
    x = ~.d1,
    y = ~.d2,
    z = ~.d3,
    type = "scatter3d",
    mode = if (label_known) "markers+text" else "markers",
    text = if (label_known) ~label else NULL,
    textposition = "top center",
    color = ~class,
    colors = class_cols,
    hovertext = ~hover,
    hoverinfo = "text",
    marker = list(size = 4, opacity = 0.78),
    name = "Known"
  )

  if (!is.null(unknown_plot) && nrow(unknown_plot) > 0) {
    p <- plotly::add_markers(
      p,
      data = unknown_plot,
      x = ~.d1,
      y = ~.d2,
      z = ~.d3,
      type = "scatter3d",
      mode = if (label_unknown) "markers+text" else "markers",
      text = if (label_unknown) ~label else NULL,
      textposition = "top center",
      hovertext = ~hover,
      hoverinfo = "text",
      marker = list(
        color = "black",
        size = 7,
        symbol = "diamond",
        opacity = 1,
        line = list(width = 1, color = "white")
      ),
      name = "Unknown"
    )
  }

  p <- plotly::layout(
    p,
    title = list(text = paste0(
      "3D RF ensemble — ", focus_class,
      "<br><sup>", task_name, " | coordinates: ",
      paste(fit$features, collapse = " + "), "</sup>"
    )),
    legend = list(orientation = "h", x = 0, y = -0.12),
    scene = list(
      xaxis = list(title = fit$axis_titles[1], range = xr),
      yaxis = list(title = fit$axis_titles[2], range = yr),
      zaxis = list(title = fit$axis_titles[3], range = zr),
      aspectmode = "cube"
    )
  )

  print(p)
  if (!is.null(out_html)) {
    htmlwidgets::saveWidget(p, out_html, selfcontained = TRUE)
    message("Wrote plotly HTML -> ", out_html)
  }

  fit$plot <- p
  fit$known_plot <- known_plot
  fit$unknown_plot <- unknown_plot
  fit$prob_grid <- prob_grid
  fit$iso_probs <- iso_probs
  invisible(fit)
}


# ---------------------------------------------------------------------
# 3D ordered specimen curve.
# Smoothly interpolates the selected specimens in the chosen 3D coordinate
# space and predicts P(focus_class) at every interpolated position.
# The curve colour therefore changes continuously with predicted probability.
# ---------------------------------------------------------------------
feature_probability_curve_plotly <- function(tapho_db,
                                              res,
                                              ordered_samples,
                                              features = c(
                                                "mnau_upper_appendicular_mean",
                                                "all_sections_dominance",
                                                "mnau_vertebrae_to_thorax_ratio"
                                              ),
                                              sample_var = "site_name",
                                              task_name = "4class",
                                              focus_class = "Funerary Context",
                                              n_features = 20,
                                              ntree = 500,
                                              cv_folds = 3,
                                              seed = 42,
                                              curve_n = 121,
                                              spline_method = "natural",
                                              show_background = TRUE,
                                              point_size = 10,
                                              curve_width = 6,
                                              out_html = NULL) {
  if (length(features) != 3L) {
    stop("feature_probability_curve_plotly() needs exactly 3 features.")
  }
  if (length(ordered_samples) < 2L) {
    stop("ordered_samples must contain at least two labels.")
  }
  if (!sample_var %in% names(tapho_db)) {
    stop("sample_var '", sample_var, "' is not a column in tapho_db.")
  }
  if (!requireNamespace("plotly", quietly = TRUE)) {
    stop("Package 'plotly' is required.")
  }
  if (!is.null(out_html) && !requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("Package 'htmlwidgets' is required to save HTML.")
  }

  # Fit on all known rows and project all unknown rows; do not filter here,
  # because the ordered specimens may be known or unknown.
  fit <- .surface_fit_coordinates(
    tapho_db = tapho_db,
    res = res,
    features = features,
    task_name = task_name,
    focus_class = focus_class,
    n_features = n_features,
    ntree = ntree,
    cv_folds = cv_folds,
    seed = seed,
    unknown_sites = NULL,
    label_var = sample_var
  )

  known_for_match <- fit$known %>%
    dplyr::mutate(source = "known")
  unknown_for_match <- if (!is.null(fit$unknown)) {
    fit$unknown %>% dplyr::mutate(source = "unknown")
  } else {
    known_for_match[0, , drop = FALSE]
  }

  all_pts <- dplyr::bind_rows(known_for_match, unknown_for_match)

  anchor_idx <- integer(length(ordered_samples))
  for (i in seq_along(ordered_samples)) {
    hit <- which(all_pts$label == ordered_samples[i])
    if (!length(hit)) {
      stop("Ordered sample not found in ", sample_var, ": ", ordered_samples[i])
    }
    if (length(hit) > 1) {
      warning("Multiple rows match '", ordered_samples[i], "'; using the first one.")
    }
    anchor_idx[i] <- hit[1]
  }

  anchors <- all_pts[anchor_idx, , drop = FALSE]
  anchors$order <- seq_len(nrow(anchors))
  anchors$sample <- ordered_samples

  # Natural cubic parametric spline through the specimen coordinates.
  t_anchor <- seq(0, 1, length.out = nrow(anchors))
  curve_n <- max(as.integer(curve_n), nrow(anchors) * 10L)
  # Include every anchor parameter exactly so the rendered polyline itself
  # passes through each observed specimen, not merely the underlying spline.
  t_curve <- sort(unique(c(seq(0, 1, length.out = curve_n), t_anchor)))

  interp_coord <- function(y) {
    stats::spline(
      x = t_anchor,
      y = y,
      xout = t_curve,
      method = spline_method
    )$y
  }

  curve <- data.frame(
    .d1 = interp_coord(anchors$.d1),
    .d2 = interp_coord(anchors$.d2),
    .d3 = interp_coord(anchors$.d3),
    t = t_curve
  )

  curve_probs <- .ensemble_prob(
    fit$rf_list,
    curve[, c(".d1", ".d2", ".d3"), drop = FALSE],
    fit$classes
  )
  curve$p_focus <- curve_probs[, focus_class]
  curve$pred <- fit$classes[max.col(curve_probs, ties.method = "first")]

  # Recalculate anchor probabilities directly at the exact specimen points.
  anchor_probs <- .ensemble_prob(
    fit$rf_list,
    anchors[, c(".d1", ".d2", ".d3"), drop = FALSE],
    fit$classes
  )
  anchors$p_focus <- anchor_probs[, focus_class]
  anchors$pred <- fit$classes[max.col(anchor_probs, ties.method = "first")]

  anchors$hover <- paste0(
    "<b>", anchors$sample, "</b>",
    "<br>Order: ", anchors$order,
    "<br>Source: ", anchors$source,
    "<br>Predicted class: ", anchors$pred,
    "<br>Mean P(", focus_class, "): ", round(anchors$p_focus, 4),
    "<br>", fit$features[1], ": ", round(anchors$.d1, 4),
    "<br>", fit$features[2], ": ", round(anchors$.d2, 4),
    "<br>", fit$features[3], ": ", round(anchors$.d3, 4)
  )

  # Same blue -> white -> red probability palette as the 2D surface.
  prob_palette <- grDevices::colorRampPalette(
    c("#3b4cc0", "#7b9ff9", "#f7f7f7", "#f4987a", "#b40426")
  )(256)
  prob_to_col <- function(p) {
    ii <- pmax(1L, pmin(256L, floor(p * 255) + 1L))
    prob_palette[ii]
  }
  plotly_scale <- list(
    list(0.00, "#3b4cc0"),
    list(0.25, "#7b9ff9"),
    list(0.50, "#f7f7f7"),
    list(0.75, "#f4987a"),
    list(1.00, "#b40426")
  )

  p <- plotly::plot_ly()

  if (isTRUE(show_background)) {
    bg_known <- fit$known
    p <- plotly::add_markers(
      p,
      data = bg_known,
      x = ~.d1,
      y = ~.d2,
      z = ~.d3,
      type = "scatter3d",
      mode = "markers",
      marker = list(size = 3, color = "rgba(90,90,90,0.25)"),
      hoverinfo = "skip",
      name = "Known background"
    )

    if (!is.null(fit$unknown) && nrow(fit$unknown) > 0) {
      p <- plotly::add_markers(
        p,
        data = fit$unknown,
        x = ~.d1,
        y = ~.d2,
        z = ~.d3,
        type = "scatter3d",
        mode = "markers",
        marker = list(size = 3, color = "rgba(0,0,0,0.18)", symbol = "diamond"),
        hoverinfo = "skip",
        name = "Unknown background"
      )
    }
  }

  # Draw short coloured line segments. Using explicit segments guarantees a
  # true probability gradient along the 3D curve across Plotly versions.
  segment_prob <- (curve$p_focus[-nrow(curve)] + curve$p_focus[-1]) / 2
  segment_cols <- prob_to_col(segment_prob)

  for (i in seq_len(nrow(curve) - 1L)) {
    p <- plotly::add_trace(
      p,
      x = curve$.d1[c(i, i + 1L)],
      y = curve$.d2[c(i, i + 1L)],
      z = curve$.d3[c(i, i + 1L)],
      type = "scatter3d",
      mode = "lines",
      line = list(color = segment_cols[i], width = curve_width),
      hoverinfo = "skip",
      showlegend = FALSE,
      inherit = FALSE
    )
  }

  # Actual specimens: larger, labelled, and coloured by their exact p_focus.
  p <- plotly::add_markers(
    p,
    data = anchors,
    x = ~.d1,
    y = ~.d2,
    z = ~.d3,
    type = "scatter3d",
    mode = "markers+text",
    text = ~sample,
    textposition = "top center",
    hovertext = ~hover,
    hoverinfo = "text",
    marker = list(
      size = point_size,
      color = anchors$p_focus,
      colorscale = plotly_scale,
      cmin = 0,
      cmax = 1,
      showscale = TRUE,
      colorbar = list(title = paste0("P(", focus_class, ")")),
      line = list(width = 1.2, color = "black")
    ),
    name = "Ordered specimens"
  )

  p <- plotly::layout(
    p,
    title = list(text = paste0(
      "Ordered specimen probability curve — ", focus_class,
      "<br><sup>", task_name, " | ", sample_var, " order: ",
      paste(ordered_samples, collapse = " → "), "</sup>"
    )),
    scene = list(
      xaxis = list(title = fit$axis_titles[1]),
      yaxis = list(title = fit$axis_titles[2]),
      zaxis = list(title = fit$axis_titles[3]),
      aspectmode = "cube"
    ),
    legend = list(orientation = "h", x = 0, y = -0.12)
  )

  print(p)

  if (!is.null(out_html)) {
    htmlwidgets::saveWidget(p, out_html, selfcontained = TRUE)
    message("Wrote probability-curve HTML -> ", out_html)
  }

  anchor_table <- anchors %>%
    dplyr::select(
      order,
      sample,
      source,
      predicted = pred,
      p_focus_mean = p_focus,
      .d1,
      .d2,
      .d3
    ) %>%
    dplyr::mutate(p_focus_mean = round(p_focus_mean, 4))

  message("\n=== Ordered specimen probabilities ===")
  print(as.data.frame(anchor_table), row.names = FALSE)

  invisible(list(
    plot = p,
    fit = fit,
    anchors = anchors,
    anchor_table = anchor_table,
    curve = curve,
    ordered_samples = ordered_samples
  ))
}
