# Species (context-controlled)
*Automated hominin_species × skeletal-part representation*

- **Grouping column:** `hominin_species` (mode = single)
- **Groups (n):** H. sapiens = 79; H. neanderthalensis = 50; Middle Pleistocene hominin = 14; H. erectus = 5
- **Sites analysed:** 148  |  **features screened:** 63

## Hypothesis

**H:** Species-level differences may reflect different depositional histories, not anatomy alone.

**Expected pattern:** Neanderthal / earlier Homo / H. sapiens may differ, but differences may vanish after controlling for age, site type, period, context.

**Why it matters:** Interesting but risky; do not read causally unless preservation and context are controlled.


## Summary

56 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **density_evenness** (ε² = 0.201, FDR p = 1.19e-05). PERMANOVA pseudo-F = 2.54, p = 0.0097; PC1–PC3 explain 71.8% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 213 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 23 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|density_evenness                             |  0.201| 1.19e-05|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.200| 1.19e-05|large      |significant |
|low_density_axial_survival                   |  0.190| 1.19e-05|large      |significant |
|low_density_share                            |  0.188| 1.19e-05|large      |significant |
|dominance_gap_all                            |  0.184| 1.19e-05|large      |significant |
|all_sections_dominance                       |  0.184| 1.19e-05|large      |significant |
|low_density_survival_index                   |  0.184| 1.19e-05|large      |significant |
|mnau_postcranial_total_mean                  |  0.183| 1.19e-05|large      |significant |
|mnau_axial_main_mean                         |  0.182| 1.19e-05|large      |significant |
|mnau_column_trunk_mean                       |  0.179| 1.19e-05|large      |significant |
|mnau_appendicular_mean                       |  0.178| 1.19e-05|large      |significant |
|mnau_gini                                    |  0.178| 1.19e-05|large      |significant |
|mnau_evenness_minus_dominance                |  0.177| 1.19e-05|large      |significant |
|mnau_cv                                      |  0.177| 1.19e-05|large      |significant |
|mnau_inverse_simpson                         |  0.176| 1.19e-05|large      |significant |
|mnau_simpson_evenness                        |  0.176| 1.19e-05|large      |significant |
|mnau_simpson_dominance                       |  0.176| 1.19e-05|large      |significant |
|lower_appendicular_continuity_hm             |  0.174| 1.19e-05|large      |significant |
|mnau_lower_appendicular_mean                 |  0.174| 1.19e-05|large      |significant |
|effective_sections_hill1                     |  0.173| 1.39e-05|large      |significant |
|mnau_heip_evenness                           |  0.173| 1.39e-05|large      |significant |
|mnau_region_mean_evenness                    |  0.169| 1.65e-05|large      |significant |
|mnau_dominance_of_region_means               |  0.162| 2.53e-05|large      |significant |
|mnau_proximal_appendicular_mean              |  0.161| 2.39e-05|large      |significant |
|distal_appendicular_continuity_hm            |  0.157| 2.91e-05|large      |significant |
|mnau_distal_appendicular_mean                |  0.156| 2.91e-05|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.156| 2.94e-05|large      |significant |
|mne_arms                                     |  0.155| 2.98e-05|large      |significant |
|mnau_upper_appendicular_mean                 |  0.155| 2.98e-05|large      |significant |
|mnau_legs                                    |  0.146| 5.27e-05|large      |significant |
|mnau_foot                                    |  0.143| 6.20e-05|large      |significant |
|mnau_girdle_mean                             |  0.141| 7.11e-05|large      |significant |
|ProportionalRep_MNIbased_humerus             |  0.136| 9.37e-05|moderate   |significant |
|mnau_arms                                    |  0.128| 1.62e-04|moderate   |significant |
|mne_cranial_share                            |  0.127| 1.66e-04|moderate   |significant |
|dominant_axial_share                         |  0.113| 4.06e-04|moderate   |significant |
|ProportionalRep_MNIbased_fibula              |  0.108| 5.74e-04|moderate   |significant |
|mnau_shoulder                                |  0.106| 6.27e-04|moderate   |significant |
|ProportionalRep_MNIbased_femur               |  0.105| 6.61e-04|moderate   |significant |
|ProportionalRep_MNIbased_tibia               |  0.104| 6.98e-04|moderate   |significant |
|mnau_hands                                   |  0.098| 1.04e-03|moderate   |significant |
|ReMNAU_cervical                              |  0.097| 1.09e-03|moderate   |significant |
|mnau_pelvic                                  |  0.087| 2.08e-03|moderate   |significant |
|ProportionalRep_MNIbased_cervical            |  0.084| 2.52e-03|moderate   |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.082| 2.84e-03|moderate   |significant |
|appendicular_dominance                       |  0.075| 8.74e-03|moderate   |significant |
|appendicular_dominance_refined               |  0.075| 8.74e-03|moderate   |significant |
|ProportionalRep_MNIbased_clavicle            |  0.074| 4.78e-03|moderate   |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.072| 5.24e-03|moderate   |significant |
|ReMNAU_ulna                                  |  0.066| 7.85e-03|moderate   |significant |
|postcranial_dominance_refined                |  0.062| 1.64e-02|moderate   |significant |
|ReMNAU_radius                                |  0.060| 1.08e-02|moderate   |significant |
|ProportionalRep_MNIbased_radius              |  0.059| 1.12e-02|small      |significant |
|lower_appendicular_evenness                  |  0.056| 2.54e-02|small      |significant |
|lower_appendicular_evenness_refined          |  0.056| 2.54e-02|small      |significant |
|ProportionalRep_MNIbased_carpal              |  0.053| 1.64e-02|small      |significant |
|mnau_vertebrae_to_thorax_ratio               |  0.009| 2.46e-01|negligible |n.s.        |
|mnau_arms_legs_logratio                      |  0.009| 2.46e-01|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.009| 2.46e-01|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.003| 3.54e-01|negligible |n.s.        |
|mnau_arms_legs_diff                          |  0.000| 4.09e-01|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.006| 5.44e-01|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.014| 7.98e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                          |     Z|  p (adj)|Sig |
|:-----------------------------------|:-------------------------------------------------|-----:|--------:|:---|
|ProportionalRep_MNIbased_carpal     |H. sapiens vs H. neanderthalensis                 | -2.72| 0.039300|*   |
|ProportionalRep_MNIbased_carpal     |H. sapiens vs Middle Pleistocene hominin          | -1.28| 0.364000|ns  |
|ProportionalRep_MNIbased_carpal     |H. sapiens vs H. erectus                          | -2.11| 0.104000|ns  |
|ProportionalRep_MNIbased_carpal     |H. neanderthalensis vs Middle Pleistocene hominin |  0.39| 0.694000|ns  |
|ProportionalRep_MNIbased_carpal     |H. neanderthalensis vs H. erectus                 | -1.03| 0.364000|ns  |
|ProportionalRep_MNIbased_carpal     |Middle Pleistocene hominin vs H. erectus          | -1.15| 0.364000|ns  |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs H. neanderthalensis                 | -2.73| 0.028600|*   |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs Middle Pleistocene hominin          | -2.56| 0.028600|*   |
|ProportionalRep_MNIbased_cervical   |H. sapiens vs H. erectus                          | -2.45| 0.028600|*   |
|ProportionalRep_MNIbased_cervical   |H. neanderthalensis vs Middle Pleistocene hominin | -0.83| 0.458000|ns  |
|ProportionalRep_MNIbased_cervical   |H. neanderthalensis vs H. erectus                 | -1.36| 0.262000|ns  |
|ProportionalRep_MNIbased_cervical   |Middle Pleistocene hominin vs H. erectus          | -0.74| 0.458000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs H. neanderthalensis                 | -2.77| 0.020500|*   |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs Middle Pleistocene hominin          | -1.56| 0.152000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. sapiens vs H. erectus                          | -2.70| 0.020500|*   |
|ProportionalRep_MNIbased_clavicle   |H. neanderthalensis vs Middle Pleistocene hominin |  0.16| 0.873000|ns  |
|ProportionalRep_MNIbased_clavicle   |H. neanderthalensis vs H. erectus                 | -1.59| 0.152000|ns  |
|ProportionalRep_MNIbased_clavicle   |Middle Pleistocene hominin vs H. erectus          | -1.53| 0.152000|ns  |
|ProportionalRep_MNIbased_femur      |H. sapiens vs H. neanderthalensis                 | -2.79| 0.015700|*   |
|ProportionalRep_MNIbased_femur      |H. sapiens vs Middle Pleistocene hominin          | -2.43| 0.030100|*   |
|ProportionalRep_MNIbased_femur      |H. sapiens vs H. erectus                          | -3.16| 0.009550|**  |
|ProportionalRep_MNIbased_femur      |H. neanderthalensis vs Middle Pleistocene hominin | -0.66| 0.507000|ns  |
|ProportionalRep_MNIbased_femur      |H. neanderthalensis vs H. erectus                 | -2.03| 0.063700|ns  |
|ProportionalRep_MNIbased_femur      |Middle Pleistocene hominin vs H. erectus          | -1.44| 0.179000|ns  |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs H. neanderthalensis                 | -3.38| 0.004420|**  |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs Middle Pleistocene hominin          | -2.31| 0.042200|*   |
|ProportionalRep_MNIbased_fibula     |H. sapiens vs H. erectus                          | -2.77| 0.017000|*   |
|ProportionalRep_MNIbased_fibula     |H. neanderthalensis vs Middle Pleistocene hominin | -0.19| 0.846000|ns  |
|ProportionalRep_MNIbased_fibula     |H. neanderthalensis vs H. erectus                 | -1.42| 0.234000|ns  |
|ProportionalRep_MNIbased_fibula     |Middle Pleistocene hominin vs H. erectus          | -1.16| 0.293000|ns  |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs H. neanderthalensis                 | -3.23| 0.003690|**  |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs Middle Pleistocene hominin          | -2.88| 0.007900|**  |
|ProportionalRep_MNIbased_humerus    |H. sapiens vs H. erectus                          | -3.31| 0.003690|**  |
|ProportionalRep_MNIbased_humerus    |H. neanderthalensis vs Middle Pleistocene hominin | -0.83| 0.405000|ns  |
|ProportionalRep_MNIbased_humerus    |H. neanderthalensis vs H. erectus                 | -2.01| 0.066100|ns  |
|ProportionalRep_MNIbased_humerus    |Middle Pleistocene hominin vs H. erectus          | -1.33| 0.220000|ns  |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs H. neanderthalensis                 | -2.46| 0.027800|*   |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs Middle Pleistocene hominin          | -2.61| 0.027800|*   |
|ProportionalRep_MNIbased_metacarpal |H. sapiens vs H. erectus                          | -2.57| 0.027800|*   |
|ProportionalRep_MNIbased_metacarpal |H. neanderthalensis vs Middle Pleistocene hominin | -1.03| 0.363000|ns  |
|ProportionalRep_MNIbased_metacarpal |H. neanderthalensis vs H. erectus                 | -1.58| 0.172000|ns  |
|ProportionalRep_MNIbased_metacarpal |Middle Pleistocene hominin vs H. erectus          | -0.82| 0.411000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs H. neanderthalensis                 | -2.71| 0.031100|*   |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs Middle Pleistocene hominin          | -1.87| 0.123000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. sapiens vs H. erectus                          | -2.56| 0.031100|*   |
|ProportionalRep_MNIbased_os_coxae   |H. neanderthalensis vs Middle Pleistocene hominin | -0.17| 0.863000|ns  |
|ProportionalRep_MNIbased_os_coxae   |H. neanderthalensis vs H. erectus                 | -1.47| 0.211000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Middle Pleistocene hominin vs H. erectus          | -1.23| 0.264000|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs H. neanderthalensis                 | -1.98| 0.095200|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs Middle Pleistocene hominin          | -2.04| 0.095200|ns  |
|ProportionalRep_MNIbased_radius     |H. sapiens vs H. erectus                          | -2.60| 0.055500|ns  |
|ProportionalRep_MNIbased_radius     |H. neanderthalensis vs Middle Pleistocene hominin | -0.77| 0.440000|ns  |
|ProportionalRep_MNIbased_radius     |H. neanderthalensis vs H. erectus                 | -1.80| 0.109000|ns  |
|ProportionalRep_MNIbased_radius     |Middle Pleistocene hominin vs H. erectus          | -1.17| 0.291000|ns  |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs H. neanderthalensis                 | -3.36| 0.004740|**  |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs Middle Pleistocene hominin          | -2.71| 0.020200|*   |
|ProportionalRep_MNIbased_tibia      |H. sapiens vs H. erectus                          | -2.30| 0.042500|*   |
|ProportionalRep_MNIbased_tibia      |H. neanderthalensis vs Middle Pleistocene hominin | -0.59| 0.596000|ns  |
|ProportionalRep_MNIbased_tibia      |H. neanderthalensis vs H. erectus                 | -0.97| 0.497000|ns  |
|ProportionalRep_MNIbased_tibia      |Middle Pleistocene hominin vs H. erectus          | -0.53| 0.596000|ns  |
|ReMNAU_cervical                     |H. sapiens vs H. neanderthalensis                 | -2.93| 0.016000|*   |
|ReMNAU_cervical                     |H. sapiens vs Middle Pleistocene hominin          | -2.79| 0.016000|*   |
|ReMNAU_cervical                     |H. sapiens vs H. erectus                          | -2.49| 0.025500|*   |
|ReMNAU_cervical                     |H. neanderthalensis vs Middle Pleistocene hominin | -0.92| 0.428000|ns  |
|ReMNAU_cervical                     |H. neanderthalensis vs H. erectus                 | -1.32| 0.280000|ns  |
|ReMNAU_cervical                     |Middle Pleistocene hominin vs H. erectus          | -0.65| 0.513000|ns  |
|ReMNAU_radius                       |H. sapiens vs H. neanderthalensis                 | -1.95| 0.103000|ns  |
|ReMNAU_radius                       |H. sapiens vs Middle Pleistocene hominin          | -2.11| 0.103000|ns  |
|ReMNAU_radius                       |H. sapiens vs H. erectus                          | -2.60| 0.055800|ns  |
|ReMNAU_radius                       |H. neanderthalensis vs Middle Pleistocene hominin | -0.86| 0.390000|ns  |
|ReMNAU_radius                       |H. neanderthalensis vs H. erectus                 | -1.81| 0.106000|ns  |
|ReMNAU_radius                       |Middle Pleistocene hominin vs H. erectus          | -1.13| 0.311000|ns  |
|ReMNAU_ulna                         |H. sapiens vs H. neanderthalensis                 | -2.33| 0.058800|ns  |
|ReMNAU_ulna                         |H. sapiens vs Middle Pleistocene hominin          | -1.94| 0.104000|ns  |
|ReMNAU_ulna                         |H. sapiens vs H. erectus                          | -2.64| 0.049300|*   |
|ReMNAU_ulna                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.47| 0.640000|ns  |
|ReMNAU_ulna                         |H. neanderthalensis vs H. erectus                 | -1.70| 0.134000|ns  |
|ReMNAU_ulna                         |Middle Pleistocene hominin vs H. erectus          | -1.26| 0.250000|ns  |
|all_sections_dominance              |H. sapiens vs H. neanderthalensis                 |  3.71| 0.001030|**  |
|all_sections_dominance              |H. sapiens vs Middle Pleistocene hominin          |  3.43| 0.001200|**  |
|all_sections_dominance              |H. sapiens vs H. erectus                          |  3.58| 0.001030|**  |
|all_sections_dominance              |H. neanderthalensis vs Middle Pleistocene hominin |  1.04| 0.298000|ns  |
|all_sections_dominance              |H. neanderthalensis vs H. erectus                 |  2.07| 0.058000|ns  |
|all_sections_dominance              |Middle Pleistocene hominin vs H. erectus          |  1.26| 0.250000|ns  |
|appendicular_dominance              |H. sapiens vs H. neanderthalensis                 |  2.65| 0.043200|*   |
|appendicular_dominance              |H. sapiens vs Middle Pleistocene hominin          |  0.10| 0.924000|ns  |
|appendicular_dominance              |H. sapiens vs H. erectus                          |  2.45| 0.043200|*   |
|appendicular_dominance              |H. neanderthalensis vs Middle Pleistocene hominin | -1.25| 0.253000|ns  |
|appendicular_dominance              |H. neanderthalensis vs H. erectus                 |  1.70| 0.134000|ns  |
|appendicular_dominance              |Middle Pleistocene hominin vs H. erectus          |  2.17| 0.059700|ns  |
|appendicular_dominance_refined      |H. sapiens vs H. neanderthalensis                 |  2.65| 0.043200|*   |
|appendicular_dominance_refined      |H. sapiens vs Middle Pleistocene hominin          |  0.10| 0.924000|ns  |
|appendicular_dominance_refined      |H. sapiens vs H. erectus                          |  2.45| 0.043200|*   |
|appendicular_dominance_refined      |H. neanderthalensis vs Middle Pleistocene hominin | -1.25| 0.253000|ns  |
|appendicular_dominance_refined      |H. neanderthalensis vs H. erectus                 |  1.70| 0.134000|ns  |
|appendicular_dominance_refined      |Middle Pleistocene hominin vs H. erectus          |  2.17| 0.059700|ns  |
|density_evenness                    |H. sapiens vs H. neanderthalensis                 | -4.25| 0.000129|*** |
|density_evenness                    |H. sapiens vs Middle Pleistocene hominin          | -3.36| 0.001560|**  |
|density_evenness                    |H. sapiens vs H. erectus                          | -3.52| 0.001300|**  |
|density_evenness                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.65| 0.517000|ns  |
|density_evenness                    |H. neanderthalensis vs H. erectus                 | -1.80| 0.108000|ns  |
|density_evenness                    |Middle Pleistocene hominin vs H. erectus          | -1.24| 0.256000|ns  |
|distal_appendicular_continuity_hm   |H. sapiens vs H. neanderthalensis                 | -3.86| 0.000684|*** |
|distal_appendicular_continuity_hm   |H. sapiens vs Middle Pleistocene hominin          | -2.45| 0.028300|*   |
|distal_appendicular_continuity_hm   |H. sapiens vs H. erectus                          | -3.51| 0.001340|**  |
|distal_appendicular_continuity_hm   |H. neanderthalensis vs Middle Pleistocene hominin | -0.05| 0.963000|ns  |
|distal_appendicular_continuity_hm   |H. neanderthalensis vs H. erectus                 | -1.97| 0.074100|ns  |
|distal_appendicular_continuity_hm   |Middle Pleistocene hominin vs H. erectus          | -1.74| 0.097700|ns  |
|dominance_gap_all                   |H. sapiens vs H. neanderthalensis                 |  3.75| 0.001050|**  |
|dominance_gap_all                   |H. sapiens vs Middle Pleistocene hominin          |  3.41| 0.001310|**  |
|dominance_gap_all                   |H. sapiens vs H. erectus                          |  3.57| 0.001060|**  |
|dominance_gap_all                   |H. neanderthalensis vs Middle Pleistocene hominin |  0.99| 0.321000|ns  |
|dominance_gap_all                   |H. neanderthalensis vs H. erectus                 |  2.05| 0.061200|ns  |
|dominance_gap_all                   |Middle Pleistocene hominin vs H. erectus          |  1.27| 0.247000|ns  |
|dominant_axial_share                |H. sapiens vs H. neanderthalensis                 |  1.75| 0.097100|ns  |
|dominant_axial_share                |H. sapiens vs Middle Pleistocene hominin          |  2.97| 0.008790|**  |
|dominant_axial_share                |H. sapiens vs H. erectus                          |  3.44| 0.003450|**  |
|dominant_axial_share                |H. neanderthalensis vs Middle Pleistocene hominin |  1.81| 0.097100|ns  |
|dominant_axial_share                |H. neanderthalensis vs H. erectus                 |  2.71| 0.013400|*   |
|dominant_axial_share                |Middle Pleistocene hominin vs H. erectus          |  1.39| 0.164000|ns  |
|effective_sections_hill1            |H. sapiens vs H. neanderthalensis                 | -3.63| 0.001130|**  |
|effective_sections_hill1            |H. sapiens vs Middle Pleistocene hominin          | -3.23| 0.002480|**  |
|effective_sections_hill1            |H. sapiens vs H. erectus                          | -3.56| 0.001130|**  |
|effective_sections_hill1            |H. neanderthalensis vs Middle Pleistocene hominin | -0.90| 0.369000|ns  |
|effective_sections_hill1            |H. neanderthalensis vs H. erectus                 | -2.08| 0.056600|ns  |
|effective_sections_hill1            |Middle Pleistocene hominin vs H. erectus          | -1.35| 0.212000|ns  |
|low_density_axial_survival          |H. sapiens vs H. neanderthalensis                 | -4.15| 0.000198|*** |
|low_density_axial_survival          |H. sapiens vs Middle Pleistocene hominin          | -3.31| 0.001880|**  |
|low_density_axial_survival          |H. sapiens vs H. erectus                          | -3.48| 0.001480|**  |
|low_density_axial_survival          |H. neanderthalensis vs Middle Pleistocene hominin | -0.69| 0.489000|ns  |
|low_density_axial_survival          |H. neanderthalensis vs H. erectus                 | -1.83| 0.102000|ns  |
|low_density_axial_survival          |Middle Pleistocene hominin vs H. erectus          | -1.24| 0.257000|ns  |
|low_density_share                   |H. sapiens vs H. neanderthalensis                 | -3.89| 0.000612|*** |
|low_density_share                   |H. sapiens vs Middle Pleistocene hominin          | -3.31| 0.001860|**  |
|low_density_share                   |H. sapiens vs H. erectus                          | -3.62| 0.000869|*** |
|low_density_share                   |H. neanderthalensis vs Middle Pleistocene hominin | -0.82| 0.413000|ns  |
|low_density_share                   |H. neanderthalensis vs H. erectus                 | -2.04| 0.061500|ns  |
|low_density_share                   |Middle Pleistocene hominin vs H. erectus          | -1.37| 0.206000|ns  |
|low_density_survival_index          |H. sapiens vs H. neanderthalensis                 | -4.05| 0.000306|*** |
|low_density_survival_index          |H. sapiens vs Middle Pleistocene hominin          | -3.07| 0.004300|**  |
|low_density_survival_index          |H. sapiens vs H. erectus                          | -3.60| 0.000957|*** |
|low_density_survival_index          |H. neanderthalensis vs Middle Pleistocene hominin | -0.52| 0.602000|ns  |
|low_density_survival_index          |H. neanderthalensis vs H. erectus                 | -1.98| 0.071900|ns  |
|low_density_survival_index          |Middle Pleistocene hominin vs H. erectus          | -1.48| 0.167000|ns  |
|lower_appendicular_continuity_hm    |H. sapiens vs H. neanderthalensis                 | -4.10| 0.000245|*** |
|lower_appendicular_continuity_hm    |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012300|*   |
|lower_appendicular_continuity_hm    |H. sapiens vs H. erectus                          | -3.53| 0.001250|**  |
|lower_appendicular_continuity_hm    |H. neanderthalensis vs Middle Pleistocene hominin | -0.17| 0.861000|ns  |
|lower_appendicular_continuity_hm    |H. neanderthalensis vs H. erectus                 | -1.89| 0.088200|ns  |
|lower_appendicular_continuity_hm    |Middle Pleistocene hominin vs H. erectus          | -1.60| 0.132000|ns  |
|lower_appendicular_evenness         |H. sapiens vs H. neanderthalensis                 | -2.19| 0.068800|ns  |
|lower_appendicular_evenness         |H. sapiens vs Middle Pleistocene hominin          |  0.60| 0.550000|ns  |
|lower_appendicular_evenness         |H. sapiens vs H. erectus                          | -2.12| 0.068800|ns  |
|lower_appendicular_evenness         |H. neanderthalensis vs Middle Pleistocene hominin |  1.65| 0.149000|ns  |
|lower_appendicular_evenness         |H. neanderthalensis vs H. erectus                 | -1.47| 0.170000|ns  |
|lower_appendicular_evenness         |Middle Pleistocene hominin vs H. erectus          | -2.18| 0.068800|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs H. neanderthalensis                 | -2.19| 0.068800|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs Middle Pleistocene hominin          |  0.60| 0.550000|ns  |
|lower_appendicular_evenness_refined |H. sapiens vs H. erectus                          | -2.12| 0.068800|ns  |
|lower_appendicular_evenness_refined |H. neanderthalensis vs Middle Pleistocene hominin |  1.65| 0.149000|ns  |
|lower_appendicular_evenness_refined |H. neanderthalensis vs H. erectus                 | -1.47| 0.170000|ns  |
|lower_appendicular_evenness_refined |Middle Pleistocene hominin vs H. erectus          | -2.18| 0.068800|ns  |
|mnau_appendicular_mean              |H. sapiens vs H. neanderthalensis                 | -3.82| 0.000669|*** |
|mnau_appendicular_mean              |H. sapiens vs Middle Pleistocene hominin          | -3.09| 0.004010|**  |
|mnau_appendicular_mean              |H. sapiens vs H. erectus                          | -3.69| 0.000669|*** |
|mnau_appendicular_mean              |H. neanderthalensis vs Middle Pleistocene hominin | -0.68| 0.495000|ns  |
|mnau_appendicular_mean              |H. neanderthalensis vs H. erectus                 | -2.16| 0.046200|*   |
|mnau_appendicular_mean              |Middle Pleistocene hominin vs H. erectus          | -1.55| 0.146000|ns  |
|mnau_arms                           |H. sapiens vs H. neanderthalensis                 | -3.05| 0.006930|**  |
|mnau_arms                           |H. sapiens vs Middle Pleistocene hominin          | -2.74| 0.012200|*   |
|mnau_arms                           |H. sapiens vs H. erectus                          | -3.35| 0.004890|**  |
|mnau_arms                           |H. neanderthalensis vs Middle Pleistocene hominin | -0.81| 0.419000|ns  |
|mnau_arms                           |H. neanderthalensis vs H. erectus                 | -2.12| 0.051400|ns  |
|mnau_arms                           |Middle Pleistocene hominin vs H. erectus          | -1.44| 0.181000|ns  |
|mnau_axial_main_mean                |H. sapiens vs H. neanderthalensis                 | -4.04| 0.000314|*** |
|mnau_axial_main_mean                |H. sapiens vs Middle Pleistocene hominin          | -3.22| 0.002580|**  |
|mnau_axial_main_mean                |H. sapiens vs H. erectus                          | -3.46| 0.001600|**  |
|mnau_axial_main_mean                |H. neanderthalensis vs Middle Pleistocene hominin | -0.67| 0.504000|ns  |
|mnau_axial_main_mean                |H. neanderthalensis vs H. erectus                 | -1.85| 0.097200|ns  |
|mnau_axial_main_mean                |Middle Pleistocene hominin vs H. erectus          | -1.27| 0.243000|ns  |
|mnau_column_trunk_mean              |H. sapiens vs H. neanderthalensis                 | -3.93| 0.000501|*** |
|mnau_column_trunk_mean              |H. sapiens vs Middle Pleistocene hominin          | -3.20| 0.002790|**  |
|mnau_column_trunk_mean              |H. sapiens vs H. erectus                          | -3.52| 0.001300|**  |
|mnau_column_trunk_mean              |H. neanderthalensis vs Middle Pleistocene hominin | -0.71| 0.475000|ns  |
|mnau_column_trunk_mean              |H. neanderthalensis vs H. erectus                 | -1.94| 0.077900|ns  |
|mnau_column_trunk_mean              |Middle Pleistocene hominin vs H. erectus          | -1.34| 0.218000|ns  |
|mnau_cv                             |H. sapiens vs H. neanderthalensis                 |  3.63| 0.000907|*** |
|mnau_cv                             |H. sapiens vs Middle Pleistocene hominin          |  3.26| 0.002250|**  |
|mnau_cv                             |H. sapiens vs H. erectus                          |  3.61| 0.000907|*** |
|mnau_cv                             |H. neanderthalensis vs Middle Pleistocene hominin |  0.92| 0.357000|ns  |
|mnau_cv                             |H. neanderthalensis vs H. erectus                 |  2.13| 0.049600|*   |
|mnau_cv                             |Middle Pleistocene hominin vs H. erectus          |  1.39| 0.199000|ns  |
|mnau_distal_appendicular_mean       |H. sapiens vs H. neanderthalensis                 | -3.65| 0.001370|**  |
|mnau_distal_appendicular_mean       |H. sapiens vs Middle Pleistocene hominin          | -2.82| 0.009600|**  |
|mnau_distal_appendicular_mean       |H. sapiens vs H. erectus                          | -3.50| 0.001370|**  |
|mnau_distal_appendicular_mean       |H. neanderthalensis vs Middle Pleistocene hominin | -0.53| 0.600000|ns  |
|mnau_distal_appendicular_mean       |H. neanderthalensis vs H. erectus                 | -2.04| 0.061900|ns  |
|mnau_distal_appendicular_mean       |Middle Pleistocene hominin vs H. erectus          | -1.53| 0.151000|ns  |
|mnau_dominance_of_region_means      |H. sapiens vs H. neanderthalensis                 |  2.97| 0.005960|**  |
|mnau_dominance_of_region_means      |H. sapiens vs Middle Pleistocene hominin          |  3.35| 0.002430|**  |
|mnau_dominance_of_region_means      |H. sapiens vs H. erectus                          |  3.69| 0.001330|**  |
|mnau_dominance_of_region_means      |H. neanderthalensis vs Middle Pleistocene hominin |  1.41| 0.160000|ns  |
|mnau_dominance_of_region_means      |H. neanderthalensis vs H. erectus                 |  2.47| 0.020400|*   |
|mnau_dominance_of_region_means      |Middle Pleistocene hominin vs H. erectus          |  1.41| 0.160000|ns  |
|mnau_evenness_minus_dominance       |H. sapiens vs H. neanderthalensis                 | -3.65| 0.001090|**  |
|mnau_evenness_minus_dominance       |H. sapiens vs Middle Pleistocene hominin          | -3.32| 0.001800|**  |
|mnau_evenness_minus_dominance       |H. sapiens vs H. erectus                          | -3.57| 0.001090|**  |
|mnau_evenness_minus_dominance       |H. neanderthalensis vs Middle Pleistocene hominin | -0.97| 0.332000|ns  |
|mnau_evenness_minus_dominance       |H. neanderthalensis vs H. erectus                 | -2.08| 0.056700|ns  |
|mnau_evenness_minus_dominance       |Middle Pleistocene hominin vs H. erectus          | -1.31| 0.229000|ns  |
|mnau_foot                           |H. sapiens vs H. neanderthalensis                 | -3.98| 0.000409|*** |
|mnau_foot                           |H. sapiens vs Middle Pleistocene hominin          | -2.21| 0.054100|ns  |
|mnau_foot                           |H. sapiens vs H. erectus                          | -3.11| 0.005570|**  |
|mnau_foot                           |H. neanderthalensis vs Middle Pleistocene hominin |  0.26| 0.795000|ns  |
|mnau_foot                           |H. neanderthalensis vs H. erectus                 | -1.53| 0.153000|ns  |
|mnau_foot                           |Middle Pleistocene hominin vs H. erectus          | -1.52| 0.153000|ns  |
|mnau_gini                           |H. sapiens vs H. neanderthalensis                 |  3.63| 0.000844|*** |
|mnau_gini                           |H. sapiens vs Middle Pleistocene hominin          |  3.21| 0.002610|**  |
|mnau_gini                           |H. sapiens vs H. erectus                          |  3.68| 0.000844|*** |
|mnau_gini                           |H. neanderthalensis vs Middle Pleistocene hominin |  0.88| 0.379000|ns  |
|mnau_gini                           |H. neanderthalensis vs H. erectus                 |  2.20| 0.041900|*   |
|mnau_gini                           |Middle Pleistocene hominin vs H. erectus          |  1.47| 0.170000|ns  |
|mnau_girdle_mean                    |H. sapiens vs H. neanderthalensis                 | -3.69| 0.001350|**  |
|mnau_girdle_mean                    |H. sapiens vs Middle Pleistocene hominin          | -2.41| 0.031500|*   |
|mnau_girdle_mean                    |H. sapiens vs H. erectus                          | -3.29| 0.002960|**  |
|mnau_girdle_mean                    |H. neanderthalensis vs Middle Pleistocene hominin | -0.11| 0.912000|ns  |
|mnau_girdle_mean                    |H. neanderthalensis vs H. erectus                 | -1.82| 0.104000|ns  |
|mnau_girdle_mean                    |Middle Pleistocene hominin vs H. erectus          | -1.57| 0.139000|ns  |
|mnau_hands                          |H. sapiens vs H. neanderthalensis                 | -2.90| 0.011300|*   |
|mnau_hands                          |H. sapiens vs Middle Pleistocene hominin          | -2.21| 0.054800|ns  |
|mnau_hands                          |H. sapiens vs H. erectus                          | -3.01| 0.011300|*   |
|mnau_hands                          |H. neanderthalensis vs Middle Pleistocene hominin | -0.38| 0.700000|ns  |
|mnau_hands                          |H. neanderthalensis vs H. erectus                 | -1.84| 0.098100|ns  |
|mnau_hands                          |Middle Pleistocene hominin vs H. erectus          | -1.44| 0.181000|ns  |
|mnau_heip_evenness                  |H. sapiens vs H. neanderthalensis                 | -3.63| 0.001130|**  |
|mnau_heip_evenness                  |H. sapiens vs Middle Pleistocene hominin          | -3.23| 0.002480|**  |
|mnau_heip_evenness                  |H. sapiens vs H. erectus                          | -3.56| 0.001130|**  |
|mnau_heip_evenness                  |H. neanderthalensis vs Middle Pleistocene hominin | -0.90| 0.369000|ns  |
|mnau_heip_evenness                  |H. neanderthalensis vs H. erectus                 | -2.08| 0.056600|ns  |
|mnau_heip_evenness                  |Middle Pleistocene hominin vs H. erectus          | -1.35| 0.212000|ns  |
|mnau_inverse_simpson                |H. sapiens vs H. neanderthalensis                 | -3.67| 0.001090|**  |
|mnau_inverse_simpson                |H. sapiens vs Middle Pleistocene hominin          | -3.28| 0.002080|**  |
|mnau_inverse_simpson                |H. sapiens vs H. erectus                          | -3.57| 0.001090|**  |
|mnau_inverse_simpson                |H. neanderthalensis vs Middle Pleistocene hominin | -0.92| 0.358000|ns  |
|mnau_inverse_simpson                |H. neanderthalensis vs H. erectus                 | -2.07| 0.057800|ns  |
|mnau_inverse_simpson                |Middle Pleistocene hominin vs H. erectus          | -1.33| 0.220000|ns  |
|mnau_legs                           |H. sapiens vs H. neanderthalensis                 | -3.66| 0.001520|**  |
|mnau_legs                           |H. sapiens vs Middle Pleistocene hominin          | -2.91| 0.007290|**  |
|mnau_legs                           |H. sapiens vs H. erectus                          | -3.15| 0.004930|**  |
|mnau_legs                           |H. neanderthalensis vs Middle Pleistocene hominin | -0.60| 0.547000|ns  |
|mnau_legs                           |H. neanderthalensis vs H. erectus                 | -1.69| 0.138000|ns  |
|mnau_legs                           |Middle Pleistocene hominin vs H. erectus          | -1.17| 0.291000|ns  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs H. neanderthalensis                 | -3.49| 0.002090|**  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs Middle Pleistocene hominin          | -3.15| 0.003290|**  |
|mnau_limb_shaft_proxy_mean          |H. sapiens vs H. erectus                          | -3.39| 0.002090|**  |
|mnau_limb_shaft_proxy_mean          |H. neanderthalensis vs Middle Pleistocene hominin | -0.93| 0.351000|ns  |
|mnau_limb_shaft_proxy_mean          |H. neanderthalensis vs H. erectus                 | -1.99| 0.070200|ns  |
|mnau_limb_shaft_proxy_mean          |Middle Pleistocene hominin vs H. erectus          | -1.25| 0.254000|ns  |
|mnau_lower_appendicular_mean        |H. sapiens vs H. neanderthalensis                 | -3.90| 0.000586|*** |
|mnau_lower_appendicular_mean        |H. sapiens vs Middle Pleistocene hominin          | -3.13| 0.003460|**  |
|mnau_lower_appendicular_mean        |H. sapiens vs H. erectus                          | -3.47| 0.001540|**  |
|mnau_lower_appendicular_mean        |H. neanderthalensis vs Middle Pleistocene hominin | -0.68| 0.499000|ns  |
|mnau_lower_appendicular_mean        |H. neanderthalensis vs H. erectus                 | -1.91| 0.083500|ns  |
|mnau_lower_appendicular_mean        |Middle Pleistocene hominin vs H. erectus          | -1.33| 0.220000|ns  |
|mnau_pelvic                         |H. sapiens vs H. neanderthalensis                 | -2.87| 0.020100|*   |
|mnau_pelvic                         |H. sapiens vs Middle Pleistocene hominin          | -2.19| 0.056300|ns  |
|mnau_pelvic                         |H. sapiens vs H. erectus                          | -2.71| 0.020100|*   |
|mnau_pelvic                         |H. neanderthalensis vs Middle Pleistocene hominin | -0.39| 0.696000|ns  |
|mnau_pelvic                         |H. neanderthalensis vs H. erectus                 | -1.56| 0.178000|ns  |
|mnau_pelvic                         |Middle Pleistocene hominin vs H. erectus          | -1.18| 0.286000|ns  |
|mnau_postcranial_total_mean         |H. sapiens vs H. neanderthalensis                 | -3.84| 0.000642|*** |
|mnau_postcranial_total_mean         |H. sapiens vs Middle Pleistocene hominin          | -3.20| 0.002770|**  |
|mnau_postcranial_total_mean         |H. sapiens vs H. erectus                          | -3.70| 0.000642|*** |
|mnau_postcranial_total_mean         |H. neanderthalensis vs Middle Pleistocene hominin | -0.77| 0.441000|ns  |
|mnau_postcranial_total_mean         |H. neanderthalensis vs H. erectus                 | -2.16| 0.046200|*   |
|mnau_postcranial_total_mean         |Middle Pleistocene hominin vs H. erectus          | -1.50| 0.161000|ns  |
|mnau_proximal_appendicular_mean     |H. sapiens vs H. neanderthalensis                 | -3.71| 0.001250|**  |
|mnau_proximal_appendicular_mean     |H. sapiens vs Middle Pleistocene hominin          | -2.93| 0.006740|**  |
|mnau_proximal_appendicular_mean     |H. sapiens vs H. erectus                          | -3.48| 0.001480|**  |
|mnau_proximal_appendicular_mean     |H. neanderthalensis vs Middle Pleistocene hominin | -0.59| 0.552000|ns  |
|mnau_proximal_appendicular_mean     |H. neanderthalensis vs H. erectus                 | -2.00| 0.069000|ns  |
|mnau_proximal_appendicular_mean     |Middle Pleistocene hominin vs H. erectus          | -1.45| 0.176000|ns  |
|mnau_region_mean_evenness           |H. sapiens vs H. neanderthalensis                 | -3.48| 0.001490|**  |
|mnau_region_mean_evenness           |H. sapiens vs Middle Pleistocene hominin          | -3.04| 0.004780|**  |
|mnau_region_mean_evenness           |H. sapiens vs H. erectus                          | -3.74| 0.001090|**  |
|mnau_region_mean_evenness           |H. neanderthalensis vs Middle Pleistocene hominin | -0.80| 0.423000|ns  |
|mnau_region_mean_evenness           |H. neanderthalensis vs H. erectus                 | -2.32| 0.030700|*   |
|mnau_region_mean_evenness           |Middle Pleistocene hominin vs H. erectus          | -1.62| 0.125000|ns  |
|mnau_shoulder                       |H. sapiens vs H. neanderthalensis                 | -3.26| 0.006790|**  |
|mnau_shoulder                       |H. sapiens vs Middle Pleistocene hominin          | -1.99| 0.094000|ns  |
|mnau_shoulder                       |H. sapiens vs H. erectus                          | -3.02| 0.007500|**  |
|mnau_shoulder                       |H. neanderthalensis vs Middle Pleistocene hominin |  0.04| 0.967000|ns  |
|mnau_shoulder                       |H. neanderthalensis vs H. erectus                 | -1.72| 0.129000|ns  |
|mnau_shoulder                       |Middle Pleistocene hominin vs H. erectus          | -1.57| 0.140000|ns  |
|mnau_simpson_dominance              |H. sapiens vs H. neanderthalensis                 |  3.67| 0.001090|**  |
|mnau_simpson_dominance              |H. sapiens vs Middle Pleistocene hominin          |  3.28| 0.002080|**  |
|mnau_simpson_dominance              |H. sapiens vs H. erectus                          |  3.57| 0.001090|**  |
|mnau_simpson_dominance              |H. neanderthalensis vs Middle Pleistocene hominin |  0.92| 0.358000|ns  |
|mnau_simpson_dominance              |H. neanderthalensis vs H. erectus                 |  2.07| 0.057800|ns  |
|mnau_simpson_dominance              |Middle Pleistocene hominin vs H. erectus          |  1.33| 0.220000|ns  |
|mnau_simpson_evenness               |H. sapiens vs H. neanderthalensis                 | -3.67| 0.001090|**  |
|mnau_simpson_evenness               |H. sapiens vs Middle Pleistocene hominin          | -3.28| 0.002080|**  |
|mnau_simpson_evenness               |H. sapiens vs H. erectus                          | -3.57| 0.001090|**  |
|mnau_simpson_evenness               |H. neanderthalensis vs Middle Pleistocene hominin | -0.92| 0.358000|ns  |
|mnau_simpson_evenness               |H. neanderthalensis vs H. erectus                 | -2.07| 0.057800|ns  |
|mnau_simpson_evenness               |Middle Pleistocene hominin vs H. erectus          | -1.33| 0.220000|ns  |
|mnau_top2_share_mcnaughton          |H. sapiens vs H. neanderthalensis                 |  3.88| 0.000560|*** |
|mnau_top2_share_mcnaughton          |H. sapiens vs Middle Pleistocene hominin          |  3.52| 0.000851|*** |
|mnau_top2_share_mcnaughton          |H. sapiens vs H. erectus                          |  3.74| 0.000560|*** |
|mnau_top2_share_mcnaughton          |H. neanderthalensis vs Middle Pleistocene hominin |  1.03| 0.304000|ns  |
|mnau_top2_share_mcnaughton          |H. neanderthalensis vs H. erectus                 |  2.16| 0.046600|*   |
|mnau_top2_share_mcnaughton          |Middle Pleistocene hominin vs H. erectus          |  1.35| 0.214000|ns  |
|mnau_upper_appendicular_mean        |H. sapiens vs H. neanderthalensis                 | -3.59| 0.001010|**  |
|mnau_upper_appendicular_mean        |H. sapiens vs Middle Pleistocene hominin          | -2.62| 0.017400|*   |
|mnau_upper_appendicular_mean        |H. sapiens vs H. erectus                          | -3.63| 0.001010|**  |
|mnau_upper_appendicular_mean        |H. neanderthalensis vs Middle Pleistocene hominin | -0.37| 0.709000|ns  |
|mnau_upper_appendicular_mean        |H. neanderthalensis vs H. erectus                 | -2.19| 0.043000|*   |
|mnau_upper_appendicular_mean        |Middle Pleistocene hominin vs H. erectus          | -1.75| 0.095500|ns  |
|mne_arms                            |H. sapiens vs H. neanderthalensis                 | -4.12| 0.000228|*** |
|mne_arms                            |H. sapiens vs Middle Pleistocene hominin          | -1.67| 0.114000|ns  |
|mne_arms                            |H. sapiens vs H. erectus                          | -3.43| 0.001810|**  |
|mne_arms                            |H. neanderthalensis vs Middle Pleistocene hominin |  0.86| 0.390000|ns  |
|mne_arms                            |H. neanderthalensis vs H. erectus                 | -1.78| 0.111000|ns  |
|mne_arms                            |Middle Pleistocene hominin vs H. erectus          | -2.11| 0.070400|ns  |
|mne_cranial_share                   |H. sapiens vs H. neanderthalensis                 |  2.24| 0.037300|*   |
|mne_cranial_share                   |H. sapiens vs Middle Pleistocene hominin          |  3.07| 0.006340|**  |
|mne_cranial_share                   |H. sapiens vs H. erectus                          |  3.53| 0.002510|**  |
|mne_cranial_share                   |H. neanderthalensis vs Middle Pleistocene hominin |  1.61| 0.130000|ns  |
|mne_cranial_share                   |H. neanderthalensis vs H. erectus                 |  2.60| 0.018400|*   |
|mne_cranial_share                   |Middle Pleistocene hominin vs H. erectus          |  1.41| 0.158000|ns  |
|postcranial_dominance_refined       |H. sapiens vs H. neanderthalensis                 |  2.36| 0.055400|ns  |
|postcranial_dominance_refined       |H. sapiens vs Middle Pleistocene hominin          |  0.49| 0.623000|ns  |
|postcranial_dominance_refined       |H. sapiens vs H. erectus                          |  2.45| 0.055400|ns  |
|postcranial_dominance_refined       |H. neanderthalensis vs Middle Pleistocene hominin | -0.72| 0.564000|ns  |
|postcranial_dominance_refined       |H. neanderthalensis vs H. erectus                 |  1.79| 0.111000|ns  |
|postcranial_dominance_refined       |Middle Pleistocene hominin vs H. erectus          |  1.99| 0.092700|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.54, R² = 0.061, p = 0.0097.
PCA variance explained: PC1 56.6%, PC2 8.8%, PC3 6.3% (cumulative 71.8%).
Dispersion caveat (PERMDISP): p = 0.002 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.160| -0.138|  0.023|
|mnau_appendicular_mean      | -0.160| -0.136| -0.027|
|mnau_gini                   |  0.159| -0.116|  0.012|
|mnau_top2_share_mcnaughton  |  0.158| -0.139|  0.003|
|effective_sections_hill1    | -0.158|  0.131| -0.007|
|mnau_heip_evenness          | -0.158|  0.131| -0.007|
|mnau_simpson_evenness       | -0.158|  0.107| -0.010|
|mnau_inverse_simpson        | -0.158|  0.107| -0.010|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
