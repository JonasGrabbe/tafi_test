# Research-history / sampling bias
*Automated region × skeletal-part representation*

- **Grouping column:** `region` (mode = alternative)
- **Groups (n):** West Europe = 107; Central Europe = 12; Europe = 7; West Asia = 7; Southeast Asia = 5
- **Sites analysed:** 138  |  **features screened:** 63

## Hypothesis

**H:** Regional research history, geology, climate and excavation tradition affect recovery.

**Expected pattern:** Some regions more complete (cave preservation/modern excavation); others biased to diagnostic cranial/dental material.

**Why it matters:** Detects sampling and research-history bias; weaker as a behavioural hypothesis.


## Summary

40 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_distal_appendicular_mean** (ε² = 0.164, FDR p = 0.001586). PERMANOVA pseudo-F = 2.13, p = 0.0205; PC1–PC3 explain 71.8% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 191 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 13 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mnau_distal_appendicular_mean                |  0.164| 0.00159|large      |significant |
|mne_arms                                     |  0.158| 0.00159|large      |significant |
|distal_appendicular_continuity_hm            |  0.151| 0.00159|large      |significant |
|mnau_foot                                    |  0.136| 0.00309|moderate   |significant |
|appendicular_dominance                       |  0.134| 0.00583|moderate   |significant |
|appendicular_dominance_refined               |  0.134| 0.00583|moderate   |significant |
|ProportionalRep_MNIbased_carpal              |  0.128| 0.00394|moderate   |significant |
|lower_appendicular_evenness                  |  0.118| 0.00841|moderate   |significant |
|lower_appendicular_evenness_refined          |  0.118| 0.00841|moderate   |significant |
|mnau_region_mean_evenness                    |  0.116| 0.00583|moderate   |significant |
|postcranial_dominance_refined                |  0.114| 0.00841|moderate   |significant |
|mnau_hands                                   |  0.112| 0.00583|moderate   |significant |
|effective_sections_hill1                     |  0.103| 0.00775|moderate   |significant |
|mnau_heip_evenness                           |  0.103| 0.00775|moderate   |significant |
|mnau_gini                                    |  0.103| 0.00775|moderate   |significant |
|lower_appendicular_continuity_hm             |  0.101| 0.00775|moderate   |significant |
|mnau_top2_share_mcnaughton                   |  0.096| 0.00841|moderate   |significant |
|mnau_axial_main_mean                         |  0.090| 0.01040|moderate   |significant |
|low_density_survival_index                   |  0.090| 0.01040|moderate   |significant |
|low_density_axial_survival                   |  0.087| 0.01140|moderate   |significant |
|mnau_column_trunk_mean                       |  0.084| 0.01300|moderate   |significant |
|mnau_shoulder                                |  0.083| 0.01310|moderate   |significant |
|mnau_upper_appendicular_mean                 |  0.078| 0.01740|moderate   |significant |
|mnau_postcranial_total_mean                  |  0.076| 0.01740|moderate   |significant |
|mnau_inverse_simpson                         |  0.075| 0.01740|moderate   |significant |
|mnau_simpson_dominance                       |  0.075| 0.01740|moderate   |significant |
|mnau_simpson_evenness                        |  0.075| 0.01740|moderate   |significant |
|mnau_girdle_mean                             |  0.074| 0.01740|moderate   |significant |
|mnau_appendicular_mean                       |  0.073| 0.01750|moderate   |significant |
|mnau_dominance_of_region_means               |  0.073| 0.01820|moderate   |significant |
|mnau_evenness_minus_dominance                |  0.073| 0.01820|moderate   |significant |
|mnau_cv                                      |  0.071| 0.01930|moderate   |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.070| 0.01930|moderate   |significant |
|mnau_lower_appendicular_mean                 |  0.068| 0.02060|moderate   |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.066| 0.02270|moderate   |significant |
|ProportionalRep_MNIbased_clavicle            |  0.063| 0.02520|moderate   |significant |
|ProportionalRep_MNIbased_radius              |  0.060| 0.02910|moderate   |significant |
|low_density_share                            |  0.057| 0.03640|small      |significant |
|ProportionalRep_MNIbased_cervical            |  0.055| 0.03640|small      |significant |
|mnau_pelvic                                  |  0.055| 0.03640|small      |significant |
|all_sections_dominance                       |  0.049| 0.05140|small      |n.s.        |
|mnau_proximal_appendicular_mean              |  0.048| 0.05140|small      |n.s.        |
|mnau_arms                                    |  0.048| 0.05160|small      |n.s.        |
|mne_cranial_share                            |  0.041| 0.07160|small      |n.s.        |
|density_evenness                             |  0.041| 0.07530|small      |n.s.        |
|ReMNAU_ulna                                  |  0.038| 0.08120|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.037| 0.08590|small      |n.s.        |
|ProportionalRep_MNIbased_fibula              |  0.034| 0.09690|small      |n.s.        |
|ReMNAU_radius                                |  0.032| 0.10700|small      |n.s.        |
|ProportionalRep_MNIbased_humerus             |  0.027| 0.13400|small      |n.s.        |
|ReMNAU_cervical                              |  0.026| 0.14300|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.023| 0.16200|small      |n.s.        |
|dominant_axial_share                         |  0.022| 0.16300|small      |n.s.        |
|mnau_arms_legs_diff                          |  0.021| 0.17400|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.020| 0.17400|small      |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.020| 0.17400|small      |n.s.        |
|mnau_legs                                    |  0.019| 0.17800|small      |n.s.        |
|dominance_gap_all                            |  0.016| 0.21100|small      |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.012| 0.24700|small      |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.011| 0.25500|small      |n.s.        |
|ProportionalRep_MNIbased_femur               |  0.006| 0.31500|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast |  0.003| 0.35700|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.004| 0.47700|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                         |     Z|  p (adj)|Sig |
|:-----------------------------------|:--------------------------------|-----:|--------:|:---|
|ProportionalRep_MNIbased_carpal     |West Europe vs Central Europe    |  0.22| 0.825000|ns  |
|ProportionalRep_MNIbased_carpal     |West Europe vs Europe            |  2.90| 0.009310|**  |
|ProportionalRep_MNIbased_carpal     |West Europe vs West Asia         |  3.31| 0.005540|**  |
|ProportionalRep_MNIbased_carpal     |West Europe vs Southeast Asia    | -1.36| 0.245000|ns  |
|ProportionalRep_MNIbased_carpal     |Central Europe vs Europe         |  2.24| 0.042100|*   |
|ProportionalRep_MNIbased_carpal     |Central Europe vs West Asia      |  2.57| 0.020400|*   |
|ProportionalRep_MNIbased_carpal     |Central Europe vs Southeast Asia | -1.29| 0.245000|ns  |
|ProportionalRep_MNIbased_carpal     |Europe vs West Asia              |  0.30| 0.825000|ns  |
|ProportionalRep_MNIbased_carpal     |Europe vs Southeast Asia         | -2.99| 0.009230|**  |
|ProportionalRep_MNIbased_carpal     |West Asia vs Southeast Asia      | -3.26| 0.005540|**  |
|ProportionalRep_MNIbased_cervical   |West Europe vs Central Europe    |  0.47| 0.637000|ns  |
|ProportionalRep_MNIbased_cervical   |West Europe vs Europe            |  0.95| 0.429000|ns  |
|ProportionalRep_MNIbased_cervical   |West Europe vs West Asia         |  2.63| 0.042200|*   |
|ProportionalRep_MNIbased_cervical   |West Europe vs Southeast Asia    | -1.74| 0.137000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs Europe         |  0.48| 0.637000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs West Asia      |  1.86| 0.137000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs Southeast Asia | -1.76| 0.137000|ns  |
|ProportionalRep_MNIbased_cervical   |Europe vs West Asia              |  1.23| 0.312000|ns  |
|ProportionalRep_MNIbased_cervical   |Europe vs Southeast Asia         | -1.99| 0.137000|ns  |
|ProportionalRep_MNIbased_cervical   |West Asia vs Southeast Asia      | -3.11| 0.018500|*   |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Central Europe    |  0.86| 0.434000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Europe            |  1.81| 0.116000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs West Asia         |  2.08| 0.093500|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Southeast Asia    | -1.99| 0.093500|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs Europe         |  0.94| 0.434000|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs West Asia      |  1.15| 0.356000|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs Southeast Asia | -2.20| 0.092600|ns  |
|ProportionalRep_MNIbased_clavicle   |Europe vs West Asia              |  0.19| 0.849000|ns  |
|ProportionalRep_MNIbased_clavicle   |Europe vs Southeast Asia         | -2.76| 0.028700|*   |
|ProportionalRep_MNIbased_clavicle   |West Asia vs Southeast Asia      | -2.94| 0.028700|*   |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Central Europe    | -0.34| 0.737000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Europe            |  1.56| 0.179000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Europe vs West Asia         |  2.55| 0.036500|*   |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Southeast Asia    | -1.93| 0.108000|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs Europe         |  1.49| 0.179000|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs West Asia      |  2.30| 0.053100|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs Southeast Asia | -1.47| 0.179000|ns  |
|ProportionalRep_MNIbased_metacarpal |Europe vs West Asia              |  0.72| 0.523000|ns  |
|ProportionalRep_MNIbased_metacarpal |Europe vs Southeast Asia         | -2.54| 0.036500|*   |
|ProportionalRep_MNIbased_metacarpal |West Asia vs Southeast Asia      | -3.20| 0.013600|*   |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Central Europe    | -0.38| 0.785000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Europe            |  2.02| 0.082600|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs West Asia         |  2.06| 0.082600|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Southeast Asia    | -1.94| 0.082600|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs Europe         |  1.90| 0.082600|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs West Asia      |  1.93| 0.082600|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs Southeast Asia | -1.45| 0.184000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Europe vs West Asia              |  0.03| 0.977000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Europe vs Southeast Asia         | -2.86| 0.021200|*   |
|ProportionalRep_MNIbased_os_coxae   |West Asia vs Southeast Asia      | -2.89| 0.021200|*   |
|ProportionalRep_MNIbased_radius     |West Europe vs Central Europe    |  0.18| 0.860000|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs Europe            |  1.51| 0.188000|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs West Asia         |  2.26| 0.080400|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs Southeast Asia    | -2.06| 0.098700|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs Europe         |  1.12| 0.326000|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs West Asia      |  1.74| 0.137000|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs Southeast Asia | -1.87| 0.123000|ns  |
|ProportionalRep_MNIbased_radius     |Europe vs West Asia              |  0.55| 0.651000|ns  |
|ProportionalRep_MNIbased_radius     |Europe vs Southeast Asia         | -2.61| 0.044700|*   |
|ProportionalRep_MNIbased_radius     |West Asia vs Southeast Asia      | -3.11| 0.018600|*   |
|appendicular_dominance              |West Europe vs Central Europe    | -1.05| 0.326000|ns  |
|appendicular_dominance              |West Europe vs Europe            | -2.86| 0.014200|*   |
|appendicular_dominance              |West Europe vs West Asia         | -2.34| 0.038300|*   |
|appendicular_dominance              |West Europe vs Southeast Asia    |  2.13| 0.055700|ns  |
|appendicular_dominance              |Central Europe vs Europe         | -1.50| 0.192000|ns  |
|appendicular_dominance              |Central Europe vs West Asia      | -1.09| 0.326000|ns  |
|appendicular_dominance              |Central Europe vs Southeast Asia |  2.42| 0.038300|*   |
|appendicular_dominance              |Europe vs West Asia              |  0.38| 0.705000|ns  |
|appendicular_dominance              |Europe vs Southeast Asia         |  3.43| 0.005960|**  |
|appendicular_dominance              |West Asia vs Southeast Asia      |  3.14| 0.008430|**  |
|appendicular_dominance_refined      |West Europe vs Central Europe    | -1.05| 0.326000|ns  |
|appendicular_dominance_refined      |West Europe vs Europe            | -2.86| 0.014200|*   |
|appendicular_dominance_refined      |West Europe vs West Asia         | -2.34| 0.038300|*   |
|appendicular_dominance_refined      |West Europe vs Southeast Asia    |  2.13| 0.055700|ns  |
|appendicular_dominance_refined      |Central Europe vs Europe         | -1.50| 0.192000|ns  |
|appendicular_dominance_refined      |Central Europe vs West Asia      | -1.09| 0.326000|ns  |
|appendicular_dominance_refined      |Central Europe vs Southeast Asia |  2.42| 0.038300|*   |
|appendicular_dominance_refined      |Europe vs West Asia              |  0.38| 0.705000|ns  |
|appendicular_dominance_refined      |Europe vs Southeast Asia         |  3.43| 0.005960|**  |
|appendicular_dominance_refined      |West Asia vs Southeast Asia      |  3.14| 0.008430|**  |
|distal_appendicular_continuity_hm   |West Europe vs Central Europe    | -0.55| 0.632000|ns  |
|distal_appendicular_continuity_hm   |West Europe vs Europe            |  3.10| 0.006370|**  |
|distal_appendicular_continuity_hm   |West Europe vs West Asia         |  2.45| 0.024000|*   |
|distal_appendicular_continuity_hm   |West Europe vs Southeast Asia    | -2.68| 0.014900|*   |
|distal_appendicular_continuity_hm   |Central Europe vs Europe         |  2.90| 0.009350|**  |
|distal_appendicular_continuity_hm   |Central Europe vs West Asia      |  2.36| 0.026100|*   |
|distal_appendicular_continuity_hm   |Central Europe vs Southeast Asia | -1.98| 0.058900|ns  |
|distal_appendicular_continuity_hm   |Europe vs West Asia              | -0.48| 0.632000|ns  |
|distal_appendicular_continuity_hm   |Europe vs Southeast Asia         | -4.16| 0.000319|*** |
|distal_appendicular_continuity_hm   |West Asia vs Southeast Asia      | -3.72| 0.000989|*** |
|effective_sections_hill1            |West Europe vs Central Europe    | -0.24| 0.899000|ns  |
|effective_sections_hill1            |West Europe vs Europe            |  2.30| 0.042600|*   |
|effective_sections_hill1            |West Europe vs West Asia         |  2.45| 0.042600|*   |
|effective_sections_hill1            |West Europe vs Southeast Asia    | -2.34| 0.042600|*   |
|effective_sections_hill1            |Central Europe vs Europe         |  2.04| 0.058500|ns  |
|effective_sections_hill1            |Central Europe vs West Asia      |  2.17| 0.050400|ns  |
|effective_sections_hill1            |Central Europe vs Southeast Asia | -1.88| 0.075500|ns  |
|effective_sections_hill1            |Europe vs West Asia              |  0.11| 0.913000|ns  |
|effective_sections_hill1            |Europe vs Southeast Asia         | -3.37| 0.003790|**  |
|effective_sections_hill1            |West Asia vs Southeast Asia      | -3.47| 0.003790|**  |
|low_density_axial_survival          |West Europe vs Central Europe    | -0.37| 0.708000|ns  |
|low_density_axial_survival          |West Europe vs Europe            |  1.43| 0.196000|ns  |
|low_density_axial_survival          |West Europe vs West Asia         |  2.47| 0.034200|*   |
|low_density_axial_survival          |West Europe vs Southeast Asia    | -2.56| 0.034200|*   |
|low_density_axial_survival          |Central Europe vs Europe         |  1.41| 0.196000|ns  |
|low_density_axial_survival          |Central Europe vs West Asia      |  2.26| 0.047400|*   |
|low_density_axial_survival          |Central Europe vs Southeast Asia | -1.98| 0.078700|ns  |
|low_density_axial_survival          |Europe vs West Asia              |  0.75| 0.501000|ns  |
|low_density_axial_survival          |Europe vs Southeast Asia         | -2.95| 0.015700|*   |
|low_density_axial_survival          |West Asia vs Southeast Asia      | -3.64| 0.002710|**  |
|low_density_share                   |West Europe vs Central Europe    |  0.20| 0.840000|ns  |
|low_density_share                   |West Europe vs Europe            |  0.86| 0.556000|ns  |
|low_density_share                   |West Europe vs West Asia         |  1.58| 0.227000|ns  |
|low_density_share                   |West Europe vs Southeast Asia    | -2.75| 0.021300|*   |
|low_density_share                   |Central Europe vs Europe         |  0.58| 0.664000|ns  |
|low_density_share                   |Central Europe vs West Asia      |  1.17| 0.403000|ns  |
|low_density_share                   |Central Europe vs Southeast Asia | -2.48| 0.032400|*   |
|low_density_share                   |Europe vs West Asia              |  0.53| 0.664000|ns  |
|low_density_share                   |Europe vs Southeast Asia         | -2.73| 0.021300|*   |
|low_density_share                   |West Asia vs Southeast Asia      | -3.21| 0.013300|*   |
|low_density_survival_index          |West Europe vs Central Europe    |  0.17| 0.863000|ns  |
|low_density_survival_index          |West Europe vs Europe            |  1.56| 0.170000|ns  |
|low_density_survival_index          |West Europe vs West Asia         |  2.40| 0.034800|*   |
|low_density_survival_index          |West Europe vs Southeast Asia    | -2.65| 0.026700|*   |
|low_density_survival_index          |Central Europe vs Europe         |  1.17| 0.303000|ns  |
|low_density_survival_index          |Central Europe vs West Asia      |  1.86| 0.105000|ns  |
|low_density_survival_index          |Central Europe vs Southeast Asia | -2.38| 0.034800|*   |
|low_density_survival_index          |Europe vs West Asia              |  0.62| 0.598000|ns  |
|low_density_survival_index          |Europe vs Southeast Asia         | -3.11| 0.009330|**  |
|low_density_survival_index          |West Asia vs Southeast Asia      | -3.67| 0.002400|**  |
|lower_appendicular_continuity_hm    |West Europe vs Central Europe    |  0.01| 0.994000|ns  |
|lower_appendicular_continuity_hm    |West Europe vs Europe            |  2.65| 0.026600|*   |
|lower_appendicular_continuity_hm    |West Europe vs West Asia         |  2.19| 0.049700|*   |
|lower_appendicular_continuity_hm    |West Europe vs Southeast Asia    | -2.25| 0.049700|*   |
|lower_appendicular_continuity_hm    |Central Europe vs Europe         |  2.17| 0.049700|*   |
|lower_appendicular_continuity_hm    |Central Europe vs West Asia      |  1.79| 0.092300|ns  |
|lower_appendicular_continuity_hm    |Central Europe vs Southeast Asia | -1.94| 0.074900|ns  |
|lower_appendicular_continuity_hm    |Europe vs West Asia              | -0.34| 0.814000|ns  |
|lower_appendicular_continuity_hm    |Europe vs Southeast Asia         | -3.53| 0.004200|**  |
|lower_appendicular_continuity_hm    |West Asia vs Southeast Asia      | -3.22| 0.006520|**  |
|lower_appendicular_evenness         |West Europe vs Central Europe    |  0.34| 0.731000|ns  |
|lower_appendicular_evenness         |West Europe vs Europe            |  2.73| 0.021200|*   |
|lower_appendicular_evenness         |West Europe vs West Asia         |  2.04| 0.069200|ns  |
|lower_appendicular_evenness         |West Europe vs Southeast Asia    | -2.19| 0.069200|ns  |
|lower_appendicular_evenness         |Central Europe vs Europe         |  1.89| 0.084200|ns  |
|lower_appendicular_evenness         |Central Europe vs West Asia      |  1.35| 0.221000|ns  |
|lower_appendicular_evenness         |Central Europe vs Southeast Asia | -2.11| 0.069200|ns  |
|lower_appendicular_evenness         |Europe vs West Asia              | -0.51| 0.679000|ns  |
|lower_appendicular_evenness         |Europe vs Southeast Asia         | -3.42| 0.006260|**  |
|lower_appendicular_evenness         |West Asia vs Southeast Asia      | -3.03| 0.012400|*   |
|lower_appendicular_evenness_refined |West Europe vs Central Europe    |  0.34| 0.731000|ns  |
|lower_appendicular_evenness_refined |West Europe vs Europe            |  2.73| 0.021200|*   |
|lower_appendicular_evenness_refined |West Europe vs West Asia         |  2.04| 0.069200|ns  |
|lower_appendicular_evenness_refined |West Europe vs Southeast Asia    | -2.19| 0.069200|ns  |
|lower_appendicular_evenness_refined |Central Europe vs Europe         |  1.89| 0.084200|ns  |
|lower_appendicular_evenness_refined |Central Europe vs West Asia      |  1.35| 0.221000|ns  |
|lower_appendicular_evenness_refined |Central Europe vs Southeast Asia | -2.11| 0.069200|ns  |
|lower_appendicular_evenness_refined |Europe vs West Asia              | -0.51| 0.679000|ns  |
|lower_appendicular_evenness_refined |Europe vs Southeast Asia         | -3.42| 0.006260|**  |
|lower_appendicular_evenness_refined |West Asia vs Southeast Asia      | -3.03| 0.012400|*   |
|mnau_appendicular_mean              |West Europe vs Central Europe    | -0.33| 0.741000|ns  |
|mnau_appendicular_mean              |West Europe vs Europe            |  1.69| 0.129000|ns  |
|mnau_appendicular_mean              |West Europe vs West Asia         |  2.16| 0.076800|ns  |
|mnau_appendicular_mean              |West Europe vs Southeast Asia    | -2.34| 0.064000|ns  |
|mnau_appendicular_mean              |Central Europe vs Europe         |  1.60| 0.137000|ns  |
|mnau_appendicular_mean              |Central Europe vs West Asia      |  1.98| 0.094400|ns  |
|mnau_appendicular_mean              |Central Europe vs Southeast Asia | -1.82| 0.114000|ns  |
|mnau_appendicular_mean              |Europe vs West Asia              |  0.34| 0.741000|ns  |
|mnau_appendicular_mean              |Europe vs Southeast Asia         | -2.96| 0.015500|*   |
|mnau_appendicular_mean              |West Asia vs Southeast Asia      | -3.27| 0.010800|*   |
|mnau_axial_main_mean                |West Europe vs Central Europe    | -0.31| 0.758000|ns  |
|mnau_axial_main_mean                |West Europe vs Europe            |  1.48| 0.198000|ns  |
|mnau_axial_main_mean                |West Europe vs West Asia         |  2.54| 0.027500|*   |
|mnau_axial_main_mean                |West Europe vs Southeast Asia    | -2.55| 0.027500|*   |
|mnau_axial_main_mean                |Central Europe vs Europe         |  1.41| 0.198000|ns  |
|mnau_axial_main_mean                |Central Europe vs West Asia      |  2.28| 0.044900|*   |
|mnau_axial_main_mean                |Central Europe vs Southeast Asia | -2.01| 0.073300|ns  |
|mnau_axial_main_mean                |Europe vs West Asia              |  0.77| 0.487000|ns  |
|mnau_axial_main_mean                |Europe vs Southeast Asia         | -2.98| 0.014500|*   |
|mnau_axial_main_mean                |West Asia vs Southeast Asia      | -3.68| 0.002290|**  |
|mnau_column_trunk_mean              |West Europe vs Central Europe    | -0.44| 0.659000|ns  |
|mnau_column_trunk_mean              |West Europe vs Europe            |  1.46| 0.180000|ns  |
|mnau_column_trunk_mean              |West Europe vs West Asia         |  2.25| 0.061100|ns  |
|mnau_column_trunk_mean              |West Europe vs Southeast Asia    | -2.65| 0.027000|*   |
|mnau_column_trunk_mean              |Central Europe vs Europe         |  1.48| 0.180000|ns  |
|mnau_column_trunk_mean              |Central Europe vs West Asia      |  2.13| 0.066700|ns  |
|mnau_column_trunk_mean              |Central Europe vs Southeast Asia | -2.02| 0.071700|ns  |
|mnau_column_trunk_mean              |Europe vs West Asia              |  0.58| 0.628000|ns  |
|mnau_column_trunk_mean              |Europe vs Southeast Asia         | -3.04| 0.011700|*   |
|mnau_column_trunk_mean              |West Asia vs Southeast Asia      | -3.57| 0.003600|**  |
|mnau_cv                             |West Europe vs Central Europe    |  0.22| 0.916000|ns  |
|mnau_cv                             |West Europe vs Europe            | -1.95| 0.102000|ns  |
|mnau_cv                             |West Europe vs West Asia         | -2.02| 0.102000|ns  |
|mnau_cv                             |West Europe vs Southeast Asia    |  2.17| 0.101000|ns  |
|mnau_cv                             |Central Europe vs Europe         | -1.74| 0.103000|ns  |
|mnau_cv                             |Central Europe vs West Asia      | -1.80| 0.103000|ns  |
|mnau_cv                             |Central Europe vs Southeast Asia |  1.74| 0.103000|ns  |
|mnau_cv                             |Europe vs West Asia              | -0.05| 0.959000|ns  |
|mnau_cv                             |Europe vs Southeast Asia         |  3.00| 0.013700|*   |
|mnau_cv                             |West Asia vs Southeast Asia      |  3.04| 0.013700|*   |
|mnau_distal_appendicular_mean       |West Europe vs Central Europe    | -0.88| 0.422000|ns  |
|mnau_distal_appendicular_mean       |West Europe vs Europe            |  2.76| 0.009650|**  |
|mnau_distal_appendicular_mean       |West Europe vs West Asia         |  3.01| 0.006550|**  |
|mnau_distal_appendicular_mean       |West Europe vs Southeast Asia    | -2.69| 0.010300|*   |
|mnau_distal_appendicular_mean       |Central Europe vs Europe         |  2.83| 0.009450|**  |
|mnau_distal_appendicular_mean       |Central Europe vs West Asia      |  3.03| 0.006550|**  |
|mnau_distal_appendicular_mean       |Central Europe vs Southeast Asia | -1.81| 0.088500|ns  |
|mnau_distal_appendicular_mean       |Europe vs West Asia              |  0.18| 0.855000|ns  |
|mnau_distal_appendicular_mean       |Europe vs Southeast Asia         | -3.94| 0.000412|*** |
|mnau_distal_appendicular_mean       |West Asia vs Southeast Asia      | -4.10| 0.000406|*** |
|mnau_dominance_of_region_means      |West Europe vs Central Europe    |  0.22| 0.824000|ns  |
|mnau_dominance_of_region_means      |West Europe vs Europe            | -1.60| 0.155000|ns  |
|mnau_dominance_of_region_means      |West Europe vs West Asia         | -2.04| 0.089500|ns  |
|mnau_dominance_of_region_means      |West Europe vs Southeast Asia    |  2.48| 0.043600|*   |
|mnau_dominance_of_region_means      |Central Europe vs Europe         | -1.46| 0.181000|ns  |
|mnau_dominance_of_region_means      |Central Europe vs West Asia      | -1.81| 0.116000|ns  |
|mnau_dominance_of_region_means      |Central Europe vs Southeast Asia |  2.01| 0.089500|ns  |
|mnau_dominance_of_region_means      |Europe vs West Asia              | -0.32| 0.824000|ns  |
|mnau_dominance_of_region_means      |Europe vs Southeast Asia         |  3.01| 0.013100|*   |
|mnau_dominance_of_region_means      |West Asia vs Southeast Asia      |  3.30| 0.009740|**  |
|mnau_evenness_minus_dominance       |West Europe vs Central Europe    | -0.18| 0.908000|ns  |
|mnau_evenness_minus_dominance       |West Europe vs Europe            |  1.91| 0.101000|ns  |
|mnau_evenness_minus_dominance       |West Europe vs West Asia         |  2.07| 0.097000|ns  |
|mnau_evenness_minus_dominance       |West Europe vs Southeast Asia    | -2.24| 0.084200|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs Europe         |  1.68| 0.116000|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs West Asia      |  1.81| 0.101000|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs Southeast Asia | -1.82| 0.101000|ns  |
|mnau_evenness_minus_dominance       |Europe vs West Asia              |  0.12| 0.908000|ns  |
|mnau_evenness_minus_dominance       |Europe vs Southeast Asia         | -3.02| 0.012600|*   |
|mnau_evenness_minus_dominance       |West Asia vs Southeast Asia      | -3.13| 0.012600|*   |
|mnau_foot                           |West Europe vs Central Europe    | -0.33| 0.744000|ns  |
|mnau_foot                           |West Europe vs Europe            |  3.12| 0.005950|**  |
|mnau_foot                           |West Europe vs West Asia         |  2.56| 0.020800|*   |
|mnau_foot                           |West Europe vs Southeast Asia    | -2.22| 0.037600|*   |
|mnau_foot                           |Central Europe vs Europe         |  2.77| 0.013900|*   |
|mnau_foot                           |Central Europe vs West Asia      |  2.31| 0.034700|*   |
|mnau_foot                           |Central Europe vs Southeast Asia | -1.72| 0.106000|ns  |
|mnau_foot                           |Europe vs West Asia              | -0.41| 0.744000|ns  |
|mnau_foot                           |Europe vs Southeast Asia         | -3.82| 0.001350|**  |
|mnau_foot                           |West Asia vs Southeast Asia      | -3.44| 0.002880|**  |
|mnau_gini                           |West Europe vs Central Europe    |  0.25| 0.849000|ns  |
|mnau_gini                           |West Europe vs Europe            | -2.26| 0.043200|*   |
|mnau_gini                           |West Europe vs West Asia         | -2.52| 0.039400|*   |
|mnau_gini                           |West Europe vs Southeast Asia    |  2.30| 0.043200|*   |
|mnau_gini                           |Central Europe vs Europe         | -2.01| 0.062900|ns  |
|mnau_gini                           |Central Europe vs West Asia      | -2.23| 0.043200|*   |
|mnau_gini                           |Central Europe vs Southeast Asia |  1.83| 0.084000|ns  |
|mnau_gini                           |Europe vs West Asia              | -0.19| 0.849000|ns  |
|mnau_gini                           |Europe vs Southeast Asia         |  3.30| 0.004840|**  |
|mnau_gini                           |West Asia vs Southeast Asia      |  3.47| 0.004840|**  |
|mnau_girdle_mean                    |West Europe vs Central Europe    |  0.33| 0.821000|ns  |
|mnau_girdle_mean                    |West Europe vs Europe            |  1.92| 0.096300|ns  |
|mnau_girdle_mean                    |West Europe vs West Asia         |  1.90| 0.096300|ns  |
|mnau_girdle_mean                    |West Europe vs Southeast Asia    | -2.44| 0.048700|*   |
|mnau_girdle_mean                    |Central Europe vs Europe         |  1.36| 0.224000|ns  |
|mnau_girdle_mean                    |Central Europe vs West Asia      |  1.34| 0.224000|ns  |
|mnau_girdle_mean                    |Central Europe vs Southeast Asia | -2.29| 0.055100|ns  |
|mnau_girdle_mean                    |Europe vs West Asia              | -0.02| 0.986000|ns  |
|mnau_girdle_mean                    |Europe vs Southeast Asia         | -3.19| 0.007550|**  |
|mnau_girdle_mean                    |West Asia vs Southeast Asia      | -3.17| 0.007550|**  |
|mnau_hands                          |West Europe vs Central Europe    | -0.77| 0.494000|ns  |
|mnau_hands                          |West Europe vs Europe            |  2.57| 0.025700|*   |
|mnau_hands                          |West Europe vs West Asia         |  2.28| 0.032000|*   |
|mnau_hands                          |West Europe vs Southeast Asia    | -2.36| 0.030400|*   |
|mnau_hands                          |Central Europe vs Europe         |  2.59| 0.025700|*   |
|mnau_hands                          |Central Europe vs West Asia      |  2.36| 0.030400|*   |
|mnau_hands                          |Central Europe vs Southeast Asia | -1.59| 0.139000|ns  |
|mnau_hands                          |Europe vs West Asia              | -0.21| 0.837000|ns  |
|mnau_hands                          |Europe vs Southeast Asia         | -3.55| 0.003790|**  |
|mnau_hands                          |West Asia vs Southeast Asia      | -3.37| 0.003810|**  |
|mnau_heip_evenness                  |West Europe vs Central Europe    | -0.24| 0.899000|ns  |
|mnau_heip_evenness                  |West Europe vs Europe            |  2.30| 0.042600|*   |
|mnau_heip_evenness                  |West Europe vs West Asia         |  2.45| 0.042600|*   |
|mnau_heip_evenness                  |West Europe vs Southeast Asia    | -2.34| 0.042600|*   |
|mnau_heip_evenness                  |Central Europe vs Europe         |  2.04| 0.058500|ns  |
|mnau_heip_evenness                  |Central Europe vs West Asia      |  2.17| 0.050400|ns  |
|mnau_heip_evenness                  |Central Europe vs Southeast Asia | -1.88| 0.075500|ns  |
|mnau_heip_evenness                  |Europe vs West Asia              |  0.11| 0.913000|ns  |
|mnau_heip_evenness                  |Europe vs Southeast Asia         | -3.37| 0.003790|**  |
|mnau_heip_evenness                  |West Asia vs Southeast Asia      | -3.47| 0.003790|**  |
|mnau_inverse_simpson                |West Europe vs Central Europe    | -0.17| 0.903000|ns  |
|mnau_inverse_simpson                |West Europe vs Europe            |  1.96| 0.099400|ns  |
|mnau_inverse_simpson                |West Europe vs West Asia         |  2.13| 0.082900|ns  |
|mnau_inverse_simpson                |West Europe vs Southeast Asia    | -2.21| 0.082900|ns  |
|mnau_inverse_simpson                |Central Europe vs Europe         |  1.72| 0.107000|ns  |
|mnau_inverse_simpson                |Central Europe vs West Asia      |  1.85| 0.102000|ns  |
|mnau_inverse_simpson                |Central Europe vs Southeast Asia | -1.80| 0.102000|ns  |
|mnau_inverse_simpson                |Europe vs West Asia              |  0.12| 0.903000|ns  |
|mnau_inverse_simpson                |Europe vs Southeast Asia         | -3.03| 0.012000|*   |
|mnau_inverse_simpson                |West Asia vs Southeast Asia      | -3.15| 0.012000|*   |
|mnau_lower_appendicular_mean        |West Europe vs Central Europe    | -0.69| 0.542000|ns  |
|mnau_lower_appendicular_mean        |West Europe vs Europe            |  1.90| 0.082600|ns  |
|mnau_lower_appendicular_mean        |West Europe vs West Asia         |  2.02| 0.075800|ns  |
|mnau_lower_appendicular_mean        |West Europe vs Southeast Asia    | -2.05| 0.075800|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs Europe         |  2.00| 0.075800|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs West Asia      |  2.10| 0.075800|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs Southeast Asia | -1.37| 0.215000|ns  |
|mnau_lower_appendicular_mean        |Europe vs West Asia              |  0.09| 0.928000|ns  |
|mnau_lower_appendicular_mean        |Europe vs Southeast Asia         | -2.87| 0.020800|*   |
|mnau_lower_appendicular_mean        |West Asia vs Southeast Asia      | -2.95| 0.020800|*   |
|mnau_pelvic                         |West Europe vs Central Europe    | -0.62| 0.591000|ns  |
|mnau_pelvic                         |West Europe vs Europe            |  1.58| 0.163000|ns  |
|mnau_pelvic                         |West Europe vs West Asia         |  1.85| 0.127000|ns  |
|mnau_pelvic                         |West Europe vs Southeast Asia    | -2.10| 0.120000|ns  |
|mnau_pelvic                         |Central Europe vs Europe         |  1.70| 0.150000|ns  |
|mnau_pelvic                         |Central Europe vs West Asia      |  1.92| 0.127000|ns  |
|mnau_pelvic                         |Central Europe vs Southeast Asia | -1.45| 0.185000|ns  |
|mnau_pelvic                         |Europe vs West Asia              |  0.20| 0.841000|ns  |
|mnau_pelvic                         |Europe vs Southeast Asia         | -2.69| 0.035500|*   |
|mnau_pelvic                         |West Asia vs Southeast Asia      | -2.88| 0.035500|*   |
|mnau_postcranial_total_mean         |West Europe vs Central Europe    | -0.40| 0.689000|ns  |
|mnau_postcranial_total_mean         |West Europe vs Europe            |  1.61| 0.143000|ns  |
|mnau_postcranial_total_mean         |West Europe vs West Asia         |  2.25| 0.061700|ns  |
|mnau_postcranial_total_mean         |West Europe vs Southeast Asia    | -2.38| 0.057800|ns  |
|mnau_postcranial_total_mean         |Central Europe vs Europe         |  1.58| 0.143000|ns  |
|mnau_postcranial_total_mean         |Central Europe vs West Asia      |  2.10| 0.071600|ns  |
|mnau_postcranial_total_mean         |Central Europe vs Southeast Asia | -1.82| 0.116000|ns  |
|mnau_postcranial_total_mean         |Europe vs West Asia              |  0.46| 0.689000|ns  |
|mnau_postcranial_total_mean         |Europe vs Southeast Asia         | -2.93| 0.016700|*   |
|mnau_postcranial_total_mean         |West Asia vs Southeast Asia      | -3.36| 0.007910|**  |
|mnau_region_mean_evenness           |West Europe vs Central Europe    | -0.08| 0.938000|ns  |
|mnau_region_mean_evenness           |West Europe vs Europe            |  2.33| 0.039600|*   |
|mnau_region_mean_evenness           |West Europe vs West Asia         |  2.60| 0.030500|*   |
|mnau_region_mean_evenness           |West Europe vs Southeast Asia    | -2.51| 0.030500|*   |
|mnau_region_mean_evenness           |Central Europe vs Europe         |  1.96| 0.062100|ns  |
|mnau_region_mean_evenness           |Central Europe vs West Asia      |  2.18| 0.048800|*   |
|mnau_region_mean_evenness           |Central Europe vs Southeast Asia | -2.11| 0.049700|*   |
|mnau_region_mean_evenness           |Europe vs West Asia              |  0.19| 0.938000|ns  |
|mnau_region_mean_evenness           |Europe vs Southeast Asia         | -3.51| 0.002220|**  |
|mnau_region_mean_evenness           |West Asia vs Southeast Asia      | -3.69| 0.002220|**  |
|mnau_shoulder                       |West Europe vs Central Europe    |  0.75| 0.503000|ns  |
|mnau_shoulder                       |West Europe vs Europe            |  1.99| 0.077500|ns  |
|mnau_shoulder                       |West Europe vs West Asia         |  2.34| 0.051400|ns  |
|mnau_shoulder                       |West Europe vs Southeast Asia    | -2.19| 0.056500|ns  |
|mnau_shoulder                       |Central Europe vs Europe         |  1.15| 0.312000|ns  |
|mnau_shoulder                       |Central Europe vs West Asia      |  1.44| 0.214000|ns  |
|mnau_shoulder                       |Central Europe vs Southeast Asia | -2.32| 0.051400|ns  |
|mnau_shoulder                       |Europe vs West Asia              |  0.26| 0.798000|ns  |
|mnau_shoulder                       |Europe vs Southeast Asia         | -3.04| 0.011800|*   |
|mnau_shoulder                       |West Asia vs Southeast Asia      | -3.27| 0.010600|*   |
|mnau_simpson_dominance              |West Europe vs Central Europe    |  0.17| 0.903000|ns  |
|mnau_simpson_dominance              |West Europe vs Europe            | -1.96| 0.099400|ns  |
|mnau_simpson_dominance              |West Europe vs West Asia         | -2.13| 0.082900|ns  |
|mnau_simpson_dominance              |West Europe vs Southeast Asia    |  2.21| 0.082900|ns  |
|mnau_simpson_dominance              |Central Europe vs Europe         | -1.72| 0.107000|ns  |
|mnau_simpson_dominance              |Central Europe vs West Asia      | -1.85| 0.102000|ns  |
|mnau_simpson_dominance              |Central Europe vs Southeast Asia |  1.80| 0.102000|ns  |
|mnau_simpson_dominance              |Europe vs West Asia              | -0.12| 0.903000|ns  |
|mnau_simpson_dominance              |Europe vs Southeast Asia         |  3.03| 0.012000|*   |
|mnau_simpson_dominance              |West Asia vs Southeast Asia      |  3.15| 0.012000|*   |
|mnau_simpson_evenness               |West Europe vs Central Europe    | -0.17| 0.903000|ns  |
|mnau_simpson_evenness               |West Europe vs Europe            |  1.96| 0.099400|ns  |
|mnau_simpson_evenness               |West Europe vs West Asia         |  2.13| 0.082900|ns  |
|mnau_simpson_evenness               |West Europe vs Southeast Asia    | -2.21| 0.082900|ns  |
|mnau_simpson_evenness               |Central Europe vs Europe         |  1.72| 0.107000|ns  |
|mnau_simpson_evenness               |Central Europe vs West Asia      |  1.85| 0.102000|ns  |
|mnau_simpson_evenness               |Central Europe vs Southeast Asia | -1.80| 0.102000|ns  |
|mnau_simpson_evenness               |Europe vs West Asia              |  0.12| 0.903000|ns  |
|mnau_simpson_evenness               |Europe vs Southeast Asia         | -3.03| 0.012000|*   |
|mnau_simpson_evenness               |West Asia vs Southeast Asia      | -3.15| 0.012000|*   |
|mnau_top2_share_mcnaughton          |West Europe vs Central Europe    |  0.05| 0.960000|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs Europe            | -1.86| 0.104000|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs West Asia         | -2.12| 0.067200|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs Southeast Asia    |  2.81| 0.016700|*   |
|mnau_top2_share_mcnaughton          |Central Europe vs Europe         | -1.56| 0.148000|ns  |
|mnau_top2_share_mcnaughton          |Central Europe vs West Asia      | -1.78| 0.108000|ns  |
|mnau_top2_share_mcnaughton          |Central Europe vs Southeast Asia |  2.39| 0.042700|*   |
|mnau_top2_share_mcnaughton          |Europe vs West Asia              | -0.19| 0.943000|ns  |
|mnau_top2_share_mcnaughton          |Europe vs Southeast Asia         |  3.44| 0.002950|**  |
|mnau_top2_share_mcnaughton          |West Asia vs Southeast Asia      |  3.61| 0.002950|**  |
|mnau_upper_appendicular_mean        |West Europe vs Central Europe    |  0.14| 0.893000|ns  |
|mnau_upper_appendicular_mean        |West Europe vs Europe            |  1.88| 0.099900|ns  |
|mnau_upper_appendicular_mean        |West Europe vs West Asia         |  2.07| 0.077700|ns  |
|mnau_upper_appendicular_mean        |West Europe vs Southeast Asia    | -2.44| 0.049500|*   |
|mnau_upper_appendicular_mean        |Central Europe vs Europe         |  1.46| 0.182000|ns  |
|mnau_upper_appendicular_mean        |Central Europe vs West Asia      |  1.61| 0.154000|ns  |
|mnau_upper_appendicular_mean        |Central Europe vs Southeast Asia | -2.17| 0.074700|ns  |
|mnau_upper_appendicular_mean        |Europe vs West Asia              |  0.13| 0.893000|ns  |
|mnau_upper_appendicular_mean        |Europe vs Southeast Asia         | -3.16| 0.007970|**  |
|mnau_upper_appendicular_mean        |West Asia vs Southeast Asia      | -3.28| 0.007970|**  |
|mne_arms                            |West Europe vs Central Europe    |  0.63| 0.531000|ns  |
|mne_arms                            |West Europe vs Europe            |  3.90| 0.000472|*** |
|mne_arms                            |West Europe vs West Asia         |  2.06| 0.056700|ns  |
|mne_arms                            |West Europe vs Southeast Asia    | -2.21| 0.044800|*   |
|mne_arms                            |Central Europe vs Europe         |  2.80| 0.012700|*   |
|mne_arms                            |Central Europe vs West Asia      |  1.29| 0.220000|ns  |
|mne_arms                            |Central Europe vs Southeast Asia | -2.26| 0.044800|*   |
|mne_arms                            |Europe vs West Asia              | -1.35| 0.220000|ns  |
|mne_arms                            |Europe vs Southeast Asia         | -4.33| 0.000148|*** |
|mne_arms                            |West Asia vs Southeast Asia      | -3.10| 0.006450|**  |
|postcranial_dominance_refined       |West Europe vs Central Europe    | -0.87| 0.426000|ns  |
|postcranial_dominance_refined       |West Europe vs Europe            | -2.22| 0.045600|*   |
|postcranial_dominance_refined       |West Europe vs West Asia         | -2.51| 0.039700|*   |
|postcranial_dominance_refined       |West Europe vs Southeast Asia    |  2.21| 0.045600|*   |
|postcranial_dominance_refined       |Central Europe vs Europe         | -1.13| 0.325000|ns  |
|postcranial_dominance_refined       |Central Europe vs West Asia      | -1.35| 0.252000|ns  |
|postcranial_dominance_refined       |Central Europe vs Southeast Asia |  2.40| 0.041100|*   |
|postcranial_dominance_refined       |Europe vs West Asia              | -0.21| 0.831000|ns  |
|postcranial_dominance_refined       |Europe vs Southeast Asia         |  3.14| 0.008430|**  |
|postcranial_dominance_refined       |West Asia vs Southeast Asia      |  3.31| 0.008430|**  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 2.13, R² = 0.073, p = 0.0205.
PCA variance explained: PC1 56.2%, PC2 9.2%, PC3 6.4% (cumulative 71.8%).
Dispersion caveat (PERMDISP): p = 0.081.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.161| -0.138| -0.024|
|mnau_appendicular_mean      | -0.160| -0.136|  0.026|
|mnau_gini                   |  0.158| -0.120| -0.016|
|mnau_top2_share_mcnaughton  |  0.158| -0.140| -0.002|
|mnau_inverse_simpson        | -0.158|  0.107|  0.013|
|mnau_simpson_evenness       | -0.158|  0.107|  0.013|
|effective_sections_hill1    | -0.158|  0.134|  0.010|
|mnau_heip_evenness          | -0.158|  0.134|  0.010|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
