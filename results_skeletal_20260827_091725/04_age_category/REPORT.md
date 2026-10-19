# Age-related preservation
*Automated age_category × skeletal-part representation*

- **Grouping column:** `age_category` (mode = single)
- **Groups (n):** Mixed = 55; Adult = 53; Juvenile = 6; Infant = 5; Subadult = 5
- **Sites analysed:** 124  |  **features screened:** 50

## Hypothesis

**H:** Age affects preservation: infant/juvenile bones are smaller, less fused, more fragile.

**Expected pattern:** Infants/juveniles show lower representation of small unfused bones, axial elements, epiphyses, ribs, vertebrae, hands/feet, pelvis; adults more complete/identifiable.

**Why it matters:** Strong biological/taphonomic hypothesis; should be checked before interpreting cultural differences.


## Summary

2 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.141, FDR p = 0.0177). PERMANOVA pseudo-F = 2.44, p = 0.0079; PC1–PC3 explain 74.9% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 191 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 19 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.141|  0.0177|large      |significant |
|density_adjusted_appendicular_axial_contrast |  0.113|  0.0388|moderate   |significant |
|distal_appendicular_continuity_hm            |  0.037|  0.6940|small      |n.s.        |
|dominant_axial_share                         |  0.021|  0.6940|small      |n.s.        |
|mne_cranial_share                            |  0.016|  0.6940|small      |n.s.        |
|effective_sections_hill1                     |  0.013|  0.6940|small      |n.s.        |
|mnau_heip_evenness                           |  0.013|  0.6940|small      |n.s.        |
|lower_appendicular_continuity_hm             |  0.013|  0.6940|small      |n.s.        |
|mnau_gini                                    |  0.012|  0.6940|small      |n.s.        |
|density_evenness                             |  0.011|  0.6940|small      |n.s.        |
|mnau_dominance_of_region_means               |  0.011|  0.6940|small      |n.s.        |
|dominance_gap_all                            |  0.009|  0.6940|negligible |n.s.        |
|mnau_foot                                    |  0.008|  0.6940|negligible |n.s.        |
|mnau_region_mean_evenness                    |  0.008|  0.6940|negligible |n.s.        |
|mnau_inverse_simpson                         |  0.004|  0.6940|negligible |n.s.        |
|mnau_simpson_dominance                       |  0.004|  0.6940|negligible |n.s.        |
|mnau_simpson_evenness                        |  0.004|  0.6940|negligible |n.s.        |
|mnau_pelvic                                  |  0.003|  0.6940|negligible |n.s.        |
|mnau_lower_appendicular_mean                 |  0.003|  0.6940|negligible |n.s.        |
|mnau_evenness_minus_dominance                |  0.003|  0.6940|negligible |n.s.        |
|mnau_cv                                      |  0.002|  0.6940|negligible |n.s.        |
|mnau_proximal_appendicular_mean              |  0.001|  0.6940|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.001|  0.6940|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.001|  0.6940|negligible |n.s.        |
|mnau_girdle_mean                             | -0.001|  0.6940|negligible |n.s.        |
|mnau_appendicular_mean                       | -0.002|  0.6940|negligible |n.s.        |
|mnau_hands                                   | -0.002|  0.6940|negligible |n.s.        |
|lower_appendicular_evenness                  | -0.002|  0.6940|negligible |n.s.        |
|lower_appendicular_evenness_refined          | -0.002|  0.6940|negligible |n.s.        |
|mnau_top2_share_mcnaughton                   | -0.002|  0.6940|negligible |n.s.        |
|mnau_legs                                    | -0.004|  0.6940|negligible |n.s.        |
|mnau_limb_shaft_proxy_mean                   | -0.004|  0.6940|negligible |n.s.        |
|all_sections_dominance                       | -0.004|  0.6940|negligible |n.s.        |
|mnau_postcranial_total_mean                  | -0.004|  0.6940|negligible |n.s.        |
|postcranial_dominance_refined                | -0.005|  0.6940|negligible |n.s.        |
|mnau_column_trunk_mean                       | -0.006|  0.7070|negligible |n.s.        |
|low_density_share                            | -0.008|  0.7380|negligible |n.s.        |
|low_density_axial_survival                   | -0.009|  0.7520|negligible |n.s.        |
|mnau_distal_appendicular_mean                | -0.010|  0.7520|negligible |n.s.        |
|mnau_axial_main_mean                         | -0.011|  0.7520|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.013|  0.7900|negligible |n.s.        |
|appendicular_dominance                       | -0.018|  0.8130|negligible |n.s.        |
|appendicular_dominance_refined               | -0.018|  0.8130|negligible |n.s.        |
|low_density_survival_index                   | -0.020|  0.8920|negligible |n.s.        |
|mnau_arms                                    | -0.020|  0.8920|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.021|  0.8920|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.022|  0.8920|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.023|  0.8920|negligible |n.s.        |
|mnau_shoulder                                | -0.023|  0.8920|negligible |n.s.        |
|mnau_upper_appendicular_mean                 | -0.028|  0.9560|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                                      |Contrast             |     Z|  p (adj)|Sig |
|:--------------------------------------------|:--------------------|-----:|--------:|:---|
|density_adjusted_appendicular_axial_contrast |Mixed vs Adult       | -0.54| 0.592000|ns  |
|density_adjusted_appendicular_axial_contrast |Mixed vs Juvenile    | -2.67| 0.018900|*   |
|density_adjusted_appendicular_axial_contrast |Mixed vs Infant      | -3.22| 0.013000|*   |
|density_adjusted_appendicular_axial_contrast |Mixed vs Subadult    |  0.64| 0.592000|ns  |
|density_adjusted_appendicular_axial_contrast |Adult vs Juvenile    | -2.43| 0.027900|*   |
|density_adjusted_appendicular_axial_contrast |Adult vs Infant      | -2.99| 0.014000|*   |
|density_adjusted_appendicular_axial_contrast |Adult vs Subadult    |  0.86| 0.555000|ns  |
|density_adjusted_appendicular_axial_contrast |Juvenile vs Infant   | -0.58| 0.592000|ns  |
|density_adjusted_appendicular_axial_contrast |Juvenile vs Subadult |  2.39| 0.027900|*   |
|density_adjusted_appendicular_axial_contrast |Infant vs Subadult   |  2.85| 0.014600|*   |
|mne_arms                                     |Mixed vs Adult       | -4.00| 0.000646|*** |
|mne_arms                                     |Mixed vs Juvenile    | -2.29| 0.073400|ns  |
|mne_arms                                     |Mixed vs Infant      | -2.47| 0.068300|ns  |
|mne_arms                                     |Mixed vs Subadult    | -1.18| 0.598000|ns  |
|mne_arms                                     |Adult vs Juvenile    | -0.50| 0.710000|ns  |
|mne_arms                                     |Adult vs Infant      | -0.82| 0.675000|ns  |
|mne_arms                                     |Adult vs Subadult    |  0.47| 0.710000|ns  |
|mne_arms                                     |Juvenile vs Infant   | -0.28| 0.782000|ns  |
|mne_arms                                     |Juvenile vs Subadult |  0.72| 0.675000|ns  |
|mne_arms                                     |Infant vs Subadult   |  0.95| 0.675000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.44, R² = 0.092, p = 0.0079.
PCA variance explained: PC1 61.0%, PC2 8.1%, PC3 5.9% (cumulative 74.9%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                    |    PC1|    PC2|    PC3|
|:--------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton |  0.177| -0.111|  0.019|
|mnau_simpson_evenness      | -0.176|  0.080| -0.024|
|mnau_inverse_simpson       | -0.176|  0.080| -0.024|
|mnau_gini                  |  0.176| -0.111|  0.030|
|mnau_heip_evenness         | -0.175|  0.125| -0.023|
|effective_sections_hill1   | -0.175|  0.125| -0.023|
|all_sections_dominance     |  0.174| -0.137| -0.010|
|mnau_cv                    |  0.174| -0.157|  0.001|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
