# THREE INDEPENDENT CLASSIFICATION TASKS -- R / TIDYVERSE
# 4class: exact labels Cannibalism / Carnivore / Funerary Context /
#         Geological transport (100 whole-site rows, 96 named parent sites).
# cannibalism_vs_fc: exact labels Cannibalism / Funerary Context (74 / 70).
# fc_vs_rest: Funerary Context / the six agreed negative labels (104 / 100).
# Unknown/Unkown (23 rows) are projection-only; sepulchral-cave labels excluded.
# No separate fixed holdout: OUTER CV = test, INNER CV = tuning validation.
# After evaluation, final tuning/fitting uses all reference rows within each task.
# Seven feature sets: C, E, C+E, absolute SPR, relative SPR, engineered, combined.
# E defaults to recomputed Shannon H/log(22), NOT Heip. Set cfg$evenness below
# to "source_heip" to use the original mnau_heip_evenness column instead.
# The 28 engineered predictors remain as supplied; their formulas are unknown.
# Fits: ridge binomial for binary tasks, ridge multinomial for 4class.
# Within each task: 20x5 outer CV, 4 inner folds, site grouping, identical splits
# across all 7 feature sets; task-specific preprocessing fits and lambda tuning.
# No R runtime was available during authoring: full R execution is unverified.
# CSV preprocessing and class counts were independently checked in Python.
#
# Run from the directory containing this file and the original tb_merged.csv:
# install.packages(c("tidyverse", "glmnet", "vegan", "broom"))
# source("three_task_workflow.R")
# Or: Rscript three_task_workflow.R tb_merged.csv results_three_tasks
# Script recreates all adjusted CSVs and audits from the ORIGINAL input.
# See README.md for metric definitions, evenness choice, and exact task labels.
# Docs: https://glmnet.stanford.edu/articles/glmnet.html
# Heip reference: https://scikit.bio/docs/dev/generated/skbio.diversity.alpha.heip_e.html

suppressPackageStartupMessages({
  library(tidyverse)
  library(glmnet)
  library(vegan)
  library(broom)
})

args <- commandArgs(trailingOnly = TRUE)
cfg <- list(
  input = if (length(args) >= 1) args[[1]] else "tb_merged.csv",
  out = if (length(args) >= 2) args[[2]] else "results_three_tasks",
  tasks = c("4class", "cannibalism_vs_fc", "fc_vs_rest"),
  # shannon22 = recomputed H/log(22); source_heip = supplied mnau_heip_evenness.
  # The choice applies to both Evenness_only and C_evenness.
  evenness = "shannon22",
  seed = 20260910L, repeats = 20L, outer_k = 5L, inner_k = 4L,
  lambdas = 10^seq(2, -5, length.out = 50),
  whole_col = "count_type", group_col = "site_name",
  spr_prefix = "ProportionalRep_MNIbased_",
  bilateral = c("clavicle", "scapula", "humerus", "radius", "ulna"),
  engineered_cols = c(
    "mnau_proximal_appendicular_mean", "mnau_lower_appendicular_mean",
    "mnau_distal_appendicular_mean", "mnau_appendicular_mean",
    "mnau_postcranial_total_mean", "mnau_top2_share_mcnaughton",
    "mnau_upper_appendicular_mean", "low_density_survival_index",
    "mnau_vertebrae_to_thorax_ratio", "all_sections_dominance",
    "mnau_lower_upper_appendicular_diff", "mnau_heip_evenness",
    "mnau_girdle_appendicular_logratio", "postcranial_continuity_hm",
    "mnau_girdle_to_appendicular_ratio", "mnau_gini", "density_representation_r2",
    "mnau_cv", "mnau_girdle_appendicular_diff", "mnau_full_axial_mean",
    "mnau_arms", "dominance_gap_all", "mnau_girdle_share_of_appendicular",
    "section_completeness_025_all", "whole_body_continuity_hm",
    "density_representation_slope", "mnau_limb_shaft_proxy_mean", "density_residual_sd"
  ),
  expected_engineered_n = 28L,
  # FALSE rejects missing absolute SPR values. Do not silently turn unknown
  # measurements into anatomical absences. TRUE only if NA explicitly means 0.
  missing_spr_is_zero = FALSE,
  # This explicit rule is NEW: the previous median threshold was unspecified.
  robust_median = 0.65
)
negative <- c("Cannibalism", "Carnivore", "Carnivore den(transport)",
              "Disarticulated within occupation layers", "Geological transport",
              "Carnivore Scavenge (in situ)")
