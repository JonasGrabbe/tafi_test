# WHOLE-SITE SPR WORKFLOW -- R / TIDYVERSE
# New implementation of the workflow described in the supplied conversation.
# Configured against the attached tb_merged.csv: 450 rows, 152 whole-site rows,
# 104 reference rows (49 F / 55 NF), 100 reference parent sites, 23 unknowns.
# The earlier reply reported 113 whole-site rows and 72 reference rows. Those
# counts do not match this attachment. Original code/seeds/tuning are unavailable;
# this script cannot promise exact reproduction of the earlier numerical tables.
# This script has not been executed in R in the delivery environment.
#
# SETUP
# install.packages(c("tidyverse", "glmnet", "vegan", "broom"))
# 1. Keep the ORIGINAL, unadjusted tb_merged.csv beside this script.
# 2. All 28 engineered names are already configured from the attachment.
#    Engineered variables are retained as supplied, as described previously;
#    their formulas are unknown. They are NOT silently recomputed from SPR.
# 3. Run from that directory: source("whole_site_workflow.R")
#    Or: Rscript whole_site_workflow.R tb_merged.csv results
# Do not input an already adjusted CSV: redistribution must occur only once.
#
# EXPLICIT NEW SETTINGS (not recovered settings from the original analysis):
# ridge logistic regression; lambda = 10^seq(2,-5,length.out=50);
# tuning by pooled inner out-of-fold ROC-AUC; ties favor larger lambda;
# inverse class-frequency weights, recomputed in every training fold;
# median imputation and scaling learned only inside each training fold;
# 20 repeats x 5 outer folds, 4 inner folds; grouping by site_name;
# threshold 0.5; repeat-level metrics pool all outer held-out rows;
# reported SD is variation across repeats, NOT a confidence interval.
# Final models use an additional 4-fold grouped tuning on all reference data.
# Unknown and sepulchral-cave records never participate in fitting/tuning.
#
# Class-balanced probabilities are affinity scores, not calibrated estimates
# of archaeological origin. Adjusted_ReMNAU is adjusted SPR / row sum.
# Equal allocation of unknown laterality is a symmetry assumption, not a claim
# that the true left/right specimen counts are equal. Capping at 1 follows the
# requested convention and is fully audited; it can discard allocated mass.
#
# Docs: https://glmnet.stanford.edu/articles/glmnet.html
# https://vegandevs.github.io/vegan/reference/adonis.html
# https://vegandevs.github.io/vegan/reference/betadisper.html

suppressPackageStartupMessages({
  library(tidyverse)
  library(glmnet)
  library(vegan)
  library(broom)
})

