# Recovery / excavation bias
*Automated discovery_context × skeletal-part representation*

- **Grouping column:** `discovery_context` (mode = alternative)
- **Groups (n):** Formal excavation = 77; Casual = 14; Quarry = 4
- **Sites analysed:** 95  |  **features screened:** 63

## Hypothesis

**H:** Recovery method affects which bones enter the dataset.

**Expected pattern:** Formal/complete excavations recover more small bones; quarry/casual discoveries over-represent large, visible, diagnostic elements.

**Why it matters:** Essential bias-control analysis; may explain patterns that otherwise look biological or cultural.


## Summary

0 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **distal_appendicular_continuity_hm** (ε² = 0.101, FDR p = 0.1521). PERMANOVA pseudo-F = 0.79, p = 0.5390; PC1–PC3 explain 74.3% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 126 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 3 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|distal_appendicular_continuity_hm            |  0.101|   0.152|moderate   |n.s.   |
|mnau_hands                                   |  0.094|   0.152|moderate   |n.s.   |
|mnau_distal_appendicular_mean                |  0.074|   0.173|moderate   |n.s.   |
|ProportionalRep_MNIbased_fibula              |  0.069|   0.173|moderate   |n.s.   |
|ProportionalRep_MNIbased_carpal              |  0.068|   0.173|moderate   |n.s.   |
|mne_arms                                     |  0.066|   0.173|moderate   |n.s.   |
|ReMNAU_radius                                |  0.064|   0.173|moderate   |n.s.   |
|ProportionalRep_MNIbased_metacarpal          |  0.053|   0.236|small      |n.s.   |
|mnau_foot                                    |  0.048|   0.236|small      |n.s.   |
|effective_sections_hill1                     |  0.045|   0.236|small      |n.s.   |
|mnau_heip_evenness                           |  0.045|   0.236|small      |n.s.   |
|mnau_gini                                    |  0.044|   0.236|small      |n.s.   |
|mnau_arms_legs_logratio                      |  0.042|   0.236|small      |n.s.   |
|mnau_arms_to_legs_ratio                      |  0.042|   0.236|small      |n.s.   |
|mne_arms_to_legs_ratio                       |  0.040|   0.236|small      |n.s.   |
|ProportionalRep_MNIbased_radius              |  0.039|   0.236|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.038|   0.236|small      |n.s.   |
|mnau_arms                                    |  0.035|   0.236|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.033|   0.236|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.033|   0.236|small      |n.s.   |
|mnau_evenness_minus_dominance                |  0.032|   0.236|small      |n.s.   |
|mnau_arms_legs_diff                          |  0.031|   0.236|small      |n.s.   |
|ProportionalRep_MNIbased_humerus             |  0.030|   0.236|small      |n.s.   |
|mnau_inverse_simpson                         |  0.029|   0.236|small      |n.s.   |
|mnau_simpson_evenness                        |  0.029|   0.236|small      |n.s.   |
|mnau_simpson_dominance                       |  0.029|   0.236|small      |n.s.   |
|density_evenness                             |  0.026|   0.261|small      |n.s.   |
|mnau_cv                                      |  0.025|   0.263|small      |n.s.   |
|ReMNAU_cervical                              |  0.024|   0.263|small      |n.s.   |
|all_sections_dominance                       |  0.023|   0.269|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.022|   0.270|small      |n.s.   |
|low_density_axial_survival                   |  0.019|   0.294|small      |n.s.   |
|ProportionalRep_MNIbased_cervical            |  0.019|   0.294|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.017|   0.294|small      |n.s.   |
|mnau_limb_shaft_proxy_mean                   |  0.017|   0.294|small      |n.s.   |
|mnau_axial_main_mean                         |  0.017|   0.294|small      |n.s.   |
|mnau_appendicular_mean                       |  0.014|   0.318|small      |n.s.   |
|mnau_legs                                    |  0.013|   0.318|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.013|   0.318|small      |n.s.   |
|ProportionalRep_MNIbased_tibia               |  0.013|   0.318|small      |n.s.   |
|mne_cranial_share                            |  0.011|   0.340|small      |n.s.   |
|mnau_lower_appendicular_mean                 |  0.009|   0.366|negligible |n.s.   |
|ReMNAU_ulna                                  |  0.008|   0.372|negligible |n.s.   |
|dominance_gap_all                            |  0.007|   0.377|negligible |n.s.   |
|postcranial_dominance_refined                |  0.005|   0.417|negligible |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.003|   0.431|negligible |n.s.   |
|appendicular_dominance                       |  0.002|   0.431|negligible |n.s.   |
|appendicular_dominance_refined               |  0.002|   0.431|negligible |n.s.   |
|low_density_survival_index                   |  0.002|   0.431|negligible |n.s.   |
|mnau_proximal_appendicular_mean              |  0.000|   0.456|negligible |n.s.   |
|dominant_axial_share                         |  0.000|   0.456|negligible |n.s.   |
|mne_vertebrae_to_thorax_ratio                |  0.000|   0.456|negligible |n.s.   |
|mnau_column_trunk_mean                       | -0.004|   0.534|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast | -0.007|   0.576|negligible |n.s.   |
|lower_appendicular_evenness                  | -0.008|   0.576|negligible |n.s.   |
|lower_appendicular_evenness_refined          | -0.008|   0.576|negligible |n.s.   |
|mnau_shoulder                                | -0.008|   0.596|negligible |n.s.   |
|low_density_share                            | -0.010|   0.631|negligible |n.s.   |
|mnau_girdle_mean                             | -0.012|   0.693|negligible |n.s.   |
|mnau_pelvic                                  | -0.013|   0.711|negligible |n.s.   |
|ProportionalRep_MNIbased_clavicle            | -0.014|   0.725|negligible |n.s.   |
|ProportionalRep_MNIbased_os_coxae            | -0.016|   0.774|negligible |n.s.   |
|ProportionalRep_MNIbased_femur               | -0.018|   0.842|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 0.79, R² = 0.019, p = 0.5390.
PCA variance explained: PC1 58.8%, PC2 8.1%, PC3 7.4% (cumulative 74.3%).
Dispersion caveat (PERMDISP): p = 0.677.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.158| -0.129| -0.052|
|mnau_top2_share_mcnaughton  |  0.158| -0.116| -0.054|
|mnau_appendicular_mean      | -0.157| -0.137| -0.027|
|mnau_cv                     |  0.156| -0.138| -0.051|
|mnau_heip_evenness          | -0.156|  0.115|  0.055|
|effective_sections_hill1    | -0.156|  0.115|  0.055|
|mnau_gini                   |  0.156| -0.103| -0.059|
|mnau_inverse_simpson        | -0.155|  0.078|  0.057|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
