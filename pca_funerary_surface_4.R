# =====================================================================
#  PCA decision-surface for "Funerary Context"
#
#  1. take the best 20 features from the RFE result
#  2. PCA them -> keep PC1, PC2
#  3. train RF on (PC1, PC2) with the known labels
#  4. fill a square grid over the PC1/PC2 range; colour each cell by
#     P(predicted class == "Funerary Context")
#  5. project the UNKNOWN instances (never used so far) through the SAME
#     20 features + SAME PCA rotation, predict, and scatter them on top,
#     labelled by site_name
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
# main
# ---------------------------------------------------------------------
pca_surface_plot <- function(tapho_db,
                             res,                       # output of rfe_rf / run_rfe
                             task_name   = "4class",
                             focus_class = "Funerary Context",
                             n_features  = 20,
                             ntree       = 500,
                             grid_n      = 200,         # cells per axis
                             seed        = 42,
                             unknown_sites = NULL,      # only plot these site_names (NULL = all)
                             out_plot    = "pca_funerary_surface.png") {

  set.seed(seed)

  # --- best 20 features (highest importance = retained longest) -------------
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

  # --- clean known features, drop any zero-variance among the 20 -----------
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

  # --- PCA on known features (centre + scale), keep PC1/PC2 ----------------
  pca <- stats::prcomp(Xk, center = TRUE, scale. = TRUE)
  sc_k <- as.data.frame(stats::predict(pca, Xk)[, 1:2, drop = FALSE])
  names(sc_k) <- c("PC1", "PC2")

  # --- RF on the two components --------------------------------------------
  train2 <- dplyr::mutate(sc_k, .y = yk)
  set.seed(seed)
  rf2 <- randomForest::randomForest(.y ~ PC1 + PC2, data = train2, ntree = ntree)

  # --- square probability grid over the PC ranges --------------------------
  g1 <- seq(min(sc_k$PC1), max(sc_k$PC1), length.out = grid_n)
  g2 <- seq(min(sc_k$PC2), max(sc_k$PC2), length.out = grid_n)
  grid <- expand.grid(PC1 = g1, PC2 = g2)
  if (!focus_class %in% levels(yk))
    stop("focus_class '", focus_class, "' is not a level of taphonomic_context")
  grid$prob <- stats::predict(rf2, grid, type = "prob")[, focus_class]

  # --- project unknown instances through the SAME features + rotation ------
  unk_scores <- NULL
  if (nrow(unknown_df) > 0) {
    cu  <- .clean_features(unknown_df, top_feats, medians = ck$medians)
    scu <- as.data.frame(stats::predict(pca, cu$X)[, 1:2, drop = FALSE])
    names(scu) <- c("PC1", "PC2")
    scu$site_name <- unknown_df$site_name
    scu$pred      <- stats::predict(rf2, scu[, c("PC1", "PC2")])
    scu$p_focus   <- stats::predict(rf2, scu[, c("PC1", "PC2")], type = "prob")[, focus_class]
    unk_scores <- scu
  }

  known_pts <- dplyr::mutate(sc_k, class = yk)

  # --- plot -----------------------------------------------------------------
  p <- ggplot() +
    geom_raster(data = grid, aes(PC1, PC2, fill = prob), interpolate = TRUE) +
    geom_contour(data = grid, aes(PC1, PC2, z = prob),
                 breaks = 0.5, colour = "white", linewidth = 0.4) +
    scale_fill_gradientn(
      colours = c("#3b4cc0", "#7b9ff9", "#f7f7f7", "#f4987a", "#b40426"),
      limits = c(0, 1), name = paste0("P(", focus_class, ")")) +
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
    labs(title = paste0("RF probability surface — ", focus_class),
         subtitle = paste0(task_name, " | RF on PC1/PC2 of best ",
                           length(top_feats), " features | x = unknown sites"),
         x = sprintf("PC1 (%.1f%% var)", 100 * summary(pca)$importance[2, 1]),
         y = sprintf("PC2 (%.1f%% var)", 100 * summary(pca)$importance[2, 2])) +
    coord_cartesian(expand = FALSE) +
    theme_minimal(base_size = 12)

  ggsave(out_plot, p, width = 9, height = 7, dpi = 150)
  print(p)
  message("Wrote surface -> ", out_plot)

  invisible(list(plot = p, pca = pca, rf2 = rf2,
                 top_feats = top_feats, medians = ck$medians,
                 known = known_pts, grid = grid, unknown = unk_scores))
}

# ---------------------------------------------------------------------
# Example
# ---------------------------------------------------------------------
# res <- run_rfe(tapho_db, task_name = "4class")
# focus_sites <- c(
#   "Kleine Feldhofer Grotte", "Bilzingsleben", "Weimar-Ehringsdorf",
#   "Scladina Cave", "Engis / Schmerling Cave", "Trou de la Naulette",
#   "Bolomor Cave", "Cova de les Malladetes (Barx, Valencia, Spain)",
#   "Cova del Parpalló (Parpalló Cave)", "Saint-Césaire",
#   "Steinheim an der Murr", "Ochoz 1, Ochoz 2", "Peștera Muierii",
#   "Sima de los Huesos"
# )
# pr  <- pca_surface_plot(tapho_db, res, task_name = "4class",
#                         unknown_sites = focus_sites)
# pr$unknown   # projected unknown sites with predicted class + P(Funerary Context)
