# ==============================================================================
# Archaeological classification-label geometry across 7 feature spaces
# Three task framings, repeated independently
#
# INPUT:
#   final/tapho_db_sum.csv
#
# TASKS:
#   1) 4class
#      Cannibalism | Carnivore | Funerary Context | Geological transport
#   2) cannibalism_vs_fc
#      Cannibalism | Funerary Context
#   3) fc_vs_rest
#      Funerary Context | Rest
#      Rest = Cannibalism + Carnivore + Geological transport
#
# DESIGN:
#   * tapho_db_sum is used directly; no site_id and no row collapsing.
#   * Bilateral *_indet %MNAU/ReMNAU values are redistributed first.
#   * %MNAU redistribution is capped at 1.0 per left/right side.
#   * Seven spaces:
#       C only, Heip evenness only, C + Heip evenness,
#       %MNAU raw, ReMNAU raw, Engineered, Combined.
#   * Each classification task is analysed independently.
#   * There is NO K-means and NO k-selection here: the archaeological task label
#     itself is the grouping variable.
#   * Median imputation and z-standardization are estimated separately inside
#     each task/feature-space labelled dataset.
#   * For >2-D spaces PCA is fitted to the standardized labelled task data and
#     used only for visualization/interpretation; formal multivariate tests use
#     the full standardized feature matrix.
#   * 2-D group ellipses are 90% concentration/data ellipses based on each
#     task-class covariance matrix and chi-square(2) Mahalanobis contours.
#   * Unknown/Unkown and Sepulchral Cave/Cuevas Sepulcrales do NOT enter the
#     task-label tests. They are projected afterward using task-fitted
#     preprocessing and receive a descriptive nearest-class-centroid label.
#   * Historical/early named records remain ordinary in-sample labelled records
#     whenever they belong to the task.
#
# REQUIRED PACKAGES:
#   tidyverse, cluster, vegan, ggrepel
# ============================================================================== 

# ------------------------------------------------------------------------------
# 0. Paths and startup diagnostics
# ------------------------------------------------------------------------------

RUN_WD <- getwd()
INPUT_FILE <- file.path(RUN_WD, "final", "tapho_db_sum.csv")
ROOT_OUT <- file.path(RUN_WD, "classification_tasks_7spaces_R_outputs")
FIG_OUT <- file.path(ROOT_OUT, "figures")

cat("\n=== 3 CLASSIFICATION TASKS x 7 FEATURE SPACES ===\n")
cat("Working directory :", RUN_WD, "\n")
cat("Input file        :", INPUT_FILE, "\n")
cat("Output directory  :", ROOT_OUT, "\n\n")

if (!file.exists(INPUT_FILE)) {
  stop(
    "Input file not found: ", INPUT_FILE, "\n",
    "Set the working directory to the project root containing final/tapho_db_sum.csv."
  )
}

dir.create(ROOT_OUT, showWarnings = TRUE, recursive = TRUE)
dir.create(FIG_OUT, showWarnings = TRUE, recursive = TRUE)

required_packages <- c("tidyverse", "cluster", "vegan", "ggrepel")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages) > 0) {
  stop("Missing R package(s): ", paste(missing_packages, collapse = ", "))
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(cluster)
  library(vegan)
  library(ggrepel)
})

set.seed(42)
SEED <- 42
B_PERM <- 4999
ELLIPSE_LEVEL <- 0.90
PCTMNAU_MAX <- 1.0
REDISTRIBUTE_BILATERAL_INDET <- TRUE
DROP_REDISTRIBUTED_INDET_FROM_ANALYSIS <- TRUE
EXCLUDE_SIMA_PNAS <- TRUE

writeLines(
  c(
    paste("Run started:", Sys.time()),
    paste("Working directory:", RUN_WD),
    paste("Input:", normalizePath(INPUT_FILE, winslash = "/", mustWork = TRUE))
  ),
  file.path(ROOT_OUT, "RUN_STARTED.txt")
)

# ------------------------------------------------------------------------------
# 1. Read summed data directly
# ------------------------------------------------------------------------------

d_raw <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

required_cols <- c(
  "site_name", "taphonomic_context", "funerary_context",
  "Mean_part_abundance", "mnau_heip_evenness"
)
missing_cols <- setdiff(required_cols, names(d_raw))
if (length(missing_cols) > 0) {
  stop("Missing required column(s): ", paste(missing_cols, collapse = ", "))
}

if (!"layer_name" %in% names(d_raw)) d_raw$layer_name <- NA_character_

d <- d_raw %>% mutate(record_id = row_number(), .before = 1)
C_VAR <- "Mean_part_abundance"
E_VAR <- "mnau_heip_evenness"

# ------------------------------------------------------------------------------
# 2. Bilateral indeterminate redistribution FIRST
# ------------------------------------------------------------------------------

find_bilateral_triplets <- function(data_names, prefix, feature_type) {
  indet <- data_names[
    str_starts(data_names, prefix) & str_ends(data_names, "_indet")
  ]
  if (length(indet) == 0) return(tibble())

  tibble(
    feature_type = feature_type,
    indet_col = indet,
    base = str_remove(indet, "_indet$"),
    left_col = paste0(base, "_left"),
    right_col = paste0(base, "_right")
  ) %>%
    filter(left_col %in% data_names, right_col %in% data_names) %>%
    mutate(anatomical_part = str_remove(base, paste0("^", prefix)))
}

pct_pairs <- find_bilateral_triplets(
  names(d), "ProportionalRep_MNIbased_", "%MNAU"
)
rem_pairs <- find_bilateral_triplets(
  names(d), "ReMNAU_", "ReMNAU"
)
indet_pairs <- bind_rows(pct_pairs, rem_pairs)

