# Imputation burden and classification performance

## Design

Natural resolution was defined using the site-specific `calc_level = "min"` vectors from the observed-only natural-level analysis. 
Only genuinely observed site-section cells were used; absent sections were ignored rather than interpreted from stored default levels. 
For every tested classification vector, a site-section was classified as exposed to upward reconstruction when its requested target level exceeded that site's natural-min level.

## Dataset

- Sites: 152

- Observed site-section cells: 930

- Tested level vectors: 1000

- Mean imputed-cell fraction across vectors: 5.26%

- Median imputed-cell fraction: 5.81%

- Maximum imputed-cell fraction: 11.29%

- Mean fraction of sites requiring any upward reconstruction: 26.18%


## Primary model

`performance ~ factor(sum_level) + imputed_cell_fraction`


Because total detail is entered as a factor, the imputation coefficient is estimated from comparisons among vectors with exactly the same total level sum. It therefore asks whether redistributing a fixed amount of anatomical detail into sections that exceed site-specific natural-min resolution is associated with additional performance change. Total-detail strata represented by only one tested vector are excluded from this HC3 model because HC3 variance is undefined when leverage equals 1. The linear-total-detail model retains all 1,000 vectors.

- **4class — Accuracy:** +10 percentage points of imputed site-section cells = -0.0017 performance points (95% CI -0.0072 to +0.0037; p = 0.5381; BH-FDR q = 0.5381).

- **4class — Macro-F1:** +10 percentage points of imputed site-section cells = -0.0050 performance points (95% CI -0.0114 to +0.0015; p = 0.1291; BH-FDR q = 0.1452).

- **4class — Balanced accuracy:** +10 percentage points of imputed site-section cells = -0.0060 performance points (95% CI -0.0125 to +0.0006; p = 0.07391; BH-FDR q = 0.09502).

- **cannibalism_vs_fc — Accuracy:** +10 percentage points of imputed site-section cells = +0.0046 performance points (95% CI +0.0008 to +0.0084; p = 0.01868; BH-FDR q = 0.03362).

- **cannibalism_vs_fc — Macro-F1:** +10 percentage points of imputed site-section cells = -0.0069 performance points (95% CI -0.0136 to -0.0002; p = 0.04439; BH-FDR q = 0.06659).

- **cannibalism_vs_fc — Balanced accuracy:** +10 percentage points of imputed site-section cells = -0.0338 performance points (95% CI -0.0455 to -0.0221; p = 1.578e-08; BH-FDR q = 1.42e-07).

- **fc_vs_rest — Accuracy:** +10 percentage points of imputed site-section cells = -0.0080 performance points (95% CI -0.0115 to -0.0045; p = 8.593e-06; BH-FDR q = 2.578e-05).

- **fc_vs_rest — Macro-F1:** +10 percentage points of imputed site-section cells = -0.0092 performance points (95% CI -0.0131 to -0.0052; p = 5.169e-06; BH-FDR q = 2.326e-05).

- **fc_vs_rest — Balanced accuracy:** +10 percentage points of imputed site-section cells = -0.0131 performance points (95% CI -0.0190 to -0.0072; p = 1.375e-05; BH-FDR q = 3.093e-05).


## Interpretation boundary

This analysis quantifies structural exposure to upward reconstruction, not the realized count-level reconstruction error. A site-section is counted as exposed whenever target level > natural-min level. The next causal-style experiment should use genuinely fine-resolution sites, collapse them to a coarser level, reconstruct them back upward, and compare reconstructed values and classification performance with the original fine data.


## Statistical limitation

The 1,000 level-vector rows per task reuse the same underlying assemblages through cross-validation and therefore are not 1,000 independent biological observations. HC3 inference is useful for mapping the sampled level-vector design space but should be treated as exploratory. The confirmatory design should retain outer-fold performance for every level vector using identical outer splits and analyse paired fold-level outcomes with mixed-effects models.

