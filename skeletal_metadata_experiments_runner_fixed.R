# ============================================================
# Skeletal metadata experiments runner
# Version: 2026-06-18b - robust list-column extraction fix
# Source this file, then run:
#   out_all <- run_skeletal_metadata_experiments(tb)
#
# Expected input:
#   tb = wide tibble/data.frame produced from tapho.loader workflow,
#        with metadata columns and skeletal-representation feature columns.
#
# Output:
#   A timestamped folder with CSV results, RDS objects, Plotly HTML plots,
#   experiment markdown summaries, and MASTER_REPORT.html.
# ============================================================

# -----------------------------
# Package management
# -----------------------------
.skel_required_packages <- function() {
  c(
    "dplyr", "tidyr", "purrr", "stringr", "tibble",
    "plotly", "htmlwidgets", "htmltools", "knitr",
    "vegan", "rstatix", "readr"
  )
}

.skel_load_packages <- function(install_missing = FALSE) {
  pkgs <- .skel_required_packages()
  missing <- pkgs[!pkgs %in% rownames(installed.packages())]

  if (length(missing) > 0 && isTRUE(install_missing)) {
    install.packages(missing)
  }

  still_missing <- pkgs[!pkgs %in% rownames(installed.packages())]
  if (length(still_missing) > 0) {
    stop(
      "Missing required packages: ", paste(still_missing, collapse = ", "),
      "\nInstall them first, or call run_skeletal_metadata_experiments(..., install_missing = TRUE).",
      call. = FALSE
    )
  }

  invisible(lapply(pkgs, require, character.only = TRUE))
}

# -----------------------------
# Feature list: 63 important features supplied by user
# -----------------------------
.skel_important_features_63 <- function() {
  c(
    "density_evenness",
    "lower_appendicular_evenness_refined",
    "ProportionalRep_MNIbased_humerus",
    "mnau_heip_evenness",
    "dominant_axial_share",
    "ReMNAU_ulna",
    "mne_cranial_share",
    "ProportionalRep_MNIbased_tibia",
    "ProportionalRep_MNIbased_fibula",
    "mnau_arms_legs_diff",
    "distal_appendicular_continuity_hm",
    "ReMNAU_cervical",
    "low_density_share",
    "ProportionalRep_MNIbased_cervical",
    "appendicular_dominance_refined",
    "appendicular_dominance",
    "density_adjusted_appendicular_axial_contrast",
    "effective_sections_hill1",
    "mnau_axial_main_mean",
    "postcranial_dominance_refined",
    "mnau_arms",
    "lower_appendicular_continuity_hm",
    "mnau_arms_legs_logratio",
    "lower_appendicular_evenness",
    "ProportionalRep_MNIbased_metacarpal",
    "ProportionalRep_MNIbased_radius",
    "mnau_hands",
    "mne_arms",
    "mnau_pelvic",
    "ProportionalRep_MNIbased_clavicle",
    "mnau_cv",
    "mnau_region_mean_evenness",
    "mnau_limb_shaft_proxy_mean",
    "ProportionalRep_MNIbased_os_coxae",
    "ProportionalRep_MNIbased_carpal",
    "mnau_arms_to_legs_ratio",
    "ReMNAU_radius",
    "mne_arms_to_legs_ratio",
    "mnau_simpson_dominance",
    "mnau_gini",
    "mnau_dominance_of_region_means",
    "mnau_inverse_simpson",
    "mnau_shoulder",
    "ProportionalRep_MNIbased_femur",
    "mnau_vertebrae_to_thorax_ratio",
    "mne_vertebrae_to_thorax_ratio",
    "all_sections_dominance",
    "mnau_evenness_minus_dominance",
    "dominance_gap_all",
    "low_density_axial_survival",
    "mnau_top2_share_mcnaughton",
    "mnau_legs",
    "mnau_simpson_evenness",
    "mnau_foot",
    "mnau_postcranial_total_mean",
    "mnau_column_trunk_mean",
    "mnau_appendicular_mean",
    "mnau_upper_appendicular_mean",
    "mnau_lower_appendicular_mean",
    "mnau_girdle_mean",
    "mnau_distal_appendicular_mean",
    "mnau_proximal_appendicular_mean",
    "low_density_survival_index"
  )
}

.skel_bad_multivariate_features <- function() {
  c(
    "mne_vertebrae_to_thorax_ratio",
    "mnau_vertebrae_to_thorax_ratio"
  )
}

.skel_log1p_multivariate_features <- function() {
  c(
    "mne_arms_to_legs_ratio",
    "mnau_arms_to_legs_ratio"
  )
}

# -----------------------------
# Utility helpers
# -----------------------------
.skel_safe_slug <- function(x) {
  x |>
    stringr::str_to_lower() |>
    stringr::str_replace_all("[^a-z0-9]+", "_") |>
    stringr::str_replace_all("^_|_$", "")
}

.skel_numeric_clean <- function(x) {
  x <- suppressWarnings(as.numeric(x))
  x[!is.finite(x)] <- NA_real_
  x
}

.skel_epsilon_squared_kw <- function(H, n) {
  ifelse(is.na(H) | n <= 1, NA_real_, as.numeric(H) / (n - 1))
}

.skel_effect_label <- function(eps2) {
  dplyr::case_when(
    is.na(eps2) ~ NA_character_,
    eps2 >= 0.14 ~ "large",
    eps2 >= 0.06 ~ "moderate",
    eps2 >= 0.01 ~ "small",
    TRUE ~ "negligible"
  )
}

.skel_first_or_na <- function(x) {
  if (length(x) == 0) return(NA_real_)
  x[[1]]
}

# Robust extraction helpers for one-row tibble/list-column values.
# These avoid errors like .data[[list("taphonomic_context")]] when
# a list-column is returned one nesting level deeper than expected.
.skel_exp_scalar <- function(exp_row, col) {
  x <- exp_row[[col]]
  x <- unlist(x, recursive = TRUE, use.names = FALSE)
  if (length(x) == 0) return(NA_character_)
  as.character(x[[1]])
}

