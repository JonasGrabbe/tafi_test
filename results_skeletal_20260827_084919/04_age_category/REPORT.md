# Age-related preservation
*Automated age_category × skeletal-part representation*

- **Grouping column:** `age_category` (mode = single)
- **Groups (n):** Mixed = 55; Adult = 53; Juvenile = 6; Infant = 5; Subadult = 5
- **Sites analysed:** 124  |  **features screened:** 63

## Hypothesis

**H:** Age affects preservation: infant/juvenile bones are smaller, less fused, more fragile.

**Expected pattern:** Infants/juveniles show lower representation of small unfused bones, axial elements, epiphyses, ribs, vertebrae, hands/feet, pelvis; adults more complete/identifiable.

**Why it matters:** Strong biological/taphonomic hypothesis; should be checked before interpreting cultural differences.


## Summary

1 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.141, FDR p = 0.0223). PERMANOVA pseudo-F = 2.73, p = 0.0034; PC1–PC3 explain 72.2% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 225 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 22 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.141|  0.0223|large      |significant |
|density_adjusted_appendicular_axial_contrast |  0.083|  0.2370|moderate   |n.s.        |
|distal_appendicular_continuity_hm            |  0.038|  0.8330|small      |n.s.        |
|ProportionalRep_MNIbased_carpal              |  0.028|  0.8330|small      |n.s.        |
|dominant_axial_share                         |  0.023|  0.8330|small      |n.s.        |
|ProportionalRep_MNIbased_femur               |  0.020|  0.8330|small      |n.s.        |
|ProportionalRep_MNIbased_os_coxae            |  0.018|  0.8330|small      |n.s.        |
|mne_cranial_share                            |  0.016|  0.8330|small      |n.s.        |
|ReMNAU_radius                                |  0.016|  0.8330|small      |n.s.        |
|density_evenness                             |  0.013|  0.8330|small      |n.s.        |
|lower_appendicular_continuity_hm             |  0.010|  0.8330|small      |n.s.        |
|postcranial_dominance_refined                |  0.010|  0.8330|negligible |n.s.        |
|mnau_foot                                    |  0.008|  0.8330|negligible |n.s.        |
|mnau_lower_appendicular_mean                 |  0.007|  0.8330|negligible |n.s.        |
|effective_sections_hill1                     |  0.007|  0.8330|negligible |n.s.        |
|mnau_heip_evenness                           |  0.007|  0.8330|negligible |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.005|  0.8330|negligible |n.s.        |
|ReMNAU_ulna                                  |  0.005|  0.8330|negligible |n.s.        |
|mnau_pelvic                                  |  0.005|  0.8330|negligible |n.s.        |
|mnau_gini                                    |  0.004|  0.8330|negligible |n.s.        |
|mnau_dominance_of_region_means               |  0.004|  0.8330|negligible |n.s.        |
|mnau_region_mean_evenness                    |  0.001|  0.8330|negligible |n.s.        |
|lower_appendicular_evenness                  |  0.000|  0.8330|negligible |n.s.        |
|lower_appendicular_evenness_refined          |  0.000|  0.8330|negligible |n.s.        |
|appendicular_dominance                       | -0.001|  0.8330|negligible |n.s.        |
|appendicular_dominance_refined               | -0.001|  0.8330|negligible |n.s.        |
|mnau_proximal_appendicular_mean              | -0.001|  0.8330|negligible |n.s.        |
|mnau_hands                                   | -0.002|  0.8330|negligible |n.s.        |
|dominance_gap_all                            | -0.003|  0.8330|negligible |n.s.        |
|mnau_evenness_minus_dominance                | -0.003|  0.8330|negligible |n.s.        |
|mnau_legs                                    | -0.004|  0.8330|negligible |n.s.        |
|mnau_girdle_mean                             | -0.004|  0.8330|negligible |n.s.        |
|mnau_appendicular_mean                       | -0.004|  0.8330|negligible |n.s.        |
|mnau_top2_share_mcnaughton                   | -0.005|  0.8330|negligible |n.s.        |
|mnau_limb_shaft_proxy_mean                   | -0.005|  0.8330|negligible |n.s.        |
|mnau_column_trunk_mean                       | -0.007|  0.8330|negligible |n.s.        |
|mnau_inverse_simpson                         | -0.007|  0.8330|negligible |n.s.        |
|mnau_simpson_dominance                       | -0.007|  0.8330|negligible |n.s.        |
|mnau_simpson_evenness                        | -0.007|  0.8330|negligible |n.s.        |
|all_sections_dominance                       | -0.008|  0.8330|negligible |n.s.        |
|mnau_cv                                      | -0.008|  0.8330|negligible |n.s.        |
|low_density_share                            | -0.009|  0.8330|negligible |n.s.        |
|low_density_axial_survival                   | -0.009|  0.8330|negligible |n.s.        |
|mnau_postcranial_total_mean                  | -0.010|  0.8330|negligible |n.s.        |
|mnau_distal_appendicular_mean                | -0.010|  0.8400|negligible |n.s.        |
|mnau_axial_main_mean                         | -0.012|  0.8550|negligible |n.s.        |
|ProportionalRep_MNIbased_radius              | -0.016|  0.9580|negligible |n.s.        |
|mnau_arms                                    | -0.020|  1.0000|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.021|  1.0000|negligible |n.s.        |
|low_density_survival_index                   | -0.021|  1.0000|negligible |n.s.        |
|ProportionalRep_MNIbased_clavicle            | -0.022|  1.0000|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.023|  1.0000|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.023|  1.0000|negligible |n.s.        |
|mnau_shoulder                                | -0.023|  1.0000|negligible |n.s.        |
|ProportionalRep_MNIbased_fibula              | -0.025|  1.0000|negligible |n.s.        |
|ProportionalRep_MNIbased_humerus             | -0.025|  1.0000|negligible |n.s.        |
|mnau_upper_appendicular_mean                 | -0.026|  1.0000|negligible |n.s.        |
|ProportionalRep_MNIbased_cervical            | -0.028|  1.0000|negligible |n.s.        |
|ProportionalRep_MNIbased_metacarpal          | -0.030|  1.0000|negligible |n.s.        |
|ReMNAU_cervical                              | -0.031|  1.0000|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.031|  1.0000|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.033|  1.0000|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.033|  1.0000|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature  |Contrast             |     Z|  p (adj)|Sig |
|:--------|:--------------------|-----:|--------:|:---|
|mne_arms |Mixed vs Adult       | -4.00| 0.000646|*** |
|mne_arms |Mixed vs Juvenile    | -2.29| 0.073400|ns  |
|mne_arms |Mixed vs Infant      | -2.47| 0.068300|ns  |
|mne_arms |Mixed vs Subadult    | -1.18| 0.598000|ns  |
|mne_arms |Adult vs Juvenile    | -0.50| 0.710000|ns  |
|mne_arms |Adult vs Infant      | -0.82| 0.675000|ns  |
|mne_arms |Adult vs Subadult    |  0.47| 0.710000|ns  |
|mne_arms |Juvenile vs Infant   | -0.28| 0.782000|ns  |
|mne_arms |Juvenile vs Subadult |  0.72| 0.675000|ns  |
|mne_arms |Infant vs Subadult   |  0.95| 0.675000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.73, R² = 0.101, p = 0.0034.
PCA variance explained: PC1 57.2%, PC2 8.7%, PC3 6.3% (cumulative 72.2%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160|  0.135|  0.038|
|mnau_appendicular_mean      | -0.159|  0.138| -0.011|
|mnau_gini                   |  0.158|  0.112|  0.024|
|mnau_top2_share_mcnaughton  |  0.158|  0.136|  0.018|
|effective_sections_hill1    | -0.158| -0.127| -0.018|
|mnau_heip_evenness          | -0.158| -0.127| -0.018|
|mnau_simpson_evenness       | -0.157| -0.101| -0.024|
|mnau_inverse_simpson        | -0.157| -0.101| -0.024|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