projection <- c("Unknown", "Unkown")
cave <- c("Cuevas Sepulcrales", "Sepulchral Cave")
dir.create(cfg$out, recursive = TRUE, showWarnings = FALSE)
out <- function(x) file.path(cfg$out, x)
save_csv <- function(x, name) readr::write_csv(x, out(name), na = "")
if (!file.exists(cfg$input)) stop("Cannot find the original tb_merged.csv. Set the working directory to the extracted package folder or pass its path.")

# 1. Strict input checks and whole-site filtering ----------------------------
raw <- read_csv(cfg$input, show_col_types = FALSE, name_repair = "check_unique")
if ("preprocessing_version" %in% names(raw)) stop("Use the original input CSV; this input is already adjusted.")
required <- c(cfg$whole_col, cfg$group_col, "taphonomic_context")
if (!all(required %in% names(raw))) stop("Missing metadata: ", paste(setdiff(required, names(raw)), collapse = ", "))
raw <- raw %>% mutate(.source_row = row_number())
flag <- str_to_lower(str_trim(as.character(raw[[cfg$whole_col]])))
if (any(is.na(flag) | !flag %in% c("true", "false", "1", "0"))) {
  stop("Whole-site flag must contain only TRUE/FALSE or 1/0, with no missing values.")
}
dat <- raw[flag %in% c("true", "1"), ] %>%
  mutate(site_name = str_squish(as.character(.data[[cfg$group_col]])),
         taphonomic_context = str_squish(taphonomic_context),
         taphonomic_context = recode(taphonomic_context,
           "Carnivore den (transport)" = "Carnivore den(transport)"))
if (!nrow(dat) || any(is.na(dat$site_name) | dat$site_name == "")) stop("No whole-site rows, or missing site identifiers.")
if (any(is.na(dat$taphonomic_context))) stop("Missing taphonomic_context.")
unexpected <- setdiff(unique(dat$taphonomic_context), c("Funerary Context", negative, projection, cave))
if (length(unexpected)) stop("Unrecognized context labels: ", paste(unexpected, collapse = ", "))
dat <- dat %>% mutate(
  origin = case_when(taphonomic_context == "Funerary Context" ~ "Funerary",
                    taphonomic_context %in% negative ~ "Nonfunerary",
                    TRUE ~ NA_character_),
  role = case_when(!is.na(origin) ~ "reference",
                   taphonomic_context %in% projection ~ "unknown_projection",
                   TRUE ~ "excluded_cave"),
  y = if_else(is.na(origin), NA_integer_, as.integer(origin == "Funerary")))
save_csv(count(dat, role, taphonomic_context, name = "n"), "whole_site_counts.csv")

# 2. Bilateral redistribution, with a cell-level audit -----------------------
spr <- names(dat)[startsWith(names(dat), cfg$spr_prefix)]
if (!length(spr)) stop("No ProportionalRep_MNIbased_* columns found.")
if (!all(map_lgl(dat[spr], is.numeric))) stop("SPR columns must be numeric, on the 0-1 scale.")
if (cfg$missing_spr_is_zero) dat <- dat %>% mutate(across(all_of(spr), ~replace_na(.x, 0)))
if (anyNA(dat[spr])) stop("Missing SPR values: resolve their meaning before redistribution and feature calculation.")
if (any(!is.finite(as.matrix(dat[spr]))) || any(as.matrix(dat[spr]) < 0)) stop("Input SPR must be finite and nonnegative.")
# Input uses ratios, not 0-100 percentages. The attached ratio data already
# contain ten values >1. Apply the requested ceiling to ALL retained SPR fields
# AFTER allocation, and audit these separately from allocation-induced caps.
input_exceedances <- dat %>% select(.source_row, site_name, all_of(spr)) %>%
  pivot_longer(all_of(spr), names_to = "predictor", values_to = "original_value") %>%
  filter(original_value > 1)
