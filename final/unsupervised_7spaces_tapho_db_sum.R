# ==============================================================================
# Unsupervised SPR analysis: 7 feature spaces
# DIRECT SUMMED DATASET; ALL KNOWN REFERENCE RECORDS INCLUDED IN CLUSTER FIT
#
# Input:
#   final/tapho_db_sum.csv
#
# Required packages:
#   tidyverse, cluster, vegan, ggrepel
#
# DESIGN:
# - K-means is label-blind: archaeological labels are NEVER used to fit clusters.
# - All known summed records in the four reference contexts are INCLUDED from the start,
#   including the historical / early named panels.
# - Unknown/Unkown records are excluded from preprocessing, k-selection and fitting,
#   then projected to the fitted centers afterward.
# - "Sima de los Huesos PNAS" is excluded from the Unknown projection.
# - tapho_db_sum is used DIRECTLY: there is no site_id requirement and no row collapse.
# - A synthetic record_id is created only for bookkeeping and never used as a feature.
# - C / abundance = Mean_part_abundance.
# - Evenness = mnau_heip_evenness (Heip evenness).
# - %MNAU uses stored ProportionalRep_MNIbased_* values directly.
# - ReMNAU uses stored ReMNAU_* values directly.
# - No adjusted %MNAU/ReMNAU transformation and no Hellinger transformation.
# - The previous pooled-indeterminate handling is retained by excluding the five
#   pooled clavicle/scapula/humerus/radius/ulna "indet" variables while retaining
#   the corresponding right/left variables.
# - Median imputation + z-standardization are used ONLY as numerical preprocessing
#   for Euclidean K-means. Raw values are retained for interpretation/2D display.
# - For >2-D spaces K-means uses the FULL standardized matrix. PCA is DISPLAY ONLY.
# - Plotted ellipses are 90% confidence ellipses for cluster CENTROIDS.
# ==============================================================================

library(tidyverse)
library(cluster)
library(vegan)
library(ggrepel)

set.seed(42)

INPUT_FILE <- "final/tapho_db_sum.csv"
OUT_DIR <- "unsupervised_7spaces_tapho_db_sum_R_outputs"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

SEED <- 42
B_PERM <- 4999
CI_LEVEL <- 0.90

# Current default preserves the previous pooled-indeterminate handling.
# Set FALSE if you want the pooled *_indet columns included as independent
# clustering dimensions.
EXCLUDE_POOLED_INDET <- TRUE

# ------------------------------------------------------------------------------
# 1. Load data
# ------------------------------------------------------------------------------

d_raw <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

C_VAR <- "Mean_part_abundance"
E_VAR <- "mnau_heip_evenness"

stopifnot(
  C_VAR %in% names(d_raw),
  E_VAR %in% names(d_raw)
)

# ------------------------------------------------------------------------------
# 2. Define feature columns exactly from the CSV
# ------------------------------------------------------------------------------

# Keep the previous treatment of pooled indeterminate elements:
# exclude pooled indet variables while keeping right/left variables.
prop_indet_exclude <- c(
  "ProportionalRep_MNIbased_clavicle_indet",
  "ProportionalRep_MNIbased_scapula_indet",
  "ProportionalRep_MNIbased_humerus_indet",
  "ProportionalRep_MNIbased_radius_indet",
  "ProportionalRep_MNIbased_ulna_indet"
)

rem_indet_exclude <- c(
  "ReMNAU_clavicle_indet",
  "ReMNAU_scapula_indet",
  "ReMNAU_humerus_indet",
  "ReMNAU_radius_indet",
  "ReMNAU_ulna_indet"
)

prop_cols <- names(d_raw)[
  stringr::str_starts(names(d_raw), "ProportionalRep_MNIbased_")
]

rem_cols <- names(d_raw)[
  stringr::str_starts(names(d_raw), "ReMNAU_")
]

if (EXCLUDE_POOLED_INDET) {
  prop_cols <- setdiff(prop_cols, prop_indet_exclude)
  rem_cols <- setdiff(rem_cols, rem_indet_exclude)
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
eng_cols <- intersect(eng_cols, names(d_raw))

# ------------------------------------------------------------------------------
# 3. Use the summed dataset directly
# ------------------------------------------------------------------------------

# tapho_db_sum is already the summed analytical dataset.
# Do NOT group, average, or reconstruct parent sites here.
# There is intentionally no dependency on site_id.

required_metadata <- c(
  "site_name",
  "taphonomic_context",
  "funerary_context"
)

missing_metadata <- setdiff(required_metadata, names(d_raw))
if (length(missing_metadata) > 0) {
  stop(
    "Missing required metadata column(s) in tapho_db_sum: ",
    paste(missing_metadata, collapse = ", ")
  )
}

# layer_name is useful in output tables but is not required for fitting.
if (!"layer_name" %in% names(d_raw)) {
  d_raw$layer_name <- NA_character_
}

# Synthetic row identifier for output bookkeeping only.
# It prevents accidental merging when the same site_name occurs more than once.
d <- d_raw %>%
  mutate(record_id = row_number(), .before = 1)

# ------------------------------------------------------------------------------
# 4. Archaeological labels
# ------------------------------------------------------------------------------

class4_fun <- function(x) {
  case_when(
    x == "Funerary Context" ~ "Funerary",
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)"
    ) ~ "Carnivore-related",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

norm_fun_subtype <- function(x) {
  xl <- stringr::str_to_lower(stringr::str_trim(x))

  case_when(
    is.na(x) ~ "Missing",
    xl == "inhumation single" ~ "Single inhumation",
    stringr::str_starts(xl, "inhumation single; inhumation multiple") ~
      "Single + multiple",
    xl == "inhumation multiple" ~ "Multiple inhumation",
    xl == "inhumation single; collective burial" ~ "Single + collective",
    stringr::str_starts(xl, "collective burial") &
      stringr::str_detect(xl, "secondary") ~ "Collective-secondary",
    stringr::str_starts(xl, "collective burial") ~ "Collective burial",
    xl == "cremation" ~ "Cremation",
    xl == "funerary caching" ~ "Funerary caching",
    xl == "possible burial" ~ "Possible burial",
    xl == "no inhumation" ~ "No inhumation",
    TRUE ~ stringr::str_trim(x)
  )
}

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
    class4 = class4_fun(taphonomic_context),
    binary_label = case_when(
      class4 == "Funerary" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    ),
    funerary_subtype_norm = norm_fun_subtype(funerary_context),
    named_panel = case_when(
      site_name %in% historical & site_name %in% early ~ "Both panels",
      site_name %in% historical ~ "Historical",
      site_name %in% early ~ "Early",
      TRUE ~ NA_character_
    )
  )

# IMPORTANT CHANGE:
# ALL known four-context sites are included in the clustering fit.
fit <- d %>%
  filter(!is.na(class4))

# Unknown sites remain projection-only.
# Explicitly ignore Sima de los Huesos PNAS.
unknown <- d %>%
  filter(taphonomic_context %in% c("Unknown", "Unkown")) %>%
  filter(site_name != "Sima de los Huesos PNAS")

ignored_unknown <- d %>%
  filter(
    taphonomic_context %in% c("Unknown", "Unkown"),
    site_name == "Sima de los Huesos PNAS"
  )

other_excluded <- d %>%
  filter(
    is.na(class4),
    !taphonomic_context %in% c("Unknown", "Unkown")
  )

partition <- tibble(
  dataset = c(
    "Known four-context clustering fit (summed rows)",
    "Named historical/early records inside fit",
    "Unknown projection",
    "Ignored Unknown: Sima de los Huesos PNAS",
    "Other contexts excluded"
  ),
  n_rows = c(
    nrow(fit),
    sum(!is.na(fit$named_panel)),
    nrow(unknown),
    nrow(ignored_unknown),
    nrow(other_excluded)
  )
)

