# =====================================================================
#  AUTOMATED SKELETAL-PART REPRESENTATION WORKFLOW  (multi-experiment)
#  ---------------------------------------------------------------------
#  Replaces the hard-coded site lists with metadata-driven grouping and
#  runs the SAME statistical battery as the .docx report
#  (Kruskal-Wallis -> epsilon^2 -> BH-FDR -> Dunn -> PCA -> PERMANOVA)
#  across EIGHT pre-registered hypotheses, in a loop.
#
#  For every experiment it writes, into its own sub-folder:
#    * group_sizes.csv, feature_diagnostics.csv
#    * descriptives.csv (median/IQR per group), assumption_checks.csv
#    * omnibus.csv (KW + eps^2 + BH-FDR), posthoc_dunn.csv
#    * pca_loadings.csv, pca_scores.csv, permanova.txt
#    * plot1_top_features.html, plot2_composites.html, plot3_pca.html
#    * REPORT.md  (a detailed, report-style write-up)
#  and one master_report.md / master_summary.csv comparing all eight.
#
#  Expects the wide feature table `tb` from your existing workflow.
# =====================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(purrr); library(tibble)
  library(plotly); library(htmlwidgets); library(knitr)
  library(rstatix)   # kruskal_test, kruskal_effsize, dunn_test
  library(vegan)     # adonis2 (PERMANOVA), betadisper (dispersion)
})
`%||%` <- function(a, b) if (is.null(a)) b else a

# =====================================================================
# 0.  FEATURE POOL  -- the 63 most important features (RFE ranking).
#     The final 10 "retained" features are the analytical core.
# =====================================================================
CORE_RETAINED_10 <- c(
  "mnau_foot", "mnau_postcranial_total_mean", "mnau_column_trunk_mean",
  "mnau_appendicular_mean", "mnau_upper_appendicular_mean",
  "mnau_lower_appendicular_mean", "mnau_girdle_mean",
  "mnau_distal_appendicular_mean", "mnau_proximal_appendicular_mean",
  "low_density_survival_index"
)

FEATURES_63 <- c(
  # ---- eliminated tier (broader, still important) ----
  "density_evenness", "lower_appendicular_evenness_refined",
  "ProportionalRep_MNIbased_humerus", "mnau_heip_evenness",
  "dominant_axial_share", "ReMNAU_ulna", "mne_cranial_share",
  "ProportionalRep_MNIbased_tibia", "ProportionalRep_MNIbased_fibula",
  "mnau_arms_legs_diff", "distal_appendicular_continuity_hm",
  "ReMNAU_cervical", "low_density_share", "ProportionalRep_MNIbased_cervical",
  "appendicular_dominance_refined", "appendicular_dominance",
  "density_adjusted_appendicular_axial_contrast", "effective_sections_hill1",
  "mnau_axial_main_mean", "postcranial_dominance_refined", "mnau_arms",
  "lower_appendicular_continuity_hm", "mnau_arms_legs_logratio",
  "lower_appendicular_evenness", "ProportionalRep_MNIbased_metacarpal",
  "ProportionalRep_MNIbased_radius", "mnau_hands", "mne_arms", "mnau_pelvic",
  "ProportionalRep_MNIbased_clavicle", "mnau_cv", "mnau_region_mean_evenness",
  "mnau_limb_shaft_proxy_mean", "ProportionalRep_MNIbased_os_coxae",
  "ProportionalRep_MNIbased_carpal", "mnau_arms_to_legs_ratio", "ReMNAU_radius",
  "mne_arms_to_legs_ratio", "mnau_simpson_dominance", "mnau_gini",
  "mnau_dominance_of_region_means", "mnau_inverse_simpson", "mnau_shoulder",
  "ProportionalRep_MNIbased_femur", "mnau_vertebrae_to_thorax_ratio",
  "mne_vertebrae_to_thorax_ratio", "all_sections_dominance",
  "mnau_evenness_minus_dominance", "dominance_gap_all",
  "low_density_axial_survival", "mnau_top2_share_mcnaughton", "mnau_legs",
  "mnau_simpson_evenness",
  # ---- retained tier (core 10) ----
  CORE_RETAINED_10
)

# =====================================================================
# 1.  CONFIGURATION
# =====================================================================
CONFIG <- list(
  # grouping: a spec (mode = single | alternative | interaction)
  group_spec   = list(mode = "single", vars = "taphonomic_context"),
  manual_groups = NULL,                 # set to reproduce original report

  drop_values  = c(NA, "", "Indet", "indet", "unknown", "Unknown", "NA",
                   "na", "none", "None", "?"),
  recode       = list(),
  min_group_n  = 4,
  top_k_groups = NULL,                  # NULL = keep all qualifying levels

  candidate_features = FEATURES_63,     # the 63-feature pool
  core_features      = CORE_RETAINED_10,
  meta_cols = c(
    "site_id","ind_name","individual_id","site_name","layer_name","count_type",
    "geological_period","cultural_period","culture_period_2","start_date_cal_bp",
    "end_date_cal_bp","mis_stage","karstic_system","karstic_system_2",
    "open_air_site","open_air_site_2","region","country","mni","age_category",
    "n_infant","n_juvenil","n_subadult","n_adult","gender","taphonomic_context",
    "funerary_context","discovery_context","degree_of_excavation",
    "hominin_species","observation","reference","sum_count"),

  fdr_alpha      = 0.05,
  degenerate_max = 1e4,
  n_top_plot1    = 3,
  permanova_perm = 9999,
  seed           = 20260616,
  palette = c("#D55E00","#0072B2","#009E73","#CC79A7","#E69F00",
              "#56B4E9","#F0E442","#999999","#882255","#44AA99")
)

