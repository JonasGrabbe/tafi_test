# Recovery / excavation bias
*Automated discovery_context × skeletal-part representation*

- **Grouping column:** `discovery_context` (mode = alternative)
- **Groups (n):** Formal excavation = 76; Casual = 14; Quarry = 4
- **Sites analysed:** 94  |  **features screened:** 63

## Hypothesis

**H:** Recovery method affects which bones enter the dataset.

**Expected pattern:** Formal/complete excavations recover more small bones; quarry/casual discoveries over-represent large, visible, diagnostic elements.

**Why it matters:** Essential bias-control analysis; may explain patterns that otherwise look biological or cultural.


## Summary

0 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **distal_appendicular_continuity_hm** (ε² = 0.098, FDR p = 0.1746). PERMANOVA pseudo-F = 0.77, p = 0.5616; PC1–PC3 explain 74.4% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 126 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 2 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|distal_appendicular_continuity_hm            |  0.098|   0.175|moderate   |n.s.   |
|mnau_hands                                   |  0.092|   0.175|moderate   |n.s.   |
|ProportionalRep_MNIbased_fibula              |  0.070|   0.175|moderate   |n.s.   |
|mnau_distal_appendicular_mean                |  0.070|   0.175|moderate   |n.s.   |
|mne_arms                                     |  0.066|   0.175|moderate   |n.s.   |
|ProportionalRep_MNIbased_carpal              |  0.066|   0.175|moderate   |n.s.   |
|ReMNAU_radius                                |  0.065|   0.175|moderate   |n.s.   |
|ProportionalRep_MNIbased_metacarpal          |  0.050|   0.249|small      |n.s.   |
|mnau_foot                                    |  0.046|   0.249|small      |n.s.   |
|effective_sections_hill1                     |  0.043|   0.249|small      |n.s.   |
|mnau_heip_evenness                           |  0.043|   0.249|small      |n.s.   |
|mnau_arms_legs_logratio                      |  0.041|   0.249|small      |n.s.   |
|mnau_arms_to_legs_ratio                      |  0.041|   0.249|small      |n.s.   |
|mnau_gini                                    |  0.041|   0.249|small      |n.s.   |
|mne_arms_to_legs_ratio                       |  0.040|   0.249|small      |n.s.   |
|ProportionalRep_MNIbased_radius              |  0.039|   0.251|small      |n.s.   |
|mnau_arms                                    |  0.036|   0.261|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.035|   0.261|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.032|   0.271|small      |n.s.   |
|ProportionalRep_MNIbased_humerus             |  0.031|   0.271|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.031|   0.271|small      |n.s.   |
|mnau_arms_legs_diff                          |  0.029|   0.271|small      |n.s.   |
|mnau_evenness_minus_dominance                |  0.029|   0.271|small      |n.s.   |
|mnau_inverse_simpson                         |  0.026|   0.276|small      |n.s.   |
|mnau_simpson_dominance                       |  0.026|   0.276|small      |n.s.   |
|mnau_simpson_evenness                        |  0.026|   0.276|small      |n.s.   |
|density_evenness                             |  0.023|   0.295|small      |n.s.   |
|ReMNAU_cervical                              |  0.022|   0.295|small      |n.s.   |
|mnau_cv                                      |  0.022|   0.295|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.021|   0.298|small      |n.s.   |
|all_sections_dominance                       |  0.020|   0.301|small      |n.s.   |
|low_density_axial_survival                   |  0.019|   0.305|small      |n.s.   |
|mnau_limb_shaft_proxy_mean                   |  0.018|   0.305|small      |n.s.   |
|ProportionalRep_MNIbased_cervical            |  0.017|   0.313|small      |n.s.   |
|mnau_axial_main_mean                         |  0.016|   0.313|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.016|   0.315|small      |n.s.   |
|mnau_legs                                    |  0.014|   0.320|small      |n.s.   |
|ProportionalRep_MNIbased_tibia               |  0.014|   0.320|small      |n.s.   |
|mnau_appendicular_mean                       |  0.013|   0.334|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.012|   0.337|small      |n.s.   |
|mne_cranial_share                            |  0.010|   0.363|negligible |n.s.   |
|ReMNAU_ulna                                  |  0.008|   0.381|negligible |n.s.   |
|mnau_lower_appendicular_mean                 |  0.007|   0.390|negligible |n.s.   |
|dominance_gap_all                            |  0.005|   0.415|negligible |n.s.   |
|postcranial_dominance_refined                |  0.004|   0.441|negligible |n.s.   |
|low_density_survival_index                   |  0.001|   0.471|negligible |n.s.   |
|appendicular_dominance                       |  0.001|   0.471|negligible |n.s.   |
|appendicular_dominance_refined               |  0.001|   0.471|negligible |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.000|   0.474|negligible |n.s.   |
|mnau_proximal_appendicular_mean              | -0.001|   0.479|negligible |n.s.   |
|dominant_axial_share                         | -0.002|   0.497|negligible |n.s.   |
|mne_vertebrae_to_thorax_ratio                | -0.004|   0.537|negligible |n.s.   |
|mnau_column_trunk_mean                       | -0.006|   0.563|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast | -0.007|   0.589|negligible |n.s.   |
|mnau_shoulder                                | -0.009|   0.610|negligible |n.s.   |
|lower_appendicular_evenness                  | -0.010|   0.610|negligible |n.s.   |
|lower_appendicular_evenness_refined          | -0.010|   0.610|negligible |n.s.   |
|low_density_share                            | -0.011|   0.660|negligible |n.s.   |
|mnau_girdle_mean                             | -0.013|   0.724|negligible |n.s.   |
|mnau_pelvic                                  | -0.014|   0.732|negligible |n.s.   |
|ProportionalRep_MNIbased_clavicle            | -0.014|   0.732|negligible |n.s.   |
|ProportionalRep_MNIbased_os_coxae            | -0.017|   0.796|negligible |n.s.   |
|ProportionalRep_MNIbased_femur               | -0.018|   0.842|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 0.77, R² = 0.019, p = 0.5616.
PCA variance explained: PC1 58.8%, PC2 8.2%, PC3 7.4% (cumulative 74.4%).
Dispersion caveat (PERMDISP): p = 0.678.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.158| -0.124| -0.064|
|mnau_top2_share_mcnaughton  |  0.158| -0.111| -0.063|
|mnau_appendicular_mean      | -0.157| -0.134| -0.037|
|mnau_cv                     |  0.156| -0.134| -0.063|
|effective_sections_hill1    | -0.156|  0.109|  0.061|
|mnau_heip_evenness          | -0.156|  0.109|  0.061|
|mnau_gini                   |  0.156| -0.096| -0.063|
|mnau_inverse_simpson        | -0.155|  0.072|  0.058|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
