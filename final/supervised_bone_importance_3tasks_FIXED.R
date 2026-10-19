# ==============================================================================
# SUPERVISED BONE-LEVEL INTERPRETATION
# 3 tasks x raw %MNAU / raw ReMNAU
#
# This script is designed to run AFTER:
#   supervised_ml_7spaces_3tasks_unknown_projection_FIXED_v3.R
#
# It uses:
#   final/tapho_db_sum.csv
#   supervised_ml_7spaces_3tasks_R_outputs/all_task_grouped_cv_fold_maps.csv
#   supervised_ml_7spaces_3tasks_R_outputs/pooled_OOF_performance.csv
#
# Three complementary layers:
#   A) site-level statistical group differences by bone
#   B) held-out grouped-CV permutation importance by bone
#   C) optional SHAP for the selected full-reference refit
#
# Interpretation:
# - Statistical tests answer: "does representation differ among labels?"
# - Held-out permutation importance answers: "does this bone help prediction?"
# - SHAP answers: "how does the selected fitted model use this bone?"
# - SHAP is descriptive. It is NOT a p-value or causal effect.
#
# Bilateral bones:
# - *_left and *_right are treated as ONE anatomical group for model importance.
# - For descriptive/statistical group contrasts, the bilateral bone value is the
#   row mean of left and right after the same *_indet redistribution used in ML.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETTINGS
# ------------------------------------------------------------------------------

INPUT_FILE <- "final/tapho_db_sum.csv"

ML_OUT <- "supervised_ml_7spaces_3tasks_R_outputs"
FOLD_MAP_FILE <- file.path(ML_OUT, "all_task_grouped_cv_fold_maps.csv")
PERFORMANCE_FILE <- file.path(ML_OUT, "pooled_OOF_performance.csv")

OUT_DIR <- "supervised_bone_importance_3tasks_R_outputs"

SEED <- 42L

# Statistical permutation tests.
STAT_PERMUTATIONS <- 9999L

# Number of held-out perturbations per bone per fold.
IMPORTANCE_PERMUTATIONS <- 30L

# Approximate SHAP.
RUN_SHAP <- TRUE
SHAP_NSIM <- 50L

# Same model settings as the supervised pipeline.
RF_TREES <- 80L
RF_MIN_NODE <- 2L
SVM_COST <- 1
KNN_K <- 7L
LOGISTIC_LAMBDA <- 1

# Same bilateral indeterminate handling.
REDISTRIBUTE_BILATERAL_INDET <- TRUE
DROP_REDISTRIBUTED_INDET_FROM_FEATURES <- TRUE
PCTMNAU_MAX <- 1

ANATOMICAL_SPACES <- c("%MNAU raw", "ReMNAU raw")

# ------------------------------------------------------------------------------
# 1. STARTUP
# ------------------------------------------------------------------------------

cat("\n=== SUPERVISED BONE IMPORTANCE: 3 TASKS ===\n")

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(OUT_DIR, "figures"), recursive = TRUE, showWarnings = FALSE)

if (!dir.exists(OUT_DIR)) stop("Could not create output directory.")

required <- c("tidyverse", "glmnet", "ranger", "e1071")
missing <- required[!vapply(required, requireNamespace, quietly = TRUE,
                           FUN.VALUE = logical(1))]

if (length(missing) > 0) {
  stop("Install packages first: ", paste(missing, collapse = ", "))
}

library(tidyverse)

if (!file.exists(INPUT_FILE)) stop("Missing input: ", INPUT_FILE)
if (!file.exists(FOLD_MAP_FILE)) stop("Missing CV fold map: ", FOLD_MAP_FILE)
if (!file.exists(PERFORMANCE_FILE)) stop("Missing OOF performance: ", PERFORMANCE_FILE)

d <- read_csv(INPUT_FILE, show_col_types = FALSE) %>%
  mutate(record_id = row_number(), .before = 1)

fold_maps <- read_csv(FOLD_MAP_FILE, show_col_types = FALSE)
performance <- read_csv(PERFORMANCE_FILE, show_col_types = FALSE)

if (!"layer_name" %in% names(d)) d$layer_name <- NA_character_

needed <- c(
  "site_name", "taphonomic_context", "funerary_context",
  "Mean_part_abundance", "mnau_heip_evenness"
)

if (length(setdiff(needed, names(d))) > 0) {
  stop("Missing columns: ", paste(setdiff(needed, names(d)), collapse = ", "))
}

# ------------------------------------------------------------------------------
# 2. SAME BILATERAL *_indet REDISTRIBUTION AS MAIN ML
# ------------------------------------------------------------------------------

find_triplets <- function(nms, prefix, type) {
  ind <- nms[str_starts(nms, prefix) & str_ends(nms, "_indet")]
  if (length(ind) == 0) return(tibble())

  tibble(
    feature_type = type,
    indet_col = ind,
    base = str_remove(ind, "_indet$"),
    left_col = paste0(base, "_left"),
    right_col = paste0(base, "_right")
  ) %>%
    filter(left_col %in% nms, right_col %in% nms) %>%
    mutate(anatomical_part = str_remove(base, paste0("^", prefix)))
}

raw_rem_names <- names(d)[
  str_starts(names(d), "ReMNAU_") &
    !str_starts(names(d), "ReMNAU_adjusted_")
]

indet_pairs <- bind_rows(
  find_triplets(names(d), "ProportionalRep_MNIbased_", "%MNAU"),
  find_triplets(raw_rem_names, "ReMNAU_", "ReMNAU")
)