save_csv(input_exceedances, "input_spr_values_above_one.csv")
# Match right or the documented typo rigth, but reject ambiguous duplicates.
find_part <- function(element, side) {
  sides <- if (side == "right") c("right", "rigth") else side
  candidates <- paste0(cfg$spr_prefix, element, "_", sides)
  hit <- spr[tolower(spr) %in% tolower(candidates)]
  if (length(hit) != 1) stop("Need exactly one column for ", element, " ", side,
                            "; expected ", paste(candidates, collapse = " or "))
  hit
}
audit <- vector("list", length(cfg$bilateral))
removed <- character()
for (j in seq_along(cfg$bilateral)) {
  e <- cfg$bilateral[[j]]
  l <- find_part(e, "left"); r <- find_part(e, "right"); z <- find_part(e, "indet")
  uncapped_l <- dat[[l]] + dat[[z]] / 2
  uncapped_r <- dat[[r]] + dat[[z]] / 2
  audit[[j]] <- tibble(.source_row = dat$.source_row, site_name = dat$site_name,
    element = e, left_before = dat[[l]], right_before = dat[[r]], indet_before = dat[[z]],
    left_uncapped = uncapped_l, right_uncapped = uncapped_r,
    left_after = pmin(uncapped_l, 1), right_after = pmin(uncapped_r, 1),
    left_capped = uncapped_l > 1, right_capped = uncapped_r > 1,
    discarded_mass = pmax(uncapped_l - 1, 0) + pmax(uncapped_r - 1, 0))
  dat[[l]] <- uncapped_l; dat[[r]] <- uncapped_r
  removed <- c(removed, z)
}
save_csv(bind_rows(audit), "whole_site_indet_redistribution_audit.csv")
spr <- setdiff(spr, removed)
dat <- dat %>% select(-all_of(removed))
cap_audit <- dat %>% select(.source_row, site_name, all_of(spr)) %>%
  pivot_longer(all_of(spr), names_to = "predictor", values_to = "uncapped_value") %>%
  filter(uncapped_value > 1) %>%
  left_join(input_exceedances, by = c(".source_row", "site_name", "predictor")) %>%
  mutate(adjusted_value = 1, discarded_mass = uncapped_value - 1,
         reason = if_else(is.na(original_value), "bilateral_allocation", "already_above_one_in_input"))
save_csv(cap_audit, "all_spr_capping_audit.csv")
dat <- dat %>% mutate(across(all_of(spr), ~pmin(.x, 1)))
if (length(spr) != 22L) warning("Adjusted SPR has ", length(spr), " columns, rather than the previously reported 22.")
X <- as.matrix(dat[spr]); total <- rowSums(X)
P <- X / ifelse(total > 0, total, 1)
rem <- paste0("Adjusted_ReMNAU_", substring(spr, nchar(cfg$spr_prefix) + 1))
colnames(P) <- rem
dat <- bind_cols(dat, as_tibble(P)) %>% mutate(
  C = rowMeans(X),
  E = -rowSums(P * log(pmax(P, .Machine$double.xmin))) / log(ncol(P)),
  represented_parts = rowSums(X > 0),
  empty_profile = total == 0,
  preprocessing_version = "equal_split_all_spr_cap1_v2")
# For an empty profile the mathematical composition is undefined; this workflow
# encodes it as zeros and E=0, with empty_profile retained for transparent reporting.
# Original ReMNAU and original engineered fields remain in the output for audit;
# only Adjusted_ReMNAU_* is used by the new ReMNAU model.
# The task-independent adjusted data are exported after E_selected is assigned.

# Never infer engineered predictors from all numeric columns (metadata leakage).
eng <- cfg$engineered_cols
if (length(eng) != cfg$expected_engineered_n || anyDuplicated(eng)) stop("Engineered feature count/uniqueness mismatch.")
if (!all(eng %in% names(dat))) stop("Missing engineered columns: ", paste(setdiff(eng, names(dat)), collapse = ", "))
if (length(intersect(eng, c(required, ".source_row", "y", "origin", "role", spr, rem)))) stop("Engineered list overlaps metadata or other model blocks.")
if (!all(map_lgl(dat[eng], is.numeric))) stop("Engineered predictors must be numeric.")
if (any(is.infinite(as.matrix(dat[eng])))) stop("Infinite engineered values: resolve their formulas before fitting.")
if (!cfg$evenness %in% c("shannon22", "source_heip")) stop("Unknown evenness option.")
dat <- dat %>% mutate(E_Shannon22 = E, E_source_heip = mnau_heip_evenness,
  E_selected = if (cfg$evenness == "shannon22") E_Shannon22 else E_source_heip,
  evenness_definition = cfg$evenness)
# E retains the prior Shannon definition for compatibility. Only E_selected is
# used by the new Evenness_only and C_evenness models. Source Heip is unmodified;
# this script makes no claim about the number/definition of parts in its formula.
save_csv(dat, "whole_site_indet_adjusted_analysis_data.csv")
families <- list(C_only = "C", Evenness_only = "E_selected",
  C_evenness = c("C", "E_selected"), MNAU = spr, ReMNAU = rem,
  Engineered = eng, Combined = c(spr, rem, eng))
save_csv(imap_dfr(families, ~tibble(model = .y, predictor = .x,
                                 evenness_definition = cfg$evenness)), "model_feature_manifest.csv")
task_levels <- list(
  `4class` = c("Cannibalism", "Carnivore", "Funerary Context", "Geological transport"),
  cannibalism_vs_fc = c("Cannibalism", "Funerary Context"),
  fc_vs_rest = c("Rest", "Funerary Context"))