redistribute_bilateral_pair <- function(
    dat, indet_col, left_col, right_col,
    feature_type, anatomical_part, max_value = Inf) {

  i_before <- dat[[indet_col]]
  l_before <- dat[[left_col]]
  r_before <- dat[[right_col]]

  i_after <- i_before
  l_after <- l_before
  r_after <- r_before
  audits <- list()
  ai <- 1L

  rows <- which(is.finite(i_before) & i_before > 0)

  for (j in rows) {
    amount <- i_before[j]
    l0 <- if (is.na(l_before[j])) 0 else l_before[j]
    r0 <- if (is.na(r_before[j])) 0 else r_before[j]

    cap_l <- if (is.finite(max_value)) max(0, max_value - l0) else Inf
    cap_r <- if (is.finite(max_value)) max(0, max_value - r0) else Inf

    # Initial 50:50 allocation.
    add_l <- if (is.finite(cap_l)) min(amount / 2, cap_l) else amount / 2
    add_r <- if (is.finite(cap_r)) min(amount / 2, cap_r) else amount / 2
    remaining <- amount - add_l - add_r

    # Transfer any unassigned amount to available capacity.
    if (remaining > 0) {
      cap_l2 <- if (is.finite(cap_l)) max(0, cap_l - add_l) else Inf
      take_l <- if (is.finite(cap_l2)) min(remaining, cap_l2) else remaining
      add_l <- add_l + take_l
      remaining <- remaining - take_l
    }
    if (remaining > 0) {
      cap_r2 <- if (is.finite(cap_r)) max(0, cap_r - add_r) else Inf
      take_r <- if (is.finite(cap_r2)) min(remaining, cap_r2) else remaining
      add_r <- add_r + take_r
      remaining <- remaining - take_r
    }

    l_after[j] <- l0 + add_l
    r_after[j] <- r0 + add_r
    i_after[j] <- max(0, remaining)

    if (is.finite(max_value)) {
      if (l0 <= max_value + 1e-12) l_after[j] <- min(l_after[j], max_value)
      if (r0 <= max_value + 1e-12) r_after[j] <- min(r_after[j], max_value)
    }

    audits[[ai]] <- tibble(
      record_id = dat$record_id[j],
      site_name = dat$site_name[j],
      feature_type = feature_type,
      anatomical_part = anatomical_part,
      indet_col = indet_col,
      left_col = left_col,
      right_col = right_col,
      indet_before = i_before[j],
      left_before = l_before[j],
      right_before = r_before[j],
      assigned_left = add_l,
      assigned_right = add_r,
      residual_indet = i_after[j],
      left_after = l_after[j],
      right_after = r_after[j]
    )
    ai <- ai + 1L
  }

  dat[[indet_col]] <- i_after
  dat[[left_col]] <- l_after
  dat[[right_col]] <- r_after

  list(
    data = dat,
    audit = if (length(audits) > 0) bind_rows(audits) else tibble()
  )
}

indet_audits <- list()
if (REDISTRIBUTE_BILATERAL_INDET && nrow(indet_pairs) > 0) {
  for (ii in seq_len(nrow(indet_pairs))) {
    pr <- indet_pairs[ii, ]
    maxv <- if (pr$feature_type == "%MNAU") PCTMNAU_MAX else Inf
    rr <- redistribute_bilateral_pair(
      d,
      pr$indet_col, pr$left_col, pr$right_col,
      pr$feature_type, pr$anatomical_part,
      max_value = maxv
    )
    d <- rr$data
    indet_audits[[ii]] <- rr$audit
  }
}

indet_audit <- bind_rows(indet_audits)
write_csv(indet_pairs, file.path(ROOT_OUT, "indet_bilateral_pairs_detected.csv"))
write_csv(indet_audit, file.path(ROOT_OUT, "indet_redistribution_audit.csv"))

if (nrow(indet_audit) > 0) {
  indet_summary <- indet_audit %>%
    group_by(feature_type, anatomical_part, indet_col, left_col, right_col) %>%
    summarise(
      n_records = n(),
      total_indet_before = sum(indet_before, na.rm = TRUE),
      total_assigned_left = sum(assigned_left, na.rm = TRUE),
      total_assigned_right = sum(assigned_right, na.rm = TRUE),
      total_residual_indet = sum(residual_indet, na.rm = TRUE),
      n_with_residual = sum(residual_indet > 1e-12, na.rm = TRUE),
      .groups = "drop"
    )
} else {
  indet_summary <- tibble()
}
write_csv(indet_summary, file.path(ROOT_OUT, "indet_redistribution_summary.csv"))

# ------------------------------------------------------------------------------
# 3. Feature spaces
# ------------------------------------------------------------------------------

prop_cols <- names(d)[str_starts(names(d), "ProportionalRep_MNIbased_")]
rem_cols <- names(d)[str_starts(names(d), "ReMNAU_")]

if (DROP_REDISTRIBUTED_INDET_FROM_ANALYSIS) {
  prop_drop <- indet_pairs %>% filter(feature_type == "%MNAU") %>% pull(indet_col)
  rem_drop <- indet_pairs %>% filter(feature_type == "ReMNAU") %>% pull(indet_col)
  prop_cols <- setdiff(prop_cols, prop_drop)
  rem_cols <- setdiff(rem_cols, rem_drop)
}

eng_cols <- c(
  "mnau_proximal_appendicular_mean",
  "mnau_lower_appendicular_mean",
  "mnau_distal_appendicular_mean",
  "mnau_appendicular_mean",
  "mnau_postcranial_total_mean",
  "mnau_top2_share_mcnaughton",
  "mnau_upper_appendicular_mean",
  "low_density_survival_index",
  "mnau_vertebrae_to_thorax_ratio",
  "all_sections_dominance",
  "mnau_lower_upper_appendicular_diff",
  "mnau_heip_evenness",
  "mnau_girdle_appendicular_logratio",
  "postcranial_continuity_hm",
  "mnau_girdle_to_appendicular_ratio",
  "mnau_gini",
  "density_representation_r2",
  "mnau_cv",
  "mnau_girdle_appendicular_diff",
  "mnau_full_axial_mean",
  "mnau_arms",
  "dominance_gap_all",
  "mnau_girdle_share_of_appendicular",
  "section_completeness_025_all",
  "whole_body_continuity_hm",
  "density_representation_slope",
  "mnau_limb_shaft_proxy_mean",
  "density_residual_sd"
)
eng_cols <- intersect(eng_cols, names(d))

