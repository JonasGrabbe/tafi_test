# ==============================================================================
# F vs NF challenge analysis: 7 feature spaces x 4 algorithms
# Direct tapho_db_sum analysis + bilateral indeterminate redistribution
# Five balanced pseudo-unknown site panels + repeated grouped CV
#
# Tasks:
#   1) 4class:
#        Cannibalism / Carnivore / Funerary Context / Geological transport
#   2) cannibalism_vs_fc:
#        Cannibalism / Funerary Context
#   3) fc_vs_rest:
#        Funerary Context / Rest
#        Rest = Cannibalism + Carnivore + Geological transport
#
# IMPORTANT:
# - Input is final/tapho_db_sum.csv. There is no site_id dependency.
# - site_name is used only as the GROUPING variable for CV, so multiple rows from
#   the same named site can never be split between train and validation.
# - Unknown/Unkown and Sepulchral/Cuevas Sepulcrales never enter fitting,
#   preprocessing, balancing, CV performance estimation, or conformal calibration.
# - Historical/early named sites are NOT held out: if they carry one of the four
#   known reference labels, they participate normally in grouped CV.
# - Bilateral *_indet redistribution is performed BEFORE feature-space creation.
# - %MNAU and ReMNAU are used as stored after that redistribution; no Hellinger
#   transformation is applied.
# - All data-dependent preprocessing is fitted inside each training fold only.
# - Training classes are balanced by random oversampling WITHIN the training fold.
# - No hyperparameter search is performed. Settings are fixed a priori.
# - Repeated grouped CV: 5 repeats x 3 folds = 15 held-out assessments per
#   model-feature-task combination. Each reference record has one OOF prediction
#   per CV repeat (5 total), never from a model that trained on its own site.
# - Unknown-site probabilities are affinities to the reference classes under these
#   balanced classification tasks; they are NOT literal archaeological posterior
#   probabilities.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. User settings
# ------------------------------------------------------------------------------

INPUT_FILE <- "final/tapho_db_sum.csv"
OUT_DIR <- "fc_vs_rest_5group_pseudounknown_R_outputs"

SEED <- 42
CV_FOLDS <- 3L
CV_REPEATS <- 5L

RF_TREES <- 80L
RF_MIN_NODE <- 2L
SVM_COST <- 1
KNN_K <- 7L
LOGISTIC_LAMBDA <- 1

CONFORMAL_ALPHA <- 0.10

REDISTRIBUTE_BILATERAL_INDET <- TRUE
DROP_REDISTRIBUTED_INDET_FROM_FEATURES <- TRUE
PCTMNAU_MAX <- 1

# Current request/example includes Sima de los Huesos PNAS.
# Change to TRUE if you later want to omit it.
EXCLUDE_SIMA_PNAS <- FALSE
SIMA_PNAS_NAMES <- c("Sima de los Huesos PNAS")

# For the compact unknown table that mirrors the table in the prompt.
COMPACT_AFFINITY_SPACES <- c(
  "C + Heip evenness",
  "%MNAU raw",
  "ReMNAU raw",
  "Engineered",
  "Combined"
)

# Descriptive bands for "how many feature spaces are F / middle / NF".
# These are reporting bands, NOT classification thresholds.
AFFINITY_LOW <- 0.40
AFFINITY_HIGH <- 0.60

# Hard binary classification remains P(F) >= 0.5.
CLASS_THRESHOLD <- 0.50

# ------------------------------------------------------------------------------
# 1. Startup and package checks
# ------------------------------------------------------------------------------

cat("\n=== F vs NF: FIVE-GROUP PSEUDO-UNKNOWN CHALLENGE ===\n")
cat("Working directory:", normalizePath(getwd(), winslash = "/", mustWork = FALSE), "\n")

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)
if (!dir.exists(OUT_DIR)) {
  stop("Could not create output directory: ", OUT_DIR)
}

ROOT_OUT <- normalizePath(OUT_DIR, winslash = "/", mustWork = FALSE)
cat("Output directory :", ROOT_OUT, "\n")

writeLines(
  c(
    paste0("Run started: ", Sys.time()),
    paste0("Working directory: ", getwd()),
    paste0("Input: ", INPUT_FILE),
    paste0("Output: ", ROOT_OUT)
  ),
  file.path(ROOT_OUT, "RUN_STARTED.txt")
)

required_packages <- c("tidyverse", "glmnet", "ranger", "e1071")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
]

if (length(missing_packages) > 0) {
  writeLines(
    paste("Missing packages:", paste(missing_packages, collapse = ", ")),
    file.path(ROOT_OUT, "RUN_STOPPED_MISSING_PACKAGES.txt")
  )
  stop(
    "Install the following packages and rerun:\n  ",
    paste(missing_packages, collapse = ", ")
  )
}

library(tidyverse)

set.seed(SEED)

if (!file.exists(INPUT_FILE)) {
  stop(
    "Input file was not found: ", INPUT_FILE,
    "\nCurrent working directory: ", getwd()
  )
}

d_raw <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

required_columns <- c(
  "site_name", "taphonomic_context", "funerary_context",
  "Mean_part_abundance", "mnau_heip_evenness"
)
missing_required <- setdiff(required_columns, names(d_raw))
if (length(missing_required) > 0) {
  stop(
    "Missing required columns in tapho_db_sum: ",
    paste(missing_required, collapse = ", ")
  )
}

if (!"layer_name" %in% names(d_raw)) d_raw$layer_name <- NA_character_

d <- d_raw %>%
  mutate(record_id = row_number(), .before = 1)

writeLines(
  c(
    paste0("Input rows: ", nrow(d)),
    paste0("Input columns: ", ncol(d)),
    paste0("Unique site_name values: ", n_distinct(d$site_name))
  ),
  file.path(ROOT_OUT, "RUN_INPUT_OK.txt")
)

# ------------------------------------------------------------------------------
# 2. Bilateral indeterminate redistribution
# ------------------------------------------------------------------------------

find_bilateral_triplets <- function(data_names, prefix, feature_type) {
  indet <- data_names[
    stringr::str_starts(data_names, prefix) &
      stringr::str_ends(data_names, "_indet")
  ]

  if (length(indet) == 0) return(tibble())

  tibble(
    feature_type = feature_type,
    indet_col = indet,
    base = stringr::str_remove(indet, "_indet$"),
    left_col = paste0(base, "_left"),
    right_col = paste0(base, "_right")
  ) %>%
    filter(left_col %in% data_names, right_col %in% data_names) %>%
    mutate(
      anatomical_part = stringr::str_remove(base, paste0("^", prefix))
    )
}

# Raw ReMNAU columns only. If adjusted copies exist, do not redistribute them here.
raw_rem_names <- names(d)[
  str_starts(names(d), "ReMNAU_") &
    !str_starts(names(d), "ReMNAU_adjusted_")
]

indet_pairs <- bind_rows(
  find_bilateral_triplets(
    names(d),
    "ProportionalRep_MNIbased_",
    "%MNAU"
  ),
  find_bilateral_triplets(
    raw_rem_names,
    "ReMNAU_",
    "ReMNAU"
  )
)