if (!all(cfg$tasks %in% names(task_levels))) stop("Unknown task requested.")

task_data <- function(task) {
  if (task == "4class") {
    ans <- dat %>% filter(taphonomic_context %in% task_levels[[task]]) %>%
      mutate(target = taphonomic_context)
  } else if (task == "cannibalism_vs_fc") {
    ans <- dat %>% filter(taphonomic_context %in% task_levels[[task]]) %>%
      mutate(target = taphonomic_context)
  } else {
    ans <- dat %>% filter(taphonomic_context %in% c("Funerary Context", negative)) %>%
      mutate(target = if_else(taphonomic_context == "Funerary Context", "Funerary Context", "Rest"))
  }
  # Drop the old binary target columns to prevent their accidental use in 4class.
  ans %>% select(-any_of(c("origin", "y", "role"))) %>%
    mutate(target = factor(target, levels = task_levels[[task]]), task = task)
}
unknown <- dat %>% filter(taphonomic_context %in% projection) %>%
  select(-any_of(c("origin", "y", "role")))
save_csv(unknown, "whole_site_unknown_data.csv")
task_counts <- map_dfr(cfg$tasks, function(task) task_data(task) %>%
  group_by(target) %>% summarise(rows = n(), parents = n_distinct(site_name), .groups = "drop") %>%
  mutate(task = task, .before = 1))
save_csv(task_counts, "task_class_counts.csv")

# GROUPED SPLITS ------------------------------------------------------------
# Each task builds its own split plan BEFORE any model is fitted. Within a task,
# all seven models reuse that exact plan. Here groups are stratified by class,
# so proportions are approximate in ROWS when some parents have multiple rows.
make_folds <- function(d, k, seed) {
  g <- d %>% distinct(site_name, target) %>% arrange(target, site_name)
  if (any(count(g, site_name)$n > 1)) stop("Contradictory class labels within a named parent site.")
  if (any(table(g$target) < k)) stop("Too few parent sites per class for ", k, " folds.")
  set.seed(seed)
  g <- g %>% group_by(target) %>%
    mutate(fold = sample(rep(seq_len(k), length.out = n()))) %>% ungroup()
  map(seq_len(k), function(f) {
    assessment <- which(d$site_name %in% g$site_name[g$fold == f])
    analysis <- setdiff(seq_len(nrow(d)), assessment)
    stopifnot(!length(intersect(d$site_name[analysis], d$site_name[assessment])),
              all(table(d$target[analysis]) > 0), all(table(d$target[assessment]) > 0))
    list(analysis = analysis, assessment = assessment)
  })
}
split_size <- function(d, split, stage, repeat_id, outer_fold, inner_fold = NA_integer_) {
  tr <- d[split$analysis, ]; va <- d[split$assessment, ]
  tibble(stage = stage, repeat_id = repeat_id, outer_fold = outer_fold, inner_fold = inner_fold,
    available_rows = nrow(d), training_rows = nrow(tr), assessment_rows = nrow(va),
    training_parents = n_distinct(tr$site_name), assessment_parents = n_distinct(va$site_name))
}
split_class_size <- function(d, split, stage, repeat_id, outer_fold, inner_fold = NA_integer_) {
  bind_rows(d[split$analysis, ] %>% mutate(split_role = "training"),
            d[split$assessment, ] %>% mutate(split_role = "assessment")) %>%
    group_by(split_role, target) %>% summarise(rows = n(), parents = n_distinct(site_name), .groups = "drop") %>%
    mutate(stage = stage, repeat_id = repeat_id, outer_fold = outer_fold, inner_fold = inner_fold)
}