write_csv(partition, file.path(OUT_DIR, "sample_partition.csv"))

# Sanity checks
print(partition)
print(fit %>% count(class4))
print(fit %>% count(binary_label))
print(fit %>% filter(!is.na(named_panel)) %>% count(named_panel, class4))

# ------------------------------------------------------------------------------
# 5. Seven feature spaces
# ------------------------------------------------------------------------------

informative <- function(data, vars) {
  vars[
    vapply(
      vars,
      function(v) {
        z <- data[[v]]
        sum(!is.na(z)) > 1 &&
          dplyr::n_distinct(z, na.rm = TRUE) > 1
      },
      logical(1)
    )
  ]
}

prop_cols <- informative(fit, prop_cols)
rem_cols <- informative(fit, rem_cols)
eng_cols <- informative(fit, eng_cols)

feature_sets <- list(
  `C only` = C_VAR,
  `Heip evenness only` = E_VAR,
  `C + Heip evenness` = c(C_VAR, E_VAR),
  `%MNAU raw` = prop_cols,
  `ReMNAU raw` = rem_cols,
  `Engineered` = eng_cols,
  `Combined` = unique(c(prop_cols, rem_cols, eng_cols))
)

feature_manifest <- imap_dfr(
  feature_sets,
  ~ tibble(
    Feature_space = .y,
    variable = .x
  )
)
write_csv(feature_manifest, file.path(OUT_DIR, "feature_manifest.csv"))

# ------------------------------------------------------------------------------
# 6. Preprocessing
# ------------------------------------------------------------------------------

# NOTE:
# %MNAU and ReMNAU are not Hellinger-transformed or otherwise compositionally
# transformed. They enter here exactly as stored in the CSV, followed only by:
#   1) reference-median imputation for missing cells
#   2) z-standardization for Euclidean K-means
#
# This prevents variables with larger variance/range from dominating distance.

make_preprocessor <- function(train, vars) {

  missing_vars <- setdiff(vars, names(train))
  if (length(missing_vars) > 0) {
    stop(
      "Missing variables: ",
      paste(missing_vars, collapse = ", ")
    )
  }

  med <- map_dbl(
    vars,
    function(v) {
      x <- train[[v]]
      if (all(is.na(x))) return(NA_real_)
      median(x, na.rm = TRUE)
    }
  )
  names(med) <- vars

  if (any(!is.finite(med))) {
    bad <- names(med)[!is.finite(med)]
    stop(
      "Cannot impute feature(s) with no finite training values: ",
      paste(bad, collapse = ", ")
    )
  }

  x0 <- as.data.frame(train[, vars, drop = FALSE])

  for (v in vars) {
    x0[[v]][is.na(x0[[v]])] <- med[[v]]
  }

  X0 <- as.matrix(x0)
  mu <- colMeans(X0)
  sdv <- apply(X0, 2, sd)
  sdv[!is.finite(sdv) | sdv == 0] <- 1

  X <- sweep(
    sweep(X0, 2, mu, "-"),
    2, sdv, "/"
  )

  list(
    vars = vars,
    medians = med,
    means = mu,
    sds = sdv,
    X_train_raw = X0,
    X_train = X
  )
}

apply_preprocessor <- function(prep, newdata) {

  x0 <- as.data.frame(
    newdata[, prep$vars, drop = FALSE]
  )

  for (v in prep$vars) {
    x0[[v]][is.na(x0[[v]])] <- prep$medians[[v]]
  }

  X0 <- as.matrix(x0)

  X <- sweep(
    sweep(X0, 2, prep$means, "-"),
    2, prep$sds, "/"
  )

  list(
    raw = X0,
    scaled = X
  )
}

# ------------------------------------------------------------------------------
# 7. k-selection helpers
# ------------------------------------------------------------------------------

elbow_distance <- function(k, inertia) {

  xn <- (k - min(k)) / (max(k) - min(k))
  yn <- (inertia - min(inertia)) / (max(inertia) - min(inertia))

  p1 <- c(xn[1], yn[1])
  p2 <- c(xn[length(xn)], yn[length(yn)])
  line <- p2 - p1

  dd <- map_dbl(
    seq_along(k),
    function(i) {
      p <- c(xn[i], yn[i])
      abs(
        line[1] * (p[2] - p1[2]) -
          line[2] * (p[1] - p1[1])
      ) / sqrt(sum(line^2))
    }
  )

  inner <- 2:(length(k) - 1)

  k[
    inner[
      which.max(dd[inner])
    ]
  ]
}

# Selection rule:
# use elbow when its silhouette is within 0.02 of the maximum;
# otherwise use the maximum-silhouette k.
choose_k <- function(kvals, inertia, silhouettes) {

  elbow_k <- elbow_distance(kvals, inertia)
  sil_k <- kvals[
    which.max(
      replace_na(silhouettes, -Inf)
    )
  ]

  max_sil <- max(silhouettes, na.rm = TRUE)
  sil_at_elbow <- silhouettes[match(elbow_k, kvals)]

  if (
    elbow_k >= 2 &&
      is.finite(sil_at_elbow) &&
      sil_at_elbow >= max_sil - 0.02
  ) {
    chosen_k <- elbow_k
    rule <- "Elbow; silhouette within 0.02 of maximum"
  } else {
    chosen_k <- sil_k
    rule <- "Maximum silhouette"
  }

  list(
    elbow_k = elbow_k,
    silhouette_k = sil_k,
    chosen_k = chosen_k,
    rule = rule
  )
}

# ------------------------------------------------------------------------------
# 8. Statistical helpers
# ------------------------------------------------------------------------------

choose2 <- function(n) n * (n - 1) / 2

ARI <- function(a, b) {
  tab <- table(a, b)

  sum_comb <- sum(choose2(tab))
  row_comb <- sum(choose2(rowSums(tab)))
  col_comb <- sum(choose2(colSums(tab)))
  total_comb <- choose2(sum(tab))

  if (total_comb == 0) return(NA_real_)

  expected <- row_comb * col_comb / total_comb
  max_index <- 0.5 * (row_comb + col_comb)

  if (max_index == expected) return(0)

  (sum_comb - expected) / (max_index - expected)
}

NMI <- function(a, b) {
  tab <- table(a, b)
  pxy <- tab / sum(tab)
  px <- rowSums(pxy)
  py <- colSums(pxy)

  nz <- which(pxy > 0, arr.ind = TRUE)

  mi <- sum(
    pxy[nz] *
      log(
        pxy[nz] /
          (px[nz[, 1]] * py[nz[, 2]])
      )
  )

  hx <- -sum(px[px > 0] * log(px[px > 0]))
  hy <- -sum(py[py > 0] * log(py[py > 0]))

  if (hx == 0 || hy == 0) return(0)

  mi / sqrt(hx * hy)
}

purity <- function(labels, clusters) {
  tab <- table(clusters, labels)
  sum(apply(tab, 1, max)) / sum(tab)
}

bias_corrected_cramers_v <- function(labels, clusters) {

  tab <- table(clusters, labels)

  if (nrow(tab) < 2 || ncol(tab) < 2) {
    return(NA_real_)
  }

  chi <- suppressWarnings(
    chisq.test(tab, correct = FALSE)
  )

  n <- sum(tab)
  phi2 <- as.numeric(chi$statistic) / n

  r <- nrow(tab)
  k <- ncol(tab)

  phi2_corr <- max(
    0,
    phi2 -
      ((k - 1) * (r - 1)) / (n - 1)
  )

  r_corr <- r - ((r - 1)^2) / (n - 1)
  k_corr <- k - ((k - 1)^2) / (n - 1)

  denom <- min(k_corr - 1, r_corr - 1)

  if (!is.finite(denom) || denom <= 0) {
    return(NA_real_)
  }

  sqrt(phi2_corr / denom)
}

