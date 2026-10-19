# Species (context-controlled)
*Automated hominin_species × skeletal-part representation*

- **Grouping column:** `hominin_species` (mode = single)
- **Groups (n):** H. sapiens = 79; H. neanderthalensis = 50; Middle Pleistocene hominin = 15; H. erectus = 5
- **Sites analysed:** 149  |  **features screened:** 63

## Hypothesis

**H:** Species-level differences may reflect different depositional histories, not anatomy alone.

**Expected pattern:** Neanderthal / earlier Homo / H. sapiens may differ, but differences may vanish after controlling for age, site type, period, context.

**Why it matters:** Interesting but risky; do not read causally unless preservation and context are controlled.


## Summary

56 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **density_evenness** (ε² = 0.183, FDR p = 3.586e-05). PERMANOVA pseudo-F = 2.57, p = 0.0101; PC1–PC3 explain 71.8% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 214 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 20 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|density_evenness                             |  0.183| 3.59e-05|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.182| 3.59e-05|large      |significant |
|low_density_axial_survival                   |  0.175| 3.59e-05|large      |significant |
|low_density_share                            |  0.175| 3.59e-05|large      |significant |
|mnau_postcranial_total_mean                  |  0.172| 3.59e-05|large      |significant |
|low_density_survival_index                   |  0.171| 3.59e-05|large      |significant |
|mnau_axial_main_mean                         |  0.170| 3.59e-05|large      |significant |
|dominance_gap_all                            |  0.168| 3.59e-05|large      |significant |
|mnau_appendicular_mean                       |  0.166| 3.59e-05|large      |significant |
|all_sections_dominance                       |  0.166| 3.59e-05|large      |significant |
|mnau_column_trunk_mean                       |  0.164| 3.59e-05|large      |significant |
|lower_appendicular_continuity_hm             |  0.164| 3.59e-05|large      |significant |
|mnau_lower_appendicular_mean                 |  0.162| 3.76e-05|large      |significant |
|mnau_gini                                    |  0.159| 4.29e-05|large      |significant |
|mnau_evenness_minus_dominance                |  0.157| 4.29e-05|large      |significant |
|mnau_cv                                      |  0.157| 4.29e-05|large      |significant |
|mnau_simpson_dominance                       |  0.156| 4.29e-05|large      |significant |
|mnau_inverse_simpson                         |  0.156| 4.29e-05|large      |significant |
|mnau_simpson_evenness                        |  0.156| 4.29e-05|large      |significant |
|mnau_region_mean_evenness                    |  0.154| 4.38e-05|large      |significant |
|mnau_proximal_appendicular_mean              |  0.153| 4.29e-05|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.153| 4.29e-05|large      |significant |
|effective_sections_hill1                     |  0.152| 4.44e-05|large      |significant |
|mnau_heip_evenness                           |  0.152| 4.44e-05|large      |significant |
|mne_arms                                     |  0.151| 4.41e-05|large      |significant |
|mnau_upper_appendicular_mean                 |  0.147| 5.23e-05|large      |significant |
|distal_appendicular_continuity_hm            |  0.146| 5.23e-05|large      |significant |
|mnau_dominance_of_region_means               |  0.144| 6.34e-05|large      |significant |
|mnau_legs                                    |  0.143| 6.34e-05|large      |significant |
|mnau_distal_appendicular_mean                |  0.142| 6.34e-05|large      |significant |
|mnau_foot                                    |  0.134| 1.05e-04|moderate   |significant |
|mnau_girdle_mean                             |  0.132| 1.22e-04|moderate   |significant |
|ProportionalRep_MNIbased_humerus             |  0.131| 1.29e-04|moderate   |significant |
|mnau_arms                                    |  0.125| 1.85e-04|moderate   |significant |
|mne_cranial_share                            |  0.114| 3.87e-04|moderate   |significant |
|ProportionalRep_MNIbased_fibula              |  0.108| 5.51e-04|moderate   |significant |
|ProportionalRep_MNIbased_tibia               |  0.103| 7.80e-04|moderate   |significant |
|mnau_shoulder                                |  0.101| 8.34e-04|moderate   |significant |
|ProportionalRep_MNIbased_femur               |  0.101| 8.34e-04|moderate   |significant |
|dominant_axial_share                         |  0.100| 8.69e-04|moderate   |significant |
|mnau_hands                                   |  0.088| 1.89e-03|moderate   |significant |
|ReMNAU_cervical                              |  0.086| 2.16e-03|moderate   |significant |
|mnau_pelvic                                  |  0.079| 3.41e-03|moderate   |significant |
|appendicular_dominance                       |  0.078| 7.07e-03|moderate   |significant |
|appendicular_dominance_refined               |  0.078| 7.07e-03|moderate   |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.073| 5.05e-03|moderate   |significant |
|ProportionalRep_MNIbased_cervical            |  0.073| 5.05e-03|moderate   |significant |
|ProportionalRep_MNIbased_clavicle            |  0.072| 5.18e-03|moderate   |significant |
|ReMNAU_ulna                                  |  0.070| 5.80e-03|moderate   |significant |
|lower_appendicular_evenness                  |  0.065| 1.59e-02|moderate   |significant |
|lower_appendicular_evenness_refined          |  0.065| 1.59e-02|moderate   |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.064| 7.96e-03|moderate   |significant |
|ReMNAU_radius                                |  0.062| 9.04e-03|moderate   |significant |
|postcranial_dominance_refined                |  0.061| 1.67e-02|moderate   |significant |
|ProportionalRep_MNIbased_radius              |  0.056| 1.38e-02|small      |significant |
|ProportionalRep_MNIbased_carpal              |  0.050| 1.84e-02|small      |significant |
|mnau_vertebrae_to_thorax_ratio               |  0.017| 1.56e-01|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.015| 1.78e-01|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.008| 2.50e-01|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.008| 2.50e-01|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.005| 5.33e-01|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.007| 5.96e-01|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.014| 7.96e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                          |     Z|  p (adj)|Sig |
|:-----------------------------------|:-------------------------------------------------|-----:|--------:|:---|
|ProportionalRep_MNIbased_carpal     |H. sapiens vs H. neanderthalensis                 | -2.71| 0.040900|*   |
|ProportionalRep_MNIbased_carpal     |H. sapiens vs Middle Pleistocene hominin          | -0.94| 0.418000|ns  |
|ProportionalRep_MNIbased_carpal     |H. sapiens vs H. erectus                          | -2.10| 0.107000|ns  |
|ProportionalRep_MNIbased_carpal     |H. neanderthalensis vs Middle Pleistocene hominin |  0.76| 0.445000|ns  |
|ProportionalRep_MNIbased_carpal     |H. neanderthalensis vs H. erectus                 | -1.02| 0.418000|ns  |
|ProportionalRep_MNIbased_carpal     |Middle Pleistocene hominin vs H. erectus          | -1.37| 0.344000|ns  |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs H. neanderthalensis                 | -2.71| 0.040600|*   |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs Middle Pleistocene hominin          | -2.17| 0.060700|ns  |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs H. erectus                          | -2.44| 0.044600|*   |
|ProportionalRep_MNIbased_cervical   |H. neanderthalensis vs Middle Pleistocene hominin | -0.41| 0.683000|ns  |
|ProportionalRep_MNIbased_cervical   |H. neanderthalensis vs H. erectus                 | -1.35| 0.265000|ns  |
|ProportionalRep_MNIbased_cervical   |Middle Pleistocene hominin vs H. erectus          | -0.99| 0.384000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs H. neanderthalensis                 | -2.77| 0.020300|*   |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs Middle Pleistocene hominin          | -1.43| 0.183000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs H. erectus                          | -2.71| 0.020300|*   |
|ProportionalRep_MNIbased_clavicle   |H. neanderthalensis vs Middle Pleistocene hominin |  0.33| 0.739000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. neanderthalensis vs H. erectus                 | -1.59| 0.167000|ns  |
|ProportionalRep_MNIbased_clavicle   |Middle Pleistocene hominin vs H. erectus          | -1.64| 0.167000|ns  |
|ProportionalRep_MNIbased_femur      |H. sapiens vs H. neanderthalensis                 | -2.81| 0.014800|*   |
|ProportionalRep_MNIbased_femur      |H. sapiens vs Middle Pleistocene hominin          | -2.27| 0.046100|*   |
|ProportionalRep_MNIbased_femur      |H. sapiens vs H. erectus                          | -3.16| 0.009480|**  |
|ProportionalRep_MNIbased_femur      |H. neanderthalensis vs Middle Pleistocene hominin | -0.45| 0.654000|ns  |
|ProportionalRep_MNIbased_femur      |H. neanderthalensis vs H. erectus                 | -2.02| 0.064600|ns  |
|ProportionalRep_MNIbased_femur      |Middle Pleistocene hominin vs H. erectus          | -1.58| 0.136000|ns  |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs H. neanderthalensis                 | -3.38| 0.004340|**  |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs Middle Pleistocene hominin          | -2.35| 0.037600|*   |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs H. erectus                          | -2.78| 0.016300|*   |
|ProportionalRep_MNIbased_fibula     |H. neanderthalensis vs Middle Pleistocene hominin | -0.17| 0.863000|ns  |
|ProportionalRep_MNIbased_fibula     |H. neanderthalensis vs H. erectus                 | -1.43| 0.228000|ns  |
|ProportionalRep_MNIbased_fibula     |Middle Pleistocene hominin vs H. erectus          | -1.20| 0.275000|ns  |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs H. neanderthalensis                 | -3.23| 0.003750|**  |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012200|*   |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs H. erectus                          | -3.31| 0.003750|**  |
|ProportionalRep_MNIbased_humerus    |H. neanderthalensis vs Middle Pleistocene hominin | -0.64| 0.520000|ns  |
|ProportionalRep_MNIbased_humerus    |H. neanderthalensis vs H. erectus                 | -2.02| 0.065800|ns  |
|ProportionalRep_MNIbased_humerus    |Middle Pleistocene hominin vs H. erectus          | -1.46| 0.172000|ns  |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs H. neanderthalensis                 | -2.44| 0.039600|*   |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs Middle Pleistocene hominin          | -2.33| 0.039600|*   |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs H. erectus                          | -2.56| 0.039600|*   |
|ProportionalRep_MNIbased_metacarpal |H. neanderthalensis vs Middle Pleistocene hominin | -0.73| 0.465000|ns  |
|ProportionalRep_MNIbased_metacarpal |H. neanderthalensis vs H. erectus                 | -1.58| 0.172000|ns  |
|ProportionalRep_MNIbased_metacarpal |Middle Pleistocene hominin vs H. erectus          | -1.02| 0.371000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs H. neanderthalensis                 | -2.69| 0.032900|*   |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs Middle Pleistocene hominin          | -1.43| 0.184000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs H. erectus                          | -2.54| 0.032900|*   |
|ProportionalRep_MNIbased_os_coxae   |H. neanderthalensis vs Middle Pleistocene hominin |  0.29| 0.773000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. neanderthalensis vs H. erectus                 | -1.46| 0.184000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.184000|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs H. neanderthalensis                 | -1.97| 0.107000|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs Middle Pleistocene hominin          | -1.90| 0.107000|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs H. erectus                          | -2.60| 0.055200|ns  |
|ProportionalRep_MNIbased_radius     |H. neanderthalensis vs Middle Pleistocene hominin | -0.61| 0.542000|ns  |
|ProportionalRep_MNIbased_radius     |H. neanderthalensis vs H. erectus                 | -1.80| 0.107000|ns  |
|ProportionalRep_MNIbased_radius     |Middle Pleistocene hominin vs H. erectus          | -1.29| 0.237000|ns  |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs H. neanderthalensis                 | -3.35| 0.004900|**  |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs Middle Pleistocene hominin          | -2.72| 0.019700|*   |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs H. erectus                          | -2.31| 0.041300|*   |
|ProportionalRep_MNIbased_tibia      |H. neanderthalensis vs Middle Pleistocene hominin | -0.55| 0.585000|ns  |
|ProportionalRep_MNIbased_tibia      |H. neanderthalensis vs H. erectus                 | -0.99| 0.487000|ns  |
|ProportionalRep_MNIbased_tibia      |Middle Pleistocene hominin vs H. erectus          | -0.58| 0.585000|ns  |
|ReMNAU_cervical                     |H. sapiens vs H. neanderthalensis                 | -2.91| 0.021500|*   |
|ReMNAU_cervical                     |H. sapiens vs Middle Pleistocene hominin          | -2.45| 0.028300|*   |
|ReMNAU_cervical                     |H. sapiens vs H. erectus                          | -2.48| 0.028300|*   |
|ReMNAU_cervical                     |H. neanderthalensis vs Middle Pleistocene hominin | -0.56| 0.576000|ns  |
|ReMNAU_cervical                     |H. neanderthalensis vs H. erectus                 | -1.32| 0.281000|ns  |
|ReMNAU_cervical                     |Middle Pleistocene hominin vs H. erectus          | -0.88| 0.456000|ns  |
|ReMNAU_radius                       |H. sapiens vs H. neanderthalensis                 | -1.97| 0.097700|ns  |
|ReMNAU_radius                       |H. sapiens vs Middle Pleistocene hominin          | -2.20| 0.084300|ns  |
|ReMNAU_radius                       |H. sapiens vs H. erectus                          | -2.62| 0.052600|ns  |
|ReMNAU_radius                       |H. neanderthalensis vs Middle Pleistocene hominin | -0.89| 0.373000|ns  |
|ReMNAU_radius                       |H. neanderthalensis vs H. erectus                 | -1.82| 0.104000|ns  |
|ReMNAU_radius                       |Middle Pleistocene hominin vs H. erectus          | -1.14| 0.304000|ns  |
|ReMNAU_ulna                         |H. sapiens vs H. neanderthalensis                 | -2.37| 0.053600|ns  |
|ReMNAU_ulna                         |H. sapiens vs Middle Pleistocene hominin          | -2.12| 0.067800|ns  |
|ReMNAU_ulna                         |H. sapiens vs H. erectus                          | -2.67| 0.045400|*   |
|ReMNAU_ulna                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.58| 0.565000|ns  |
|ReMNAU_ulna                         |H. neanderthalensis vs H. erectus                 | -1.71| 0.130000|ns  |
|ReMNAU_ulna                         |Middle Pleistocene hominin vs H. erectus          | -1.23| 0.263000|ns  |
|all_sections_dominance              |H. sapiens vs H. neanderthalensis                 |  3.69| 0.001120|**  |
|all_sections_dominance              |H. sapiens vs Middle Pleistocene hominin          |  2.99| 0.005650|**  |
|all_sections_dominance              |H. sapiens vs H. erectus                          |  3.56| 0.001120|**  |
|all_sections_dominance              |H. neanderthalensis vs Middle Pleistocene hominin |  0.56| 0.576000|ns  |
|all_sections_dominance              |H. neanderthalensis vs H. erectus                 |  2.05| 0.059900|ns  |
|all_sections_dominance              |Middle Pleistocene hominin vs H. erectus          |  1.55| 0.146000|ns  |
|appendicular_dominance              |H. sapiens vs H. neanderthalensis                 |  2.65| 0.036500|*   |
|appendicular_dominance              |H. sapiens vs Middle Pleistocene hominin          | -0.29| 0.772000|ns  |
|appendicular_dominance              |H. sapiens vs H. erectus                          |  2.43| 0.036500|*   |
|appendicular_dominance              |H. neanderthalensis vs Middle Pleistocene hominin | -1.69| 0.110000|ns  |
|appendicular_dominance              |H. neanderthalensis vs H. erectus                 |  1.69| 0.110000|ns  |
|appendicular_dominance              |Middle Pleistocene hominin vs H. erectus          |  2.36| 0.036500|*   |
|appendicular_dominance_refined      |H. sapiens vs H. neanderthalensis                 |  2.65| 0.036500|*   |
|appendicular_dominance_refined      |H. sapiens vs Middle Pleistocene hominin          | -0.29| 0.772000|ns  |
|appendicular_dominance_refined      |H. sapiens vs H. erectus                          |  2.43| 0.036500|*   |
|appendicular_dominance_refined      |H. neanderthalensis vs Middle Pleistocene hominin | -1.69| 0.110000|ns  |
|appendicular_dominance_refined      |H. neanderthalensis vs H. erectus                 |  1.69| 0.110000|ns  |
|appendicular_dominance_refined      |Middle Pleistocene hominin vs H. erectus          |  2.36| 0.036500|*   |
|density_evenness                    |H. sapiens vs H. neanderthalensis                 | -4.22| 0.000146|*** |
|density_evenness                    |H. sapiens vs Middle Pleistocene hominin          | -2.88| 0.007970|**  |
|density_evenness                    |H. sapiens vs H. erectus                          | -3.49| 0.001430|**  |
|density_evenness                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.13| 0.896000|ns  |
|density_evenness                    |H. neanderthalensis vs H. erectus                 | -1.78| 0.111000|ns  |
|density_evenness                    |Middle Pleistocene hominin vs H. erectus          | -1.55| 0.146000|ns  |
|distal_appendicular_continuity_hm   |H. sapiens vs H. neanderthalensis                 | -3.83| 0.000755|*** |
|distal_appendicular_continuity_hm   |H. sapiens vs Middle Pleistocene hominin          | -2.04| 0.061000|ns  |
|distal_appendicular_continuity_hm   |H. sapiens vs H. erectus                          | -3.49| 0.001460|**  |
|distal_appendicular_continuity_hm   |H. neanderthalensis vs Middle Pleistocene hominin |  0.40| 0.686000|ns  |
|distal_appendicular_continuity_hm   |H. neanderthalensis vs H. erectus                 | -1.95| 0.061000|ns  |
|distal_appendicular_continuity_hm   |Middle Pleistocene hominin vs H. erectus          | -2.00| 0.061000|ns  |
|dominance_gap_all                   |H. sapiens vs H. neanderthalensis                 |  3.73| 0.001140|**  |
|dominance_gap_all                   |H. sapiens vs Middle Pleistocene hominin          |  3.01| 0.005270|**  |
|dominance_gap_all                   |H. sapiens vs H. erectus                          |  3.55| 0.001140|**  |
|dominance_gap_all                   |H. neanderthalensis vs Middle Pleistocene hominin |  0.56| 0.578000|ns  |
|dominance_gap_all                   |H. neanderthalensis vs H. erectus                 |  2.04| 0.062700|ns  |
|dominance_gap_all                   |Middle Pleistocene hominin vs H. erectus          |  1.53| 0.150000|ns  |
|dominant_axial_share                |H. sapiens vs H. neanderthalensis                 |  1.73| 0.123000|ns  |
|dominant_axial_share                |H. sapiens vs Middle Pleistocene hominin          |  2.62| 0.017500|*   |
|dominant_axial_share                |H. sapiens vs H. erectus                          |  3.43| 0.003650|**  |
|dominant_axial_share                |H. neanderthalensis vs Middle Pleistocene hominin |  1.45| 0.148000|ns  |
|dominant_axial_share                |H. neanderthalensis vs H. erectus                 |  2.70| 0.017500|*   |
|dominant_axial_share                |Middle Pleistocene hominin vs H. erectus          |  1.63| 0.123000|ns  |
|effective_sections_hill1            |H. sapiens vs H. neanderthalensis                 | -3.61| 0.001270|**  |
|effective_sections_hill1            |H. sapiens vs Middle Pleistocene hominin          | -2.64| 0.016800|*   |
|effective_sections_hill1            |H. sapiens vs H. erectus                          | -3.52| 0.001270|**  |
|effective_sections_hill1            |H. neanderthalensis vs Middle Pleistocene hominin | -0.28| 0.781000|ns  |
|effective_sections_hill1            |H. neanderthalensis vs H. erectus                 | -2.05| 0.059900|ns  |
|effective_sections_hill1            |Middle Pleistocene hominin vs H. erectus          | -1.71| 0.105000|ns  |
|low_density_axial_survival          |H. sapiens vs H. neanderthalensis                 | -4.11| 0.000237|*** |
|low_density_axial_survival          |H. sapiens vs Middle Pleistocene hominin          | -2.95| 0.006400|**  |
|low_density_axial_survival          |H. sapiens vs H. erectus                          | -3.46| 0.001590|**  |
|low_density_axial_survival          |H. neanderthalensis vs Middle Pleistocene hominin | -0.30| 0.767000|ns  |
|low_density_axial_survival          |H. neanderthalensis vs H. erectus                 | -1.82| 0.103000|ns  |
|low_density_axial_survival          |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.165000|ns  |
|low_density_share                   |H. sapiens vs H. neanderthalensis                 | -3.86| 0.000682|*** |
|low_density_share                   |H. sapiens vs Middle Pleistocene hominin          | -3.01| 0.005290|**  |
|low_density_share                   |H. sapiens vs H. erectus                          | -3.61| 0.000918|*** |
|low_density_share                   |H. neanderthalensis vs Middle Pleistocene hominin | -0.47| 0.635000|ns  |
|low_density_share                   |H. neanderthalensis vs H. erectus                 | -2.04| 0.062100|ns  |
|low_density_share                   |Middle Pleistocene hominin vs H. erectus          | -1.58| 0.136000|ns  |
|low_density_survival_index          |H. sapiens vs H. neanderthalensis                 | -4.01| 0.000369|*** |
|low_density_survival_index          |H. sapiens vs Middle Pleistocene hominin          | -2.75| 0.011900|*   |
|low_density_survival_index          |H. sapiens vs H. erectus                          | -3.58| 0.001020|**  |
|low_density_survival_index          |H. neanderthalensis vs Middle Pleistocene hominin | -0.17| 0.863000|ns  |
|low_density_survival_index          |H. neanderthalensis vs H. erectus                 | -1.98| 0.072000|ns  |
|low_density_survival_index          |Middle Pleistocene hominin vs H. erectus          | -1.70| 0.107000|ns  |
|lower_appendicular_continuity_hm    |H. sapiens vs H. neanderthalensis                 | -4.09| 0.000262|*** |
|lower_appendicular_continuity_hm    |H. sapiens vs Middle Pleistocene hominin          | -2.36| 0.036700|*   |
|lower_appendicular_continuity_hm    |H. sapiens vs H. erectus                          | -3.51| 0.001340|**  |
|lower_appendicular_continuity_hm    |H. neanderthalensis vs Middle Pleistocene hominin |  0.25| 0.801000|ns  |
|lower_appendicular_continuity_hm    |H. neanderthalensis vs H. erectus                 | -1.88| 0.077200|ns  |
|lower_appendicular_continuity_hm    |Middle Pleistocene hominin vs H. erectus          | -1.85| 0.077200|ns  |
|lower_appendicular_evenness         |H. sapiens vs H. neanderthalensis                 | -2.17| 0.053700|ns  |
|lower_appendicular_evenness         |H. sapiens vs Middle Pleistocene hominin          |  1.06| 0.291000|ns  |
|lower_appendicular_evenness         |H. sapiens vs H. erectus                          | -2.10| 0.053700|ns  |
|lower_appendicular_evenness         |H. neanderthalensis vs Middle Pleistocene hominin |  2.13| 0.053700|ns  |
|lower_appendicular_evenness         |H. neanderthalensis vs H. erectus                 | -1.46| 0.174000|ns  |
|lower_appendicular_evenness         |Middle Pleistocene hominin vs H. erectus          | -2.40| 0.053700|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs H. neanderthalensis                 | -2.17| 0.053700|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs Middle Pleistocene hominin          |  1.06| 0.291000|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs H. erectus                          | -2.10| 0.053700|ns  |
|lower_appendicular_evenness_refined |H. neanderthalensis vs Middle Pleistocene hominin |  2.13| 0.053700|ns  |
|lower_appendicular_evenness_refined |H. neanderthalensis vs H. erectus                 | -1.46| 0.174000|ns  |
|lower_appendicular_evenness_refined |Middle Pleistocene hominin vs H. erectus          | -2.40| 0.053700|ns  |
|mnau_appendicular_mean              |H. sapiens vs H. neanderthalensis                 | -3.79| 0.000710|*** |
|mnau_appendicular_mean              |H. sapiens vs Middle Pleistocene hominin          | -2.78| 0.010800|*   |
|mnau_appendicular_mean              |H. sapiens vs H. erectus                          | -3.68| 0.000710|*** |
|mnau_appendicular_mean              |H. neanderthalensis vs Middle Pleistocene hominin | -0.34| 0.738000|ns  |
|mnau_appendicular_mean              |H. neanderthalensis vs H. erectus                 | -2.15| 0.046800|*   |
|mnau_appendicular_mean              |Middle Pleistocene hominin vs H. erectus          | -1.77| 0.092800|ns  |
|mnau_arms                           |H. sapiens vs H. neanderthalensis                 | -3.05| 0.006850|**  |
|mnau_arms                           |H. sapiens vs Middle Pleistocene hominin          | -2.68| 0.014800|*   |
|mnau_arms                           |H. sapiens vs H. erectus                          | -3.35| 0.004790|**  |
|mnau_arms                           |H. neanderthalensis vs Middle Pleistocene hominin | -0.69| 0.490000|ns  |
|mnau_arms                           |H. neanderthalensis vs H. erectus                 | -2.12| 0.050800|ns  |
|mnau_arms                           |Middle Pleistocene hominin vs H. erectus          | -1.53| 0.150000|ns  |
|mnau_axial_main_mean                |H. sapiens vs H. neanderthalensis                 | -4.01| 0.000363|*** |
|mnau_axial_main_mean                |H. sapiens vs Middle Pleistocene hominin          | -2.92| 0.007080|**  |
|mnau_axial_main_mean                |H. sapiens vs H. erectus                          | -3.45| 0.001690|**  |
|mnau_axial_main_mean                |H. neanderthalensis vs Middle Pleistocene hominin | -0.33| 0.743000|ns  |
|mnau_axial_main_mean                |H. neanderthalensis vs H. erectus                 | -1.85| 0.097400|ns  |
|mnau_axial_main_mean                |Middle Pleistocene hominin vs H. erectus          | -1.49| 0.164000|ns  |
|mnau_column_trunk_mean              |H. sapiens vs H. neanderthalensis                 | -3.91| 0.000554|*** |
|mnau_column_trunk_mean              |H. sapiens vs Middle Pleistocene hominin          | -2.80| 0.010200|*   |
|mnau_column_trunk_mean              |H. sapiens vs H. erectus                          | -3.50| 0.001400|**  |
|mnau_column_trunk_mean              |H. neanderthalensis vs Middle Pleistocene hominin | -0.28| 0.780000|ns  |
|mnau_column_trunk_mean              |H. neanderthalensis vs H. erectus                 | -1.93| 0.079600|ns  |
|mnau_column_trunk_mean              |Middle Pleistocene hominin vs H. erectus          | -1.60| 0.132000|ns  |
|mnau_cv                             |H. sapiens vs H. neanderthalensis                 |  3.60| 0.001020|**  |
|mnau_cv                             |H. sapiens vs Middle Pleistocene hominin          |  2.72| 0.013200|*   |
|mnau_cv                             |H. sapiens vs H. erectus                          |  3.58| 0.001020|**  |
|mnau_cv                             |H. neanderthalensis vs Middle Pleistocene hominin |  0.36| 0.720000|ns  |
|mnau_cv                             |H. neanderthalensis vs H. erectus                 |  2.11| 0.051800|ns  |
|mnau_cv                             |Middle Pleistocene hominin vs H. erectus          |  1.72| 0.103000|ns  |
|mnau_distal_appendicular_mean       |H. sapiens vs H. neanderthalensis                 | -3.61| 0.001510|**  |
|mnau_distal_appendicular_mean       |H. sapiens vs Middle Pleistocene hominin          | -2.37| 0.035500|*   |
|mnau_distal_appendicular_mean       |H. sapiens vs H. erectus                          | -3.48| 0.001510|**  |
|mnau_distal_appendicular_mean       |H. neanderthalensis vs Middle Pleistocene hominin | -0.05| 0.957000|ns  |
|mnau_distal_appendicular_mean       |H. neanderthalensis vs H. erectus                 | -2.03| 0.063500|ns  |
|mnau_distal_appendicular_mean       |Middle Pleistocene hominin vs H. erectus          | -1.81| 0.083600|ns  |
|mnau_dominance_of_region_means      |H. sapiens vs H. neanderthalensis                 |  2.94| 0.006880|**  |
|mnau_dominance_of_region_means      |H. sapiens vs Middle Pleistocene hominin          |  2.93| 0.006880|**  |
|mnau_dominance_of_region_means      |H. sapiens vs H. erectus                          |  3.67| 0.001440|**  |
|mnau_dominance_of_region_means      |H. neanderthalensis vs Middle Pleistocene hominin |  0.96| 0.335000|ns  |
|mnau_dominance_of_region_means      |H. neanderthalensis vs H. erectus                 |  2.46| 0.021000|*   |
|mnau_dominance_of_region_means      |Middle Pleistocene hominin vs H. erectus          |  1.68| 0.111000|ns  |
|mnau_evenness_minus_dominance       |H. sapiens vs H. neanderthalensis                 | -3.63| 0.001210|**  |
|mnau_evenness_minus_dominance       |H. sapiens vs Middle Pleistocene hominin          | -2.79| 0.010500|*   |
|mnau_evenness_minus_dominance       |H. sapiens vs H. erectus                          | -3.54| 0.001210|**  |
|mnau_evenness_minus_dominance       |H. neanderthalensis vs Middle Pleistocene hominin | -0.41| 0.681000|ns  |
|mnau_evenness_minus_dominance       |H. neanderthalensis vs H. erectus                 | -2.06| 0.059300|ns  |
|mnau_evenness_minus_dominance       |Middle Pleistocene hominin vs H. erectus          | -1.64| 0.122000|ns  |
|mnau_foot                           |H. sapiens vs H. neanderthalensis                 | -3.96| 0.000454|*** |
|mnau_foot                           |H. sapiens vs Middle Pleistocene hominin          | -1.80| 0.113000|ns  |
|mnau_foot                           |H. sapiens vs H. erectus                          | -3.09| 0.005970|**  |
|mnau_foot                           |H. neanderthalensis vs Middle Pleistocene hominin |  0.70| 0.481000|ns  |
|mnau_foot                           |H. neanderthalensis vs H. erectus                 | -1.52| 0.156000|ns  |
|mnau_foot                           |Middle Pleistocene hominin vs H. erectus          | -1.78| 0.113000|ns  |
|mnau_gini                           |H. sapiens vs H. neanderthalensis                 |  3.61| 0.000929|*** |
|mnau_gini                           |H. sapiens vs Middle Pleistocene hominin          |  2.69| 0.014100|*   |
|mnau_gini                           |H. sapiens vs H. erectus                          |  3.65| 0.000929|*** |
|mnau_gini                           |H. neanderthalensis vs Middle Pleistocene hominin |  0.33| 0.738000|ns  |
|mnau_gini                           |H. neanderthalensis vs H. erectus                 |  2.18| 0.043900|*   |
|mnau_gini                           |Middle Pleistocene hominin vs H. erectus          |  1.79| 0.087700|ns  |
|mnau_girdle_mean                    |H. sapiens vs H. neanderthalensis                 | -3.67| 0.001470|**  |
|mnau_girdle_mean                    |H. sapiens vs Middle Pleistocene hominin          | -2.08| 0.074800|ns  |
|mnau_girdle_mean                    |H. sapiens vs H. erectus                          | -3.28| 0.003130|**  |
|mnau_girdle_mean                    |H. neanderthalensis vs Middle Pleistocene hominin |  0.26| 0.795000|ns  |
|mnau_girdle_mean                    |H. neanderthalensis vs H. erectus                 | -1.81| 0.087600|ns  |
|mnau_girdle_mean                    |Middle Pleistocene hominin vs H. erectus          | -1.79| 0.087600|ns  |
|mnau_hands                          |H. sapiens vs H. neanderthalensis                 | -2.87| 0.012400|*   |
|mnau_hands                          |H. sapiens vs Middle Pleistocene hominin          | -1.80| 0.108000|ns  |
|mnau_hands                          |H. sapiens vs H. erectus                          | -2.99| 0.012400|*   |
|mnau_hands                          |H. neanderthalensis vs Middle Pleistocene hominin |  0.04| 0.970000|ns  |
|mnau_hands                          |H. neanderthalensis vs H. erectus                 | -1.83| 0.108000|ns  |
|mnau_hands                          |Middle Pleistocene hominin vs H. erectus          | -1.69| 0.110000|ns  |
|mnau_heip_evenness                  |H. sapiens vs H. neanderthalensis                 | -3.61| 0.001270|**  |
|mnau_heip_evenness                  |H. sapiens vs Middle Pleistocene hominin          | -2.64| 0.016800|*   |
|mnau_heip_evenness                  |H. sapiens vs H. erectus                          | -3.52| 0.001270|**  |
|mnau_heip_evenness                  |H. neanderthalensis vs Middle Pleistocene hominin | -0.28| 0.781000|ns  |
|mnau_heip_evenness                  |H. neanderthalensis vs H. erectus                 | -2.05| 0.059900|ns  |
|mnau_heip_evenness                  |Middle Pleistocene hominin vs H. erectus          | -1.71| 0.105000|ns  |
|mnau_inverse_simpson                |H. sapiens vs H. neanderthalensis                 | -3.64| 0.001220|**  |
|mnau_inverse_simpson                |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012400|*   |
|mnau_inverse_simpson                |H. sapiens vs H. erectus                          | -3.54| 0.001220|**  |
|mnau_inverse_simpson                |H. neanderthalensis vs Middle Pleistocene hominin | -0.35| 0.723000|ns  |
|mnau_inverse_simpson                |H. neanderthalensis vs H. erectus                 | -2.05| 0.060300|ns  |
|mnau_inverse_simpson                |Middle Pleistocene hominin vs H. erectus          | -1.66| 0.115000|ns  |
|mnau_legs                           |H. sapiens vs H. neanderthalensis                 | -3.68| 0.001420|**  |
|mnau_legs                           |H. sapiens vs Middle Pleistocene hominin          | -2.82| 0.009510|**  |
|mnau_legs                           |H. sapiens vs H. erectus                          | -3.16| 0.004790|**  |
|mnau_legs                           |H. neanderthalensis vs Middle Pleistocene hominin | -0.44| 0.657000|ns  |
|mnau_legs                           |H. neanderthalensis vs H. erectus                 | -1.69| 0.137000|ns  |
|mnau_legs                           |Middle Pleistocene hominin vs H. erectus          | -1.28| 0.241000|ns  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs H. neanderthalensis                 | -3.49| 0.002040|**  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs Middle Pleistocene hominin          | -3.11| 0.003780|**  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs H. erectus                          | -3.40| 0.002040|**  |
|mnau_limb_shaft_proxy_mean          |H. neanderthalensis vs Middle Pleistocene hominin | -0.83| 0.407000|ns  |
|mnau_limb_shaft_proxy_mean          |H. neanderthalensis vs H. erectus                 | -2.00| 0.069000|ns  |
|mnau_limb_shaft_proxy_mean          |Middle Pleistocene hominin vs H. erectus          | -1.34| 0.216000|ns  |
|mnau_lower_appendicular_mean        |H. sapiens vs H. neanderthalensis                 | -3.88| 0.000623|*** |
|mnau_lower_appendicular_mean        |H. sapiens vs Middle Pleistocene hominin          | -2.80| 0.010400|*   |
|mnau_lower_appendicular_mean        |H. sapiens vs H. erectus                          | -3.46| 0.001620|**  |
|mnau_lower_appendicular_mean        |H. neanderthalensis vs Middle Pleistocene hominin | -0.29| 0.771000|ns  |
|mnau_lower_appendicular_mean        |H. neanderthalensis vs H. erectus                 | -1.91| 0.085000|ns  |
|mnau_lower_appendicular_mean        |Middle Pleistocene hominin vs H. erectus          | -1.56| 0.141000|ns  |
|mnau_pelvic                         |H. sapiens vs H. neanderthalensis                 | -2.85| 0.020800|*   |
|mnau_pelvic                         |H. sapiens vs Middle Pleistocene hominin          | -1.85| 0.128000|ns  |
|mnau_pelvic                         |H. sapiens vs H. erectus                          | -2.70| 0.020800|*   |
|mnau_pelvic                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.02| 0.983000|ns  |
|mnau_pelvic                         |H. neanderthalensis vs H. erectus                 | -1.56| 0.180000|ns  |
|mnau_pelvic                         |Middle Pleistocene hominin vs H. erectus          | -1.40| 0.193000|ns  |
|mnau_postcranial_total_mean         |H. sapiens vs H. neanderthalensis                 | -3.83| 0.000670|*** |
|mnau_postcranial_total_mean         |H. sapiens vs Middle Pleistocene hominin          | -2.93| 0.006870|**  |
|mnau_postcranial_total_mean         |H. sapiens vs H. erectus                          | -3.69| 0.000670|*** |
|mnau_postcranial_total_mean         |H. neanderthalensis vs Middle Pleistocene hominin | -0.45| 0.653000|ns  |
|mnau_postcranial_total_mean         |H. neanderthalensis vs H. erectus                 | -2.15| 0.046900|*   |
|mnau_postcranial_total_mean         |Middle Pleistocene hominin vs H. erectus          | -1.70| 0.107000|ns  |
|mnau_proximal_appendicular_mean     |H. sapiens vs H. neanderthalensis                 | -3.69| 0.001320|**  |
|mnau_proximal_appendicular_mean     |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012400|*   |
|mnau_proximal_appendicular_mean     |H. sapiens vs H. erectus                          | -3.48| 0.001510|**  |
|mnau_proximal_appendicular_mean     |H. neanderthalensis vs Middle Pleistocene hominin | -0.35| 0.726000|ns  |
|mnau_proximal_appendicular_mean     |H. neanderthalensis vs H. erectus                 | -2.00| 0.068900|ns  |
|mnau_proximal_appendicular_mean     |Middle Pleistocene hominin vs H. erectus          | -1.61| 0.128000|ns  |
|mnau_region_mean_evenness           |H. sapiens vs H. neanderthalensis                 | -3.46| 0.001600|**  |
|mnau_region_mean_evenness           |H. sapiens vs Middle Pleistocene hominin          | -2.59| 0.019100|*   |
|mnau_region_mean_evenness           |H. sapiens vs H. erectus                          | -3.72| 0.001200|**  |
|mnau_region_mean_evenness           |H. neanderthalensis vs Middle Pleistocene hominin | -0.33| 0.744000|ns  |
|mnau_region_mean_evenness           |H. neanderthalensis vs H. erectus                 | -2.30| 0.032000|*   |
|mnau_region_mean_evenness           |Middle Pleistocene hominin vs H. erectus          | -1.91| 0.067700|ns  |
|mnau_shoulder                       |H. sapiens vs H. neanderthalensis                 | -3.25| 0.007030|**  |
|mnau_shoulder                       |H. sapiens vs Middle Pleistocene hominin          | -1.75| 0.104000|ns  |
|mnau_shoulder                       |H. sapiens vs H. erectus                          | -3.02| 0.007680|**  |
|mnau_shoulder                       |H. neanderthalensis vs Middle Pleistocene hominin |  0.32| 0.748000|ns  |
|mnau_shoulder                       |H. neanderthalensis vs H. erectus                 | -1.71| 0.104000|ns  |
|mnau_shoulder                       |Middle Pleistocene hominin vs H. erectus          | -1.74| 0.104000|ns  |
|mnau_simpson_dominance              |H. sapiens vs H. neanderthalensis                 |  3.64| 0.001220|**  |
|mnau_simpson_dominance              |H. sapiens vs Middle Pleistocene hominin          |  2.74| 0.012400|*   |
|mnau_simpson_dominance              |H. sapiens vs H. erectus                          |  3.54| 0.001220|**  |
|mnau_simpson_dominance              |H. neanderthalensis vs Middle Pleistocene hominin |  0.35| 0.723000|ns  |
|mnau_simpson_dominance              |H. neanderthalensis vs H. erectus                 |  2.05| 0.060300|ns  |
|mnau_simpson_dominance              |Middle Pleistocene hominin vs H. erectus          |  1.66| 0.115000|ns  |
|mnau_simpson_evenness               |H. sapiens vs H. neanderthalensis                 | -3.64| 0.001220|**  |
|mnau_simpson_evenness               |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012400|*   |
|mnau_simpson_evenness               |H. sapiens vs H. erectus                          | -3.54| 0.001220|**  |
|mnau_simpson_evenness               |H. neanderthalensis vs Middle Pleistocene hominin | -0.35| 0.723000|ns  |
|mnau_simpson_evenness               |H. neanderthalensis vs H. erectus                 | -2.05| 0.060300|ns  |
|mnau_simpson_evenness               |Middle Pleistocene hominin vs H. erectus          | -1.66| 0.115000|ns  |
|mnau_top2_share_mcnaughton          |H. sapiens vs H. neanderthalensis                 |  3.87| 0.000608|*** |
|mnau_top2_share_mcnaughton          |H. sapiens vs Middle Pleistocene hominin          |  3.09| 0.004060|**  |
|mnau_top2_share_mcnaughton          |H. sapiens vs H. erectus                          |  3.72| 0.000608|*** |
|mnau_top2_share_mcnaughton          |H. neanderthalensis vs Middle Pleistocene hominin |  0.54| 0.587000|ns  |
|mnau_top2_share_mcnaughton          |H. neanderthalensis vs H. erectus                 |  2.14| 0.048700|*   |
|mnau_top2_share_mcnaughton          |Middle Pleistocene hominin vs H. erectus          |  1.64| 0.122000|ns  |
|mnau_upper_appendicular_mean        |H. sapiens vs H. neanderthalensis                 | -3.57| 0.001080|**  |
|mnau_upper_appendicular_mean        |H. sapiens vs Middle Pleistocene hominin          | -2.39| 0.034100|*   |
|mnau_upper_appendicular_mean        |H. sapiens vs H. erectus                          | -3.62| 0.001080|**  |
|mnau_upper_appendicular_mean        |H. neanderthalensis vs Middle Pleistocene hominin | -0.09| 0.926000|ns  |
|mnau_upper_appendicular_mean        |H. neanderthalensis vs H. erectus                 | -2.18| 0.043300|*   |
|mnau_upper_appendicular_mean        |Middle Pleistocene hominin vs H. erectus          | -1.93| 0.064100|ns  |
|mne_arms                            |H. sapiens vs H. neanderthalensis                 | -4.11| 0.000236|*** |
|mne_arms                            |H. sapiens vs Middle Pleistocene hominin          | -1.38| 0.202000|ns  |
|mne_arms                            |H. sapiens vs H. erectus                          | -3.42| 0.001910|**  |
|mne_arms                            |H. neanderthalensis vs Middle Pleistocene hominin |  1.20| 0.228000|ns  |
|mne_arms                            |H. neanderthalensis vs H. erectus                 | -1.77| 0.114000|ns  |
|mne_arms                            |Middle Pleistocene hominin vs H. erectus          | -2.30| 0.043000|*   |
|mne_cranial_share                   |H. sapiens vs H. neanderthalensis                 |  2.23| 0.039100|*   |
|mne_cranial_share                   |H. sapiens vs Middle Pleistocene hominin          |  2.74| 0.018700|*   |
|mne_cranial_share                   |H. sapiens vs H. erectus                          |  3.51| 0.002660|**  |
|mne_cranial_share                   |H. neanderthalensis vs Middle Pleistocene hominin |  1.25| 0.211000|ns  |
|mne_cranial_share                   |H. neanderthalensis vs H. erectus                 |  2.60| 0.018800|*   |
|mne_cranial_share                   |Middle Pleistocene hominin vs H. erectus          |  1.64| 0.120000|ns  |
|postcranial_dominance_refined       |H. sapiens vs H. neanderthalensis                 |  2.33| 0.059500|ns  |
|postcranial_dominance_refined       |H. sapiens vs Middle Pleistocene hominin          |  0.23| 0.820000|ns  |
|postcranial_dominance_refined       |H. sapiens vs H. erectus                          |  2.44| 0.059500|ns  |
|postcranial_dominance_refined       |H. neanderthalensis vs Middle Pleistocene hominin | -1.02| 0.369000|ns  |
|postcranial_dominance_refined       |H. neanderthalensis vs H. erectus                 |  1.78| 0.112000|ns  |
|postcranial_dominance_refined       |Middle Pleistocene hominin vs H. erectus          |  2.14| 0.065300|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.57, R² = 0.061, p = 0.0101.
PCA variance explained: PC1 56.7%, PC2 8.8%, PC3 6.3% (cumulative 71.8%).
Dispersion caveat (PERMDISP): p = 0.002 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160| -0.138| -0.020|
|mnau_appendicular_mean      | -0.160| -0.136|  0.029|
|mnau_top2_share_mcnaughton  |  0.158| -0.139| -0.001|
|mnau_gini                   |  0.158| -0.117| -0.013|
|effective_sections_hill1    | -0.158|  0.132|  0.007|
|mnau_heip_evenness          | -0.158|  0.132|  0.007|
|mnau_inverse_simpson        | -0.158|  0.108|  0.012|
|mnau_simpson_evenness       | -0.158|  0.108|  0.012|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