.skel_exp_vec <- function(exp_row, col) {
  x <- exp_row[[col]]
  x <- unlist(x, recursive = TRUE, use.names = FALSE)
  x <- as.character(x)
  x <- x[!is.na(x) & stringr::str_trim(x) != ""]
  unique(x)
}

# -----------------------------
# Experiments table
# -----------------------------
.skel_default_experiments <- function() {
  tibble::tribble(
    ~experiment_id, ~experiment_name, ~group_vars, ~covariates, ~hypothesis, ~expected_pattern, ~why_interesting,

    "E01",
    "taphonomic_context",
    list(c("taphonomic_context")),
    list(character(0)),
    "Different accumulation causes produce different body-part profiles.",
    "Funerary contexts should be more anatomically balanced; carnivore/geological transport should lose small, fragile, axial, or low-density elements; cannibalism may show selective absence or overrepresentation of processed parts.",
    "This is the strongest direct taphonomic hypothesis because accumulation cause is directly linked to skeletal survival, transport, human handling, and carnivore behavior.",

    "E02",
    "karstic_system_open_air_site",
    list(c("karstic_system", "open_air_site")),
    list(character(0)),
    "Depositional environment filters the skeleton before excavation.",
    "Cave interiors may preserve more small elements; cave entrances and rockshelters may show disturbance or carnivore activity; fluvial/open-air contexts may preferentially preserve dense or large elements.",
    "This tests whether site formation, rather than species or culture, explains skeletal-part differences.",

    "E03",
    "funerary_context_cultural_period",
    list(c("funerary_context", "cultural_period")),
    list(c("degree_of_excavation", "discovery_context")),
    "Mortuary practice changes skeletal completeness and element selection through time.",
    "Single inhumations should approach complete skeletons; collective burials may overrepresent crania, long bones, or curated elements; non-inhumation contexts may be more fragmentary.",
    "This separates intentional mortuary behavior from preservation and recovery loss.",

    "E04",
    "age_category",
    list(c("age_category")),
    list(c("mni", "degree_of_excavation")),
    "Age affects preservation because infant and juvenile bones are smaller, less fused, and more fragile.",
    "Infants and juveniles should show lower representation of small unfused bones, axial elements, ribs, vertebrae, hands, feet, and pelvis.",
    "This is a biological/taphonomic control that should be tested before interpreting cultural or species differences.",

    "E05",
    "geological_period_mis_date",
    list(c("geological_period", "date_bin")),
    list(c("mis_stage", "karstic_system", "open_air_site", "taphonomic_context")),
    "Older assemblages are more altered by long-term attrition and recovery bias.",
    "Earlier Pleistocene contexts may show stronger loss of fragile elements and more dominance of durable cranial, dental, shaft, or dense long-bone remains.",
    "This tests time-depth and preservation intensity, while retaining depositional and contextual covariates for PERMANOVA.",

    "E06",
    "hominin_species_controlled",
    list(c("hominin_species")),
    list(c("geological_period", "date_bin", "taphonomic_context", "karstic_system", "open_air_site")),
    "Species-level differences may reflect different depositional histories rather than species anatomy alone.",
    "Species may differ descriptively, but many differences may weaken after controlling for period, site type, and taphonomic context.",
    "This is interpretively interesting but risky; the script reports both group effects and PERMANOVA with covariates.",

    "E07",
    "region_country",
    list(c("region")),
    list(c("country", "karstic_system", "degree_of_excavation")),
    "Regional research history, geology, climate, and excavation tradition affect recovery.",
    "Some regions may have more complete profiles because of cave preservation or modern excavation, whereas others may be biased toward diagnostic cranial or dental material.",
    "This is a bias-detection analysis rather than a strong behavioral model.",

    "E08",
    "degree_of_excavation_discovery_context",
    list(c("degree_of_excavation", "discovery_context")),
    list(c("count_type")),
    "Recovery method affects what bones enter the dataset.",
    "Formal and complete excavations should recover more small bones; quarry, casual, and partial discoveries should overrepresent large, visible, diagnostic elements.",
    "This is essential as a recovery-bias control because it can explain patterns that otherwise look biological, cultural, or taphonomic."
  )
}

# -----------------------------
# Data preparation
# -----------------------------
.skel_prepare_tb <- function(tb) {
  tb <- as.data.frame(tb)

  if (!"site_name" %in% names(tb)) {
    tb$site_name <- paste0("row_", seq_len(nrow(tb)))
  }

  if ("start_date_cal_bp" %in% names(tb)) {
    tb$start_date_cal_bp_num <- suppressWarnings(as.numeric(tb$start_date_cal_bp))
  } else {
    tb$start_date_cal_bp_num <- NA_real_
  }

  tb$date_bin <- dplyr::case_when(
    is.na(tb$start_date_cal_bp_num) ~ "missing_date",
    tb$start_date_cal_bp_num < 11700 ~ "Holocene_or_recent",
    tb$start_date_cal_bp_num < 126000 ~ "Late_Pleistocene",
    tb$start_date_cal_bp_num < 781000 ~ "Middle_Pleistocene",
    TRUE ~ "Early_Pleistocene_or_older"
  )

  tibble::as_tibble(tb)
}