BASE_FEATURE_SETS <- list(
  `C only` = C_VAR,
  `Heip evenness only` = E_VAR,
  `C + Heip evenness` = c(C_VAR, E_VAR),
  `%MNAU raw` = prop_cols,
  `ReMNAU raw` = rem_cols,
  `Engineered` = eng_cols,
  `Combined` = unique(c(prop_cols, rem_cols, eng_cols))
)

# ------------------------------------------------------------------------------
# 4. Archaeological labels and three classification tasks
# ------------------------------------------------------------------------------

class4_label <- function(x) {
  case_when(
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)"
    ) ~ "Carnivore",
    x == "Funerary Context" ~ "Funerary Context",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

norm_fun_subtype <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) | str_trim(x) == "" ~ "Funerary Context",
    xl == "inhumation single" ~ "Single inhumation",
    str_starts(xl, "inhumation single; inhumation multiple") ~ "Single + multiple",
    xl == "inhumation multiple" ~ "Multiple inhumation",
    xl == "inhumation single; collective burial" ~ "Single + collective",
    str_starts(xl, "collective burial") & str_detect(xl, "secondary") ~ "Collective-secondary",
    str_starts(xl, "collective burial") ~ "Collective burial",
    xl == "cremation" ~ "Cremation",
    xl == "funerary caching" ~ "Funerary caching",
    xl == "possible burial" ~ "Possible burial",
    xl == "no inhumation" ~ "No inhumation",
    TRUE ~ str_trim(x)
  )
}

d <- d %>%
  mutate(
    label_4class = class4_label(taphonomic_context),
    label_cannibalism_vs_fc = case_when(
      label_4class == "Cannibalism" ~ "Cannibalism",
      label_4class == "Funerary Context" ~ "Funerary Context",
      TRUE ~ NA_character_
    ),
    label_fc_vs_rest = case_when(
      label_4class == "Funerary Context" ~ "Funerary Context",
      label_4class %in% c("Cannibalism", "Carnivore", "Geological transport") ~ "Rest",
      TRUE ~ NA_character_
    ),
    funerary_subtype_norm = norm_fun_subtype(funerary_context),
    secondary_context = case_when(
      label_4class == "Funerary Context" ~ funerary_subtype_norm,
      !is.na(label_4class) ~ label_4class,
      TRUE ~ NA_character_
    ),
    special_type = case_when(
      taphonomic_context %in% c("Unknown", "Unkown") ~ "Unknown",
      taphonomic_context %in% c("Sepulchral Cave", "Cuevas Sepulcrales") ~ "Sepulchral",
      TRUE ~ NA_character_
    )
  )

if (EXCLUDE_SIMA_PNAS) {
  d <- d %>%
    mutate(
      excluded_sima_pnas = special_type == "Unknown" &
        str_to_lower(str_squish(site_name)) == str_to_lower("Sima de los Huesos PNAS")
    )
} else {
  d <- d %>% mutate(excluded_sima_pnas = FALSE)
}

TASKS <- list(
  `4class` = list(
    label_col = "label_4class",
    classes = c("Cannibalism", "Carnivore", "Funerary Context", "Geological transport")
  ),
  `cannibalism_vs_fc` = list(
    label_col = "label_cannibalism_vs_fc",
    classes = c("Cannibalism", "Funerary Context")
  ),
  `fc_vs_rest` = list(
    label_col = "label_fc_vs_rest",
    classes = c("Funerary Context", "Rest")
  )
)

# Named historical/early panels remain IN SAMPLE when task-eligible.
historical <- c(
  "La Chapelle-aux-Saints", "La Ferrassie", "Regourdou", "Roc de Marsal",
  "Shanidar Cave", "Krapina", "La Quina", "Moula-Guercy", "Grotta Guattari",
  "Mladeč Caves", "Cro-Magnon I", "Brno II", "Teshik-Tash Cave",
  "Cueva de los Torrejones", "Crow Creek", "Goat’s Hole (Paviland Cave)"
)

early <- c(
  "El Sidrón J1", "Mancos 5MT-10010 Feature 3", "Yellow Jacket 5MT-3",
  "Qafzeh Cave", "Tabun Cave (Mugharet et-Tabun)", "Mugharet es-Skhul",
  "Grotte de Fontbrégoua", "Cova Gran de Santa Linya", "Sima de las Palomas",
  "Kebara Cave", "La Ferrassie"
)

test_names <- union(historical, early)

d <- d %>%
  mutate(
    named_panel = case_when(
      site_name %in% historical & site_name %in% early ~ "Both panels",
      site_name %in% historical ~ "Historical",
      site_name %in% early ~ "Early",
      TRUE ~ NA_character_
    )
  )

# ------------------------------------------------------------------------------
# 5. Helpers
# ------------------------------------------------------------------------------

informative_vars <- function(data, vars) {
  vars[vapply(vars, function(v) {
    x <- data[[v]]
    sum(is.finite(x)) > 1 && n_distinct(x[is.finite(x)]) > 1
  }, logical(1))]
}

fit_preprocess <- function(train, newdata, vars) {
  med <- map_dbl(vars, function(v) median(train[[v]], na.rm = TRUE))
  names(med) <- vars
  med[!is.finite(med)] <- 0

  make_matrix <- function(dat) {
    x <- as.data.frame(dat[, vars, drop = FALSE])
    for (v in vars) {
      bad <- !is.finite(x[[v]])
      x[[v]][bad] <- med[[v]]
    }
    as.matrix(x)
  }

  xtr0 <- make_matrix(train)
  xnew0 <- make_matrix(newdata)
  mu <- colMeans(xtr0)
  sdv <- apply(xtr0, 2, sd)
  sdv[!is.finite(sdv) | sdv == 0] <- 1

  standardize <- function(x) sweep(sweep(x, 2, mu, "-"), 2, sdv, "/")

  list(
    X_train = standardize(xtr0),
    X_new = standardize(xnew0),
    X_train_original = xtr0,
    X_new_original = xnew0,
    medians = med,
    means = mu,
    sds = sdv
  )
}