redistribute_one <- function(dat, indet_col, left_col, right_col,
                             feature_type, max_value = Inf) {

  ind <- dat[[indet_col]]
  lef <- dat[[left_col]]
  rig <- dat[[right_col]]

  rows <- which(is.finite(ind) & ind > 0)

  for (i in rows) {
    amount <- ind[i]

    l0 <- ifelse(is.na(lef[i]), 0, lef[i])
    r0 <- ifelse(is.na(rig[i]), 0, rig[i])

    cap_l <- if (is.finite(max_value)) max(0, max_value - l0) else Inf
    cap_r <- if (is.finite(max_value)) max(0, max_value - r0) else Inf

    al <- if (is.finite(cap_l)) min(amount / 2, cap_l) else amount / 2
    ar <- if (is.finite(cap_r)) min(amount / 2, cap_r) else amount / 2

    rem <- amount - al - ar

    if (rem > 0) {
      extra_cap <- if (is.finite(cap_l)) max(0, cap_l - al) else Inf
      take <- if (is.finite(extra_cap)) min(rem, extra_cap) else rem
      al <- al + take
      rem <- rem - take
    }

    if (rem > 0) {
      extra_cap <- if (is.finite(cap_r)) max(0, cap_r - ar) else Inf
      take <- if (is.finite(extra_cap)) min(rem, extra_cap) else rem
      ar <- ar + take
      rem <- rem - take
    }

    lef[i] <- l0 + al
    rig[i] <- r0 + ar
    ind[i] <- max(0, rem)

    if (is.finite(max_value)) {
      if (l0 <= max_value + 1e-12) lef[i] <- min(lef[i], max_value)
      if (r0 <= max_value + 1e-12) rig[i] <- min(rig[i], max_value)
    }
  }

  dat[[indet_col]] <- ind
  dat[[left_col]] <- lef
  dat[[right_col]] <- rig
  dat
}

if (REDISTRIBUTE_BILATERAL_INDET && nrow(indet_pairs) > 0) {
  for (i in seq_len(nrow(indet_pairs))) {
    z <- indet_pairs[i, ]
    d <- redistribute_one(
      d,
      z$indet_col,
      z$left_col,
      z$right_col,
      z$feature_type,
      ifelse(z$feature_type == "%MNAU", PCTMNAU_MAX, Inf)
    )
  }
}

write_csv(indet_pairs, file.path(OUT_DIR, "bilateral_bone_pairs.csv"))

# ------------------------------------------------------------------------------
# 3. LABELS AND RAW ANATOMICAL FEATURE SETS
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

d <- d %>% mutate(class4 = collapse_class4(taphonomic_context))
known <- d %>% filter(!is.na(class4))

prop_cols <- names(d)[str_starts(names(d), "ProportionalRep_MNIbased_")]
rem_cols <- names(d)[
  str_starts(names(d), "ReMNAU_") &
    !str_starts(names(d), "ReMNAU_adjusted_")
]

if (DROP_REDISTRIBUTED_INDET_FROM_FEATURES) {
  prop_cols <- setdiff(
    prop_cols,
    indet_pairs %>%
      filter(feature_type == "%MNAU") %>%
      pull(indet_col)
  )

  rem_cols <- setdiff(
    rem_cols,
    indet_pairs %>%
      filter(feature_type == "ReMNAU") %>%
      pull(indet_col)
  )
}

feature_sets <- list(
  `%MNAU raw` = prop_cols,
  `ReMNAU raw` = rem_cols
)

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

