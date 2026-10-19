# Recovery / excavation bias
*Automated discovery_context × skeletal-part representation*

- **Grouping column:** `discovery_context` (mode = alternative)
- **Groups (n):** Formal excavation = 77; Casual = 14; Quarry = 4
- **Sites analysed:** 95  |  **features screened:** 50

## Hypothesis

**H:** Recovery method affects which bones enter the dataset.

**Expected pattern:** Formal/complete excavations recover more small bones; quarry/casual discoveries over-represent large, visible, diagnostic elements.

**Why it matters:** Essential bias-control analysis; may explain patterns that otherwise look biological or cultural.


## Summary

0 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **distal_appendicular_continuity_hm** (ε² = 0.101, FDR p = 0.1054). PERMANOVA pseudo-F = 0.88, p = 0.4605; PC1–PC3 explain 76.3% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 98 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 3 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|distal_appendicular_continuity_hm            |  0.101|   0.105|moderate   |n.s.   |
|mnau_hands                                   |  0.095|   0.105|moderate   |n.s.   |
|mnau_distal_appendicular_mean                |  0.075|   0.105|moderate   |n.s.   |
|mne_arms                                     |  0.066|   0.105|moderate   |n.s.   |
|mnau_gini                                    |  0.066|   0.105|moderate   |n.s.   |
|mnau_evenness_minus_dominance                |  0.059|   0.105|small      |n.s.   |
|mnau_inverse_simpson                         |  0.059|   0.105|small      |n.s.   |
|mnau_simpson_dominance                       |  0.059|   0.105|small      |n.s.   |
|mnau_simpson_evenness                        |  0.059|   0.105|small      |n.s.   |
|effective_sections_hill1                     |  0.059|   0.105|small      |n.s.   |
|mnau_heip_evenness                           |  0.059|   0.105|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.058|   0.105|small      |n.s.   |
|mnau_cv                                      |  0.056|   0.107|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.055|   0.107|small      |n.s.   |
|all_sections_dominance                       |  0.053|   0.109|small      |n.s.   |
|mnau_foot                                    |  0.048|   0.124|small      |n.s.   |
|mnau_arms_legs_logratio                      |  0.042|   0.148|small      |n.s.   |
|mnau_arms_to_legs_ratio                      |  0.042|   0.148|small      |n.s.   |
|mne_arms_to_legs_ratio                       |  0.040|   0.148|small      |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.040|   0.148|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.038|   0.152|small      |n.s.   |
|density_evenness                             |  0.037|   0.153|small      |n.s.   |
|dominance_gap_all                            |  0.035|   0.153|small      |n.s.   |
|mnau_arms                                    |  0.035|   0.153|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.029|   0.188|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.029|   0.188|small      |n.s.   |
|mnau_arms_legs_diff                          |  0.028|   0.189|small      |n.s.   |
|appendicular_dominance                       |  0.027|   0.205|small      |n.s.   |
|appendicular_dominance_refined               |  0.027|   0.205|small      |n.s.   |
|low_density_axial_survival                   |  0.018|   0.263|small      |n.s.   |
|mnau_axial_main_mean                         |  0.018|   0.263|small      |n.s.   |
|postcranial_dominance_refined                |  0.015|   0.294|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.014|   0.294|small      |n.s.   |
|mnau_legs                                    |  0.013|   0.294|small      |n.s.   |
|mnau_appendicular_mean                       |  0.012|   0.301|small      |n.s.   |
|mne_cranial_share                            |  0.011|   0.307|small      |n.s.   |
|mnau_limb_shaft_proxy_mean                   |  0.010|   0.307|small      |n.s.   |
|low_density_share                            |  0.007|   0.349|negligible |n.s.   |
|low_density_survival_index                   |  0.005|   0.374|negligible |n.s.   |
|mnau_lower_appendicular_mean                 |  0.005|   0.374|negligible |n.s.   |
|lower_appendicular_evenness                  |  0.003|   0.376|negligible |n.s.   |
|lower_appendicular_evenness_refined          |  0.003|   0.376|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast |  0.003|   0.376|negligible |n.s.   |
|dominant_axial_share                         |  0.000|   0.410|negligible |n.s.   |
|mne_vertebrae_to_thorax_ratio                |  0.000|   0.418|negligible |n.s.   |
|mnau_column_trunk_mean                       | -0.006|   0.527|negligible |n.s.   |
|mnau_proximal_appendicular_mean              | -0.006|   0.527|negligible |n.s.   |
|mnau_shoulder                                | -0.008|   0.561|negligible |n.s.   |
|mnau_girdle_mean                             | -0.013|   0.684|negligible |n.s.   |
|mnau_pelvic                                  | -0.015|   0.731|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 0.88, R² = 0.021, p = 0.4605.
PCA variance explained: PC1 61.2%, PC2 8.7%, PC3 6.4% (cumulative 76.3%).
Dispersion caveat (PERMDISP): p = 0.887.

Top PC1 loadings:

|Feature                    |    PC1|    PC2|    PC3|
|:--------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton |  0.177|  0.106| -0.013|
|mnau_inverse_simpson       | -0.175| -0.082| -0.005|
|mnau_simpson_evenness      | -0.175| -0.082| -0.005|
|mnau_gini                  |  0.175|  0.112| -0.011|
|all_sections_dominance     |  0.175|  0.100| -0.067|
|mnau_cv                    |  0.175|  0.124| -0.069|
|effective_sections_hill1   | -0.175| -0.114|  0.028|
|mnau_heip_evenness         | -0.175| -0.114|  0.028|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