ellipse_concentration <- function(x, y, level = ELLIPSE_LEVEL, n_points = 200) {
  xy <- cbind(x, y)
  xy <- xy[complete.cases(xy), , drop = FALSE]
  if (nrow(xy) < 3) return(NULL)

  mu <- colMeans(xy)
  S <- cov(xy)
  if (any(!is.finite(S))) return(NULL)

  ev <- eigen(S, symmetric = TRUE)
  radii <- sqrt(qchisq(level, df = 2) * pmax(ev$values, 0))
  theta <- seq(0, 2 * pi, length.out = n_points)
  unit <- rbind(cos(theta), sin(theta))
  ell <- t(ev$vectors %*% diag(radii) %*% unit)

  tibble(x = ell[, 1] + mu[1], y = ell[, 2] + mu[2])
}

concentration_interval_1d <- function(x, level = ELLIPSE_LEVEL) {
  x <- x[is.finite(x)]
  if (length(x) == 0) return(tibble(mean = NA_real_, lower = NA_real_, upper = NA_real_))
  if (length(x) == 1) return(tibble(mean = x[1], lower = NA_real_, upper = NA_real_))
  m <- mean(x)
  s <- sd(x)
  crit <- qnorm((1 + level) / 2)
  tibble(mean = m, lower = m - crit * s, upper = m + crit * s)
}

cliffs_delta <- function(x, y) {
  x <- x[is.finite(x)]
  y <- y[is.finite(y)]
  if (length(x) == 0 || length(y) == 0) return(NA_real_)
  mean(outer(x, y, ">")) - mean(outer(x, y, "<"))
}

epsilon_squared_kw <- function(H, n, k) {
  if (!is.finite(H) || n <= k) return(NA_real_)
  max(0, (H - k + 1) / (n - k))
}

nearest_centroid <- function(X, labels, Xnew = X) {
  labs <- factor(labels)
  lev <- levels(labs)
  centers <- map_dfr(lev, function(g) {
    ix <- labs == g
    tibble(label = g, center = list(colMeans(X[ix, , drop = FALSE])))
  })

  Cmat <- do.call(rbind, centers$center)
  rownames(Cmat) <- centers$label

  dmat <- sapply(seq_len(nrow(Cmat)), function(j) {
    sqrt(rowSums((Xnew - matrix(Cmat[j, ], nrow(Xnew), ncol(Xnew), byrow = TRUE))^2))
  })
  if (is.vector(dmat)) dmat <- matrix(dmat, ncol = nrow(Cmat))
  colnames(dmat) <- rownames(Cmat)

  nearest_idx <- max.col(-dmat, ties.method = "first")
  nearest_lab <- colnames(dmat)[nearest_idx]
  nearest_dist <- dmat[cbind(seq_len(nrow(dmat)), nearest_idx)]

  second_dist <- apply(dmat, 1, function(z) {
    zs <- sort(z)
    if (length(zs) >= 2) zs[2] else NA_real_
  })

  list(
    centers = Cmat,
    distances = dmat,
    nearest_label = nearest_lab,
    nearest_distance = nearest_dist,
    second_distance = second_dist,
    distance_ratio = nearest_dist / second_dist
  )
}

safe_betadisper <- function(X, labels, B = B_PERM) {
  out <- tibble(Dispersion_F = NA_real_, Dispersion_p = NA_real_)
  labs <- factor(labels)
  if (nlevels(labs) < 2 || any(table(labs) < 2)) return(out)

  bd <- tryCatch(
    vegan::betadisper(dist(X), labs),
    error = function(e) NULL
  )
  if (is.null(bd)) return(out)

  bp <- tryCatch(
    vegan::permutest(bd, permutations = B),
    error = function(e) NULL
  )
  if (is.null(bp)) return(out)

  tibble(
    Dispersion_F = as.numeric(bp$tab$F[1]),
    Dispersion_p = as.numeric(bp$tab$`Pr(>F)`[1])
  )
}

class_palette <- c(
  "Funerary Context" = "#0072B2",
  "Cannibalism" = "#D55E00",
  "Carnivore" = "#009E73",
  "Geological transport" = "#CC79A7",
  "Rest" = "#D55E00"
)

class_shapes <- c(
  "Funerary Context" = 16,
  "Cannibalism" = 17,
  "Carnivore" = 15,
  "Geological transport" = 18,
  "Rest" = 17
)

special_colours <- c("Unknown" = "#222222", "Sepulchral" = "#E69F00")
special_shapes <- c("Unknown" = 4, "Sepulchral" = 8)

# ------------------------------------------------------------------------------
# 6. Storage
# ------------------------------------------------------------------------------

sample_partitions <- list()
space_summaries <- list()
class_profiles <- list()
univariate_tests <- list()
pairwise_tests <- list()
centroid_performance <- list()
labelled_assignments <- list()
special_assignments <- list()
named_assignments <- list()
pca_correlations <- list()
pca_loadings <- list()
secondary_compositions <- list()

special_all <- d %>%
  filter(!is.na(special_type), !excluded_sima_pnas)

# ------------------------------------------------------------------------------
# 7. Run each classification task independently
# ------------------------------------------------------------------------------