redistribute_bilateral_pair <- function(
  dat, indet_col, left_col, right_col,
  feature_type, anatomical_part, max_value = Inf
) {
  i_before <- dat[[indet_col]]
  l_before <- dat[[left_col]]
  r_before <- dat[[right_col]]

  i_after <- i_before
  l_after <- l_before
  r_after <- r_before

  audit_rows <- list()
  ai <- 1L

  rows <- which(is.finite(i_before) & i_before > 0)

  for (j in rows) {
    amount <- i_before[j]

    l0 <- if (is.na(l_before[j])) 0 else l_before[j]
    r0 <- if (is.na(r_before[j])) 0 else r_before[j]

    if (is.finite(max_value)) {
      cap_l <- max(0, max_value - l0)
      cap_r <- max(0, max_value - r0)
    } else {
      cap_l <- Inf
      cap_r <- Inf
    }

    # Start with the most even possible 50:50 split.
    add_l <- if (is.finite(cap_l)) min(amount / 2, cap_l) else amount / 2
    add_r <- if (is.finite(cap_r)) min(amount / 2, cap_r) else amount / 2
    remaining <- amount - add_l - add_r

    # Reallocate any remainder to whichever side still has capacity.
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

    audit_rows[[ai]] <- tibble(
      record_id = dat$record_id[j],
      site_name = dat$site_name[j],
      taphonomic_context = dat$taphonomic_context[j],
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
      right_after = r_after[j],
      pct_cap = if (is.finite(max_value)) max_value else NA_real_
    )
    ai <- ai + 1L
  }

  dat[[indet_col]] <- i_after
  dat[[left_col]] <- l_after
  dat[[right_col]] <- r_after

  list(
    data = dat,
    audit = if (length(audit_rows) > 0) bind_rows(audit_rows) else tibble()
  )
}

indet_audit_parts <- list()

if (REDISTRIBUTE_BILATERAL_INDET && nrow(indet_pairs) > 0) {
  for (ii in seq_len(nrow(indet_pairs))) {
    pair <- indet_pairs[ii, ]
    max_val <- if (pair$feature_type == "%MNAU") PCTMNAU_MAX else Inf

    rr <- redistribute_bilateral_pair(
      dat = d,
      indet_col = pair$indet_col,
      left_col = pair$left_col,
      right_col = pair$right_col,
      feature_type = pair$feature_type,
      anatomical_part = pair$anatomical_part,
      max_value = max_val
    )

    d <- rr$data
    indet_audit_parts[[paste(pair$feature_type, pair$anatomical_part, sep = "_")]] <- rr$audit
  }
}

indet_redistribution_audit <- bind_rows(indet_audit_parts)

if (nrow(indet_redistribution_audit) > 0) {
  indet_redistribution_summary <- indet_redistribution_audit %>%
    group_by(feature_type, anatomical_part, indet_col, left_col, right_col) %>%
    summarise(
      n_records_redistributed = n(),
      total_indet_before = sum(indet_before, na.rm = TRUE),
      total_assigned_left = sum(assigned_left, na.rm = TRUE),
      total_assigned_right = sum(assigned_right, na.rm = TRUE),
      total_residual_indet = sum(residual_indet, na.rm = TRUE),
      n_with_residual = sum(residual_indet > 1e-12, na.rm = TRUE),
      .groups = "drop"
    )
} else {
  indet_redistribution_summary <- indet_pairs %>%
    transmute(
      feature_type, anatomical_part, indet_col, left_col, right_col,
      n_records_redistributed = 0L,
      total_indet_before = 0,
      total_assigned_left = 0,
      total_assigned_right = 0,
      total_residual_indet = 0,
      n_with_residual = 0L
    )
}

write_csv(indet_pairs, file.path(ROOT_OUT, "indet_bilateral_pairs_detected.csv"))
write_csv(indet_redistribution_audit, file.path(ROOT_OUT, "indet_redistribution_audit.csv"))
write_csv(indet_redistribution_summary, file.path(ROOT_OUT, "indet_redistribution_summary.csv"))

# ------------------------------------------------------------------------------
# 3. Archaeological labels and target sets
# ------------------------------------------------------------------------------

collapse_class4 <- function(x) {
  case_when(
    x == "Funerary Context" ~ "Funerary Context",
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore",
      "Carnivore-related",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)",
      "Carnivore den (transport)"
    ) ~ "Carnivore",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

d <- d %>%
  mutate(class4 = collapse_class4(taphonomic_context))

unknown <- d %>%
  filter(taphonomic_context %in% c("Unknown", "Unkown"))

if (EXCLUDE_SIMA_PNAS) {
  unknown <- unknown %>% filter(!site_name %in% SIMA_PNAS_NAMES)
}

sepulchral <- d %>%
  filter(taphonomic_context %in% c("Cuevas Sepulcrales", "Sepulchral Cave"))

known_reference <- d %>%
  filter(!is.na(class4))

partition <- tibble(
  dataset = c("Known reference", "Unknown/Unkown projection", "Sepulchral projection"),
  n_rows = c(nrow(known_reference), nrow(unknown), nrow(sepulchral)),
  unique_site_names = c(
    n_distinct(known_reference$site_name),
    n_distinct(unknown$site_name),
    n_distinct(sepulchral$site_name)
  )
)

write_csv(partition, file.path(ROOT_OUT, "sample_partition.csv"))
write_csv(
  known_reference %>% count(class4, name = "n"),
  file.path(ROOT_OUT, "known_reference_class_counts.csv")
)

# ------------------------------------------------------------------------------
# 4. Seven feature spaces
# ------------------------------------------------------------------------------

C_var <- "Mean_part_abundance"
E_var <- "mnau_heip_evenness"

prop_cols <- names(d)[
  str_starts(names(d), "ProportionalRep_MNIbased_")
]

rem_cols <- names(d)[
  str_starts(names(d), "ReMNAU_") &
    !str_starts(names(d), "ReMNAU_adjusted_")
]

prop_indet_exclude <- indet_pairs %>%
  filter(feature_type == "%MNAU") %>%
  pull(indet_col)

rem_indet_exclude <- indet_pairs %>%
  filter(feature_type == "ReMNAU") %>%
  pull(indet_col)

if (DROP_REDISTRIBUTED_INDET_FROM_FEATURES) {
  prop_cols <- setdiff(prop_cols, prop_indet_exclude)
  rem_cols <- setdiff(rem_cols, rem_indet_exclude)
}

