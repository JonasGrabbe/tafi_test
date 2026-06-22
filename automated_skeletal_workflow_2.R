# =====================================================================
#  AUTOMATED SKELETAL-PART REPRESENTATION WORKFLOW
#  ---------------------------------------------------------------------
#  Drop-in replacement for the hard-coded sites_up / sites_down /
#  sites_plot blocks. It:
#    1. builds groups AUTOMATICALLY from a metadata column
#       (or from a manual named list, for backward compatibility),
#    2. screens features and flags numerically degenerate ratios,
#    3. runs the SAME statistical battery as the .docx report
#       (Kruskal-Wallis -> epsilon^2 effect size -> BH-FDR ->
#        Dunn post-hoc -> PCA -> PERMANOVA),
#    4. emits the THREE plotly 3D plots:
#         (1) the most differential raw features,
#         (2) composite "mean" axes built from the top features,
#         (3) the PCA ordination,
#    5. optionally writes a Markdown report mirroring the original.
#
#  Expects the wide feature table `tb` from your existing workflow
#  (the 303-column tibble). Nothing else is hard-coded.
# =====================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(tibble)
  library(plotly)
  # statistics
  library(rstatix)   # kruskal_test, kruskal_effsize, dunn_test
  library(vegan)     # adonis2 (PERMANOVA), betadisper (dispersion caveat)
  # car::leveneTest is used if available; we fall back gracefully
})

# =====================================================================
# 0.  CONFIGURATION  -- everything you would normally hand-edit
# =====================================================================
CONFIG <- list(
  # --- GROUPING -------------------------------------------------------
  # Which metadata column defines the groups. The report's strongest
  # first-paper hypothesis is accumulation process, so this is the
  # sensible default. Swap to any column to test another hypothesis:
  #   "taphonomic_context", "funerary_context", "age_category",
  #   "open_air_site", "karstic_system", "cultural_period",
  #   "geological_period", "mis_stage", "hominin_species", "region".
  group_var      = "taphonomic_context",

  # Level cleaning applied before grouping
  drop_values    = c(NA, "", "Indet", "indet", "unknown", "Unknown", "NA"),
  recode         = list(),   # e.g. list("fluvial" = "geological",
                             #            "river"    = "geological")
  min_group_n    = 4,        # drop levels with fewer rows than this
  top_k_groups   = 3,        # keep only the k most populous levels
                             #   (NULL = keep all that pass min_group_n)

  # Manual override: set to a named list of site_name vectors to
  # reproduce the original report exactly, e.g.
  #   manual_groups = list(sites_up = c(...), sites_down = c(...), ...)
  # When non-NULL this WINS over group_var.
  manual_groups  = NULL,

  # --- FEATURES -------------------------------------------------------
  # Candidate pool the screening searches over. The 20 below are the
  # report's set. Set to NULL to auto-use every numeric feature column
  # (everything after sum_count), which lets the workflow *discover*
  # discriminating features instead of being told them.
  candidate_features = c(
    "mnau_girdle_mean", "mnau_proximal_appendicular_mean", "mnau_shoulder",
    "mnau_postcranial_total_mean", "mnau_upper_appendicular_mean",
    "mnau_appendicular_mean", "mnau_column_trunk_mean",
    "ProportionalRep_MNIbased_os_coxae", "mnau_arms",
    "low_density_survival_index", "ProportionalRep_MNIbased_metacarpal",
    "mnau_lower_appendicular_mean",
    "density_adjusted_appendicular_axial_contrast",
    "ProportionalRep_MNIbased_femur", "all_sections_dominance",
    "mnau_distal_appendicular_mean", "ReMNAU_cervical", "mnau_legs",
    "mne_vertebrae_to_thorax_ratio", "mne_arms_to_legs_ratio"
  ),

  # Columns that are metadata, never treated as features
  meta_cols = c(
    "site_id", "ind_name", "individual_id", "site_name", "layer_name",
    "count_type", "geological_period", "cultural_period",
    "culture_period_2", "start_date_cal_bp", "end_date_cal_bp",
    "mis_stage", "karstic_system", "karstic_system_2", "open_air_site",
    "open_air_site_2", "region", "country", "mni", "age_category",
    "n_infant", "n_juvenil", "n_subadult", "n_adult", "gender",
    "taphonomic_context", "funerary_context", "discovery_context",
    "degree_of_excavation", "hominin_species", "observation",
    "reference", "sum_count"
  ),

  # --- SCREENING / STATS ---------------------------------------------
  fdr_alpha          = 0.05,   # BH-FDR significance threshold
  degenerate_max     = 1e4,    # |value| above this flags a degenerate ratio
  n_top_plot1        = 3,      # raw features shown in plot 1 (3D needs 3)
  permanova_perm     = 9999,
  seed               = 20260616,

  # --- COLOURS (extended automatically if >3 groups) -----------------
  palette = c("#D55E00", "#0072B2", "#009E73", "#CC79A7",
              "#E69F00", "#56B4E9", "#F0E442", "#999999")
)

