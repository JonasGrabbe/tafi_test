# Depositional environment
*Automated karstic_system × skeletal-part representation*

- **Grouping column:** `karstic_system` (mode = alternative)
- **Groups (n):** Cave = 105; Rockshelter = 17
- **Sites analysed:** 122  |  **features screened:** 63

## Hypothesis

**H:** Depositional environment filters the skeleton before excavation.

**Expected pattern:** Cave interiors preserve more small elements; entrances/rockshelters show carnivore activity; fluvial deposits favour dense/large elements.

**Why it matters:** Tests whether site formation, not culture or species, explains anatomical differences.


## Summary

0 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **ProportionalRep_MNIbased_radius** (ε² = 0.076, FDR p = 0.08505). PERMANOVA pseudo-F = 2.63, p = 0.0496; PC1–PC3 explain 71.0% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 112 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 21 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|ProportionalRep_MNIbased_radius              |  0.076|  0.0850|moderate   |n.s.   |
|ProportionalRep_MNIbased_femur               |  0.061|  0.0850|moderate   |n.s.   |
|ReMNAU_radius                                |  0.054|  0.0850|small      |n.s.   |
|mnau_limb_shaft_proxy_mean                   |  0.050|  0.0850|small      |n.s.   |
|mnau_proximal_appendicular_mean              |  0.050|  0.0850|small      |n.s.   |
|mnau_appendicular_mean                       |  0.047|  0.0850|small      |n.s.   |
|mnau_arms                                    |  0.044|  0.0850|small      |n.s.   |
|mnau_legs                                    |  0.044|  0.0850|small      |n.s.   |
|mnau_lower_appendicular_mean                 |  0.043|  0.0850|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.043|  0.0850|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.041|  0.0876|small      |n.s.   |
|ProportionalRep_MNIbased_humerus             |  0.033|  0.1020|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.033|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_carpal              |  0.032|  0.1020|small      |n.s.   |
|ReMNAU_ulna                                  |  0.031|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_tibia               |  0.031|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_clavicle            |  0.031|  0.1020|small      |n.s.   |
|all_sections_dominance                       |  0.030|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_metacarpal          |  0.029|  0.1020|small      |n.s.   |
|mnau_pelvic                                  |  0.028|  0.1020|small      |n.s.   |
|mnau_girdle_mean                             |  0.028|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_fibula              |  0.027|  0.1020|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.026|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_os_coxae            |  0.025|  0.1020|small      |n.s.   |
|ProportionalRep_MNIbased_cervical            |  0.025|  0.1020|small      |n.s.   |
|mnau_inverse_simpson                         |  0.025|  0.1020|small      |n.s.   |
|mnau_simpson_dominance                       |  0.025|  0.1020|small      |n.s.   |
|mnau_simpson_evenness                        |  0.025|  0.1020|small      |n.s.   |
|mnau_evenness_minus_dominance                |  0.025|  0.1020|small      |n.s.   |
|dominant_axial_share                         |  0.025|  0.1020|small      |n.s.   |
|mnau_cv                                      |  0.024|  0.1040|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.023|  0.1040|small      |n.s.   |
|dominance_gap_all                            |  0.020|  0.1200|small      |n.s.   |
|mnau_column_trunk_mean                       |  0.020|  0.1200|small      |n.s.   |
|mnau_distal_appendicular_mean                |  0.019|  0.1240|small      |n.s.   |
|mnau_gini                                    |  0.019|  0.1240|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.018|  0.1240|small      |n.s.   |
|mnau_shoulder                                |  0.018|  0.1240|small      |n.s.   |
|effective_sections_hill1                     |  0.017|  0.1290|small      |n.s.   |
|mnau_heip_evenness                           |  0.017|  0.1290|small      |n.s.   |
|low_density_survival_index                   |  0.016|  0.1380|small      |n.s.   |
|ReMNAU_cervical                              |  0.014|  0.1520|small      |n.s.   |
|mne_vertebrae_to_thorax_ratio                |  0.013|  0.1580|small      |n.s.   |
|mne_cranial_share                            |  0.012|  0.1750|small      |n.s.   |
|mnau_hands                                   |  0.011|  0.1750|small      |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.010|  0.1810|small      |n.s.   |
|low_density_axial_survival                   |  0.010|  0.1810|small      |n.s.   |
|mne_arms                                     |  0.009|  0.1990|negligible |n.s.   |
|distal_appendicular_continuity_hm            |  0.006|  0.2370|negligible |n.s.   |
|appendicular_dominance                       |  0.006|  0.2380|negligible |n.s.   |
|appendicular_dominance_refined               |  0.006|  0.2380|negligible |n.s.   |
|mnau_axial_main_mean                         |  0.006|  0.2380|negligible |n.s.   |
|mnau_foot                                    |  0.005|  0.2380|negligible |n.s.   |
|density_evenness                             |  0.005|  0.2380|negligible |n.s.   |
|postcranial_dominance_refined                |  0.003|  0.2940|negligible |n.s.   |
|low_density_share                            |  0.000|  0.3720|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast | -0.005|  0.5850|negligible |n.s.   |
|lower_appendicular_evenness                  | -0.006|  0.5850|negligible |n.s.   |
|lower_appendicular_evenness_refined          | -0.006|  0.5850|negligible |n.s.   |
|mnau_arms_legs_diff                          | -0.006|  0.6670|negligible |n.s.   |
|mne_arms_to_legs_ratio                       | -0.007|  0.7650|negligible |n.s.   |
|mnau_arms_legs_logratio                      | -0.008|  0.8970|negligible |n.s.   |
|mnau_arms_to_legs_ratio                      | -0.008|  0.8970|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.63, R² = 0.025, p = 0.0496.
PCA variance explained: PC1 55.2%, PC2 9.2%, PC3 6.6% (cumulative 71.0%).
Dispersion caveat (PERMDISP): p = 0.046 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.162|  0.139| -0.023|
|mnau_appendicular_mean      | -0.161|  0.139|  0.039|
|mnau_top2_share_mcnaughton  |  0.160|  0.145|  0.002|
|mnau_gini                   |  0.160|  0.124|  0.002|
|effective_sections_hill1    | -0.159| -0.137| -0.004|
|mnau_heip_evenness          | -0.159| -0.137| -0.004|
|mnau_inverse_simpson        | -0.159| -0.116| -0.005|
|mnau_simpson_evenness       | -0.159| -0.116| -0.005|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