# =====================================================================
# 2.  THE EIGHT EXPERIMENTS  (from the hypothesis table)
# =====================================================================
EXPERIMENTS <- list(
  list(id="01_taphonomic_context", label="Accumulation process",
       spec=list(mode="single", vars="taphonomic_context"),
       hypothesis="Different accumulation causes produce different body-part profiles.",
       expected="Funerary contexts more anatomically balanced; carnivore/geological transport loses small, fragile, axial, low-density elements; cannibalism shows selective absence/over-representation of processed parts.",
       why="Strongest hypothesis: accumulation cause is directly linked to skeletal survival, transport and human/carnivore behaviour.",
       min_group_n=4, top_k=NULL),

  list(id="02_depositional_environment", label="Depositional environment",
       spec=list(mode="alternative", vars=c("karstic_system","open_air_site")),
       hypothesis="Depositional environment filters the skeleton before excavation.",
       expected="Cave interiors preserve more small elements; entrances/rockshelters show carnivore activity; fluvial deposits favour dense/large elements.",
       why="Tests whether site formation, not culture or species, explains anatomical differences.",
       min_group_n=4, top_k=NULL),

  list(id="03_funerary_x_cultural_period", label="Mortuary practice through time",
       spec=list(mode="interaction", vars=c("funerary_context","cultural_period")),
       hypothesis="Mortuary practice changes completeness and element selection through time.",
       expected="Single inhumations approach complete skeletons; collective burials over-represent crania/long bones; non-inhumation contexts more fragmentary.",
       why="Separates intentional mortuary behaviour from preservation loss (Robb: human handling can pattern representation).",
       min_group_n=3, top_k=6),

  list(id="04_age_category", label="Age-related preservation",
       spec=list(mode="single", vars="age_category"),
       hypothesis="Age affects preservation: infant/juvenile bones are smaller, less fused, more fragile.",
       expected="Infants/juveniles show lower representation of small unfused bones, axial elements, epiphyses, ribs, vertebrae, hands/feet, pelvis; adults more complete/identifiable.",
       why="Strong biological/taphonomic hypothesis; should be checked before interpreting cultural differences.",
       min_group_n=4, top_k=NULL),

  list(id="05_chronology_attrition", label="Time depth / attrition",
       spec=list(mode="alternative", vars=c("geological_period","mis_stage","cultural_period")),
       hypothesis="Older assemblages are more altered by long-term attrition and recovery bias.",
       expected="Earlier Pleistocene contexts lose fragile elements and over-represent teeth, cranial pieces, dense shafts; Holocene burials more complete.",
       why="Tests time-depth and preservation intensity (must be read alongside context).",
       min_group_n=4, top_k=NULL),

  list(id="06_hominin_species", label="Species (context-controlled)",
       spec=list(mode="single", vars="hominin_species"),
       hypothesis="Species-level differences may reflect different depositional histories, not anatomy alone.",
       expected="Neanderthal / earlier Homo / H. sapiens may differ, but differences may vanish after controlling for age, site type, period, context.",
       why="Interesting but risky; do not read causally unless preservation and context are controlled.",
       min_group_n=4, top_k=NULL),

  list(id="07_region_country", label="Research-history / sampling bias",
       spec=list(mode="alternative", vars=c("region","country")),
       hypothesis="Regional research history, geology, climate and excavation tradition affect recovery.",
       expected="Some regions more complete (cave preservation/modern excavation); others biased to diagnostic cranial/dental material.",
       why="Detects sampling and research-history bias; weaker as a behavioural hypothesis.",
       min_group_n=4, top_k=5),

  list(id="08_recovery_method", label="Recovery / excavation bias",
       spec=list(mode="alternative", vars=c("degree_of_excavation","discovery_context")),
       hypothesis="Recovery method affects which bones enter the dataset.",
       expected="Formal/complete excavations recover more small bones; quarry/casual discoveries over-represent large, visible, diagnostic elements.",
       why="Essential bias-control analysis; may explain patterns that otherwise look biological or cultural.",
       min_group_n=4, top_k=NULL)
)