# TRAINING-ONLY PREPROCESSING AND LOGISTIC MODELS ----------------------------
prep_fit <- function(d, cols) {
  x <- as.matrix(d[cols])
  med <- apply(x, 2, function(z) if (all(is.na(z))) 0 else median(z, na.rm = TRUE))
  for (j in seq_along(cols)) x[is.na(x[, j]), j] <- med[[j]]
  mu <- colMeans(x); s <- apply(x, 2, sd)
  list(cols = cols, median = med, center = mu, scale = s, keep = is.finite(s) & s > 1e-12)
}
prep_apply <- function(d, pp) {
  x <- as.matrix(d[pp$cols])
  for (j in seq_along(pp$cols)) x[is.na(x[, j]), j] <- pp$median[[j]]
  x <- x[, pp$keep, drop = FALSE]
  if (ncol(x)) x <- sweep(sweep(x, 2, pp$center[pp$keep], "-"), 2, pp$scale[pp$keep], "/")
  x
}
pad <- function(x) if (ncol(x) == 1) cbind(x, .zero_dummy = 0) else x
fit_path <- function(d, cols, lev) {
  pp <- prep_fit(d, cols); x <- prep_apply(d, pp)
  y <- factor(d$target, levels = lev); K <- length(lev)
  counts <- as.numeric(table(y)); stopifnot(all(counts > 0))
  w <- nrow(d) / (K * counts[as.integer(y)])
  if (!ncol(x)) return(list(pp = pp, fit = NULL, classes = lev))
  response <- if (K == 2) as.integer(y) - 1L else y
  fit <- glmnet(pad(x), response, family = if (K == 2) "binomial" else "multinomial",
    alpha = 0, lambda = cfg$lambdas, weights = w, standardize = FALSE)
  list(pp = pp, fit = fit, classes = lev)
}
predict_path <- function(object, d, lambda) {
  lev <- object$classes; K <- length(lev); N <- nrow(d); L <- length(lambda)
  ans <- array(1/K, dim = c(N, K, L), dimnames = list(NULL, lev, as.character(lambda)))
  if (!N || is.null(object$fit)) return(ans) # balanced intercept-only fallback
  p <- predict(object$fit, newx = pad(prep_apply(d, object$pp)), s = lambda, type = "response")
  if (K == 2) {
    p <- matrix(p, nrow = N, ncol = L)
    ans[, 1, ] <- 1 - p; ans[, 2, ] <- p
  } else {
    ans[, , ] <- p[, lev, , drop = FALSE]
  }
  stopifnot(all(is.finite(ans)), all(ans >= -1e-10), all(ans <= 1+1e-10))
  ans
}
slice_prob <- function(a, j, lev) matrix(a[, , j], nrow = dim(a)[1], ncol = length(lev), dimnames = list(NULL, lev))
auc <- function(y, p) {
  n1 <- sum(y); n0 <- length(y)-n1
  if (!n1 || !n0) stop("AUC requires both positive and negative observations.")
  (sum(rank(p, ties.method = "average")[y]) - n1*(n1+1)/2) / (n1*n0)
}
choose_class <- function(p, lev) {
  if (length(lev) == 2) return(ifelse(p[, 2] >= .5, lev[2], lev[1]))
  lev[max.col(p, ties.method = "first")]
}
metrics <- function(target, p, lev) {
  target <- as.character(target); pred <- choose_class(p, lev)
  recall <- map_dbl(lev, ~mean(pred[target == .x] == .x))
  au <- map_dbl(seq_along(lev), ~auc(target == lev[[.x]], p[, .x]))
  f1 <- map_dbl(lev, function(cl) {
    tp <- sum(target == cl & pred == cl); fp <- sum(target != cl & pred == cl); fn <- sum(target == cl & pred != cl)
    if (2*tp+fp+fn == 0) 0 else 2*tp/(2*tp+fp+fn)
  })
  truth <- outer(target, lev, "==") * 1
  brier <- if (length(lev) == 2) mean((p[, 2]-truth[, 2])^2) else mean(rowSums((p-truth)^2))
  tibble(balanced_accuracy = mean(recall), accuracy = mean(pred == target),
    roc_auc = mean(au), macro_f1 = mean(f1), brier = brier,
    log_loss = -mean(log(pmax(p[cbind(seq_along(target), match(target, lev))], 1e-15))))
}
tune_lambda <- function(d, cols, folds, lev) {
  probs <- array(NA_real_, dim = c(nrow(d), length(lev), length(cfg$lambdas)))
  for (f in folds) {
    fit <- fit_path(d[f$analysis, ], cols, lev)
    probs[f$assessment, , ] <- predict_path(fit, d[f$assessment, ], cfg$lambdas)
  }
  stopifnot(!anyNA(probs))
  scores <- map_dbl(seq_along(cfg$lambdas), function(j) {
    p <- slice_prob(probs, j, lev)
    mean(map_dbl(seq_along(lev), ~auc(as.character(d$target) == lev[[.x]], p[, .x])))
  })
  best <- which.max(scores) # descending grid: exact ties select stronger penalty
  list(lambda = cfg$lambdas[[best]], table = tibble(lambda = cfg$lambdas, inner_auc = scores))
}
prob_table <- function(d, p, lev) {
  a <- d %>% select(any_of(c(".source_row", "site_name", "ind_name", "individual_id", "target")))
  for (j in seq_along(lev)) a[[paste0("prob_", j)]] <- p[, j]
  a %>% mutate(predicted_class = choose_class(p, lev))
}