chisq_perm <- function(labels, clusters, B = B_PERM, seed = 1) {

  tab <- table(clusters, labels)

  if (nrow(tab) < 2 || ncol(tab) < 2) {
    return(c(Chi_square = NA_real_, Permutation_p = NA_real_))
  }

  obs <- as.numeric(
    suppressWarnings(
      chisq.test(tab, correct = FALSE)$statistic
    )
  )

  set.seed(seed)

  null <- replicate(
    B,
    {
      tab0 <- table(clusters, sample(labels))
      as.numeric(
        suppressWarnings(
          chisq.test(tab0, correct = FALSE)$statistic
        )
      )
    }
  )

  c(
    Chi_square = obs,
    Permutation_p = (1 + sum(null >= obs)) / (B + 1)
  )
}

association_summary <- function(
  labels,
  clusters,
  feature_space,
  label_level,
  k,
  B = B_PERM,
  seed = 1
) {

  ok <- complete.cases(labels, clusters)
  labels <- labels[ok]
  clusters <- clusters[ok]

  if (
    length(unique(labels)) < 2 ||
      length(unique(clusters)) < 2
  ) {
    return(
      tibble(
        Feature_space = feature_space,
        Label_level = label_level,
        n = length(labels),
        k = k,
        ARI = NA_real_,
        NMI = NA_real_,
        Purity = NA_real_,
        Chi_square = NA_real_,
        Permutation_p = NA_real_,
        Bias_corrected_Cramers_V = NA_real_
      )
    )
  }

  ch <- chisq_perm(
    labels,
    clusters,
    B = B,
    seed = seed
  )

  tibble(
    Feature_space = feature_space,
    Label_level = label_level,
    n = length(labels),
    k = k,
    ARI = ARI(labels, clusters),
    NMI = NMI(labels, clusters),
    Purity = purity(labels, clusters),
    Chi_square = unname(ch["Chi_square"]),
    Permutation_p = unname(ch["Permutation_p"]),
    Bias_corrected_Cramers_V =
      bias_corrected_cramers_v(labels, clusters)
  )
}

permanova_dispersion <- function(
  X,
  labels,
  feature_space,
  label_level,
  permutations = B_PERM
) {

  ok <- complete.cases(labels)
  X2 <- X[ok, , drop = FALSE]
  labs <- droplevels(factor(labels[ok]))

  if (
    nrow(X2) < 4 ||
      nlevels(labs) < 2
  ) {
    return(
      tibble(
        Feature_space = feature_space,
        Label_level = label_level,
        n = nrow(X2),
        Pseudo_F = NA_real_,
        R2 = NA_real_,
        PERMANOVA_p = NA_real_,
        Dispersion_F = NA_real_,
        Dispersion_p = NA_real_
      )
    )
  }

  dd <- dist(X2)
  dat <- tibble(label = labs)

  set.seed(SEED)
  ad <- vegan::adonis2(
    dd ~ label,
    data = dat,
    permutations = permutations
  )

  bd <- vegan::betadisper(dd, labs)

  set.seed(SEED)
  bp <- vegan::permutest(
    bd,
    permutations = min(999, permutations)
  )

  tibble(
    Feature_space = feature_space,
    Label_level = label_level,
    n = nrow(X2),
    Pseudo_F = ad$F[1],
    R2 = ad$R2[1],
    PERMANOVA_p = ad$`Pr(>F)`[1],
    Dispersion_F = bp$tab$F[1],
    Dispersion_p = bp$tab$`Pr(>F)`[1]
  )
}

cliffs_delta <- function(x, y) {
  x <- x[is.finite(x)]
  y <- y[is.finite(y)]
  if (length(x) == 0 || length(y) == 0) return(NA_real_)
  mean(outer(x, y, ">")) - mean(outer(x, y, "<"))
}

nearest_center <- function(Xnew, centers) {
  apply(
    Xnew,
    1,
    function(z) {
      which.min(
        rowSums(
          sweep(centers, 2, z, "-")^2
        )
      )
    }
  )
}

ellipse_ci <- function(
  x,
  y,
  level = CI_LEVEL,
  n = 200
) {

  xy <- cbind(x, y)
  xy <- xy[complete.cases(xy), , drop = FALSE]

  if (nrow(xy) < 3) return(NULL)

  mu <- colMeans(xy)
  S <- cov(xy) / nrow(xy)

  ev <- eigen(S, symmetric = TRUE)

  radii <- sqrt(
    qchisq(level, df = 2) *
      pmax(ev$values, 0)
  )

  theta <- seq(
    0,
    2 * pi,
    length.out = n
  )

  unit <- rbind(
    cos(theta),
    sin(theta)
  )

  ell <- t(
    ev$vectors %*%
      diag(radii) %*%
      unit
  )

  tibble(
    x = ell[, 1] + mu[1],
    y = ell[, 2] + mu[2]
  )
}

ci_1d <- function(x, level = CI_LEVEL) {

  x <- x[is.finite(x)]
  n <- length(x)

  if (n < 2) {
    return(
      tibble(
        n = n,
        mean = mean(x),
        lower = NA_real_,
        upper = NA_real_
      )
    )
  }

  m <- mean(x)
  se <- sd(x) / sqrt(n)
  crit <- qt(
    1 - (1 - level) / 2,
    df = n - 1
  )

  tibble(
    n = n,
    mean = m,
    lower = m - crit * se,
    upper = m + crit * se
  )
}

partial_cor <- function(x, y, z) {

  ok <- complete.cases(x, y, z)
  x <- x[ok]
  y <- y[ok]
  z <- z[ok]

  n <- length(x)

  if (n < 4) {
    return(c(r = NA_real_, p = NA_real_, n = n))
  }

  rx <- resid(lm(x ~ z))
  ry <- resid(lm(y ~ z))

  r <- cor(rx, ry)

  if (!is.finite(r) || abs(r) >= 1) {
    p <- ifelse(abs(r) == 1, 0, NA_real_)
  } else {
    tval <- r * sqrt((n - 3) / (1 - r^2))
    p <- 2 * pt(-abs(tval), df = n - 3)
  }

  c(r = r, p = p, n = n)
}

# ------------------------------------------------------------------------------
# 9. Storage
# ------------------------------------------------------------------------------

diag_all <- list()
assoc_all <- list()
permanova_all <- list()
profile_all <- list()
corr_all <- list()

fit_all <- list()
unknown_all <- list()
named_panel_all <- list()

binary_tabs <- list()
class4_tabs <- list()
nonfun_tabs <- list()
fun_subtype_tabs <- list()
fun_subtype_common_tabs <- list()

# ------------------------------------------------------------------------------
# 10. Main loop
# ------------------------------------------------------------------------------

