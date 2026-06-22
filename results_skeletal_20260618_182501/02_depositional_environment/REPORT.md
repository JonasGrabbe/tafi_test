# Depositional environment
*Automated karstic_system × skeletal-part representation*

- **Grouping column:** `karstic_system` (mode = alternative)
- **Groups (n):** Cave = 104; Rockshelter = 17
- **Sites analysed:** 121  |  **features screened:** 63

## Hypothesis

**H:** Depositional environment filters the skeleton before excavation.

**Expected pattern:** Cave interiors preserve more small elements; entrances/rockshelters show carnivore activity; fluvial deposits favour dense/large elements.

**Why it matters:** Tests whether site formation, not culture or species, explains anatomical differences.


## Summary

0 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **ProportionalRep_MNIbased_radius** (ε² = 0.077, FDR p = 0.07749). PERMANOVA pseudo-F = 2.71, p = 0.0454; PC1–PC3 explain 71.0% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 112 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 22 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result |
|:--------------------------------------------|------:|-------:|:----------|:------|
|ProportionalRep_MNIbased_radius              |  0.077|  0.0775|moderate   |n.s.   |
|ProportionalRep_MNIbased_femur               |  0.061|  0.0775|moderate   |n.s.   |
|ReMNAU_radius                                |  0.053|  0.0775|small      |n.s.   |
|mnau_proximal_appendicular_mean              |  0.050|  0.0775|small      |n.s.   |
|mnau_limb_shaft_proxy_mean                   |  0.050|  0.0775|small      |n.s.   |
|mnau_appendicular_mean                       |  0.048|  0.0775|small      |n.s.   |
|mnau_lower_appendicular_mean                 |  0.045|  0.0775|small      |n.s.   |
|mnau_arms                                    |  0.045|  0.0775|small      |n.s.   |
|mnau_legs                                    |  0.045|  0.0775|small      |n.s.   |
|mnau_upper_appendicular_mean                 |  0.044|  0.0775|small      |n.s.   |
|mnau_postcranial_total_mean                  |  0.042|  0.0830|small      |n.s.   |
|mnau_dominance_of_region_means               |  0.035|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_carpal              |  0.034|  0.0831|small      |n.s.   |
|all_sections_dominance                       |  0.034|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_humerus             |  0.033|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_clavicle            |  0.031|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_tibia               |  0.030|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_metacarpal          |  0.030|  0.0831|small      |n.s.   |
|mnau_pelvic                                  |  0.030|  0.0831|small      |n.s.   |
|mnau_inverse_simpson                         |  0.030|  0.0831|small      |n.s.   |
|mnau_simpson_dominance                       |  0.030|  0.0831|small      |n.s.   |
|mnau_simpson_evenness                        |  0.030|  0.0831|small      |n.s.   |
|ReMNAU_ulna                                  |  0.029|  0.0831|small      |n.s.   |
|mnau_girdle_mean                             |  0.029|  0.0831|small      |n.s.   |
|mnau_evenness_minus_dominance                |  0.029|  0.0831|small      |n.s.   |
|mnau_top2_share_mcnaughton                   |  0.029|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_os_coxae            |  0.028|  0.0831|small      |n.s.   |
|mnau_cv                                      |  0.028|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_cervical            |  0.027|  0.0831|small      |n.s.   |
|ProportionalRep_MNIbased_fibula              |  0.027|  0.0831|small      |n.s.   |
|dominant_axial_share                         |  0.027|  0.0831|small      |n.s.   |
|mnau_region_mean_evenness                    |  0.026|  0.0892|small      |n.s.   |
|dominance_gap_all                            |  0.023|  0.1010|small      |n.s.   |
|mnau_gini                                    |  0.023|  0.1010|small      |n.s.   |
|mnau_column_trunk_mean                       |  0.022|  0.1010|small      |n.s.   |
|mnau_distal_appendicular_mean                |  0.021|  0.1030|small      |n.s.   |
|effective_sections_hill1                     |  0.021|  0.1030|small      |n.s.   |
|mnau_heip_evenness                           |  0.021|  0.1030|small      |n.s.   |
|lower_appendicular_continuity_hm             |  0.021|  0.1030|small      |n.s.   |
|mnau_shoulder                                |  0.019|  0.1130|small      |n.s.   |
|low_density_survival_index                   |  0.017|  0.1230|small      |n.s.   |
|mne_vertebrae_to_thorax_ratio                |  0.017|  0.1240|small      |n.s.   |
|ReMNAU_cervical                              |  0.015|  0.1390|small      |n.s.   |
|mnau_vertebrae_to_thorax_ratio               |  0.013|  0.1530|small      |n.s.   |
|mne_cranial_share                            |  0.013|  0.1530|small      |n.s.   |
|mnau_hands                                   |  0.013|  0.1530|small      |n.s.   |
|low_density_axial_survival                   |  0.012|  0.1610|small      |n.s.   |
|mne_arms                                     |  0.010|  0.1790|small      |n.s.   |
|distal_appendicular_continuity_hm            |  0.008|  0.2110|negligible |n.s.   |
|appendicular_dominance                       |  0.008|  0.2110|negligible |n.s.   |
|appendicular_dominance_refined               |  0.008|  0.2110|negligible |n.s.   |
|density_evenness                             |  0.007|  0.2110|negligible |n.s.   |
|mnau_foot                                    |  0.007|  0.2110|negligible |n.s.   |
|mnau_axial_main_mean                         |  0.007|  0.2110|negligible |n.s.   |
|postcranial_dominance_refined                |  0.003|  0.2880|negligible |n.s.   |
|low_density_share                            |  0.000|  0.3610|negligible |n.s.   |
|density_adjusted_appendicular_axial_contrast | -0.005|  0.5510|negligible |n.s.   |
|lower_appendicular_evenness                  | -0.005|  0.5330|negligible |n.s.   |
|lower_appendicular_evenness_refined          | -0.005|  0.5330|negligible |n.s.   |
|mnau_arms_legs_diff                          | -0.006|  0.6500|negligible |n.s.   |
|mne_arms_to_legs_ratio                       | -0.007|  0.7430|negligible |n.s.   |
|mnau_arms_legs_logratio                      | -0.008|  0.9110|negligible |n.s.   |
|mnau_arms_to_legs_ratio                      | -0.008|  0.9110|negligible |n.s.   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.71, R² = 0.026, p = 0.0454.
PCA variance explained: PC1 55.1%, PC2 9.3%, PC3 6.6% (cumulative 71.0%).
Dispersion caveat (PERMDISP): p = 0.047 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.162|  0.139|  0.026|
|mnau_appendicular_mean      | -0.161|  0.140| -0.037|
|mnau_gini                   |  0.160|  0.124| -0.002|
|mnau_top2_share_mcnaughton  |  0.160|  0.145|  0.000|
|mnau_heip_evenness          | -0.159| -0.137|  0.004|
|effective_sections_hill1    | -0.159| -0.137|  0.004|
|mnau_inverse_simpson        | -0.159| -0.116|  0.007|
|mnau_simpson_evenness       | -0.159| -0.116|  0.007|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