for (task_name in names(TASKS)) {
  task_spec <- TASKS[[task_name]]
  label_col <- task_spec$label_col

  task_dir <- file.path(ROOT_OUT, task_name)
  task_fig_dir <- file.path(task_dir, "figures")
  dir.create(task_dir, showWarnings = FALSE, recursive = TRUE)
  dir.create(task_fig_dir, showWarnings = FALSE, recursive = TRUE)

  task_data <- d %>%
    filter(!is.na(.data[[label_col]])) %>%
    mutate(Task_label = factor(.data[[label_col]], levels = task_spec$classes))

  sample_partitions[[task_name]] <- task_data %>%
    count(Task_label, name = "n") %>%
    mutate(Task = task_name, .before = 1)

  # Detailed subtype/process composition inside each task class.
  secondary_compositions[[task_name]] <- task_data %>%
    count(Task_label, secondary_context, name = "n") %>%
    group_by(Task_label) %>%
    mutate(
      class_n = sum(n),
      percent_within_task_class = 100 * n / class_n
    ) %>%
    ungroup() %>%
    mutate(Task = task_name, .before = 1)

  # Seven spaces are re-screened for informativeness inside each task.
  task_feature_sets <- imap(BASE_FEATURE_SETS, function(vars, nm) {
    informative_vars(task_data, vars)
  })

  feature_manifest <- imap_dfr(task_feature_sets, function(vars, nm) {
    tibble(Task = task_name, Feature_space = nm, variable = vars)
  })
  write_csv(feature_manifest, file.path(task_dir, "feature_manifest.csv"))

  for (space in names(task_feature_sets)) {
    vars <- task_feature_sets[[space]]
    if (length(vars) == 0) next

    pp <- fit_preprocess(task_data, special_all, vars)
    X <- pp$X_train
    Xs <- pp$X_new
    labs <- task_data$Task_label
    p <- ncol(X)

    # --------------------------------------------------------------------------
    # Full-space geometry: task-label silhouette, PERMANOVA, dispersion
    # --------------------------------------------------------------------------

    sil <- NA_real_
    if (nlevels(labs) >= 2 && nrow(X) > nlevels(labs)) {
      sil_obj <- tryCatch(
        cluster::silhouette(as.integer(labs), dist(X)),
        error = function(e) NULL
      )
      if (!is.null(sil_obj)) sil <- mean(sil_obj[, 3])
    }

    dd <- dist(X)
    ad <- vegan::adonis2(
      dd ~ label,
      data = tibble(label = labs),
      permutations = B_PERM
    )
    disp <- safe_betadisper(X, labs, B_PERM)

    nc <- nearest_centroid(X, labs, X)
    in_sample_match <- nc$nearest_label == as.character(labs)

    # PCA for correlations/display when p >= 2.
    if (p >= 2) {
      pc <- prcomp(X, center = FALSE, scale. = FALSE)
      Z <- predict(pc, X)
      Zs <- if (nrow(Xs) > 0) predict(pc, Xs) else matrix(numeric(0), nrow = 0, ncol = ncol(Z))
      var_exp <- summary(pc)$importance[2, ]

      rC <- suppressWarnings(cor.test(Z[, 1], task_data[[C_VAR]], method = "pearson"))
      okE <- complete.cases(Z[, 1], task_data[[E_VAR]])
      rE <- if (sum(okE) >= 3) suppressWarnings(cor.test(Z[okE, 1], task_data[[E_VAR]][okE])) else NULL

      pca_correlations[[paste(task_name, space)]] <- tibble(
        Task = task_name,
        Feature_space = space,
        n_features = p,
        PC1_variance = var_exp[1],
        PC2_variance = var_exp[2],
        r_PC1_C = unname(rC$estimate),
        p_PC1_C = rC$p.value,
        r_PC1_Heip = if (is.null(rE)) NA_real_ else unname(rE$estimate),
        p_PC1_Heip = if (is.null(rE)) NA_real_ else rE$p.value
      )

      loads <- as.data.frame(pc$rotation) %>%
        rownames_to_column("variable") %>%
        as_tibble() %>%
        mutate(Task = task_name, Feature_space = space, .before = 1)
      pca_loadings[[paste(task_name, space)]] <- loads
    } else {
      pc <- NULL
      Z <- matrix(X[, 1], ncol = 1)
      Zs <- if (nrow(Xs) > 0) matrix(Xs[, 1], ncol = 1) else matrix(numeric(0), ncol = 1)

      pca_correlations[[paste(task_name, space)]] <- tibble(
        Task = task_name,
        Feature_space = space,
        n_features = 1,
        PC1_variance = 1,
        PC2_variance = NA_real_,
        r_PC1_C = suppressWarnings(cor(X[, 1], task_data[[C_VAR]], use = "complete.obs")),
        p_PC1_C = NA_real_,
        r_PC1_Heip = suppressWarnings(cor(X[, 1], task_data[[E_VAR]], use = "complete.obs")),
        p_PC1_Heip = NA_real_
      )
    }

    space_summaries[[paste(task_name, space)]] <- tibble(
      Task = task_name,
      Feature_space = space,
      n = nrow(X),
      n_features = p,
      n_classes = nlevels(labs),
      Mean_true_label_silhouette = sil,
      PERMANOVA_F = ad$F[1],
      PERMANOVA_R2 = ad$R2[1],
      PERMANOVA_p = ad$`Pr(>F)`[1],
      Dispersion_F = disp$Dispersion_F,
      Dispersion_p = disp$Dispersion_p,
      In_sample_nearest_centroid_match = mean(in_sample_match)
    )

    # --------------------------------------------------------------------------
    # Class profiles and univariate C/Heip statistics
    # --------------------------------------------------------------------------

    prof <- task_data %>%
      mutate(
        Task_label = labs,
        Nearest_centroid_label = nc$nearest_label,
        Nearest_centroid_distance = nc$nearest_distance,
        Nearest_second_distance_ratio = nc$distance_ratio
      ) %>%
      group_by(Task_label) %>%
      summarise(
        n = n(),
        Median_C = median(.data[[C_VAR]], na.rm = TRUE),
        IQR_C = IQR(.data[[C_VAR]], na.rm = TRUE),
        Median_Heip = median(.data[[E_VAR]], na.rm = TRUE),
        IQR_Heip = IQR(.data[[E_VAR]], na.rm = TRUE),
        Mean_nearest_centroid_distance = mean(Nearest_centroid_distance),
        In_sample_nearest_centroid_match = mean(Nearest_centroid_label == as.character(Task_label)),
        .groups = "drop"
      ) %>%
      mutate(Task = task_name, Feature_space = space, .before = 1)
    class_profiles[[paste(task_name, space)]] <- prof

    for (v in c(C_VAR, E_VAR)) {
      datv <- task_data %>%
        transmute(label = labs, value = .data[[v]]) %>%
        filter(is.finite(value), !is.na(label))

      if (nlevels(droplevels(datv$label)) == 2) {
        lev <- levels(droplevels(datv$label))
        x <- datv$value[datv$label == lev[1]]
        y <- datv$value[datv$label == lev[2]]
        wt <- wilcox.test(x, y, exact = FALSE)

        univariate_tests[[paste(task_name, space, v)]] <- tibble(
          Task = task_name,
          Feature_space = space,
          Variable = v,
          Test = "Wilcoxon rank-sum",
          Statistic = unname(wt$statistic),
          p = wt$p.value,
          Effect_size = cliffs_delta(x, y),
          Effect_size_name = paste0("Cliff_delta_", lev[1], "_vs_", lev[2])
        )
      } else {
        kw <- kruskal.test(value ~ label, data = datv)
        kgrp <- nlevels(droplevels(datv$label))
        univariate_tests[[paste(task_name, space, v)]] <- tibble(
          Task = task_name,
          Feature_space = space,
          Variable = v,
          Test = "Kruskal-Wallis",
          Statistic = unname(kw$statistic),
          p = kw$p.value,
          Effect_size = epsilon_squared_kw(unname(kw$statistic), nrow(datv), kgrp),
          Effect_size_name = "epsilon_squared"
        )

        pw <- pairwise.wilcox.test(
          datv$value, datv$label,
          p.adjust.method = "BH",
          exact = FALSE
        )
        pm <- as.data.frame(as.table(pw$p.value)) %>%
          filter(!is.na(Freq)) %>%
          transmute(
            Task = task_name,
            Feature_space = space,
            Variable = v,
            Group1 = Var1,
            Group2 = Var2,
            p_BH = Freq
          )
        pairwise_tests[[paste(task_name, space, v)]] <- pm
      }
    }

    # --------------------------------------------------------------------------
    # Site-level labelled assignments and special projections
    # --------------------------------------------------------------------------

    labelled_out <- task_data %>%
      transmute(
        Task = task_name,
        Feature_space = space,
        record_id, site_name, layer_name,
        taphonomic_context, funerary_context,
        secondary_context,
        True_task_label = as.character(labs),
        Nearest_centroid_label = nc$nearest_label,
        Nearest_centroid_match = nc$nearest_label == as.character(labs),
        Distance_to_nearest_centroid = nc$nearest_distance,
        Distance_ratio_nearest_to_second = nc$distance_ratio,
        PC1 = Z[, 1],
        PC2 = if (ncol(Z) >= 2) Z[, 2] else NA_real_
      )
    labelled_assignments[[paste(task_name, space)]] <- labelled_out

    if (nrow(special_all) > 0) {
      ns <- nearest_centroid(X, labs, Xs)
      special_out <- special_all %>%
        transmute(
          Task = task_name,
          Feature_space = space,
          record_id, site_name, layer_name,
          special_type,
          taphonomic_context,
          Nearest_task_centroid = ns$nearest_label,
          Distance_to_nearest_centroid = ns$nearest_distance,
          Distance_ratio_nearest_to_second = ns$distance_ratio,
          PC1 = Zs[, 1],
          PC2 = if (ncol(Zs) >= 2) Zs[, 2] else NA_real_
        )
      special_assignments[[paste(task_name, space)]] <- special_out
    }

    named_idx <- !is.na(task_data$named_panel)
    if (any(named_idx)) {
      named_assignments[[paste(task_name, space)]] <- labelled_out[named_idx, ] %>%
        mutate(named_panel = task_data$named_panel[named_idx], .after = site_name)
    }

    # --------------------------------------------------------------------------
    # Plot 1: labelled task groups
    # --------------------------------------------------------------------------

    if (p == 1) {
      vf <- tibble(
        x = pp$X_train_original[, 1],
        label = labs,
        label_y = as.numeric(labs)
      )

      intervals <- vf %>%
        group_by(label) %>%
        group_modify(~ concentration_interval_1d(.x$x, ELLIPSE_LEVEL)) %>%
        ungroup() %>%
        mutate(label_y = match(as.character(label), levels(labs)))

      gp <- ggplot(vf, aes(x = x, y = label_y, colour = label)) +
        geom_jitter(height = 0.10, width = 0, alpha = 0.65, size = 2.2) +
        geom_segment(
          data = intervals,
          aes(x = lower, xend = upper, y = label_y, yend = label_y, colour = label),
          linewidth = 1.0,
          inherit.aes = FALSE,
          na.rm = TRUE
        ) +
        geom_point(
          data = intervals,
          aes(x = mean, y = label_y, colour = label),
          size = 3.0,
          inherit.aes = FALSE
        ) +
        scale_y_continuous(
          breaks = seq_along(levels(labs)),
          labels = levels(labs),
          expand = expansion(mult = c(0.15, 0.10))
        ) +
        scale_colour_manual(values = class_palette) +
        labs(
          x = vars[1], y = NULL,
          title = paste0(task_name, " | ", space),
          subtitle = "Task labels shown directly; bars are 90% concentration intervals"
        ) +
        theme_bw()

    } else {
      if (p == 2 && space == "C + Heip evenness") {
        vf <- tibble(
          x = pp$X_train_original[, 1],
          y = pp$X_train_original[, 2],
          label = labs
        )
        xlab <- "Mean abundance C"
        ylab <- "Heip evenness"
      } else {
        vf <- tibble(x = Z[, 1], y = Z[, 2], label = labs)
        ve <- summary(pc)$importance[2, ]
        xlab <- paste0("PC1 (", round(100 * ve[1], 1), "%)")
        ylab <- paste0("PC2 (", round(100 * ve[2], 1), "%)")
      }

      ell <- map_dfr(levels(labs), function(g) {
        q <- vf %>% filter(label == g)
        e <- ellipse_concentration(q$x, q$y, ELLIPSE_LEVEL)
        if (is.null(e)) return(tibble())
        mutate(e, label = factor(g, levels = levels(labs)))
      })

      gp <- ggplot(vf, aes(x, y, colour = label, shape = label)) +
        geom_point(size = 2.6, alpha = 0.80) +
        geom_path(
          data = ell,
          aes(x, y, colour = label, group = label),
          inherit.aes = FALSE,
          linewidth = 0.9
        ) +
        scale_colour_manual(values = class_palette) +
        scale_shape_manual(values = class_shapes) +
        labs(
          x = xlab, y = ylab,
          title = paste0(task_name, " | ", space),
          subtitle = if (p > 2)
            "PCA display only; 90% group-specific concentration ellipses"
          else
            "90% group-specific concentration ellipses"
        ) +
        theme_bw()
    }

    ggsave(
      file.path(task_fig_dir, paste0("labels_", make.names(space), ".png")),
      gp, width = 9.5, height = 6.8, dpi = 300
    )

    # --------------------------------------------------------------------------
    # Plot 2: special Unknown/Sepulchral projections over labelled task geometry
    # --------------------------------------------------------------------------

    if (nrow(special_all) > 0) {
      if (p == 1) {
        sf <- tibble(
          x = pp$X_new_original[, 1],
          special_type = special_all$special_type,
          site_name = special_all$site_name
        )

        gsp <- ggplot(vf, aes(x = x, y = label_y, colour = label)) +
          geom_jitter(height = 0.10, width = 0, alpha = 0.30, size = 1.8) +
          geom_point(
            data = sf,
            aes(x = x, colour = special_type, shape = special_type),
            y = 0.45,
            inherit.aes = FALSE, size = 3.0, stroke = 1
          ) +
          ggrepel::geom_text_repel(
            data = sf,
            aes(x = x, label = site_name),
            y = 0.45,
            inherit.aes = FALSE, size = 2.1, max.overlaps = 40
          ) +
          scale_y_continuous(
            breaks = c(0.45, seq_along(levels(labs))),
            labels = c("Special", levels(labs)),
            expand = expansion(mult = c(0.08, 0.10))
          ) +
          scale_colour_manual(values = c(class_palette, special_colours)) +
          scale_shape_manual(values = special_shapes) +
          labs(
            x = vars[1], y = NULL,
            title = paste0(task_name, " | ", space, " | special-site projection")
          ) +
          theme_bw()
      } else {
        if (p == 2 && space == "C + Heip evenness") {
          sf <- tibble(
            x = pp$X_new_original[, 1],
            y = pp$X_new_original[, 2],
            special_type = special_all$special_type,
            site_name = special_all$site_name
          )
        } else {
          sf <- tibble(
            x = Zs[, 1], y = Zs[, 2],
            special_type = special_all$special_type,
            site_name = special_all$site_name
          )
        }

        gsp <- ggplot() +
          geom_point(
            data = vf,
            aes(x, y, colour = label, shape = label),
            alpha = 0.25, size = 2.0
          ) +
          geom_path(
            data = ell,
            aes(x, y, colour = label, group = label),
            linewidth = 0.8
          ) +
          geom_point(
            data = sf,
            aes(x, y, colour = special_type, shape = special_type),
            size = 3.0, stroke = 1
          ) +
          ggrepel::geom_text_repel(
            data = sf,
            aes(x, y, label = site_name),
            size = 2.2, max.overlaps = 40
          ) +
          scale_colour_manual(values = c(class_palette, special_colours)) +
          scale_shape_manual(values = c(class_shapes, special_shapes)) +
          labs(
            x = xlab, y = ylab,
            title = paste0(task_name, " | ", space, " | Unknown/Sepulchral projection"),
            subtitle = "Special records did not enter task-label tests; nearest centroids are descriptive"
          ) +
          theme_bw()
      }

      ggsave(
        file.path(task_fig_dir, paste0("special_projection_", make.names(space), ".png")),
        gsp, width = 11, height = 7.4, dpi = 300
      )
    }

    # --------------------------------------------------------------------------
    # Plot 3: historical/early named sites highlighted in their in-sample task
    # --------------------------------------------------------------------------

    if (any(named_idx) && p >= 2) {
      if (p == 2 && space == "C + Heip evenness") {
        nf <- tibble(
          x = pp$X_train_original[named_idx, 1],
          y = pp$X_train_original[named_idx, 2],
          site_name = task_data$site_name[named_idx],
          named_panel = task_data$named_panel[named_idx]
        )
      } else {
        nf <- tibble(
          x = Z[named_idx, 1], y = Z[named_idx, 2],
          site_name = task_data$site_name[named_idx],
          named_panel = task_data$named_panel[named_idx]
        )
      }

      gnp <- ggplot() +
        geom_point(
          data = vf,
          aes(x, y, colour = label, shape = label),
          alpha = 0.22, size = 1.9
        ) +
        geom_path(
          data = ell,
          aes(x, y, colour = label, group = label),
          linewidth = 0.8
        ) +
        geom_point(
          data = nf,
          aes(x, y),
          shape = 21, fill = "white", colour = "black",
          size = 3.2, stroke = 1
        ) +
        ggrepel::geom_text_repel(
          data = nf,
          aes(x, y, label = site_name),
          size = 2.2, max.overlaps = 50
        ) +
        scale_colour_manual(values = class_palette) +
        scale_shape_manual(values = class_shapes) +
        labs(
          x = xlab, y = ylab,
          title = paste0(task_name, " | ", space, " | historical/early named sites"),
          subtitle = "Named records are part of the labelled task sample, not a holdout"
        ) +
        theme_bw()

      ggsave(
        file.path(task_fig_dir, paste0("named_historical_early_", make.names(space), ".png")),
        gnp, width = 11, height = 7.4, dpi = 300
      )
    }
  }
}