for (space in names(feature_sets)) {

  message("Running: ", space)

  vars <- feature_sets[[space]]

  prep <- make_preprocessor(
    fit,
    vars
  )

  X <- prep$X_train
  Xraw <- prep$X_train_raw

  udat <- apply_preprocessor(
    prep,
    unknown
  )

  Xu <- udat$scaled
  Xuraw <- udat$raw

  p <- ncol(X)

  # --------------------------------------------------------------------------
  # k diagnostics
  # --------------------------------------------------------------------------

  kvals <- 1:min(8, nrow(X) - 1)

  inertia <- map_dbl(
    kvals,
    function(k) {
      set.seed(SEED)
      kmeans(
        X,
        centers = k,
        nstart = 100,
        iter.max = 300
      )$tot.withinss
    }
  )

  silhouettes <- rep(
    NA_real_,
    length(kvals)
  )

  for (i in seq_along(kvals)) {

    k <- kvals[i]

    if (k >= 2) {
      set.seed(SEED)

      km0 <- kmeans(
        X,
        centers = k,
        nstart = 100,
        iter.max = 300
      )

      silhouettes[i] <- mean(
        cluster::silhouette(
          km0$cluster,
          dist(X)
        )[, 3]
      )
    }
  }

  ks <- choose_k(
    kvals,
    inertia,
    silhouettes
  )

  chosen_k <- ks$chosen_k

  diag <- tibble(
    Feature_space = space,
    k = kvals,
    Inertia = inertia,
    Silhouette = silhouettes,
    Elbow_k = ks$elbow_k,
    Silhouette_best_k = ks$silhouette_k,
    Chosen_k = chosen_k,
    Rule = ks$rule
  )

  diag_all[[space]] <- diag

  diag_plot <- diag %>%
    mutate(
      Relative_inertia =
        Inertia / first(Inertia)
    ) %>%
    select(
      k,
      Relative_inertia,
      Silhouette
    ) %>%
    pivot_longer(
      -k,
      names_to = "metric",
      values_to = "value"
    )

  gp_k <- ggplot(
    diag_plot,
    aes(
      x = k,
      y = value,
      linetype = metric,
      shape = metric
    )
  ) +
    geom_line(na.rm = TRUE) +
    geom_point(na.rm = TRUE) +
    geom_vline(
      xintercept = chosen_k,
      linetype = 2
    ) +
    scale_x_continuous(
      breaks = kvals
    ) +
    labs(
      x = "k",
      y = "Relative inertia / mean silhouette",
      title = paste0(
        space,
        ": elbow and silhouette"
      ),
      subtitle = paste0(
        "Chosen k = ",
        chosen_k,
        " (",
        ks$rule,
        ")"
      )
    ) +
    theme_bw()

  ggsave(
    file.path(
      OUT_DIR,
      paste0(
        "k_",
        make.names(space),
        ".png"
      )
    ),
    gp_k,
    width = 8.5,
    height = 5.8,
    dpi = 300
  )

  # --------------------------------------------------------------------------
  # Final k-means
  # --------------------------------------------------------------------------

  set.seed(SEED)

  km <- kmeans(
    X,
    centers = chosen_k,
    nstart = 300,
    iter.max = 500
  )

  cl_raw <- km$cluster

  # Reorder cluster labels by increasing median Mean_part_abundance.
  # This makes C1 consistently the lower-abundance cluster.
  cluster_map <- fit %>%
    mutate(
      Cluster_raw = cl_raw
    ) %>%
    group_by(Cluster_raw) %>%
    summarise(
      Median_C_order =
        median(
          .data[[C_VAR]],
          na.rm = TRUE
        ),
      .groups = "drop"
    ) %>%
    arrange(
      Median_C_order,
      Cluster_raw
    ) %>%
    mutate(
      Cluster = row_number()
    )

  relabel_cluster <- function(x) {
    cluster_map$Cluster[
      match(
        x,
        cluster_map$Cluster_raw
      )
    ]
  }

  cl <- relabel_cluster(cl_raw)

  # Unknown projection to nearest fitted RAW k-means center,
  # then convert raw center number to ordered cluster number.
  clu_raw <- nearest_center(
    Xu,
    km$centers
  )
  clu <- relabel_cluster(clu_raw)

  dfit <- sqrt(
    rowSums(
      (X - km$centers[cl_raw, , drop = FALSE])^2
    )
  )

  dunk <- sqrt(
    rowSums(
      (Xu - km$centers[clu_raw, , drop = FALSE])^2
    )
  )

  # --------------------------------------------------------------------------
  # PCA for display / PC1 interpretation
  # --------------------------------------------------------------------------

  pc <- prcomp(
    X,
    center = FALSE,
    scale. = FALSE
  )

  Zf <- predict(
    pc,
    X
  )

  Zu <- predict(
    pc,
    Xu
  )

  pc1 <- Zf[, 1]

  rC <- suppressWarnings(
    cor.test(
      pc1,
      fit[[C_VAR]],
      method = "pearson"
    )
  )

  okE <- complete.cases(
    pc1,
    fit[[E_VAR]]
  )

  rE <- suppressWarnings(
    cor.test(
      pc1[okE],
      fit[[E_VAR]][okE],
      method = "pearson"
    )
  )

  prE <- partial_cor(
    pc1,
    fit[[E_VAR]],
    fit[[C_VAR]]
  )

  corr_all[[space]] <- tibble(
    Feature_space = space,
    n_features = p,
    PC1_variance =
      summary(pc)$importance[2, 1],
    PC2_variance =
      if (p >= 2) {
        summary(pc)$importance[2, 2]
      } else {
        NA_real_
      },
    r_PC1_C =
      unname(rC$estimate),
    p_PC1_C =
      rC$p.value,
    r_PC1_Heip =
      unname(rE$estimate),
    p_PC1_Heip =
      rE$p.value,
    partial_r_PC1_Heip_given_C =
      unname(prE["r"]),
    partial_p_PC1_Heip_given_C =
      unname(prE["p"])
  )

  # --------------------------------------------------------------------------
  # Cluster profiles
  # --------------------------------------------------------------------------

  tmp <- fit %>%
    mutate(
      Cluster = cl,
      Cluster_raw = cl_raw,
      Distance_to_centroid = dfit
    )

  prof <- tmp %>%
    group_by(Cluster) %>%
    summarise(
      n = n(),

      F_n =
        sum(binary_label == "F"),
      NF_n =
        sum(binary_label == "NF"),

      F_percent =
        100 * mean(binary_label == "F"),

      Funerary_n =
        sum(class4 == "Funerary"),
      Cannibalism_n =
        sum(class4 == "Cannibalism"),
      Carnivore_n =
        sum(class4 == "Carnivore-related"),
      Geological_transport_n =
        sum(class4 == "Geological transport"),

      Median_C =
        median(
          .data[[C_VAR]],
          na.rm = TRUE
        ),

      Median_Heip =
        median(
          .data[[E_VAR]],
          na.rm = TRUE
        ),

      Median_distance =
        median(Distance_to_centroid),

      .groups = "drop"
    ) %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  profile_all[[space]] <- prof

  # --------------------------------------------------------------------------
  # Cluster-label association
  # --------------------------------------------------------------------------

  assoc_all[[paste(space, "binary")]] <-
    association_summary(
      fit$binary_label,
      cl,
      feature_space = space,
      label_level = "Funerary vs non-funerary",
      k = chosen_k,
      B = B_PERM,
      seed = 101
    )

  assoc_all[[paste(space, "four")]] <-
    association_summary(
      fit$class4,
      cl,
      feature_space = space,
      label_level = "Broad four-context",
      k = chosen_k,
      B = B_PERM,
      seed = 102
    )

  # Non-funerary sublabels:
  # Cannibalism vs Carnivore-related vs Geological transport
  nf <- fit$class4 != "Funerary"

  assoc_all[[paste(space, "nonfun")]] <-
    association_summary(
      fit$class4[nf],
      cl[nf],
      feature_space = space,
      label_level = "Within non-funerary: 3 processes",
      k = chosen_k,
      B = B_PERM,
      seed = 103
    )

  # Funerary subtypes: all categories (descriptive + permutation association)
  fm <- fit$class4 == "Funerary"

  assoc_all[[paste(space, "fsub_all")]] <-
    association_summary(
      fit$funerary_subtype_norm[fm],
      cl[fm],
      feature_space = space,
      label_level = "Within funerary: all subtypes",
      k = chosen_k,
      B = B_PERM,
      seed = 104
    )

  # A more defensible inferential subtype analysis restricted to subtype n >= 3.
  ftab <- table(
    fit$funerary_subtype_norm[fm]
  )

  common_fsub <- names(
    ftab[ftab >= 3]
  )

  fm_common <- fm &
    fit$funerary_subtype_norm %in%
      common_fsub

  assoc_all[[paste(space, "fsub_common")]] <-
    association_summary(
      fit$funerary_subtype_norm[fm_common],
      cl[fm_common],
      feature_space = space,
      label_level = "Within funerary: subtypes n>=3",
      k = chosen_k,
      B = B_PERM,
      seed = 105
    )

  # --------------------------------------------------------------------------
  # PERMANOVA + dispersion
  # These test feature-space differences among archaeological groups and are
  # complementary to the cluster-label contingency tests above.
  # --------------------------------------------------------------------------

  permanova_all[[paste(space, "binary")]] <-
    permanova_dispersion(
      X,
      fit$binary_label,
      feature_space = space,
      label_level = "Funerary vs non-funerary",
      permutations = B_PERM
    )

  permanova_all[[paste(space, "four")]] <-
    permanova_dispersion(
      X,
      fit$class4,
      feature_space = space,
      label_level = "Broad four-context",
      permutations = B_PERM
    )

  permanova_all[[paste(space, "nonfun")]] <-
    permanova_dispersion(
      X[nf, , drop = FALSE],
      fit$class4[nf],
      feature_space = space,
      label_level = "Within non-funerary: 3 processes",
      permutations = B_PERM
    )

  if (sum(fm_common) >= 6) {
    permanova_all[[paste(space, "fsub_common")]] <-
      permanova_dispersion(
        X[fm_common, , drop = FALSE],
        fit$funerary_subtype_norm[fm_common],
        feature_space = space,
        label_level = "Within funerary: subtypes n>=3",
        permutations = B_PERM
      )
  }

  # --------------------------------------------------------------------------
  # Contingency / composition tables
  # --------------------------------------------------------------------------

  binary_tabs[[space]] <-
    as.data.frame.matrix(
      table(
        Cluster = cl,
        Binary = fit$binary_label
      )
    ) %>%
    rownames_to_column("Cluster") %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  class4_tabs[[space]] <-
    as.data.frame.matrix(
      table(
        Cluster = cl,
        Context = fit$class4
      )
    ) %>%
    rownames_to_column("Cluster") %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  nonfun_tabs[[space]] <-
    as.data.frame.matrix(
      table(
        Cluster = cl[nf],
        Context = fit$class4[nf]
      )
    ) %>%
    rownames_to_column("Cluster") %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  fun_subtype_tabs[[space]] <-
    as.data.frame.matrix(
      table(
        Cluster = cl[fm],
        Funerary_subtype =
          fit$funerary_subtype_norm[fm]
      )
    ) %>%
    rownames_to_column("Cluster") %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  fun_subtype_common_tabs[[space]] <-
    as.data.frame.matrix(
      table(
        Cluster = cl[fm_common],
        Funerary_subtype =
          fit$funerary_subtype_norm[fm_common]
      )
    ) %>%
    rownames_to_column("Cluster") %>%
    mutate(
      Feature_space = space,
      .before = 1
    )

  # --------------------------------------------------------------------------
  # Fit assignments
  # --------------------------------------------------------------------------

  profile_lookup <- prof %>%
    select(
      Cluster,
      Cluster_F_percent = F_percent
    )

  dominant_lookup <- tmp %>%
    count(
      Cluster,
      class4,
      name = "n"
    ) %>%
    group_by(Cluster) %>%
    arrange(desc(n), class4) %>%
    slice(1) %>%
    ungroup() %>%
    transmute(
      Cluster,
      Cluster_dominant_class4 = class4
    )

  fit_out <- fit %>%
    transmute(
      Feature_space = space,
      record_id,
      site_name,
      layer_name,
      named_panel,
      class4,
      binary_label,
      funerary_subtype =
        funerary_subtype_norm,
      Cluster = cl,
      Cluster_raw = cl_raw,
      Distance_to_centroid = dfit,
      PC1 = Zf[, 1],
      PC2 =
        if (ncol(Zf) >= 2) {
          Zf[, 2]
        } else {
          NA_real_
        }
    ) %>%
    left_join(
      profile_lookup,
      by = "Cluster"
    ) %>%
    left_join(
      dominant_lookup,
      by = "Cluster"
    )

  fit_out$Distance_percentile_within_cluster <-
    map2_dbl(
      fit_out$Cluster,
      fit_out$Distance_to_centroid,
      function(k, x) {
        100 * mean(
          fit_out$Distance_to_centroid[
            fit_out$Cluster == k
          ] <= x
        )
      }
    )

  fit_all[[space]] <- fit_out

  named_panel_all[[space]] <-
    fit_out %>%
    filter(!is.na(named_panel))

  # --------------------------------------------------------------------------
  # Unknown projection
  # --------------------------------------------------------------------------

  unknown_out <- unknown %>%
    transmute(
      Feature_space = space,
      record_id,
      site_name,
      layer_name,
      Cluster = clu,
      Cluster_raw = clu_raw,
      Distance_to_centroid = dunk,
      PC1 = Zu[, 1],
      PC2 =
        if (ncol(Zu) >= 2) {
          Zu[, 2]
        } else {
          NA_real_
        }
    ) %>%
    left_join(
      profile_lookup,
      by = "Cluster"
    ) %>%
    left_join(
      dominant_lookup,
      by = "Cluster"
    )

  unknown_out$Distance_percentile_vs_fit_cluster <-
    map2_dbl(
      unknown_out$Cluster,
      unknown_out$Distance_to_centroid,
      function(k, x) {
        100 * mean(
          dfit[cl == k] <= x
        )
      }
    )

  unknown_all[[space]] <- unknown_out

  # --------------------------------------------------------------------------
  # Visualization coordinates
  # --------------------------------------------------------------------------

  if (p == 1) {

    ref_plot <- tibble(
      x = Xraw[, 1],
      Cluster = factor(cl),
      class4 = fit$class4,
      site_name = fit$site_name,
      named_panel = fit$named_panel
    ) %>%
      mutate(
        y = as.numeric(Cluster)
      )

    ci_df <- ref_plot %>%
      group_by(Cluster) %>%
      group_modify(
        ~ ci_1d(.x$x, CI_LEVEL)
      ) %>%
      ungroup() %>%
      mutate(
        y = as.numeric(Cluster)
      )

    gp_cluster <- ggplot(
      ref_plot,
      aes(
        x = x,
        y = y
      )
    ) +
      geom_jitter(
        aes(
          shape = class4,
          fill = Cluster
        ),
        height = 0.08,
        width = 0,
        size = 2.5
      ) +
      geom_segment(
        data = ci_df,
        aes(
          x = lower,
          xend = upper,
          y = y,
          yend = y
        ),
        inherit.aes = FALSE,
        linewidth = 1
      ) +
      geom_point(
        data = ci_df,
        aes(
          x = mean,
          y = y
        ),
        inherit.aes = FALSE,
        shape = 23,
        size = 3
      ) +
      scale_y_continuous(
        breaks = sort(unique(ref_plot$y)),
        labels = paste0(
          "C",
          sort(unique(ref_plot$y))
        )
      ) +
      labs(
        x = vars[1],
        y = "K-means cluster",
        title = paste0(
          space,
          ": k-means solution, k=",
          chosen_k
        ),
        subtitle = "90% confidence intervals for cluster means"
      ) +
      theme_bw()

    unknown_plot <- tibble(
      x = Xuraw[, 1],
      y = clu,
      site_name = unknown$site_name
    )

    gp_unknown <- ggplot() +
      geom_jitter(
        data = ref_plot,
        aes(
          x = x,
          y = y,
          fill = Cluster
        ),
        height = 0.06,
        width = 0,
        alpha = 0.25,
        size = 2
      ) +
      geom_point(
        data = unknown_plot,
        aes(
          x = x,
          y = y
        ),
        shape = 4,
        size = 3
      ) +
      ggrepel::geom_text_repel(
        data = unknown_plot,
        aes(
          x = x,
          y = y,
          label = site_name
        ),
        size = 2.5
      ) +
      scale_y_continuous(
        breaks = sort(unique(ref_plot$y)),
        labels = paste0(
          "C",
          sort(unique(ref_plot$y))
        )
      ) +
      labs(
        x = vars[1],
        y = "Assigned cluster",
        title = paste0(
          space,
          ": Unknown projection"
        )
      ) +
      theme_bw()

    panel_plot <- ref_plot %>%
      filter(!is.na(named_panel))

    gp_panel <- ggplot() +
      geom_jitter(
        data = ref_plot,
        aes(
          x = x,
          y = y,
          fill = Cluster
        ),
        height = 0.06,
        width = 0,
        alpha = 0.18,
        size = 2
      ) +
      geom_point(
        data = panel_plot,
        aes(
          x = x,
          y = y,
          shape = named_panel
        ),
        size = 3
      ) +
      ggrepel::geom_text_repel(
        data = panel_plot,
        aes(
          x = x,
          y = y,
          label = site_name
        ),
        size = 2.4
      ) +
      scale_y_continuous(
        breaks = sort(unique(ref_plot$y)),
        labels = paste0(
          "C",
          sort(unique(ref_plot$y))
        )
      ) +
      labs(
        x = vars[1],
        y = "K-means cluster",
        title = paste0(
          space,
          ": named historical/early sites"
        ),
        subtitle = "These sites were included in the clustering fit"
      ) +
      theme_bw()

  } else {

    # 2-D C + Heip: display original raw C and Heip.
    # >2-D: display PCA1/PCA2 only; clustering used the full matrix.
    if (
      p == 2 &&
        identical(
          vars,
          c(C_VAR, E_VAR)
        )
    ) {

      ref_plot <- tibble(
        x = Xraw[, 1],
        y = Xraw[, 2],
        Cluster = factor(cl),
        class4 = fit$class4,
        site_name = fit$site_name,
        named_panel = fit$named_panel
      )

      unknown_plot <- tibble(
        x = Xuraw[, 1],
        y = Xuraw[, 2],
        site_name = unknown$site_name
      )

      xl <- "Mean part abundance (C)"
      yl <- "Heip evenness"

      display_note <-
        "90% confidence ellipses for cluster centroids"

    } else {

      ref_plot <- tibble(
        x = Zf[, 1],
        y = Zf[, 2],
        Cluster = factor(cl),
        class4 = fit$class4,
        site_name = fit$site_name,
        named_panel = fit$named_panel
      )

      unknown_plot <- tibble(
        x = Zu[, 1],
        y = Zu[, 2],
        site_name = unknown$site_name
      )

      xl <- paste0(
        "PC1 (",
        round(
          100 *
            summary(pc)$importance[2, 1],
          1
        ),
        "%)"
      )

      yl <- paste0(
        "PC2 (",
        round(
          100 *
            summary(pc)$importance[2, 2],
          1
        ),
        "%)"
      )

      display_note <-
        "PCA display only; K-means used full standardized feature space; 90% centroid CIs"
    }

    ell <- map_dfr(
      levels(ref_plot$Cluster),
      function(z) {

        q <- ref_plot %>%
          filter(Cluster == z)

        e <- ellipse_ci(
          q$x,
          q$y,
          level = CI_LEVEL
        )

        if (is.null(e)) {
          return(tibble())
        }

        mutate(
          e,
          Cluster = z
        )
      }
    )

    gp_cluster <- ggplot(
      ref_plot,
      aes(
        x = x,
        y = y
      )
    ) +
      geom_point(
        aes(
          fill = Cluster,
          shape = class4
        ),
        size = 2.6
      ) +
      geom_path(
        data = ell,
        aes(
          x = x,
          y = y,
          group = Cluster
        ),
        inherit.aes = FALSE
      ) +
      labs(
        x = xl,
        y = yl,
        title = paste0(
          space,
          ": k-means solution, k=",
          chosen_k
        ),
        subtitle = display_note
      ) +
      theme_bw()

    gp_unknown <- ggplot() +
      geom_point(
        data = ref_plot,
        aes(
          x = x,
          y = y,
          fill = Cluster
        ),
        alpha = 0.22,
        size = 2
      ) +
      geom_path(
        data = ell,
        aes(
          x = x,
          y = y,
          group = Cluster
        )
      ) +
      geom_point(
        data = unknown_plot,
        aes(
          x = x,
          y = y
        ),
        shape = 4,
        size = 3
      ) +
      ggrepel::geom_text_repel(
        data = unknown_plot,
        aes(
          x = x,
          y = y,
          label = site_name
        ),
        size = 2.3
      ) +
      labs(
        x = xl,
        y = yl,
        title = paste0(
          space,
          ": Unknown projection"
        ),
        subtitle =
          "Sima de los Huesos PNAS excluded"
      ) +
      theme_bw()

    panel_plot <- ref_plot %>%
      filter(!is.na(named_panel))

    gp_panel <- ggplot() +
      geom_point(
        data = ref_plot,
        aes(
          x = x,
          y = y,
          fill = Cluster
        ),
        alpha = 0.16,
        size = 2
      ) +
      geom_path(
        data = ell,
        aes(
          x = x,
          y = y,
          group = Cluster
        )
      ) +
      geom_point(
        data = panel_plot,
        aes(
          x = x,
          y = y,
          shape = named_panel
        ),
        size = 3
      ) +
      ggrepel::geom_text_repel(
        data = panel_plot,
        aes(
          x = x,
          y = y,
          label = site_name
        ),
        size = 2.2
      ) +
      labs(
        x = xl,
        y = yl,
        title = paste0(
          space,
          ": named historical/early sites"
        ),
        subtitle =
          "Highlighted sites are part of the fitted clustering sample"
      ) +
      theme_bw()
  }

  ggsave(
    file.path(
      OUT_DIR,
      paste0(
        "clusters_",
        make.names(space),
        ".png"
      )
    ),
    gp_cluster,
    width = 10.4,
    height = 7.3,
    dpi = 300
  )

  ggsave(
    file.path(
      OUT_DIR,
      paste0(
        "unknown_",
        make.names(space),
        ".png"
      )
    ),
    gp_unknown,
    width = 11,
    height = 7.5,
    dpi = 300
  )

  ggsave(
    file.path(
      OUT_DIR,
      paste0(
        "named_panels_",
        make.names(space),
        ".png"
      )
    ),
    gp_panel,
    width = 11.5,
    height = 7.8,
    dpi = 300
  )
}

