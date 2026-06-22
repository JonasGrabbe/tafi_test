# Age-related preservation
*Automated age_category × skeletal-part representation*

- **Grouping column:** `age_category` (mode = single)
- **Groups (n):** Mixed = 55; Adult = 51; Subadult = 5; Infant = 4
- **Sites analysed:** 115  |  **features screened:** 63

## Hypothesis

**H:** Age affects preservation: infant/juvenile bones are smaller, less fused, more fragile.

**Expected pattern:** Infants/juveniles show lower representation of small unfused bones, axial elements, epiphyses, ribs, vertebrae, hands/feet, pelvis; adults more complete/identifiable.

**Why it matters:** Strong biological/taphonomic hypothesis; should be checked before interpreting cultural differences.


## Summary

1 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.131, FDR p = 0.03515). PERMANOVA pseudo-F = 3.31, p = 0.0021; PC1–PC3 explain 72.2% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 160 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 36 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.131|  0.0352|moderate   |significant |
|density_adjusted_appendicular_axial_contrast |  0.044|  0.9440|small      |n.s.        |
|distal_appendicular_continuity_hm            |  0.032|  0.9440|small      |n.s.        |
|ProportionalRep_MNIbased_carpal              |  0.026|  0.9440|small      |n.s.        |
|ProportionalRep_MNIbased_femur               |  0.023|  0.9440|small      |n.s.        |
|ProportionalRep_MNIbased_os_coxae            |  0.015|  0.9440|small      |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.013|  0.9440|small      |n.s.        |
|mnau_pelvic                                  |  0.013|  0.9440|small      |n.s.        |
|ReMNAU_radius                                |  0.008|  0.9440|negligible |n.s.        |
|mnau_lower_appendicular_mean                 |  0.007|  0.9440|negligible |n.s.        |
|mnau_girdle_mean                             |  0.006|  0.9440|negligible |n.s.        |
|mnau_foot                                    |  0.006|  0.9440|negligible |n.s.        |
|dominant_axial_share                         |  0.005|  0.9440|negligible |n.s.        |
|postcranial_dominance_refined                |  0.004|  0.9440|negligible |n.s.        |
|density_evenness                             |  0.004|  0.9440|negligible |n.s.        |
|effective_sections_hill1                     |  0.003|  0.9440|negligible |n.s.        |
|mnau_heip_evenness                           |  0.003|  0.9440|negligible |n.s.        |
|lower_appendicular_evenness                  |  0.000|  0.9440|negligible |n.s.        |
|lower_appendicular_evenness_refined          |  0.000|  0.9440|negligible |n.s.        |
|mnau_proximal_appendicular_mean              |  0.000|  0.9440|negligible |n.s.        |
|mnau_column_trunk_mean                       | -0.001|  0.9440|negligible |n.s.        |
|mnau_hands                                   | -0.001|  0.9440|negligible |n.s.        |
|mne_cranial_share                            | -0.002|  0.9440|negligible |n.s.        |
|appendicular_dominance                       | -0.002|  0.9440|negligible |n.s.        |
|appendicular_dominance_refined               | -0.002|  0.9440|negligible |n.s.        |
|mnau_gini                                    | -0.002|  0.9440|negligible |n.s.        |
|ReMNAU_ulna                                  | -0.002|  0.9440|negligible |n.s.        |
|lower_appendicular_continuity_hm             | -0.003|  0.9440|negligible |n.s.        |
|low_density_axial_survival                   | -0.004|  0.9440|negligible |n.s.        |
|mnau_appendicular_mean                       | -0.005|  0.9440|negligible |n.s.        |
|mnau_legs                                    | -0.005|  0.9440|negligible |n.s.        |
|mnau_dominance_of_region_means               | -0.006|  0.9440|negligible |n.s.        |
|mnau_limb_shaft_proxy_mean                   | -0.006|  0.9440|negligible |n.s.        |
|mnau_axial_main_mean                         | -0.006|  0.9440|negligible |n.s.        |
|low_density_share                            | -0.008|  0.9440|negligible |n.s.        |
|mnau_postcranial_total_mean                  | -0.008|  0.9440|negligible |n.s.        |
|mnau_region_mean_evenness                    | -0.009|  0.9440|negligible |n.s.        |
|mnau_evenness_minus_dominance                | -0.009|  0.9440|negligible |n.s.        |
|mnau_top2_share_mcnaughton                   | -0.011|  0.9440|negligible |n.s.        |
|ProportionalRep_MNIbased_radius              | -0.011|  0.9440|negligible |n.s.        |
|mnau_inverse_simpson                         | -0.013|  0.9440|negligible |n.s.        |
|mnau_simpson_dominance                       | -0.013|  0.9440|negligible |n.s.        |
|mnau_simpson_evenness                        | -0.013|  0.9440|negligible |n.s.        |
|mnau_cv                                      | -0.013|  0.9440|negligible |n.s.        |
|ProportionalRep_MNIbased_clavicle            | -0.014|  0.9440|negligible |n.s.        |
|low_density_survival_index                   | -0.015|  0.9440|negligible |n.s.        |
|dominance_gap_all                            | -0.015|  0.9440|negligible |n.s.        |
|mnau_shoulder                                | -0.017|  0.9440|negligible |n.s.        |
|mnau_distal_appendicular_mean                | -0.017|  0.9440|negligible |n.s.        |
|all_sections_dominance                       | -0.017|  0.9440|negligible |n.s.        |
|mnau_arms                                    | -0.017|  0.9440|negligible |n.s.        |
|ProportionalRep_MNIbased_cervical            | -0.017|  0.9440|negligible |n.s.        |
|ProportionalRep_MNIbased_fibula              | -0.018|  0.9440|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.019|  0.9440|negligible |n.s.        |
|ProportionalRep_MNIbased_humerus             | -0.019|  0.9440|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.020|  0.9510|negligible |n.s.        |
|ReMNAU_cervical                              | -0.020|  0.9510|negligible |n.s.        |
|ProportionalRep_MNIbased_metacarpal          | -0.021|  0.9530|negligible |n.s.        |
|mnau_upper_appendicular_mean                 | -0.022|  0.9790|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.023|  0.9810|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.025|  0.9970|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.027|  0.9970|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.027|  0.9970|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature  |Contrast           |     Z| p (adj)|Sig |
|:--------|:------------------|-----:|-------:|:---|
|mne_arms |Mixed vs Adult     | -3.96| 0.00044|*** |
|mne_arms |Mixed vs Subadult  | -1.19| 0.46600|ns  |
|mne_arms |Mixed vs Infant    | -1.98| 0.14300|ns  |
|mne_arms |Adult vs Subadult  |  0.46| 0.64800|ns  |
|mne_arms |Adult vs Infant    | -0.49| 0.64800|ns  |
|mne_arms |Subadult vs Infant | -0.70| 0.64800|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 3.31, R² = 0.096, p = 0.0021.
PCA variance explained: PC1 56.7%, PC2 9.0%, PC3 6.4% (cumulative 72.2%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160|  0.135|  0.040|
|mnau_appendicular_mean      | -0.159|  0.139| -0.010|
|mnau_top2_share_mcnaughton  |  0.158|  0.137|  0.016|
|mnau_gini                   |  0.158|  0.115|  0.023|
|effective_sections_hill1    | -0.158| -0.128| -0.020|
|mnau_heip_evenness          | -0.158| -0.128| -0.020|
|mnau_inverse_simpson        | -0.157| -0.102| -0.022|
|mnau_simpson_evenness       | -0.157| -0.102| -0.022|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