.skel_make_grouped_df <- function(df,
                                  group_vars,
                                  feature_cols,
                                  covariates = character(0),
                                  min_group_n = 5,
                                  small_groups = c("other", "drop"),
                                  missing_policy = c("keep", "drop")) {
  small_groups <- match.arg(small_groups)
  missing_policy <- match.arg(missing_policy)

  group_vars <- intersect(group_vars, names(df))

  if (length(group_vars) == 0) {
    stop("None of the requested grouping variables exist in tb.", call. = FALSE)
  }

  out <- df

  for (v in group_vars) {
    out[[v]] <- as.character(out[[v]])
    out[[v]][is.na(out[[v]]) | stringr::str_trim(out[[v]]) == ""] <- "missing"
  }

  if (missing_policy == "drop") {
    out <- out |>
      dplyr::filter(dplyr::if_all(dplyr::all_of(group_vars), ~ .x != "missing"))
  }

  if (length(group_vars) == 1) {
    out <- out |>
      dplyr::mutate(group = .data[[group_vars[1]]])
  } else {
    out <- out |>
      tidyr::unite(
        col = "group",
        dplyr::all_of(group_vars),
        sep = " | ",
        remove = FALSE,
        na.rm = FALSE
      )
  }

  group_counts <- table(out$group)
  large_groups <- names(group_counts[group_counts >= min_group_n])

  if (small_groups == "drop") {
    out <- out |>
      dplyr::filter(group %in% large_groups)
  } else {
    out <- out |>
      dplyr::mutate(group = dplyr::if_else(group %in% large_groups, group, "Other_small_groups"))
  }

  out <- out |>
    dplyr::filter(!is.na(group), group != "") |>
    dplyr::mutate(group = factor(group)) |>
    droplevels()

  available_features <- intersect(feature_cols, names(out))

  keep_cols <- c(
    "site_id", "site_name", "ind_name", "individual_id",
    "group", group_vars, covariates,
    "taphonomic_context", "funerary_context", "geological_period",
    "cultural_period", "culture_period_2", "mis_stage", "date_bin",
    "karstic_system", "karstic_system_2",
    "open_air_site", "open_air_site_2",
    "region", "country", "age_category", "gender",
    "hominin_species", "degree_of_excavation",
    "discovery_context", "count_type", "mni", "sum_count",
    available_features
  )

  out |>
    dplyr::select(dplyr::any_of(unique(keep_cols)))
}

# -----------------------------
# Descriptives and tests
# -----------------------------
.skel_run_descriptives <- function(df, feature_cols) {
  purrr::map_dfr(feature_cols, function(f) {
    if (!f %in% names(df)) return(tibble::tibble())

    dat <- df |>
      dplyr::transmute(
        group = as.character(group),
        value = .skel_numeric_clean(.data[[f]])
      ) |>
      dplyr::filter(!is.na(group), is.finite(value))

    if (nrow(dat) == 0) return(tibble::tibble())

    dat |>
      dplyr::group_by(group) |>
      dplyr::summarise(
        feature = f,
        n = dplyr::n(),
        median = median(value, na.rm = TRUE),
        q1 = stats::quantile(value, 0.25, na.rm = TRUE),
        q3 = stats::quantile(value, 0.75, na.rm = TRUE),
        iqr = stats::IQR(value, na.rm = TRUE),
        mean = mean(value, na.rm = TRUE),
        sd = stats::sd(value, na.rm = TRUE),
        min = min(value, na.rm = TRUE),
        max = max(value, na.rm = TRUE),
        .groups = "drop"
      ) |>
      dplyr::select(feature, group, dplyr::everything())
  })
}

.skel_run_assumption_checks <- function(df, feature_cols) {
  shapiro_tbl <- purrr::map_dfr(feature_cols, function(f) {
    if (!f %in% names(df)) return(tibble::tibble())

    dat <- df |>
      dplyr::transmute(
        group = as.character(group),
        value = .skel_numeric_clean(.data[[f]])
      ) |>
      dplyr::filter(!is.na(group), is.finite(value))

    dat |>
      dplyr::group_by(group) |>
      dplyr::summarise(
        feature = f,
        n = dplyr::n(),
        shapiro_p = ifelse(
          dplyr::n() >= 3 && dplyr::n() <= 5000 && length(unique(value)) > 2,
          stats::shapiro.test(value)$p.value,
          NA_real_
        ),
        .groups = "drop"
      ) |>
      dplyr::select(feature, group, n, shapiro_p)
  })

  levene_tbl <- purrr::map_dfr(feature_cols, function(f) {
    if (!f %in% names(df)) return(tibble::tibble())

    dat <- df |>
      dplyr::transmute(
        group = factor(group),
        value = .skel_numeric_clean(.data[[f]])
      ) |>
      dplyr::filter(!is.na(group), is.finite(value)) |>
      droplevels()

    if (dplyr::n_distinct(dat$group) < 2 || nrow(dat) < 6) {
      return(tibble::tibble(feature = f, levene_p = NA_real_))
    }

    tryCatch(
      {
        lv <- rstatix::levene_test(dat, value ~ group, center = median)
        tibble::tibble(feature = f, levene_p = lv$p[1])
      },
      error = function(e) tibble::tibble(feature = f, levene_p = NA_real_)
    )
  })

  list(shapiro = shapiro_tbl, levene = levene_tbl)
}

.skel_run_kw_fdr <- function(df, feature_cols) {
  kw <- purrr::map_dfr(feature_cols, function(f) {
    if (!f %in% names(df)) return(tibble::tibble())

    dat <- df |>
      dplyr::transmute(
        group = factor(group),
        value = .skel_numeric_clean(.data[[f]])
      ) |>
      dplyr::filter(!is.na(group), is.finite(value)) |>
      droplevels()

    n_groups <- dplyr::n_distinct(dat$group)

    if (nrow(dat) < 6 || n_groups < 2 || length(unique(dat$value)) < 2) {
      return(tibble::tibble(
        feature = f,
        n = nrow(dat),
        n_groups = n_groups,
        H = NA_real_,
        df = NA_real_,
        p = NA_real_,
        eps2 = NA_real_
      ))
    }

    kt <- stats::kruskal.test(value ~ group, data = dat)

    tibble::tibble(
      feature = f,
      n = nrow(dat),
      n_groups = n_groups,
      H = as.numeric(kt$statistic),
      df = as.numeric(kt$parameter),
      p = kt$p.value,
      eps2 = .skel_epsilon_squared_kw(as.numeric(kt$statistic), nrow(dat))
    )
  })

  kw |>
    dplyr::mutate(
      p_fdr = stats::p.adjust(p, method = "BH"),
      significant_fdr_05 = !is.na(p_fdr) & p_fdr < 0.05,
      effect = .skel_effect_label(eps2)
    ) |>
    dplyr::arrange(dplyr::desc(significant_fdr_05), dplyr::desc(eps2), p_fdr)
}

