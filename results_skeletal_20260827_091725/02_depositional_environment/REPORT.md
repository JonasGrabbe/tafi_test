# Depositional environment
*Automated karstic_system × skeletal-part representation*

- **Grouping column:** `karstic_system` (mode = alternative)
- **Groups (n):** Cave = 105; Rockshelter = 17
- **Sites analysed:** 122  |  **features screened:** 50

## Hypothesis

**H:** Depositional environment filters the skeleton before excavation.

**Expected pattern:** Cave interiors preserve more small elements; entrances/rockshelters show carnivore activity; fluvial deposits favour dense/large elements.

**Why it matters:** Tests whether site formation, not culture or species, explains anatomical differences.


## Summary

0 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_limb_shaft_proxy_mean** (ε² = 0.049, FDR p = 0.09667). PERMANOVA pseudo-F = 2.18, p = 0.0882; PC1–PC3 explain 74.0% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 91 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 12 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|mnau_limb_shaft_proxy_mean                   |  0.049|  0.0967|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.047|  0.0967|small      |n.s.   |
|mnau_legs                                    |  0.044|  0.0967|small      |n.s.   |
|mnau_arms                                    |  0.044|  0.0967|small      |n.s.   |
|mnau_proximal_appendicular_mean              |  0.044|  0.0967|small      |n.s.   |
|mnau_appendicular_mean                       |  0.041|  0.0967|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.041|  0.0967|small      |n.s.   |
|mnau_lower_appendicular_mean                 |  0.039|  0.0967|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.039|  0.0967|small      |n.s.   |
|mnau_arms_legs_diff                          |  0.033|  0.1320|small      |n.s.   |
|all_sections_dominance                       |  0.029|  0.1370|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.025|  0.1370|small      |n.s.   |
|mnau_inverse_simpson                         |  0.024|  0.1370|small      |n.s.   |
|mnau_simpson_dominance                       |  0.024|  0.1370|small      |n.s.   |
|mnau_simpson_evenness                        |  0.024|  0.1370|small      |n.s.   |
|mnau_cv                                      |  0.022|  0.1370|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.022|  0.1370|small      |n.s.   |
|mnau_column_trunk_mean                       |  0.022|  0.1370|small      |n.s.   |
|mnau_girdle_mean                             |  0.021|  0.1370|small      |n.s.   |
|mnau_evenness_minus_dominance                |  0.021|  0.1370|small      |n.s.   |
|mnau_gini                                    |  0.020|  0.1370|small      |n.s.   |
|mnau_distal_appendicular_mean                |  0.019|  0.1370|small      |n.s.   |
|dominant_axial_share                         |  0.019|  0.1370|small      |n.s.   |
|effective_sections_hill1                     |  0.019|  0.1370|small      |n.s.   |
|mnau_heip_evenness                           |  0.019|  0.1370|small      |n.s.   |
|mnau_pelvic                                  |  0.018|  0.1370|small      |n.s.   |
|mnau_shoulder                                |  0.018|  0.1370|small      |n.s.   |
|dominance_gap_all                            |  0.018|  0.1370|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.017|  0.1370|small      |n.s.   |
|density_evenness                             |  0.016|  0.1530|small      |n.s.   |
|low_density_survival_index                   |  0.015|  0.1550|small      |n.s.   |
|mne_vertebrae_to_thorax_ratio                |  0.013|  0.1690|small      |n.s.   |
|low_density_axial_survival                   |  0.012|  0.1770|small      |n.s.   |
|mnau_hands                                   |  0.011|  0.1840|small      |n.s.   |
|mne_cranial_share                            |  0.011|  0.1860|small      |n.s.   |
|mne_arms                                     |  0.009|  0.2050|negligible |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.009|  0.2050|negligible |n.s.   |
|mnau_axial_main_mean                         |  0.007|  0.2320|negligible |n.s.   |
|distal_appendicular_continuity_hm            |  0.007|  0.2320|negligible |n.s.   |
|postcranial_dominance_refined                |  0.006|  0.2450|negligible |n.s.   |
|mnau_foot                                    |  0.005|  0.2450|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast |  0.005|  0.2500|negligible |n.s.   |
|appendicular_dominance                       |  0.002|  0.3050|negligible |n.s.   |
|appendicular_dominance_refined               |  0.002|  0.3050|negligible |n.s.   |
|low_density_share                            | -0.001|  0.3980|negligible |n.s.   |
|mnau_arms_legs_logratio                      | -0.004|  0.4900|negligible |n.s.   |
|mnau_arms_to_legs_ratio                      | -0.004|  0.4900|negligible |n.s.   |
|lower_appendicular_evenness                  | -0.007|  0.6130|negligible |n.s.   |
|lower_appendicular_evenness_refined          | -0.007|  0.6130|negligible |n.s.   |
|mne_arms_to_legs_ratio                       | -0.007|  0.7410|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.18, R² = 0.021, p = 0.0882.
PCA variance explained: PC1 59.0%, PC2 8.7%, PC3 6.3% (cumulative 74.0%).
Dispersion caveat (PERMDISP): p = 0.040 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton    |  0.179|  0.114| -0.027|
|mnau_gini                     |  0.178|  0.116| -0.038|
|mnau_inverse_simpson          | -0.178| -0.087|  0.037|
|mnau_simpson_evenness         | -0.178| -0.087|  0.037|
|effective_sections_hill1      | -0.178| -0.126|  0.030|
|mnau_heip_evenness            | -0.178| -0.126|  0.030|
|mnau_cv                       |  0.176|  0.155| -0.002|
|mnau_evenness_minus_dominance | -0.175| -0.157| -0.001|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
