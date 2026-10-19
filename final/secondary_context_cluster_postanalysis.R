# ==============================================================================
# Secondary-context interpretation of the two-run unsupervised clustering
# Run AFTER:
#   unsupervised_7spaces_tapho_db_sum_two_runs_colored_concentration_ellipses_indet_redistributed.R
#
# Purpose
# -------
# 1. Quantify what each K-means cluster is made of:
#      - Funerary vs non-funerary percentages
#      - Funerary / Cannibalism / Carnivore-related / Geological transport
#      - Detailed secondary labels: funerary subtype for funerary records,
#        broad process for non-funerary records
# 2. Quantify where each archaeological context falls across clusters.
# 3. Test detailed secondary-context association with cluster membership using
#    permutation inference (sparse contingency tables).
# 4. Test whether detailed labels add organization after preserving the broad
#    funerary/non-funerary distinction (stratified permutation).
# 5. Perform cluster x secondary-context Fisher enrichment tests with BH/FDR.
# 6. Report where Unknown, Sepulchral, Historical and Early named records fall.
# 7. Produce report-ready figures, CSV tables and an automatically generated
#    Markdown Results summary for the C + Heip space.
#
# IMPORTANT
# ---------
# K-means is NOT refit here. This script interprets the assignments generated
# by the preceding clustering script. Formal archaeological-label inference is
# calculated only on rows with known four-context labels. Unknown and
# Sepulchral rows are reported descriptively as placements/affinities.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. Paths and settings
# ------------------------------------------------------------------------------

RUN_WD <- getwd()
ROOT_IN <- file.path(
  RUN_WD,
  "unsupervised_7spaces_tapho_db_sum_TWO_RUNS_R_outputs_3"
)

RUN_A_IN <- file.path(ROOT_IN, "run_A_reference_fit_projection")
RUN_B_IN <- file.path(ROOT_IN, "run_B_all_contexts_in_kmeans_fit")

OUT_DIR <- file.path(ROOT_IN, "secondary_context_post_analysis")
dir.create(OUT_DIR, showWarnings = TRUE, recursive = TRUE)

FOCUS_SPACE <- "C + Heip evenness"
B_PERM <- 19999L
ALPHA_FDR <- 0.05
SEED <- 4201L

cat("\n=== SECONDARY-CONTEXT CLUSTER POST-ANALYSIS ===\n")
cat("Working directory :", RUN_WD, "\n")
cat("Input root        :", ROOT_IN, "\n")
cat("Output directory  :", OUT_DIR, "\n")
cat("Focus space       :", FOCUS_SPACE, "\n")
cat("Permutations      :", format(B_PERM, big.mark = ","), "\n\n")

if (!dir.exists(ROOT_IN)) {
  stop(
    "Cannot find the clustering-output folder:\n  ", ROOT_IN,
    "\nRun the two-run clustering script first."
  )
}

required_files <- c(
  file.path(RUN_A_IN, "fit_assignments.csv"),
  file.path(RUN_A_IN, "special_projection_assignments.csv"),
  file.path(RUN_A_IN, "cluster_profiles.csv"),
  file.path(RUN_B_IN, "fit_assignments.csv"),
  file.path(RUN_B_IN, "cluster_profiles.csv")
)

missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop(
    "Required output file(s) are missing:\n",
    paste0("  - ", missing_files, collapse = "\n")
  )
}

writeLines(
  c(
    paste0("Started: ", Sys.time()),
    paste0("Input root: ", ROOT_IN),
    paste0("Focus space: ", FOCUS_SPACE),
    paste0("Permutations: ", B_PERM)
  ),
  file.path(OUT_DIR, "RUN_STARTED.txt")
)

# ------------------------------------------------------------------------------
# 1. Packages
# ------------------------------------------------------------------------------

needed <- c("tidyverse")
missing_packages <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop(
    "Missing package(s): ", paste(missing_packages, collapse = ", "),
    "\nInstall first with install.packages()."
  )
}

library(tidyverse)

set.seed(SEED)

# ------------------------------------------------------------------------------
# 2. Helpers
# ------------------------------------------------------------------------------

clean_fun_subtype <- function(x) {
  x <- as.character(x)
  bad <- is.na(x) | stringr::str_trim(x) == "" | x == "Missing"
  x[bad] <- "Funerary Context"
  x
}

add_secondary_labels <- function(dat) {
  dat %>%
    mutate(
      # Exact reporting rule at the broad-process level desired here:
      # funerary -> recorded funerary subtype; non-funerary -> broad process.
      secondary_context = case_when(
        class4 == "Funerary" ~ clean_fun_subtype(funerary_subtype),
        class4 == "Cannibalism" ~ "Cannibalism",
        class4 == "Carnivore-related" ~ "Carnivore-related",
        class4 == "Geological transport" ~ "Geological transport",
        TRUE ~ NA_character_
      ),
      # A literal version of the original rule is retained for auditability.
      secondary_context_literal = case_when(
        class4 == "Funerary" ~ clean_fun_subtype(funerary_subtype),
        !is.na(class4) ~ taphonomic_context,
        TRUE ~ NA_character_
      ),
      binary_name = case_when(
        binary_label == "F" ~ "Funerary",
        binary_label == "NF" ~ "Non-funerary",
        TRUE ~ NA_character_
      )
    )
}

