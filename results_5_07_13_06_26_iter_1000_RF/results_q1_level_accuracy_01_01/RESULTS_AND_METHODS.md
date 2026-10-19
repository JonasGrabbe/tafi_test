# Skeletal detail levels and classification performance

## Research question

Across 1,000 randomly sampled skeletal-section level vectors per task, does increasing total representational detail change out-of-sample classification performance, and which anatomical sections show independent dose-response effects after controlling for the detail levels assigned to all other sections? The analysis also asks whether effects are linear or nonlinear, task-specific, and large enough to be practically relevant rather than only statistically detectable.

## Primary statistical strategy

1. **Data integrity:** sample size and vector uniqueness are recorded for each task; duplicates are rejected. The expected design size is 1000.
2. **Whole-vector effect:** ordinary least squares estimates the interpretable change in performance per one-unit increase in total detail. HC3 heteroskedasticity-robust confidence intervals are primary; Spearman correlation and a REML-fitted GAM are sensitivity checks for monotonic and nonlinear structure.
3. **Section effects:** all varying sections enter one factor-based multivariable model. Type-II HC3 tests assess each section globally; adjusted level contrasts compare each level with that section's lowest observed level. Benjamini-Hochberg FDR controls multiplicity. Total detail is deliberately excluded from this model because it is the exact sum of the section predictors and would cause deterministic collinearity.
4. **Effect emphasis:** adjusted R-squared, GAM deviance explained, partial eta-squared, estimated changes and 95% CIs are reported alongside p/q values.

## Results by task

### 4class

- **Sample:** 1000 unique vectors.
- **Total-detail trend:** slope = -0.00244 per level (HC3 95% CI -0.00286 to -0.00202; p = 6.626e-28; BH q = 9.939e-28). A five-level increase corresponds to -0.0122 points of performance. Adjusted R-squared = 0.103; Spearman rho = -0.320; GAM edf = 2.90 and deviance explained = 10.9%.

- **Adjusted section tests:** 8 of 9 varying sections remained significant after BH-FDR: Arm, Foot, Leg, Pelvis, Cranium, Thorax, Shoulder, Hand.

- **Largest global section effect:** Arm, partial eta-squared = 0.2461, q = 1.89e-59.

- **Largest adjusted level contrast:** Foot level 5 versus level 1, delta = -0.0258 (95% CI -0.0293 to -0.0223; q = 1.2e-41).


### cannibalism_vs_fc

- **Sample:** 1000 unique vectors.
- **Total-detail trend:** slope = -0.00141 per level (HC3 95% CI -0.00174 to -0.00109; p = 5.624e-17; BH q = 5.624e-17). A five-level increase corresponds to -0.0071 points of performance. Adjusted R-squared = 0.072; Spearman rho = -0.306; GAM edf = 3.36 and deviance explained = 8.3%.

- **Adjusted section tests:** 6 of 9 varying sections remained significant after BH-FDR: Arm, Hand, Foot, Leg, Pelvis, Vertebrae.

- **Largest global section effect:** Arm, partial eta-squared = 0.2936, q = 3.366e-73.

- **Largest adjusted level contrast:** Arm level 3 versus level 1, delta = -0.0194 (95% CI -0.0214 to -0.0174; q = 3.474e-68).


### fc_vs_rest

- **Sample:** 1000 unique vectors.
- **Total-detail trend:** slope = -0.00300 per level (HC3 95% CI -0.00326 to -0.00274; p = 5.308e-92; BH q = 1.592e-91). A five-level increase corresponds to -0.0150 points of performance. Adjusted R-squared = 0.298; Spearman rho = -0.535; GAM edf = 1.00 and deviance explained = 29.9%.

- **Adjusted section tests:** 9 of 9 varying sections remained significant after BH-FDR: Foot, Vertebrae, Pelvis, Thorax, Leg, Hand, Shoulder, Arm, Cranium.

- **Largest global section effect:** Foot, partial eta-squared = 0.4401, q = 5.327e-120.

- **Largest adjusted level contrast:** Foot level 5 versus level 1, delta = -0.0231 (95% CI -0.0253 to -0.0209; q = 4.172e-77).


## Essential limitation for a high-tier paper

These 1,000 rows are summary cross-validation scores calculated from repeated reuse of the same underlying assemblages. They are therefore not 1,000 independent biological observations. The present analysis rigorously characterizes the sampled level-vector design space, but conventional standard errors cannot represent all uncertainty created by cross-validation and hyperparameter selection. The strongest confirmatory design is to save performance for every outer repeat/fold and level vector, use identical outer splits across vectors, perform tuning only inside each outer training split, and analyse the fold-level outcomes with a paired mixed-effects model (random intercepts for outer repeat/fold). An untouched external test set is preferable when available.

## Recommended interpretation rule

Treat a result as substantively convincing only when the direction is stable across the linear, rank-based and GAM summaries; the adjusted effect and its 95% CI are meaningful on the performance scale; multiplicity-controlled q < 0.05; and the pattern persists in outer-fold or external-test sensitivity analyses. Do not infer that greater anatomical resolution is universally beneficial merely from an unadjusted mean or a visually dense parallel-coordinate plot.