# =====================================================================
# 3.  AUTOMATED GROUPING
# =====================================================================
build_groups <- function(tb, cfg = CONFIG) {

  if (!is.null(cfg$manual_groups)) {
    lookup <- utils::stack(lapply(cfg$manual_groups, as.character)) |>
      setNames(c("site_name", "group"))
    out <- tb |> inner_join(lookup, by = "site_name") |>
      mutate(group = factor(group, levels = names(cfg$manual_groups)))
    attr(out, "group_var") <- "manual"; return(out)
  }

  spec <- cfg$group_spec %||% list(mode = "single", vars = cfg$group_var)

  clean_col <- function(x) {
    x <- trimws(as.character(x))
    if (length(cfg$recode) > 0) x <- dplyr::recode(x, !!!cfg$recode)
    x[is.na(x) | x %in% as.character(cfg$drop_values)] <- NA_character_
    x
  }
  label_for <- function(vars, mode) {
    if (length(setdiff(vars, names(tb)))) return(NULL)
    cols <- lapply(vars, function(v) clean_col(tb[[v]]))
    if (mode == "interaction") {
      lab <- do.call(paste, c(cols, sep = " | "))
      lab[Reduce(`|`, lapply(cols, is.na))] <- NA_character_
      lab
    } else cols[[1]]
  }
  pick_and_filter <- function(lab) {
    if (is.null(lab)) return(NULL)
    keep <- names(which(table(lab) >= cfg$min_group_n))
    lab  <- ifelse(lab %in% keep, lab, NA_character_)
    if (!is.null(cfg$top_k_groups) &&
        length(unique(na.omit(lab))) > cfg$top_k_groups) {
      topk <- names(sort(table(lab), decreasing = TRUE))[seq_len(cfg$top_k_groups)]
      lab  <- ifelse(lab %in% topk, lab, NA_character_)
    }
    lab
  }

  if (identical(spec$mode, "alternative")) {
    scored <- lapply(spec$vars, function(v) {
      lab <- pick_and_filter(label_for(v, "single"))
      list(var = v, lab = lab,
           rows = sum(!is.na(lab)), groups = length(unique(na.omit(lab))))
    })
    scored <- Filter(function(s) !is.null(s$lab) && s$groups >= 2, scored)
    if (!length(scored))
      stop("No usable grouping column among: ", paste(spec$vars, collapse = ", "))
    best   <- scored[[ which.max(vapply(scored,
                 function(s) s$rows + s$groups / 1000, numeric(1))) ]]
    lab    <- best$lab; chosen <- best$var
  } else {
    chosen <- if (identical(spec$mode, "interaction"))
                paste(spec$vars, collapse = " \u00d7 ") else spec$vars[1]
    lab    <- pick_and_filter(label_for(spec$vars, spec$mode))
    if (is.null(lab))
      stop("Grouping column(s) not found: ", paste(spec$vars, collapse = ", "))
  }

  out <- tb |> mutate(.lab = lab) |> filter(!is.na(.lab))
  if (dplyr::n_distinct(out$.lab) < 2)
    stop("Automated grouping produced < 2 usable groups for '", chosen,
         "'. Loosen min_group_n / drop_values, or pick another column.")
  out <- out |>
    mutate(group = factor(.lab, levels = names(sort(table(.lab),
                                                    decreasing = TRUE)))) |>
    select(-.lab)
  attr(out, "group_var") <- chosen
  message(sprintf("[%s] %d groups, sizes = %s", chosen, nlevels(out$group),
                  paste(sprintf("%s=%d", levels(out$group),
                                table(out$group)), collapse = ", ")))
  out
}

# =====================================================================
# 4.  FEATURE SCREENING (degenerate-ratio detection)
# =====================================================================
screen_features <- function(tb, cfg = CONFIG) {
  feats <- cfg$candidate_features %||% (tb |> select(-any_of(cfg$meta_cols)) |>
                                          select(where(is.numeric)) |> names())
  feats <- intersect(feats, names(tb))

  diag <- map_dfr(feats, function(f) {
    v <- suppressWarnings(as.numeric(tb[[f]])); fin <- v[is.finite(v)]
    tibble(feature = f, n_finite = length(fin),
           max_abs = if (length(fin)) max(abs(fin)) else NA_real_,
           has_inf = any(!is.finite(v) & !is.na(v)),
           degenerate = grepl("ratio", f, ignore.case = TRUE) &
             (isTRUE(max(abs(fin)) > cfg$degenerate_max) |
                any(!is.finite(v) & !is.na(v))))
  })
  mv_drop  <- diag |> filter(degenerate,
                 max_abs > cfg$degenerate_max * 100 | has_inf) |> pull(feature)
  mv_log1p <- diag |> filter(grepl("ratio", feature, ignore.case = TRUE),
                             !feature %in% mv_drop) |> pull(feature)
  list(rank_features = feats, mv_features = setdiff(feats, mv_drop),
       log1p_features = mv_log1p, diagnostics = diag)
}