# =====================================================================
# 1.  AUTOMATED GROUPING
# =====================================================================
build_groups <- function(tb, cfg = CONFIG) {

  # ---- manual mode: reproduce the original hard-coded report --------
  if (!is.null(cfg$manual_groups)) {
    lookup <- stack(lapply(cfg$manual_groups, as.character)) |>
      setNames(c("site_name", "group"))
    out <- tb |>
      inner_join(lookup, by = "site_name") |>
      mutate(group = factor(group, levels = names(cfg$manual_groups)))
    attr(out, "group_var") <- "manual"
    return(out)
  }

  gv <- cfg$group_var
  if (!gv %in% names(tb))
    stop("group_var '", gv, "' is not a column of tb.")

  out <- tb |>
    mutate(.raw = trimws(as.character(.data[[gv]])))
  # apply manual level merges only if any were supplied
  if (length(cfg$recode) > 0)
    out <- out |> mutate(.raw = dplyr::recode(.raw, !!!cfg$recode))
  # drop unusable levels
  out <- out |>
    filter(!.raw %in% as.character(cfg$drop_values), !is.na(.raw))

  # enforce minimum group size
  keep <- out |> count(.raw) |> filter(n >= cfg$min_group_n) |> pull(.raw)
  out  <- out |> filter(.raw %in% keep)

  # keep only the k most populous levels, if requested
  if (!is.null(cfg$top_k_groups)) {
    keep <- out |> count(.raw, sort = TRUE) |>
      slice_head(n = cfg$top_k_groups) |> pull(.raw)
    out  <- out |> filter(.raw %in% keep)
  }

  if (dplyr::n_distinct(out$.raw) < 2)
    stop("Automated grouping produced < 2 usable groups for '", gv,
         "'. Loosen min_group_n / drop_values, or pick another column.")

  out <- out |>
    mutate(group = factor(.raw,
                          levels = names(sort(table(.raw), decreasing = TRUE)))) |>
    select(-.raw)

  attr(out, "group_var") <- gv
  message(sprintf("Grouping by '%s': %d groups, sizes = %s",
                  gv, nlevels(out$group),
                  paste(sprintf("%s=%d", levels(out$group),
                                table(out$group)), collapse = ", ")))
  out
}

# =====================================================================
# 2.  FEATURE SCREENING  (degenerate-ratio detection, report-style)
# =====================================================================
screen_features <- function(tb, cfg = CONFIG) {

  feats <- cfg$candidate_features
  if (is.null(feats)) {                       # auto: every numeric feature
    feats <- tb |>
      select(-any_of(cfg$meta_cols)) |>
      select(where(is.numeric)) |>
      names()
  }
  feats <- intersect(feats, names(tb))

  diag <- map_dfr(feats, function(f) {
    v <- suppressWarnings(as.numeric(tb[[f]]))
    finite <- v[is.finite(v)]
    tibble(
      feature   = f,
      n_finite  = length(finite),
      max_abs   = if (length(finite)) max(abs(finite)) else NA_real_,
      has_inf   = any(!is.finite(v) & !is.na(v)),
      # "ratio-like" name AND blown-up magnitude -> pathological
      degenerate = grepl("ratio", f, ignore.case = TRUE) &
                   (isTRUE(max(abs(finite)) > cfg$degenerate_max) | any(!is.finite(v) & !is.na(v)))
    )
  })

  # Multivariate (PCA/PERMANOVA) feature set, cleaned exactly as report:
  #  - drop the worst pathological ratios entirely
  #  - log1p-transform the merely-skewed ratios that survive
  mv_drop   <- diag |> filter(degenerate, max_abs > cfg$degenerate_max * 100 | has_inf) |> pull(feature)
  mv_log1p  <- diag |> filter(grepl("ratio", feature, ignore.case = TRUE),
                              !feature %in% mv_drop) |> pull(feature)
  mv_feats  <- setdiff(feats, mv_drop)

  list(
    rank_features = feats,        # KW/Dunn use ALL (rank-invariant to scale)
    mv_features   = mv_feats,     # PCA/PERMANOVA use the cleaned set
    log1p_features = mv_log1p,
    diagnostics   = diag
  )
}