# TASK-SPECIFIC EXPLORATORY DIAGNOSTICS --------------------------------------
# One mean descriptor/profile per named parent limits duplicate-row dependence.
# These are in-sample exploratory analyses, separate from prediction evaluation.
diagnostics <- function(ref, lev, task_dir) {
  parent <- ref %>% group_by(site_name, target) %>%
    summarise(across(all_of(c(spr, "C", "E_selected")), ~if (all(is.na(.x))) NA_real_ else mean(.x, na.rm = TRUE)), .groups = "drop")
  write_csv(parent, file.path(task_dir, "parent_mean_sensitivity_data.csv"))
  desc <- parent %>% select(target, C, E_selected) %>% pivot_longer(-target, names_to = "variable") %>%
    group_by(target, variable) %>% summarise(n_observed = sum(!is.na(value)), median = median(value, na.rm = TRUE),
      q25 = quantile(value, .25, na.rm = TRUE), q75 = quantile(value, .75, na.rm = TRUE), .groups = "drop")
  write_csv(desc, file.path(task_dir, "parent_mean_univariate_summary.csv"))
  tests <- map_dfr(c("C", "E_selected"), function(v) {
    a <- parent %>% filter(!is.na(.data[[v]]))
    if (length(lev) == 2) {
      pos <- a[[v]][a$target == lev[2]]; neg <- a[[v]][a$target == lev[1]]
      wt <- wilcox.test(pos, neg, exact = FALSE)
      tibble(variable = v, test = "Mann-Whitney", p_value = wt$p.value,
             cliffs_delta_positive_minus_negative = mean(sign(outer(pos, neg, "-"))))
    } else {
      kt <- kruskal.test(a[[v]], a$target)
      tibble(variable = v, test = "Kruskal-Wallis", p_value = kt$p.value,
             cliffs_delta_positive_minus_negative = NA_real_)
    }
  })
  write_csv(tests, file.path(task_dir, "parent_mean_univariate_tests.csv"))
  if (length(lev) == 2) {
    complete <- parent %>% filter(is.finite(C), is.finite(E_selected)) %>%
      mutate(y = as.integer(target == lev[2]), C_z = as.numeric(scale(C)), E_z = as.numeric(scale(E_selected)))
    if (all(is.finite(complete$C_z)) && all(is.finite(complete$E_z))) {
      m0 <- glm(y ~ C_z, data = complete, family = binomial())
      m1 <- glm(y ~ C_z + E_z, data = complete, family = binomial())
      write_lines(capture.output(anova(m0, m1, test = "LRT")), file.path(task_dir, "parent_mean_evenness_LR_test.txt"))
      write_csv(tidy(m1) %>% mutate(odds_ratio = exp(estimate)), file.path(task_dir, "parent_mean_logistic_coefficients.csv"))
    }
  }
  x <- as.matrix(parent[spr]); keep <- apply(x, 2, sd) > 1e-12
  z <- scale(x[, keep, drop = FALSE]); pc <- prcomp(z, center = FALSE, scale. = FALSE)
  if (cor(pc$x[, 1], parent$C) < 0) { pc$x[, 1] <- -pc$x[, 1]; pc$rotation[, 1] <- -pc$rotation[, 1] }
  scores <- bind_cols(parent %>% select(site_name, target, C, E_selected), as_tibble(pc$x))
  var <- pc$sdev^2/sum(pc$sdev^2)
  write_csv(scores, file.path(task_dir, "parent_mean_pca_scores.csv"))
  write_csv(as.data.frame(pc$rotation) %>% rownames_to_column("predictor"), file.path(task_dir, "parent_mean_pca_loadings.csv"))
  write_csv(tibble(PC = seq_along(var), variance_fraction = var), file.path(task_dir, "parent_mean_pca_variance.csv"))
  fig <- ggplot(scores, aes(PC1, PC2, color = target)) + geom_point(size = 2) +
    labs(x = sprintf("PC1 (%.1f%%)", 100*var[1]), y = sprintf("PC2 (%.1f%%)", 100*var[2]),
         color = "Class", subtitle = "Exploratory PCA: one mean profile per named parent") + theme_minimal()
  ggsave(file.path(task_dir, "parent_mean_pca.png"), fig, width = 9, height = 6, dpi = 300)
  set.seed(cfg$seed)
  perma <- vegan::adonis2(z ~ target, data = parent, method = "euclidean", permutations = 9999)
  dispersion <- vegan::betadisper(dist(z), parent$target, type = "centroid")
  set.seed(cfg$seed)
  disp <- vegan::permutest(dispersion, permutations = 9999)
  write_lines(capture.output(perma), file.path(task_dir, "parent_mean_permanova.txt"))
  write_lines(capture.output(disp), file.path(task_dir, "parent_mean_permdisp.txt"))
}

