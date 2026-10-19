# Species (context-controlled)
*Automated hominin_species × skeletal-part representation*

- **Grouping column:** `hominin_species` (mode = single)
- **Groups (n):** H. sapiens = 79; H. neanderthalensis = 50; Middle Pleistocene hominin = 15; H. erectus = 5
- **Sites analysed:** 149  |  **features screened:** 50

## Hypothesis

**H:** Species-level differences may reflect different depositional histories, not anatomy alone.

**Expected pattern:** Neanderthal / earlier Homo / H. sapiens may differ, but differences may vanish after controlling for age, site type, period, context.

**Why it matters:** Interesting but risky; do not read causally unless preservation and context are controlled.


## Summary

46 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **low_density_survival_index** (ε² = 0.181, FDR p = 3.815e-05). PERMANOVA pseudo-F = 2.82, p = 0.0060; PC1–PC3 explain 74.5% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 177 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 19 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|low_density_survival_index                   |  0.181| 3.81e-05|large      |significant |
|low_density_axial_survival                   |  0.177| 3.81e-05|large      |significant |
|low_density_share                            |  0.176| 3.81e-05|large      |significant |
|mnau_axial_main_mean                         |  0.172| 3.81e-05|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.170| 3.81e-05|large      |significant |
|density_evenness                             |  0.170| 3.81e-05|large      |significant |
|mnau_postcranial_total_mean                  |  0.166| 3.81e-05|large      |significant |
|lower_appendicular_continuity_hm             |  0.162| 3.81e-05|large      |significant |
|mnau_lower_appendicular_mean                 |  0.160| 3.81e-05|large      |significant |
|mnau_appendicular_mean                       |  0.159| 3.81e-05|large      |significant |
|mnau_gini                                    |  0.157| 3.81e-05|large      |significant |
|effective_sections_hill1                     |  0.157| 3.81e-05|large      |significant |
|mnau_heip_evenness                           |  0.157| 3.81e-05|large      |significant |
|mnau_region_mean_evenness                    |  0.156| 3.81e-05|large      |significant |
|mnau_evenness_minus_dominance                |  0.155| 3.81e-05|large      |significant |
|mnau_inverse_simpson                         |  0.154| 3.81e-05|large      |significant |
|mnau_simpson_dominance                       |  0.154| 3.81e-05|large      |significant |
|mnau_simpson_evenness                        |  0.154| 3.81e-05|large      |significant |
|dominance_gap_all                            |  0.153| 3.81e-05|large      |significant |
|all_sections_dominance                       |  0.152| 3.81e-05|large      |significant |
|mne_arms                                     |  0.151| 3.81e-05|large      |significant |
|mnau_column_trunk_mean                       |  0.151| 3.81e-05|large      |significant |
|mnau_cv                                      |  0.151| 3.81e-05|large      |significant |
|mnau_dominance_of_region_means               |  0.150| 3.81e-05|large      |significant |
|mnau_upper_appendicular_mean                 |  0.148| 3.81e-05|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.148| 3.81e-05|large      |significant |
|mnau_proximal_appendicular_mean              |  0.148| 3.81e-05|large      |significant |
|distal_appendicular_continuity_hm            |  0.146| 4.05e-05|large      |significant |
|mnau_distal_appendicular_mean                |  0.143| 4.82e-05|large      |significant |
|mnau_legs                                    |  0.143| 4.82e-05|large      |significant |
|mnau_foot                                    |  0.134| 8.32e-05|moderate   |significant |
|mnau_girdle_mean                             |  0.128| 1.29e-04|moderate   |significant |
|mnau_arms                                    |  0.125| 1.49e-04|moderate   |significant |
|mne_cranial_share                            |  0.107| 5.12e-04|moderate   |significant |
|mnau_arms_legs_diff                          |  0.102| 6.81e-04|moderate   |significant |
|mnau_shoulder                                |  0.102| 6.81e-04|moderate   |significant |
|mnau_hands                                   |  0.088| 1.66e-03|moderate   |significant |
|dominant_axial_share                         |  0.087| 1.75e-03|moderate   |significant |
|mnau_vertebrae_to_thorax_ratio               |  0.078| 3.29e-03|moderate   |significant |
|appendicular_dominance                       |  0.069| 1.08e-02|moderate   |significant |
|appendicular_dominance_refined               |  0.069| 1.08e-02|moderate   |significant |
|mnau_pelvic                                  |  0.069| 5.69e-03|moderate   |significant |
|postcranial_dominance_refined                |  0.059| 1.91e-02|small      |significant |
|lower_appendicular_evenness                  |  0.049| 3.45e-02|small      |significant |
|lower_appendicular_evenness_refined          |  0.049| 3.45e-02|small      |significant |
|density_adjusted_appendicular_axial_contrast |  0.041| 3.45e-02|small      |significant |
|mne_vertebrae_to_thorax_ratio                |  0.015| 1.74e-01|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.009| 2.32e-01|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.009| 2.32e-01|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.014| 7.96e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                                      |Contrast                                          |     Z|  p (adj)|Sig |
|:--------------------------------------------|:-------------------------------------------------|-----:|--------:|:---|
|all_sections_dominance                       |H. sapiens vs H. neanderthalensis                 |  3.26| 0.003400|**  |
|all_sections_dominance                       |H. sapiens vs Middle Pleistocene hominin          |  3.12| 0.003600|**  |
|all_sections_dominance                       |H. sapiens vs H. erectus                          |  3.50| 0.002810|**  |
|all_sections_dominance                       |H. neanderthalensis vs Middle Pleistocene hominin |  0.96| 0.338000|ns  |
|all_sections_dominance                       |H. neanderthalensis vs H. erectus                 |  2.17| 0.045600|*   |
|all_sections_dominance                       |Middle Pleistocene hominin vs H. erectus          |  1.42| 0.186000|ns  |
|appendicular_dominance                       |H. sapiens vs H. neanderthalensis                 |  2.52| 0.041000|*   |
|appendicular_dominance                       |H. sapiens vs Middle Pleistocene hominin          |  0.94| 0.415000|ns  |
|appendicular_dominance                       |H. sapiens vs H. erectus                          |  2.47| 0.041000|*   |
|appendicular_dominance                       |H. neanderthalensis vs Middle Pleistocene hominin | -0.44| 0.658000|ns  |
|appendicular_dominance                       |H. neanderthalensis vs H. erectus                 |  1.75| 0.119000|ns  |
|appendicular_dominance                       |Middle Pleistocene hominin vs H. erectus          |  1.84| 0.119000|ns  |
|appendicular_dominance_refined               |H. sapiens vs H. neanderthalensis                 |  2.52| 0.041000|*   |
|appendicular_dominance_refined               |H. sapiens vs Middle Pleistocene hominin          |  0.94| 0.415000|ns  |
|appendicular_dominance_refined               |H. sapiens vs H. erectus                          |  2.47| 0.041000|*   |
|appendicular_dominance_refined               |H. neanderthalensis vs Middle Pleistocene hominin | -0.44| 0.658000|ns  |
|appendicular_dominance_refined               |H. neanderthalensis vs H. erectus                 |  1.75| 0.119000|ns  |
|appendicular_dominance_refined               |Middle Pleistocene hominin vs H. erectus          |  1.84| 0.119000|ns  |
|density_adjusted_appendicular_axial_contrast |H. sapiens vs H. neanderthalensis                 | -1.41| 0.237000|ns  |
|density_adjusted_appendicular_axial_contrast |H. sapiens vs Middle Pleistocene hominin          | -1.01| 0.377000|ns  |
|density_adjusted_appendicular_axial_contrast |H. sapiens vs H. erectus                          | -2.76| 0.034700|*   |
|density_adjusted_appendicular_axial_contrast |H. neanderthalensis vs Middle Pleistocene hominin | -0.10| 0.922000|ns  |
|density_adjusted_appendicular_axial_contrast |H. neanderthalensis vs H. erectus                 | -2.17| 0.090000|ns  |
|density_adjusted_appendicular_axial_contrast |Middle Pleistocene hominin vs H. erectus          | -1.92| 0.111000|ns  |
|density_evenness                             |H. sapiens vs H. neanderthalensis                 | -3.76| 0.001040|**  |
|density_evenness                             |H. sapiens vs Middle Pleistocene hominin          | -3.15| 0.003230|**  |
|density_evenness                             |H. sapiens vs H. erectus                          | -3.47| 0.001560|**  |
|density_evenness                             |H. neanderthalensis vs Middle Pleistocene hominin | -0.68| 0.497000|ns  |
|density_evenness                             |H. neanderthalensis vs H. erectus                 | -1.94| 0.078100|ns  |
|density_evenness                             |Middle Pleistocene hominin vs H. erectus          | -1.38| 0.202000|ns  |
|distal_appendicular_continuity_hm            |H. sapiens vs H. neanderthalensis                 | -3.83| 0.000760|*** |
|distal_appendicular_continuity_hm            |H. sapiens vs Middle Pleistocene hominin          | -2.03| 0.061000|ns  |
|distal_appendicular_continuity_hm            |H. sapiens vs H. erectus                          | -3.49| 0.001460|**  |
|distal_appendicular_continuity_hm            |H. neanderthalensis vs Middle Pleistocene hominin |  0.41| 0.682000|ns  |
|distal_appendicular_continuity_hm            |H. neanderthalensis vs H. erectus                 | -1.95| 0.061000|ns  |
|distal_appendicular_continuity_hm            |Middle Pleistocene hominin vs H. erectus          | -2.01| 0.061000|ns  |
|dominance_gap_all                            |H. sapiens vs H. neanderthalensis                 |  3.20| 0.002770|**  |
|dominance_gap_all                            |H. sapiens vs Middle Pleistocene hominin          |  3.20| 0.002770|**  |
|dominance_gap_all                            |H. sapiens vs H. erectus                          |  3.50| 0.002740|**  |
|dominance_gap_all                            |H. neanderthalensis vs Middle Pleistocene hominin |  1.07| 0.283000|ns  |
|dominance_gap_all                            |H. neanderthalensis vs H. erectus                 |  2.19| 0.042300|*   |
|dominance_gap_all                            |Middle Pleistocene hominin vs H. erectus          |  1.38| 0.200000|ns  |
|dominant_axial_share                         |H. sapiens vs H. neanderthalensis                 |  1.53| 0.151000|ns  |
|dominant_axial_share                         |H. sapiens vs Middle Pleistocene hominin          |  2.31| 0.041400|*   |
|dominant_axial_share                         |H. sapiens vs H. erectus                          |  3.37| 0.004500|**  |
|dominant_axial_share                         |H. neanderthalensis vs Middle Pleistocene hominin |  1.27| 0.203000|ns  |
|dominant_axial_share                         |H. neanderthalensis vs H. erectus                 |  2.72| 0.019400|*   |
|dominant_axial_share                         |Middle Pleistocene hominin vs H. erectus          |  1.75| 0.121000|ns  |
|effective_sections_hill1                     |H. sapiens vs H. neanderthalensis                 | -3.55| 0.001230|**  |
|effective_sections_hill1                     |H. sapiens vs Middle Pleistocene hominin          | -2.89| 0.007740|**  |
|effective_sections_hill1                     |H. sapiens vs H. erectus                          | -3.53| 0.001230|**  |
|effective_sections_hill1                     |H. neanderthalensis vs Middle Pleistocene hominin | -0.56| 0.578000|ns  |
|effective_sections_hill1                     |H. neanderthalensis vs H. erectus                 | -2.09| 0.055500|ns  |
|effective_sections_hill1                     |Middle Pleistocene hominin vs H. erectus          | -1.58| 0.137000|ns  |
|low_density_axial_survival                   |H. sapiens vs H. neanderthalensis                 | -4.14| 0.000211|*** |
|low_density_axial_survival                   |H. sapiens vs Middle Pleistocene hominin          | -2.94| 0.006530|**  |
|low_density_axial_survival                   |H. sapiens vs H. erectus                          | -3.47| 0.001570|**  |
|low_density_axial_survival                   |H. neanderthalensis vs Middle Pleistocene hominin | -0.28| 0.783000|ns  |
|low_density_axial_survival                   |H. neanderthalensis vs H. erectus                 | -1.82| 0.104000|ns  |
|low_density_axial_survival                   |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.163000|ns  |
|low_density_share                            |H. sapiens vs H. neanderthalensis                 | -3.78| 0.000920|*** |
|low_density_share                            |H. sapiens vs Middle Pleistocene hominin          | -3.16| 0.003130|**  |
|low_density_share                            |H. sapiens vs H. erectus                          | -3.61| 0.000920|*** |
|low_density_share                            |H. neanderthalensis vs Middle Pleistocene hominin | -0.67| 0.501000|ns  |
|low_density_share                            |H. neanderthalensis vs H. erectus                 | -2.07| 0.057700|ns  |
|low_density_share                            |Middle Pleistocene hominin vs H. erectus          | -1.50| 0.161000|ns  |
|low_density_survival_index                   |H. sapiens vs H. neanderthalensis                 | -4.15| 0.000201|*** |
|low_density_survival_index                   |H. sapiens vs Middle Pleistocene hominin          | -2.87| 0.008210|**  |
|low_density_survival_index                   |H. sapiens vs H. erectus                          | -3.61| 0.000924|*** |
|low_density_survival_index                   |H. neanderthalensis vs Middle Pleistocene hominin | -0.20| 0.842000|ns  |
|low_density_survival_index                   |H. neanderthalensis vs H. erectus                 | -1.95| 0.076800|ns  |
|low_density_survival_index                   |Middle Pleistocene hominin vs H. erectus          | -1.66| 0.117000|ns  |
|lower_appendicular_continuity_hm             |H. sapiens vs H. neanderthalensis                 | -4.06| 0.000291|*** |
|lower_appendicular_continuity_hm             |H. sapiens vs Middle Pleistocene hominin          | -2.36| 0.036100|*   |
|lower_appendicular_continuity_hm             |H. sapiens vs H. erectus                          | -3.51| 0.001350|**  |
|lower_appendicular_continuity_hm             |H. neanderthalensis vs Middle Pleistocene hominin |  0.23| 0.817000|ns  |
|lower_appendicular_continuity_hm             |H. neanderthalensis vs H. erectus                 | -1.88| 0.078300|ns  |
|lower_appendicular_continuity_hm             |Middle Pleistocene hominin vs H. erectus          | -1.84| 0.078300|ns  |
|lower_appendicular_evenness                  |H. sapiens vs H. neanderthalensis                 | -1.93| 0.107000|ns  |
|lower_appendicular_evenness                  |H. sapiens vs Middle Pleistocene hominin          |  0.77| 0.441000|ns  |
|lower_appendicular_evenness                  |H. sapiens vs H. erectus                          | -2.09| 0.107000|ns  |
|lower_appendicular_evenness                  |H. neanderthalensis vs Middle Pleistocene hominin |  1.73| 0.124000|ns  |
|lower_appendicular_evenness                  |H. neanderthalensis vs H. erectus                 | -1.52| 0.155000|ns  |
|lower_appendicular_evenness                  |Middle Pleistocene hominin vs H. erectus          | -2.25| 0.107000|ns  |
|lower_appendicular_evenness_refined          |H. sapiens vs H. neanderthalensis                 | -1.93| 0.107000|ns  |
|lower_appendicular_evenness_refined          |H. sapiens vs Middle Pleistocene hominin          |  0.77| 0.441000|ns  |
|lower_appendicular_evenness_refined          |H. sapiens vs H. erectus                          | -2.09| 0.107000|ns  |
|lower_appendicular_evenness_refined          |H. neanderthalensis vs Middle Pleistocene hominin |  1.73| 0.124000|ns  |
|lower_appendicular_evenness_refined          |H. neanderthalensis vs H. erectus                 | -1.52| 0.155000|ns  |
|lower_appendicular_evenness_refined          |Middle Pleistocene hominin vs H. erectus          | -2.25| 0.107000|ns  |
|mnau_appendicular_mean                       |H. sapiens vs H. neanderthalensis                 | -3.75| 0.000916|*** |
|mnau_appendicular_mean                       |H. sapiens vs Middle Pleistocene hominin          | -2.64| 0.016600|*   |
|mnau_appendicular_mean                       |H. sapiens vs H. erectus                          | -3.61| 0.000916|*** |
|mnau_appendicular_mean                       |H. neanderthalensis vs Middle Pleistocene hominin | -0.22| 0.825000|ns  |
|mnau_appendicular_mean                       |H. neanderthalensis vs H. erectus                 | -2.10| 0.053100|ns  |
|mnau_appendicular_mean                       |Middle Pleistocene hominin vs H. erectus          | -1.78| 0.089300|ns  |
|mnau_arms                                    |H. sapiens vs H. neanderthalensis                 | -3.06| 0.006700|**  |
|mnau_arms                                    |H. sapiens vs Middle Pleistocene hominin          | -2.68| 0.014700|*   |
|mnau_arms                                    |H. sapiens vs H. erectus                          | -3.35| 0.004780|**  |
|mnau_arms                                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.69| 0.492000|ns  |
|mnau_arms                                    |H. neanderthalensis vs H. erectus                 | -2.12| 0.051000|ns  |
|mnau_arms                                    |Middle Pleistocene hominin vs H. erectus          | -1.53| 0.150000|ns  |
|mnau_arms_legs_diff                          |H. sapiens vs H. neanderthalensis                 |  3.50| 0.002800|**  |
|mnau_arms_legs_diff                          |H. sapiens vs Middle Pleistocene hominin          |  2.29| 0.044200|*   |
|mnau_arms_legs_diff                          |H. sapiens vs H. erectus                          |  2.45| 0.043000|*   |
|mnau_arms_legs_diff                          |H. neanderthalensis vs Middle Pleistocene hominin |  0.04| 0.967000|ns  |
|mnau_arms_legs_diff                          |H. neanderthalensis vs H. erectus                 |  1.06| 0.417000|ns  |
|mnau_arms_legs_diff                          |Middle Pleistocene hominin vs H. erectus          |  0.94| 0.417000|ns  |
|mnau_axial_main_mean                         |H. sapiens vs H. neanderthalensis                 | -4.07| 0.000279|*** |
|mnau_axial_main_mean                         |H. sapiens vs Middle Pleistocene hominin          | -2.91| 0.007300|**  |
|mnau_axial_main_mean                         |H. sapiens vs H. erectus                          | -3.46| 0.001640|**  |
|mnau_axial_main_mean                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.28| 0.778000|ns  |
|mnau_axial_main_mean                         |H. neanderthalensis vs H. erectus                 | -1.83| 0.101000|ns  |
|mnau_axial_main_mean                         |Middle Pleistocene hominin vs H. erectus          | -1.50| 0.160000|ns  |
|mnau_column_trunk_mean                       |H. sapiens vs H. neanderthalensis                 | -3.76| 0.001010|**  |
|mnau_column_trunk_mean                       |H. sapiens vs Middle Pleistocene hominin          | -2.54| 0.022100|*   |
|mnau_column_trunk_mean                       |H. sapiens vs H. erectus                          | -3.46| 0.001600|**  |
|mnau_column_trunk_mean                       |H. neanderthalensis vs Middle Pleistocene hominin | -0.12| 0.903000|ns  |
|mnau_column_trunk_mean                       |H. neanderthalensis vs H. erectus                 | -1.96| 0.075800|ns  |
|mnau_column_trunk_mean                       |Middle Pleistocene hominin vs H. erectus          | -1.71| 0.106000|ns  |
|mnau_cv                                      |H. sapiens vs H. neanderthalensis                 |  3.38| 0.002180|**  |
|mnau_cv                                      |H. sapiens vs Middle Pleistocene hominin          |  2.97| 0.005870|**  |
|mnau_cv                                      |H. sapiens vs H. erectus                          |  3.47| 0.002180|**  |
|mnau_cv                                      |H. neanderthalensis vs Middle Pleistocene hominin |  0.74| 0.459000|ns  |
|mnau_cv                                      |H. neanderthalensis vs H. erectus                 |  2.09| 0.054800|ns  |
|mnau_cv                                      |Middle Pleistocene hominin vs H. erectus          |  1.48| 0.167000|ns  |
|mnau_distal_appendicular_mean                |H. sapiens vs H. neanderthalensis                 | -3.62| 0.001500|**  |
|mnau_distal_appendicular_mean                |H. sapiens vs Middle Pleistocene hominin          | -2.39| 0.033600|*   |
|mnau_distal_appendicular_mean                |H. sapiens vs H. erectus                          | -3.48| 0.001500|**  |
|mnau_distal_appendicular_mean                |H. neanderthalensis vs Middle Pleistocene hominin | -0.07| 0.946000|ns  |
|mnau_distal_appendicular_mean                |H. neanderthalensis vs H. erectus                 | -2.03| 0.063600|ns  |
|mnau_distal_appendicular_mean                |Middle Pleistocene hominin vs H. erectus          | -1.80| 0.085300|ns  |
|mnau_dominance_of_region_means               |H. sapiens vs H. neanderthalensis                 |  3.06| 0.005680|**  |
|mnau_dominance_of_region_means               |H. sapiens vs Middle Pleistocene hominin          |  2.98| 0.005680|**  |
|mnau_dominance_of_region_means               |H. sapiens vs H. erectus                          |  3.68| 0.001400|**  |
|mnau_dominance_of_region_means               |H. neanderthalensis vs Middle Pleistocene hominin |  0.95| 0.343000|ns  |
|mnau_dominance_of_region_means               |H. neanderthalensis vs H. erectus                 |  2.42| 0.023300|*   |
|mnau_dominance_of_region_means               |Middle Pleistocene hominin vs H. erectus          |  1.66| 0.117000|ns  |
|mnau_evenness_minus_dominance                |H. sapiens vs H. neanderthalensis                 | -3.41| 0.001980|**  |
|mnau_evenness_minus_dominance                |H. sapiens vs Middle Pleistocene hominin          | -3.03| 0.004820|**  |
|mnau_evenness_minus_dominance                |H. sapiens vs H. erectus                          | -3.52| 0.001980|**  |
|mnau_evenness_minus_dominance                |H. neanderthalensis vs Middle Pleistocene hominin | -0.78| 0.434000|ns  |
|mnau_evenness_minus_dominance                |H. neanderthalensis vs H. erectus                 | -2.13| 0.049600|*   |
|mnau_evenness_minus_dominance                |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.163000|ns  |
|mnau_foot                                    |H. sapiens vs H. neanderthalensis                 | -3.96| 0.000454|*** |
|mnau_foot                                    |H. sapiens vs Middle Pleistocene hominin          | -1.80| 0.113000|ns  |
|mnau_foot                                    |H. sapiens vs H. erectus                          | -3.09| 0.005970|**  |
|mnau_foot                                    |H. neanderthalensis vs Middle Pleistocene hominin |  0.70| 0.481000|ns  |
|mnau_foot                                    |H. neanderthalensis vs H. erectus                 | -1.52| 0.156000|ns  |
|mnau_foot                                    |Middle Pleistocene hominin vs H. erectus          | -1.78| 0.113000|ns  |
|mnau_gini                                    |H. sapiens vs H. neanderthalensis                 |  3.53| 0.001260|**  |
|mnau_gini                                    |H. sapiens vs Middle Pleistocene hominin          |  2.92| 0.007110|**  |
|mnau_gini                                    |H. sapiens vs H. erectus                          |  3.55| 0.001260|**  |
|mnau_gini                                    |H. neanderthalensis vs Middle Pleistocene hominin |  0.59| 0.553000|ns  |
|mnau_gini                                    |H. neanderthalensis vs H. erectus                 |  2.11| 0.052700|ns  |
|mnau_gini                                    |Middle Pleistocene hominin vs H. erectus          |  1.58| 0.138000|ns  |
|mnau_girdle_mean                             |H. sapiens vs H. neanderthalensis                 | -3.60| 0.001940|**  |
|mnau_girdle_mean                             |H. sapiens vs Middle Pleistocene hominin          | -2.03| 0.084200|ns  |
|mnau_girdle_mean                             |H. sapiens vs H. erectus                          | -3.27| 0.003270|**  |
|mnau_girdle_mean                             |H. neanderthalensis vs Middle Pleistocene hominin |  0.26| 0.793000|ns  |
|mnau_girdle_mean                             |H. neanderthalensis vs H. erectus                 | -1.83| 0.084700|ns  |
|mnau_girdle_mean                             |Middle Pleistocene hominin vs H. erectus          | -1.81| 0.084700|ns  |
|mnau_hands                                   |H. sapiens vs H. neanderthalensis                 | -2.87| 0.012400|*   |
|mnau_hands                                   |H. sapiens vs Middle Pleistocene hominin          | -1.80| 0.108000|ns  |
|mnau_hands                                   |H. sapiens vs H. erectus                          | -2.99| 0.012400|*   |
|mnau_hands                                   |H. neanderthalensis vs Middle Pleistocene hominin |  0.04| 0.970000|ns  |
|mnau_hands                                   |H. neanderthalensis vs H. erectus                 | -1.83| 0.108000|ns  |
|mnau_hands                                   |Middle Pleistocene hominin vs H. erectus          | -1.69| 0.110000|ns  |
|mnau_heip_evenness                           |H. sapiens vs H. neanderthalensis                 | -3.55| 0.001230|**  |
|mnau_heip_evenness                           |H. sapiens vs Middle Pleistocene hominin          | -2.89| 0.007740|**  |
|mnau_heip_evenness                           |H. sapiens vs H. erectus                          | -3.53| 0.001230|**  |
|mnau_heip_evenness                           |H. neanderthalensis vs Middle Pleistocene hominin | -0.56| 0.578000|ns  |
|mnau_heip_evenness                           |H. neanderthalensis vs H. erectus                 | -2.09| 0.055500|ns  |
|mnau_heip_evenness                           |Middle Pleistocene hominin vs H. erectus          | -1.58| 0.137000|ns  |
|mnau_inverse_simpson                         |H. sapiens vs H. neanderthalensis                 | -3.40| 0.002020|**  |
|mnau_inverse_simpson                         |H. sapiens vs Middle Pleistocene hominin          | -3.02| 0.005050|**  |
|mnau_inverse_simpson                         |H. sapiens vs H. erectus                          | -3.51| 0.002020|**  |
|mnau_inverse_simpson                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.77| 0.440000|ns  |
|mnau_inverse_simpson                         |H. neanderthalensis vs H. erectus                 | -2.12| 0.050800|ns  |
|mnau_inverse_simpson                         |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.164000|ns  |
|mnau_legs                                    |H. sapiens vs H. neanderthalensis                 | -3.68| 0.001420|**  |
|mnau_legs                                    |H. sapiens vs Middle Pleistocene hominin          | -2.82| 0.009510|**  |
|mnau_legs                                    |H. sapiens vs H. erectus                          | -3.16| 0.004790|**  |
|mnau_legs                                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.44| 0.657000|ns  |
|mnau_legs                                    |H. neanderthalensis vs H. erectus                 | -1.69| 0.137000|ns  |
|mnau_legs                                    |Middle Pleistocene hominin vs H. erectus          | -1.28| 0.241000|ns  |
|mnau_limb_shaft_proxy_mean                   |H. sapiens vs H. neanderthalensis                 | -3.54| 0.002410|**  |
|mnau_limb_shaft_proxy_mean                   |H. sapiens vs Middle Pleistocene hominin          | -2.98| 0.005820|**  |
|mnau_limb_shaft_proxy_mean                   |H. sapiens vs H. erectus                          | -3.33| 0.002570|**  |
|mnau_limb_shaft_proxy_mean                   |H. neanderthalensis vs Middle Pleistocene hominin | -0.68| 0.499000|ns  |
|mnau_limb_shaft_proxy_mean                   |H. neanderthalensis vs H. erectus                 | -1.91| 0.083500|ns  |
|mnau_limb_shaft_proxy_mean                   |Middle Pleistocene hominin vs H. erectus          | -1.35| 0.211000|ns  |
|mnau_lower_appendicular_mean                 |H. sapiens vs H. neanderthalensis                 | -3.87| 0.000663|*** |
|mnau_lower_appendicular_mean                 |H. sapiens vs Middle Pleistocene hominin          | -2.75| 0.011800|*   |
|mnau_lower_appendicular_mean                 |H. sapiens vs H. erectus                          | -3.47| 0.001590|**  |
|mnau_lower_appendicular_mean                 |H. neanderthalensis vs Middle Pleistocene hominin | -0.26| 0.795000|ns  |
|mnau_lower_appendicular_mean                 |H. neanderthalensis vs H. erectus                 | -1.92| 0.082800|ns  |
|mnau_lower_appendicular_mean                 |Middle Pleistocene hominin vs H. erectus          | -1.59| 0.133000|ns  |
|mnau_pelvic                                  |H. sapiens vs H. neanderthalensis                 | -2.75| 0.023500|*   |
|mnau_pelvic                                  |H. sapiens vs Middle Pleistocene hominin          | -1.39| 0.197000|ns  |
|mnau_pelvic                                  |H. sapiens vs H. erectus                          | -2.66| 0.023500|*   |
|mnau_pelvic                                  |H. neanderthalensis vs Middle Pleistocene hominin |  0.36| 0.722000|ns  |
|mnau_pelvic                                  |H. neanderthalensis vs H. erectus                 | -1.56| 0.179000|ns  |
|mnau_pelvic                                  |Middle Pleistocene hominin vs H. erectus          | -1.62| 0.179000|ns  |
|mnau_postcranial_total_mean                  |H. sapiens vs H. neanderthalensis                 | -3.82| 0.000791|*** |
|mnau_postcranial_total_mean                  |H. sapiens vs Middle Pleistocene hominin          | -2.78| 0.010900|*   |
|mnau_postcranial_total_mean                  |H. sapiens vs H. erectus                          | -3.65| 0.000791|*** |
|mnau_postcranial_total_mean                  |H. neanderthalensis vs Middle Pleistocene hominin | -0.32| 0.751000|ns  |
|mnau_postcranial_total_mean                  |H. neanderthalensis vs H. erectus                 | -2.12| 0.051300|ns  |
|mnau_postcranial_total_mean                  |Middle Pleistocene hominin vs H. erectus          | -1.74| 0.097700|ns  |
|mnau_proximal_appendicular_mean              |H. sapiens vs H. neanderthalensis                 | -3.65| 0.001590|**  |
|mnau_proximal_appendicular_mean              |H. sapiens vs Middle Pleistocene hominin          | -2.70| 0.013800|*   |
|mnau_proximal_appendicular_mean              |H. sapiens vs H. erectus                          | -3.41| 0.001970|**  |
|mnau_proximal_appendicular_mean              |H. neanderthalensis vs Middle Pleistocene hominin | -0.35| 0.728000|ns  |
|mnau_proximal_appendicular_mean              |H. neanderthalensis vs H. erectus                 | -1.94| 0.077800|ns  |
|mnau_proximal_appendicular_mean              |Middle Pleistocene hominin vs H. erectus          | -1.57| 0.140000|ns  |
|mnau_region_mean_evenness                    |H. sapiens vs H. neanderthalensis                 | -3.35| 0.002470|**  |
|mnau_region_mean_evenness                    |H. sapiens vs Middle Pleistocene hominin          | -2.84| 0.008940|**  |
|mnau_region_mean_evenness                    |H. sapiens vs H. erectus                          | -3.71| 0.001240|**  |
|mnau_region_mean_evenness                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.64| 0.524000|ns  |
|mnau_region_mean_evenness                    |H. neanderthalensis vs H. erectus                 | -2.34| 0.029100|*   |
|mnau_region_mean_evenness                    |Middle Pleistocene hominin vs H. erectus          | -1.76| 0.093600|ns  |
|mnau_shoulder                                |H. sapiens vs H. neanderthalensis                 | -3.26| 0.006760|**  |
|mnau_shoulder                                |H. sapiens vs Middle Pleistocene hominin          | -1.74| 0.104000|ns  |
|mnau_shoulder                                |H. sapiens vs H. erectus                          | -3.02| 0.007660|**  |
|mnau_shoulder                                |H. neanderthalensis vs Middle Pleistocene hominin |  0.33| 0.740000|ns  |
|mnau_shoulder                                |H. neanderthalensis vs H. erectus                 | -1.71| 0.104000|ns  |
|mnau_shoulder                                |Middle Pleistocene hominin vs H. erectus          | -1.74| 0.104000|ns  |
|mnau_simpson_dominance                       |H. sapiens vs H. neanderthalensis                 |  3.40| 0.002020|**  |
|mnau_simpson_dominance                       |H. sapiens vs Middle Pleistocene hominin          |  3.02| 0.005050|**  |
|mnau_simpson_dominance                       |H. sapiens vs H. erectus                          |  3.51| 0.002020|**  |
|mnau_simpson_dominance                       |H. neanderthalensis vs Middle Pleistocene hominin |  0.77| 0.440000|ns  |
|mnau_simpson_dominance                       |H. neanderthalensis vs H. erectus                 |  2.12| 0.050800|ns  |
|mnau_simpson_dominance                       |Middle Pleistocene hominin vs H. erectus          |  1.49| 0.164000|ns  |
|mnau_simpson_evenness                        |H. sapiens vs H. neanderthalensis                 | -3.40| 0.002020|**  |
|mnau_simpson_evenness                        |H. sapiens vs Middle Pleistocene hominin          | -3.02| 0.005050|**  |
|mnau_simpson_evenness                        |H. sapiens vs H. erectus                          | -3.51| 0.002020|**  |
|mnau_simpson_evenness                        |H. neanderthalensis vs Middle Pleistocene hominin | -0.77| 0.440000|ns  |
|mnau_simpson_evenness                        |H. neanderthalensis vs H. erectus                 | -2.12| 0.050800|ns  |
|mnau_simpson_evenness                        |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.164000|ns  |
|mnau_top2_share_mcnaughton                   |H. sapiens vs H. neanderthalensis                 |  3.59| 0.001000|**  |
|mnau_top2_share_mcnaughton                   |H. sapiens vs Middle Pleistocene hominin          |  3.02| 0.005000|**  |
|mnau_top2_share_mcnaughton                   |H. sapiens vs H. erectus                          |  3.72| 0.001000|**  |
|mnau_top2_share_mcnaughton                   |H. neanderthalensis vs Middle Pleistocene hominin |  0.66| 0.510000|ns  |
|mnau_top2_share_mcnaughton                   |H. neanderthalensis vs H. erectus                 |  2.26| 0.036000|*   |
|mnau_top2_share_mcnaughton                   |Middle Pleistocene hominin vs H. erectus          |  1.68| 0.112000|ns  |
|mnau_upper_appendicular_mean                 |H. sapiens vs H. neanderthalensis                 | -3.64| 0.000865|*** |
|mnau_upper_appendicular_mean                 |H. sapiens vs Middle Pleistocene hominin          | -2.32| 0.040700|*   |
|mnau_upper_appendicular_mean                 |H. sapiens vs H. erectus                          | -3.63| 0.000865|*** |
|mnau_upper_appendicular_mean                 |H. neanderthalensis vs Middle Pleistocene hominin |  0.01| 0.989000|ns  |
|mnau_upper_appendicular_mean                 |H. neanderthalensis vs H. erectus                 | -2.16| 0.045800|*   |
|mnau_upper_appendicular_mean                 |Middle Pleistocene hominin vs H. erectus          | -1.97| 0.058300|ns  |
|mnau_vertebrae_to_thorax_ratio               |H. sapiens vs H. neanderthalensis                 | -3.39| 0.004150|**  |
|mnau_vertebrae_to_thorax_ratio               |H. sapiens vs Middle Pleistocene hominin          | -0.55| 0.582000|ns  |
|mnau_vertebrae_to_thorax_ratio               |H. sapiens vs H. erectus                          | -2.11| 0.106000|ns  |
|mnau_vertebrae_to_thorax_ratio               |H. neanderthalensis vs Middle Pleistocene hominin |  1.56| 0.180000|ns  |
|mnau_vertebrae_to_thorax_ratio               |H. neanderthalensis vs H. erectus                 | -0.76| 0.534000|ns  |
|mnau_vertebrae_to_thorax_ratio               |Middle Pleistocene hominin vs H. erectus          | -1.58| 0.180000|ns  |
|mne_arms                                     |H. sapiens vs H. neanderthalensis                 | -4.11| 0.000236|*** |
|mne_arms                                     |H. sapiens vs Middle Pleistocene hominin          | -1.38| 0.202000|ns  |
|mne_arms                                     |H. sapiens vs H. erectus                          | -3.42| 0.001910|**  |
|mne_arms                                     |H. neanderthalensis vs Middle Pleistocene hominin |  1.20| 0.228000|ns  |
|mne_arms                                     |H. neanderthalensis vs H. erectus                 | -1.77| 0.114000|ns  |
|mne_arms                                     |Middle Pleistocene hominin vs H. erectus          | -2.30| 0.043000|*   |
|mne_cranial_share                            |H. sapiens vs H. neanderthalensis                 |  2.14| 0.048600|*   |
|mne_cranial_share                            |H. sapiens vs Middle Pleistocene hominin          |  2.54| 0.021900|*   |
|mne_cranial_share                            |H. sapiens vs H. erectus                          |  3.51| 0.002690|**  |
|mne_cranial_share                            |H. neanderthalensis vs Middle Pleistocene hominin |  1.12| 0.262000|ns  |
|mne_cranial_share                            |H. neanderthalensis vs H. erectus                 |  2.63| 0.021900|*   |
|mne_cranial_share                            |Middle Pleistocene hominin vs H. erectus          |  1.75| 0.096800|ns  |
|postcranial_dominance_refined                |H. sapiens vs H. neanderthalensis                 |  2.11| 0.104000|ns  |
|postcranial_dominance_refined                |H. sapiens vs Middle Pleistocene hominin          |  1.26| 0.250000|ns  |
|postcranial_dominance_refined                |H. sapiens vs H. erectus                          |  2.46| 0.083100|ns  |
|postcranial_dominance_refined                |H. neanderthalensis vs Middle Pleistocene hominin |  0.08| 0.939000|ns  |
|postcranial_dominance_refined                |H. neanderthalensis vs H. erectus                 |  1.86| 0.126000|ns  |
|postcranial_dominance_refined                |Middle Pleistocene hominin vs H. erectus          |  1.69| 0.137000|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.82, R² = 0.067, p = 0.0060.
PCA variance explained: PC1 60.5%, PC2 8.1%, PC3 5.8% (cumulative 74.5%).
Dispersion caveat (PERMDISP): p = 0.003 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton    |  0.178|  0.111| -0.032|
|mnau_gini                     |  0.177|  0.108| -0.037|
|mnau_inverse_simpson          | -0.176| -0.082|  0.033|
|mnau_simpson_evenness         | -0.176| -0.082|  0.033|
|mnau_heip_evenness            | -0.176| -0.120|  0.026|
|effective_sections_hill1      | -0.176| -0.120|  0.026|
|mnau_cv                       |  0.174|  0.157|  0.005|
|mnau_evenness_minus_dominance | -0.174| -0.160| -0.007|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