pearson_chi_stat <- function(labels, clusters) {
  ok <- complete.cases(labels, clusters)
  labels <- droplevels(factor(labels[ok]))
  clusters <- droplevels(factor(clusters[ok]))

  if (length(labels) < 2 || nlevels(labels) < 2 || nlevels(clusters) < 2) {
    return(NA_real_)
  }

  tab <- table(clusters, labels)
  expected <- outer(rowSums(tab), colSums(tab)) / sum(tab)

  if (any(expected <= 0)) return(NA_real_)
  sum((tab - expected)^2 / expected)
}

cramers_v_bias_corrected <- function(tab) {
  tab <- as.matrix(tab)
  n <- sum(tab)
  r <- nrow(tab)
  k <- ncol(tab)

  if (n <= 1 || r < 2 || k < 2) return(NA_real_)

  expected <- outer(rowSums(tab), colSums(tab)) / n
  chi2 <- sum((tab - expected)^2 / expected)
  phi2 <- chi2 / n

  phi2_corr <- max(
    0,
    phi2 - ((k - 1) * (r - 1)) / (n - 1)
  )

  r_corr <- r - ((r - 1)^2) / (n - 1)
  k_corr <- k - ((k - 1)^2) / (n - 1)
  denom <- min(k_corr - 1, r_corr - 1)

  if (!is.finite(denom) || denom <= 0) return(0)
  sqrt(phi2_corr / denom)
}

cramers_v_raw <- function(tab) {
  tab <- as.matrix(tab)
  n <- sum(tab)
  if (n == 0 || nrow(tab) < 2 || ncol(tab) < 2) return(NA_real_)
  expected <- outer(rowSums(tab), colSums(tab)) / n
  chi2 <- sum((tab - expected)^2 / expected)
  sqrt((chi2 / n) / min(nrow(tab) - 1, ncol(tab) - 1))
}

NMI <- function(a, b) {
  ok <- complete.cases(a, b)
  a <- factor(a[ok])
  b <- factor(b[ok])
  tab <- table(a, b)
  pxy <- tab / sum(tab)
  px <- rowSums(pxy)
  py <- colSums(pxy)
  nz <- which(pxy > 0, arr.ind = TRUE)
  mi <- sum(
    pxy[nz] * log(
      pxy[nz] / (px[nz[, 1]] * py[nz[, 2]])
    )
  )
  hx <- -sum(px[px > 0] * log(px[px > 0]))
  hy <- -sum(py[py > 0] * log(py[py > 0]))
  if (hx == 0 || hy == 0) return(0)
  mi / sqrt(hx * hy)
}

permutation_association <- function(
    labels,
    clusters,
    B = B_PERM,
    seed = SEED,
    strata = NULL
) {
  ok <- complete.cases(labels, clusters)
  if (!is.null(strata)) ok <- ok & !is.na(strata)

  labels <- as.character(labels[ok])
  clusters <- as.character(clusters[ok])
  if (!is.null(strata)) strata <- as.character(strata[ok])

  tab <- table(clusters, labels)

  if (nrow(tab) < 2 || ncol(tab) < 2) {
    return(tibble(
      n = length(labels),
      n_clusters = nrow(tab),
      n_labels = ncol(tab),
      chi_square = NA_real_,
      permutation_p = NA_real_,
      cramers_v = NA_real_,
      bias_corrected_cramers_v = NA_real_,
      NMI = NA_real_,
      expected_cells_below_5_pct = NA_real_
    ))
  }

  expected <- outer(rowSums(tab), colSums(tab)) / sum(tab)
  obs <- sum((tab - expected)^2 / expected)

  set.seed(seed)

  null <- numeric(B)
  idx_all <- seq_along(labels)

  if (is.null(strata)) {
    for (i in seq_len(B)) {
      perm_labels <- sample(labels, replace = FALSE)
      null[i] <- pearson_chi_stat(perm_labels, clusters)
    }
  } else {
    split_idx <- split(idx_all, strata)
    for (i in seq_len(B)) {
      perm_labels <- labels
      for (idx in split_idx) {
        perm_labels[idx] <- sample(labels[idx], replace = FALSE)
      }
      null[i] <- pearson_chi_stat(perm_labels, clusters)
    }
  }

  p_perm <- (1 + sum(null >= obs, na.rm = TRUE)) / (B + 1)

  tibble(
    n = length(labels),
    n_clusters = nrow(tab),
    n_labels = ncol(tab),
    chi_square = obs,
    permutation_p = p_perm,
    cramers_v = cramers_v_raw(tab),
    bias_corrected_cramers_v = cramers_v_bias_corrected(tab),
    NMI = NMI(labels, clusters),
    expected_cells_below_5_pct = 100 * mean(expected < 5)
  )
}

