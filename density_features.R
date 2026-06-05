make_tapho_density_features <- function(
  element,
  One_Skeleton_count,
  Skeleton_Section,
  MNE,
  MNI_used,
  PercentMNAU = NULL,
  MNAU = NULL,
  epsilon = 1e-6,
  fragile_threshold = 0,
  teeth_density_placeholder = 0.721100,
  section_summary = c("mean", "median")
) {

  section_summary <- match.arg(section_summary)

  density_feature_names <- c(
    "density_weighted_mean_mnau",
    "density_weighted_mean_mne",
    "density_representation_spearman",
    "density_representation_slope",
    "high_density_to_low_density_ratio",
    "high_density_share",
    "low_density_share",
    "low_density_survival_index",
    "fragile_section_survival_count",
    "density_evenness",
    "density_dominance_index",
    "density_adjusted_cranial_postcranial_contrast",
    "density_adjusted_limb_trunk_contrast",
    "density_adjusted_appendicular_axial_contrast",
    "density_adjusted_distal_proximal_contrast",
    "density_corrected_marrow_proxy_contrast"
  )

  empty_density_features <- function() {
    x <- as.list(rep(NA_real_, length(density_feature_names)))
    names(x) <- density_feature_names
    tibble::as_tibble(x)
  }

  as_chr <- function(x) {
    if (is.null(x)) return(character(0))
    as.character(unlist(x, use.names = FALSE))
  }

  as_num <- function(x) {
    if (is.null(x)) return(numeric(0))
    suppressWarnings(as.numeric(unlist(x, use.names = FALSE)))
  }

  sections_order <- c(
    "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
    "arms", "hands", "pelvic", "legs", "foot"
  )

  section_density <- c(
    cranium   = 0.721100,
    teeth     = teeth_density_placeholder,
    hyoid     = 0.252500,
    vertebrae = 0.154900,
    thorax    = 0.214000,
    shoulder  = 0.190450,
    arms      = 0.576000,
    hands     = 0.489167,
    pelvic    = 0.326500,
    legs      = 0.451025,
    foot      = 0.479167
  )

  section_density <- section_density[sections_order]

  density_bins <- list(
    low  = c("vertebrae", "shoulder", "thorax", "hyoid"),
    mid  = c("pelvic", "legs", "foot"),
    high = c("hands", "arms", "cranium", "teeth")
  )

  groups <- list(
    cranial_complex       = c("cranium", "teeth", "hyoid"),
    axial_main            = c("vertebrae", "thorax"),
    full_axial            = c("cranium", "teeth", "hyoid", "vertebrae", "thorax"),
    postcranial_total     = c("vertebrae", "thorax", "shoulder", "arms", "hands", "pelvic", "legs", "foot"),
    column_trunk          = c("vertebrae", "thorax", "pelvic"),
    appendicular          = c("shoulder", "arms", "hands", "pelvic", "legs", "foot"),
    upper_appendicular    = c("shoulder", "arms", "hands"),
    lower_appendicular    = c("pelvic", "legs", "foot"),
    girdle                = c("shoulder", "pelvic"),
    limb_shaft_proxy      = c("arms", "legs"),
    distal_appendicular   = c("hands", "foot"),
    proximal_appendicular = c("shoulder", "arms", "pelvic", "legs")
  )

  sec <- as_chr(Skeleton_Section)
  mne <- as_num(MNE)
  one_count <- as_num(One_Skeleton_count)
  percent_mnau <- as_num(PercentMNAU)
  mnau <- as_num(MNAU)
  mni_vec <- as_num(MNI_used)

  n <- length(sec)

  if (n == 0 || length(mne) != n) {
    return(empty_density_features())
  }

  if (length(one_count) != n) {
    one_count <- rep(NA_real_, n)
  }

  mni <- mni_vec[is.finite(mni_vec) & mni_vec > 0][1]

  if (length(percent_mnau) == n && any(is.finite(percent_mnau))) {
    element_rep <- percent_mnau
  } else if (length(mnau) == n && any(is.finite(mnau))) {
    if (is.finite(mni) && mni > 0) {
      element_rep <- 100 * mnau / mni
    } else {
      element_rep <- mnau
    }
  } else {
    denom <- one_count

    denom[!is.finite(denom) | denom <= 0] <- NA_real_

    raw_mnau <- mne / denom

    if (is.finite(mni) && mni > 0) {
      element_rep <- 100 * raw_mnau / mni
    } else {
      raw_ok <- raw_mnau[is.finite(raw_mnau)]

      if (length(raw_ok) > 0 && max(raw_ok, na.rm = TRUE) > epsilon) {
        element_rep <- 100 * raw_mnau / max(raw_ok, na.rm = TRUE)
      } else {
        element_rep <- rep(0, n)
      }
    }
  }

  section_rep <- stats::setNames(rep(0, length(sections_order)), sections_order)
  section_mne <- stats::setNames(rep(0, length(sections_order)), sections_order)

  valid_rep <- sec %in% sections_order & is.finite(element_rep)
  valid_mne <- sec %in% sections_order & is.finite(mne)

  section_fun <- function(x) {
    x <- x[is.finite(x)]

    if (length(x) == 0) return(0)

    if (section_summary == "median") {
      stats::median(x)
    } else {
      base::mean(x)
    }
  }

  if (any(valid_rep)) {
    rep_tmp <- tapply(element_rep[valid_rep], sec[valid_rep], section_fun)
    section_rep[names(rep_tmp)] <- as.numeric(rep_tmp)
  }

  if (any(valid_mne)) {
    mne_tmp <- tapply(mne[valid_mne], sec[valid_mne], base::sum, na.rm = TRUE)
    section_mne[names(mne_tmp)] <- as.numeric(mne_tmp)
  }

  safe_weighted_density <- function(weights) {
    weights[!is.finite(weights)] <- 0
    total <- base::sum(weights, na.rm = TRUE)

    if (!is.finite(total) || total <= epsilon) {
      return(NA_real_)
    }

    base::sum(weights * section_density, na.rm = TRUE) / total
  }

  safe_share <- function(x, total) {
    if (!is.finite(total) || total <= epsilon) return(NA_real_)
    x / total
  }

  safe_mean <- function(x) {
    x <- x[is.finite(x)]
    if (length(x) == 0) return(NA_real_)
    base::mean(x)
  }

  d <- as.numeric(section_density)
  r <- as.numeric(section_rep)
  names(r) <- sections_order

  if (stats::sd(r, na.rm = TRUE) <= epsilon) {
    density_representation_spearman <- NA_real_
  } else {
    density_representation_spearman <- suppressWarnings(
      stats::cor(d, r, method = "spearman", use = "complete.obs")
    )
  }

  d_bar <- base::mean(d)
  r_bar <- base::mean(r)
  slope_denominator <- base::sum((d - d_bar)^2)

  if (!is.finite(slope_denominator) || slope_denominator <= epsilon) {
    density_representation_slope <- NA_real_
    residuals <- stats::setNames(rep(NA_real_, length(sections_order)), sections_order)
  } else {
    density_representation_slope <-
      base::sum((d - d_bar) * (r - r_bar)) / slope_denominator

    intercept <- r_bar - density_representation_slope * d_bar
    predicted <- intercept + density_representation_slope * d

    residuals <- r - predicted
    names(residuals) <- sections_order
  }

  low_sections  <- density_bins$low
  mid_sections  <- density_bins$mid
  high_sections <- density_bins$high

  total_rep <- base::sum(section_rep, na.rm = TRUE)

  high_total <- base::sum(section_rep[high_sections], na.rm = TRUE)
  mid_total  <- base::sum(section_rep[mid_sections], na.rm = TRUE)
  low_total  <- base::sum(section_rep[low_sections], na.rm = TRUE)

  density_bin_totals <- c(
    low  = low_total,
    mid  = mid_total,
    high = high_total
  )

  if (base::sum(density_bin_totals, na.rm = TRUE) <= epsilon) {
    density_evenness <- NA_real_
    density_dominance_index <- NA_real_
  } else {
    p <- density_bin_totals / base::sum(density_bin_totals, na.rm = TRUE)
    p_nonzero <- p[p > 0 & is.finite(p)]

    density_evenness <- -base::sum(p_nonzero * log(p_nonzero)) / log(3)
    density_dominance_index <- max(p, na.rm = TRUE)
  }

  resid_mean <- function(section_names) {
    safe_mean(residuals[section_names])
  }

  tibble::tibble(
    density_weighted_mean_mnau =
      safe_weighted_density(section_rep),

    density_weighted_mean_mne =
      safe_weighted_density(section_mne),

    density_representation_spearman =
      density_representation_spearman,

    density_representation_slope =
      density_representation_slope,

    high_density_to_low_density_ratio =
      (safe_mean(section_rep[high_sections]) + epsilon) /
      (safe_mean(section_rep[low_sections]) + epsilon),

    high_density_share =
      safe_share(high_total, total_rep),

    low_density_share =
      safe_share(low_total, total_rep),

    low_density_survival_index =
      safe_mean(section_rep[low_sections]),

    fragile_section_survival_count =
      base::sum(section_rep[low_sections] > fragile_threshold, na.rm = TRUE),

    density_evenness =
      density_evenness,

    density_dominance_index =
      density_dominance_index,

    density_adjusted_cranial_postcranial_contrast =
      resid_mean(groups$cranial_complex) -
      resid_mean(groups$postcranial_total),

    density_adjusted_limb_trunk_contrast =
      resid_mean(groups$limb_shaft_proxy) -
      resid_mean(groups$column_trunk),

    density_adjusted_appendicular_axial_contrast =
      resid_mean(groups$appendicular) -
      resid_mean(groups$axial_main),

    density_adjusted_distal_proximal_contrast =
      resid_mean(groups$distal_appendicular) -
      resid_mean(groups$proximal_appendicular),

    density_corrected_marrow_proxy_contrast =
      resid_mean(groups$limb_shaft_proxy) -
      resid_mean(c("hands", "foot", "thorax"))
  )
}