.skel_run_dunn_posthoc <- function(df, kw_tbl) {
  sig_features <- kw_tbl |>
    dplyr::filter(significant_fdr_05) |>
    dplyr::pull(feature)

  if (length(sig_features) == 0) return(tibble::tibble())

  purrr::map_dfr(sig_features, function(f) {
    dat <- df |>
      dplyr::transmute(
        group = factor(group),
        value = .skel_numeric_clean(.data[[f]])
      ) |>
      dplyr::filter(!is.na(group), is.finite(value)) |>
      droplevels()

    if (dplyr::n_distinct(dat$group) < 2) return(tibble::tibble())

    tryCatch(
      {
        rstatix::dunn_test(dat, value ~ group, p.adjust.method = "BH") |>
          dplyr::mutate(feature = f, .before = 1)
      },
      error = function(e) {
        tibble::tibble(feature = f, error = conditionMessage(e))
      }
    )
  })
}

# -----------------------------
# Multivariate analysis
# -----------------------------
.skel_clean_feature_matrix <- function(df,
                                       features,
                                       min_nonmissing = 5,
                                       median_impute = TRUE) {
  features <- intersect(features, names(df))
  features <- setdiff(features, .skel_bad_multivariate_features())

  if (length(features) < 3) {
    stop("Fewer than 3 usable features available for multivariate analysis.", call. = FALSE)
  }

  x <- df[, features, drop = FALSE]
  x <- as.data.frame(lapply(x, .skel_numeric_clean))

  for (f in intersect(.skel_log1p_multivariate_features(), names(x))) {
    x[[f]] <- log1p(x[[f]])
  }

  keep <- names(x)[vapply(x, function(v) {
    sum(!is.na(v)) >= min_nonmissing &&
      is.finite(stats::sd(v, na.rm = TRUE)) &&
      stats::sd(v, na.rm = TRUE) > 0
  }, logical(1))]

  x <- x[, keep, drop = FALSE]

  if (ncol(x) < 3) {
    stop("Fewer than 3 non-zero-variance features after cleaning.", call. = FALSE)
  }

  if (isTRUE(median_impute)) {
    for (f in names(x)) {
      med <- stats::median(x[[f]], na.rm = TRUE)
      x[[f]][is.na(x[[f]])] <- med
    }
  }

  mat <- scale(x)

  list(mat = mat, features = colnames(mat))
}

.skel_run_permanova <- function(df,
                                features,
                                covariates = character(0),
                                permutations = 9999) {
  features <- intersect(features, names(df))
  features <- setdiff(features, .skel_bad_multivariate_features())

  if (length(features) < 3 || dplyr::n_distinct(df$group) < 2) {
    return(tibble::tibble(
      term = NA_character_, df = NA_real_, sumsq = NA_real_, R2 = NA_real_,
      F = NA_real_, p = NA_real_, note = "Skipped: insufficient features or groups."
    ))
  }

  clean <- .skel_clean_feature_matrix(df, features)
  Y <- clean$mat

  meta <- df |>
    dplyr::mutate(group = factor(group))

  covariates <- intersect(covariates, names(meta))

  usable_covariates <- covariates[vapply(covariates, function(v) {
    length(unique(stats::na.omit(as.character(meta[[v]])))) >= 2
  }, logical(1))]

  for (v in usable_covariates) {
    if (is.numeric(meta[[v]])) {
      meta[[v]][!is.finite(meta[[v]])] <- NA_real_
      med <- stats::median(meta[[v]], na.rm = TRUE)
      if (!is.finite(med)) med <- 0
      meta[[v]][is.na(meta[[v]])] <- med
    } else {
      meta[[v]] <- as.character(meta[[v]])
      meta[[v]][is.na(meta[[v]]) | stringr::str_trim(meta[[v]]) == ""] <- "missing"
      meta[[v]] <- factor(meta[[v]])
    }
  }

  formula_terms <- c("group", usable_covariates)
  form <- stats::as.formula(paste("Y ~", paste(formula_terms, collapse = " + ")))

  tryCatch(
    {
      ad <- vegan::adonis2(
        formula = form,
        data = meta,
        method = "euclidean",
        permutations = permutations,
        by = "margin"
      )

      as.data.frame(ad) |>
        tibble::rownames_to_column("term") |>
        tibble::as_tibble() |>
        dplyr::rename(
          df = Df,
          sumsq = SumOfSqs,
          R2 = R2,
          F = F,
          p = `Pr(>F)`
        ) |>
        dplyr::mutate(note = NA_character_)
    },
    error = function(e) {
      tibble::tibble(
        term = NA_character_, df = NA_real_, sumsq = NA_real_, R2 = NA_real_,
        F = NA_real_, p = NA_real_, note = paste("PERMANOVA failed:", conditionMessage(e))
      )
    }
  )
}

.skel_run_pca <- function(df, features) {
  clean <- .skel_clean_feature_matrix(df, features)
  pca <- stats::prcomp(clean$mat, center = FALSE, scale. = FALSE)

  n_pc <- min(3, ncol(pca$x))
  if (n_pc < 3) {
    stop("PCA produced fewer than 3 components.", call. = FALSE)
  }

  scores <- as.data.frame(pca$x[, 1:3, drop = FALSE]) |>
    dplyr::bind_cols(df |> dplyr::select(dplyr::any_of(c("site_name", "site_id", "group"))), .)

  variance_values <- (pca$sdev^2 / sum(pca$sdev^2)) * 100

  var_tbl <- tibble::tibble(
    PC = paste0("PC", seq_along(pca$sdev)),
    variance_percent = variance_values,
    cumulative_percent = cumsum(variance_values)
  )

  loadings <- as.data.frame(pca$rotation[, 1:min(5, ncol(pca$rotation)), drop = FALSE]) |>
    tibble::rownames_to_column("feature") |>
    tibble::as_tibble()

  list(
    pca = pca,
    scores = scores,
    variance = var_tbl,
    loadings = loadings,
    features = clean$features
  )
}