# RUN EACH TASK INDEPENDENTLY -----------------------------------------------
all_performance <- list()
for (task in cfg$tasks) {
  ref <- task_data(task); lev <- task_levels[[task]]
  task_dir <- out(task); dir.create(task_dir, recursive = TRUE, showWarnings = FALSE)
  save_task <- function(x, name) write_csv(x, file.path(task_dir, name), na = "")
  save_task(ref, "reference_data.csv")
  save_task(tibble(probability_column = paste0("prob_", seq_along(lev)), class = lev), "probability_class_key.csv")
  if (length(intersect(ref$site_name, unknown$site_name))) warning(task, ": some projected unknowns share a parent name with references.")
  task_seed <- cfg$seed + match(task, names(task_levels))*100000L
  outer_folds <- map(seq_len(cfg$repeats), ~make_folds(ref, cfg$outer_k, task_seed+.x))
  inner_folds <- map(seq_len(cfg$repeats), function(r) map(seq_len(cfg$outer_k), function(f) {
    make_folds(ref[outer_folds[[r]][[f]]$analysis, ], cfg$inner_k, task_seed+1000L+100L*r+f)
  }))
  final_folds <- make_folds(ref, cfg$inner_k, task_seed+99999L)
  saveRDS(list(config = cfg, task = task, task_seed = task_seed, classes = lev,
    input_md5 = tools::md5sum(cfg$input), reference_row_ids = ref$.source_row,
    outer = outer_folds, inner = inner_folds, final = final_folds), file.path(task_dir, "split_plan.rds"))
  sizes <- list(); class_sizes <- list(); assignments <- list(); idx <- 0L
  for (r in seq_len(cfg$repeats)) for (f in seq_len(cfg$outer_k)) {
    sp <- outer_folds[[r]][[f]]; tr <- ref[sp$analysis, ]; idx <- idx+1L
    sizes[[idx]] <- split_size(ref, sp, "outer_test", r, f)
    class_sizes[[idx]] <- split_class_size(ref, sp, "outer_test", r, f)
    assignments[[idx]] <- ref[sp$assessment, ] %>% select(.source_row, site_name, target) %>%
      mutate(stage = "outer_test", repeat_id = r, outer_fold = f, inner_fold = NA_integer_)
    for (j in seq_len(cfg$inner_k)) {
      ip <- inner_folds[[r]][[f]][[j]]; idx <- idx+1L
      # Explicitly check the inner folds never contain any outer-test parent.
      stopifnot(!length(intersect(tr$site_name, ref$site_name[sp$assessment])))
      sizes[[idx]] <- split_size(tr, ip, "inner_validation", r, f, j)
      class_sizes[[idx]] <- split_class_size(tr, ip, "inner_validation", r, f, j)
      assignments[[idx]] <- tr[ip$assessment, ] %>% select(.source_row, site_name, target) %>%
        mutate(stage = "inner_validation", repeat_id = r, outer_fold = f, inner_fold = j)
    }
  }
  for (j in seq_len(cfg$inner_k)) {
    idx <- idx+1L
    sizes[[idx]] <- split_size(ref, final_folds[[j]], "final_tuning", NA_integer_, NA_integer_, j)
    class_sizes[[idx]] <- split_class_size(ref, final_folds[[j]], "final_tuning", NA_integer_, NA_integer_, j)
    assignments[[idx]] <- ref[final_folds[[j]]$assessment, ] %>% select(.source_row, site_name, target) %>%
      mutate(stage = "final_tuning", repeat_id = NA_integer_, outer_fold = NA_integer_, inner_fold = j)
  }
  save_task(bind_rows(sizes), "split_sizes.csv")
  save_task(bind_rows(class_sizes), "split_sizes_by_class.csv")
  save_task(bind_rows(assignments), "assessment_assignments.csv")
  save_task(bind_rows(sizes) %>% group_by(stage) %>%
    summarise(across(c(training_rows, assessment_rows, training_parents, assessment_parents),
                     list(min = min, max = max, mean = mean)), .groups = "drop"), "split_size_ranges.csv")

  oof <- list(); tuned_paths <- list(); index <- 0L
  for (r in seq_len(cfg$repeats)) {
    message(task, ": outer repeat ", r, "/", cfg$repeats)
    for (f in seq_len(cfg$outer_k)) {
      sp <- outer_folds[[r]][[f]]; tr <- ref[sp$analysis, ]; te <- ref[sp$assessment, ]
      for (model in names(families)) {
        index <- index+1L
        tuned <- tune_lambda(tr, families[[model]], inner_folds[[r]][[f]], lev)
        fit <- fit_path(tr, families[[model]], lev)
        p <- slice_prob(predict_path(fit, te, tuned$lambda), 1, lev)
        oof[[index]] <- prob_table(te, p, lev) %>% mutate(repeat_id = r, fold = f, model = model, lambda = tuned$lambda)
        tuned_paths[[index]] <- tuned$table %>% mutate(repeat_id = r, fold = f, model = model)
      }
    }
  }
  oof <- bind_rows(oof); pcols <- paste0("prob_", seq_along(lev))
  stopifnot(nrow(oof) == nrow(ref)*cfg$repeats*length(families),
            all(abs(rowSums(as.matrix(oof[pcols]))-1) < 1e-8),
            all(count(oof, model, repeat_id, .source_row)$n == 1L))
  save_task(oof, "outer_test_predictions.csv")
  save_task(bind_rows(tuned_paths), "inner_tuning_results.csv")
  repeat_metrics <- oof %>% group_by(model, repeat_id) %>%
    group_modify(~metrics(.x$target, as.matrix(.x[pcols]), lev)) %>% ungroup()
  save_task(repeat_metrics, "metrics_by_repeat.csv")
  performance <- repeat_metrics %>% group_by(model) %>%
    summarise(across(c(balanced_accuracy, accuracy, roc_auc, macro_f1, brier, log_loss),
                     list(mean = mean, sd = sd)), .groups = "drop") %>% mutate(task = task, .before = 1)
  save_task(performance, "model_performance.csv")
  all_performance[[task]] <- performance
  save_task(oof %>% count(model, repeat_id, target, predicted_class, name = "n"), "confusion_counts_by_repeat.csv")
  class_recall <- oof %>% group_by(model, repeat_id, target) %>%
    summarise(recall = mean(as.character(target) == predicted_class), n = n(), .groups = "drop")
  save_task(class_recall, "class_recall_by_repeat.csv")
  # Each named parent receives one prediction in this sensitivity analysis.
  parent_oof <- oof %>% group_by(model, repeat_id, site_name, target) %>%
    summarise(across(all_of(pcols), mean), .groups = "drop")
  save_task(parent_oof %>% group_by(model, repeat_id) %>%
    group_modify(~metrics(.x$target, as.matrix(.x[pcols]), lev)) %>% ungroup(), "parent_averaged_metrics_by_repeat.csv")

  final_models <- list(); projections <- list(); final_tuning <- list()
  for (model in names(families)) {
    tuned <- tune_lambda(ref, families[[model]], final_folds, lev)
    fit <- fit_path(ref, families[[model]], lev)
    final_models[[model]] <- list(model = fit, lambda = tuned$lambda, predictors = families[[model]], evenness = cfg$evenness)
    final_tuning[[model]] <- tuned$table %>% mutate(model = model, selected = lambda == tuned$lambda)
    if (nrow(unknown)) {
      p <- slice_prob(predict_path(fit, unknown, tuned$lambda), 1, lev)
      projections[[model]] <- bind_cols(
        prob_table(unknown, p, lev), unknown %>% select(taphonomic_context, C, E_selected, represented_parts, empty_profile)) %>%
        mutate(model = model, task = task, evenness_definition = cfg$evenness)
    }
  }
  saveRDS(final_models, file.path(task_dir, "final_models.rds"))
  save_task(bind_rows(final_tuning), "final_tuning_results.csv")
  if (length(projections)) {
    predictions <- bind_rows(projections)
    save_task(predictions, "unknown_all_class_probabilities.csv")
    # This FC probability is conditional on the task's candidate classes.
    fc_col <- pcols[match("Funerary Context", lev)]
    fc <- predictions %>% select(.source_row, site_name, model, all_of(fc_col)) %>%
      rename(FC_probability = all_of(fc_col)) %>% pivot_wider(names_from = model, values_from = FC_probability)
    if (length(lev) == 2) {
      fc <- fc %>% rowwise() %>% mutate(
        min_affinity = min(c_across(all_of(names(families)))),
        max_affinity = max(c_across(all_of(names(families)))),
        median_affinity = median(c_across(all_of(names(families)))),
        interpretation = case_when(
          min_affinity < .5 & max_affinity > .5 ~ "representation-sensitive",
          min_affinity > .5 & median_affinity >= cfg$robust_median ~ "robust FC affinity",
          max_affinity < .5 & median_affinity <= 1-cfg$robust_median ~ paste0("robust ", lev[1], " affinity"),
          TRUE ~ "indeterminate")) %>% ungroup()
    }
    # No binary .5 consensus interpretation is imposed on the four-class model.
    save_task(fc, "unknown_FC_probability_by_model.csv")
  }
  diagnostics(ref, lev, task_dir)
}
save_csv(bind_rows(all_performance), "all_tasks_model_performance.csv")
write_lines(capture.output(sessionInfo()), out("sessionInfo.txt"))
message("Completed requested tasks. Outputs: ", normalizePath(cfg$out))