eng_cols_requested <- c(
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

eng_cols <- intersect(eng_cols_requested, names(d))

feature_sets <- list(
  `C only` = C_var,
  `Heip evenness only` = E_var,
  `C + Heip evenness` = c(C_var, E_var),
  `%MNAU raw` = prop_cols,
  `ReMNAU raw` = rem_cols,
  `Engineered` = eng_cols,
  `Combined` = unique(c(prop_cols, rem_cols, eng_cols))
)

if (any(lengths(feature_sets) == 0)) {
  stop(
    "At least one feature space contains zero variables: ",
    paste(names(feature_sets)[lengths(feature_sets) == 0], collapse = ", ")
  )
}

feature_manifest <- imap_dfr(
  feature_sets,
  ~ tibble(
    feature_space = .y,
    n_features_requested = length(.x),
    variable = .x
  )
)
write_csv(feature_manifest, file.path(ROOT_OUT, "feature_manifest.csv"))

# ------------------------------------------------------------------------------
# 5. Classification tasks
# ------------------------------------------------------------------------------

task_classes <- list(
  `4class` = c(
    "Cannibalism",
    "Carnivore",
    "Funerary Context",
    "Geological transport"
  ),
  `cannibalism_vs_fc` = c(
    "Cannibalism",
    "Funerary Context"
  ),
  `fc_vs_rest` = c(
    "Rest",
    "Funerary Context"
  )
)

make_task_data <- function(task_name, dat) {
  if (task_name == "4class") {
    return(
      dat %>%
        filter(!is.na(class4)) %>%
        mutate(task_label = class4)
    )
  }

  if (task_name == "cannibalism_vs_fc") {
    return(
      dat %>%
        filter(class4 %in% c("Cannibalism", "Funerary Context")) %>%
        mutate(task_label = class4)
    )
  }

  if (task_name == "fc_vs_rest") {
    return(
      dat %>%
        filter(!is.na(class4)) %>%
        mutate(
          task_label = if_else(
            class4 == "Funerary Context",
            "Funerary Context",
            "Rest"
          )
        )
    )
  }

  stop("Unknown task: ", task_name)
}

# ------------------------------------------------------------------------------
# 6. Grouped stratified fold map
# ------------------------------------------------------------------------------

make_grouped_stratified_folds <- function(
  dat, v = 3L, repeats = 5L, seed = 42L
) {
  if (any(is.na(dat$site_name) | dat$site_name == "")) {
    stop("site_name contains missing/blank values; grouped CV requires site_name.")
  }

  group_labels <- dat %>%
    distinct(site_name, task_label)

  inconsistent <- group_labels %>%
    count(site_name, name = "n_labels") %>%
    filter(n_labels > 1)

  if (nrow(inconsistent) > 0) {
    stop(
      "At least one site_name has multiple task labels within the same task: ",
      paste(head(inconsistent$site_name, 10), collapse = ", ")
    )
  }

  min_groups <- group_labels %>%
    count(task_label, name = "n_groups") %>%
    summarise(min_n = min(n_groups)) %>%
    pull(min_n)

  if (min_groups < v) {
    stop(
      "Cannot make ", v, " grouped folds because the smallest class has only ",
      min_groups, " unique site_name groups."
    )
  }

  maps <- vector("list", repeats)

  for (r in seq_len(repeats)) {
    set.seed(seed + r * 1009L)

    one <- group_labels %>%
      group_by(task_label) %>%
      group_modify(~ {
        g <- sample(.x$site_name, length(.x$site_name), replace = FALSE)
        tibble(
          site_name = g,
          fold = rep(seq_len(v), length.out = length(g))
        )
      }) %>%
      ungroup() %>%
      mutate(repeat_id = r)

    maps[[r]] <- one
  }

  bind_rows(maps)
}

# ------------------------------------------------------------------------------
# 7. Fold-specific preprocessing
# ------------------------------------------------------------------------------

fit_preprocessor <- function(train, vars) {
  med <- map_dbl(vars, function(v) {
    z <- train[[v]]
    m <- suppressWarnings(median(z, na.rm = TRUE))
    if (!is.finite(m)) 0 else m
  })
  names(med) <- vars

  impute <- function(dat) {
    x <- as.data.frame(dat[, vars, drop = FALSE])

    for (v in vars) {
      bad <- !is.finite(x[[v]]) | is.na(x[[v]])
      x[[v]][bad] <- med[[v]]
    }

    as.matrix(x)
  }

  xtr0 <- impute(train)

  mu <- colMeans(xtr0)
  sdv <- apply(xtr0, 2, sd)

  keep <- is.finite(sdv) & sdv > 0

  # If all variables are constant in a fold, stop rather than fabricate a model.
  if (!any(keep)) {
    stop("All variables are zero-variance in one training fold.")
  }

  keep_vars <- vars[keep]
  mu <- mu[keep]
  sdv <- sdv[keep]

  transform_raw <- function(dat) {
    xx <- impute(dat)
    xx[, keep, drop = FALSE]
  }

  transform_scaled <- function(dat) {
    xx <- transform_raw(dat)
    sweep(sweep(xx, 2, mu, "-"), 2, sdv, "/")
  }

  list(
    vars = vars,
    keep_vars = keep_vars,
    medians = med,
    means = mu,
    sds = sdv,
    train_raw = transform_raw(train),
    train_scaled = transform_scaled(train),
    transform_raw = transform_raw,
    transform_scaled = transform_scaled
  )
}

# ------------------------------------------------------------------------------
# 8. Training-fold oversampling
# ------------------------------------------------------------------------------

balance_indices <- function(y, seed) {
  y <- as.character(y)
  classes <- sort(unique(y))
  counts <- table(y)
  target_n <- max(counts)

  set.seed(seed)

  idx <- unlist(
    lapply(classes, function(cl) {
      ii <- which(y == cl)

      if (length(ii) < target_n) {
        c(ii, sample(ii, target_n - length(ii), replace = TRUE))
      } else {
        ii
      }
    }),
    use.names = FALSE
  )

  sample(idx, length(idx), replace = FALSE)
}

# ------------------------------------------------------------------------------
# 9. Four fixed classifiers
# ------------------------------------------------------------------------------

align_probability_matrix <- function(P, classes) {
  P <- as.matrix(P)

  if (is.null(colnames(P))) {
    if (ncol(P) != length(classes)) {
      stop("Probability matrix has no class names and unexpected number of columns.")
    }
    colnames(P) <- classes
  }

  missing <- setdiff(classes, colnames(P))
  if (length(missing) > 0) {
    stop(
      "Probability output is missing class(es): ",
      paste(missing, collapse = ", ")
    )
  }

  P <- P[, classes, drop = FALSE]

  # Numerical guard.
  P[P < 0] <- 0
  rs <- rowSums(P)
  rs[!is.finite(rs) | rs <= 0] <- 1
  P / rs
}

predict_logistic <- function(X_train, y_train, X_new, classes) {
  family_name <- if (length(classes) == 2) "binomial" else "multinomial"

  # glmnet requires an x matrix with at least two columns. C-only and
  # Heip-only are scientifically valid one-predictor models, so for glmnet's
  # interface only we append a constant-zero dummy predictor. Its coefficient
  # contributes exactly zero to every linear predictor, so the substantive
  # fitted model remains one-dimensional. Other algorithms never see it.
  if (ncol(X_train) == 1L) {
    X_train_glmnet <- cbind(
      X_train,
      .glmnet_zero_dummy = rep(0, nrow(X_train))
    )
    X_new_glmnet <- cbind(
      X_new,
      .glmnet_zero_dummy = rep(0, nrow(X_new))
    )
  } else {
    X_train_glmnet <- X_train
    X_new_glmnet <- X_new
  }

  fit <- glmnet::glmnet(
    x = X_train_glmnet,
    y = factor(y_train, levels = classes),
    family = family_name,
    alpha = 0,
    lambda = LOGISTIC_LAMBDA,
    standardize = FALSE
  )

  pr <- predict(
    fit,
    newx = X_new_glmnet,
    type = "response",
    s = LOGISTIC_LAMBDA
  )

  if (length(classes) == 2) {
    # glmnet binomial response is P(second factor level).
    p2 <- as.numeric(pr)
    P <- cbind(1 - p2, p2)
    colnames(P) <- classes
  } else {
    # n x class x lambda
    P <- pr[, , 1, drop = FALSE]
    P <- P[, , 1]
    if (is.vector(P)) P <- matrix(P, nrow = nrow(X_new))
  }

  align_probability_matrix(P, classes)
}

predict_rf <- function(X_train, y_train, X_new, classes) {
  tr <- as.data.frame(X_train)
  names(tr) <- paste0("X", seq_len(ncol(tr)))
  tr$.y <- factor(y_train, levels = classes)

  te <- as.data.frame(X_new)
  names(te) <- paste0("X", seq_len(ncol(te)))

  mtry_val <- max(1L, floor(sqrt(ncol(X_train))))

  fit <- ranger::ranger(
    .y ~ .,
    data = tr,
    probability = TRUE,
    num.trees = RF_TREES,
    mtry = mtry_val,
    min.node.size = RF_MIN_NODE,
    seed = SEED
  )

  P <- predict(fit, data = te)$predictions
  align_probability_matrix(P, classes)
}

predict_svm <- function(X_train, y_train, X_new, classes) {
  fit <- e1071::svm(
    x = X_train,
    y = factor(y_train, levels = classes),
    kernel = "radial",
    cost = SVM_COST,
    gamma = 1 / ncol(X_train),
    scale = FALSE,
    probability = TRUE
  )

  pred <- predict(
    fit,
    X_new,
    probability = TRUE,
    decision.values = FALSE
  )

  P <- attr(pred, "probabilities")
  align_probability_matrix(P, classes)
}

predict_weighted_knn <- function(X_train, y_train, X_new, classes, k = 7L) {
  k_use <- min(k, nrow(X_train))
  P <- matrix(
    0,
    nrow = nrow(X_new),
    ncol = length(classes),
    dimnames = list(NULL, classes)
  )

  for (i in seq_len(nrow(X_new))) {
    dif <- sweep(X_train, 2, X_new[i, ], "-")
    dst <- sqrt(rowSums(dif^2))
    ord <- order(dst)[seq_len(k_use)]

    d <- dst[ord]
    yy <- y_train[ord]

    # Exact matches dominate without infinite numeric weights.
    if (any(d <= 1e-12)) {
      exact <- yy[d <= 1e-12]
      wtab <- table(factor(exact, levels = classes))
      P[i, ] <- as.numeric(wtab) / sum(wtab)
    } else {
      w <- 1 / d
      score <- vapply(
        classes,
        function(cl) sum(w[yy == cl]),
        numeric(1)
      )
      P[i, ] <- score / sum(score)
    }
  }

  P
}

predict_model <- function(
  model_name,
  X_train_scaled,
  X_train_raw,
  y_train,
  X_new_scaled,
  X_new_raw,
  classes
) {
  if (model_name == "Logistic regression") {
    return(predict_logistic(X_train_scaled, y_train, X_new_scaled, classes))
  }

  if (model_name == "Random forest") {
    return(predict_rf(X_train_raw, y_train, X_new_raw, classes))
  }

  if (model_name == "RBF-SVM") {
    return(predict_svm(X_train_scaled, y_train, X_new_scaled, classes))
  }

  if (model_name == "KNN") {
    return(
      predict_weighted_knn(
        X_train_scaled,
        y_train,
        X_new_scaled,
        classes,
        k = KNN_K
      )
    )
  }

  stop("Unknown model: ", model_name)
}

model_names <- c(
  "Logistic regression",
  "Random forest",
  "RBF-SVM",
  "KNN"
)

# ------------------------------------------------------------------------------
# 10. Metrics
# ------------------------------------------------------------------------------

binary_auc <- function(y01, score) {
  ok <- is.finite(score) & !is.na(y01)
  y01 <- y01[ok]
  score <- score[ok]

  n1 <- sum(y01 == 1)
  n0 <- sum(y01 == 0)

  if (n1 == 0 || n0 == 0) return(NA_real_)

  r <- rank(score, ties.method = "average")
  (sum(r[y01 == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0)
}

calc_metrics <- function(truth, P, classes) {
  truth <- factor(truth, levels = classes)
  pred <- factor(classes[max.col(P, ties.method = "first")], levels = classes)

  tab <- table(truth, pred)

  recalls <- vapply(seq_along(classes), function(j) {
    den <- sum(tab[j, ])
    if (den == 0) return(NA_real_)
    tab[j, j] / den
  }, numeric(1))

  precisions <- vapply(seq_along(classes), function(j) {
    den <- sum(tab[, j])
    if (den == 0) return(NA_real_)
    tab[j, j] / den
  }, numeric(1))

  balanced_accuracy <- mean(recalls, na.rm = TRUE)
  macro_precision <- mean(precisions, na.rm = TRUE)
  macro_recall <- mean(recalls, na.rm = TRUE)

  if (length(classes) == 2) {
    positive <- "Funerary Context"
    if (!positive %in% classes) positive <- classes[2]

    y01 <- as.integer(truth == positive)
    roc_auc <- binary_auc(y01, P[, positive])
    brier <- mean((P[, positive] - y01)^2)

    pos_j <- which(classes == positive)
    precision <- precisions[pos_j]
    recall <- recalls[pos_j]
  } else {
    aucs <- vapply(classes, function(cl) {
      binary_auc(
        as.integer(truth == cl),
        P[, cl]
      )
    }, numeric(1))

    roc_auc <- mean(aucs, na.rm = TRUE)

    Y <- sapply(classes, function(cl) as.integer(truth == cl))
    brier <- mean(rowSums((P - Y)^2))

    precision <- macro_precision
    recall <- macro_recall
  }

  tibble(
    n = length(truth),
    balanced_accuracy = balanced_accuracy,
    roc_auc = roc_auc,
    precision = precision,
    recall = recall,
    brier = brier
  )
}

prob_to_long <- function(
  P, meta, classes,
  task_name, feature_space, model_name,
  repeat_id, fold_id, dataset_role
) {
  as_tibble(P, .name_repair = "minimal") %>%
    setNames(classes) %>%
    bind_cols(
      meta %>%
        select(
          record_id, site_name, layer_name,
          taphonomic_context, funerary_context,
          any_of(c("task_label", "class4"))
        )
    ) %>%
    pivot_longer(
      cols = all_of(classes),
      names_to = "class",
      values_to = "probability"
    ) %>%
    mutate(
      task = task_name,
      feature_space = feature_space,
      model = model_name,
      repeat_id = repeat_id,
      fold = fold_id,
      dataset_role = dataset_role,
      .before = 1
    )
}


# ==============================================================================
# 11. Five-group pseudo-unknown challenge design
# ==============================================================================

# The supplied list has 27 entries but La Ferrassie appears twice, so there are
# 26 unique requested site names. Sites are assigned to five OUTER holdout
# panels, stratified by the binary F-vs-Rest label.
#
# For each outer panel:
#   - every row belonging to those site_name values is removed from fitting;
#   - the remaining labelled reference is split by site_name into 3 folds;
#   - the 3-fold grouped CV is repeated 5 times;
#   - each of the 15 fold-trained models predicts the outer held-out panel;
#   - this is repeated for 7 feature spaces x 4 algorithms.
#
# Therefore each held-out SITE receives:
#   7 spaces x 4 algorithms x 3 folds x 5 repeats = 420 model predictions.
#
# A site represented by multiple rows is first averaged WITHIN each fitted model,
# so it still contributes exactly 420 site-level predictions rather than being
# weighted more heavily because it has several assemblage rows.

CHALLENGE_SITES_REQUESTED <- c(
  "La Chapelle-aux-Saints",
  "La Ferrassie",
  "Regourdou",
  "Roc de Marsal",
  "Shanidar Cave",
  "Krapina",
  "La Quina",
  "Moula-Guercy",
  "Grotta Guattari",
  "Mladeč Caves",
  "Cro-Magnon I",
  "Brno II",
  "Teshik-Tash Cave",
  "Cueva de los Torrejones",
  "Crow Creek",
  "Goat’s Hole (Paviland Cave)",
  "El Sidrón J1",
  "Mancos 5MT-10010 Feature 3",
  "Yellow Jacket 5MT-3",
  "Qafzeh Cave",
  "Tabun Cave (Mugharet et-Tabun)",
  "Mugharet es-Skhul",
  "Grotte de Fontbrégoua",
  "Cova Gran de Santa Linya",
  "Sima de las Palomas",
  "Kebara Cave",
  "La Ferrassie"
)

N_OUTER_GROUPS <- 5L
OUTER_GROUP_SEED <- 20260911L
TASK_NAME <- "fc_vs_rest"
CLASSES <- c("Rest", "Funerary Context")

challenge_request_audit <- tibble(
  request_order = seq_along(CHALLENGE_SITES_REQUESTED),
  requested_site_name = CHALLENGE_SITES_REQUESTED,
  duplicated_in_request = duplicated(CHALLENGE_SITES_REQUESTED)
)

write_csv(
  challenge_request_audit,
  file.path(ROOT_OUT, "challenge_requested_sites_audit.csv")
)

challenge_sites <- unique(CHALLENGE_SITES_REQUESTED)

task_all <- make_task_data(TASK_NAME, known_reference) %>%
  mutate(
    task_label = factor(task_label, levels = CLASSES)
  ) %>%
  arrange(record_id)

available_names <- unique(task_all$site_name)
missing_challenge <- setdiff(challenge_sites, available_names)

if (length(missing_challenge) > 0) {
  writeLines(
    c(
      "The following requested site names were not found exactly:",
      missing_challenge
    ),
    file.path(ROOT_OUT, "STOPPED_missing_challenge_site_names.txt")
  )
  stop(
    "Requested challenge site_name values not found exactly:\n  ",
    paste(missing_challenge, collapse = "\n  "),
    "\nCheck spelling against tapho_db_sum.csv."
  )
}

site_labels <- task_all %>%
  filter(site_name %in% challenge_sites) %>%
  group_by(site_name) %>%
  summarise(
    n_rows_for_site = n(),
    n_binary_labels = n_distinct(as.character(task_label)),
    assigned_dataset_label = first(as.character(task_label)),
    original_taphonomic_context =
      paste(sort(unique(na.omit(taphonomic_context))), collapse = "; "),
    .groups = "drop"
  )

bad_labels <- site_labels %>% filter(n_binary_labels != 1L)
if (nrow(bad_labels) > 0) {
  stop(
    "At least one requested site has inconsistent F-vs-Rest labels: ",
    paste(bad_labels$site_name, collapse = ", ")
  )
}

# Stratified round-robin allocation. Within each class, names are shuffled once,
# then distributed cyclically across the five groups. With the current requested
# panel (19 Funerary, 7 Rest), this distributes the two classes as evenly as
# mathematically possible across five groups.
set.seed(OUTER_GROUP_SEED)

challenge_group_assignment <- site_labels %>%
  select(
    site_name, n_rows_for_site,
    assigned_dataset_label, original_taphonomic_context
  ) %>%
  group_by(assigned_dataset_label) %>%
  group_modify(~ {
    x <- .x[sample(seq_len(nrow(.x))), , drop = FALSE]
    x$holdout_group <- rep(
      seq_len(N_OUTER_GROUPS),
      length.out = nrow(x)
    )
    x
  }) %>%
  ungroup() %>%
  arrange(holdout_group, assigned_dataset_label, site_name)

group_balance <- challenge_group_assignment %>%
  count(holdout_group, assigned_dataset_label, name = "n_sites") %>%
  tidyr::complete(
    holdout_group = seq_len(N_OUTER_GROUPS),
    assigned_dataset_label = CLASSES,
    fill = list(n_sites = 0L)
  ) %>%
  arrange(holdout_group, assigned_dataset_label)

group_sizes <- challenge_group_assignment %>%
  count(holdout_group, name = "n_sites_total")

write_csv(
  challenge_group_assignment,
  file.path(ROOT_OUT, "challenge_5group_assignment.csv")
)
write_csv(
  group_balance,
  file.path(ROOT_OUT, "challenge_5group_class_balance.csv")
)
write_csv(
  group_sizes,
  file.path(ROOT_OUT, "challenge_5group_sizes.csv")
)

cat("\nRequested entries :", length(CHALLENGE_SITES_REQUESTED), "\n")
cat("Unique sites      :", length(challenge_sites), "\n")
cat("Binary labels:\n")
print(challenge_group_assignment %>% count(assigned_dataset_label))
cat("\nFive holdout groups:\n")
print(group_balance)

# ==============================================================================
# 12. Run each outer pseudo-unknown group
# ==============================================================================

challenge_prediction_parts <- list()
inner_oof_parts <- list()
inner_fold_metric_parts <- list()
inner_fold_map_parts <- list()

pred_counter <- 1L
oof_counter <- 1L
metric_counter <- 1L
foldmap_counter <- 1L

for (g in seq_len(N_OUTER_GROUPS)) {
  cat("\n============================================================\n")
  cat("OUTER HOLDOUT GROUP", g, "OF", N_OUTER_GROUPS, "\n")
  cat("============================================================\n")

  heldout_sites <- challenge_group_assignment %>%
    filter(holdout_group == g) %>%
    pull(site_name)

  challenge_holdout <- task_all %>%
    filter(site_name %in% heldout_sites) %>%
    mutate(outer_holdout_group = g)

  train_reference <- task_all %>%
    filter(!site_name %in% heldout_sites)

  if (any(challenge_holdout$site_name %in% train_reference$site_name)) {
    stop("Leakage detected: an outer-held-out site remains in the training reference.")
  }

  # The OUTER held-out group is never used for these folds or any preprocessing.
  fold_map <- make_grouped_stratified_folds(
    train_reference,
    v = CV_FOLDS,
    repeats = CV_REPEATS,
    seed = SEED + g * 100000L
  ) %>%
    mutate(
      outer_holdout_group = g,
      .before = 1
    )

  inner_fold_map_parts[[foldmap_counter]] <- fold_map
  foldmap_counter <- foldmap_counter + 1L

  for (space_name in names(feature_sets)) {
    vars <- feature_sets[[space_name]]
    cat("  ", space_name, "\n")

    for (r in seq_len(CV_REPEATS)) {
      fm_r <- fold_map %>% filter(repeat_id == r)

      for (f in seq_len(CV_FOLDS)) {
        inner_valid_sites <- fm_r %>%
          filter(fold == f) %>%
          pull(site_name)

        train <- train_reference %>%
          filter(!site_name %in% inner_valid_sites)

        inner_valid <- train_reference %>%
          filter(site_name %in% inner_valid_sites)

        if (any(train$site_name %in% inner_valid$site_name)) {
          stop("Inner grouped-CV leakage detected.")
        }

        pp <- fit_preprocessor(train, vars)

        Xtr_s <- pp$train_scaled
        Xtr_r <- pp$train_raw

        Xval_s <- pp$transform_scaled(inner_valid)
        Xval_r <- pp$transform_raw(inner_valid)

        Xhold_s <- pp$transform_scaled(challenge_holdout)
        Xhold_r <- pp$transform_raw(challenge_holdout)

        ytr <- as.character(train$task_label)
        yval <- as.character(inner_valid$task_label)

        bal_idx <- balance_indices(
          ytr,
          seed =
            SEED +
            g * 1000000L +
            match(space_name, names(feature_sets)) * 10000L +
            r * 100L + f
        )

        Xtr_s_bal <- Xtr_s[bal_idx, , drop = FALSE]
        Xtr_r_bal <- Xtr_r[bal_idx, , drop = FALSE]
        ytr_bal <- ytr[bal_idx]

        for (model_name in model_names) {
          # Fit exactly once and use that fitted model for both the inner
          # validation fold and the completely untouched OUTER challenge panel.
          n_val <- nrow(inner_valid)
          n_hold <- nrow(challenge_holdout)

          Xnew_s <- rbind(Xval_s, Xhold_s)
          Xnew_r <- rbind(Xval_r, Xhold_r)

          Pall <- predict_model(
            model_name,
            Xtr_s_bal, Xtr_r_bal, ytr_bal,
            Xnew_s, Xnew_r,
            CLASSES
          )

          Pval <- Pall[seq_len(n_val), , drop = FALSE]
          idx_hold <- n_val + seq_len(n_hold)
          Phold <- Pall[idx_hold, , drop = FALSE]

          # Internal CV metrics for the reduced training reference.
          inner_met <- calc_metrics(
            truth = yval,
            P = Pval,
            classes = CLASSES
          ) %>%
            mutate(
              outer_holdout_group = g,
              feature_space = space_name,
              model = model_name,
              repeat_id = r,
              fold = f,
              n_train_before_balance = length(ytr),
              n_train_after_balance = length(ytr_bal),
              n_features_used = ncol(Xtr_s),
              .before = 1
            )

          inner_fold_metric_parts[[metric_counter]] <- inner_met
          metric_counter <- metric_counter + 1L

          inner_oof_parts[[oof_counter]] <- prob_to_long(
            Pval,
            inner_valid,
            CLASSES,
            TASK_NAME,
            space_name,
            model_name,
            r,
            f,
            paste0("Inner OOF; outer group ", g)
          ) %>%
            mutate(outer_holdout_group = g, .before = 1)

          oof_counter <- oof_counter + 1L

          challenge_prediction_parts[[pred_counter]] <- prob_to_long(
            Phold,
            challenge_holdout,
            CLASSES,
            TASK_NAME,
            space_name,
            model_name,
            r,
            f,
            paste0("Pseudo-unknown holdout group ", g)
          ) %>%
            mutate(outer_holdout_group = g, .before = 1)

          pred_counter <- pred_counter + 1L
        }
      }
    }
  }
}

challenge_predictions_long <- bind_rows(challenge_prediction_parts)
inner_oof_long <- bind_rows(inner_oof_parts)
inner_fold_metrics <- bind_rows(inner_fold_metric_parts)
inner_fold_maps <- bind_rows(inner_fold_map_parts)

write_csv(
  challenge_predictions_long,
  file.path(ROOT_OUT, "challenge_probabilities_all_fold_models_long.csv")
)
write_csv(
  inner_oof_long,
  file.path(ROOT_OUT, "inner_OOF_probabilities_long.csv")
)
write_csv(
  inner_fold_metrics,
  file.path(ROOT_OUT, "inner_fold_level_performance.csv")
)
write_csv(
  inner_fold_maps,
  file.path(ROOT_OUT, "inner_grouped_cv_fold_maps.csv")
)

# ==============================================================================
# 13. Collapse multiple rows to ONE site-level prediction per fitted model
# ==============================================================================

challenge_F_fit <- challenge_predictions_long %>%
  filter(class == "Funerary Context") %>%
  group_by(
    outer_holdout_group,
    site_name,
    feature_space,
    model,
    repeat_id,
    fold
  ) %>%
  summarise(
    P_F = mean(probability, na.rm = TRUE),
    n_assemblage_rows = n_distinct(record_id),
    assigned_dataset_label = first(as.character(task_label)),
    original_taphonomic_context =
      paste(sort(unique(na.omit(taphonomic_context))), collapse = "; "),
    .groups = "drop"
  )

# Each unique challenge site should now have exactly 420 fitted-model predictions.
prediction_count_check <- challenge_F_fit %>%
  count(site_name, name = "n_site_level_model_predictions") %>%
  mutate(expected = length(feature_sets) * length(model_names) * CV_FOLDS * CV_REPEATS)

write_csv(
  prediction_count_check,
  file.path(ROOT_OUT, "challenge_420_prediction_count_check.csv")
)

bad_prediction_counts <- prediction_count_check %>%
  filter(n_site_level_model_predictions != expected)

if (nrow(bad_prediction_counts) > 0) {
  stop(
    "At least one held-out site did not receive exactly 420 site-level predictions. ",
    "See challenge_420_prediction_count_check.csv."
  )
}

# ==============================================================================
# 14. Site x feature-space and site x model summaries
# ==============================================================================

challenge_by_space <- challenge_F_fit %>%
  group_by(
    outer_holdout_group,
    site_name,
    assigned_dataset_label,
    feature_space
  ) %>%
  summarise(
    Mean_P_F = mean(P_F, na.rm = TRUE),
    SD_P_F = sd(P_F, na.rm = TRUE),
    F_decisions_percent = 100 * mean(P_F >= CLASS_THRESHOLD, na.rm = TRUE),
    n_model_predictions = n(),
    .groups = "drop"
  )

challenge_by_space_model <- challenge_F_fit %>%
  group_by(
    outer_holdout_group,
    site_name,
    assigned_dataset_label,
    feature_space,
    model
  ) %>%
  summarise(
    Mean_P_F = mean(P_F, na.rm = TRUE),
    SD_P_F = sd(P_F, na.rm = TRUE),
    F_decisions_percent = 100 * mean(P_F >= CLASS_THRESHOLD, na.rm = TRUE),
    n_fold_models = n(),
    .groups = "drop"
  )

write_csv(
  challenge_by_space,
  file.path(ROOT_OUT, "challenge_probability_by_feature_space.csv")
)
write_csv(
  challenge_by_space_model,
  file.path(ROOT_OUT, "challenge_probability_by_space_model.csv")
)

# ==============================================================================
# 15. Compact report: 28 feature-space x algorithm pipelines
# ==============================================================================

# Seven-space summaries are retained for representation-sensitivity diagnostics.
# These average the four algorithms within each feature space.
space_vote_summary <- challenge_by_space %>%
  group_by(
    outer_holdout_group,
    site_name,
    assigned_dataset_label
  ) %>%
  summarise(
    n_spaces = n(),
    F_voting_spaces = sum(Mean_P_F >= CLASS_THRESHOLD),
    Min_space_P_F = min(Mean_P_F),
    Max_space_P_F = max(Mean_P_F),
    Space_range_P_F = Max_space_P_F - Min_space_P_F,
    representation_sensitive =
      (Max_space_P_F > AFFINITY_HIGH & Min_space_P_F < AFFINITY_LOW) |
      Space_range_P_F >= 0.35,
    .groups = "drop"
  )

# PRIMARY vote count for reporting:
# 7 feature spaces x 4 algorithms = 28 distinct pipelines.
# A pipeline votes F when its mean across the 15 outer-held-out fold models is
# P(F) >= 0.50.
EXPECTED_PIPELINES <- length(feature_sets) * length(model_names)

pipeline_vote_summary <- challenge_by_space_model %>%
  group_by(
    outer_holdout_group,
    site_name,
    assigned_dataset_label
  ) %>%
  summarise(
    n_pipelines = n(),
    F_voting_pipelines = sum(Mean_P_F >= CLASS_THRESHOLD),
    Min_pipeline_P_F = min(Mean_P_F),
    Max_pipeline_P_F = max(Mean_P_F),
    Pipeline_range_P_F = Max_pipeline_P_F - Min_pipeline_P_F,
    .groups = "drop"
  )

if (any(pipeline_vote_summary$n_pipelines != EXPECTED_PIPELINES)) {
  stop(
    "At least one challenge site does not have exactly ", EXPECTED_PIPELINES,
    " feature-space x algorithm pipelines."
  )
}

write_csv(
  pipeline_vote_summary,
  file.path(ROOT_OUT, "challenge_28pipeline_vote_summary.csv")
)

overall_site_summary <- challenge_F_fit %>%
  group_by(
    outer_holdout_group,
    site_name,
    assigned_dataset_label
  ) %>%
  summarise(
    # There are exactly 15 fitted models for every one of the 28 pipelines,
    # so this 420-prediction mean is mathematically identical to the equal-weight
    # mean of the 28 pipeline means.
    Mean_P_F_28_pipelines = mean(P_F, na.rm = TRUE),
    SD_P_F_all_420 = sd(P_F, na.rm = TRUE),
    F_decisions_count_across_420 = sum(P_F >= CLASS_THRESHOLD, na.rm = TRUE),
    F_decisions_percent_across_420 =
      100 * mean(P_F >= CLASS_THRESHOLD, na.rm = TRUE),
    n_predictions = n(),
    .groups = "drop"
  )

challenge_site_summary <- overall_site_summary %>%
  left_join(
    pipeline_vote_summary,
    by = c(
      "outer_holdout_group",
      "site_name",
      "assigned_dataset_label"
    )
  ) %>%
  left_join(
    space_vote_summary,
    by = c(
      "outer_holdout_group",
      "site_name",
      "assigned_dataset_label"
    )
  ) %>%
  left_join(
    challenge_group_assignment %>%
      select(
        site_name,
        original_taphonomic_context,
        n_rows_for_site
      ),
    by = "site_name"
  ) %>%
  mutate(
    Assigned_dataset_label = if_else(
      assigned_dataset_label == "Funerary Context",
      "F (Funerary Context)",
      "NF (Rest)"
    ),
    Predicted_majority_label = if_else(
      Mean_P_F_28_pipelines >= CLASS_THRESHOLD,
      "F (Funerary Context)",
      "NF (Rest)"
    ),
    Label_agreement = if_else(
      Predicted_majority_label == Assigned_dataset_label,
      "Correct",
      "Discordant"
    ),
    `F-voting pipelines` = paste0(F_voting_pipelines, "/", EXPECTED_PIPELINES),
    `F-voting spaces` = paste0(F_voting_spaces, "/", length(feature_sets)),
    `F decisions across 420 fits` = paste0(
      F_decisions_count_across_420, "/", n_predictions
    ),

    # Keep the same affinity-label logic as the previous report so that changing
    # the reporting denominator from 7 spaces to 28 pipelines does not silently
    # redefine the archaeological interpretation categories.
    Affinity_label = case_when(
      F_voting_spaces == 7 &
        Mean_P_F_28_pipelines >= 0.60 ~
        "Strong Funerary affinity",

      F_voting_spaces >= 5 &
        Mean_P_F_28_pipelines >= 0.55 &
        representation_sensitive ~
        "Funerary affinity - representation-sensitive",

      F_voting_spaces >= 5 &
        Mean_P_F_28_pipelines >= 0.55 ~
        "Funerary affinity",

      F_voting_spaces <= 2 &
        Mean_P_F_28_pipelines <= 0.30 &
        representation_sensitive ~
        "Non-funerary affinity - representation-sensitive",

      F_voting_spaces <= 1 &
        Mean_P_F_28_pipelines <= 0.30 ~
        "Strong non-funerary affinity",

      Mean_P_F_28_pipelines >= 0.40 &
        Mean_P_F_28_pipelines <= 0.60 ~
        "Ambiguous / mixed affinity",

      representation_sensitive ~
        "Representation-sensitive",

      Mean_P_F_28_pipelines > 0.50 ~
        "Moderate Funerary affinity",

      TRUE ~
        "Moderate non-funerary affinity"
    )
  ) %>%
  arrange(desc(Mean_P_F_28_pipelines))

# PRIMARY compact table: the vote denominator is now 28, not 7.
challenge_compact_table <- challenge_site_summary %>%
  transmute(
    `Site` = site_name,
    `Assigned dataset label` = Assigned_dataset_label,
    `Mean P(F), 28 pipelines` = round(Mean_P_F_28_pipelines, 3),
    `F-voting pipelines` = `F-voting pipelines`,
    `Affinity label / interpretation` = Affinity_label
  )

challenge_full_table <- challenge_site_summary %>%
  transmute(
    `Site` = site_name,
    `Outer holdout group` = outer_holdout_group,
    `Assigned dataset label` = Assigned_dataset_label,
    `Original taphonomic context` = original_taphonomic_context,
    `Rows for site` = n_rows_for_site,
    `Mean P(F), 28 pipelines` = round(Mean_P_F_28_pipelines, 6),
    `SD P(F), 420 fits` = round(SD_P_F_all_420, 6),
    `F-voting pipelines` = `F-voting pipelines`,
    `F-voting spaces (diagnostic)` = `F-voting spaces`,
    `F decisions across 420 fits` = `F decisions across 420 fits`,
    `F decisions across 420 fits (%)` =
      round(F_decisions_percent_across_420, 1),
    `Predicted majority label` = Predicted_majority_label,
    `Agreement with assigned label` = Label_agreement,
    `Affinity label / interpretation` = Affinity_label,
    `Min pipeline P(F)` = round(Min_pipeline_P_F, 6),
    `Max pipeline P(F)` = round(Max_pipeline_P_F, 6),
    `Pipeline range P(F)` = round(Pipeline_range_P_F, 6),
    `Min space P(F)` = round(Min_space_P_F, 6),
    `Max space P(F)` = round(Max_space_P_F, 6),
    `Space range P(F)` = round(Space_range_P_F, 6)
  )

write_csv(
  challenge_compact_table,
  file.path(ROOT_OUT, "CHALLENGE_SITE_SUMMARY_compact.csv")
)
write_csv(
  challenge_full_table,
  file.path(ROOT_OUT, "CHALLENGE_SITE_SUMMARY_full.csv")
)

# Wide seven-space table retained for diagnosing representation sensitivity.
challenge_7space_wide <- challenge_by_space %>%
  select(
    site_name,
    assigned_dataset_label,
    feature_space,
    Mean_P_F
  ) %>%
  pivot_wider(
    names_from = feature_space,
    values_from = Mean_P_F
  ) %>%
  left_join(
    challenge_site_summary %>%
      select(
        site_name,
        Mean_P_F_28_pipelines,
        F_voting_pipelines,
        F_voting_spaces,
        Affinity_label
      ),
    by = "site_name"
  ) %>%
  arrange(desc(Mean_P_F_28_pipelines))

write_csv(
  challenge_7space_wide,
  file.path(ROOT_OUT, "CHALLENGE_SITE_7SPACE_PROBABILITIES.csv")
)

# Wide 28-pipeline table: one column for every feature-space x algorithm pair.
challenge_28pipeline_wide <- challenge_by_space_model %>%
  mutate(
    pipeline = paste(feature_space, model, sep = " | ")
  ) %>%
  select(
    site_name,
    assigned_dataset_label,
    pipeline,
    Mean_P_F
  ) %>%
  pivot_wider(
    names_from = pipeline,
    values_from = Mean_P_F
  ) %>%
  left_join(
    challenge_site_summary %>%
      select(
        site_name,
        Mean_P_F_28_pipelines,
        F_voting_pipelines,
        F_decisions_count_across_420,
        Affinity_label
      ),
    by = "site_name"
  ) %>%
  arrange(desc(Mean_P_F_28_pipelines))

write_csv(
  challenge_28pipeline_wide,
  file.path(ROOT_OUT, "CHALLENGE_SITE_28PIPELINE_PROBABILITIES.csv")
)

# ==============================================================================
# 16. True held-out performance across the 26 challenge sites
# ==============================================================================

performance_from_site_prob <- function(dat) {
  dat <- dat %>%
    arrange(site_name)

  truth <- as.character(dat$assigned_dataset_label)
  pF <- dat$P_F

  P <- cbind(
    Rest = 1 - pF,
    `Funerary Context` = pF
  )

  calc_metrics(
    truth = truth,
    P = P,
    classes = CLASSES
  )
}

# 28 feature-space x algorithm pipelines. For each site, the probability is the
# mean of its 15 truly outer-held-out fold-model predictions for that pipeline.
challenge_pipeline_site <- challenge_F_fit %>%
  group_by(
    site_name,
    assigned_dataset_label,
    feature_space,
    model
  ) %>%
  summarise(
    P_F = mean(P_F, na.rm = TRUE),
    n_fold_models = n(),
    .groups = "drop"
  )

challenge_28_pipeline_performance <- challenge_pipeline_site %>%
  group_by(feature_space, model) %>%
  group_modify(~ performance_from_site_prob(.x)) %>%
  ungroup() %>%
  arrange(desc(balanced_accuracy), desc(roc_auc))

write_csv(
  challenge_28_pipeline_performance,
  file.path(ROOT_OUT, "challenge_28_pipeline_heldout_performance.csv")
)

# Overall 7-space x 4-algorithm ensemble across the 26 unique challenge sites.
overall_ensemble_perf_input <- challenge_site_summary %>%
  transmute(
    site_name,
    assigned_dataset_label,
    P_F = Mean_P_F_28_pipelines
  )

overall_ensemble_performance <- performance_from_site_prob(
  overall_ensemble_perf_input
) %>%
  mutate(
    n_unique_challenge_sites = nrow(overall_ensemble_perf_input),
    .before = 1
  )

write_csv(
  overall_ensemble_performance,
  file.path(ROOT_OUT, "challenge_overall_ensemble_heldout_performance.csv")
)

# Performance separately within each of the five held-out panels.
challenge_group_performance <- challenge_site_summary %>%
  transmute(
    outer_holdout_group,
    site_name,
    assigned_dataset_label,
    P_F = Mean_P_F_28_pipelines
  ) %>%
  group_by(outer_holdout_group) %>%
  group_modify(~ performance_from_site_prob(.x)) %>%
  ungroup()

write_csv(
  challenge_group_performance,
  file.path(ROOT_OUT, "challenge_each_holdout_group_performance.csv")
)

# Confusion counts for the overall ensemble.
confusion_summary <- challenge_site_summary %>%
  mutate(
    truth_F = assigned_dataset_label == "Funerary Context",
    pred_F = Mean_P_F_28_pipelines >= CLASS_THRESHOLD
  ) %>%
  summarise(
    TP_F = sum(truth_F & pred_F),
    FN_F = sum(truth_F & !pred_F),
    TN_NF = sum(!truth_F & !pred_F),
    FP_NF_as_F = sum(!truth_F & pred_F)
  )

write_csv(
  confusion_summary,
  file.path(ROOT_OUT, "challenge_overall_confusion_counts.csv")
)

# ==============================================================================
# 17. Internal-CV summaries for each reduced training reference
# ==============================================================================

inner_fold_performance_summary <- inner_fold_metrics %>%
  group_by(
    outer_holdout_group,
    feature_space,
    model
  ) %>%
  summarise(
    n_assessment_folds = n(),
    BA_mean = mean(balanced_accuracy, na.rm = TRUE),
    BA_sd = sd(balanced_accuracy, na.rm = TRUE),
    AUC_mean = mean(roc_auc, na.rm = TRUE),
    AUC_sd = sd(roc_auc, na.rm = TRUE),
    Precision_mean = mean(precision, na.rm = TRUE),
    Precision_sd = sd(precision, na.rm = TRUE),
    Recall_mean = mean(recall, na.rm = TRUE),
    Recall_sd = sd(recall, na.rm = TRUE),
    Brier_mean = mean(brier, na.rm = TRUE),
    Brier_sd = sd(brier, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(
  inner_fold_performance_summary,
  file.path(ROOT_OUT, "inner_fold_performance_mean_SD.csv")
)

# ==============================================================================
# 18. Optional Word table
# ==============================================================================

if (
  requireNamespace("officer", quietly = TRUE) &&
  requireNamespace("flextable", quietly = TRUE)
) {
  ft <- flextable::flextable(challenge_compact_table)
  ft <- flextable::autofit(ft)
  ft <- flextable::fontsize(ft, size = 9, part = "all")

  doc <- officer::read_docx()
  doc <- officer::body_add_par(
    doc,
    "Five-group pseudo-unknown F vs NF challenge",
    style = "heading 1"
  )
  doc <- officer::body_add_par(
    doc,
    paste0(
      "Each site was removed completely from model fitting in its assigned ",
      "outer holdout panel. Mean P(F) is the equal-weight mean across 28 pipelines ",
      "(7 feature spaces x 4 algorithms). Each pipeline is averaged over 15 outer-held-out ",
      "fold models (3 folds x 5 repeats), giving 420 fitted-model predictions per site. ",
      "F-voting pipelines is the number of the 28 pipeline means with P(F) >= 0.50."
    )
  )
  doc <- flextable::body_add_flextable(doc, ft)

  print(
    doc,
    target = file.path(ROOT_OUT, "CHALLENGE_SITE_SUMMARY_compact.docx")
  )
}

# ==============================================================================
# 19. Run summary
# ==============================================================================

writeLines(
  c(
    paste0("Run finished: ", Sys.time()),
    paste0("Input: ", INPUT_FILE),
    paste0("Unique challenge sites: ", length(challenge_sites)),
    paste0("Outer holdout groups: ", N_OUTER_GROUPS),
    paste0("Inner grouped CV: ", CV_FOLDS, " folds x ", CV_REPEATS, " repeats"),
    paste0("Feature spaces: ", length(feature_sets)),
    paste0("Algorithms: ", length(model_names)),
    paste0(
      "Predictions per held-out site: ",
      length(feature_sets) * length(model_names) * CV_FOLDS * CV_REPEATS
    ),
    "Primary compact table: CHALLENGE_SITE_SUMMARY_compact.csv",
    "Primary full table: CHALLENGE_SITE_SUMMARY_full.csv",
    "Seven-space diagnostic detail: CHALLENGE_SITE_7SPACE_PROBABILITIES.csv",
    "28-pipeline detail: CHALLENGE_SITE_28PIPELINE_PROBABILITIES.csv",
    "28-pipeline held-out metrics: challenge_28_pipeline_heldout_performance.csv",
    "Overall held-out metrics: challenge_overall_ensemble_heldout_performance.csv"
  ),
  file.path(ROOT_OUT, "RUN_FINISHED.txt")
)

cat("\n=== FINISHED ===\n")
cat("Main outputs:\n")
cat("  CHALLENGE_SITE_SUMMARY_compact.csv\n")
cat("  CHALLENGE_SITE_SUMMARY_full.csv\n")
cat("  CHALLENGE_SITE_7SPACE_PROBABILITIES.csv\n")
cat("  CHALLENGE_SITE_28PIPELINE_PROBABILITIES.csv\n")
cat("  challenge_28_pipeline_heldout_performance.csv\n")
cat("  challenge_overall_ensemble_heldout_performance.csv\n")
cat("Output directory:", ROOT_OUT, "\n")