# ------------------------------------------------------------------------------
# 11. Consolidate results
# ------------------------------------------------------------------------------

diagnostics <- bind_rows(diag_all)
associations <- bind_rows(assoc_all)
permanova_results <- bind_rows(permanova_all)
profiles <- bind_rows(profile_all)
pca_correlations <- bind_rows(corr_all)

fit_assignments <- bind_rows(fit_all)
unknown_assignments <- bind_rows(unknown_all)
named_panel_assignments <- bind_rows(named_panel_all)

binary_contingencies <- bind_rows(binary_tabs)
fourclass_contingencies <- bind_rows(class4_tabs)
nonfunerary_contingencies <- bind_rows(nonfun_tabs)
funerary_subtype_contingencies <- bind_rows(fun_subtype_tabs)
funerary_common_subtype_contingencies <-
  bind_rows(fun_subtype_common_tabs)

k_summary <- diagnostics %>%
  group_by(Feature_space) %>%
  summarise(
    Elbow_k = first(Elbow_k),
    Silhouette_best_k =
      first(Silhouette_best_k),
    Chosen_k = first(Chosen_k),
    Rule = first(Rule),
    Max_silhouette =
      max(Silhouette, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  left_join(
    pca_correlations,
    by = "Feature_space"
  )

# ------------------------------------------------------------------------------
# 12. Long-form cluster composition: percentages by label
# ------------------------------------------------------------------------------

cluster_binary_percent <- fit_assignments %>%
  count(
    Feature_space,
    Cluster,
    binary_label,
    name = "n"
  ) %>%
  group_by(
    Feature_space,
    Cluster
  ) %>%
  mutate(
    cluster_n = sum(n),
    percent_within_cluster =
      100 * n / cluster_n
  ) %>%
  ungroup()

cluster_class4_percent <- fit_assignments %>%
  count(
    Feature_space,
    Cluster,
    class4,
    name = "n"
  ) %>%
  group_by(
    Feature_space,
    Cluster
  ) %>%
  mutate(
    cluster_n = sum(n),
    percent_within_cluster =
      100 * n / cluster_n
  ) %>%
  ungroup()

cluster_funerary_subtype_percent <-
  fit_assignments %>%
  filter(class4 == "Funerary") %>%
  count(
    Feature_space,
    Cluster,
    funerary_subtype,
    name = "n"
  ) %>%
  group_by(
    Feature_space,
    Cluster
  ) %>%
  mutate(
    funerary_cluster_n = sum(n),
    percent_within_funerary_cluster =
      100 * n / funerary_cluster_n
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 13. Unknown consensus across feature spaces
# ------------------------------------------------------------------------------

unknown_consensus <- unknown_assignments %>%
  mutate(
    F_enriched =
      Cluster_F_percent >= 50
  ) %>%
  group_by(
    record_id,
    site_name
  ) %>%
  summarise(
    Feature_spaces =
      n_distinct(Feature_space),

    F_enriched_spaces =
      sum(F_enriched),

    NF_enriched_spaces =
      Feature_spaces -
      F_enriched_spaces,

    Median_cluster_F_percent =
      median(
        Cluster_F_percent,
        na.rm = TRUE
      ),

    Mean_cluster_F_percent =
      mean(
        Cluster_F_percent,
        na.rm = TRUE
      ),

    Median_distance_percentile =
      median(
        Distance_percentile_vs_fit_cluster,
        na.rm = TRUE
      ),

    Max_distance_percentile =
      max(
        Distance_percentile_vs_fit_cluster,
        na.rm = TRUE
      ),

    .groups = "drop"
  ) %>%
  arrange(
    desc(Median_cluster_F_percent),
    desc(F_enriched_spaces)
  )

# ------------------------------------------------------------------------------
# 14. Named historical / early records
# IMPORTANT: these are IN-SAMPLE descriptive locations, not held-out validation.
# ------------------------------------------------------------------------------

named_panel_consensus <-
  named_panel_assignments %>%
  mutate(
    F_enriched =
      Cluster_F_percent >= 50,
    Posthoc_binary_cluster =
      if_else(
        F_enriched,
        "F",
        "NF"
      ),
    Posthoc_binary_match =
      Posthoc_binary_cluster ==
      binary_label,
    Posthoc_class4_match =
      Cluster_dominant_class4 ==
      class4
  ) %>%
  group_by(
    record_id,
    site_name,
    named_panel,
    class4,
    binary_label
  ) %>%
  summarise(
    Feature_spaces =
      n_distinct(Feature_space),

    F_enriched_spaces =
      sum(F_enriched),

    NF_enriched_spaces =
      Feature_spaces -
      F_enriched_spaces,

    Posthoc_binary_matches =
      sum(Posthoc_binary_match),

    Posthoc_class4_matches =
      sum(Posthoc_class4_match),

    Median_cluster_F_percent =
      median(
        Cluster_F_percent,
        na.rm = TRUE
      ),

    Median_distance_percentile =
      median(
        Distance_percentile_within_cluster,
        na.rm = TRUE
      ),

    Max_distance_percentile =
      max(
        Distance_percentile_within_cluster,
        na.rm = TRUE
      ),

    .groups = "drop"
  ) %>%
  arrange(
    named_panel,
    site_name,
    record_id
  )

# ------------------------------------------------------------------------------
# 15. Broad C / Heip statistics among the four archaeological contexts
# ------------------------------------------------------------------------------

broad_descriptives <- fit %>%
  group_by(class4) %>%
  summarise(
    n = n(),

    Median_C =
      median(
        .data[[C_VAR]],
        na.rm = TRUE
      ),

    Q1_C =
      quantile(
        .data[[C_VAR]],
        0.25,
        na.rm = TRUE
      ),

    Q3_C =
      quantile(
        .data[[C_VAR]],
        0.75,
        na.rm = TRUE
      ),

    Median_Heip =
      median(
        .data[[E_VAR]],
        na.rm = TRUE
      ),

    Q1_Heip =
      quantile(
        .data[[E_VAR]],
        0.25,
        na.rm = TRUE
      ),

    Q3_Heip =
      quantile(
        .data[[E_VAR]],
        0.75,
        na.rm = TRUE
      ),

    .groups = "drop"
  )

kw_broad <- map_dfr(
  c(C_VAR, E_VAR),
  function(v) {

    dat <- fit %>%
      filter(
        is.finite(.data[[v]])
      )

    tst <- kruskal.test(
      dat[[v]] ~ dat$class4
    )

    tibble(
      Variable = v,
      Kruskal_H =
        unname(tst$statistic),
      df =
        unname(tst$parameter),
      p =
        tst$p.value
    )
  }
)

classes <- c(
  "Funerary",
  "Cannibalism",
  "Carnivore-related",
  "Geological transport"
)

pairwise_broad <- map_dfr(
  c(C_VAR, E_VAR),
  function(v) {

    combn(
      classes,
      2,
      simplify = FALSE
    ) %>%
      map_dfr(
        function(pair) {

          x <- fit %>%
            filter(
              class4 == pair[1]
            ) %>%
            pull(all_of(v))
          x <- x[is.finite(x)]

          y <- fit %>%
            filter(
              class4 == pair[2]
            ) %>%
            pull(all_of(v))
          y <- y[is.finite(y)]

          wt <- wilcox.test(
            x,
            y,
            exact = FALSE
          )

          tibble(
            Variable = v,
            Group1 = pair[1],
            Group2 = pair[2],
            n1 = length(x),
            n2 = length(y),
            Median1 = median(x),
            Median2 = median(y),
            Cliffs_delta =
              cliffs_delta(x, y),
            p_raw =
              wt$p.value
          )
        }
      )
  }
) %>%
  group_by(Variable) %>%
  mutate(
    p_BH =
      p.adjust(
        p_raw,
        method = "BH"
      )
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 16. Funerary subtype descriptives + inferential analysis for adequately-sized
#     subtype groups (n >= 3)
# ------------------------------------------------------------------------------

funerary_fit <- fit %>%
  filter(class4 == "Funerary")

funerary_descriptives <- funerary_fit %>%
  group_by(funerary_subtype_norm) %>%
  summarise(
    n = n(),

    Median_C =
      median(
        .data[[C_VAR]],
        na.rm = TRUE
      ),

    Q1_C =
      quantile(
        .data[[C_VAR]],
        0.25,
        na.rm = TRUE
      ),

    Q3_C =
      quantile(
        .data[[C_VAR]],
        0.75,
        na.rm = TRUE
      ),

    Median_Heip =
      median(
        .data[[E_VAR]],
        na.rm = TRUE
      ),

    Q1_Heip =
      quantile(
        .data[[E_VAR]],
        0.25,
        na.rm = TRUE
      ),

    Q3_Heip =
      quantile(
        .data[[E_VAR]],
        0.75,
        na.rm = TRUE
      ),

    .groups = "drop"
  ) %>%
  arrange(desc(n))

common_fun_subtypes <-
  funerary_descriptives %>%
  filter(n >= 3) %>%
  pull(funerary_subtype_norm)

fun_common <- funerary_fit %>%
  filter(
    funerary_subtype_norm %in%
      common_fun_subtypes
  )

kw_fun_subtypes <- map_dfr(
  c(C_VAR, E_VAR),
  function(v) {

    if (
      n_distinct(
        fun_common$funerary_subtype_norm
      ) < 2
    ) {
      return(
        tibble(
          Variable = v,
          Kruskal_H = NA_real_,
          df = NA_real_,
          p = NA_real_
        )
      )
    }

    dat <- fun_common %>%
      filter(
        is.finite(.data[[v]])
      )

    tst <- kruskal.test(
      dat[[v]] ~
        dat$funerary_subtype_norm
    )

    tibble(
      Variable = v,
      Kruskal_H =
        unname(tst$statistic),
      df =
        unname(tst$parameter),
      p =
        tst$p.value
    )
  }
)

pairwise_fun_subtypes <- map_dfr(
  c(C_VAR, E_VAR),
  function(v) {

    groups <- sort(
      unique(
        fun_common$funerary_subtype_norm
      )
    )

    if (length(groups) < 2) {
      return(tibble())
    }

    combn(
      groups,
      2,
      simplify = FALSE
    ) %>%
      map_dfr(
        function(pair) {

          x <- fun_common %>%
            filter(
              funerary_subtype_norm ==
                pair[1]
            ) %>%
            pull(all_of(v))
          x <- x[is.finite(x)]

          y <- fun_common %>%
            filter(
              funerary_subtype_norm ==
                pair[2]
            ) %>%
            pull(all_of(v))
          y <- y[is.finite(y)]

          wt <- wilcox.test(
            x,
            y,
            exact = FALSE
          )

          tibble(
            Variable = v,
            Group1 = pair[1],
            Group2 = pair[2],
            n1 = length(x),
            n2 = length(y),
            Median1 = median(x),
            Median2 = median(y),
            Cliffs_delta =
              cliffs_delta(x, y),
            p_raw =
              wt$p.value
          )
        }
      )
  }
)

if (nrow(pairwise_fun_subtypes) > 0) {
  pairwise_fun_subtypes <-
    pairwise_fun_subtypes %>%
    group_by(Variable) %>%
    mutate(
      p_BH =
        p.adjust(
          p_raw,
          method = "BH"
        )
    ) %>%
    ungroup()
}

# ------------------------------------------------------------------------------
# 17. Save outputs
# ------------------------------------------------------------------------------

write_csv(
  diagnostics,
  file.path(
    OUT_DIR,
    "k_diagnostics.csv"
  )
)

write_csv(
  k_summary,
  file.path(
    OUT_DIR,
    "k_summary.csv"
  )
)

write_csv(
  associations,
  file.path(
    OUT_DIR,
    "cluster_label_associations.csv"
  )
)

write_csv(
  permanova_results,
  file.path(
    OUT_DIR,
    "permanova_dispersion.csv"
  )
)

write_csv(
  profiles,
  file.path(
    OUT_DIR,
    "cluster_profiles.csv"
  )
)

write_csv(
  pca_correlations,
  file.path(
    OUT_DIR,
    "pca_correlations.csv"
  )
)

write_csv(
  fit_assignments,
  file.path(
    OUT_DIR,
    "fit_assignments_all_known.csv"
  )
)

write_csv(
  cluster_binary_percent,
  file.path(
    OUT_DIR,
    "cluster_binary_percent.csv"
  )
)

write_csv(
  cluster_class4_percent,
  file.path(
    OUT_DIR,
    "cluster_class4_percent.csv"
  )
)

write_csv(
  cluster_funerary_subtype_percent,
  file.path(
    OUT_DIR,
    "cluster_funerary_subtype_percent.csv"
  )
)

write_csv(
  binary_contingencies,
  file.path(
    OUT_DIR,
    "binary_contingencies.csv"
  )
)

write_csv(
  fourclass_contingencies,
  file.path(
    OUT_DIR,
    "fourclass_contingencies.csv"
  )
)

write_csv(
  nonfunerary_contingencies,
  file.path(
    OUT_DIR,
    "nonfunerary_threeclass_contingencies.csv"
  )
)

write_csv(
  funerary_subtype_contingencies,
  file.path(
    OUT_DIR,
    "funerary_subtype_contingencies_all.csv"
  )
)

write_csv(
  funerary_common_subtype_contingencies,
  file.path(
    OUT_DIR,
    "funerary_subtype_contingencies_n_ge_3.csv"
  )
)

write_csv(
  unknown_assignments,
  file.path(
    OUT_DIR,
    "unknown_assignments.csv"
  )
)

write_csv(
  unknown_consensus,
  file.path(
    OUT_DIR,
    "unknown_consensus.csv"
  )
)

write_csv(
  named_panel_assignments,
  file.path(
    OUT_DIR,
    "named_historical_early_assignments.csv"
  )
)

write_csv(
  named_panel_consensus,
  file.path(
    OUT_DIR,
    "named_historical_early_consensus.csv"
  )
)

write_csv(
  broad_descriptives,
  file.path(
    OUT_DIR,
    "broad_context_C_Heip_descriptives.csv"
  )
)

write_csv(
  kw_broad,
  file.path(
    OUT_DIR,
    "broad_context_C_Heip_kruskal.csv"
  )
)

write_csv(
  pairwise_broad,
  file.path(
    OUT_DIR,
    "broad_context_C_Heip_pairwise_BH.csv"
  )
)

write_csv(
  funerary_descriptives,
  file.path(
    OUT_DIR,
    "funerary_subtype_descriptives.csv"
  )
)

write_csv(
  kw_fun_subtypes,
  file.path(
    OUT_DIR,
    "funerary_subtype_C_Heip_kruskal_n_ge_3.csv"
  )
)

write_csv(
  pairwise_fun_subtypes,
  file.path(
    OUT_DIR,
    "funerary_subtype_C_Heip_pairwise_BH_n_ge_3.csv"
  )
)

# Save enough information to reproduce / inspect fitted solutions later.
saveRDS(
  list(
    input_file = INPUT_FILE,
    feature_sets = feature_sets,
    feature_manifest = feature_manifest,
    fit_summed_records = fit,
    unknown_summed_records = unknown,
    ignored_unknown = ignored_unknown,
    k_summary = k_summary,
    diagnostics = diagnostics,
    profiles = profiles,
    fit_assignments = fit_assignments,
    unknown_assignments = unknown_assignments,
    named_panel_assignments =
      named_panel_assignments
  ),
  file.path(
    OUT_DIR,
    "analysis_objects.rds"
  )
)

capture.output(
  sessionInfo(),
  file = file.path(
    OUT_DIR,
    "sessionInfo.txt"
  )
)

message(
  "Finished. Outputs are in: ",
  OUT_DIR
)
