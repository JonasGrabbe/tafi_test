# Time depth / attrition
*Automated geological_period × skeletal-part representation*

- **Grouping column:** `geological_period` (mode = alternative)
- **Groups (n):** Late Pleistocene = 86; Holocene = 48; Middle Pleistocene = 15
- **Sites analysed:** 149  |  **features screened:** 63

## Hypothesis

**H:** Older assemblages are more altered by long-term attrition and recovery bias.

**Expected pattern:** Earlier Pleistocene contexts lose fragile elements and over-represent teeth, cranial pieces, dense shafts; Holocene burials more complete.

**Why it matters:** Tests time-depth and preservation intensity (must be read alongside context).


## Summary

1 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.101, FDR p = 0.01493). PERMANOVA pseudo-F = 1.64, p = 0.1317; PC1–PC3 explain 71.7% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 175 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 33 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.101|  0.0149|moderate   |significant |
|density_evenness                             |  0.070|  0.0756|moderate   |n.s.        |
|low_density_share                            |  0.061|  0.0927|moderate   |n.s.        |
|low_density_axial_survival                   |  0.056|  0.0927|small      |n.s.        |
|mnau_axial_main_mean                         |  0.054|  0.0927|small      |n.s.        |
|dominance_gap_all                            |  0.046|  0.1100|small      |n.s.        |
|effective_sections_hill1                     |  0.045|  0.1100|small      |n.s.        |
|mnau_heip_evenness                           |  0.045|  0.1100|small      |n.s.        |
|distal_appendicular_continuity_hm            |  0.041|  0.1100|small      |n.s.        |
|mnau_top2_share_mcnaughton                   |  0.040|  0.1100|small      |n.s.        |
|mnau_evenness_minus_dominance                |  0.039|  0.1100|small      |n.s.        |
|all_sections_dominance                       |  0.039|  0.1100|small      |n.s.        |
|mnau_gini                                    |  0.039|  0.1100|small      |n.s.        |
|mnau_inverse_simpson                         |  0.035|  0.1140|small      |n.s.        |
|mnau_simpson_dominance                       |  0.035|  0.1140|small      |n.s.        |
|mnau_simpson_evenness                        |  0.035|  0.1140|small      |n.s.        |
|mnau_cv                                      |  0.034|  0.1180|small      |n.s.        |
|mnau_region_mean_evenness                    |  0.031|  0.1420|small      |n.s.        |
|ProportionalRep_MNIbased_humerus             |  0.029|  0.1420|small      |n.s.        |
|mnau_foot                                    |  0.028|  0.1420|small      |n.s.        |
|mnau_distal_appendicular_mean                |  0.028|  0.1420|small      |n.s.        |
|mnau_column_trunk_mean                       |  0.027|  0.1420|small      |n.s.        |
|low_density_survival_index                   |  0.027|  0.1420|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.023|  0.1720|small      |n.s.        |
|mnau_dominance_of_region_means               |  0.023|  0.1720|small      |n.s.        |
|lower_appendicular_continuity_hm             |  0.023|  0.1720|small      |n.s.        |
|mnau_postcranial_total_mean                  |  0.021|  0.1880|small      |n.s.        |
|mnau_arms                                    |  0.020|  0.1920|small      |n.s.        |
|mnau_lower_appendicular_mean                 |  0.019|  0.2060|small      |n.s.        |
|mne_cranial_share                            |  0.018|  0.2110|small      |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.017|  0.2110|small      |n.s.        |
|mnau_legs                                    |  0.014|  0.2440|small      |n.s.        |
|mnau_hands                                   |  0.014|  0.2440|small      |n.s.        |
|mnau_appendicular_mean                       |  0.013|  0.2580|small      |n.s.        |
|ProportionalRep_MNIbased_fibula              |  0.013|  0.2640|small      |n.s.        |
|dominant_axial_share                         |  0.012|  0.2640|small      |n.s.        |
|ProportionalRep_MNIbased_metacarpal          |  0.012|  0.2640|small      |n.s.        |
|mnau_proximal_appendicular_mean              |  0.011|  0.2680|small      |n.s.        |
|ReMNAU_cervical                              |  0.011|  0.2680|small      |n.s.        |
|mnau_upper_appendicular_mean                 |  0.009|  0.2950|negligible |n.s.        |
|ReMNAU_ulna                                  |  0.003|  0.4430|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.002|  0.4710|negligible |n.s.        |
|ProportionalRep_MNIbased_cervical            |  0.000|  0.5250|negligible |n.s.        |
|ProportionalRep_MNIbased_femur               | -0.001|  0.5600|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.002|  0.5800|negligible |n.s.        |
|mnau_pelvic                                  | -0.004|  0.6710|negligible |n.s.        |
|mnau_girdle_mean                             | -0.004|  0.6850|negligible |n.s.        |
|ReMNAU_radius                                | -0.006|  0.7330|negligible |n.s.        |
|lower_appendicular_evenness                  | -0.007|  0.7160|negligible |n.s.        |
|lower_appendicular_evenness_refined          | -0.007|  0.7160|negligible |n.s.        |
|ProportionalRep_MNIbased_radius              | -0.007|  0.7570|negligible |n.s.        |
|mnau_shoulder                                | -0.008|  0.7570|negligible |n.s.        |
|ProportionalRep_MNIbased_carpal              | -0.008|  0.7570|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.008|  0.7570|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.008|  0.7570|negligible |n.s.        |
|ProportionalRep_MNIbased_os_coxae            | -0.008|  0.7570|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.010|  0.8050|negligible |n.s.        |
|appendicular_dominance                       | -0.011|  0.7800|negligible |n.s.        |
|appendicular_dominance_refined               | -0.011|  0.7800|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.011|  0.8540|negligible |n.s.        |
|ProportionalRep_MNIbased_clavicle            | -0.012|  0.8760|negligible |n.s.        |
|postcranial_dominance_refined                | -0.012|  0.8340|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.013|  0.9740|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature  |Contrast                               |     Z|  p (adj)|Sig |
|:--------|:--------------------------------------|-----:|--------:|:---|
|mne_arms |Late Pleistocene vs Holocene           |  4.08| 0.000134|*** |
|mne_arms |Late Pleistocene vs Middle Pleistocene |  1.12| 0.262000|ns  |
|mne_arms |Holocene vs Middle Pleistocene         | -1.42| 0.231000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 1.64, R² = 0.027, p = 0.1317.
PCA variance explained: PC1 56.9%, PC2 8.5%, PC3 6.3% (cumulative 71.7%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160| -0.138| -0.019|
|mnau_appendicular_mean      | -0.160| -0.135|  0.030|
|mnau_top2_share_mcnaughton  |  0.159| -0.137|  0.001|
|mnau_gini                   |  0.158| -0.116| -0.012|
|mnau_heip_evenness          | -0.158|  0.130|  0.006|
|effective_sections_hill1    | -0.158|  0.130|  0.006|
|mnau_inverse_simpson        | -0.158|  0.104|  0.010|
|mnau_simpson_evenness       | -0.158|  0.104|  0.010|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