fisher_enrichment_one_table <- function(dat) {
  dat <- dat %>%
    filter(!is.na(secondary_context), !is.na(Cluster_name))

  clusters <- sort(unique(as.character(dat$Cluster_name)))
  labels <- sort(unique(dat$secondary_context))
  n_total <- nrow(dat)

  res <- tidyr::crossing(
    Cluster_name = clusters,
    secondary_context = labels
  ) %>%
    mutate(
      a = map2_int(
        Cluster_name, secondary_context,
        ~sum(dat$Cluster_name == .x & dat$secondary_context == .y)
      ),
      cluster_total = map_int(
        Cluster_name,
        ~sum(dat$Cluster_name == .x)
      ),
      label_total = map_int(
        secondary_context,
        ~sum(dat$secondary_context == .x)
      ),
      b = cluster_total - a,
      c = label_total - a,
      d = n_total - a - b - c
    )

  fisher_parts <- pmap(
    res %>% select(a, b, c, d),
    function(a, b, c, d) {
      tt <- matrix(c(a, b, c, d), nrow = 2, byrow = TRUE)
      ft <- suppressWarnings(fisher.test(tt, alternative = "two.sided"))
      est <- unname(ft$estimate)
      if (length(est) == 0) est <- NA_real_
      tibble(
        odds_ratio = est,
        fisher_p = ft$p.value
      )
    }
  )

  bind_cols(res, bind_rows(fisher_parts)) %>%
    mutate(
      cluster_percent = 100 * a / cluster_total,
      context_percent_in_cluster = cluster_percent,
      context_distribution_to_cluster_percent = 100 * a / label_total,
      outside_cluster_percent = if_else(
        n_total - cluster_total > 0,
        100 * c / (n_total - cluster_total),
        NA_real_
      ),
      direction = case_when(
        is.na(odds_ratio) ~ NA_character_,
        odds_ratio > 1 ~ "Enriched",
        odds_ratio < 1 ~ "Depleted",
        TRUE ~ "Neutral"
      ),
      fisher_q_BH = p.adjust(fisher_p, method = "BH"),
      significant_FDR_0_05 = fisher_q_BH < ALPHA_FDR
    ) %>%
    arrange(fisher_q_BH, desc(abs(log(pmax(odds_ratio, 1e-12)))))
}

fmt_num <- function(x, digits = 3) {
  ifelse(is.na(x), "NA", formatC(x, format = "f", digits = digits))
}

fmt_p <- function(p, B = B_PERM) {
  if (is.na(p)) return("NA")
  min_p <- 1 / (B + 1)
  if (p <= min_p + .Machine$double.eps) {
    return(paste0(formatC(min_p, format = "f", digits = 5), " (minimum attainable)"))
  }
  if (p < 0.001) return(formatC(p, format = "f", digits = 5))
  formatC(p, format = "f", digits = 3)
}

# ------------------------------------------------------------------------------
# 3. Read both runs
# ------------------------------------------------------------------------------

read_run <- function(run_name, run_dir, special_are_projected) {
  fit <- readr::read_csv(
    file.path(run_dir, "fit_assignments.csv"),
    show_col_types = FALSE
  ) %>%
    mutate(
      Run = run_name,
      Assignment_source = "K-means fit"
    )

  fit <- add_secondary_labels(fit)

  if (special_are_projected) {
    proj <- readr::read_csv(
      file.path(run_dir, "special_projection_assignments.csv"),
      show_col_types = FALSE
    ) %>%
      mutate(
        Run = run_name,
        Assignment_source = "Projected after fit",
        named_panel = NA_character_,
        class4 = NA_character_,
        binary_label = NA_character_,
        funerary_subtype = NA_character_,
        secondary_context = NA_character_,
        secondary_context_literal = NA_character_,
        binary_name = NA_character_
      )
  } else {
    proj <- fit[0, , drop = FALSE]
  }

  profiles <- readr::read_csv(
    file.path(run_dir, "cluster_profiles.csv"),
    show_col_types = FALSE
  ) %>%
    mutate(Run = run_name)

  list(
    fit = fit,
    projection = proj,
    profiles = profiles
  )
}

run_A <- read_run(
  "Run A: known-reference fit",
  RUN_A_IN,
  special_are_projected = TRUE
)

run_B <- read_run(
  "Run B: all contexts in fit",
  RUN_B_IN,
  special_are_projected = FALSE
)

fit_all <- bind_rows(run_A$fit, run_B$fit)
profiles_all <- bind_rows(run_A$profiles, run_B$profiles)

all_assignments <- bind_rows(
  run_A$fit,
  run_A$projection,
  run_B$fit
)

known <- fit_all %>%
  filter(!is.na(class4), !is.na(binary_label), !is.na(secondary_context))

if (!FOCUS_SPACE %in% unique(fit_all$Feature_space)) {
  stop(
    "FOCUS_SPACE was not found. Available spaces:\n",
    paste(sort(unique(fit_all$Feature_space)), collapse = "\n")
  )
}

# ------------------------------------------------------------------------------
# 4. Percent composition: what is each cluster made of?
# ------------------------------------------------------------------------------

cluster_binary_composition <- known %>%
  count(Run, Feature_space, Cluster, Cluster_name, binary_name, name = "n") %>%
  group_by(Run, Feature_space, Cluster, Cluster_name) %>%
  mutate(
    known_cluster_n = sum(n),
    percent_of_cluster = 100 * n / known_cluster_n
  ) %>%
  ungroup()

cluster_broad_context_composition <- known %>%
  count(Run, Feature_space, Cluster, Cluster_name, class4, name = "n") %>%
  group_by(Run, Feature_space, Cluster, Cluster_name) %>%
  mutate(
    known_cluster_n = sum(n),
    percent_of_cluster = 100 * n / known_cluster_n
  ) %>%
  ungroup()

