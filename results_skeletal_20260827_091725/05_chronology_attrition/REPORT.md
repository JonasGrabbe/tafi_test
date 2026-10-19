# Time depth / attrition
*Automated geological_period × skeletal-part representation*

- **Grouping column:** `geological_period` (mode = alternative)
- **Groups (n):** Late Pleistocene = 86; Holocene = 48; Middle Pleistocene = 15
- **Sites analysed:** 149  |  **features screened:** 50

## Hypothesis

**H:** Older assemblages are more altered by long-term attrition and recovery bias.

**Expected pattern:** Earlier Pleistocene contexts lose fragile elements and over-represent teeth, cranial pieces, dense shafts; Holocene burials more complete.

**Why it matters:** Tests time-depth and preservation intensity (must be read alongside context).


## Summary

1 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.101, FDR p = 0.01185). PERMANOVA pseudo-F = 1.33, p = 0.2288; PC1–PC3 explain 74.5% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 143 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 29 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.101|  0.0118|moderate   |significant |
|density_evenness                             |  0.063|  0.0588|moderate   |n.s.        |
|low_density_axial_survival                   |  0.058|  0.0588|small      |n.s.        |
|low_density_share                            |  0.057|  0.0588|small      |n.s.        |
|mnau_axial_main_mean                         |  0.057|  0.0588|small      |n.s.        |
|dominance_gap_all                            |  0.043|  0.0734|small      |n.s.        |
|effective_sections_hill1                     |  0.043|  0.0734|small      |n.s.        |
|mnau_heip_evenness                           |  0.043|  0.0734|small      |n.s.        |
|mnau_evenness_minus_dominance                |  0.041|  0.0734|small      |n.s.        |
|distal_appendicular_continuity_hm            |  0.041|  0.0734|small      |n.s.        |
|mnau_gini                                    |  0.040|  0.0734|small      |n.s.        |
|low_density_survival_index                   |  0.039|  0.0734|small      |n.s.        |
|mnau_inverse_simpson                         |  0.039|  0.0734|small      |n.s.        |
|mnau_simpson_dominance                       |  0.039|  0.0734|small      |n.s.        |
|mnau_simpson_evenness                        |  0.039|  0.0734|small      |n.s.        |
|mnau_cv                                      |  0.038|  0.0734|small      |n.s.        |
|all_sections_dominance                       |  0.036|  0.0800|small      |n.s.        |
|mnau_region_mean_evenness                    |  0.033|  0.0921|small      |n.s.        |
|mnau_top2_share_mcnaughton                   |  0.033|  0.0921|small      |n.s.        |
|mnau_distal_appendicular_mean                |  0.028|  0.1150|small      |n.s.        |
|mnau_foot                                    |  0.028|  0.1150|small      |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.026|  0.1240|small      |n.s.        |
|mnau_dominance_of_region_means               |  0.025|  0.1290|small      |n.s.        |
|lower_appendicular_continuity_hm             |  0.023|  0.1480|small      |n.s.        |
|mnau_arms                                    |  0.020|  0.1680|small      |n.s.        |
|mnau_column_trunk_mean                       |  0.019|  0.1720|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.018|  0.1720|small      |n.s.        |
|mnau_postcranial_total_mean                  |  0.018|  0.1720|small      |n.s.        |
|mnau_lower_appendicular_mean                 |  0.018|  0.1720|small      |n.s.        |
|mnau_hands                                   |  0.015|  0.2060|small      |n.s.        |
|mnau_legs                                    |  0.014|  0.2060|small      |n.s.        |
|mnau_appendicular_mean                       |  0.012|  0.2310|small      |n.s.        |
|mnau_upper_appendicular_mean                 |  0.012|  0.2330|small      |n.s.        |
|mnau_proximal_appendicular_mean              |  0.011|  0.2330|small      |n.s.        |
|mnau_arms_legs_diff                          |  0.011|  0.2330|small      |n.s.        |
|mne_cranial_share                            |  0.009|  0.2600|negligible |n.s.        |
|dominant_axial_share                         |  0.005|  0.3430|negligible |n.s.        |
|mnau_arms_legs_logratio                      |  0.002|  0.3920|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.002|  0.3920|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.002|  0.3920|negligible |n.s.        |
|mnau_girdle_mean                             | -0.002|  0.5320|negligible |n.s.        |
|mnau_shoulder                                | -0.007|  0.7450|negligible |n.s.        |
|mnau_pelvic                                  | -0.009|  0.7980|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.010|  0.8430|negligible |n.s.        |
|lower_appendicular_evenness                  | -0.012|  0.8190|negligible |n.s.        |
|lower_appendicular_evenness_refined          | -0.012|  0.8190|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.013|  0.9740|negligible |n.s.        |
|postcranial_dominance_refined                | -0.014|  0.9110|negligible |n.s.        |
|appendicular_dominance                       | -0.014|  0.9110|negligible |n.s.        |
|appendicular_dominance_refined               | -0.014|  0.9110|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature  |Contrast                               |     Z|  p (adj)|Sig |
|:--------|:--------------------------------------|-----:|--------:|:---|
|mne_arms |Late Pleistocene vs Holocene           |  4.08| 0.000134|*** |
|mne_arms |Late Pleistocene vs Middle Pleistocene |  1.12| 0.262000|ns  |
|mne_arms |Holocene vs Middle Pleistocene         | -1.42| 0.231000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 1.33, R² = 0.022, p = 0.2288.
PCA variance explained: PC1 60.7%, PC2 8.0%, PC3 5.8% (cumulative 74.5%).
Dispersion caveat (PERMDISP): p = 0.000 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton    |  0.178|  0.109| -0.032|
|mnau_gini                     |  0.177|  0.106| -0.037|
|mnau_inverse_simpson          | -0.176| -0.080|  0.033|
|mnau_simpson_evenness         | -0.176| -0.080|  0.033|
|mnau_heip_evenness            | -0.176| -0.118|  0.026|
|effective_sections_hill1      | -0.176| -0.118|  0.026|
|mnau_cv                       |  0.174|  0.157|  0.006|
|mnau_evenness_minus_dominance | -0.174| -0.160| -0.008|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