# =====================================================================
# 3.  UNIVARIATE STATISTICS  (KW -> eps^2 -> BH-FDR -> Dunn)
# =====================================================================
rank_analysis <- function(df, features, cfg = CONFIG) {

  long <- df |>
    select(group, all_of(features)) |>
    mutate(across(all_of(features), ~ suppressWarnings(as.numeric(.)))) |>
    pivot_longer(all_of(features), names_to = "feature", values_to = "value") |>
    filter(is.finite(value))

  # omnibus Kruskal-Wallis + epsilon^2 effect size, per feature
  omnibus <- long |>
    group_by(feature) |>
    group_modify(function(d, key) {
      if (dplyr::n_distinct(d$group) < 2 || nrow(d) < 4)
        return(tibble(H = NA, df = NA, p = NA, eps2 = NA))
      kw  <- rstatix::kruskal_test(d, value ~ group)
      es  <- rstatix::kruskal_effsize(d, value ~ group)
      tibble(H = kw$statistic, df = kw$df, p = kw$p, eps2 = es$effsize)
    }) |>
    ungroup() |>
    mutate(p_fdr  = p.adjust(p, method = "BH"),
           sig    = p_fdr < cfg$fdr_alpha,
           effect = cut(eps2, c(-Inf, .01, .06, .14, Inf),
                        labels = c("negligible","small","moderate","large"))) |>
    arrange(desc(eps2))

  # Dunn post-hoc (BH) for every FDR-significant feature
  sig_feats <- omnibus |> filter(sig) |> pull(feature)
  posthoc <- if (length(sig_feats)) {
    long |> filter(feature %in% sig_feats) |>
      group_by(feature) |>
      group_modify(~ rstatix::dunn_test(.x, value ~ group, p.adjust.method = "BH")) |>
      ungroup()
  } else tibble()

  list(omnibus = omnibus, posthoc = posthoc, sig_features = sig_feats)
}

# =====================================================================
# 4.  MULTIVARIATE  (PCA + PERMANOVA + dispersion caveat)
# =====================================================================
multivariate_analysis <- function(df, mv_features, log1p_features, cfg = CONFIG) {

  set.seed(cfg$seed)
  X <- df |>
    select(group, site_name, all_of(mv_features)) |>
    mutate(across(all_of(log1p_features),
                  ~ log1p(pmax(suppressWarnings(as.numeric(.)), 0)))) |>
    mutate(across(all_of(mv_features), ~ suppressWarnings(as.numeric(.)))) |>
    drop_na()

  feat_mat <- X |> select(all_of(mv_features)) |>
    select(where(~ sd(., na.rm = TRUE) > 0)) |>   # drop constant cols
    as.matrix() |> scale()

  pca <- prcomp(feat_mat, center = FALSE, scale. = FALSE)
  npc <- min(3, ncol(pca$x))
  var_expl <- (pca$sdev^2 / sum(pca$sdev^2) * 100)[seq_len(npc)]

  scores <- as.data.frame(pca$x[, seq_len(npc), drop = FALSE])
  names(scores) <- paste0("PC", seq_len(npc))
  scores <- bind_cols(X |> select(group, site_name), scores)

  # PERMANOVA on Euclidean distances
  D <- dist(feat_mat)
  perm <- vegan::adonis2(D ~ group, data = X, permutations = cfg$permanova_perm)

  # dispersion caveat (PERMDISP analogue)
  disp <- vegan::betadisper(D, X$group)
  disp_p <- vegan::permutest(disp, permutations = cfg$permanova_perm)$tab$`Pr(>F)`[1]

  list(pca = pca, scores = scores, var_expl = var_expl,
       loadings = pca$rotation[, seq_len(npc), drop = FALSE],
       permanova = perm, dispersion_p = disp_p, X = X)
}