# -----------------------------
# Composite axes and plots
# -----------------------------
.skel_row_mean_z <- function(df, cols) {
  cols <- intersect(cols, names(df))

  if (length(cols) == 0) {
    return(rep(NA_real_, nrow(df)))
  }

  x <- as.data.frame(lapply(df[, cols, drop = FALSE], .skel_numeric_clean))

  z <- as.data.frame(lapply(x, function(v) {
    s <- stats::sd(v, na.rm = TRUE)
    m <- mean(v, na.rm = TRUE)

    if (!is.finite(s) || s == 0) {
      return(rep(NA_real_, length(v)))
    }

    (v - m) / s
  }))

  out <- rowMeans(z, na.rm = TRUE)
  out[is.nan(out)] <- NA_real_
  out
}

.skel_make_composite_df <- function(df) {
  comp <- df

  comp$completeness_axis <- .skel_row_mean_z(comp, c(
    "mnau_postcranial_total_mean",
    "mnau_column_trunk_mean",
    "mnau_appendicular_mean",
    "mnau_upper_appendicular_mean",
    "mnau_lower_appendicular_mean",
    "mnau_girdle_mean",
    "mnau_distal_appendicular_mean",
    "mnau_proximal_appendicular_mean",
    "mnau_foot",
    "mnau_hands",
    "mnau_arms",
    "mnau_legs",
    "mnau_shoulder",
    "mnau_pelvic"
  ))

  comp$density_fragility_axis <- .skel_row_mean_z(comp, c(
    "low_density_survival_index",
    "low_density_share",
    "low_density_axial_survival",
    "density_evenness",
    "density_adjusted_appendicular_axial_contrast"
  ))

  comp$dominance_evenness_axis <- .skel_row_mean_z(comp, c(
    "all_sections_dominance",
    "appendicular_dominance",
    "appendicular_dominance_refined",
    "postcranial_dominance_refined",
    "dominance_gap_all",
    "mnau_top2_share_mcnaughton",
    "mnau_simpson_dominance",
    "mnau_gini",
    "mnau_dominance_of_region_means",
    "mnau_evenness_minus_dominance",
    "effective_sections_hill1",
    "mnau_heip_evenness",
    "mnau_region_mean_evenness",
    "mnau_simpson_evenness",
    "mnau_inverse_simpson"
  ))

  tibble::as_tibble(comp)
}

.skel_plot_3d_features <- function(df, x, y, z, title) {
  d <- df |>
    dplyr::mutate(
      xval = .skel_numeric_clean(.data[[x]]),
      yval = .skel_numeric_clean(.data[[y]]),
      zval = .skel_numeric_clean(.data[[z]])
    ) |>
    dplyr::filter(is.finite(xval), is.finite(yval), is.finite(zval))

  if (nrow(d) == 0) {
    stop("No complete rows for 3D feature plot.", call. = FALSE)
  }

  plotly::plot_ly(
    data = d,
    x = ~xval,
    y = ~yval,
    z = ~zval,
    color = ~group,
    type = "scatter3d",
    mode = "markers+text",
    text = ~site_name,
    textposition = "top center",
    marker = list(size = 6, opacity = 0.85),
    hoverinfo = "text",
    hovertext = ~paste0(
      "<b>", site_name, "</b>",
      "<br>Group: ", group,
      "<br>", x, ": ", round(xval, 4),
      "<br>", y, ": ", round(yval, 4),
      "<br>", z, ": ", round(zval, 4)
    )
  ) |>
    plotly::layout(
      title = title,
      legend = list(title = list(text = "Grouping")),
      scene = list(
        xaxis = list(title = x),
        yaxis = list(title = y),
        zaxis = list(title = z)
      )
    )
}

.skel_plot_best_3_features <- function(df, kw_tbl) {
  top3 <- kw_tbl |>
    dplyr::filter(!feature %in% .skel_bad_multivariate_features()) |>
    dplyr::filter(!is.na(eps2)) |>
    dplyr::arrange(dplyr::desc(significant_fdr_05), dplyr::desc(eps2), p_fdr) |>
    dplyr::slice_head(n = 3) |>
    dplyr::pull(feature)

  if (length(top3) < 3) {
    stop("Fewer than 3 usable top features.", call. = FALSE)
  }

  .skel_plot_3d_features(
    df,
    x = top3[1],
    y = top3[2],
    z = top3[3],
    title = paste0("Best 3 differential features: ", paste(top3, collapse = " / "))
  )
}

.skel_plot_composites_3d <- function(df) {
  comp_df <- .skel_make_composite_df(df)

  .skel_plot_3d_features(
    comp_df,
    x = "completeness_axis",
    y = "density_fragility_axis",
    z = "dominance_evenness_axis",
    title = "Composite 3D plot: completeness / density-fragility / dominance-evenness"
  )
}

.skel_plot_pca_3d <- function(pca_obj) {
  scores <- pca_obj$scores
  var <- pca_obj$variance

  plotly::plot_ly(
    data = scores,
    x = ~PC1,
    y = ~PC2,
    z = ~PC3,
    color = ~group,
    type = "scatter3d",
    mode = "markers+text",
    text = ~site_name,
    textposition = "top center",
    marker = list(size = 6, opacity = 0.85),
    hoverinfo = "text",
    hovertext = ~paste0(
      "<b>", site_name, "</b>",
      "<br>Group: ", group,
      "<br>PC1: ", round(PC1, 3),
      "<br>PC2: ", round(PC2, 3),
      "<br>PC3: ", round(PC3, 3)
    )
  ) |>
    plotly::layout(
      title = "3D PCA of selected skeletal-representation features",
      scene = list(
        xaxis = list(title = paste0("PC1 (", round(var$variance_percent[1], 1), "%)")),
        yaxis = list(title = paste0("PC2 (", round(var$variance_percent[2], 1), "%)")),
        zaxis = list(title = paste0("PC3 (", round(var$variance_percent[3], 1), "%)"))
      )
    )
}