# ------------------------------------------------------------------------------
# 8. Consolidate outputs
# ------------------------------------------------------------------------------

sample_partition <- bind_rows(sample_partitions)
space_summary <- bind_rows(space_summaries)
class_profile <- bind_rows(class_profiles)
univariate <- bind_rows(univariate_tests)
pairwise <- bind_rows(pairwise_tests)
labelled_site_assignments <- bind_rows(labelled_assignments)
special_site_assignments <- bind_rows(special_assignments)
named_site_assignments <- bind_rows(named_assignments)
pca_corr <- bind_rows(pca_correlations)
loadings <- bind_rows(pca_loadings)
secondary_comp <- bind_rows(secondary_compositions)

write_csv(sample_partition, file.path(ROOT_OUT, "task_sample_partition.csv"))
write_csv(space_summary, file.path(ROOT_OUT, "task_feature_space_multivariate_statistics.csv"))
write_csv(class_profile, file.path(ROOT_OUT, "task_class_profiles_C_Heip_and_centroid_geometry.csv"))
write_csv(univariate, file.path(ROOT_OUT, "task_C_Heip_univariate_tests.csv"))
write_csv(pairwise, file.path(ROOT_OUT, "task_4class_pairwise_Wilcoxon_BH.csv"))
write_csv(labelled_site_assignments, file.path(ROOT_OUT, "labelled_site_task_geometry.csv"))
write_csv(special_site_assignments, file.path(ROOT_OUT, "Unknown_Sepulchral_task_projection.csv"))
write_csv(named_site_assignments, file.path(ROOT_OUT, "historical_early_named_task_geometry.csv"))
write_csv(pca_corr, file.path(ROOT_OUT, "task_PCA_correlations.csv"))
write_csv(loadings, file.path(ROOT_OUT, "task_PCA_loadings.csv"))
write_csv(secondary_comp, file.path(ROOT_OUT, "secondary_context_composition_within_task_classes.csv"))