# =====================================================================
# 5.  COMPOSITE AXES  (for plot 2: "mean of important features")
# =====================================================================
# Groups the top features into up to 3 interpretable families and
# returns the per-row z-scored mean of each family.
build_composites <- function(df, top_features) {
  z <- function(v) { v <- suppressWarnings(as.numeric(v)); as.numeric(scale(v)) }

  fam <- function(pattern, pool)
    pool[grepl(pattern, pool, ignore.case = TRUE)]

  completeness <- fam("mean|postcranial|appendicular|girdle|shoulder|arms|legs|column",
                      top_features)
  density      <- fam("density|low_density|survival", top_features)
  balance      <- fam("contrast|ratio|os_coxae|femur|metacarpal|dominance|cervical",
                      top_features)

  # guarantee three non-empty axes: backfill from leftover top features
  leftover <- setdiff(top_features, c(completeness, density, balance))
  axes <- list(completeness_score      = completeness,
               density_survival_score  = density,
               axial_appendicular_score = balance)
  for (nm in names(axes)) {
    if (length(axes[[nm]]) == 0 && length(leftover)) {
      axes[[nm]] <- leftover[1]; leftover <- leftover[-1]
    }
  }

  comp <- imap_dfc(axes, function(cols, nm) {
    if (length(cols) == 0) return(setNames(tibble(rep(NA_real_, nrow(df))), nm))
    m <- rowMeans(sapply(cols, function(c) z(df[[c]])), na.rm = TRUE)
    setNames(tibble(m), nm)
  })

  bind_cols(df |> select(group, site_name), comp)
}

# =====================================================================
# 6.  THE THREE PLOTLY 3D PLOTS
# =====================================================================
.group_colours <- function(groups, cfg = CONFIG) {
  lv <- levels(groups)
  setNames(cfg$palette[seq_along(lv)], lv)
}

.scatter3d <- function(d, xcol, ycol, zcol, cfg, title,
                       ax = c(xcol, ycol, zcol)) {
  cols <- .group_colours(d$group, cfg)
  d <- d |> rename(.x = all_of(xcol), .y = all_of(ycol), .z = all_of(zcol))
  plot_ly(
    d, x = ~.x, y = ~.y, z = ~.z,
    color = ~group, colors = cols,
    type = "scatter3d", mode = "markers+text",
    text = ~site_name, textposition = "top center",
    marker = list(size = 6, opacity = 0.85),
    hoverinfo = "text",
    hovertext = ~paste0("<b>", site_name, "</b><br>Group: ", group,
                        "<br>", ax[1], ": ", round(.x, 4),
                        "<br>", ax[2], ": ", round(.y, 4),
                        "<br>", ax[3], ": ", round(.z, 4))
  ) |>
    layout(
      title = title,
      scene = list(xaxis = list(title = ax[1]),
                   yaxis = list(title = ax[2]),
                   zaxis = list(title = ax[3])),
      legend = list(title = list(text = "Group")))
}

# ---- PLOT 1: most differential raw features --------------------------
plot_top_features <- function(df, omnibus, cfg = CONFIG) {
  top <- omnibus |> filter(sig) |> slice_max(eps2, n = cfg$n_top_plot1) |>
    pull(feature)
  if (length(top) < 3)                          # fall back to top-by-eps2
    top <- omnibus |> slice_max(eps2, n = 3) |> pull(feature)
  d <- df |> select(group, site_name, all_of(top[1:3])) |>
    mutate(across(all_of(top[1:3]), ~ suppressWarnings(as.numeric(.))))
  .scatter3d(d, top[1], top[2], top[3], cfg,
             title = "1) Most differential skeletal features (by effect size)")
}

# ---- PLOT 2: composite "mean" axes -----------------------------------
plot_composites <- function(df, omnibus, cfg = CONFIG) {
  top  <- omnibus |> filter(sig | is.na(sig)) |> slice_max(eps2, n = 8) |> pull(feature)
  comp <- build_composites(df, top)
  axes <- names(comp)[!names(comp) %in% c("group", "site_name")]
  .scatter3d(comp, axes[1], axes[2], axes[3], cfg,
             title = "2) Composite axes (mean of top features per family)",
             ax = axes)
}

# ---- PLOT 3: PCA ordination ------------------------------------------
plot_pca <- function(mv, cfg = CONFIG) {
  s  <- mv$scores
  ve <- mv$var_expl
  .scatter3d(s, "PC1", "PC2", "PC3", cfg,
             title = "3) PCA of skeletal-representation features",
             ax = c(sprintf("PC1 (%.1f%%)", ve[1]),
                    sprintf("PC2 (%.1f%%)", ve[2]),
                    sprintf("PC3 (%.1f%%)", ve[3])))
}