# =====================================================================
# 5.  DESCRIPTIVES + ASSUMPTION CHECKS
# =====================================================================
descriptives <- function(df, features) {
  df |> select(group, all_of(features)) |>
    mutate(across(all_of(features), ~ suppressWarnings(as.numeric(.)))) |>
    pivot_longer(all_of(features), names_to = "feature", values_to = "value") |>
    filter(is.finite(value)) |>
    group_by(feature, group) |>
    summarise(n = dplyr::n(), median = median(value), iqr = IQR(value),
              mean = mean(value), sd = sd(value), .groups = "drop") |>
    arrange(feature, group)
}

assumption_checks <- function(df, features) {
  long <- df |> select(group, all_of(features)) |>
    mutate(across(all_of(features), ~ suppressWarnings(as.numeric(.)))) |>
    pivot_longer(all_of(features), names_to = "feature", values_to = "value") |>
    filter(is.finite(value))

  shapiro <- long |> group_by(feature, group) |>
    summarise(shapiro_p = {
      v <- value[is.finite(value)]
      if (length(unique(v)) < 3 || length(v) < 3 || length(v) > 5000) NA_real_
      else tryCatch(stats::shapiro.test(v)$p.value, error = function(e) NA_real_)
    }, .groups = "drop")

  levene <- long |> group_by(feature) |>
    summarise(levene_p = {
      ok <- requireNamespace("car", quietly = TRUE) &&
        dplyr::n_distinct(group) >= 2 && length(value) > 4
      if (!ok) NA_real_ else tryCatch(
        car::leveneTest(value ~ factor(group), center = median)$`Pr(>F)`[1],
        error = function(e) NA_real_)
    }, .groups = "drop")

  list(shapiro = shapiro, levene = levene)
}

# =====================================================================
# 6.  UNIVARIATE STATISTICS (KW -> eps^2 -> BH-FDR -> Dunn)
# =====================================================================
rank_analysis <- function(df, features, cfg = CONFIG) {
  long <- df |> select(group, all_of(features)) |>
    mutate(across(all_of(features), ~ suppressWarnings(as.numeric(.)))) |>
    pivot_longer(all_of(features), names_to = "feature", values_to = "value") |>
    filter(is.finite(value))

  omnibus <- long |> group_by(feature) |>
    group_modify(function(d, key) {
      if (dplyr::n_distinct(d$group) < 2 || nrow(d) < 4)
        return(tibble(H = NA, df = NA, p = NA, eps2 = NA))
      kw <- rstatix::kruskal_test(d, value ~ group)
      es <- rstatix::kruskal_effsize(d, value ~ group)
      tibble(H = kw$statistic, df = kw$df, p = kw$p, eps2 = es$effsize)
    }) |> ungroup() |>
    mutate(p_fdr = p.adjust(p, method = "BH"),
           sig   = !is.na(p_fdr) & p_fdr < cfg$fdr_alpha,
           effect = cut(eps2, c(-Inf, .01, .06, .14, Inf),
                        labels = c("negligible","small","moderate","large"))) |>
    arrange(desc(eps2))

  sig_feats <- omnibus |> filter(sig) |> pull(feature)
  posthoc <- if (length(sig_feats))
    long |> filter(feature %in% sig_feats) |> group_by(feature) |>
      group_modify(~ rstatix::dunn_test(.x, value ~ group,
                                        p.adjust.method = "BH")) |> ungroup()
  else tibble()

  list(omnibus = omnibus, posthoc = posthoc, sig_features = sig_feats)
}

# =====================================================================
# 7.  MULTIVARIATE (PCA + PERMANOVA + dispersion caveat)
# =====================================================================
multivariate_analysis <- function(df, mv_features, log1p_features, cfg = CONFIG) {
  set.seed(cfg$seed)
  X <- df |> select(group, site_name, all_of(mv_features)) |>
    mutate(across(all_of(log1p_features),
                  ~ log1p(pmax(suppressWarnings(as.numeric(.)), 0)))) |>
    mutate(across(all_of(mv_features), ~ suppressWarnings(as.numeric(.)))) |>
    drop_na()
  if (nrow(X) < 3 || dplyr::n_distinct(X$group) < 2)
    stop("Too few complete rows/groups for multivariate analysis.")

  feat_mat <- X |> select(all_of(mv_features)) |>
    select(where(~ sd(., na.rm = TRUE) > 0)) |> as.matrix() |> scale()

  pca <- prcomp(feat_mat, center = FALSE, scale. = FALSE)
  npc <- min(3, ncol(pca$x))
  ve  <- (pca$sdev^2 / sum(pca$sdev^2) * 100)[seq_len(npc)]
  scores <- as.data.frame(pca$x[, seq_len(npc), drop = FALSE])
  names(scores) <- paste0("PC", seq_len(npc))
  scores <- bind_cols(X |> select(group, site_name), scores)

  D    <- dist(feat_mat)
  perm <- vegan::adonis2(D ~ group, data = X, permutations = cfg$permanova_perm)
  disp <- vegan::betadisper(D, X$group)
  disp_p <- vegan::permutest(disp, permutations = cfg$permanova_perm)$tab$`Pr(>F)`[1]

  list(pca = pca, scores = scores, var_expl = ve,
       loadings = pca$rotation[, seq_len(npc), drop = FALSE],
       permanova = perm, dispersion_p = disp_p, X = X)
}