# Cross-space summaries of special-site nearest task centroids.
if (nrow(special_site_assignments) > 0) {
  special_consensus <- special_site_assignments %>%
    count(Task, record_id, site_name, special_type, Nearest_task_centroid, name = "n_spaces") %>%
    group_by(Task, record_id, site_name, special_type) %>%
    mutate(total_spaces = sum(n_spaces), percent_spaces = 100 * n_spaces / total_spaces) %>%
    ungroup() %>%
    arrange(Task, site_name, desc(n_spaces))
  write_csv(special_consensus, file.path(ROOT_OUT, "Unknown_Sepulchral_nearest_class_consensus.csv"))
}

if (nrow(named_site_assignments) > 0) {
  named_consensus <- named_site_assignments %>%
    group_by(Task, record_id, site_name, named_panel, True_task_label) %>%
    summarise(
      Feature_spaces = n_distinct(Feature_space),
      Nearest_centroid_matches = sum(Nearest_centroid_match, na.rm = TRUE),
      Match_percent = 100 * mean(Nearest_centroid_match, na.rm = TRUE),
      Median_distance_ratio = median(Distance_ratio_nearest_to_second, na.rm = TRUE),
      .groups = "drop"
    )
  write_csv(named_consensus, file.path(ROOT_OUT, "historical_early_named_cross_space_summary.csv"))
}