make_task <- function(task, dat) {
  if (task == "4class") {
    return(dat %>% filter(!is.na(class4)) %>% mutate(task_label = class4))
  }

  if (task == "cannibalism_vs_fc") {
    return(
      dat %>%
        filter(class4 %in% c("Cannibalism", "Funerary Context")) %>%
        mutate(task_label = class4)
    )
  }

  if (task == "fc_vs_rest") {
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

  stop("Unknown task: ", task)
}

# ------------------------------------------------------------------------------
# 4. BONE GROUPS
# ------------------------------------------------------------------------------

bone_name <- function(feature, space) {
  if (space == "%MNAU raw") {
    x <- str_remove(feature, "^ProportionalRep_MNIbased_")
  } else {
    x <- str_remove(feature, "^ReMNAU_")
  }

  x %>%
    str_remove("_left$") %>%
    str_remove("_right$") %>%
    str_remove("_indet$")
}

bone_groups <- function(vars, space) {
  split(vars, map_chr(vars, bone_name, space = space))
}

bone_map <- imap_dfr(feature_sets, function(vars, space) {
  groups <- bone_groups(vars, space)

  imap_dfr(groups, function(cols, bone) {
    tibble(
      feature_space = space,
      bone = bone,
      n_columns = length(cols),
      columns = paste(cols, collapse = " | ")
    )
  })
})

write_csv(bone_map, file.path(OUT_DIR, "bone_feature_map.csv"))

make_bone_values <- function(dat, vars, space) {
  groups <- bone_groups(vars, space)

  # Build each bone column with its final name immediately. This avoids
  # tibble/vctrs repeatedly repairing duplicate temporary column names ("v").
  B <- imap_dfc(groups, function(cols, bone) {
    X <- as.matrix(dat[, cols, drop = FALSE])

    if (ncol(X) == 1) {
      value <- as.numeric(X[, 1])
    } else {
      value <- rowMeans(X, na.rm = TRUE)
      value[rowSums(is.finite(X)) == 0] <- NA_real_
    }

    tibble(!!bone := value)
  })

  bind_cols(
    dat %>% select(record_id, site_name, task_label),
    B
  )
}

# ------------------------------------------------------------------------------
# 5. SITE-LEVEL STATISTICAL TESTS
# ------------------------------------------------------------------------------

safe_mean <- function(x) {
  z <- x[is.finite(x)]
  if (length(z) == 0) NA_real_ else mean(z)
}

cliff_delta <- function(x, y) {
  x <- x[is.finite(x)]
  y <- y[is.finite(y)]

  n1 <- length(x)
  n2 <- length(y)

  if (n1 == 0 || n2 == 0) return(NA_real_)

  r <- rank(c(x, y), ties.method = "average")
  R1 <- sum(r[seq_len(n1)])
  U1 <- R1 - n1 * (n1 + 1) / 2

  2 * U1 / (n1 * n2) - 1
}

kw_H <- function(x, g) {
  ok <- is.finite(x) & !is.na(g)
  x <- x[ok]
  g <- factor(g[ok])

  if (length(x) < 2 || nlevels(g) < 2) return(NA_real_)

  n <- length(x)
  r <- rank(x, ties.method = "average")

  z <- tibble(g = g, r = r) %>%
    group_by(g) %>%
    summarise(n_g = n(), R_g = sum(r), .groups = "drop")

  H <- 12 / (n * (n + 1)) * sum(z$R_g^2 / z$n_g) - 3 * (n + 1)

  ties <- table(x)
  correction <- 1 - sum(ties^3 - ties) / (n^3 - n)

  if (!is.finite(correction) || correction <= 0) return(0)

  H / correction
}

perm_binary <- function(x, g, focal, B, seed) {
  ok <- is.finite(x) & !is.na(g)
  x <- x[ok]
  g <- as.character(g[ok])

  other <- setdiff(unique(g), focal)[1]
  obs <- cliff_delta(x[g == focal], x[g == other])

  set.seed(seed)

  null <- replicate(B, {
    gp <- sample(g)
    cliff_delta(x[gp == focal], x[gp == other])
  })

  (1 + sum(abs(null) >= abs(obs), na.rm = TRUE)) / (B + 1)
}

perm_kw <- function(x, g, B, seed) {
  ok <- is.finite(x) & !is.na(g)
  x <- x[ok]
  g <- as.character(g[ok])

  obs <- kw_H(x, g)

  set.seed(seed)
  null <- replicate(B, kw_H(x, sample(g)))

  (1 + sum(null >= obs, na.rm = TRUE)) / (B + 1)
}

profile_list <- list()
test_list <- list()
pairwise_list <- list()
seed_counter <- 1L

for (task in names(task_classes)) {
  td <- make_task(task, known)

  for (space in names(feature_sets)) {
    bv <- make_bone_values(td, feature_sets[[space]], space)

    bnames <- setdiff(
      names(bv),
      c("record_id", "site_name", "task_label")
    )

    # Formal inference uses one independent row per named site.
    site_bv <- bv %>%
      group_by(site_name, task_label) %>%
      summarise(across(all_of(bnames), safe_mean), .groups = "drop")

    profiles <- site_bv %>%
      pivot_longer(
        all_of(bnames),
        names_to = "bone",
        values_to = "value"
      ) %>%
      group_by(task_label, bone) %>%
      summarise(
        n_sites = sum(is.finite(value)),
        mean = mean(value, na.rm = TRUE),
        sd = sd(value, na.rm = TRUE),
        median = median(value, na.rm = TRUE),
        q25 = quantile(value, .25, na.rm = TRUE, names = FALSE),
        q75 = quantile(value, .75, na.rm = TRUE, names = FALSE),
        .groups = "drop"
      ) %>%
      mutate(task = task, feature_space = space, .before = 1)

    profile_list[[length(profile_list) + 1L]] <- profiles

    classes <- task_classes[[task]]

    if (length(classes) == 2) {
      focal <- "Funerary Context"
      comparison <- setdiff(classes, focal)[1]

      tests <- map_dfr(seq_along(bnames), function(j) {
        b <- bnames[j]
        x <- site_bv[[b]]
        g <- as.character(site_bv$task_label)

        xf <- x[g == focal & is.finite(x)]
        xc <- x[g == comparison & is.finite(x)]

        del <- cliff_delta(xf, xc)

        tibble(
          task = task,
          feature_space = space,
          bone = b,
          focal_class = focal,
          comparison_class = comparison,
          n_focal = length(xf),
          n_comparison = length(xc),
          median_focal = median(xf, na.rm = TRUE),
          median_comparison = median(xc, na.rm = TRUE),
          mean_focal = mean(xf, na.rm = TRUE),
          mean_comparison = mean(xc, na.rm = TRUE),
          median_difference = median(xf, na.rm = TRUE) -
            median(xc, na.rm = TRUE),
          cliffs_delta = del,
          permutation_p = perm_binary(
            x, g, focal,
            STAT_PERMUTATIONS,
            SEED + seed_counter * 101L + j
          )
        )
      }) %>%
        mutate(
          q_BH = p.adjust(permutation_p, method = "BH"),
          direction = case_when(
            cliffs_delta > 0 ~ paste0("higher in ", focal),
            cliffs_delta < 0 ~ paste0("higher in ", comparison),
            TRUE ~ "no direction"
          ),
          effect_magnitude = case_when(
            abs(cliffs_delta) < 0.147 ~ "negligible",
            abs(cliffs_delta) < 0.33 ~ "small",
            abs(cliffs_delta) < 0.474 ~ "medium",
            TRUE ~ "large"
          )
        ) %>%
        arrange(q_BH, desc(abs(cliffs_delta)))

      test_list[[length(test_list) + 1L]] <- tests

    } else {
      tests <- map_dfr(seq_along(bnames), function(j) {
        b <- bnames[j]
        x <- site_bv[[b]]
        g <- as.character(site_bv$task_label)

        H <- kw_H(x, g)
        ok <- is.finite(x) & !is.na(g)
        n <- sum(ok)
        k <- n_distinct(g[ok])

        eps2 <- if (n > k) {
          max(0, (H - k + 1) / (n - k))
        } else {
          NA_real_
        }

        tibble(
          task = task,
          feature_space = space,
          bone = b,
          n_sites = n,
          H = H,
          epsilon_squared = eps2,
          permutation_p = perm_kw(
            x, g,
            STAT_PERMUTATIONS,
            SEED + seed_counter * 101L + j
          )
        )
      }) %>%
        mutate(q_BH = p.adjust(permutation_p, method = "BH")) %>%
        arrange(q_BH, desc(epsilon_squared))

      test_list[[length(test_list) + 1L]] <- tests

      pairs <- combn(classes, 2, simplify = FALSE)

      pw <- map_dfr(bnames, function(b) {
        x <- site_bv[[b]]
        g <- as.character(site_bv$task_label)

        map_dfr(pairs, function(pp) {
          a <- pp[1]
          bb <- pp[2]

          xa <- x[g == a & is.finite(x)]
          xb <- x[g == bb & is.finite(x)]

          wt <- suppressWarnings(wilcox.test(xa, xb, exact = FALSE))

          tibble(
            task = task,
            feature_space = space,
            bone = b,
            class_A = a,
            class_B = bb,
            comparison = paste(a, "vs", bb),
            n_A = length(xa),
            n_B = length(xb),
            median_A = median(xa, na.rm = TRUE),
            median_B = median(xb, na.rm = TRUE),
            cliffs_delta_A_vs_B = cliff_delta(xa, xb),
            wilcoxon_p = wt$p.value
          )
        })
      }) %>%
        group_by(task, feature_space, comparison) %>%
        mutate(q_BH_within_comparison = p.adjust(wilcoxon_p, method = "BH")) %>%
        ungroup() %>%
        mutate(q_BH_all_pairwise = p.adjust(wilcoxon_p, method = "BH")) %>%
        arrange(q_BH_all_pairwise, desc(abs(cliffs_delta_A_vs_B)))

      pairwise_list[[length(pairwise_list) + 1L]] <- pw
    }

    seed_counter <- seed_counter + 1L
  }
}

bone_profiles <- bind_rows(profile_list)
bone_tests <- bind_rows(test_list)
bone_pairwise <- bind_rows(pairwise_list)

write_csv(
  bone_profiles,
  file.path(OUT_DIR, "bone_descriptive_profiles_by_task.csv")
)

write_csv(
  bone_tests,
  file.path(OUT_DIR, "bone_statistical_tests_FDR.csv")
)

write_csv(
  bone_pairwise,
  file.path(OUT_DIR, "bone_4class_pairwise_tests_FDR.csv")
)

# ------------------------------------------------------------------------------
# 6. PREPROCESSING / BALANCING / MODEL HELPERS
# ------------------------------------------------------------------------------

fit_preprocessor <- function(train, vars) {
  med <- map_dbl(vars, function(v) {
    m <- median(train[[v]], na.rm = TRUE)
    ifelse(is.finite(m), m, 0)
  })
  names(med) <- vars

  impute <- function(dat) {
    x <- as.data.frame(dat[, vars, drop = FALSE])

    for (v in vars) {
      bad <- is.na(x[[v]]) | !is.finite(x[[v]])
      x[[v]][bad] <- med[[v]]
    }

    as.matrix(x)
  }

  X0 <- impute(train)
  mu <- colMeans(X0)
  sdv <- apply(X0, 2, sd)

  keep <- is.finite(sdv) & sdv > 0
  if (!any(keep)) stop("All variables zero variance in fold.")

  keep_vars <- vars[keep]
  mu <- mu[keep]
  sdv <- sdv[keep]

  raw_transform <- function(dat) {
    x <- impute(dat)[, keep, drop = FALSE]
    colnames(x) <- keep_vars
    x
  }

  scaled_transform <- function(dat) {
    x <- raw_transform(dat)
    x <- sweep(sweep(x, 2, mu, "-"), 2, sdv, "/")
    colnames(x) <- keep_vars
    x
  }

  list(
    keep_vars = keep_vars,
    train_raw = raw_transform(train),
    train_scaled = scaled_transform(train),
    raw_transform = raw_transform,
    scaled_transform = scaled_transform
  )
}

balance_idx <- function(y, seed) {
  y <- as.character(y)
  classes <- sort(unique(y))
  mx <- max(table(y))

  set.seed(seed)

  idx <- unlist(lapply(classes, function(cl) {
    ii <- which(y == cl)

    if (length(ii) < mx) {
      c(ii, sample(ii, mx - length(ii), replace = TRUE))
    } else {
      ii
    }
  }))

  sample(idx)
}

align_probs <- function(P, classes) {
  P <- as.matrix(P)

  if (is.null(colnames(P))) {
    colnames(P) <- classes
  }

  P <- P[, classes, drop = FALSE]
  P[P < 0] <- 0

  rs <- rowSums(P)
  rs[!is.finite(rs) | rs <= 0] <- 1

  P / rs
}

fit_model <- function(model_name, Xs, Xr, y, classes, seed) {

  if (model_name == "Logistic regression") {
    X <- Xs

    if (ncol(X) == 1) {
      X <- cbind(X, .glmnet_zero_dummy = 0)
    }

    family <- ifelse(length(classes) == 2, "binomial", "multinomial")

    mod <- glmnet::glmnet(
      X,
      factor(y, levels = classes),
      family = family,
      alpha = 0,
      lambda = LOGISTIC_LAMBDA,
      standardize = FALSE
    )

    return(list(
      type = model_name,
      model = mod,
      classes = classes,
      n_original_features = ncol(Xs),
      input = "scaled"
    ))
  }

  if (model_name == "Random forest") {
    tr <- as.data.frame(Xr)
    names(tr) <- colnames(Xr)
    tr$.y <- factor(y, levels = classes)

    mod <- ranger::ranger(
      .y ~ .,
      data = tr,
      probability = TRUE,
      num.trees = RF_TREES,
      mtry = max(1, floor(sqrt(ncol(Xr)))),
      min.node.size = RF_MIN_NODE,
      seed = seed
    )

    return(list(
      type = model_name,
      model = mod,
      classes = classes,
      input = "raw"
    ))
  }

  if (model_name == "RBF-SVM") {
    mod <- e1071::svm(
      Xs,
      factor(y, levels = classes),
      kernel = "radial",
      cost = SVM_COST,
      gamma = 1 / ncol(Xs),
      scale = FALSE,
      probability = TRUE
    )

    return(list(
      type = model_name,
      model = mod,
      classes = classes,
      input = "scaled"
    ))
  }

  if (model_name == "KNN") {
    return(list(
      type = model_name,
      X = Xs,
      y = as.character(y),
      classes = classes,
      input = "scaled"
    ))
  }

  stop("Unknown model: ", model_name)
}

predict_model <- function(obj, Xnew) {
  classes <- obj$classes

  if (obj$type == "Logistic regression") {
    X <- as.matrix(Xnew)

    if (obj$n_original_features == 1) {
      X <- cbind(X, .glmnet_zero_dummy = 0)
    }

    pr <- predict(
      obj$model,
      newx = X,
      type = "response",
      s = LOGISTIC_LAMBDA
    )

    if (length(classes) == 2) {
      p2 <- as.numeric(pr)
      P <- cbind(1 - p2, p2)
      colnames(P) <- classes
    } else {
      P <- pr[, , 1, drop = FALSE]
      P <- P[, , 1]
      if (is.vector(P)) P <- matrix(P, nrow = nrow(X))
    }

    return(align_probs(P, classes))
  }

  if (obj$type == "Random forest") {
    nd <- as.data.frame(Xnew)
    names(nd) <- colnames(Xnew)
    P <- predict(obj$model, data = nd)$predictions
    return(align_probs(P, classes))
  }

  if (obj$type == "RBF-SVM") {
    pred <- predict(
      obj$model,
      as.matrix(Xnew),
      probability = TRUE
    )
    P <- attr(pred, "probabilities")
    return(align_probs(P, classes))
  }

  if (obj$type == "KNN") {
    Xnew <- as.matrix(Xnew)
    k <- min(KNN_K, nrow(obj$X))

    P <- matrix(
      0,
      nrow(Xnew),
      length(classes),
      dimnames = list(NULL, classes)
    )

    for (i in seq_len(nrow(Xnew))) {
      dst <- sqrt(rowSums(
        sweep(obj$X, 2, Xnew[i, ], "-")^2
      ))

      ii <- order(dst)[seq_len(k)]
      dd <- dst[ii]
      yy <- obj$y[ii]

      if (any(dd <= 1e-12)) {
        z <- table(factor(yy[dd <= 1e-12], levels = classes))
        P[i, ] <- as.numeric(z) / sum(z)
      } else {
        w <- 1 / dd
        z <- vapply(
          classes,
          function(cl) sum(w[yy == cl]),
          numeric(1)
        )
        P[i, ] <- z / sum(z)
      }
    }

    return(P)
  }

  stop("Unknown fitted model.")
}

# ------------------------------------------------------------------------------
# 7. SITE-LEVEL VALIDATION METRICS
# ------------------------------------------------------------------------------

aggregate_site_probs <- function(P, meta, classes) {
  as_tibble(P) %>%
    setNames(classes) %>%
    mutate(
      site_name = meta$site_name,
      truth = as.character(meta$task_label),
      .before = 1
    ) %>%
    group_by(site_name, truth) %>%
    summarise(across(all_of(classes), mean), .groups = "drop")
}

site_balanced_accuracy <- function(P, meta, classes) {
  z <- aggregate_site_probs(P, meta, classes)

  pred <- classes[
    max.col(as.matrix(z[, classes, drop = FALSE]), ties.method = "first")
  ]

  tab <- table(
    factor(z$truth, levels = classes),
    factor(pred, levels = classes)
  )

  recall <- map_dbl(seq_along(classes), function(i) {
    den <- sum(tab[i, ])
    ifelse(den == 0, NA_real_, tab[i, i] / den)
  })

  mean(recall, na.rm = TRUE)
}

site_logloss <- function(P, meta, classes) {
  z <- aggregate_site_probs(P, meta, classes)
  PP <- as.matrix(z[, classes, drop = FALSE])

  col <- match(z$truth, classes)
  ptrue <- PP[cbind(seq_len(nrow(PP)), col)]
  ptrue <- pmax(1e-15, pmin(1 - 1e-15, ptrue))

  -mean(log(ptrue))
}

# ------------------------------------------------------------------------------
# 8. SELECT BEST VALIDATED MODEL PER TASK x RAW SPACE
# ------------------------------------------------------------------------------

best_models <- performance %>%
  filter(feature_space %in% ANATOMICAL_SPACES) %>%
  group_by(task, feature_space) %>%
  slice_max(
    balanced_accuracy,
    n = 1,
    with_ties = FALSE
  ) %>%
  ungroup()

write_csv(
  best_models,
  file.path(OUT_DIR, "selected_best_OOF_model_per_task_anatomical_space.csv")
)

cat("\nSelected models from previous OOF validation:\n")
print(
  best_models %>%
    select(task, feature_space, model, balanced_accuracy, roc_auc)
)

# ------------------------------------------------------------------------------
# 9. GROUP-AWARE VALIDATION PERMUTATION
# ------------------------------------------------------------------------------

permute_bone_by_site <- function(X, sites, cols, seed) {
  Xp <- X

  unique_sites <- unique(sites)
  if (length(unique_sites) < 2) return(Xp)

  # Site means are used as donor vectors. This preserves site as the unit being
  # permuted even where a few site_name values have multiple summed records.
  donor <- map_dfr(unique_sites, function(ss) {
    ii <- which(sites == ss)

    tibble(
      site_name = ss,
      !!!setNames(
        as.list(colMeans(X[ii, cols, drop = FALSE])),
        colnames(X)[cols]
      )
    )
  })

  set.seed(seed)

  map_tbl <- tibble(
    target_site = unique_sites,
    donor_site = sample(unique_sites)
  ) %>%
    left_join(donor, by = c("donor_site" = "site_name"))

  for (i in seq_len(nrow(map_tbl))) {
    rows <- which(sites == map_tbl$target_site[i])

    vals <- as.numeric(
      map_tbl[i, colnames(X)[cols], drop = TRUE]
    )

    Xp[rows, cols] <- matrix(
      vals,
      nrow = length(rows),
      ncol = length(cols),
      byrow = TRUE
    )
  }

  Xp
}

importance_results <- list()
imp_i <- 1L

for (i in seq_len(nrow(best_models))) {

  task <- best_models$task[i]
  space <- best_models$feature_space[i]
  model_name <- best_models$model[i]

  cat("\nImportance:", task, "|", space, "|", model_name, "\n")

  td <- make_task(task, known) %>%
    mutate(
      task_label = factor(task_label, levels = task_classes[[task]])
    )

  classes <- task_classes[[task]]
  vars <- feature_sets[[space]]

  fm <- fold_maps %>% filter(.data$task == .env$task)

  for (r in sort(unique(fm$repeat_id))) {
    fm_r <- fm %>% filter(repeat_id == r)

    for (f in sort(unique(fm_r$fold))) {
      val_sites <- fm_r %>% filter(fold == f) %>% pull(site_name)

      train <- td %>% filter(!site_name %in% val_sites)
      valid <- td %>% filter(site_name %in% val_sites)

      pp <- fit_preprocessor(train, vars)

      Xtr_s <- pp$train_scaled
      Xtr_r <- pp$train_raw
      Xva_s <- pp$scaled_transform(valid)
      Xva_r <- pp$raw_transform(valid)

      ytr <- as.character(train$task_label)

      bi <- balance_idx(
        ytr,
        seed = SEED + i * 100000L + r * 100L + f
      )

      obj <- fit_model(
        model_name,
        Xtr_s[bi, , drop = FALSE],
        Xtr_r[bi, , drop = FALSE],
        ytr[bi],
        classes,
        SEED + i * 100000L + r * 100L + f
      )

      Xbase <- if (obj$input == "raw") Xva_r else Xva_s

      P0 <- predict_model(obj, Xbase)

      ba0 <- site_balanced_accuracy(P0, valid, classes)
      ll0 <- site_logloss(P0, valid, classes)

      groups <- bone_groups(colnames(Xbase), space)

      for (bone in names(groups)) {
        cols <- which(colnames(Xbase) %in% groups[[bone]])
        if (length(cols) == 0) next

        for (b in seq_len(IMPORTANCE_PERMUTATIONS)) {
          Xp <- permute_bone_by_site(
            Xbase,
            valid$site_name,
            cols,
            seed = SEED + i * 10000000L + r * 100000L +
              f * 1000L + match(bone, names(groups)) * 100L + b
          )

          Pp <- predict_model(obj, Xp)

          bap <- site_balanced_accuracy(Pp, valid, classes)
          llp <- site_logloss(Pp, valid, classes)

          importance_results[[imp_i]] <- tibble(
            task = task,
            feature_space = space,
            model = model_name,
            repeat_id = r,
            fold = f,
            bone = bone,
            n_columns_permuted = length(cols),
            columns_permuted = paste(colnames(Xbase)[cols], collapse = " | "),
            permutation_id = b,
            baseline_BA = ba0,
            permuted_BA = bap,
            delta_BA = ba0 - bap,
            baseline_logloss = ll0,
            permuted_logloss = llp,
            delta_logloss = llp - ll0
          )

          imp_i <- imp_i + 1L
        }
      }
    }
  }
}

importance_long <- bind_rows(importance_results)

write_csv(
  importance_long,
  file.path(OUT_DIR, "heldout_bone_permutation_importance_long.csv")
)

# First average random permutations within each fold.
importance_fold <- importance_long %>%
  group_by(
    task, feature_space, model,
    repeat_id, fold, bone,
    n_columns_permuted, columns_permuted
  ) %>%
  summarise(
    delta_BA = mean(delta_BA, na.rm = TRUE),
    delta_logloss = mean(delta_logloss, na.rm = TRUE),
    .groups = "drop"
  )

# Average the three folds within each repeat.
importance_repeat <- importance_fold %>%
  group_by(
    task, feature_space, model,
    repeat_id, bone,
    n_columns_permuted, columns_permuted
  ) %>%
  summarise(
    delta_BA = mean(delta_BA, na.rm = TRUE),
    delta_logloss = mean(delta_logloss, na.rm = TRUE),
    .groups = "drop"
  )

# Variation is then reported across the five repeat fold-maps.
importance_summary <- importance_repeat %>%
  group_by(
    task, feature_space, model,
    bone, n_columns_permuted, columns_permuted
  ) %>%
  summarise(
    mean_delta_BA = mean(delta_BA, na.rm = TRUE),
    sd_delta_BA_across_repeats = sd(delta_BA, na.rm = TRUE),
    median_delta_BA = median(delta_BA, na.rm = TRUE),
    repeat_fraction_delta_BA_positive = mean(delta_BA > 0, na.rm = TRUE),
    mean_delta_logloss = mean(delta_logloss, na.rm = TRUE),
    sd_delta_logloss_across_repeats = sd(delta_logloss, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(task, feature_space) %>%
  mutate(
    predictive_rank = min_rank(desc(mean_delta_BA))
  ) %>%
  ungroup() %>%
  arrange(task, feature_space, predictive_rank)

write_csv(
  importance_summary,
  file.path(OUT_DIR, "heldout_bone_permutation_importance_summary.csv")
)

# ------------------------------------------------------------------------------
# 10. COMBINE STATISTICAL AND PREDICTIVE EVIDENCE
# ------------------------------------------------------------------------------

stat_for_join <- bind_rows(
  bone_tests %>%
    filter(task != "4class") %>%
    transmute(
      task,
      feature_space,
      bone,
      statistical_effect = abs(cliffs_delta),
      signed_statistical_effect = cliffs_delta,
      statistical_p = permutation_p,
      statistical_q_BH = q_BH,
      statistical_direction = direction
    ),
  bone_tests %>%
    filter(task == "4class") %>%
    transmute(
      task,
      feature_space,
      bone,
      statistical_effect = epsilon_squared,
      signed_statistical_effect = NA_real_,
      statistical_p = permutation_p,
      statistical_q_BH = q_BH,
      statistical_direction = "4-class omnibus"
    )
)

joint <- importance_summary %>%
  left_join(stat_for_join, by = c("task", "feature_space", "bone")) %>%
  group_by(task, feature_space) %>%
  mutate(
    predictive_percentile = percent_rank(mean_delta_BA),
    statistical_percentile = percent_rank(statistical_effect),
    joint_score = (predictive_percentile + statistical_percentile) / 2,
    evidence_category = case_when(
      statistical_q_BH < 0.05 &
        mean_delta_BA > 0 &
        repeat_fraction_delta_BA_positive >= 0.8 ~
        "statistically differentiated + predictively useful",

      statistical_q_BH < 0.05 ~
        "statistically differentiated; limited unique predictive importance",

      mean_delta_BA > 0 &
        repeat_fraction_delta_BA_positive >= 0.8 ~
        "predictively useful; weak/multiple-test statistical evidence",

      TRUE ~ "limited evidence"
    )
  ) %>%
  ungroup() %>%
  arrange(task, feature_space, desc(joint_score))

write_csv(
  joint,
  file.path(
    OUT_DIR,
    "BONE_CONSENSUS_statistical_plus_predictive_evidence.csv"
  )
)

top_bones <- joint %>%
  group_by(task, feature_space) %>%
  slice_max(joint_score, n = 10L, with_ties = FALSE) %>%
  ungroup()

write_csv(
  top_bones,
  file.path(OUT_DIR, "TOP_BONES_by_task_and_space.csv")
)

# ------------------------------------------------------------------------------
# 11. OPTIONAL SHAP FOR THE SAME SELECTED MODELS
# ------------------------------------------------------------------------------

if (RUN_SHAP && !requireNamespace("fastshap", quietly = TRUE)) {
  writeLines(
    c(
      "SHAP was requested but package 'fastshap' is not installed.",
      'Run install.packages("fastshap") and rerun this script.',
      "",
      "Statistical tests and held-out permutation importance have already run.",
      "Those are the primary inferential/predictive results."
    ),
    file.path(OUT_DIR, "SHAP_NOT_RUN_install_fastshap.txt")
  )
}

shap_values_all <- list()
shap_summary_all <- list()
shap_bone_all <- list()

if (RUN_SHAP && requireNamespace("fastshap", quietly = TRUE)) {

  cat("\nRunning SHAP for selected models...\n")

  si <- 1L

  for (i in seq_len(nrow(best_models))) {

    task <- best_models$task[i]
    space <- best_models$feature_space[i]
    model_name <- best_models$model[i]

    td <- make_task(task, known) %>%
      mutate(
        task_label = factor(task_label, levels = task_classes[[task]])
      )

    classes <- task_classes[[task]]
    vars <- feature_sets[[space]]

    pp <- fit_preprocessor(td, vars)

    Xs <- pp$train_scaled
    Xr <- pp$train_raw
    y <- as.character(td$task_label)

    bi <- balance_idx(
      y,
      SEED + 900000L + i
    )

    obj <- fit_model(
      model_name,
      Xs[bi, , drop = FALSE],
      Xr[bi, , drop = FALSE],
      y[bi],
      classes,
      SEED + 910000L + i
    )

    Xexplain <- if (obj$input == "raw") Xr else Xs
    Xdf <- as.data.frame(Xexplain)

    # For binary tasks explain the Funerary class.
    # For 4class explain every class separately.
    targets <- if (task == "4class") classes else "Funerary Context"

    for (target_class in targets) {

      pred_fun <- function(object, newdata) {
        P <- predict_model(object, as.matrix(newdata))
        as.numeric(P[, target_class])
      }

      set.seed(SEED + 920000L + si)

      S <- fastshap::explain(
        object = obj,
        X = Xdf,
        pred_wrapper = pred_fun,
        newdata = Xdf,
        nsim = SHAP_NSIM,
        adjust = TRUE,
        shap_only = TRUE
      )

      S <- as.data.frame(S)
      names(S) <- colnames(Xdf)

      shap_long <- as_tibble(S) %>%
        mutate(
          record_id = td$record_id,
          site_name = td$site_name,
          true_label = as.character(td$task_label),
          .before = 1
        ) %>%
        pivot_longer(
          cols = all_of(colnames(Xdf)),
          names_to = "feature",
          values_to = "shap"
        ) %>%
        mutate(
          task = task,
          feature_space = space,
          model = model_name,
          target_class = target_class,
          bone = map_chr(feature, bone_name, space = space),
          .before = 1
        )

      x_long <- as_tibble(Xdf) %>%
        mutate(record_id = td$record_id, .before = 1) %>%
        pivot_longer(
          -record_id,
          names_to = "feature",
          values_to = "transformed_value"
        )

      shap_long <- shap_long %>%
        left_join(x_long, by = c("record_id", "feature"))

      shap_values_all[[length(shap_values_all) + 1L]] <- shap_long

      shap_summary_all[[length(shap_summary_all) + 1L]] <-
        shap_long %>%
        group_by(
          task, feature_space, model,
          target_class, feature, bone
        ) %>%
        summarise(
          mean_abs_SHAP = mean(abs(shap), na.rm = TRUE),
          mean_SHAP = mean(shap, na.rm = TRUE),
          spearman_feature_SHAP = suppressWarnings(
            cor(
              transformed_value,
              shap,
              method = "spearman",
              use = "complete.obs"
            )
          ),
          .groups = "drop"
        ) %>%
        arrange(desc(mean_abs_SHAP))

      shap_bone_all[[length(shap_bone_all) + 1L]] <-
        shap_long %>%
        group_by(
          task, feature_space, model,
          target_class,
          record_id, site_name, true_label, bone
        ) %>%
        summarise(
          bone_abs_SHAP = sum(abs(shap), na.rm = TRUE),
          bone_signed_SHAP = sum(shap, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        group_by(
          task, feature_space, model,
          target_class, bone
        ) %>%
        summarise(
          mean_bone_abs_SHAP = mean(bone_abs_SHAP, na.rm = TRUE),
          mean_bone_signed_SHAP = mean(bone_signed_SHAP, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        arrange(desc(mean_bone_abs_SHAP))

      si <- si + 1L
    }
  }

  shap_values <- bind_rows(shap_values_all)
  shap_feature_summary <- bind_rows(shap_summary_all)
  shap_bone_summary <- bind_rows(shap_bone_all)

  write_csv(
    shap_values,
    file.path(OUT_DIR, "SHAP_values_site_feature_long.csv")
  )

  write_csv(
    shap_feature_summary,
    file.path(OUT_DIR, "SHAP_feature_importance_and_direction.csv")
  )

  write_csv(
    shap_bone_summary,
    file.path(OUT_DIR, "SHAP_BONE_importance_and_direction.csv")
  )

  # Add SHAP to joint table for the binary tasks.
  shap_binary <- shap_bone_summary %>%
    filter(target_class == "Funerary Context") %>%
    select(
      task, feature_space, bone,
      mean_bone_abs_SHAP,
      mean_bone_signed_SHAP
    )

  joint_with_shap <- joint %>%
    left_join(
      shap_binary,
      by = c("task", "feature_space", "bone")
    )

  write_csv(
    joint_with_shap,
    file.path(
      OUT_DIR,
      "BONE_CONSENSUS_statistical_predictive_SHAP.csv"
    )
  )
}

# ------------------------------------------------------------------------------
# 12. FIGURES
# ------------------------------------------------------------------------------

# Predictive importance.
for (task in names(task_classes)) {
  for (space in ANATOMICAL_SPACES) {

    q <- importance_summary %>%
      filter(.data$task == .env$task, .data$feature_space == .env$space) %>%
      slice_max(
        mean_delta_BA,
        n = 15L,
        with_ties = FALSE
      ) %>%
      mutate(bone = fct_reorder(bone, mean_delta_BA))

    if (nrow(q) == 0) next

    gp <- ggplot(q, aes(mean_delta_BA, bone)) +
      geom_point(size = 2.7) +
      geom_errorbar(
        aes(
          xmin = mean_delta_BA - sd_delta_BA_across_repeats,
          xmax = mean_delta_BA + sd_delta_BA_across_repeats
        ),
        orientation = "y",
        width = .15
      ) +
      geom_vline(xintercept = 0, linetype = 2) +
      labs(
        x = "Held-out balanced-accuracy decrease after bone permutation",
        y = NULL,
        title = paste(task, "—", space),
        subtitle = paste(
          "Best previously validated model:",
          unique(q$model),
          "| left/right perturbed together"
        )
      ) +
      theme_bw()

    ggsave(
      file.path(
        OUT_DIR,
        "figures",
        paste0(
          "predictive_bone_importance_",
          make.names(task), "_",
          make.names(space), ".png"
        )
      ),
      gp,
      width = 10,
      height = max(6, .30 * nrow(q) + 2),
      dpi = 300
    )
  }
}

# Statistical effect.
for (task in names(task_classes)) {
  for (space in ANATOMICAL_SPACES) {

    q <- bone_tests %>%
      filter(.data$task == .env$task, .data$feature_space == .env$space)

    if (nrow(q) == 0) next

    if (task == "4class") {
      q <- q %>%
        mutate(
          effect = epsilon_squared,
          significant = ifelse(q_BH < .05, "FDR < .05", "FDR ≥ .05"),
          bone = fct_reorder(bone, effect)
        )
      xlab <- "Kruskal-Wallis epsilon-squared"
    } else {
      q <- q %>%
        mutate(
          effect = abs(cliffs_delta),
          significant = ifelse(q_BH < .05, "FDR < .05", "FDR ≥ .05"),
          bone = fct_reorder(bone, effect)
        )
      xlab <- "|Cliff's delta|"
    }

    gp <- ggplot(q, aes(effect, bone, shape = significant)) +
      geom_point(size = 2.7) +
      labs(
        x = xlab,
        y = NULL,
        shape = NULL,
        title = paste(task, "—", space),
        subtitle = "Independent site-level group association; BH/FDR across bones"
      ) +
      theme_bw()

    ggsave(
      file.path(
        OUT_DIR,
        "figures",
        paste0(
          "statistical_bone_effect_",
          make.names(task), "_",
          make.names(space), ".png"
        )
      ),
      gp,
      width = 9,
      height = max(6, .30 * nrow(q) + 2),
      dpi = 300
    )
  }
}

# SHAP plots if available.
if (exists("shap_bone_summary")) {
  combos <- shap_bone_summary %>%
    distinct(task, feature_space, target_class)

  for (i in seq_len(nrow(combos))) {
    tt <- combos$task[i]
    ss <- combos$feature_space[i]
    cc <- combos$target_class[i]

    q <- shap_bone_summary %>%
      filter(
        task == tt,
        feature_space == ss,
        target_class == cc
      ) %>%
      slice_max(
        mean_bone_abs_SHAP,
        n = 15L,
        with_ties = FALSE
      ) %>%
      mutate(bone = fct_reorder(bone, mean_bone_abs_SHAP))

    gp <- ggplot(q, aes(mean_bone_abs_SHAP, bone)) +
      geom_col() +
      labs(
        x = "Mean absolute SHAP contribution",
        y = NULL,
        title = paste(tt, "—", ss, "—", cc),
        subtitle = "Descriptive explanation of full-reference refit; not a significance test"
      ) +
      theme_bw()

    ggsave(
      file.path(
        OUT_DIR,
        "figures",
        paste0(
          "SHAP_bone_",
          make.names(tt), "_",
          make.names(ss), "_",
          make.names(cc), ".png"
        )
      ),
      gp,
      width = 9,
      height = max(6, .30 * nrow(q) + 2),
      dpi = 300
    )
  }
}

# ------------------------------------------------------------------------------
# 13. REPORTING NOTES
# ------------------------------------------------------------------------------

writeLines(
  c(
    "RIGOROUS INTERPRETATION OF BONE IMPORTANCE",
    "",
    "1. Statistical association",
    "The formal group-comparison tables use one row per site_name so repeated",
    "records from a site are not treated as statistically independent.",
    "For binary tasks, effect size is Cliff's delta:",
    "  positive = higher bone representation in Funerary Context.",
    "P-values are obtained by label permutation and controlled across bones by BH/FDR.",
    "For 4class, the omnibus statistic is Kruskal-Wallis H with epsilon-squared",
    "effect size and a label-permutation p-value. Pairwise Wilcoxon/Cliff tests",
    "localize the class contrasts after the omnibus analysis.",
    "",
    "2. Predictive importance",
    "For each task x anatomical feature space, the best classifier is selected",
    "from the previously saved pooled out-of-fold balanced accuracy.",
    "That classifier is then refitted inside the SAME saved grouped-CV folds.",
    "A bone is perturbed only in the held-out fold; left/right sides are perturbed",
    "together. Importance is the decrease in site-level held-out balanced accuracy",
    "and the increase in held-out log loss.",
    "This is the primary evidence that a skeletal element contributes to prediction.",
    "",
    "3. SHAP",
    "SHAP is calculated only after model validation for the selected full-reference",
    "refit. Mean |SHAP| describes how strongly the fitted model uses the bone.",
    "For binary tasks, positive SHAP toward 'Funerary Context' raises P(F), while",
    "negative SHAP lowers it. For 4class, SHAP is calculated separately for each class.",
    "SHAP is NOT statistical significance and should not be interpreted causally.",
    "",
    "4. Correlation with numeric class codes is deliberately NOT used.",
    "The targets are categorical; the 4class target has no meaningful numeric order.",
    "Coding classes 1,2,3,4 and correlating bones with that number would create an",
    "arbitrary result. Group effect sizes + permutation inference are appropriate.",
    "",
    "5. Strongest evidence",
    "The most defensible anatomical result is a bone that:",
    "  a) has an FDR-supported group difference with a substantial effect size, AND",
    "  b) causes reproducible held-out performance loss when permuted.",
    "SHAP can then show how the selected model uses that feature.",
    "",
    "6. Correlated predictors",
    "Anatomical variables are correlated and models can substitute one predictor",
    "for another. Therefore absence of large permutation or SHAP importance does",
    "not prove biological irrelevance. Left/right grouping reduces one obvious",
    "source of importance dilution. %MNAU and ReMNAU should be interpreted as",
    "related representations rather than independent replications."
  ),
  file.path(OUT_DIR, "REPORTING_NOTES_bone_importance.txt")
)

capture.output(
  sessionInfo(),
  file = file.path(OUT_DIR, "sessionInfo.txt")
)

writeLines(
  paste0("Finished: ", Sys.time()),
  file.path(OUT_DIR, "RUN_FINISHED.txt")
)

cat("\n=== DONE ===\n")
cat("Output folder:", normalizePath(OUT_DIR, winslash = "/", mustWork = FALSE), "\n")
cat("Start with:\n")
cat("  TOP_BONES_by_task_and_space.csv\n")
cat("  BONE_CONSENSUS_statistical_plus_predictive_evidence.csv\n")
cat("  bone_statistical_tests_FDR.csv\n")
cat("  heldout_bone_permutation_importance_summary.csv\n")
if (RUN_SHAP) cat("  SHAP_BONE_importance_and_direction.csv (if fastshap is installed)\n")