# =====================================================================
# 8.  COMPOSITE AXES (for plot 2)
# =====================================================================
build_composites <- function(df, top_features) {
  z <- function(v) as.numeric(scale(suppressWarnings(as.numeric(v))))
  fam <- function(p, pool) pool[grepl(p, pool, ignore.case = TRUE)]

  axes <- list(
    completeness_score       = fam("mean|postcranial|appendicular|girdle|shoulder|arms|legs|column|foot|hands", top_features),
    density_survival_score   = fam("density|low_density|survival", top_features),
    axial_appendicular_score = fam("contrast|ratio|os_coxae|femur|metacarpal|dominance|cervical|evenness|axial", top_features))
  leftover <- setdiff(top_features, unlist(axes))
  for (nm in names(axes))
    if (length(axes[[nm]]) == 0 && length(leftover)) {
      axes[[nm]] <- leftover[1]; leftover <- leftover[-1]
    }
  comp <- imap_dfc(axes, function(cols, nm) {
    if (length(cols) == 0) return(setNames(tibble(rep(NA_real_, nrow(df))), nm))
    m <- rowMeans(sapply(cols, function(c) z(df[[c]])), na.rm = TRUE)
    setNames(tibble(m), nm)
  })
  bind_cols(df |> select(group, site_name), comp)
}

# =====================================================================
# 9.  THE THREE PLOTLY 3D PLOTS
# =====================================================================
.group_colours <- function(groups, cfg = CONFIG)
  setNames(cfg$palette[seq_along(levels(groups))], levels(groups))

.scatter3d <- function(d, xcol, ycol, zcol, cfg, title, ax = c(xcol, ycol, zcol)) {
  cols <- .group_colours(d$group, cfg)
  d <- d |> rename(.x = all_of(xcol), .y = all_of(ycol), .z = all_of(zcol))
  plot_ly(d, x = ~.x, y = ~.y, z = ~.z, color = ~group, colors = cols,
          type = "scatter3d", mode = "markers+text",
          text = ~site_name, textposition = "top center",
          marker = list(size = 6, opacity = 0.85), hoverinfo = "text",
          hovertext = ~paste0("<b>", site_name, "</b><br>Group: ", group,
                              "<br>", ax[1], ": ", round(.x, 4),
                              "<br>", ax[2], ": ", round(.y, 4),
                              "<br>", ax[3], ": ", round(.z, 4))) |>
    layout(title = title,
           scene = list(xaxis = list(title = ax[1]),
                        yaxis = list(title = ax[2]),
                        zaxis = list(title = ax[3])),
           legend = list(title = list(text = "Group")))
}

plot_top_features <- function(df, omnibus, cfg = CONFIG) {
  top <- omnibus |> filter(sig) |> slice_max(eps2, n = cfg$n_top_plot1) |> pull(feature)
  if (length(top) < 3) top <- omnibus |> slice_max(eps2, n = 3) |> pull(feature)
  top <- top[1:3]
  d <- df |> select(group, site_name, all_of(top)) |>
    mutate(across(all_of(top), ~ suppressWarnings(as.numeric(.))))
  .scatter3d(d, top[1], top[2], top[3], cfg,
             "1) Most differential skeletal features (by effect size)")
}

plot_composites <- function(df, omnibus, cfg = CONFIG) {
  top  <- omnibus |> slice_max(eps2, n = 10) |> pull(feature)
  comp <- build_composites(df, top)
  axes <- setdiff(names(comp), c("group", "site_name"))
  .scatter3d(comp, axes[1], axes[2], axes[3], cfg,
             "2) Composite axes (mean of top features per family)", ax = axes)
}

plot_pca <- function(mv, cfg = CONFIG) {
  ve <- mv$var_expl
  .scatter3d(mv$scores, "PC1", "PC2", "PC3", cfg,
             "3) PCA of skeletal-representation features",
             ax = c(sprintf("PC1 (%.1f%%)", ve[1]),
                    sprintf("PC2 (%.1f%%)", ve[2]),
                    sprintf("PC3 (%.1f%%)", ve[3])))
}

# =====================================================================
# 10.  SINGLE-EXPERIMENT RUNNER
# =====================================================================
run_workflow <- function(tb, cfg = CONFIG) {
  grp <- build_groups(tb, cfg)
  scr <- screen_features(grp, cfg)
  uni <- rank_analysis(grp, scr$rank_features, cfg)
  desc <- descriptives(grp, scr$rank_features)
  asum <- assumption_checks(grp, scr$rank_features)
  mv  <- multivariate_analysis(grp, scr$mv_features, scr$log1p_features, cfg)
  list(groups = grp, screen = scr, univariate = uni, descriptives = desc,
       assumptions = asum, multivariate = mv,
       plots = list(top_features = plot_top_features(grp, uni$omnibus, cfg),
                    composites   = plot_composites(grp, uni$omnibus, cfg),
                    pca          = plot_pca(mv, cfg)))
}