# =====================================================================
# 7.  OPTIONAL: write a Markdown report mirroring the .docx
# =====================================================================
write_report <- function(grp, scr, uni, mv, file = "auto_skeletal_report.md") {
  gv <- attr(grp, "group_var")
  con <- file(file, open = "wt", encoding = "UTF-8")
  on.exit(close(con))
  wl <- function(...) writeLines(sprintf(...), con)

  wl("# Automated skeletal-representation analysis\n")
  wl("Grouping variable: **%s** | groups: %s | n = %d sites\n",
     gv, paste(sprintf("%s (%d)", levels(grp$group), table(grp$group)),
               collapse = ", "), nrow(grp))

  wl("\n## Omnibus (Kruskal-Wallis, BH-FDR)\n")
  writeLines(knitr::kable(
    uni$omnibus |> transmute(feature, eps2 = round(eps2, 3),
                             p_fdr = signif(p_fdr, 3), effect,
                             result = ifelse(sig, "significant", "n.s.")),
    format = "pipe"), con)

  wl("\n## Multivariate\n")
  perm <- mv$permanova
  wl("PERMANOVA pseudo-F = %.2f, p = %.4f (%d permutations).",
     perm$F[1], perm$`Pr(>F)`[1], CONFIG$permanova_perm)
  wl("Variance explained: PC1 %.1f%%, PC2 %.1f%%, PC3 %.1f%% (cum %.1f%%).",
     mv$var_expl[1], mv$var_expl[2], mv$var_expl[3], sum(mv$var_expl))
  wl("Dispersion caveat (PERMDISP) p = %.3f.", mv$dispersion_p)
  message("wrote ", normalizePath(file))
}

# =====================================================================
# 8.  ONE-CALL DRIVER
# =====================================================================
run_workflow <- function(tb, cfg = CONFIG, make_report = TRUE) {
  grp <- build_groups(tb, cfg)
  scr <- screen_features(grp, cfg)
  uni <- rank_analysis(grp, scr$rank_features, cfg)
  mv  <- multivariate_analysis(grp, scr$mv_features, scr$log1p_features, cfg)

  p1 <- plot_top_features(grp, uni$omnibus, cfg)
  p2 <- plot_composites(grp, uni$omnibus, cfg)
  p3 <- plot_pca(mv, cfg)

  if (make_report) write_report(grp, scr, uni, mv)

  list(groups = grp, screen = scr, univariate = uni, multivariate = mv,
       plots = list(top_features = p1, composites = p2, pca = p3))
}

# =====================================================================
#  EXAMPLE RUN  (after your `tb` is built)
# =====================================================================
# res <- run_workflow(tb)                 # default: group by taphonomic_context
# res$plots$top_features                   # plot 1
# res$plots$composites                     # plot 2
# res$plots$pca                            # plot 3
# res$univariate$omnibus                   # the ranked feature table
# res$multivariate$permanova               # PERMANOVA result
#
# # --- test a different hypothesis: just change one line --------------
# cfg2 <- modifyList(CONFIG, list(group_var = "age_category"))
# res_age <- run_workflow(tb, cfg2)
#
# # --- reproduce the ORIGINAL hard-coded report exactly ---------------
# cfg_manual <- modifyList(CONFIG, list(manual_groups = list(
#   sites_up   = c("Abri Pataud","Předmostí","La Ferrassie","Xemxija tombs",
#                  "Regourdou","Kiik-Koba","El Espinoso Cave","Atxuri-I Cave",
#                  "Mladeč Caves"),
#   sites_down = c("Ojo Guareña","Kebara Cave","Abri de Raymonden (Chancelade)",
#                  "Vado all'Arancio","Abrigo do Lagar Velho","Roc de Marsal",
#                  "Roc-de-Cave (Saint-Cirq-Madelon, Lot)","Sima de las Palomas",
#                  "Le Moustier II"),
#   sites_plot = c("Sima de los Huesos 95","Sima de los Huesos 16",
#                  "San Juan ante Portam Latinam","Crow Creek","Mugharet es-Skhul",
#                  "Tepecik-Çiftlik","Mancos 5MT-10010 Feature 3",
#                  "Yellow Jacket 5MT-3","Grotte des Perrats"))))
# res_manual <- run_workflow(tb, cfg_manual)
