# Research-history / sampling bias
*Automated region × skeletal-part representation*

- **Grouping column:** `region` (mode = alternative)
- **Groups (n):** West Europe = 107; Central Europe = 12; Europe = 7; West Asia = 7; Southeast Asia = 5
- **Sites analysed:** 138  |  **features screened:** 50

## Hypothesis

**H:** Regional research history, geology, climate and excavation tradition affect recovery.

**Expected pattern:** Some regions more complete (cave preservation/modern excavation); others biased to diagnostic cranial/dental material.

**Why it matters:** Detects sampling and research-history bias; weaker as a behavioural hypothesis.


## Summary

39 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_distal_appendicular_mean** (ε² = 0.165, FDR p = 0.00126). PERMANOVA pseudo-F = 2.61, p = 0.0058; PC1–PC3 explain 74.7% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 148 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 15 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mnau_distal_appendicular_mean                |  0.165| 0.00126|large      |significant |
|mne_arms                                     |  0.158| 0.00126|large      |significant |
|distal_appendicular_continuity_hm            |  0.150| 0.00133|large      |significant |
|mnau_foot                                    |  0.136| 0.00245|moderate   |significant |
|mnau_hands                                   |  0.112| 0.00782|moderate   |significant |
|mnau_region_mean_evenness                    |  0.111| 0.00782|moderate   |significant |
|lower_appendicular_continuity_hm             |  0.104| 0.00850|moderate   |significant |
|lower_appendicular_evenness                  |  0.103| 0.01000|moderate   |significant |
|lower_appendicular_evenness_refined          |  0.103| 0.01000|moderate   |significant |
|effective_sections_hill1                     |  0.102| 0.00850|moderate   |significant |
|mnau_heip_evenness                           |  0.102| 0.00850|moderate   |significant |
|mnau_gini                                    |  0.101| 0.00850|moderate   |significant |
|appendicular_dominance                       |  0.098| 0.01000|moderate   |significant |
|appendicular_dominance_refined               |  0.098| 0.01000|moderate   |significant |
|mnau_top2_share_mcnaughton                   |  0.095| 0.01000|moderate   |significant |
|postcranial_dominance_refined                |  0.092| 0.01100|moderate   |significant |
|low_density_survival_index                   |  0.088| 0.01000|moderate   |significant |
|mnau_upper_appendicular_mean                 |  0.088| 0.01000|moderate   |significant |
|mnau_axial_main_mean                         |  0.087| 0.01000|moderate   |significant |
|mnau_evenness_minus_dominance                |  0.085| 0.01000|moderate   |significant |
|low_density_axial_survival                   |  0.085| 0.01000|moderate   |significant |
|mnau_inverse_simpson                         |  0.085| 0.01000|moderate   |significant |
|mnau_simpson_dominance                       |  0.085| 0.01000|moderate   |significant |
|mnau_simpson_evenness                        |  0.085| 0.01000|moderate   |significant |
|mnau_shoulder                                |  0.083| 0.01000|moderate   |significant |
|mnau_dominance_of_region_means               |  0.082| 0.01060|moderate   |significant |
|mnau_column_trunk_mean                       |  0.080| 0.01060|moderate   |significant |
|mnau_cv                                      |  0.080| 0.01070|moderate   |significant |
|mnau_postcranial_total_mean                  |  0.079| 0.01070|moderate   |significant |
|mnau_appendicular_mean                       |  0.077| 0.01100|moderate   |significant |
|mnau_girdle_mean                             |  0.075| 0.01170|moderate   |significant |
|mnau_pelvic                                  |  0.074| 0.01200|moderate   |significant |
|all_sections_dominance                       |  0.067| 0.01850|moderate   |significant |
|mnau_lower_appendicular_mean                 |  0.065| 0.01940|moderate   |significant |
|low_density_share                            |  0.064| 0.02070|moderate   |significant |
|density_adjusted_appendicular_axial_contrast |  0.058| 0.02760|small      |significant |
|density_evenness                             |  0.056| 0.03190|small      |significant |
|mnau_arms                                    |  0.048| 0.04630|small      |significant |
|mnau_proximal_appendicular_mean              |  0.046| 0.04860|small      |significant |
|dominance_gap_all                            |  0.045| 0.05260|small      |n.s.        |
|mne_cranial_share                            |  0.044| 0.05260|small      |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.040| 0.06420|small      |n.s.        |
|dominant_axial_share                         |  0.037| 0.07350|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.028| 0.11500|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.023| 0.14900|small      |n.s.        |
|mnau_legs                                    |  0.019| 0.17500|small      |n.s.        |
|mne_arms_to_legs_ratio                       | -0.004| 0.50700|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.008| 0.60400|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.016| 0.75700|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.016| 0.75700|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                                      |Contrast                         |     Z|  p (adj)|Sig |
|:--------------------------------------------|:--------------------------------|-----:|--------:|:---|
|all_sections_dominance                       |West Europe vs Central Europe    |  0.41| 0.683000|ns  |
|all_sections_dominance                       |West Europe vs Europe            | -1.39| 0.205000|ns  |
|all_sections_dominance                       |West Europe vs West Asia         | -2.05| 0.100000|ns  |
|all_sections_dominance                       |West Europe vs Southeast Asia    |  2.41| 0.052600|ns  |
|all_sections_dominance                       |Central Europe vs Europe         | -1.40| 0.205000|ns  |
|all_sections_dominance                       |Central Europe vs West Asia      | -1.95| 0.103000|ns  |
|all_sections_dominance                       |Central Europe vs Southeast Asia |  1.84| 0.109000|ns  |
|all_sections_dominance                       |Europe vs West Asia              | -0.48| 0.683000|ns  |
|all_sections_dominance                       |Europe vs Southeast Asia         |  2.81| 0.024400|*   |
|all_sections_dominance                       |West Asia vs Southeast Asia      |  3.26| 0.011300|*   |
|appendicular_dominance                       |West Europe vs Central Europe    | -1.73| 0.138000|ns  |
|appendicular_dominance                       |West Europe vs Europe            | -1.64| 0.145000|ns  |
|appendicular_dominance                       |West Europe vs West Asia         | -1.93| 0.108000|ns  |
|appendicular_dominance                       |West Europe vs Southeast Asia    |  2.37| 0.044600|*   |
|appendicular_dominance                       |Central Europe vs Europe         | -0.07| 0.942000|ns  |
|appendicular_dominance                       |Central Europe vs West Asia      | -0.30| 0.924000|ns  |
|appendicular_dominance                       |Central Europe vs Southeast Asia |  2.99| 0.010800|*   |
|appendicular_dominance                       |Europe vs West Asia              | -0.21| 0.924000|ns  |
|appendicular_dominance                       |Europe vs Southeast Asia         |  2.95| 0.010800|*   |
|appendicular_dominance                       |West Asia vs Southeast Asia      |  3.11| 0.010800|*   |
|appendicular_dominance_refined               |West Europe vs Central Europe    | -1.73| 0.138000|ns  |
|appendicular_dominance_refined               |West Europe vs Europe            | -1.64| 0.145000|ns  |
|appendicular_dominance_refined               |West Europe vs West Asia         | -1.93| 0.108000|ns  |
|appendicular_dominance_refined               |West Europe vs Southeast Asia    |  2.37| 0.044600|*   |
|appendicular_dominance_refined               |Central Europe vs Europe         | -0.07| 0.942000|ns  |
|appendicular_dominance_refined               |Central Europe vs West Asia      | -0.30| 0.924000|ns  |
|appendicular_dominance_refined               |Central Europe vs Southeast Asia |  2.99| 0.010800|*   |
|appendicular_dominance_refined               |Europe vs West Asia              | -0.21| 0.924000|ns  |
|appendicular_dominance_refined               |Europe vs Southeast Asia         |  2.95| 0.010800|*   |
|appendicular_dominance_refined               |West Asia vs Southeast Asia      |  3.11| 0.010800|*   |
|density_adjusted_appendicular_axial_contrast |West Europe vs Central Europe    | -1.73| 0.207000|ns  |
|density_adjusted_appendicular_axial_contrast |West Europe vs Europe            |  2.48| 0.043600|*   |
|density_adjusted_appendicular_axial_contrast |West Europe vs West Asia         |  0.36| 0.796000|ns  |
|density_adjusted_appendicular_axial_contrast |West Europe vs Southeast Asia    | -1.25| 0.277000|ns  |
|density_adjusted_appendicular_axial_contrast |Central Europe vs Europe         |  3.15| 0.016600|*   |
|density_adjusted_appendicular_axial_contrast |Central Europe vs West Asia      |  1.41| 0.265000|ns  |
|density_adjusted_appendicular_axial_contrast |Central Europe vs Southeast Asia | -0.09| 0.931000|ns  |
|density_adjusted_appendicular_axial_contrast |Europe vs West Asia              | -1.55| 0.244000|ns  |
|density_adjusted_appendicular_axial_contrast |Europe vs Southeast Asia         | -2.63| 0.042300|*   |
|density_adjusted_appendicular_axial_contrast |West Asia vs Southeast Asia      | -1.22| 0.277000|ns  |
|density_evenness                             |West Europe vs Central Europe    | -0.06| 0.953000|ns  |
|density_evenness                             |West Europe vs Europe            |  1.28| 0.285000|ns  |
|density_evenness                             |West Europe vs West Asia         |  1.98| 0.109000|ns  |
|density_evenness                             |West Europe vs Southeast Asia    | -2.28| 0.075900|ns  |
|density_evenness                             |Central Europe vs Europe         |  1.09| 0.344000|ns  |
|density_evenness                             |Central Europe vs West Asia      |  1.66| 0.161000|ns  |
|density_evenness                             |Central Europe vs Southeast Asia | -1.92| 0.109000|ns  |
|density_evenness                             |Europe vs West Asia              |  0.51| 0.680000|ns  |
|density_evenness                             |Europe vs Southeast Asia         | -2.64| 0.042000|*   |
|density_evenness                             |West Asia vs Southeast Asia      | -3.10| 0.019400|*   |
|distal_appendicular_continuity_hm            |West Europe vs Central Europe    | -0.58| 0.621000|ns  |
|distal_appendicular_continuity_hm            |West Europe vs Europe            |  3.09| 0.006670|**  |
|distal_appendicular_continuity_hm            |West Europe vs West Asia         |  2.42| 0.025600|*   |
|distal_appendicular_continuity_hm            |West Europe vs Southeast Asia    | -2.68| 0.014700|*   |
|distal_appendicular_continuity_hm            |Central Europe vs Europe         |  2.91| 0.009050|**  |
|distal_appendicular_continuity_hm            |Central Europe vs West Asia      |  2.36| 0.025900|*   |
|distal_appendicular_continuity_hm            |Central Europe vs Southeast Asia | -1.97| 0.061200|ns  |
|distal_appendicular_continuity_hm            |Europe vs West Asia              | -0.49| 0.627000|ns  |
|distal_appendicular_continuity_hm            |Europe vs Southeast Asia         | -4.15| 0.000328|*** |
|distal_appendicular_continuity_hm            |West Asia vs Southeast Asia      | -3.71| 0.001040|**  |
|effective_sections_hill1                     |West Europe vs Central Europe    | -0.22| 0.825000|ns  |
|effective_sections_hill1                     |West Europe vs Europe            |  2.08| 0.062300|ns  |
|effective_sections_hill1                     |West Europe vs West Asia         |  2.57| 0.034300|*   |
|effective_sections_hill1                     |West Europe vs Southeast Asia    | -2.39| 0.041700|*   |
|effective_sections_hill1                     |Central Europe vs Europe         |  1.85| 0.080300|ns  |
|effective_sections_hill1                     |Central Europe vs West Asia      |  2.25| 0.049100|*   |
|effective_sections_hill1                     |Central Europe vs Southeast Asia | -1.93| 0.076200|ns  |
|effective_sections_hill1                     |Europe vs West Asia              |  0.35| 0.804000|ns  |
|effective_sections_hill1                     |Europe vs Southeast Asia         | -3.26| 0.005580|**  |
|effective_sections_hill1                     |West Asia vs Southeast Asia      | -3.58| 0.003400|**  |
|low_density_axial_survival                   |West Europe vs Central Europe    | -0.29| 0.769000|ns  |
|low_density_axial_survival                   |West Europe vs Europe            |  1.43| 0.218000|ns  |
|low_density_axial_survival                   |West Europe vs West Asia         |  2.43| 0.037500|*   |
|low_density_axial_survival                   |West Europe vs Southeast Asia    | -2.55| 0.035400|*   |
|low_density_axial_survival                   |Central Europe vs Europe         |  1.36| 0.218000|ns  |
|low_density_axial_survival                   |Central Europe vs West Asia      |  2.18| 0.058100|ns  |
|low_density_axial_survival                   |Central Europe vs Southeast Asia | -2.03| 0.070900|ns  |
|low_density_axial_survival                   |Europe vs West Asia              |  0.73| 0.514000|ns  |
|low_density_axial_survival                   |Europe vs Southeast Asia         | -2.95| 0.016100|*   |
|low_density_axial_survival                   |West Asia vs Southeast Asia      | -3.62| 0.002980|**  |
|low_density_share                            |West Europe vs Central Europe    |  0.23| 0.819000|ns  |
|low_density_share                            |West Europe vs Europe            |  0.98| 0.471000|ns  |
|low_density_share                            |West Europe vs West Asia         |  1.82| 0.138000|ns  |
|low_density_share                            |West Europe vs Southeast Asia    | -2.74| 0.020700|*   |
|low_density_share                            |Central Europe vs Europe         |  0.65| 0.597000|ns  |
|low_density_share                            |Central Europe vs West Asia      |  1.35| 0.297000|ns  |
|low_density_share                            |Central Europe vs Southeast Asia | -2.48| 0.032400|*   |
|low_density_share                            |Europe vs West Asia              |  0.62| 0.597000|ns  |
|low_density_share                            |Europe vs Southeast Asia         | -2.79| 0.020700|*   |
|low_density_share                            |West Asia vs Southeast Asia      | -3.35| 0.008000|**  |
|low_density_survival_index                   |West Europe vs Central Europe    |  0.07| 0.947000|ns  |
|low_density_survival_index                   |West Europe vs Europe            |  1.53| 0.180000|ns  |
|low_density_survival_index                   |West Europe vs West Asia         |  2.37| 0.040200|*   |
|low_density_survival_index                   |West Europe vs Southeast Asia    | -2.66| 0.026000|*   |
|low_density_survival_index                   |Central Europe vs Europe         |  1.21| 0.282000|ns  |
|low_density_survival_index                   |Central Europe vs West Asia      |  1.90| 0.094800|ns  |
|low_density_survival_index                   |Central Europe vs Southeast Asia | -2.32| 0.040200|*   |
|low_density_survival_index                   |Europe vs West Asia              |  0.62| 0.598000|ns  |
|low_density_survival_index                   |Europe vs Southeast Asia         | -3.10| 0.009730|**  |
|low_density_survival_index                   |West Asia vs Southeast Asia      | -3.66| 0.002520|**  |
|lower_appendicular_continuity_hm             |West Europe vs Central Europe    |  0.01| 0.994000|ns  |
|lower_appendicular_continuity_hm             |West Europe vs Europe            |  2.68| 0.024700|*   |
|lower_appendicular_continuity_hm             |West Europe vs West Asia         |  2.27| 0.047300|*   |
|lower_appendicular_continuity_hm             |West Europe vs Southeast Asia    | -2.25| 0.047300|*   |
|lower_appendicular_continuity_hm             |Central Europe vs Europe         |  2.19| 0.047300|*   |
|lower_appendicular_continuity_hm             |Central Europe vs West Asia      |  1.86| 0.079300|ns  |
|lower_appendicular_continuity_hm             |Central Europe vs Southeast Asia | -1.94| 0.075600|ns  |
|lower_appendicular_continuity_hm             |Europe vs West Asia              | -0.30| 0.850000|ns  |
|lower_appendicular_continuity_hm             |Europe vs Southeast Asia         | -3.54| 0.004010|**  |
|lower_appendicular_continuity_hm             |West Asia vs Southeast Asia      | -3.27| 0.005430|**  |
|lower_appendicular_evenness                  |West Europe vs Central Europe    |  0.18| 0.858000|ns  |
|lower_appendicular_evenness                  |West Europe vs Europe            |  2.44| 0.049100|*   |
|lower_appendicular_evenness                  |West Europe vs West Asia         |  1.98| 0.079100|ns  |
|lower_appendicular_evenness                  |West Europe vs Southeast Asia    | -2.22| 0.066700|ns  |
|lower_appendicular_evenness                  |Central Europe vs Europe         |  1.78| 0.108000|ns  |
|lower_appendicular_evenness                  |Central Europe vs West Asia      |  1.42| 0.194000|ns  |
|lower_appendicular_evenness                  |Central Europe vs Southeast Asia | -2.05| 0.079100|ns  |
|lower_appendicular_evenness                  |Europe vs West Asia              | -0.34| 0.819000|ns  |
|lower_appendicular_evenness                  |Europe vs Southeast Asia         | -3.27| 0.010600|*   |
|lower_appendicular_evenness                  |West Asia vs Southeast Asia      | -3.01| 0.012900|*   |
|lower_appendicular_evenness_refined          |West Europe vs Central Europe    |  0.18| 0.858000|ns  |
|lower_appendicular_evenness_refined          |West Europe vs Europe            |  2.44| 0.049100|*   |
|lower_appendicular_evenness_refined          |West Europe vs West Asia         |  1.98| 0.079100|ns  |
|lower_appendicular_evenness_refined          |West Europe vs Southeast Asia    | -2.22| 0.066700|ns  |
|lower_appendicular_evenness_refined          |Central Europe vs Europe         |  1.78| 0.108000|ns  |
|lower_appendicular_evenness_refined          |Central Europe vs West Asia      |  1.42| 0.194000|ns  |
|lower_appendicular_evenness_refined          |Central Europe vs Southeast Asia | -2.05| 0.079100|ns  |
|lower_appendicular_evenness_refined          |Europe vs West Asia              | -0.34| 0.819000|ns  |
|lower_appendicular_evenness_refined          |Europe vs Southeast Asia         | -3.27| 0.010600|*   |
|lower_appendicular_evenness_refined          |West Asia vs Southeast Asia      | -3.01| 0.012900|*   |
|mnau_appendicular_mean                       |West Europe vs Central Europe    | -0.58| 0.624000|ns  |
|mnau_appendicular_mean                       |West Europe vs Europe            |  1.86| 0.090000|ns  |
|mnau_appendicular_mean                       |West Europe vs West Asia         |  2.13| 0.068800|ns  |
|mnau_appendicular_mean                       |West Europe vs Southeast Asia    | -2.28| 0.068800|ns  |
|mnau_appendicular_mean                       |Central Europe vs Europe         |  1.90| 0.090000|ns  |
|mnau_appendicular_mean                       |Central Europe vs West Asia      |  2.12| 0.068800|ns  |
|mnau_appendicular_mean                       |Central Europe vs Southeast Asia | -1.63| 0.129000|ns  |
|mnau_appendicular_mean                       |Europe vs West Asia              |  0.19| 0.846000|ns  |
|mnau_appendicular_mean                       |Europe vs Southeast Asia         | -3.02| 0.012500|*   |
|mnau_appendicular_mean                       |West Asia vs Southeast Asia      | -3.20| 0.012500|*   |
|mnau_arms                                    |West Europe vs Central Europe    |  0.16| 0.877000|ns  |
|mnau_arms                                    |West Europe vs Europe            |  1.22| 0.320000|ns  |
|mnau_arms                                    |West Europe vs West Asia         |  2.05| 0.102000|ns  |
|mnau_arms                                    |West Europe vs Southeast Asia    | -2.06| 0.102000|ns  |
|mnau_arms                                    |Central Europe vs Europe         |  0.90| 0.461000|ns  |
|mnau_arms                                    |Central Europe vs West Asia      |  1.58| 0.190000|ns  |
|mnau_arms                                    |Central Europe vs Southeast Asia | -1.86| 0.127000|ns  |
|mnau_arms                                    |Europe vs West Asia              |  0.61| 0.605000|ns  |
|mnau_arms                                    |Europe vs Southeast Asia         | -2.42| 0.078100|ns  |
|mnau_arms                                    |West Asia vs Southeast Asia      | -2.97| 0.029700|*   |
|mnau_axial_main_mean                         |West Europe vs Central Europe    | -0.22| 0.822000|ns  |
|mnau_axial_main_mean                         |West Europe vs Europe            |  1.47| 0.201000|ns  |
|mnau_axial_main_mean                         |West Europe vs West Asia         |  2.48| 0.032900|*   |
|mnau_axial_main_mean                         |West Europe vs Southeast Asia    | -2.55| 0.032900|*   |
|mnau_axial_main_mean                         |Central Europe vs Europe         |  1.35| 0.220000|ns  |
|mnau_axial_main_mean                         |Central Europe vs West Asia      |  2.18| 0.058900|ns  |
|mnau_axial_main_mean                         |Central Europe vs Southeast Asia | -2.06| 0.065700|ns  |
|mnau_axial_main_mean                         |Europe vs West Asia              |  0.73| 0.514000|ns  |
|mnau_axial_main_mean                         |Europe vs Southeast Asia         | -2.97| 0.014800|*   |
|mnau_axial_main_mean                         |West Asia vs Southeast Asia      | -3.64| 0.002710|**  |
|mnau_column_trunk_mean                       |West Europe vs Central Europe    | -0.37| 0.735000|ns  |
|mnau_column_trunk_mean                       |West Europe vs Europe            |  1.59| 0.154000|ns  |
|mnau_column_trunk_mean                       |West Europe vs West Asia         |  2.06| 0.079400|ns  |
|mnau_column_trunk_mean                       |West Europe vs Southeast Asia    | -2.65| 0.027100|*   |
|mnau_column_trunk_mean                       |Central Europe vs Europe         |  1.54| 0.154000|ns  |
|mnau_column_trunk_mean                       |Central Europe vs West Asia      |  1.92| 0.090700|ns  |
|mnau_column_trunk_mean                       |Central Europe vs Southeast Asia | -2.06| 0.079400|ns  |
|mnau_column_trunk_mean                       |Europe vs West Asia              |  0.34| 0.735000|ns  |
|mnau_column_trunk_mean                       |Europe vs Southeast Asia         | -3.13| 0.008770|**  |
|mnau_column_trunk_mean                       |West Asia vs Southeast Asia      | -3.44| 0.005860|**  |
|mnau_cv                                      |West Europe vs Central Europe    |  0.25| 0.802000|ns  |
|mnau_cv                                      |West Europe vs Europe            | -1.74| 0.117000|ns  |
|mnau_cv                                      |West Europe vs West Asia         | -2.26| 0.060300|ns  |
|mnau_cv                                      |West Europe vs Southeast Asia    |  2.37| 0.059900|ns  |
|mnau_cv                                      |Central Europe vs Europe         | -1.59| 0.140000|ns  |
|mnau_cv                                      |Central Europe vs West Asia      | -2.01| 0.088400|ns  |
|mnau_cv                                      |Central Europe vs Southeast Asia |  1.89| 0.097700|ns  |
|mnau_cv                                      |Europe vs West Asia              | -0.38| 0.784000|ns  |
|mnau_cv                                      |Europe vs Southeast Asia         |  3.01| 0.013100|*   |
|mnau_cv                                      |West Asia vs Southeast Asia      |  3.35| 0.007980|**  |
|mnau_distal_appendicular_mean                |West Europe vs Central Europe    | -0.90| 0.409000|ns  |
|mnau_distal_appendicular_mean                |West Europe vs Europe            |  2.73| 0.010300|*   |
|mnau_distal_appendicular_mean                |West Europe vs West Asia         |  3.04| 0.005820|**  |
|mnau_distal_appendicular_mean                |West Europe vs Southeast Asia    | -2.69| 0.010300|*   |
|mnau_distal_appendicular_mean                |Central Europe vs Europe         |  2.82| 0.009730|**  |
|mnau_distal_appendicular_mean                |Central Europe vs West Asia      |  3.07| 0.005820|**  |
|mnau_distal_appendicular_mean                |Central Europe vs Southeast Asia | -1.80| 0.090800|ns  |
|mnau_distal_appendicular_mean                |Europe vs West Asia              |  0.23| 0.818000|ns  |
|mnau_distal_appendicular_mean                |Europe vs Southeast Asia         | -3.92| 0.000445|*** |
|mnau_distal_appendicular_mean                |West Asia vs Southeast Asia      | -4.13| 0.000365|*** |
|mnau_dominance_of_region_means               |West Europe vs Central Europe    |  0.27| 0.786000|ns  |
|mnau_dominance_of_region_means               |West Europe vs Europe            | -1.49| 0.195000|ns  |
|mnau_dominance_of_region_means               |West Europe vs West Asia         | -2.33| 0.049500|*   |
|mnau_dominance_of_region_means               |West Europe vs Southeast Asia    |  2.50| 0.041400|*   |
|mnau_dominance_of_region_means               |Central Europe vs Europe         | -1.40| 0.204000|ns  |
|mnau_dominance_of_region_means               |Central Europe vs West Asia      | -2.09| 0.073900|ns  |
|mnau_dominance_of_region_means               |Central Europe vs Southeast Asia |  1.99| 0.076900|ns  |
|mnau_dominance_of_region_means               |Europe vs West Asia              | -0.61| 0.599000|ns  |
|mnau_dominance_of_region_means               |Europe vs Southeast Asia         |  2.95| 0.016100|*   |
|mnau_dominance_of_region_means               |West Asia vs Southeast Asia      |  3.51| 0.004520|**  |
|mnau_evenness_minus_dominance                |West Europe vs Central Europe    | -0.31| 0.757000|ns  |
|mnau_evenness_minus_dominance                |West Europe vs Europe            |  1.74| 0.117000|ns  |
|mnau_evenness_minus_dominance                |West Europe vs West Asia         |  2.34| 0.047700|*   |
|mnau_evenness_minus_dominance                |West Europe vs Southeast Asia    | -2.41| 0.047700|*   |
|mnau_evenness_minus_dominance                |Central Europe vs Europe         |  1.62| 0.130000|ns  |
|mnau_evenness_minus_dominance                |Central Europe vs West Asia      |  2.12| 0.067700|ns  |
|mnau_evenness_minus_dominance                |Central Europe vs Southeast Asia | -1.90| 0.096000|ns  |
|mnau_evenness_minus_dominance                |Europe vs West Asia              |  0.44| 0.731000|ns  |
|mnau_evenness_minus_dominance                |Europe vs Southeast Asia         | -3.05| 0.011600|*   |
|mnau_evenness_minus_dominance                |West Asia vs Southeast Asia      | -3.45| 0.005620|**  |
|mnau_foot                                    |West Europe vs Central Europe    | -0.33| 0.744000|ns  |
|mnau_foot                                    |West Europe vs Europe            |  3.12| 0.005950|**  |
|mnau_foot                                    |West Europe vs West Asia         |  2.56| 0.020800|*   |
|mnau_foot                                    |West Europe vs Southeast Asia    | -2.22| 0.037600|*   |
|mnau_foot                                    |Central Europe vs Europe         |  2.77| 0.013900|*   |
|mnau_foot                                    |Central Europe vs West Asia      |  2.31| 0.034700|*   |
|mnau_foot                                    |Central Europe vs Southeast Asia | -1.72| 0.106000|ns  |
|mnau_foot                                    |Europe vs West Asia              | -0.41| 0.744000|ns  |
|mnau_foot                                    |Europe vs Southeast Asia         | -3.82| 0.001350|**  |
|mnau_foot                                    |West Asia vs Southeast Asia      | -3.44| 0.002880|**  |
|mnau_gini                                    |West Europe vs Central Europe    |  0.22| 0.825000|ns  |
|mnau_gini                                    |West Europe vs Europe            | -2.07| 0.064200|ns  |
|mnau_gini                                    |West Europe vs West Asia         | -2.54| 0.037000|*   |
|mnau_gini                                    |West Europe vs Southeast Asia    |  2.41| 0.040300|*   |
|mnau_gini                                    |Central Europe vs Europe         | -1.84| 0.082200|ns  |
|mnau_gini                                    |Central Europe vs West Asia      | -2.23| 0.052000|ns  |
|mnau_gini                                    |Central Europe vs Southeast Asia |  1.94| 0.074300|ns  |
|mnau_gini                                    |Europe vs West Asia              | -0.34| 0.812000|ns  |
|mnau_gini                                    |Europe vs Southeast Asia         |  3.26| 0.005550|**  |
|mnau_gini                                    |West Asia vs Southeast Asia      |  3.57| 0.003510|**  |
|mnau_girdle_mean                             |West Europe vs Central Europe    |  0.03| 0.989000|ns  |
|mnau_girdle_mean                             |West Europe vs Europe            |  1.93| 0.093500|ns  |
|mnau_girdle_mean                             |West Europe vs West Asia         |  1.91| 0.093500|ns  |
|mnau_girdle_mean                             |West Europe vs Southeast Asia    | -2.46| 0.046400|*   |
|mnau_girdle_mean                             |Central Europe vs Europe         |  1.56| 0.152000|ns  |
|mnau_girdle_mean                             |Central Europe vs West Asia      |  1.55| 0.152000|ns  |
|mnau_girdle_mean                             |Central Europe vs Southeast Asia | -2.13| 0.082500|ns  |
|mnau_girdle_mean                             |Europe vs West Asia              | -0.01| 0.989000|ns  |
|mnau_girdle_mean                             |Europe vs Southeast Asia         | -3.21| 0.007000|**  |
|mnau_girdle_mean                             |West Asia vs Southeast Asia      | -3.19| 0.007000|**  |
|mnau_hands                                   |West Europe vs Central Europe    | -0.77| 0.491000|ns  |
|mnau_hands                                   |West Europe vs Europe            |  2.57| 0.025800|*   |
|mnau_hands                                   |West Europe vs West Asia         |  2.28| 0.032000|*   |
|mnau_hands                                   |West Europe vs Southeast Asia    | -2.36| 0.030400|*   |
|mnau_hands                                   |Central Europe vs Europe         |  2.60| 0.025800|*   |
|mnau_hands                                   |Central Europe vs West Asia      |  2.37| 0.030400|*   |
|mnau_hands                                   |Central Europe vs Southeast Asia | -1.59| 0.140000|ns  |
|mnau_hands                                   |Europe vs West Asia              | -0.21| 0.837000|ns  |
|mnau_hands                                   |Europe vs Southeast Asia         | -3.55| 0.003790|**  |
|mnau_hands                                   |West Asia vs Southeast Asia      | -3.37| 0.003810|**  |
|mnau_heip_evenness                           |West Europe vs Central Europe    | -0.22| 0.825000|ns  |
|mnau_heip_evenness                           |West Europe vs Europe            |  2.08| 0.062300|ns  |
|mnau_heip_evenness                           |West Europe vs West Asia         |  2.57| 0.034300|*   |
|mnau_heip_evenness                           |West Europe vs Southeast Asia    | -2.39| 0.041700|*   |
|mnau_heip_evenness                           |Central Europe vs Europe         |  1.85| 0.080300|ns  |
|mnau_heip_evenness                           |Central Europe vs West Asia      |  2.25| 0.049100|*   |
|mnau_heip_evenness                           |Central Europe vs Southeast Asia | -1.93| 0.076200|ns  |
|mnau_heip_evenness                           |Europe vs West Asia              |  0.35| 0.804000|ns  |
|mnau_heip_evenness                           |Europe vs Southeast Asia         | -3.26| 0.005580|**  |
|mnau_heip_evenness                           |West Asia vs Southeast Asia      | -3.58| 0.003400|**  |
|mnau_inverse_simpson                         |West Europe vs Central Europe    | -0.27| 0.789000|ns  |
|mnau_inverse_simpson                         |West Europe vs Europe            |  1.74| 0.116000|ns  |
|mnau_inverse_simpson                         |West Europe vs West Asia         |  2.37| 0.044700|*   |
|mnau_inverse_simpson                         |West Europe vs Southeast Asia    | -2.39| 0.044700|*   |
|mnau_inverse_simpson                         |Central Europe vs Europe         |  1.60| 0.136000|ns  |
|mnau_inverse_simpson                         |Central Europe vs West Asia      |  2.11| 0.068900|ns  |
|mnau_inverse_simpson                         |Central Europe vs Southeast Asia | -1.90| 0.095800|ns  |
|mnau_inverse_simpson                         |Europe vs West Asia              |  0.46| 0.721000|ns  |
|mnau_inverse_simpson                         |Europe vs Southeast Asia         | -3.03| 0.012300|*   |
|mnau_inverse_simpson                         |West Asia vs Southeast Asia      | -3.44| 0.005720|**  |
|mnau_lower_appendicular_mean                 |West Europe vs Central Europe    | -0.61| 0.602000|ns  |
|mnau_lower_appendicular_mean                 |West Europe vs Europe            |  1.80| 0.104000|ns  |
|mnau_lower_appendicular_mean                 |West Europe vs West Asia         |  1.98| 0.096500|ns  |
|mnau_lower_appendicular_mean                 |West Europe vs Southeast Asia    | -2.12| 0.096500|ns  |
|mnau_lower_appendicular_mean                 |Central Europe vs Europe         |  1.86| 0.104000|ns  |
|mnau_lower_appendicular_mean                 |Central Europe vs West Asia      |  2.01| 0.096500|ns  |
|mnau_lower_appendicular_mean                 |Central Europe vs Southeast Asia | -1.47| 0.176000|ns  |
|mnau_lower_appendicular_mean                 |Europe vs West Asia              |  0.13| 0.896000|ns  |
|mnau_lower_appendicular_mean                 |Europe vs Southeast Asia         | -2.85| 0.021600|*   |
|mnau_lower_appendicular_mean                 |West Asia vs Southeast Asia      | -2.97| 0.021600|*   |
|mnau_pelvic                                  |West Europe vs Central Europe    | -0.63| 0.589000|ns  |
|mnau_pelvic                                  |West Europe vs Europe            |  2.21| 0.067900|ns  |
|mnau_pelvic                                  |West Europe vs West Asia         |  1.91| 0.080400|ns  |
|mnau_pelvic                                  |West Europe vs Southeast Asia    | -2.07| 0.076500|ns  |
|mnau_pelvic                                  |Central Europe vs Europe         |  2.21| 0.067900|ns  |
|mnau_pelvic                                  |Central Europe vs West Asia      |  1.97| 0.080400|ns  |
|mnau_pelvic                                  |Central Europe vs Southeast Asia | -1.42| 0.194000|ns  |
|mnau_pelvic                                  |Europe vs West Asia              | -0.22| 0.827000|ns  |
|mnau_pelvic                                  |Europe vs Southeast Asia         | -3.09| 0.019200|*   |
|mnau_pelvic                                  |West Asia vs Southeast Asia      | -2.89| 0.019200|*   |
|mnau_postcranial_total_mean                  |West Europe vs Central Europe    | -0.59| 0.614000|ns  |
|mnau_postcranial_total_mean                  |West Europe vs Europe            |  1.74| 0.118000|ns  |
|mnau_postcranial_total_mean                  |West Europe vs West Asia         |  2.22| 0.055200|ns  |
|mnau_postcranial_total_mean                  |West Europe vs Southeast Asia    | -2.34| 0.055200|ns  |
|mnau_postcranial_total_mean                  |Central Europe vs Europe         |  1.80| 0.118000|ns  |
|mnau_postcranial_total_mean                  |Central Europe vs West Asia      |  2.20| 0.055200|ns  |
|mnau_postcranial_total_mean                  |Central Europe vs Southeast Asia | -1.67| 0.118000|ns  |
|mnau_postcranial_total_mean                  |Europe vs West Asia              |  0.35| 0.723000|ns  |
|mnau_postcranial_total_mean                  |Europe vs Southeast Asia         | -2.99| 0.014200|*   |
|mnau_postcranial_total_mean                  |West Asia vs Southeast Asia      | -3.31| 0.009340|**  |
|mnau_proximal_appendicular_mean              |West Europe vs Central Europe    | -0.41| 0.755000|ns  |
|mnau_proximal_appendicular_mean              |West Europe vs Europe            |  1.44| 0.189000|ns  |
|mnau_proximal_appendicular_mean              |West Europe vs West Asia         |  1.72| 0.188000|ns  |
|mnau_proximal_appendicular_mean              |West Europe vs Southeast Asia    | -2.11| 0.116000|ns  |
|mnau_proximal_appendicular_mean              |Central Europe vs Europe         |  1.44| 0.189000|ns  |
|mnau_proximal_appendicular_mean              |Central Europe vs West Asia      |  1.68| 0.188000|ns  |
|mnau_proximal_appendicular_mean              |Central Europe vs Southeast Asia | -1.58| 0.189000|ns  |
|mnau_proximal_appendicular_mean              |Europe vs West Asia              |  0.21| 0.835000|ns  |
|mnau_proximal_appendicular_mean              |Europe vs Southeast Asia         | -2.60| 0.046000|*   |
|mnau_proximal_appendicular_mean              |West Asia vs Southeast Asia      | -2.79| 0.046000|*   |
|mnau_region_mean_evenness                    |West Europe vs Central Europe    | -0.09| 0.931000|ns  |
|mnau_region_mean_evenness                    |West Europe vs Europe            |  2.00| 0.064700|ns  |
|mnau_region_mean_evenness                    |West Europe vs West Asia         |  2.72| 0.021600|*   |
|mnau_region_mean_evenness                    |West Europe vs Southeast Asia    | -2.54| 0.027800|*   |
|mnau_region_mean_evenness                    |Central Europe vs Europe         |  1.70| 0.112000|ns  |
|mnau_region_mean_evenness                    |Central Europe vs West Asia      |  2.29| 0.044000|*   |
|mnau_region_mean_evenness                    |Central Europe vs Southeast Asia | -2.13| 0.054700|ns  |
|mnau_region_mean_evenness                    |Europe vs West Asia              |  0.53| 0.665000|ns  |
|mnau_region_mean_evenness                    |Europe vs Southeast Asia         | -3.32| 0.004510|**  |
|mnau_region_mean_evenness                    |West Asia vs Southeast Asia      | -3.80| 0.001450|**  |
|mnau_shoulder                                |West Europe vs Central Europe    |  0.75| 0.505000|ns  |
|mnau_shoulder                                |West Europe vs Europe            |  2.00| 0.076700|ns  |
|mnau_shoulder                                |West Europe vs West Asia         |  2.34| 0.051800|ns  |
|mnau_shoulder                                |West Europe vs Southeast Asia    | -2.19| 0.056500|ns  |
|mnau_shoulder                                |Central Europe vs Europe         |  1.16| 0.308000|ns  |
|mnau_shoulder                                |Central Europe vs West Asia      |  1.44| 0.213000|ns  |
|mnau_shoulder                                |Central Europe vs Southeast Asia | -2.31| 0.051800|ns  |
|mnau_shoulder                                |Europe vs West Asia              |  0.25| 0.801000|ns  |
|mnau_shoulder                                |Europe vs Southeast Asia         | -3.04| 0.011700|*   |
|mnau_shoulder                                |West Asia vs Southeast Asia      | -3.27| 0.010600|*   |
|mnau_simpson_dominance                       |West Europe vs Central Europe    |  0.27| 0.789000|ns  |
|mnau_simpson_dominance                       |West Europe vs Europe            | -1.74| 0.116000|ns  |
|mnau_simpson_dominance                       |West Europe vs West Asia         | -2.37| 0.044700|*   |
|mnau_simpson_dominance                       |West Europe vs Southeast Asia    |  2.39| 0.044700|*   |
|mnau_simpson_dominance                       |Central Europe vs Europe         | -1.60| 0.136000|ns  |
|mnau_simpson_dominance                       |Central Europe vs West Asia      | -2.11| 0.068900|ns  |
|mnau_simpson_dominance                       |Central Europe vs Southeast Asia |  1.90| 0.095800|ns  |
|mnau_simpson_dominance                       |Europe vs West Asia              | -0.46| 0.721000|ns  |
|mnau_simpson_dominance                       |Europe vs Southeast Asia         |  3.03| 0.012300|*   |
|mnau_simpson_dominance                       |West Asia vs Southeast Asia      |  3.44| 0.005720|**  |
|mnau_simpson_evenness                        |West Europe vs Central Europe    | -0.27| 0.789000|ns  |
|mnau_simpson_evenness                        |West Europe vs Europe            |  1.74| 0.116000|ns  |
|mnau_simpson_evenness                        |West Europe vs West Asia         |  2.37| 0.044700|*   |
|mnau_simpson_evenness                        |West Europe vs Southeast Asia    | -2.39| 0.044700|*   |
|mnau_simpson_evenness                        |Central Europe vs Europe         |  1.60| 0.136000|ns  |
|mnau_simpson_evenness                        |Central Europe vs West Asia      |  2.11| 0.068900|ns  |
|mnau_simpson_evenness                        |Central Europe vs Southeast Asia | -1.90| 0.095800|ns  |
|mnau_simpson_evenness                        |Europe vs West Asia              |  0.46| 0.721000|ns  |
|mnau_simpson_evenness                        |Europe vs Southeast Asia         | -3.03| 0.012300|*   |
|mnau_simpson_evenness                        |West Asia vs Southeast Asia      | -3.44| 0.005720|**  |
|mnau_top2_share_mcnaughton                   |West Europe vs Central Europe    | -0.06| 0.952000|ns  |
|mnau_top2_share_mcnaughton                   |West Europe vs Europe            | -1.78| 0.108000|ns  |
|mnau_top2_share_mcnaughton                   |West Europe vs West Asia         | -2.34| 0.040700|*   |
|mnau_top2_share_mcnaughton                   |West Europe vs Southeast Asia    |  2.66| 0.026200|*   |
|mnau_top2_share_mcnaughton                   |Central Europe vs Europe         | -1.42| 0.194000|ns  |
|mnau_top2_share_mcnaughton                   |Central Europe vs West Asia      | -1.88| 0.099900|ns  |
|mnau_top2_share_mcnaughton                   |Central Europe vs Southeast Asia |  2.32| 0.040700|*   |
|mnau_top2_share_mcnaughton                   |Europe vs West Asia              | -0.41| 0.758000|ns  |
|mnau_top2_share_mcnaughton                   |Europe vs Southeast Asia         |  3.26| 0.005510|**  |
|mnau_top2_share_mcnaughton                   |West Asia vs Southeast Asia      |  3.64| 0.002760|**  |
|mnau_upper_appendicular_mean                 |West Europe vs Central Europe    | -0.02| 0.983000|ns  |
|mnau_upper_appendicular_mean                 |West Europe vs Europe            |  2.10| 0.060500|ns  |
|mnau_upper_appendicular_mean                 |West Europe vs West Asia         |  2.15| 0.060500|ns  |
|mnau_upper_appendicular_mean                 |West Europe vs Southeast Asia    | -2.45| 0.047700|*   |
|mnau_upper_appendicular_mean                 |Central Europe vs Europe         |  1.73| 0.104000|ns  |
|mnau_upper_appendicular_mean                 |Central Europe vs West Asia      |  1.78| 0.104000|ns  |
|mnau_upper_appendicular_mean                 |Central Europe vs Southeast Asia | -2.09| 0.060500|ns  |
|mnau_upper_appendicular_mean                 |Europe vs West Asia              |  0.04| 0.983000|ns  |
|mnau_upper_appendicular_mean                 |Europe vs Southeast Asia         | -3.31| 0.004640|**  |
|mnau_upper_appendicular_mean                 |West Asia vs Southeast Asia      | -3.35| 0.004640|**  |
|mne_arms                                     |West Europe vs Central Europe    |  0.63| 0.531000|ns  |
|mne_arms                                     |West Europe vs Europe            |  3.90| 0.000472|*** |
|mne_arms                                     |West Europe vs West Asia         |  2.06| 0.056700|ns  |
|mne_arms                                     |West Europe vs Southeast Asia    | -2.21| 0.044800|*   |
|mne_arms                                     |Central Europe vs Europe         |  2.80| 0.012700|*   |
|mne_arms                                     |Central Europe vs West Asia      |  1.29| 0.220000|ns  |
|mne_arms                                     |Central Europe vs Southeast Asia | -2.26| 0.044800|*   |
|mne_arms                                     |Europe vs West Asia              | -1.35| 0.220000|ns  |
|mne_arms                                     |Europe vs Southeast Asia         | -4.33| 0.000148|*** |
|mne_arms                                     |West Asia vs Southeast Asia      | -3.10| 0.006450|**  |
|postcranial_dominance_refined                |West Europe vs Central Europe    | -1.47| 0.238000|ns  |
|postcranial_dominance_refined                |West Europe vs Europe            | -1.17| 0.348000|ns  |
|postcranial_dominance_refined                |West Europe vs West Asia         | -2.22| 0.052900|ns  |
|postcranial_dominance_refined                |West Europe vs Southeast Asia    |  2.41| 0.040300|*   |
|postcranial_dominance_refined                |Central Europe vs Europe         |  0.11| 0.914000|ns  |
|postcranial_dominance_refined                |Central Europe vs West Asia      | -0.71| 0.530000|ns  |
|postcranial_dominance_refined                |Central Europe vs Southeast Asia |  2.89| 0.019500|*   |
|postcranial_dominance_refined                |Europe vs West Asia              | -0.77| 0.530000|ns  |
|postcranial_dominance_refined                |Europe vs Southeast Asia         |  2.71| 0.022500|*   |
|postcranial_dominance_refined                |West Asia vs Southeast Asia      |  3.31| 0.009420|**  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.61, R² = 0.088, p = 0.0058.
PCA variance explained: PC1 60.0%, PC2 8.8%, PC3 6.0% (cumulative 74.7%).
Dispersion caveat (PERMDISP): p = 0.182.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton    |  0.178|  0.109| -0.033|
|mnau_inverse_simpson          | -0.177| -0.078|  0.033|
|mnau_simpson_evenness         | -0.177| -0.078|  0.033|
|mnau_gini                     |  0.177|  0.108| -0.037|
|mnau_heip_evenness            | -0.176| -0.120|  0.027|
|effective_sections_hill1      | -0.176| -0.120|  0.027|
|mnau_cv                       |  0.174|  0.156| -0.001|
|mnau_evenness_minus_dominance | -0.174| -0.159| -0.001|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
