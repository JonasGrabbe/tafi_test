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
                             pc2_max     =  2,
                             pc2_min     = -2,          # crop PC2 below this (NULL = no crop)
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
unknown_df <- unknown_df %>% dplyr::filter(label_var %in% unknown_sites)

missing_sites <- setdiff(unknown_sites, unique(db$label_var))
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
message("Wrote plotly HTML -> ", out_html)
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
pca = pca,
rf_list = rf_list,
fold_acc = fold_acc,
top_feats = top_feats,
medians = ck$medians,
known = known_pts,
known_plot = known_pts_plot,
unknown = unk_scores,
unknown_plot = unk_scores_plot
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

  # 3D probability shell(s)
  show_probability_surface = TRUE,
  prob_grid_n = 25,
  iso_probs = c(0.5),
  surface_opacity = 0.18,

  # debugging
  print_feature_variance = FALSE,

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
print(unknown_df)
#if (!is.null(unknown_sites)) {
#unknown_df <- unknown_df %>%
#dplyr::filter(site_name %in% unknown_sites)

#missing_sites <- setdiff(unknown_sites, unique(db$site_name))

#if (length(missing_sites)) {
#warning(
#"site_name(s) not found in data: ",
#paste(missing_sites, collapse = ", ")
#)
#}
#}

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
message("Wrote plotly HTML -> ", out_html)
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
label_var = label_var
))
}