# =====================================================================
# 11.  SAVING (CSVs, HTML plots, per-experiment report)
# =====================================================================
.save_widget <- function(p, path) {
  ok <- tryCatch({ htmlwidgets::saveWidget(p, path, selfcontained = TRUE); TRUE },
                 error = function(e) FALSE)
  if (!ok) tryCatch(htmlwidgets::saveWidget(p, path, selfcontained = FALSE),
                    error = function(e) message("  ! could not save ", path))
}

save_experiment <- function(res, ex, dir, cfg) {
  wc <- function(x, f) utils::write.csv(x, file.path(dir, f), row.names = FALSE)

  gs <- table(res$groups$group)
  wc(tibble(group = names(gs), n = as.integer(gs)), "group_sizes.csv")
  wc(res$screen$diagnostics, "feature_diagnostics.csv")
  wc(res$descriptives, "descriptives.csv")
  wc(res$assumptions$shapiro, "assumption_shapiro.csv")
  wc(res$assumptions$levene,  "assumption_levene.csv")
  wc(res$univariate$omnibus,  "omnibus.csv")
  wc(res$univariate$posthoc,  "posthoc_dunn.csv")
  wc(as.data.frame(res$multivariate$loadings) |> rownames_to_column("feature"),
     "pca_loadings.csv")
  wc(res$multivariate$scores, "pca_scores.csv")

  pm <- res$multivariate$permanova
  writeLines(c(
    sprintf("PERMANOVA (adonis2, %d permutations)", cfg$permanova_perm),
    sprintf("pseudo-F = %.3f", pm$F[1]),
    sprintf("R2       = %.3f", pm$R2[1]),
    sprintf("p-value  = %.5f", pm$`Pr(>F)`[1]),
    sprintf("PERMDISP dispersion p = %.4f", res$multivariate$dispersion_p),
    sprintf("Variance explained: PC1 %.1f%%  PC2 %.1f%%  PC3 %.1f%%  (cum %.1f%%)",
            res$multivariate$var_expl[1], res$multivariate$var_expl[2],
            res$multivariate$var_expl[3], sum(res$multivariate$var_expl))),
    file.path(dir, "permanova.txt"))

  .save_widget(res$plots$top_features, file.path(dir, "plot1_top_features.html"))
  .save_widget(res$plots$composites,   file.path(dir, "plot2_composites.html"))
  .save_widget(res$plots$pca,          file.path(dir, "plot3_pca.html"))

  write_experiment_report(res, ex, dir, cfg)
}

