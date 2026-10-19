# Time depth / attrition
*Automated geological_period × skeletal-part representation*

- **Grouping column:** `geological_period` (mode = alternative)
- **Groups (n):** Late Pleistocene = 86; Holocene = 48; Middle Pleistocene = 14
- **Sites analysed:** 148  |  **features screened:** 63

## Hypothesis

**H:** Older assemblages are more altered by long-term attrition and recovery bias.

**Expected pattern:** Earlier Pleistocene contexts lose fragile elements and over-represent teeth, cranial pieces, dense shafts; Holocene burials more complete.

**Why it matters:** Tests time-depth and preservation intensity (must be read alongside context).


## Summary

17 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.102, FDR p = 0.01462). PERMANOVA pseudo-F = 1.67, p = 0.1150; PC1–PC3 explain 71.7% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 174 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 34 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.102|  0.0146|moderate   |significant |
|density_evenness                             |  0.085|  0.0270|moderate   |significant |
|low_density_share                            |  0.070|  0.0406|moderate   |significant |
|low_density_axial_survival                   |  0.067|  0.0406|moderate   |significant |
|mnau_axial_main_mean                         |  0.062|  0.0406|moderate   |significant |
|effective_sections_hill1                     |  0.060|  0.0406|small      |significant |
|mnau_heip_evenness                           |  0.060|  0.0406|small      |significant |
|dominance_gap_all                            |  0.059|  0.0406|small      |significant |
|mnau_evenness_minus_dominance                |  0.054|  0.0406|small      |significant |
|mnau_top2_share_mcnaughton                   |  0.054|  0.0406|small      |significant |
|all_sections_dominance                       |  0.053|  0.0406|small      |significant |
|mnau_gini                                    |  0.052|  0.0406|small      |significant |
|mnau_inverse_simpson                         |  0.050|  0.0406|small      |significant |
|mnau_simpson_dominance                       |  0.050|  0.0406|small      |significant |
|mnau_simpson_evenness                        |  0.050|  0.0406|small      |significant |
|distal_appendicular_continuity_hm            |  0.049|  0.0406|small      |significant |
|mnau_cv                                      |  0.049|  0.0419|small      |significant |
|mnau_region_mean_evenness                    |  0.042|  0.0637|small      |n.s.        |
|mnau_distal_appendicular_mean                |  0.038|  0.0759|small      |n.s.        |
|mnau_column_trunk_mean                       |  0.037|  0.0772|small      |n.s.        |
|mnau_dominance_of_region_means               |  0.037|  0.0810|small      |n.s.        |
|low_density_survival_index                   |  0.035|  0.0816|small      |n.s.        |
|mnau_foot                                    |  0.035|  0.0816|small      |n.s.        |
|ProportionalRep_MNIbased_humerus             |  0.034|  0.0827|small      |n.s.        |
|lower_appendicular_continuity_hm             |  0.031|  0.0963|small      |n.s.        |
|mnau_postcranial_total_mean                  |  0.029|  0.1090|small      |n.s.        |
|mnau_lower_appendicular_mean                 |  0.028|  0.1090|small      |n.s.        |
|mne_cranial_share                            |  0.028|  0.1100|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.025|  0.1260|small      |n.s.        |
|dominant_axial_share                         |  0.023|  0.1470|small      |n.s.        |
|mnau_arms                                    |  0.022|  0.1470|small      |n.s.        |
|mnau_appendicular_mean                       |  0.022|  0.1470|small      |n.s.        |
|mnau_hands                                   |  0.022|  0.1470|small      |n.s.        |
|ReMNAU_cervical                              |  0.020|  0.1570|small      |n.s.        |
|ProportionalRep_MNIbased_metacarpal          |  0.020|  0.1570|small      |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.018|  0.1740|small      |n.s.        |
|mnau_legs                                    |  0.017|  0.1770|small      |n.s.        |
|mnau_proximal_appendicular_mean              |  0.016|  0.1860|small      |n.s.        |
|mnau_upper_appendicular_mean                 |  0.015|  0.2070|small      |n.s.        |
|ProportionalRep_MNIbased_fibula              |  0.013|  0.2350|small      |n.s.        |
|ProportionalRep_MNIbased_cervical            |  0.010|  0.2770|negligible |n.s.        |
|ProportionalRep_MNIbased_femur               |  0.003|  0.4470|negligible |n.s.        |
|mnau_pelvic                                  |  0.003|  0.4470|negligible |n.s.        |
|mnau_girdle_mean                             |  0.001|  0.4840|negligible |n.s.        |
|ReMNAU_ulna                                  |  0.001|  0.4840|negligible |n.s.        |
|ProportionalRep_MNIbased_os_coxae            | -0.002|  0.6030|negligible |n.s.        |
|ProportionalRep_MNIbased_radius              | -0.005|  0.6920|negligible |n.s.        |
|mnau_shoulder                                | -0.005|  0.6920|negligible |n.s.        |
|ProportionalRep_MNIbased_carpal              | -0.006|  0.7170|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.006|  0.7320|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.007|  0.7370|negligible |n.s.        |
|ReMNAU_radius                                | -0.007|  0.7450|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.007|  0.7450|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.008|  0.7450|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.008|  0.7450|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.010|  0.8460|negligible |n.s.        |
|ProportionalRep_MNIbased_clavicle            | -0.011|  0.8460|negligible |n.s.        |
|lower_appendicular_evenness                  | -0.013|  0.8460|negligible |n.s.        |
|lower_appendicular_evenness_refined          | -0.013|  0.8460|negligible |n.s.        |
|postcranial_dominance_refined                | -0.013|  0.8460|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.013|  0.9430|negligible |n.s.        |
|appendicular_dominance                       | -0.013|  0.8460|negligible |n.s.        |
|appendicular_dominance_refined               | -0.013|  0.8460|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                           |Contrast                               |     Z| p (adj)|Sig |
|:---------------------------------|:--------------------------------------|-----:|-------:|:---|
|all_sections_dominance            |Late Pleistocene vs Holocene           | -2.17| 0.04460|*   |
|all_sections_dominance            |Late Pleistocene vs Middle Pleistocene |  1.64| 0.10000|ns  |
|all_sections_dominance            |Holocene vs Middle Pleistocene         |  2.86| 0.01290|*   |
|density_evenness                  |Late Pleistocene vs Holocene           |  3.18| 0.00329|**  |
|density_evenness                  |Late Pleistocene vs Middle Pleistocene | -1.23| 0.21800|ns  |
|density_evenness                  |Holocene vs Middle Pleistocene         | -3.06| 0.00329|**  |
|distal_appendicular_continuity_hm |Late Pleistocene vs Holocene           |  2.77| 0.01700|*   |
|distal_appendicular_continuity_hm |Late Pleistocene vs Middle Pleistocene | -0.57| 0.56600|ns  |
|distal_appendicular_continuity_hm |Holocene vs Middle Pleistocene         | -2.19| 0.04320|*   |
|dominance_gap_all                 |Late Pleistocene vs Holocene           | -2.40| 0.02460|*   |
|dominance_gap_all                 |Late Pleistocene vs Middle Pleistocene |  1.55| 0.12200|ns  |
|dominance_gap_all                 |Holocene vs Middle Pleistocene         |  2.90| 0.01120|*   |
|effective_sections_hill1          |Late Pleistocene vs Holocene           |  2.59| 0.01450|*   |
|effective_sections_hill1          |Late Pleistocene vs Middle Pleistocene | -1.33| 0.18400|ns  |
|effective_sections_hill1          |Holocene vs Middle Pleistocene         | -2.80| 0.01450|*   |
|low_density_axial_survival        |Late Pleistocene vs Holocene           |  2.87| 0.00735|**  |
|low_density_axial_survival        |Late Pleistocene vs Middle Pleistocene | -1.17| 0.24100|ns  |
|low_density_axial_survival        |Holocene vs Middle Pleistocene         | -2.81| 0.00735|**  |
|low_density_share                 |Late Pleistocene vs Holocene           |  2.92| 0.00696|**  |
|low_density_share                 |Late Pleistocene vs Middle Pleistocene | -1.15| 0.25000|ns  |
|low_density_share                 |Holocene vs Middle Pleistocene         | -2.83| 0.00696|**  |
|mnau_axial_main_mean              |Late Pleistocene vs Holocene           |  2.80| 0.00974|**  |
|mnau_axial_main_mean              |Late Pleistocene vs Middle Pleistocene | -1.12| 0.26400|ns  |
|mnau_axial_main_mean              |Holocene vs Middle Pleistocene         | -2.72| 0.00974|**  |
|mnau_cv                           |Late Pleistocene vs Holocene           | -2.18| 0.04430|*   |
|mnau_cv                           |Late Pleistocene vs Middle Pleistocene |  1.50| 0.13400|ns  |
|mnau_cv                           |Holocene vs Middle Pleistocene         |  2.72| 0.01950|*   |
|mnau_evenness_minus_dominance     |Late Pleistocene vs Holocene           |  2.31| 0.03100|*   |
|mnau_evenness_minus_dominance     |Late Pleistocene vs Middle Pleistocene | -1.49| 0.13500|ns  |
|mnau_evenness_minus_dominance     |Holocene vs Middle Pleistocene         | -2.80| 0.01540|*   |
|mnau_gini                         |Late Pleistocene vs Holocene           | -2.37| 0.02670|*   |
|mnau_gini                         |Late Pleistocene vs Middle Pleistocene |  1.36| 0.17300|ns  |
|mnau_gini                         |Holocene vs Middle Pleistocene         |  2.71| 0.02040|*   |
|mnau_heip_evenness                |Late Pleistocene vs Holocene           |  2.59| 0.01450|*   |
|mnau_heip_evenness                |Late Pleistocene vs Middle Pleistocene | -1.33| 0.18400|ns  |
|mnau_heip_evenness                |Holocene vs Middle Pleistocene         | -2.80| 0.01450|*   |
|mnau_inverse_simpson              |Late Pleistocene vs Holocene           |  2.23| 0.03910|*   |
|mnau_inverse_simpson              |Late Pleistocene vs Middle Pleistocene | -1.49| 0.13700|ns  |
|mnau_inverse_simpson              |Holocene vs Middle Pleistocene         | -2.74| 0.01840|*   |
|mnau_simpson_dominance            |Late Pleistocene vs Holocene           | -2.23| 0.03910|*   |
|mnau_simpson_dominance            |Late Pleistocene vs Middle Pleistocene |  1.49| 0.13700|ns  |
|mnau_simpson_dominance            |Holocene vs Middle Pleistocene         |  2.74| 0.01840|*   |
|mnau_simpson_evenness             |Late Pleistocene vs Holocene           |  2.23| 0.03910|*   |
|mnau_simpson_evenness             |Late Pleistocene vs Middle Pleistocene | -1.49| 0.13700|ns  |
|mnau_simpson_evenness             |Holocene vs Middle Pleistocene         | -2.74| 0.01840|*   |
|mnau_top2_share_mcnaughton        |Late Pleistocene vs Holocene           | -2.20| 0.04220|*   |
|mnau_top2_share_mcnaughton        |Late Pleistocene vs Middle Pleistocene |  1.64| 0.10100|ns  |
|mnau_top2_share_mcnaughton        |Holocene vs Middle Pleistocene         |  2.87| 0.01240|*   |
|mne_arms                          |Late Pleistocene vs Holocene           |  4.09| 0.00013|*** |
|mne_arms                          |Late Pleistocene vs Middle Pleistocene |  0.79| 0.43200|ns  |
|mne_arms                          |Holocene vs Middle Pleistocene         | -1.68| 0.14000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 1.67, R² = 0.028, p = 0.1150.
PCA variance explained: PC1 56.8%, PC2 8.6%, PC3 6.3% (cumulative 71.7%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160| -0.138|  0.022|
|mnau_appendicular_mean      | -0.160| -0.136| -0.027|
|mnau_top2_share_mcnaughton  |  0.159| -0.137|  0.001|
|mnau_gini                   |  0.159| -0.114|  0.011|
|effective_sections_hill1    | -0.158|  0.129| -0.006|
|mnau_heip_evenness          | -0.158|  0.129| -0.006|
|mnau_inverse_simpson        | -0.158|  0.103| -0.009|
|mnau_simpson_evenness       | -0.158|  0.103| -0.009|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