# -----------------------------
# One experiment
# -----------------------------
.skel_analyse_one_experiment <- function(tb_analysis,
                                         experiment_row,
                                         feature_cols,
                                         min_group_n = 5,
                                         small_groups = "other",
                                         permutations = 9999) {
  exp_id <- .skel_exp_scalar(experiment_row, "experiment_id")
  exp_name <- .skel_exp_scalar(experiment_row, "experiment_name")
  group_vars <- .skel_exp_vec(experiment_row, "group_vars")
  covariates <- .skel_exp_vec(experiment_row, "covariates")

  message("\nRunning ", exp_id, " - ", exp_name)

  grouped_df <- .skel_make_grouped_df(
    tb_analysis,
    group_vars = group_vars,
    feature_cols = feature_cols,
    covariates = covariates,
    min_group_n = min_group_n,
    small_groups = small_groups,
    missing_policy = "keep"
  )

  if (dplyr::n_distinct(grouped_df$group) < 2) {
    stop("Experiment ", exp_id, " has fewer than two usable groups.", call. = FALSE)
  }

  group_sizes <- grouped_df |>
    dplyr::count(group, sort = TRUE, name = "n_records")

  descriptives <- .skel_run_descriptives(grouped_df, feature_cols)
  assumptions <- .skel_run_assumption_checks(grouped_df, feature_cols)
  kw_tbl <- .skel_run_kw_fdr(grouped_df, feature_cols)
  dunn_tbl <- .skel_run_dunn_posthoc(grouped_df, kw_tbl)

  pca_feature_set <- kw_tbl |>
    dplyr::filter(!feature %in% .skel_bad_multivariate_features()) |>
    dplyr::filter(!is.na(eps2)) |>
    dplyr::arrange(dplyr::desc(significant_fdr_05), dplyr::desc(eps2), p_fdr) |>
    dplyr::slice_head(n = min(30, dplyr::n())) |>
    dplyr::pull(feature)

  if (length(pca_feature_set) < 3) {
    pca_feature_set <- setdiff(feature_cols, .skel_bad_multivariate_features())
  }

  permanova_tbl <- .skel_run_permanova(
    grouped_df,
    features = pca_feature_set,
    covariates = covariates,
    permutations = permutations
  )

  pca_obj <- .skel_run_pca(grouped_df, pca_feature_set)

  plots <- list(
    best_features_3d = tryCatch(.skel_plot_best_3_features(grouped_df, kw_tbl), error = function(e) e),
    composite_3d = tryCatch(.skel_plot_composites_3d(grouped_df), error = function(e) e),
    pca_3d = tryCatch(.skel_plot_pca_3d(pca_obj), error = function(e) e)
  )

  top_features <- kw_tbl |>
    dplyr::filter(!is.na(eps2)) |>
    dplyr::arrange(dplyr::desc(significant_fdr_05), dplyr::desc(eps2), p_fdr) |>
    dplyr::slice_head(n = 10)

  group_r2 <- permanova_tbl |>
    dplyr::filter(term == "group") |>
    dplyr::pull(R2)

  group_p <- permanova_tbl |>
    dplyr::filter(term == "group") |>
    dplyr::pull(p)

  summary_tbl <- tibble::tibble(
    experiment_id = exp_id,
    experiment_name = exp_name,
    group_vars = paste(group_vars, collapse = " + "),
    covariates = paste(covariates, collapse = " + "),
    n_records = nrow(grouped_df),
    n_groups = dplyr::n_distinct(grouped_df$group),
    n_features_tested = nrow(kw_tbl),
    n_fdr_significant = sum(kw_tbl$significant_fdr_05, na.rm = TRUE),
    max_eps2 = ifelse(all(is.na(kw_tbl$eps2)), NA_real_, max(kw_tbl$eps2, na.rm = TRUE)),
    top_feature = ifelse(nrow(top_features) > 0, top_features$feature[1], NA_character_),
    top_feature_eps2 = ifelse(nrow(top_features) > 0, top_features$eps2[1], NA_real_),
    top_feature_p_fdr = ifelse(nrow(top_features) > 0, top_features$p_fdr[1], NA_real_),
    permanova_group_R2 = ifelse(length(group_r2) > 0, group_r2[1], NA_real_),
    permanova_group_p = ifelse(length(group_p) > 0, group_p[1], NA_real_)
  )

  list(
    experiment = experiment_row,
    grouped_data = grouped_df,
    group_sizes = group_sizes,
    descriptives = descriptives,
    assumptions = assumptions,
    kw = kw_tbl,
    dunn = dunn_tbl,
    permanova = permanova_tbl,
    pca = pca_obj,
    plots = plots,
    top_features = top_features,
    summary = summary_tbl
  )
}