write_experiment_report <- function(res, ex, dir, cfg) {
  con <- file(file.path(dir, "REPORT.md"), open = "wt", encoding = "UTF-8")
  on.exit(close(con)); wl <- function(...) writeLines(sprintf(...), con)
  gv <- attr(res$groups, "group_var")
  om <- res$univariate$omnibus
  pm <- res$multivariate$permanova
  ve <- res$multivariate$var_expl
  n_sig <- sum(om$sig, na.rm = TRUE)
  topf  <- om |> slice_max(eps2, n = 1)

  wl("# %s", ex$label)
  wl("*Automated %s \u00d7 skeletal-part representation*\n", gv)
  wl("- **Grouping column:** `%s` (mode = %s)", gv, ex$spec$mode)
  wl("- **Groups (n):** %s", paste(sprintf("%s = %d", levels(res$groups$group),
                                           table(res$groups$group)), collapse = "; "))
  wl("- **Sites analysed:** %d  |  **features screened:** %d",
     nrow(res$groups), length(res$screen$rank_features))

  wl("\n## Hypothesis\n")
  wl("**H:** %s\n", ex$hypothesis)
  wl("**Expected pattern:** %s\n", ex$expected)
  wl("**Why it matters:** %s\n", ex$why)

  wl("\n## Summary\n")
  if (nrow(topf) && is.finite(topf$eps2))
    wl(paste0("%d of %d features differ significantly across groups after BH-FDR ",
              "correction. Strongest discriminator: **%s** (\u03b5\u00b2 = %.3f, ",
              "FDR p = %.4g). PERMANOVA pseudo-F = %.2f, p = %.4f; PC1\u2013PC3 ",
              "explain %.1f%% of variance.\n"),
       n_sig, nrow(om), topf$feature, topf$eps2, topf$p_fdr,
       pm$F[1], pm$`Pr(>F)`[1], sum(ve))

  wl("\n## 1. Data-quality screening\n")
  deg <- res$screen$diagnostics |> filter(degenerate)
  if (nrow(deg))
    wl("Flagged %d numerically degenerate ratio feature(s): %s. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.\n",
       nrow(deg), paste(deg$feature, collapse = ", "))
  else wl("No degenerate ratio features detected in this feature pool.\n")

  wl("\n## 2. Assumption checks\n")
  ns <- sum(res$assumptions$shapiro$shapiro_p < 0.05, na.rm = TRUE)
  nl <- sum(res$assumptions$levene$levene_p   < 0.05, na.rm = TRUE)
  wl("Shapiro-Wilk: %d feature\u00d7group cells depart from normality (p < 0.05). Levene (median-centred): %d features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.\n", ns, nl)

  wl("\n## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)\n")
  tab <- om |> transmute(Feature = feature, eps2 = round(eps2, 3),
                         `p (FDR)` = signif(p_fdr, 3), Effect = effect,
                         Result = ifelse(sig, "significant", "n.s."))
  writeLines(knitr::kable(tab, format = "pipe"), con)

  if (nrow(res$univariate$posthoc)) {
    wl("\n## 4. Post-hoc pairwise contrasts (Dunn, BH)\n")
    ph <- res$univariate$posthoc |>
      transmute(Feature = feature, Contrast = paste(group1, "vs", group2),
                Z = round(statistic, 2), `p (adj)` = signif(p.adj, 3),
                Sig = p.adj.signif)
    writeLines(knitr::kable(ph, format = "pipe"), con)
  }

  wl("\n## 5. Multivariate structure\n")
  wl("PERMANOVA (adonis2, %d permutations): pseudo-F = %.2f, R\u00b2 = %.3f, p = %.4f.",
     cfg$permanova_perm, pm$F[1], pm$R2[1], pm$`Pr(>F)`[1])
  wl("PCA variance explained: PC1 %.1f%%, PC2 %.1f%%, PC3 %.1f%% (cumulative %.1f%%).",
     ve[1], ve[2], ve[3], sum(ve))
  wl("Dispersion caveat (PERMDISP): p = %.3f%s.\n", res$multivariate$dispersion_p,
     ifelse(res$multivariate$dispersion_p < 0.05,
            " \u2014 unequal group spread, read the location difference with care", ""))
  ld <- as.data.frame(res$multivariate$loadings) |> rownames_to_column("feature") |>
    arrange(desc(abs(PC1))) |> head(8) |>
    transmute(Feature = feature, PC1 = round(PC1, 3),
              PC2 = round(PC2, 3), PC3 = round(PC3, 3))
  wl("Top PC1 loadings:\n")
  writeLines(knitr::kable(ld, format = "pipe"), con)

  wl("\n## 6. Figures\n")
  wl("1. `plot1_top_features.html` \u2014 the three most differential raw features, 3D, coloured by group.")
  wl("2. `plot2_composites.html` \u2014 completeness / density-survival / axial-appendicular composite axes.")
  wl("3. `plot3_pca.html` \u2014 PCA ordination (PC1\u2013PC3).")

  if (!is.null(ex$note)) wl("\n> **Note:** %s", ex$note)
  wl("\n---\n*Methods: Kruskal-Wallis + \u03b5\u00b2 effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (%d perms) with PERMDISP caveat. Seed = %d.*",
     cfg$permanova_perm, cfg$seed)
}

# =====================================================================
# 12.  MASTER REPORT across all experiments
# =====================================================================
write_master_report <- function(summ, root, experiments) {
  utils::write.csv(summ, file.path(root, "master_summary.csv"), row.names = FALSE)
  con <- file(file.path(root, "master_report.md"), open = "wt", encoding = "UTF-8")
  on.exit(close(con)); wl <- function(...) writeLines(sprintf(...), con)

  wl("# Skeletal-part representation: eight automated hypotheses\n")
  wl("Each hypothesis treats skeletal-part representation as the **outcome** and a metadata variable as the **grouping cause/filter**. Use `%%MNAU / %%MAU / relative MNAU`-type values (not raw MNE) so assemblage size does not drive the comparison, and remember that representation profiles can reflect transport, destruction, recovery, identification or cultural selection \u2014 not one process automatically.\n")
  wl("Pipeline per hypothesis: automated grouping \u2192 degenerate-ratio screening \u2192 Kruskal-Wallis + \u03b5\u00b2 + BH-FDR \u2192 Dunn post-hoc \u2192 PCA + PERMANOVA (with PERMDISP caveat) \u2192 three plotly 3D plots. Feature pool = the 63 RFE-ranked features (core 10 retained).\n")

  wl("\n## Cross-experiment summary\n")
  st <- summ |> transmute(
    `#` = experiment, Hypothesis = label, Status = status,
    Grouping = grouping, Groups = groups, n = n,
    `Sig feats` = n_sig, `Top feature` = top_feature, `Top eps2` = top_eps2,
    `PERMANOVA F` = permF, `p` = permP, `Disp p` = disp_p)
  writeLines(knitr::kable(st, format = "pipe"), con)

  wl("\n## How to read these results\n")
  wl("- **Strong, low-dispersion separation** (high \u03b5\u00b2, low PERMANOVA p, non-significant PERMDISP) is the most trustworthy signal.")
  wl("- A **significant PERMDISP p** means the groups differ partly in *spread*, not only location \u2014 interpret the centroid difference cautiously.")
  wl("- Experiments **07 (region/country)** and **08 (recovery method)** are bias-control checks: if they explain as much as the biological/cultural hypotheses, treat the latter as confounded by sampling/recovery.")
  wl("- The recommended first-paper framing: representation differs more by accumulation process and depositional environment than by cultural period or species, **after** controlling for assemblage size and excavation completeness.\n")

  wl("\n## Hypotheses in detail\n")
  for (ex in experiments) {
    row <- summ |> filter(experiment == ex$id)
    wl("\n### %s \u2014 %s", ex$id, ex$label)
    wl("- **H:** %s", ex$hypothesis)
    wl("- **Expected:** %s", ex$expected)
    wl("- **Why:** %s", ex$why)
    if (nrow(row) && row$status == "ok")
      wl("- **Result:** grouped by `%s` into %d groups; %d significant features; top = %s (\u03b5\u00b2 = %s); PERMANOVA p = %s. See `%s/REPORT.md`.",
         row$grouping, row$groups, row$n_sig, row$top_feature, row$top_eps2,
         row$permP, ex$id)
    else
      wl("- **Result:** could not run (insufficient usable groups). See `%s/ERROR.txt`.", ex$id)
  }
  wl("\n---\n*Generated %s.*", format(Sys.time(), "%Y-%m-%d %H:%M"))
  message("wrote ", normalizePath(file.path(root, "master_report.md")))
}