cluster_secondary_composition <- known %>%
  count(Run, Feature_space, Cluster, Cluster_name, secondary_context, name = "n") %>%
  group_by(Run, Feature_space, Cluster, Cluster_name) %>%
  mutate(
    known_cluster_n = sum(n),
    percent_of_cluster = 100 * n / known_cluster_n
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 5. Reverse percentage: where does each context fall?
# ------------------------------------------------------------------------------

binary_distribution_across_clusters <- known %>%
  count(Run, Feature_space, binary_name, Cluster, Cluster_name, name = "n") %>%
  group_by(Run, Feature_space, binary_name) %>%
  mutate(
    label_n = sum(n),
    percent_of_label_in_cluster = 100 * n / label_n
  ) %>%
  ungroup()

broad_context_distribution_across_clusters <- known %>%
  count(Run, Feature_space, class4, Cluster, Cluster_name, name = "n") %>%
  group_by(Run, Feature_space, class4) %>%
  mutate(
    label_n = sum(n),
    percent_of_label_in_cluster = 100 * n / label_n
  ) %>%
  ungroup()

secondary_distribution_across_clusters <- known %>%
  count(Run, Feature_space, secondary_context, Cluster, Cluster_name, name = "n") %>%
  group_by(Run, Feature_space, secondary_context) %>%
  mutate(
    label_n = sum(n),
    percent_of_label_in_cluster = 100 * n / label_n
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 6. Cluster lookup: F percentage and dominant known contexts
# ------------------------------------------------------------------------------

cluster_binary_lookup <- cluster_binary_composition %>%
  select(Run, Feature_space, Cluster, Cluster_name, binary_name, percent_of_cluster) %>%
  pivot_wider(
    names_from = binary_name,
    values_from = percent_of_cluster,
    values_fill = 0,
    names_prefix = "Pct_"
  ) %>%
  rename(Pct_Non_funerary = `Pct_Non-funerary`)

cluster_class4_lookup <- cluster_broad_context_composition %>%
  group_by(Run, Feature_space, Cluster, Cluster_name) %>%
  arrange(desc(percent_of_cluster), desc(n), class4) %>%
  slice(1) %>%
  ungroup() %>%
  transmute(
    Run, Feature_space, Cluster, Cluster_name,
    Dominant_broad_context = class4,
    Dominant_broad_context_pct = percent_of_cluster
  )

cluster_secondary_lookup <- cluster_secondary_composition %>%
  group_by(Run, Feature_space, Cluster, Cluster_name) %>%
  arrange(desc(percent_of_cluster), desc(n), secondary_context) %>%
  slice(1) %>%
  ungroup() %>%
  transmute(
    Run, Feature_space, Cluster, Cluster_name,
    Dominant_secondary_context = secondary_context,
    Dominant_secondary_context_pct = percent_of_cluster
  )

cluster_lookup <- cluster_binary_lookup %>%
  left_join(
    cluster_class4_lookup,
    by = c("Run", "Feature_space", "Cluster", "Cluster_name")
  ) %>%
  left_join(
    cluster_secondary_lookup,
    by = c("Run", "Feature_space", "Cluster", "Cluster_name")
  ) %>%
  left_join(
    profiles_all %>%
      select(
        Run, Feature_space, Cluster, Cluster_name,
        n_total, n_known, n_unknown, n_sepulchral,
        Median_C, Median_Heip
      ),
    by = c("Run", "Feature_space", "Cluster", "Cluster_name")
  )

# ------------------------------------------------------------------------------
# 7. Site-level mapping: known + special + named panels
# ------------------------------------------------------------------------------

site_level_mapping <- all_assignments %>%
  left_join(
    cluster_lookup,
    by = c("Run", "Feature_space", "Cluster", "Cluster_name")
  ) %>%
  mutate(
    Site_role = case_when(
      special_type == "Unknown" ~ "Unknown",
      special_type == "Sepulchral" ~ "Sepulchral",
      !is.na(named_panel) ~ paste0("Named panel: ", named_panel),
      !is.na(class4) ~ "Known reference context",
      TRUE ~ "Other"
    )
  ) %>%
  arrange(Run, Feature_space, Cluster, site_name, record_id)

special_site_mapping <- site_level_mapping %>%
  filter(special_type %in% c("Unknown", "Sepulchral"))

named_panel_mapping <- site_level_mapping %>%
  filter(!is.na(named_panel))

special_site_consensus <- special_site_mapping %>%
  group_by(Run, record_id, site_name, special_type) %>%
  summarise(
    Feature_spaces = n_distinct(Feature_space),
    F_enriched_spaces = sum(Pct_Funerary >= 50, na.rm = TRUE),
    NF_enriched_spaces = sum(Pct_Non_funerary > 50, na.rm = TRUE),
    Median_assigned_cluster_F_percent = median(Pct_Funerary, na.rm = TRUE),
    Mean_assigned_cluster_F_percent = mean(Pct_Funerary, na.rm = TRUE),
    Median_distance_to_centroid = median(Distance_to_centroid, na.rm = TRUE),
    .groups = "drop"
  )

named_panel_consensus <- named_panel_mapping %>%
  group_by(Run, record_id, site_name, named_panel, class4, binary_name, secondary_context) %>%
  summarise(
    Feature_spaces = n_distinct(Feature_space),
    F_enriched_spaces = sum(Pct_Funerary >= 50, na.rm = TRUE),
    NF_enriched_spaces = sum(Pct_Non_funerary > 50, na.rm = TRUE),
    Median_assigned_cluster_F_percent = median(Pct_Funerary, na.rm = TRUE),
    Mean_assigned_cluster_F_percent = mean(Pct_Funerary, na.rm = TRUE),
    .groups = "drop"
  )

# ------------------------------------------------------------------------------
# 8. Global association tests for all feature spaces
# ------------------------------------------------------------------------------

analysis_groups <- known %>%
  distinct(Run, Feature_space) %>%
  arrange(Run, Feature_space)

message("Running permutation association tests. This is the slowest section...")

association_rows <- vector("list", nrow(analysis_groups) * 4)
pos <- 1L

for (ii in seq_len(nrow(analysis_groups))) {
  rr <- analysis_groups$Run[ii]
  ss <- analysis_groups$Feature_space[ii]

  z <- known %>% filter(Run == rr, Feature_space == ss)

  # Detailed secondary context, unrestricted permutation.
  a1 <- permutation_association(
    z$secondary_context,
    z$Cluster_name,
    B = B_PERM,
    seed = SEED + ii
  ) %>%
    mutate(
      Run = rr,
      Feature_space = ss,
      Test = "Detailed secondary context",
      .before = 1
    )
  association_rows[[pos]] <- a1
  pos <- pos + 1L

  # Detailed secondary context, shuffled only inside broad F/NF class.
  a2 <- permutation_association(
    z$secondary_context,
    z$Cluster_name,
    B = B_PERM,
    seed = SEED + 1000 + ii,
    strata = z$binary_name
  ) %>%
    mutate(
      Run = rr,
      Feature_space = ss,
      Test = "Detailed context | F/NF preserved",
      .before = 1
    )
  association_rows[[pos]] <- a2
  pos <- pos + 1L

  # Within funerary subtypes only.
  zf <- z %>% filter(binary_label == "F")
  a3 <- permutation_association(
    zf$secondary_context,
    zf$Cluster_name,
    B = B_PERM,
    seed = SEED + 2000 + ii
  ) %>%
    mutate(
      Run = rr,
      Feature_space = ss,
      Test = "Within funerary subtypes",
      .before = 1
    )
  association_rows[[pos]] <- a3
  pos <- pos + 1L

  # Within non-funerary processes only.
  zn <- z %>% filter(binary_label == "NF")
  a4 <- permutation_association(
    zn$secondary_context,
    zn$Cluster_name,
    B = B_PERM,
    seed = SEED + 3000 + ii
  ) %>%
    mutate(
      Run = rr,
      Feature_space = ss,
      Test = "Within non-funerary processes",
      .before = 1
    )
  association_rows[[pos]] <- a4
  pos <- pos + 1L
}

secondary_association_tests <- bind_rows(association_rows)

# Binary association is useful as the comparator requested in the report.
binary_assoc_rows <- vector("list", nrow(analysis_groups))
for (ii in seq_len(nrow(analysis_groups))) {
  rr <- analysis_groups$Run[ii]
  ss <- analysis_groups$Feature_space[ii]
  z <- known %>% filter(Run == rr, Feature_space == ss)

  binary_assoc_rows[[ii]] <- permutation_association(
    z$binary_name,
    z$Cluster_name,
    B = B_PERM,
    seed = SEED + 5000 + ii
  ) %>%
    mutate(
      Run = rr,
      Feature_space = ss,
      Test = "Funerary vs non-funerary",
      .before = 1
    )
}

binary_association_tests <- bind_rows(binary_assoc_rows)

# ------------------------------------------------------------------------------
# 9. Cluster x detailed-context Fisher enrichment + BH/FDR
# ------------------------------------------------------------------------------

fisher_all <- analysis_groups %>%
  mutate(result = map2(Run, Feature_space, function(rr, ss) {
    z <- known %>% filter(Run == rr, Feature_space == ss)
    fisher_enrichment_one_table(z) %>%
      mutate(
        Run = rr,
        Feature_space = ss,
        .before = 1
      )
  })) %>%
  select(result) %>%
  unnest(result)

# ------------------------------------------------------------------------------
# 10. Focus-space cluster interpretation table
# ------------------------------------------------------------------------------

focus_significant <- fisher_all %>%
  filter(
    Feature_space == FOCUS_SPACE,
    significant_FDR_0_05
  ) %>%
  group_by(Run, Cluster_name) %>%
  summarise(
    FDR_context_signals = paste(
      paste0(
        secondary_context, " [", direction, "]",
        " (OR=", fmt_num(odds_ratio, 2),
        ", q=", fmt_num(fisher_q_BH, 4), ")"
      ),
      collapse = "; "
    ),
    .groups = "drop"
  )

focus_cluster_summary <- cluster_lookup %>%
  filter(Feature_space == FOCUS_SPACE) %>%
  left_join(focus_significant, by = c("Run", "Cluster_name")) %>%
  mutate(
    Structural_position = paste0(
      "Median C=", fmt_num(Median_C, 3),
      "; median Heip=", fmt_num(Median_Heip, 3)
    )
  ) %>%
  arrange(Run, Cluster)

# ------------------------------------------------------------------------------
# 11. Figures for the focus C + Heip space
# ------------------------------------------------------------------------------

FIG_DIR <- file.path(OUT_DIR, "figures")
dir.create(FIG_DIR, showWarnings = FALSE, recursive = TRUE)

focus_known <- known %>% filter(Feature_space == FOCUS_SPACE)

# Figure 1: Where each secondary context goes (row percentages).
p1dat <- secondary_distribution_across_clusters %>%
  filter(Feature_space == FOCUS_SPACE) %>%
  mutate(
    secondary_context = forcats::fct_reorder(
      secondary_context,
      label_n,
      .desc = FALSE
    )
  )

p1 <- ggplot(
  p1dat,
  aes(
    x = secondary_context,
    y = percent_of_label_in_cluster,
    fill = Cluster_name
  )
) +
  geom_col(width = 0.82) +
  coord_flip() +
  facet_wrap(~Run, ncol = 1) +
  scale_fill_viridis_d(option = "D", end = 0.9) +
  labs(
    x = NULL,
    y = "% of archaeological context assigned to cluster",
    fill = "Cluster",
    title = paste0(FOCUS_SPACE, ": distribution of each secondary context across clusters"),
    subtitle = "Percentages sum to 100% within each archaeological context"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom")

ggsave(
  file.path(FIG_DIR, "figure1_secondary_context_distribution_across_clusters.png"),
  p1, width = 11, height = 10, dpi = 320
)

# Figure 2: What each cluster is made of (column percentages).
p2dat <- cluster_secondary_composition %>%
  filter(Feature_space == FOCUS_SPACE)

p2 <- ggplot(
  p2dat,
  aes(
    x = Cluster_name,
    y = percent_of_cluster,
    fill = secondary_context
  )
) +
  geom_col(width = 0.78) +
  facet_wrap(~Run, ncol = 1) +
  scale_fill_viridis_d(option = "turbo", end = 0.95) +
  labs(
    x = "K-means cluster",
    y = "% of known-label members in cluster",
    fill = "Secondary context",
    title = paste0(FOCUS_SPACE, ": archaeological composition of each cluster"),
    subtitle = "Percentages sum to 100% within each cluster (known archaeological labels only)"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "right")

ggsave(
  file.path(FIG_DIR, "figure2_cluster_composition_secondary_context.png"),
  p2, width = 12, height = 9, dpi = 320
)

# Figure 3: Exact count heatmap.
p3dat <- focus_known %>%
  count(Run, Cluster_name, secondary_context, name = "n") %>%
  group_by(Run) %>%
  complete(Cluster_name, secondary_context, fill = list(n = 0)) %>%
  ungroup()

p3 <- ggplot(
  p3dat,
  aes(x = Cluster_name, y = secondary_context, fill = n)
) +
  geom_tile(colour = "white", linewidth = 0.35) +
  geom_text(aes(label = n), size = 3) +
  facet_wrap(~Run, ncol = 1) +
  scale_fill_viridis_c(option = "C") +
  labs(
    x = "K-means cluster",
    y = NULL,
    fill = "Count",
    title = paste0(FOCUS_SPACE, ": exact counts by cluster and secondary context")
  ) +
  theme_bw(base_size = 11)

ggsave(
  file.path(FIG_DIR, "figure3_secondary_context_counts.png"),
  p3, width = 10, height = 11, dpi = 320
)

# Figure 4: F/NF composition of each cluster.
p4dat <- cluster_binary_composition %>%
  filter(Feature_space == FOCUS_SPACE)

p4 <- ggplot(
  p4dat,
  aes(x = Cluster_name, y = percent_of_cluster, fill = binary_name)
) +
  geom_col(width = 0.76) +
  geom_text(
    aes(label = paste0(round(percent_of_cluster, 1), "%")),
    position = position_stack(vjust = 0.5),
    size = 3.3
  ) +
  facet_wrap(~Run, ncol = 1) +
  scale_fill_manual(values = c("Funerary" = "#4C78A8", "Non-funerary" = "#F58518")) +
  labs(
    x = "K-means cluster",
    y = "% of known-label members",
    fill = NULL,
    title = paste0(FOCUS_SPACE, ": funerary vs non-funerary composition by cluster")
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom")

ggsave(
  file.path(FIG_DIR, "figure4_binary_funerary_nonfunerary_cluster_composition.png"),
  p4, width = 9, height = 7.5, dpi = 320
)

# Figure 5: Special-site assigned-cluster F percentage across feature spaces.
if (nrow(special_site_mapping) > 0) {
  p5dat <- special_site_mapping %>%
    mutate(
      Feature_space = factor(
        Feature_space,
        levels = c(
          "C only", "Heip evenness only", "C + Heip evenness",
          "%MNAU raw", "ReMNAU raw", "Engineered", "Combined"
        )
      )
    )

  p5 <- ggplot(
    p5dat,
    aes(
      x = Feature_space,
      y = forcats::fct_rev(factor(site_name)),
      fill = Pct_Funerary
    )
  ) +
    geom_tile(colour = "white", linewidth = 0.25) +
    geom_text(aes(label = Cluster_name), size = 2.6) +
    facet_grid(special_type ~ Run, scales = "free_y", space = "free_y") +
    scale_fill_viridis_c(
      option = "B",
      limits = c(0, 100),
      na.value = "grey90"
    ) +
    labs(
      x = NULL,
      y = NULL,
      fill = "Known funerary\n% in assigned cluster",
      title = "Unknown and Sepulchral placements across feature spaces",
      subtitle = "Tile text is the assigned cluster; fill is the funerary percentage among known-label members of that cluster"
    ) +
    theme_bw(base_size = 9) +
    theme(axis.text.x = element_text(angle = 35, hjust = 1))

  ggsave(
    file.path(FIG_DIR, "figure5_special_site_cluster_affinity_across_spaces.png"),
    p5, width = 14, height = 13, dpi = 320
  )
}

# ------------------------------------------------------------------------------
# 12. Save all numerical outputs
# ------------------------------------------------------------------------------

write_csv(cluster_binary_composition,
          file.path(OUT_DIR, "cluster_binary_funerary_nonfunerary_percent.csv"))
write_csv(cluster_broad_context_composition,
          file.path(OUT_DIR, "cluster_broad_context_percent.csv"))
write_csv(cluster_secondary_composition,
          file.path(OUT_DIR, "cluster_secondary_context_percent.csv"))

write_csv(binary_distribution_across_clusters,
          file.path(OUT_DIR, "binary_label_distribution_across_clusters.csv"))
write_csv(broad_context_distribution_across_clusters,
          file.path(OUT_DIR, "broad_context_distribution_across_clusters.csv"))
write_csv(secondary_distribution_across_clusters,
          file.path(OUT_DIR, "secondary_context_distribution_across_clusters.csv"))

write_csv(cluster_lookup,
          file.path(OUT_DIR, "cluster_composition_lookup.csv"))
write_csv(focus_cluster_summary,
          file.path(OUT_DIR, "focus_C_Heip_cluster_interpretation_summary.csv"))

write_csv(secondary_association_tests,
          file.path(OUT_DIR, "secondary_context_global_permutation_tests.csv"))
write_csv(binary_association_tests,
          file.path(OUT_DIR, "binary_F_NF_permutation_tests.csv"))
write_csv(fisher_all,
          file.path(OUT_DIR, "cellwise_cluster_secondary_context_fisher_FDR.csv"))

write_csv(site_level_mapping,
          file.path(OUT_DIR, "site_level_secondary_context_and_clusters.csv"))
write_csv(special_site_mapping,
          file.path(OUT_DIR, "Unknown_Sepulchral_site_cluster_mapping.csv"))
write_csv(special_site_consensus,
          file.path(OUT_DIR, "Unknown_Sepulchral_cross_space_consensus.csv"))
write_csv(named_panel_mapping,
          file.path(OUT_DIR, "historical_early_named_site_cluster_mapping.csv"))
write_csv(named_panel_consensus,
          file.path(OUT_DIR, "historical_early_named_cross_space_consensus.csv"))

# ------------------------------------------------------------------------------
# 13. Automatically generated report-ready Markdown for focus space
# ------------------------------------------------------------------------------

report_lines <- c(
  "# Secondary-context interpretation of abundance–Heip clusters",
  "",
  paste0(
    "This post-analysis interprets the existing unsupervised K-means solution for `",
    FOCUS_SPACE,
    "`. K-means was not refit and archaeological labels were not used to construct the clusters."
  ),
  "",
  "For detailed archaeological interpretation, funerary records were assigned their normalized `funerary_context`; non-funerary records were assigned the collapsed broad process (`Cannibalism`, `Carnivore-related`, or `Geological transport`). Missing funerary subtype values, if present, were assigned the fallback `Funerary Context`. Unknown and Sepulchral records were excluded from formal label-association inference and are reported separately as cluster placements.",
  "",
  paste0(
    "Permutation tests used ", format(B_PERM, big.mark = ","),
    " shuffles. This gives a minimum attainable add-one permutation p-value of ",
    formatC(1 / (B_PERM + 1), format = "f", digits = 5), "."
  ),
  ""
)

for (rr in unique(focus_known$Run)) {
  sec <- secondary_association_tests %>%
    filter(
      Run == rr,
      Feature_space == FOCUS_SPACE,
      Test == "Detailed secondary context"
    ) %>% slice(1)

  strat <- secondary_association_tests %>%
    filter(
      Run == rr,
      Feature_space == FOCUS_SPACE,
      Test == "Detailed context | F/NF preserved"
    ) %>% slice(1)

  wf <- secondary_association_tests %>%
    filter(
      Run == rr,
      Feature_space == FOCUS_SPACE,
      Test == "Within funerary subtypes"
    ) %>% slice(1)

  wnf <- secondary_association_tests %>%
    filter(
      Run == rr,
      Feature_space == FOCUS_SPACE,
      Test == "Within non-funerary processes"
    ) %>% slice(1)

  bin <- binary_association_tests %>%
    filter(Run == rr, Feature_space == FOCUS_SPACE) %>% slice(1)

  clsum <- focus_cluster_summary %>% filter(Run == rr)
  sig <- fisher_all %>%
    filter(
      Run == rr,
      Feature_space == FOCUS_SPACE,
      significant_FDR_0_05
    ) %>%
    arrange(Cluster_name, fisher_q_BH)

  report_lines <- c(
    report_lines,
    paste0("## ", rr),
    "",
    paste0(
      "The detailed secondary-context table contained **", sec$n_labels,
      " labels across ", sec$n_clusters, " clusters** (`n = ", sec$n,
      "`). Because **", fmt_num(sec$expected_cells_below_5_pct, 1),
      "%** of expected contingency cells were below 5, inference was based on label permutation rather than the ordinary asymptotic chi-square p-value."
    ),
    "",
    paste0(
      "Detailed secondary context was associated with cluster membership: **χ² = ",
      fmt_num(sec$chi_square, 2), "**, permutation **p = ", fmt_p(sec$permutation_p),
      "**, Cramér's **V = ", fmt_num(sec$cramers_v, 3),
      "**, bias-corrected **V = ", fmt_num(sec$bias_corrected_cramers_v, 3),
      "**, and **NMI = ", fmt_num(sec$NMI, 3), "**."
    ),
    "",
    paste0(
      "For comparison, the broad funerary/non-funerary association had bias-corrected **V = ",
      fmt_num(bin$bias_corrected_cramers_v, 3),
      "** (permutation p = ", fmt_p(bin$permutation_p), ")."
    ),
    "",
    paste0(
      "A stratified permutation that shuffled detailed labels only within the broad funerary/non-funerary classes gave **p = ",
      fmt_p(strat$permutation_p),
      "**. This asks whether the fine archaeological labels contribute cluster organization beyond the already-known binary division."
    ),
    "",
    paste0(
      "Within funerary records alone, the subtype permutation p-value was **",
      fmt_p(wf$permutation_p),
      "**; within non-funerary records alone, the process-level permutation p-value was **",
      fmt_p(wnf$permutation_p), "**."
    ),
    "",
    "### Cluster composition",
    "",
    "| Cluster | n total | n known | Median C | Median Heip | Funerary % | Dominant broad context | Dominant secondary context | FDR-significant context signals |",
    "|---|---:|---:|---:|---:|---:|---|---|---|"
  )

  for (jj in seq_len(nrow(clsum))) {
    r <- clsum[jj, ]
    enr_txt <- ifelse(
      is.na(r$FDR_context_signals),
      "None at q<0.05",
      r$FDR_context_signals
    )

    report_lines <- c(
      report_lines,
      paste0(
        "| ", r$Cluster_name,
        " | ", r$n_total,
        " | ", r$n_known,
        " | ", fmt_num(r$Median_C, 3),
        " | ", fmt_num(r$Median_Heip, 3),
        " | ", fmt_num(r$Pct_Funerary, 1),
        " | ", r$Dominant_broad_context,
        " | ", r$Dominant_secondary_context,
        " | ", enr_txt, " |"
      )
    )
  }

  report_lines <- c(
    report_lines,
    "",
    "### FDR-controlled cellwise enrichments and depletions",
    ""
  )

  if (nrow(sig) == 0) {
    report_lines <- c(
      report_lines,
      "No cluster × secondary-context enrichment or depletion survived BH/FDR q < 0.05.",
      ""
    )
  } else {
    report_lines <- c(
      report_lines,
      "| Cluster | Secondary context | Direction | Count | Context in cluster % | Context assigned here % | Odds ratio | q (BH) |",
      "|---|---|---|---:|---:|---:|---:|---:|"
    )

    for (jj in seq_len(nrow(sig))) {
      r <- sig[jj, ]
      report_lines <- c(
        report_lines,
        paste0(
          "| ", r$Cluster_name,
          " | ", r$secondary_context,
          " | ", r$direction,
          " | ", r$a,
          " | ", fmt_num(r$context_percent_in_cluster, 1),
          " | ", fmt_num(r$context_distribution_to_cluster_percent, 1),
          " | ", fmt_num(r$odds_ratio, 2),
          " | ", fmt_num(r$fisher_q_BH, 4), " |"
        )
      )
    }
    report_lines <- c(report_lines, "")
  }
}

report_lines <- c(
  report_lines,
  "## Interpretation guardrails",
  "",
  "The cellwise Fisher tests are exploratory localizations of a sparse global association and are therefore reported with BH/FDR correction. Rare funerary subtypes can still generate unstable odds ratios and should be interpreted with their raw counts.",
  "",
  "Unknown and Sepulchral cluster placements are not probabilities of funerary behavior. The reported funerary percentage is the proportion of **known archaeological reference labels** occupying the cluster to which the special record was assigned.",
  "",
  "The concentration ellipses in the preceding clustering analysis describe within-cluster dispersion in the displayed 2D/PCA space and are not inferential tests of archaeological-group separation. Formal inference is supplied by the permutation and enrichment analyses reported here.",
  "",
  "## Output files",
  "",
  "- `cluster_binary_funerary_nonfunerary_percent.csv`: what percentage of each cluster is F vs NF.",
  "- `cluster_broad_context_percent.csv`: what percentage of each cluster is Funerary, Cannibalism, Carnivore-related, or Geological transport.",
  "- `cluster_secondary_context_percent.csv`: detailed funerary-subtype/process composition of every cluster.",
  "- `secondary_context_distribution_across_clusters.csv`: where each context falls across clusters.",
  "- `cellwise_cluster_secondary_context_fisher_FDR.csv`: cluster × context enrichment/depletion tests with BH/FDR.",
  "- `site_level_secondary_context_and_clusters.csv`: every fitted/projected record, cluster, archaeological labels and assigned-cluster composition.",
  "- `Unknown_Sepulchral_site_cluster_mapping.csv`: feature-space-specific special-site placements.",
  "- `historical_early_named_site_cluster_mapping.csv`: feature-space-specific locations of named historical/early records.",
  ""
)

writeLines(
  report_lines,
  file.path(OUT_DIR, "REPORT_READY_secondary_context_results.md")
)

# ------------------------------------------------------------------------------
# 14. Finished marker + console summary
# ------------------------------------------------------------------------------

writeLines(
  c(
    paste0("Finished: ", Sys.time()),
    paste0("Focus space: ", FOCUS_SPACE),
    paste0("Permutation B: ", B_PERM),
    paste0("Output directory: ", OUT_DIR)
  ),
  file.path(OUT_DIR, "RUN_FINISHED.txt")
)

cat("\nSecondary-context post-analysis complete.\n")
cat("Outputs written to:\n  ", OUT_DIR, "\n\n", sep = "")
cat("Start with:\n")
cat("  REPORT_READY_secondary_context_results.md\n")
cat("  focus_C_Heip_cluster_interpretation_summary.csv\n")
cat("  cellwise_cluster_secondary_context_fisher_FDR.csv\n")
cat("  site_level_secondary_context_and_clusters.csv\n")
cat("  figures/\n\n")