# ------------------------------------------------------------------------------
# 9. Simple report-ready markdown
# ------------------------------------------------------------------------------

fmt_p <- function(p) {
  if (is.na(p)) return("NA")
  minp <- 1 / (B_PERM + 1)
  if (p <= minp + 1e-12) return(paste0("<=", format(minp, scientific = FALSE)))
  format(round(p, 4), nsmall = 4)
}

report_lines <- c(
  "# Three archaeological classification framings across seven feature spaces",
  "",
  "This analysis uses the archaeological task labels directly as the grouping variable; it does not perform K-means or select k. Each task is analysed independently in the same seven feature representations. PCA is visualization only for spaces with more than two variables, while PERMANOVA uses the full standardized feature matrix. Ellipses are 90% group-specific concentration/data ellipses and describe within-class dispersion rather than uncertainty in class means.",
  ""
)

for (task_name in names(TASKS)) {
  report_lines <- c(report_lines, paste0("## ", task_name), "")
  sp <- sample_partition %>% filter(Task == task_name)
  report_lines <- c(
    report_lines,
    paste0(
      "Sample: ",
      paste0(sp$Task_label, " n=", sp$n, collapse = "; "),
      "."
    ),
    "",
    "| Feature space | Label silhouette | PERMANOVA R2 | PERMANOVA p | Dispersion p | In-sample nearest-centroid match |",
    "|---|---:|---:|---:|---:|---:|"
  )

  ss <- space_summary %>% filter(Task == task_name)
  for (i in seq_len(nrow(ss))) {
    report_lines <- c(
      report_lines,
      paste0(
        "| ", ss$Feature_space[i],
        " | ", sprintf("%.3f", ss$Mean_true_label_silhouette[i]),
        " | ", sprintf("%.3f", ss$PERMANOVA_R2[i]),
        " | ", fmt_p(ss$PERMANOVA_p[i]),
        " | ", fmt_p(ss$Dispersion_p[i]),
        " | ", sprintf("%.1f%%", 100 * ss$In_sample_nearest_centroid_match[i]),
        " |"
      )
    )
  }
  report_lines <- c(report_lines, "")
}

report_lines <- c(
  report_lines,
  "## Interpretation guardrails",
  "",
  "- The task labels are predefined archaeological classes, so no cluster-label association test is appropriate here: the labels themselves define the plotted groups.",
  "- Mean silhouette of the true task labels is descriptive evidence of geometric compactness/separation, not classifier accuracy.",
  "- Nearest-centroid matches are in-sample descriptive geometry and are not cross-validated predictive performance.",
  "- PERMANOVA tests differences in multivariate location; its interpretation should be considered alongside the dispersion test.",
  "- 90% concentration ellipses describe within-class score dispersion and are not significance tests.",
  "- Unknown and Sepulchral nearest-centroid labels are descriptive affinities, not probabilities or validated archaeological classifications.",
  ""
)

writeLines(report_lines, file.path(ROOT_OUT, "REPORT_READY_three_classification_tasks.md"))

writeLines(
  c(
    paste("Run finished:", Sys.time()),
    paste("Outputs:", ROOT_OUT)
  ),
  file.path(ROOT_OUT, "RUN_FINISHED.txt")
)

cat("\n=== ANALYSIS FINISHED ===\n")
cat("Outputs written to:\n", ROOT_OUT, "\n")
cat("Main report:\n", file.path(ROOT_OUT, "REPORT_READY_three_classification_tasks.md"), "\n")