# =====================================================================
# 13.  RUN ALL EIGHT EXPERIMENTS IN A LOOP
# =====================================================================
run_all_experiments <- function(tb, out_root = NULL,
                                 base_cfg = CONFIG, experiments = EXPERIMENTS) {
  if (is.null(out_root))
    out_root <- file.path(getwd(),
                          format(Sys.time(), "results_skeletal_%Y%m%d_%H%M%S"))
  dir.create(out_root, recursive = TRUE, showWarnings = FALSE)
  message("Output folder: ", out_root)

  rows <- list()
  for (ex in experiments) {
    message("\n===== ", ex$id, " : ", ex$label, " =====")
    exdir <- file.path(out_root, ex$id)
    dir.create(exdir, showWarnings = FALSE)
    cfg <- modifyList(base_cfg, list(
      group_spec   = ex$spec,
      min_group_n  = ex$min_group_n %||% base_cfg$min_group_n,
      top_k_groups = if ("top_k" %in% names(ex)) ex$top_k else base_cfg$top_k_groups))

    res <- tryCatch(run_workflow(tb, cfg), error = function(e) e)
    if (inherits(res, "error")) {
      writeLines(c(paste("Experiment:", ex$id),
                   paste("FAILED:", conditionMessage(res))),
                 file.path(exdir, "ERROR.txt"))
      message("  ! failed: ", conditionMessage(res))
      rows[[ex$id]] <- tibble(experiment = ex$id, label = ex$label,
        status = "failed", grouping = NA, groups = NA, n = NA, n_sig = NA,
        top_feature = NA, top_eps2 = NA, permF = NA, permP = NA, disp_p = NA)
      next
    }
    save_experiment(res, ex, exdir, cfg)
    om   <- res$univariate$omnibus
    topf <- om |> slice_max(eps2, n = 1)
    rows[[ex$id]] <- tibble(
      experiment = ex$id, label = ex$label, status = "ok",
      grouping = attr(res$groups, "group_var"),
      groups = nlevels(res$groups$group), n = nrow(res$groups),
      n_sig = sum(om$sig, na.rm = TRUE),
      top_feature = topf$feature, top_eps2 = round(topf$eps2, 3),
      permF = round(res$multivariate$permanova$F[1], 2),
      permP = res$multivariate$permanova$`Pr(>F)`[1],
      disp_p = round(res$multivariate$dispersion_p, 3))
    message("  ok: ", rows[[ex$id]]$n_sig, " sig features; top = ",
            rows[[ex$id]]$top_feature)
  }
  write_master_report(bind_rows(rows), out_root, experiments)
  message("\nDONE. See ", out_root)
  invisible(out_root)
}

# =====================================================================
#  USAGE  (after `tb` is built)
# =====================================================================
# source("automated_skeletal_workflow.R")
# out <- run_all_experiments(tb)          # runs all 8, writes the folder
#
# # single hypothesis only:
# res <- run_workflow(tb, modifyList(CONFIG,
#          list(group_spec = list(mode = "single", vars = "age_category"))))
# res$plots$pca
#
# # reproduce the ORIGINAL hard-coded 3-group report:
# cfg <- modifyList(CONFIG, list(manual_groups = list(
#   sites_up = c("Abri Pataud","Předmostí", ...),
#   sites_down = c("Ojo Guareña", ...),
#   sites_plot = c("Sima de los Huesos 95", ...))))
# save_experiment(run_workflow(tb, cfg),
#   list(id="manual", label="Original report", spec=list(mode="manual"),
#        hypothesis="-", expected="-", why="-"), "manual_out", cfg)