# -----------------------------
# Saving output
# -----------------------------
.skel_save_one_experiment <- function(res, output_root) {
  exp_id <- .skel_exp_scalar(res$experiment, "experiment_id")
  exp_name <- .skel_exp_scalar(res$experiment, "experiment_name")
  exp_slug <- paste0(exp_id, "_", .skel_safe_slug(exp_name))

  exp_dir <- file.path(output_root, exp_slug)
  plot_dir <- file.path(exp_dir, "plots")

  dir.create(exp_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)

  readr::write_csv(res$group_sizes, file.path(exp_dir, "01_group_sizes.csv"))
  readr::write_csv(res$descriptives, file.path(exp_dir, "02_group_descriptives.csv"))
  readr::write_csv(res$assumptions$shapiro, file.path(exp_dir, "03_shapiro_by_group.csv"))
  readr::write_csv(res$assumptions$levene, file.path(exp_dir, "04_levene_by_feature.csv"))
  readr::write_csv(res$kw, file.path(exp_dir, "05_kruskal_wallis_fdr.csv"))
  readr::write_csv(res$dunn, file.path(exp_dir, "06_dunn_posthoc.csv"))
  readr::write_csv(res$permanova, file.path(exp_dir, "07_permanova.csv"))
  readr::write_csv(res$pca$variance, file.path(exp_dir, "08_pca_variance.csv"))
  readr::write_csv(res$pca$loadings, file.path(exp_dir, "09_pca_loadings.csv"))
  readr::write_csv(res$pca$scores, file.path(exp_dir, "10_pca_scores.csv"))
  readr::write_csv(res$top_features, file.path(exp_dir, "11_top_10_features.csv"))
  readr::write_csv(res$summary, file.path(exp_dir, "12_experiment_summary.csv"))

  saveRDS(res, file.path(exp_dir, "experiment_object.rds"))

  plot_files <- list(
    best_features_3d = file.path(plot_dir, "01_best_features_3d.html"),
    composite_3d = file.path(plot_dir, "02_composite_3d.html"),
    pca_3d = file.path(plot_dir, "03_pca_3d.html")
  )

  plot_errors <- tibble::tibble(plot = character(), error = character())

  for (nm in names(plot_files)) {
    p <- res$plots[[nm]]

    if (inherits(p, "error")) {
      plot_errors <- dplyr::bind_rows(
        plot_errors,
        tibble::tibble(plot = nm, error = conditionMessage(p))
      )
    } else {
      htmlwidgets::saveWidget(
        p,
        file = plot_files[[nm]],
        selfcontained = FALSE
      )
    }
  }

  readr::write_csv(plot_errors, file.path(exp_dir, "plot_errors.csv"))

  summary_md <- c(
    paste0("# ", exp_id, " - ", exp_name),
    "",
    paste0("Hypothesis: ", res$experiment$hypothesis),
    "",
    paste0("Expected pattern: ", res$experiment$expected_pattern),
    "",
    paste0("Why interesting: ", res$experiment$why_interesting),
    "",
    "## Grouping",
    "",
    paste0("Group variables: ", paste(.skel_exp_vec(res$experiment, "group_vars"), collapse = " + ")),
    "",
    paste0("Covariates for PERMANOVA: ", paste(.skel_exp_vec(res$experiment, "covariates"), collapse = " + ")),
    "",
    "## Summary",
    "",
    capture.output(knitr::kable(res$summary, format = "pipe")),
    "",
    "## Group sizes",
    "",
    capture.output(knitr::kable(res$group_sizes, format = "pipe")),
    "",
    "## Top 10 features",
    "",
    capture.output(knitr::kable(res$top_features, format = "pipe")),
    "",
    "## PERMANOVA",
    "",
    capture.output(knitr::kable(res$permanova, format = "pipe"))
  )

  writeLines(summary_md, file.path(exp_dir, "experiment_summary.md"))

  invisible(list(exp_dir = exp_dir, plot_files = plot_files, plot_errors = plot_errors))
}

.skel_iframe_or_note <- function(src, title, output_root) {
  full <- file.path(output_root, src)

  if (!file.exists(full)) {
    return(htmltools::tags$div(
      htmltools::tags$h4(title),
      htmltools::tags$p(paste("Plot not available:", src))
    ))
  }

  htmltools::tags$div(
    htmltools::tags$h4(title),
    htmltools::tags$iframe(
      src = src,
      width = "100%",
      height = "650",
      style = "border: 1px solid #CCCCCC;"
    )
  )
}