args <- commandArgs(trailingOnly = TRUE)
cfg <- list(
  input = if (length(args) >= 1) args[[1]] else "tb_merged.csv",
  out = if (length(args) >= 2) args[[2]] else "results",
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
save_csv(dat, "whole_site_indet_adjusted_analysis_data.csv")

# Never infer engineered predictors from all numeric columns (metadata leakage).
eng <- cfg$engineered_cols
if (length(eng) != cfg$expected_engineered_n || anyDuplicated(eng)) stop("Engineered feature count/uniqueness mismatch.")
if (!all(eng %in% names(dat))) stop("Missing engineered columns: ", paste(setdiff(eng, names(dat)), collapse = ", "))
if (length(intersect(eng, c(required, ".source_row", "y", "origin", "role", spr, rem)))) stop("Engineered list overlaps metadata or other model blocks.")
if (!all(map_lgl(dat[eng], is.numeric))) stop("Engineered predictors must be numeric.")
if (any(is.infinite(as.matrix(dat[eng])))) stop("Infinite engineered values: resolve their formulas before fitting.")
families <- list(C_only = "C", C_evenness = c("C", "E"),
                 MNAU = spr, ReMNAU = rem, Engineered = eng,
                 Combined = c(spr, rem, eng))
save_csv(imap_dfr(families, ~tibble(model = .y, predictor = .x)), "model_feature_manifest.csv")
ref <- filter(dat, role == "reference")
unknown <- filter(dat, role == "unknown_projection")
save_csv(ref, "whole_site_reference_data.csv")
save_csv(unknown, "whole_site_unknown_data.csv")
if (n_distinct(ref$y) != 2) stop("Reference data need both classes.")
conflicts <- ref %>% distinct(site_name, y) %>% count(site_name) %>% filter(n > 1)
if (nrow(conflicts)) stop("A parent site has contradictory reference classes; resolve before grouped stratification.")
overlap <- intersect(ref$site_name, unknown$site_name)
if (length(overlap)) warning("Some unknown records share a named site with reference records; their projections are not independent new-site evaluations: ", paste(overlap, collapse = ", "))
save_csv(tibble(item = c("whole_site_rows", "reference_rows", "reference_sites", "funerary_rows", "nonfunerary_rows", "unknown_rows"),
               observed = c(nrow(dat), nrow(ref), n_distinct(ref$site_name), sum(ref$y == 1), sum(ref$y == 0), nrow(unknown)),
               previously_reported_unverified = c(113, 72, 68, 30, 42, 18)), "sample_size_check.csv")

# 3. Identical, class-stratified parent-site splits for every model -----------
make_folds <- function(d, k, seed) {
  g <- d %>% distinct(site_name, y) %>% arrange(y, site_name)
  if (any(table(g$y) < k)) stop("Too few independent sites per class for ", k, " folds.")
  set.seed(seed)
  g <- g %>% group_by(y) %>% mutate(fold = sample(rep(seq_len(k), length.out = n()))) %>% ungroup()
  map(seq_len(k), function(f) {
    assessment <- which(d$site_name %in% g$site_name[g$fold == f])
    analysis <- setdiff(seq_len(nrow(d)), assessment)
    stopifnot(!length(intersect(d$site_name[analysis], d$site_name[assessment])))
    list(analysis = analysis, assessment = assessment)
  })
}
outer <- map(seq_len(cfg$repeats), ~make_folds(ref, cfg$outer_k, cfg$seed + .x))
inner <- map(seq_len(cfg$repeats), function(r) map(seq_len(cfg$outer_k), function(f) {
  make_folds(ref[outer[[r]][[f]]$analysis, ], cfg$inner_k, cfg$seed + 1000L + 100L * r + f)
}))
final_folds <- make_folds(ref, cfg$inner_k, cfg$seed + 99999L)
saveRDS(list(config = cfg, source_md5 = tools::md5sum(cfg$input),
             reference_row_ids = ref$.source_row, outer = outer, inner = inner,
             final_folds = final_folds), out("split_plan_and_config.rds"))
save_csv(map_dfr(seq_len(cfg$repeats), function(r) map_dfr(seq_len(cfg$outer_k), function(f) {
  ref[outer[[r]][[f]]$assessment, ] %>% select(.source_row, site_name, origin) %>% mutate(repeat_id = r, fold = f)
})), "outer_fold_assignments.csv")

# 4. Training-only preprocessing and ridge logistic regression --------------
prep_fit <- function(d, cols) {
  x <- as.matrix(d[cols])
  med <- apply(x, 2, function(z) if (all(is.na(z))) 0 else median(z, na.rm = TRUE))
  for (j in seq_along(cols)) x[is.na(x[, j]), j] <- med[[j]]
  mu <- colMeans(x); s <- apply(x, 2, sd)
  keep <- is.finite(s) & s > 1e-12
  list(cols = cols, median = med, center = mu, scale = s, keep = keep)
}
prep_apply <- function(d, pp) {
  x <- as.matrix(d[pp$cols])
  for (j in seq_along(pp$cols)) x[is.na(x[, j]), j] <- pp$median[[j]]
  x <- x[, pp$keep, drop = FALSE]
  if (ncol(x)) x <- sweep(sweep(x, 2, pp$center[pp$keep], "-"), 2, pp$scale[pp$keep], "/")
  x
}
pad <- function(x) {
  # glmnet requires at least two columns; a zero dummy has no predictive effect.
  if (ncol(x) == 1) x <- cbind(x, .zero_dummy = 0)
  x
}
fit_path <- function(d, cols) {
  pp <- prep_fit(d, cols); x <- prep_apply(d, pp)
  w <- length(d$y) / (2 * as.numeric(table(factor(d$y, levels = 0:1)))[d$y + 1])
  if (!ncol(x)) return(list(pp = pp, fit = NULL, intercept_p = weighted.mean(d$y, w)))
  fit <- glmnet(pad(x), d$y, family = "binomial", alpha = 0,
                lambda = cfg$lambdas, weights = w, standardize = FALSE)
  list(pp = pp, fit = fit, intercept_p = NULL)
}
predict_path <- function(object, d, lambda) {
  if (!nrow(d)) return(matrix(numeric(), nrow = 0, ncol = length(lambda)))
  if (is.null(object$fit)) return(matrix(object$intercept_p, nrow(d), length(lambda)))
  as.matrix(predict(object$fit, newx = pad(prep_apply(d, object$pp)), s = lambda, type = "response"))
}
auc <- function(y, p) {
  n1 <- sum(y == 1); n0 <- sum(y == 0)
  if (!n1 || !n0) stop("ROC-AUC requires both classes.")
  (sum(rank(p, ties.method = "average")[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0)
}
metrics <- function(y, p) tibble(
  balanced_accuracy = (mean(p[y == 1] >= 0.5) + mean(p[y == 0] < 0.5)) / 2,
  roc_auc = auc(y, p), brier = mean((p - y)^2))
tune_lambda <- function(d, cols, folds) {
  p <- matrix(NA_real_, nrow(d), length(cfg$lambdas))
  for (f in folds) {
    fit <- fit_path(d[f$analysis, ], cols)
    p[f$assessment, ] <- predict_path(fit, d[f$assessment, ], cfg$lambdas)
  }
  stopifnot(!anyNA(p))
  scores <- apply(p, 2, function(z) auc(d$y, z))
  best <- which.max(scores) # lambda grid is descending; exact ties favor shrinkage
  list(lambda = cfg$lambdas[[best]], table = tibble(lambda = cfg$lambdas, inner_auc = scores))
}

# 5. Repeated nested cross-validation ---------------------------------------
oof <- list(); tuning <- list(); counter <- 0L
for (r in seq_len(cfg$repeats)) {
  message("Outer repeat ", r, "/", cfg$repeats)
  for (f in seq_len(cfg$outer_k)) {
    split <- outer[[r]][[f]]; tr <- ref[split$analysis, ]; te <- ref[split$assessment, ]
    for (model in names(families)) {
      counter <- counter + 1L
      tuned <- tune_lambda(tr, families[[model]], inner[[r]][[f]])
      fit <- fit_path(tr, families[[model]])
      oof[[counter]] <- te %>% select(.source_row, site_name, origin, y) %>% mutate(
        repeat_id = r, fold = f, model = model, lambda = tuned$lambda,
        probability = as.numeric(predict_path(fit, te, tuned$lambda)))
      tuning[[counter]] <- tuned$table %>% mutate(repeat_id = r, fold = f, model = model)
    }
  }
}
oof <- bind_rows(oof)
stopifnot(nrow(oof) == nrow(ref) * cfg$repeats * length(families), !anyNA(oof$probability))
save_csv(oof, "whole_site_oof_predictions.csv")
save_csv(bind_rows(tuning), "inner_tuning_results.csv")
repeat_metrics <- oof %>% group_by(model, repeat_id) %>% group_modify(~metrics(.x$y, .x$probability)) %>% ungroup()
save_csv(repeat_metrics, "whole_site_metrics_by_repeat.csv")
performance <- repeat_metrics %>% group_by(model) %>%
  summarise(across(c(balanced_accuracy, roc_auc, brier), list(mean = mean, sd = sd)), .groups = "drop")
save_csv(performance, "whole_site_model_performance.csv")
# Secondary sensitivity: equal contribution of each parent, after averaging
# OOF probabilities for multiple whole-site records belonging to that parent.
site_metrics <- oof %>% group_by(model, repeat_id, site_name, y) %>%
  summarise(probability = mean(probability), .groups = "drop") %>%
  group_by(model, repeat_id) %>% group_modify(~metrics(.x$y, .x$probability)) %>% ungroup()
save_csv(site_metrics, "parent_site_metrics_by_repeat_sensitivity.csv")

# 6. Final fits and projection of Unknown / Unkown records -------------------
final_models <- list(); pred <- list(); final_tuning <- list()
for (model in names(families)) {
  tuned <- tune_lambda(ref, families[[model]], final_folds)
  fit <- fit_path(ref, families[[model]])
  final_models[[model]] <- list(model = fit, lambda = tuned$lambda, predictors = families[[model]])
  final_tuning[[model]] <- tuned$table %>% mutate(model = model, selected = lambda == tuned$lambda)
  pred[[model]] <- unknown %>% select(.source_row, site_name, taphonomic_context, C, E, represented_parts, empty_profile) %>%
    mutate(model = model, probability = as.numeric(predict_path(fit, unknown, tuned$lambda)))
}
saveRDS(final_models, out("final_models.rds"))
save_csv(bind_rows(final_tuning), "final_tuning_results.csv")
if (nrow(unknown)) {
  predictions <- bind_rows(pred) %>% pivot_wider(names_from = model, values_from = probability) %>%
    rowwise() %>% mutate(
      min_affinity = min(c_across(all_of(names(families)))),
      max_affinity = max(c_across(all_of(names(families)))),
      median_affinity = median(c_across(all_of(names(families)))),
      interpretation = case_when(
        min_affinity < 0.5 & max_affinity > 0.5 ~ "representation-sensitive",
        min_affinity > 0.5 & median_affinity >= cfg$robust_median ~ "robust funerary affinity",
        max_affinity < 0.5 & median_affinity <= 1 - cfg$robust_median ~ "robust non-funerary affinity",
        TRUE ~ "indeterminate")) %>% ungroup() %>% arrange(desc(Combined))
  save_csv(predictions, "whole_site_unknown_predictions.csv")
}

# 7. Classical statistics, with explicit unit-of-analysis sensitivity --------
# Row-based p-values assume independence. Multiple records per parent violate
# that assumption: treat row-based inference as exploratory. An additional
# parent-mean analysis below uses one observation per named reference site.
# Parent averaging is a sensitivity analysis, not an archaeological merging of
# conflicting assemblages. Inspect duplicate site identities before publishing.
classical <- function(d, tag) {
  desc <- d %>% select(origin, C, E) %>% pivot_longer(c(C, E), names_to = "variable") %>%
    group_by(origin, variable) %>% summarise(n = n(), median = median(value),
      q25 = quantile(value, .25), q75 = quantile(value, .75), .groups = "drop")
  save_csv(desc, paste0(tag, "_univariate_summary.csv"))
  tests <- map_dfr(c("C", "E"), function(v) {
    a <- d[[v]][d$y == 1]; b <- d[[v]][d$y == 0]
    w <- wilcox.test(a, b, exact = FALSE, correct = TRUE)
    tibble(variable = v, p_value = w$p.value,
           cliffs_delta = mean(sign(outer(a, b, "-"))))
  })
  save_csv(tests, paste0(tag, "_univariate_tests.csv"))
  if (sd(d$C) > 0 && sd(d$E) > 0) {
    d <- d %>% mutate(C_z = as.numeric(scale(C)), E_z = as.numeric(scale(E)))
    m0 <- glm(y ~ C_z, d, family = binomial())
    m1 <- glm(y ~ C_z + E_z, d, family = binomial())
    save_csv(broom::tidy(m1) %>% mutate(odds_ratio = exp(estimate)), paste0(tag, "_logistic_coefficients.csv"))
    write_lines(capture.output(anova(m0, m1, test = "LRT")), out(paste0(tag, "_logistic_LR_test.txt")))
  }
}
classical(ref, "whole_site_exploratory")
parent <- ref %>% group_by(site_name, origin, y) %>%
  summarise(across(all_of(c(spr, "C", "E")), mean), .groups = "drop")
classical(parent, "parent_mean_sensitivity")

# 8. PCA; Hotelling; PERMANOVA and PERMDISP ----------------------------------
# PCA uses reference rows only, all nonconstant standardized absolute features.
# PCA signs are arbitrary; orient PC1 positively with C for easy comparison.
# The usual Hotelling centroid ellipse assumes independent observations and
# approximate multivariate normality. It is not a coverage/classification ellipse.
# To expose duplicate-parent sensitivity, run the whole section twice.
multivariate <- function(d, tag) {
  x <- as.matrix(d[spr]); keep <- apply(x, 2, sd) > 1e-12
  if (sum(keep) < 2) stop("PCA needs at least two variable SPR columns.")
  z <- scale(x[, keep, drop = FALSE]); pc <- prcomp(z, center = FALSE, scale. = FALSE)
  if (cor(pc$x[, 1], d$C) < 0) {
    pc$x[, 1] <- -pc$x[, 1]; pc$rotation[, 1] <- -pc$rotation[, 1]
  }
  variance <- pc$sdev^2 / sum(pc$sdev^2)
  scores <- bind_cols(d %>% select(any_of(c(".source_row", "site_name", "origin", "C"))), as_tibble(pc$x))
  save_csv(scores, paste0(tag, "_pca_scores.csv"))
  save_csv(as.data.frame(pc$rotation) %>% rownames_to_column("predictor"), paste0(tag, "_pca_loadings.csv"))
  save_csv(tibble(PC = seq_along(variance), variance_fraction = variance), paste0(tag, "_pca_variance.csv"))
  save_csv(tibble(PC1_C_correlation = cor(pc$x[, 1], d$C)), paste0(tag, "_pca_abundance_correlation.csv"))
  ellipses <- scores %>% group_by(origin) %>% group_modify(function(.x, .y) {
    v <- as.matrix(.x[c("PC1", "PC2")]); n <- nrow(v); p <- 2
    S <- cov(v)
    if (n <= p || qr(S)$rank < p) return(tibble(PC1 = numeric(), PC2 = numeric()))
    theta <- seq(0, 2 * pi, length.out = 201)
    multiplier <- p * (n - 1) / (n * (n - p)) * qf(.95, p, n - p)
    coords <- cbind(cos(theta), sin(theta)) %*% chol(S * multiplier)
    as_tibble(sweep(coords, 2, colMeans(v), "+"), .name_repair = ~c("PC1", "PC2"))
  }) %>% ungroup()
  fig <- ggplot(scores, aes(PC1, PC2, color = origin)) +
    geom_point(size = 2, alpha = .8) +
    geom_path(data = ellipses, aes(group = origin), linewidth = .8) +
    labs(x = sprintf("PC1 (%.1f%%)", 100 * variance[1]),
         y = sprintf("PC2 (%.1f%%)", 100 * variance[2]), color = "Reference context",
         subtitle = paste(tag, "| 95% centroid confidence ellipses; independence assumed")) +
    theme_minimal(base_size = 11)
  ggsave(out(paste0(tag, "_pca_2d.png")), fig, width = 9, height = 6, dpi = 300)
  a <- pc$x[d$y == 1, 1:2, drop = FALSE]; b <- pc$x[d$y == 0, 1:2, drop = FALSE]
  n1 <- nrow(a); n0 <- nrow(b); N <- n1 + n0; p <- 2
  S <- ((n1 - 1) * cov(a) + (n0 - 1) * cov(b)) / (N - 2)
  if (qr(S)$rank == 2) {
    delta <- colMeans(a) - colMeans(b)
    T2 <- as.numeric(n1 * n0 / N * t(delta) %*% solve(S, delta))
    Fval <- (N - p - 1) / (p * (N - 2)) * T2
    save_csv(tibble(T2 = T2, F = Fval, df1 = p, df2 = N - p - 1,
                    p_value = pf(Fval, p, N - p - 1, lower.tail = FALSE)), paste0(tag, "_hotelling.csv"))
  }
  set.seed(cfg$seed)
  perma <- vegan::adonis2(z ~ origin, data = d, method = "euclidean", permutations = 9999)
  dispersion <- vegan::betadisper(dist(z), factor(d$origin), type = "centroid", bias.adjust = FALSE)
  set.seed(cfg$seed)
  disp_test <- vegan::permutest(dispersion, permutations = 9999)
  write_lines(capture.output(perma), out(paste0(tag, "_permanova.txt")))
  write_lines(capture.output(disp_test), out(paste0(tag, "_permdisp.txt")))
  save_csv(tibble(origin = d$origin, distance = dispersion$distances) %>% group_by(origin) %>%
             summarise(mean_distance = mean(distance), .groups = "drop"), paste0(tag, "_dispersion_means.csv"))
  saveRDS(pc, out(paste0(tag, "_pca_model.rds")))
}
if (nrow(ref) > n_distinct(ref$site_name)) {
  warning("Duplicate parents: whole_site_exploratory classical tests, permutations and ellipses assume row independence. Consult parent_mean_sensitivity results.")
}
multivariate(ref, "whole_site_exploratory")
multivariate(parent, "parent_mean_sensitivity")
write_lines(capture.output(sessionInfo()), out("sessionInfo.txt"))
print(performance)
message("Done. Outputs: ", normalizePath(cfg$out))