.skel_write_master_report <- function(results, output_root) {
  summary_all <- dplyr::bind_rows(lapply(results, `[[`, "summary")) |>
    dplyr::arrange(permanova_group_p, dplyr::desc(n_fdr_significant), dplyr::desc(max_eps2))

  readr::write_csv(summary_all, file.path(output_root, "ALL_experiment_summary.csv"))

  experiment_sections <- purrr::map(results, function(res) {
    exp_id <- .skel_exp_scalar(res$experiment, "experiment_id")
    exp_name <- .skel_exp_scalar(res$experiment, "experiment_name")
    exp_slug <- paste0(exp_id, "_", .skel_safe_slug(exp_name))

    best_plot <- file.path(exp_slug, "plots", "01_best_features_3d.html")
    comp_plot <- file.path(exp_slug, "plots", "02_composite_3d.html")
    pca_plot <- file.path(exp_slug, "plots", "03_pca_3d.html")

    htmltools::tags$section(
      htmltools::tags$hr(),
      htmltools::tags$h2(paste0(exp_id, " - ", exp_name)),

      htmltools::tags$h3("Hypothesis"),
      htmltools::tags$p(res$experiment$hypothesis),

      htmltools::tags$h3("Expected pattern"),
      htmltools::tags$p(res$experiment$expected_pattern),

      htmltools::tags$h3("Why this experiment matters"),
      htmltools::tags$p(res$experiment$why_interesting),

      htmltools::tags$h3("Experiment summary"),
      htmltools::HTML(knitr::kable(res$summary, format = "html", table.attr = "border='1'")),

      htmltools::tags$h3("Group sizes"),
      htmltools::HTML(knitr::kable(res$group_sizes, format = "html", table.attr = "border='1'")),

      htmltools::tags$h3("Top 10 differential features"),
      htmltools::HTML(knitr::kable(res$top_features, format = "html", table.attr = "border='1'")),

      htmltools::tags$h3("PERMANOVA"),
      htmltools::HTML(knitr::kable(res$permanova, format = "html", table.attr = "border='1'")),

      htmltools::tags$h3("Plots"),
      .skel_iframe_or_note(best_plot, "1. Best three differential features, 3D Plotly", output_root),
      .skel_iframe_or_note(comp_plot, "2. Composite mean axes, 3D Plotly", output_root),
      .skel_iframe_or_note(pca_plot, "3. PCA scores, 3D Plotly", output_root),

      htmltools::tags$p(htmltools::tags$b("Full tables saved in: "), exp_slug)
    )
  })

  report <- htmltools::tags$html(
    htmltools::tags$head(
      htmltools::tags$title("Skeletal Representation Metadata Experiments"),
      htmltools::tags$style(htmltools::HTML("
        body {
          font-family: Arial, sans-serif;
          margin: 32px;
          line-height: 1.45;
        }
        table {
          border-collapse: collapse;
          font-size: 12px;
          margin-bottom: 24px;
        }
        th, td {
          padding: 5px 8px;
          border: 1px solid #BBBBBB;
        }
        h1, h2, h3 {
          color: #1f4e5f;
        }
        iframe {
          margin-bottom: 28px;
        }
      "))
    ),
    htmltools::tags$body(
      htmltools::tags$h1("Automated skeletal-representation metadata experiments"),
      htmltools::tags$p("This report runs eight hypothesis-driven metadata experiments using the 63 selected skeletal-representation features."),
      htmltools::tags$p("For each experiment, the workflow saves group sizes, descriptives, assumption checks, Kruskal-Wallis tests, BH-FDR adjusted p-values, epsilon-squared effect sizes, Dunn post-hoc tests, PERMANOVA, PCA variance/loadings/scores, and three interactive Plotly plots."),
      htmltools::tags$h2("Master summary"),
      htmltools::HTML(knitr::kable(summary_all, format = "html", table.attr = "border='1'")),
      experiment_sections
    )
  )

  htmltools::save_html(report, file.path(output_root, "MASTER_REPORT.html"))

  invisible(summary_all)
}

.skel_empty_failed_result <- function(exp_row, error_message) {
  list(
    experiment = exp_row,
    grouped_data = tibble::tibble(),
    group_sizes = tibble::tibble(),
    descriptives = tibble::tibble(),
    assumptions = list(shapiro = tibble::tibble(), levene = tibble::tibble()),
    kw = tibble::tibble(),
    dunn = tibble::tibble(),
    permanova = tibble::tibble(
      term = NA_character_, df = NA_real_, sumsq = NA_real_, R2 = NA_real_,
      F = NA_real_, p = NA_real_, note = error_message
    ),
    pca = list(scores = tibble::tibble(), variance = tibble::tibble(), loadings = tibble::tibble()),
    plots = list(
      best_features_3d = simpleError(error_message),
      composite_3d = simpleError(error_message),
      pca_3d = simpleError(error_message)
    ),
    top_features = tibble::tibble(),
    summary = tibble::tibble(
      experiment_id = .skel_exp_scalar(exp_row, "experiment_id"),
      experiment_name = .skel_exp_scalar(exp_row, "experiment_name"),
      group_vars = paste(.skel_exp_vec(exp_row, "group_vars"), collapse = " + "),
      covariates = paste(.skel_exp_vec(exp_row, "covariates"), collapse = " + "),
      n_records = NA_integer_,
      n_groups = NA_integer_,
      n_features_tested = NA_integer_,
      n_fdr_significant = NA_integer_,
      max_eps2 = NA_real_,
      top_feature = NA_character_,
      top_feature_eps2 = NA_real_,
      top_feature_p_fdr = NA_real_,
      permanova_group_R2 = NA_real_,
      permanova_group_p = NA_real_
    )
  )
}

# ============================================================
# Public function
# ============================================================
run_skeletal_metadata_experiments <- function(tb,
                                              output_root = NULL,
                                              min_group_n = 5,
                                              small_groups = c("other", "drop"),
                                              permutations = 9999,
                                              install_missing = FALSE,
                                              seed = 20260618,
                                              open_report = FALSE) {
  small_groups <- match.arg(small_groups)
  .skel_load_packages(install_missing = install_missing)
  set.seed(seed)

  tb_analysis <- .skel_prepare_tb(tb)

  important_features <- .skel_important_features_63()
  feature_cols <- intersect(important_features, names(tb_analysis))
  missing_features <- setdiff(important_features, names(tb_analysis))

  if (length(feature_cols) < 3) {
    stop("Fewer than 3 of the 63 important features were found in tb.", call. = FALSE)
  }

  if (is.null(output_root)) {
    run_stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    output_root <- file.path(getwd(), paste0("skeletal_metadata_experiments_", run_stamp))
  }

  dir.create(output_root, recursive = TRUE, showWarnings = FALSE)

  writeLines(missing_features, file.path(output_root, "missing_requested_features.txt"))

  experiments <- .skel_default_experiments()

  feature_manifest <- tibble::tibble(
    feature = important_features,
    found_in_tb = important_features %in% names(tb_analysis),
    used_in_univariate = important_features %in% feature_cols,
    excluded_from_multivariate = important_features %in% .skel_bad_multivariate_features(),
    log1p_before_multivariate_scaling = important_features %in% .skel_log1p_multivariate_features()
  )

  readr::write_csv(feature_manifest, file.path(output_root, "FEATURE_MANIFEST.csv"))

  message("Features requested: ", length(important_features))
  message("Features found in tb: ", length(feature_cols))
  message("Missing features: ", length(missing_features))
  message("Output folder: ", output_root)

  results <- vector("list", nrow(experiments))

  for (i in seq_len(nrow(experiments))) {
    exp_row <- experiments[i, ]

    res <- tryCatch(
      {
        .skel_analyse_one_experiment(
          tb_analysis = tb_analysis,
          experiment_row = exp_row,
          feature_cols = feature_cols,
          min_group_n = min_group_n,
          small_groups = small_groups,
          permutations = permutations
        )
      },
      error = function(e) {
        msg <- conditionMessage(e)
        message("FAILED: ", .skel_exp_scalar(exp_row, "experiment_id"), " - ", msg)
        .skel_empty_failed_result(exp_row, msg)
      }
    )

    .skel_save_one_experiment(res, output_root)
    results[[i]] <- res
  }

  names(results) <- experiments$experiment_id

  saveRDS(results, file.path(output_root, "ALL_experiment_objects.rds"))

  master_summary <- .skel_write_master_report(results, output_root)

  out <- list(
    output_root = output_root,
    master_report = file.path(output_root, "MASTER_REPORT.html"),
    master_summary = master_summary,
    feature_manifest = feature_manifest,
    experiments = experiments,
    results = results
  )

  class(out) <- c("skeletal_metadata_experiment_run", class(out))

  message("\nDone.")
  message("Master report: ", out$master_report)
  message("Master CSV: ", file.path(output_root, "ALL_experiment_summary.csv"))

  if (isTRUE(open_report) && interactive()) {
    utils::browseURL(out$master_report)
  }

  invisible(out)
}

print.skeletal_metadata_experiment_run <- function(x, ...) {
  cat("Skeletal metadata experiment run\n")
  cat("Output folder: ", x$output_root, "\n", sep = "")
  cat("Master report: ", x$master_report, "\n", sep = "")
  cat("Experiments: ", nrow(x$experiments), "\n", sep = "")
  cat("Features found: ", sum(x$feature_manifest$found_in_tb), "/", nrow(x$feature_manifest), "\n", sep = "")
  invisible(x)
}
