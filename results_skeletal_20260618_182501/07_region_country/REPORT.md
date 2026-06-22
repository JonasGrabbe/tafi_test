# Research-history / sampling bias
*Automated region × skeletal-part representation*

- **Grouping column:** `region` (mode = alternative)
- **Groups (n):** West Europe = 107; Central Europe = 12; West Asia = 7; Europe = 6; Southeast Asia = 5
- **Sites analysed:** 137  |  **features screened:** 63

## Hypothesis

**H:** Regional research history, geology, climate and excavation tradition affect recovery.

**Expected pattern:** Some regions more complete (cave preservation/modern excavation); others biased to diagnostic cranial/dental material.

**Why it matters:** Detects sampling and research-history bias; weaker as a behavioural hypothesis.


## Summary

39 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_distal_appendicular_mean** (ε² = 0.150, FDR p = 0.003244). PERMANOVA pseudo-F = 1.99, p = 0.0277; PC1–PC3 explain 71.8% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 177 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 13 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mnau_distal_appendicular_mean                |  0.150| 0.00324|large      |significant |
|mne_arms                                     |  0.147| 0.00324|large      |significant |
|distal_appendicular_continuity_hm            |  0.136| 0.00430|moderate   |significant |
|mnau_foot                                    |  0.120| 0.00853|moderate   |significant |
|appendicular_dominance                       |  0.116| 0.01410|moderate   |significant |
|appendicular_dominance_refined               |  0.116| 0.01410|moderate   |significant |
|ProportionalRep_MNIbased_carpal              |  0.116| 0.00853|moderate   |significant |
|postcranial_dominance_refined                |  0.107| 0.01700|moderate   |significant |
|mnau_region_mean_evenness                    |  0.103| 0.01410|moderate   |significant |
|mnau_hands                                   |  0.099| 0.01410|moderate   |significant |
|lower_appendicular_evenness                  |  0.097| 0.01890|moderate   |significant |
|lower_appendicular_evenness_refined          |  0.097| 0.01890|moderate   |significant |
|mnau_gini                                    |  0.089| 0.01700|moderate   |significant |
|lower_appendicular_continuity_hm             |  0.088| 0.01700|moderate   |significant |
|effective_sections_hill1                     |  0.088| 0.01700|moderate   |significant |
|mnau_heip_evenness                           |  0.088| 0.01700|moderate   |significant |
|mnau_top2_share_mcnaughton                   |  0.086| 0.01700|moderate   |significant |
|mnau_axial_main_mean                         |  0.084| 0.01700|moderate   |significant |
|low_density_survival_index                   |  0.084| 0.01700|moderate   |significant |
|low_density_axial_survival                   |  0.081| 0.01890|moderate   |significant |
|mnau_column_trunk_mean                       |  0.078| 0.01890|moderate   |significant |
|mnau_shoulder                                |  0.077| 0.01890|moderate   |significant |
|mnau_upper_appendicular_mean                 |  0.073| 0.02360|moderate   |significant |
|mnau_postcranial_total_mean                  |  0.072| 0.02390|moderate   |significant |
|mnau_appendicular_mean                       |  0.068| 0.02920|moderate   |significant |
|mnau_girdle_mean                             |  0.066| 0.03080|moderate   |significant |
|mnau_dominance_of_region_means               |  0.065| 0.03240|moderate   |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.064| 0.03240|moderate   |significant |
|mnau_inverse_simpson                         |  0.061| 0.03410|moderate   |significant |
|mnau_simpson_evenness                        |  0.061| 0.03410|moderate   |significant |
|mnau_simpson_dominance                       |  0.061| 0.03410|moderate   |significant |
|mnau_lower_appendicular_mean                 |  0.060| 0.03410|moderate   |significant |
|ProportionalRep_MNIbased_clavicle            |  0.060| 0.03410|moderate   |significant |
|ProportionalRep_MNIbased_radius              |  0.060| 0.03410|small      |significant |
|mnau_evenness_minus_dominance                |  0.059| 0.03580|small      |significant |
|mnau_cv                                      |  0.056| 0.04180|small      |significant |
|low_density_share                            |  0.054| 0.04330|small      |significant |
|ProportionalRep_MNIbased_cervical            |  0.053| 0.04330|small      |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.053| 0.04330|small      |significant |
|mnau_arms                                    |  0.048| 0.05400|small      |n.s.        |
|mnau_pelvic                                  |  0.048| 0.05440|small      |n.s.        |
|mnau_proximal_appendicular_mean              |  0.046| 0.05740|small      |n.s.        |
|ReMNAU_ulna                                  |  0.045| 0.06080|small      |n.s.        |
|all_sections_dominance                       |  0.040| 0.08220|small      |n.s.        |
|mne_cranial_share                            |  0.038| 0.08710|small      |n.s.        |
|mnau_limb_shaft_proxy_mean                   |  0.037| 0.08850|small      |n.s.        |
|ProportionalRep_MNIbased_fibula              |  0.035| 0.09420|small      |n.s.        |
|ReMNAU_radius                                |  0.034| 0.09730|small      |n.s.        |
|density_evenness                             |  0.030| 0.12200|small      |n.s.        |
|ProportionalRep_MNIbased_humerus             |  0.026| 0.14500|small      |n.s.        |
|ReMNAU_cervical                              |  0.026| 0.14500|small      |n.s.        |
|dominant_axial_share                         |  0.020| 0.18800|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.019| 0.18800|small      |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.019| 0.18800|small      |n.s.        |
|mnau_legs                                    |  0.018| 0.19200|small      |n.s.        |
|mnau_arms_legs_diff                          |  0.018| 0.19200|small      |n.s.        |
|ProportionalRep_MNIbased_tibia               |  0.013| 0.23900|small      |n.s.        |
|dominance_gap_all                            |  0.010| 0.28200|negligible |n.s.        |
|ProportionalRep_MNIbased_femur               |  0.004| 0.36400|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast |  0.000| 0.43500|negligible |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.002| 0.45200|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.005| 0.51400|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.007| 0.54900|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                         |     Z|  p (adj)|Sig |
|:-----------------------------------|:--------------------------------|-----:|--------:|:---|
|ProportionalRep_MNIbased_carpal     |West Europe vs Central Europe    |  0.22| 0.827000|ns  |
|ProportionalRep_MNIbased_carpal     |West Europe vs West Asia         |  3.33| 0.005120|**  |
|ProportionalRep_MNIbased_carpal     |West Europe vs Europe            |  2.53| 0.022500|*   |
|ProportionalRep_MNIbased_carpal     |West Europe vs Southeast Asia    | -1.36| 0.243000|ns  |
|ProportionalRep_MNIbased_carpal     |Central Europe vs West Asia      |  2.59| 0.022500|*   |
|ProportionalRep_MNIbased_carpal     |Central Europe vs Europe         |  1.99| 0.077000|ns  |
|ProportionalRep_MNIbased_carpal     |Central Europe vs Southeast Asia | -1.30| 0.243000|ns  |
|ProportionalRep_MNIbased_carpal     |West Asia vs Europe              | -0.42| 0.747000|ns  |
|ProportionalRep_MNIbased_carpal     |West Asia vs Southeast Asia      | -3.28| 0.005120|**  |
|ProportionalRep_MNIbased_carpal     |Europe vs Southeast Asia         | -2.79| 0.017800|*   |
|ProportionalRep_MNIbased_cervical   |West Europe vs Central Europe    |  0.47| 0.722000|ns  |
|ProportionalRep_MNIbased_cervical   |West Europe vs West Asia         |  2.68| 0.036900|*   |
|ProportionalRep_MNIbased_cervical   |West Europe vs Europe            |  0.45| 0.722000|ns  |
|ProportionalRep_MNIbased_cervical   |West Europe vs Southeast Asia    | -1.75| 0.162000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs West Asia      |  1.89| 0.162000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs Europe         |  0.09| 0.927000|ns  |
|ProportionalRep_MNIbased_cervical   |Central Europe vs Southeast Asia | -1.77| 0.162000|ns  |
|ProportionalRep_MNIbased_cervical   |West Asia vs Europe              | -1.54| 0.178000|ns  |
|ProportionalRep_MNIbased_cervical   |West Asia vs Southeast Asia      | -3.15| 0.016400|*   |
|ProportionalRep_MNIbased_cervical   |Europe vs Southeast Asia         | -1.63| 0.171000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Central Europe    |  0.86| 0.432000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs West Asia         |  2.05| 0.093400|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Europe            |  1.68| 0.155000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Europe vs Southeast Asia    | -1.99| 0.093400|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs West Asia      |  1.13| 0.367000|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs Europe         |  0.89| 0.432000|ns  |
|ProportionalRep_MNIbased_clavicle   |Central Europe vs Southeast Asia | -2.20| 0.092100|ns  |
|ProportionalRep_MNIbased_clavicle   |West Asia vs Europe              | -0.17| 0.863000|ns  |
|ProportionalRep_MNIbased_clavicle   |West Asia vs Southeast Asia      | -2.92| 0.034700|*   |
|ProportionalRep_MNIbased_clavicle   |Europe vs Southeast Asia         | -2.67| 0.038300|*   |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Central Europe    | -0.35| 0.725000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Europe vs West Asia         |  2.52| 0.054400|ns  |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Europe            |  1.28| 0.250000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Europe vs Southeast Asia    | -1.93| 0.106000|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs West Asia      |  2.29| 0.054400|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs Europe         |  1.29| 0.250000|ns  |
|ProportionalRep_MNIbased_metacarpal |Central Europe vs Southeast Asia | -1.46| 0.240000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Asia vs Europe              | -0.80| 0.470000|ns  |
|ProportionalRep_MNIbased_metacarpal |West Asia vs Southeast Asia      | -3.19| 0.014100|*   |
|ProportionalRep_MNIbased_metacarpal |Europe vs Southeast Asia         | -2.35| 0.054400|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Central Europe    | -0.38| 0.733000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs West Asia         |  2.08| 0.103000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Europe            |  1.48| 0.179000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Europe vs Southeast Asia    | -1.95| 0.103000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs West Asia      |  1.95| 0.103000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs Europe         |  1.47| 0.179000|ns  |
|ProportionalRep_MNIbased_os_coxae   |Central Europe vs Southeast Asia | -1.46| 0.179000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Asia vs Europe              | -0.34| 0.733000|ns  |
|ProportionalRep_MNIbased_os_coxae   |West Asia vs Southeast Asia      | -2.91| 0.036000|*   |
|ProportionalRep_MNIbased_os_coxae   |Europe vs Southeast Asia         | -2.50| 0.061600|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs Central Europe    |  0.17| 0.868000|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs West Asia         |  2.25| 0.081300|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs Europe            |  1.46| 0.206000|ns  |
|ProportionalRep_MNIbased_radius     |West Europe vs Southeast Asia    | -2.06| 0.099600|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs West Asia      |  1.74| 0.136000|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs Europe         |  1.12| 0.326000|ns  |
|ProportionalRep_MNIbased_radius     |Central Europe vs Southeast Asia | -1.86| 0.125000|ns  |
|ProportionalRep_MNIbased_radius     |West Asia vs Europe              | -0.48| 0.704000|ns  |
|ProportionalRep_MNIbased_radius     |West Asia vs Southeast Asia      | -3.11| 0.019000|*   |
|ProportionalRep_MNIbased_radius     |Europe vs Southeast Asia         | -2.56| 0.051600|ns  |
|appendicular_dominance              |West Europe vs Central Europe    | -1.06| 0.321000|ns  |
|appendicular_dominance              |West Europe vs West Asia         | -2.31| 0.041900|*   |
|appendicular_dominance              |West Europe vs Europe            | -2.46| 0.036300|*   |
|appendicular_dominance              |West Europe vs Southeast Asia    |  2.15| 0.053200|ns  |
|appendicular_dominance              |Central Europe vs West Asia      | -1.06| 0.321000|ns  |
|appendicular_dominance              |Central Europe vs Europe         | -1.26| 0.295000|ns  |
|appendicular_dominance              |Central Europe vs Southeast Asia |  2.44| 0.036300|*   |
|appendicular_dominance              |West Asia vs Europe              | -0.24| 0.814000|ns  |
|appendicular_dominance              |West Asia vs Southeast Asia      |  3.14| 0.008540|**  |
|appendicular_dominance              |Europe vs Southeast Asia         |  3.25| 0.008540|**  |
|appendicular_dominance_refined      |West Europe vs Central Europe    | -1.06| 0.321000|ns  |
|appendicular_dominance_refined      |West Europe vs West Asia         | -2.31| 0.041900|*   |
|appendicular_dominance_refined      |West Europe vs Europe            | -2.46| 0.036300|*   |
|appendicular_dominance_refined      |West Europe vs Southeast Asia    |  2.15| 0.053200|ns  |
|appendicular_dominance_refined      |Central Europe vs West Asia      | -1.06| 0.321000|ns  |
|appendicular_dominance_refined      |Central Europe vs Europe         | -1.26| 0.295000|ns  |
|appendicular_dominance_refined      |Central Europe vs Southeast Asia |  2.44| 0.036300|*   |
|appendicular_dominance_refined      |West Asia vs Europe              | -0.24| 0.814000|ns  |
|appendicular_dominance_refined      |West Asia vs Southeast Asia      |  3.14| 0.008540|**  |
|appendicular_dominance_refined      |Europe vs Southeast Asia         |  3.25| 0.008540|**  |
|distal_appendicular_continuity_hm   |West Europe vs Central Europe    | -0.57| 0.632000|ns  |
|distal_appendicular_continuity_hm   |West Europe vs West Asia         |  2.46| 0.023400|*   |
|distal_appendicular_continuity_hm   |West Europe vs Europe            |  2.71| 0.017500|*   |
|distal_appendicular_continuity_hm   |West Europe vs Southeast Asia    | -2.70| 0.017500|*   |
|distal_appendicular_continuity_hm   |Central Europe vs West Asia      |  2.38| 0.024800|*   |
|distal_appendicular_continuity_hm   |Central Europe vs Europe         |  2.62| 0.017500|*   |
|distal_appendicular_continuity_hm   |Central Europe vs Southeast Asia | -1.99| 0.058000|ns  |
|distal_appendicular_continuity_hm   |West Asia vs Europe              |  0.32| 0.748000|ns  |
|distal_appendicular_continuity_hm   |West Asia vs Southeast Asia      | -3.74| 0.000907|*** |
|distal_appendicular_continuity_hm   |Europe vs Southeast Asia         | -3.92| 0.000904|*** |
|effective_sections_hill1            |West Europe vs Central Europe    | -0.23| 0.820000|ns  |
|effective_sections_hill1            |West Europe vs West Asia         |  2.52| 0.038900|*   |
|effective_sections_hill1            |West Europe vs Europe            |  1.64| 0.144000|ns  |
|effective_sections_hill1            |West Europe vs Southeast Asia    | -2.37| 0.045000|*   |
|effective_sections_hill1            |Central Europe vs West Asia      |  2.22| 0.053500|ns  |
|effective_sections_hill1            |Central Europe vs Europe         |  1.52| 0.161000|ns  |
|effective_sections_hill1            |Central Europe vs Southeast Asia | -1.90| 0.094900|ns  |
|effective_sections_hill1            |West Asia vs Europe              | -0.53| 0.662000|ns  |
|effective_sections_hill1            |West Asia vs Southeast Asia      | -3.53| 0.004150|**  |
|effective_sections_hill1            |Europe vs Southeast Asia         | -2.93| 0.017100|*   |
|low_density_axial_survival          |West Europe vs Central Europe    | -0.38| 0.702000|ns  |
|low_density_axial_survival          |West Europe vs West Asia         |  2.47| 0.033500|*   |
|low_density_axial_survival          |West Europe vs Europe            |  1.02| 0.373000|ns  |
|low_density_axial_survival          |West Europe vs Southeast Asia    | -2.57| 0.033500|*   |
|low_density_axial_survival          |Central Europe vs West Asia      |  2.27| 0.046000|*   |
|low_density_axial_survival          |Central Europe vs Europe         |  1.09| 0.373000|ns  |
|low_density_axial_survival          |Central Europe vs Southeast Asia | -1.99| 0.077400|ns  |
|low_density_axial_survival          |West Asia vs Europe              | -0.96| 0.373000|ns  |
|low_density_axial_survival          |West Asia vs Southeast Asia      | -3.66| 0.002550|**  |
|low_density_axial_survival          |Europe vs Southeast Asia         | -2.65| 0.033500|*   |
|low_density_share                   |West Europe vs Central Europe    |  0.20| 0.841000|ns  |
|low_density_share                   |West Europe vs West Asia         |  1.60| 0.219000|ns  |
|low_density_share                   |West Europe vs Europe            |  0.52| 0.750000|ns  |
|low_density_share                   |West Europe vs Southeast Asia    | -2.76| 0.028600|*   |
|low_density_share                   |Central Europe vs West Asia      |  1.18| 0.394000|ns  |
|low_density_share                   |Central Europe vs Europe         |  0.32| 0.833000|ns  |
|low_density_share                   |Central Europe vs Southeast Asia | -2.49| 0.035400|*   |
|low_density_share                   |West Asia vs Europe              | -0.73| 0.668000|ns  |
|low_density_share                   |West Asia vs Southeast Asia      | -3.23| 0.012500|*   |
|low_density_share                   |Europe vs Southeast Asia         | -2.45| 0.035400|*   |
|low_density_survival_index          |West Europe vs Central Europe    |  0.16| 0.875000|ns  |
|low_density_survival_index          |West Europe vs West Asia         |  2.41| 0.034600|*   |
|low_density_survival_index          |West Europe vs Europe            |  1.21| 0.326000|ns  |
|low_density_survival_index          |West Europe vs Southeast Asia    | -2.66| 0.025700|*   |
|low_density_survival_index          |Central Europe vs West Asia      |  1.88| 0.101000|ns  |
|low_density_survival_index          |Central Europe vs Europe         |  0.92| 0.450000|ns  |
|low_density_survival_index          |Central Europe vs Southeast Asia | -2.38| 0.034600|*   |
|low_density_survival_index          |West Asia vs Europe              | -0.78| 0.483000|ns  |
|low_density_survival_index          |West Asia vs Southeast Asia      | -3.69| 0.002260|**  |
|low_density_survival_index          |Europe vs Southeast Asia         | -2.85| 0.022000|*   |
|lower_appendicular_continuity_hm    |West Europe vs Central Europe    |  0.00| 0.998000|ns  |
|lower_appendicular_continuity_hm    |West Europe vs West Asia         |  2.19| 0.056400|ns  |
|lower_appendicular_continuity_hm    |West Europe vs Europe            |  2.27| 0.056400|ns  |
|lower_appendicular_continuity_hm    |West Europe vs Southeast Asia    | -2.27| 0.056400|ns  |
|lower_appendicular_continuity_hm    |Central Europe vs West Asia      |  1.80| 0.089400|ns  |
|lower_appendicular_continuity_hm    |Central Europe vs Europe         |  1.91| 0.080600|ns  |
|lower_appendicular_continuity_hm    |Central Europe vs Southeast Asia | -1.95| 0.080600|ns  |
|lower_appendicular_continuity_hm    |West Asia vs Europe              |  0.17| 0.958000|ns  |
|lower_appendicular_continuity_hm    |West Asia vs Southeast Asia      | -3.23| 0.006130|**  |
|lower_appendicular_continuity_hm    |Europe vs Southeast Asia         | -3.29| 0.006130|**  |
|lower_appendicular_evenness         |West Europe vs Central Europe    |  0.34| 0.757000|ns  |
|lower_appendicular_evenness         |West Europe vs West Asia         |  2.00| 0.076600|ns  |
|lower_appendicular_evenness         |West Europe vs Europe            |  2.27| 0.066100|ns  |
|lower_appendicular_evenness         |West Europe vs Southeast Asia    | -2.22| 0.066100|ns  |
|lower_appendicular_evenness         |Central Europe vs West Asia      |  1.32| 0.234000|ns  |
|lower_appendicular_evenness         |Central Europe vs Europe         |  1.59| 0.161000|ns  |
|lower_appendicular_evenness         |Central Europe vs Southeast Asia | -2.13| 0.066100|ns  |
|lower_appendicular_evenness         |West Asia vs Europe              |  0.31| 0.757000|ns  |
|lower_appendicular_evenness         |West Asia vs Southeast Asia      | -3.02| 0.012600|*   |
|lower_appendicular_evenness         |Europe vs Southeast Asia         | -3.19| 0.012600|*   |
|lower_appendicular_evenness_refined |West Europe vs Central Europe    |  0.34| 0.757000|ns  |
|lower_appendicular_evenness_refined |West Europe vs West Asia         |  2.00| 0.076600|ns  |
|lower_appendicular_evenness_refined |West Europe vs Europe            |  2.27| 0.066100|ns  |
|lower_appendicular_evenness_refined |West Europe vs Southeast Asia    | -2.22| 0.066100|ns  |
|lower_appendicular_evenness_refined |Central Europe vs West Asia      |  1.32| 0.234000|ns  |
|lower_appendicular_evenness_refined |Central Europe vs Europe         |  1.59| 0.161000|ns  |
|lower_appendicular_evenness_refined |Central Europe vs Southeast Asia | -2.13| 0.066100|ns  |
|lower_appendicular_evenness_refined |West Asia vs Europe              |  0.31| 0.757000|ns  |
|lower_appendicular_evenness_refined |West Asia vs Southeast Asia      | -3.02| 0.012600|*   |
|lower_appendicular_evenness_refined |Europe vs Southeast Asia         | -3.19| 0.012600|*   |
|mnau_appendicular_mean              |West Europe vs Central Europe    | -0.33| 0.740000|ns  |
|mnau_appendicular_mean              |West Europe vs West Asia         |  2.17| 0.075000|ns  |
|mnau_appendicular_mean              |West Europe vs Europe            |  1.40| 0.210000|ns  |
|mnau_appendicular_mean              |West Europe vs Southeast Asia    | -2.35| 0.062900|ns  |
|mnau_appendicular_mean              |Central Europe vs West Asia      |  1.99| 0.092600|ns  |
|mnau_appendicular_mean              |Central Europe vs Europe         |  1.38| 0.210000|ns  |
|mnau_appendicular_mean              |Central Europe vs Southeast Asia | -1.83| 0.112000|ns  |
|mnau_appendicular_mean              |West Asia vs Europe              | -0.46| 0.715000|ns  |
|mnau_appendicular_mean              |West Asia vs Southeast Asia      | -3.28| 0.010300|*   |
|mnau_appendicular_mean              |Europe vs Southeast Asia         | -2.75| 0.030100|*   |
|mnau_axial_main_mean                |West Europe vs Central Europe    | -0.31| 0.756000|ns  |
|mnau_axial_main_mean                |West Europe vs West Asia         |  2.53| 0.028200|*   |
|mnau_axial_main_mean                |West Europe vs Europe            |  1.15| 0.314000|ns  |
|mnau_axial_main_mean                |West Europe vs Southeast Asia    | -2.56| 0.028200|*   |
|mnau_axial_main_mean                |Central Europe vs West Asia      |  2.28| 0.045400|*   |
|mnau_axial_main_mean                |Central Europe vs Europe         |  1.15| 0.314000|ns  |
|mnau_axial_main_mean                |Central Europe vs Southeast Asia | -2.02| 0.072000|ns  |
|mnau_axial_main_mean                |West Asia vs Europe              | -0.91| 0.402000|ns  |
|mnau_axial_main_mean                |West Asia vs Southeast Asia      | -3.69| 0.002260|**  |
|mnau_axial_main_mean                |Europe vs Southeast Asia         | -2.73| 0.028200|*   |
|mnau_column_trunk_mean              |West Europe vs Central Europe    | -0.45| 0.653000|ns  |
|mnau_column_trunk_mean              |West Europe vs West Asia         |  2.28| 0.056100|ns  |
|mnau_column_trunk_mean              |West Europe vs Europe            |  1.01| 0.389000|ns  |
|mnau_column_trunk_mean              |West Europe vs Southeast Asia    | -2.66| 0.025900|*   |
|mnau_column_trunk_mean              |Central Europe vs West Asia      |  2.16| 0.061400|ns  |
|mnau_column_trunk_mean              |Central Europe vs Europe         |  1.12| 0.373000|ns  |
|mnau_column_trunk_mean              |Central Europe vs Southeast Asia | -2.03| 0.070400|ns  |
|mnau_column_trunk_mean              |West Asia vs Europe              | -0.84| 0.447000|ns  |
|mnau_column_trunk_mean              |West Asia vs Southeast Asia      | -3.60| 0.003170|**  |
|mnau_column_trunk_mean              |Europe vs Southeast Asia         | -2.71| 0.025900|*   |
|mnau_cv                             |West Europe vs Central Europe    |  0.23| 0.816000|ns  |
|mnau_cv                             |West Europe vs West Asia         | -2.04| 0.104000|ns  |
|mnau_cv                             |West Europe vs Europe            | -1.29| 0.275000|ns  |
|mnau_cv                             |West Europe vs Southeast Asia    |  2.19| 0.095000|ns  |
|mnau_cv                             |Central Europe vs West Asia      | -1.82| 0.133000|ns  |
|mnau_cv                             |Central Europe vs Europe         | -1.23| 0.275000|ns  |
|mnau_cv                             |Central Europe vs Southeast Asia |  1.75| 0.133000|ns  |
|mnau_cv                             |West Asia vs Europe              |  0.45| 0.721000|ns  |
|mnau_cv                             |West Asia vs Southeast Asia      |  3.07| 0.021300|*   |
|mnau_cv                             |Europe vs Southeast Asia         |  2.55| 0.053500|ns  |
|mnau_distal_appendicular_mean       |West Europe vs Central Europe    | -0.90| 0.409000|ns  |
|mnau_distal_appendicular_mean       |West Europe vs West Asia         |  3.02| 0.006300|**  |
|mnau_distal_appendicular_mean       |West Europe vs Europe            |  2.31| 0.029500|*   |
|mnau_distal_appendicular_mean       |West Europe vs Southeast Asia    | -2.71| 0.013600|*   |
|mnau_distal_appendicular_mean       |Central Europe vs West Asia      |  3.05| 0.006300|**  |
|mnau_distal_appendicular_mean       |Central Europe vs Europe         |  2.49| 0.021300|*   |
|mnau_distal_appendicular_mean       |Central Europe vs Southeast Asia | -1.81| 0.087400|ns  |
|mnau_distal_appendicular_mean       |West Asia vs Europe              | -0.37| 0.709000|ns  |
|mnau_distal_appendicular_mean       |West Asia vs Southeast Asia      | -4.13| 0.000365|*** |
|mnau_distal_appendicular_mean       |Europe vs Southeast Asia         | -3.65| 0.001320|**  |
|mnau_dominance_of_region_means      |West Europe vs Central Europe    |  0.23| 0.816000|ns  |
|mnau_dominance_of_region_means      |West Europe vs West Asia         | -2.06| 0.088100|ns  |
|mnau_dominance_of_region_means      |West Europe vs Europe            | -1.15| 0.334000|ns  |
|mnau_dominance_of_region_means      |West Europe vs Southeast Asia    |  2.50| 0.041800|*   |
|mnau_dominance_of_region_means      |Central Europe vs West Asia      | -1.84| 0.110000|ns  |
|mnau_dominance_of_region_means      |Central Europe vs Europe         | -1.11| 0.334000|ns  |
|mnau_dominance_of_region_means      |Central Europe vs Southeast Asia |  2.01| 0.088100|ns  |
|mnau_dominance_of_region_means      |West Asia vs Europe              |  0.57| 0.630000|ns  |
|mnau_dominance_of_region_means      |West Asia vs Southeast Asia      |  3.32| 0.008930|**  |
|mnau_dominance_of_region_means      |Europe vs Southeast Asia         |  2.69| 0.036100|*   |
|mnau_evenness_minus_dominance       |West Europe vs Central Europe    | -0.18| 0.853000|ns  |
|mnau_evenness_minus_dominance       |West Europe vs West Asia         |  2.09| 0.092600|ns  |
|mnau_evenness_minus_dominance       |West Europe vs Europe            |  1.28| 0.288000|ns  |
|mnau_evenness_minus_dominance       |West Europe vs Southeast Asia    | -2.26| 0.079700|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs West Asia      |  1.83| 0.112000|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs Europe         |  1.18| 0.295000|ns  |
|mnau_evenness_minus_dominance       |Central Europe vs Southeast Asia | -1.84| 0.112000|ns  |
|mnau_evenness_minus_dominance       |West Asia vs Europe              | -0.50| 0.685000|ns  |
|mnau_evenness_minus_dominance       |West Asia vs Southeast Asia      | -3.16| 0.016000|*   |
|mnau_evenness_minus_dominance       |Europe vs Southeast Asia         | -2.59| 0.047700|*   |
|mnau_foot                           |West Europe vs Central Europe    | -0.34| 0.809000|ns  |
|mnau_foot                           |West Europe vs West Asia         |  2.57| 0.025200|*   |
|mnau_foot                           |West Europe vs Europe            |  2.71| 0.022300|*   |
|mnau_foot                           |West Europe vs Southeast Asia    | -2.24| 0.035900|*   |
|mnau_foot                           |Central Europe vs West Asia      |  2.33| 0.033000|*   |
|mnau_foot                           |Central Europe vs Europe         |  2.49| 0.025900|*   |
|mnau_foot                           |Central Europe vs Southeast Asia | -1.73| 0.105000|ns  |
|mnau_foot                           |West Asia vs Europe              |  0.24| 0.809000|ns  |
|mnau_foot                           |West Asia vs Southeast Asia      | -3.46| 0.002660|**  |
|mnau_foot                           |Europe vs Southeast Asia         | -3.57| 0.002660|**  |
|mnau_gini                           |West Europe vs Central Europe    |  0.25| 0.803000|ns  |
|mnau_gini                           |West Europe vs West Asia         | -2.56| 0.034700|*   |
|mnau_gini                           |West Europe vs Europe            | -1.69| 0.131000|ns  |
|mnau_gini                           |West Europe vs Southeast Asia    |  2.31| 0.047300|*   |
|mnau_gini                           |Central Europe vs West Asia      | -2.26| 0.047300|*   |
|mnau_gini                           |Central Europe vs Europe         | -1.57| 0.146000|ns  |
|mnau_gini                           |Central Europe vs Southeast Asia |  1.85| 0.108000|ns  |
|mnau_gini                           |West Asia vs Europe              |  0.53| 0.666000|ns  |
|mnau_gini                           |West Asia vs Southeast Asia      |  3.52| 0.004350|**  |
|mnau_gini                           |Europe vs Southeast Asia         |  2.92| 0.017600|*   |
|mnau_girdle_mean                    |West Europe vs Central Europe    |  0.32| 0.828000|ns  |
|mnau_girdle_mean                    |West Europe vs West Asia         |  1.91| 0.112000|ns  |
|mnau_girdle_mean                    |West Europe vs Europe            |  1.56| 0.196000|ns  |
|mnau_girdle_mean                    |West Europe vs Southeast Asia    | -2.45| 0.047100|*   |
|mnau_girdle_mean                    |Central Europe vs West Asia      |  1.36| 0.248000|ns  |
|mnau_girdle_mean                    |Central Europe vs Europe         |  1.11| 0.331000|ns  |
|mnau_girdle_mean                    |Central Europe vs Southeast Asia | -2.30| 0.054300|ns  |
|mnau_girdle_mean                    |West Asia vs Europe              | -0.16| 0.872000|ns  |
|mnau_girdle_mean                    |West Asia vs Southeast Asia      | -3.19| 0.014200|*   |
|mnau_girdle_mean                    |Europe vs Southeast Asia         | -2.94| 0.016500|*   |
|mnau_hands                          |West Europe vs Central Europe    | -0.78| 0.482000|ns  |
|mnau_hands                          |West Europe vs West Asia         |  2.28| 0.037200|*   |
|mnau_hands                          |West Europe vs Europe            |  2.16| 0.043900|*   |
|mnau_hands                          |West Europe vs Southeast Asia    | -2.38| 0.037200|*   |
|mnau_hands                          |Central Europe vs West Asia      |  2.38| 0.037200|*   |
|mnau_hands                          |Central Europe vs Europe         |  2.29| 0.037200|*   |
|mnau_hands                          |Central Europe vs Southeast Asia | -1.60| 0.138000|ns  |
|mnau_hands                          |West Asia vs Europe              |  0.03| 0.978000|ns  |
|mnau_hands                          |West Asia vs Southeast Asia      | -3.38| 0.004950|**  |
|mnau_hands                          |Europe vs Southeast Asia         | -3.29| 0.004950|**  |
|mnau_heip_evenness                  |West Europe vs Central Europe    | -0.23| 0.820000|ns  |
|mnau_heip_evenness                  |West Europe vs West Asia         |  2.52| 0.038900|*   |
|mnau_heip_evenness                  |West Europe vs Europe            |  1.64| 0.144000|ns  |
|mnau_heip_evenness                  |West Europe vs Southeast Asia    | -2.37| 0.045000|*   |
|mnau_heip_evenness                  |Central Europe vs West Asia      |  2.22| 0.053500|ns  |
|mnau_heip_evenness                  |Central Europe vs Europe         |  1.52| 0.161000|ns  |
|mnau_heip_evenness                  |Central Europe vs Southeast Asia | -1.90| 0.094900|ns  |
|mnau_heip_evenness                  |West Asia vs Europe              | -0.53| 0.662000|ns  |
|mnau_heip_evenness                  |West Asia vs Southeast Asia      | -3.53| 0.004150|**  |
|mnau_heip_evenness                  |Europe vs Southeast Asia         | -2.93| 0.017100|*   |
|mnau_inverse_simpson                |West Europe vs Central Europe    | -0.18| 0.860000|ns  |
|mnau_inverse_simpson                |West Europe vs West Asia         |  2.15| 0.079300|ns  |
|mnau_inverse_simpson                |West Europe vs Europe            |  1.30| 0.275000|ns  |
|mnau_inverse_simpson                |West Europe vs Southeast Asia    | -2.23| 0.079300|ns  |
|mnau_inverse_simpson                |Central Europe vs West Asia      |  1.88| 0.115000|ns  |
|mnau_inverse_simpson                |Central Europe vs Europe         |  1.20| 0.287000|ns  |
|mnau_inverse_simpson                |Central Europe vs Southeast Asia | -1.82| 0.115000|ns  |
|mnau_inverse_simpson                |West Asia vs Europe              | -0.52| 0.666000|ns  |
|mnau_inverse_simpson                |West Asia vs Southeast Asia      | -3.18| 0.014900|*   |
|mnau_inverse_simpson                |Europe vs Southeast Asia         | -2.59| 0.048100|*   |
|mnau_lower_appendicular_mean        |West Europe vs Central Europe    | -0.70| 0.537000|ns  |
|mnau_lower_appendicular_mean        |West Europe vs West Asia         |  2.04| 0.083500|ns  |
|mnau_lower_appendicular_mean        |West Europe vs Europe            |  1.56| 0.168000|ns  |
|mnau_lower_appendicular_mean        |West Europe vs Southeast Asia    | -2.06| 0.083500|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs West Asia      |  2.12| 0.083500|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs Europe         |  1.74| 0.137000|ns  |
|mnau_lower_appendicular_mean        |Central Europe vs Southeast Asia | -1.37| 0.214000|ns  |
|mnau_lower_appendicular_mean        |West Asia vs Europe              | -0.25| 0.804000|ns  |
|mnau_lower_appendicular_mean        |West Asia vs Southeast Asia      | -2.96| 0.030300|*   |
|mnau_lower_appendicular_mean        |Europe vs Southeast Asia         | -2.64| 0.041600|*   |
|mnau_postcranial_total_mean         |West Europe vs Central Europe    | -0.40| 0.691000|ns  |
|mnau_postcranial_total_mean         |West Europe vs West Asia         |  2.26| 0.059600|ns  |
|mnau_postcranial_total_mean         |West Europe vs Europe            |  1.37| 0.213000|ns  |
|mnau_postcranial_total_mean         |West Europe vs Southeast Asia    | -2.38| 0.057100|ns  |
|mnau_postcranial_total_mean         |Central Europe vs West Asia      |  2.11| 0.070000|ns  |
|mnau_postcranial_total_mean         |Central Europe vs Europe         |  1.39| 0.213000|ns  |
|mnau_postcranial_total_mean         |Central Europe vs Southeast Asia | -1.82| 0.114000|ns  |
|mnau_postcranial_total_mean         |West Asia vs Europe              | -0.55| 0.646000|ns  |
|mnau_postcranial_total_mean         |West Asia vs Southeast Asia      | -3.37| 0.007560|**  |
|mnau_postcranial_total_mean         |Europe vs Southeast Asia         | -2.75| 0.029700|*   |
|mnau_region_mean_evenness           |West Europe vs Central Europe    | -0.09| 0.927000|ns  |
|mnau_region_mean_evenness           |West Europe vs West Asia         |  2.62| 0.029000|*   |
|mnau_region_mean_evenness           |West Europe vs Europe            |  1.87| 0.087800|ns  |
|mnau_region_mean_evenness           |West Europe vs Southeast Asia    | -2.52| 0.029000|*   |
|mnau_region_mean_evenness           |Central Europe vs West Asia      |  2.21| 0.054900|ns  |
|mnau_region_mean_evenness           |Central Europe vs Europe         |  1.63| 0.130000|ns  |
|mnau_region_mean_evenness           |Central Europe vs Southeast Asia | -2.12| 0.056900|ns  |
|mnau_region_mean_evenness           |West Asia vs Europe              | -0.42| 0.746000|ns  |
|mnau_region_mean_evenness           |West Asia vs Southeast Asia      | -3.72| 0.002020|**  |
|mnau_region_mean_evenness           |Europe vs Southeast Asia         | -3.20| 0.006760|**  |
|mnau_shoulder                       |West Europe vs Central Europe    |  0.75| 0.504000|ns  |
|mnau_shoulder                       |West Europe vs West Asia         |  2.34| 0.050900|ns  |
|mnau_shoulder                       |West Europe vs Europe            |  1.74| 0.136000|ns  |
|mnau_shoulder                       |West Europe vs Southeast Asia    | -2.20| 0.055600|ns  |
|mnau_shoulder                       |Central Europe vs West Asia      |  1.44| 0.213000|ns  |
|mnau_shoulder                       |Central Europe vs Europe         |  1.01| 0.393000|ns  |
|mnau_shoulder                       |Central Europe vs Southeast Asia | -2.32| 0.050900|ns  |
|mnau_shoulder                       |West Asia vs Europe              | -0.33| 0.741000|ns  |
|mnau_shoulder                       |West Asia vs Southeast Asia      | -3.28| 0.010300|*   |
|mnau_shoulder                       |Europe vs Southeast Asia         | -2.87| 0.020500|*   |
|mnau_simpson_dominance              |West Europe vs Central Europe    |  0.18| 0.860000|ns  |
|mnau_simpson_dominance              |West Europe vs West Asia         | -2.15| 0.079300|ns  |
|mnau_simpson_dominance              |West Europe vs Europe            | -1.30| 0.275000|ns  |
|mnau_simpson_dominance              |West Europe vs Southeast Asia    |  2.23| 0.079300|ns  |
|mnau_simpson_dominance              |Central Europe vs West Asia      | -1.88| 0.115000|ns  |
|mnau_simpson_dominance              |Central Europe vs Europe         | -1.20| 0.287000|ns  |
|mnau_simpson_dominance              |Central Europe vs Southeast Asia |  1.82| 0.115000|ns  |
|mnau_simpson_dominance              |West Asia vs Europe              |  0.52| 0.666000|ns  |
|mnau_simpson_dominance              |West Asia vs Southeast Asia      |  3.18| 0.014900|*   |
|mnau_simpson_dominance              |Europe vs Southeast Asia         |  2.59| 0.048100|*   |
|mnau_simpson_evenness               |West Europe vs Central Europe    | -0.18| 0.860000|ns  |
|mnau_simpson_evenness               |West Europe vs West Asia         |  2.15| 0.079300|ns  |
|mnau_simpson_evenness               |West Europe vs Europe            |  1.30| 0.275000|ns  |
|mnau_simpson_evenness               |West Europe vs Southeast Asia    | -2.23| 0.079300|ns  |
|mnau_simpson_evenness               |Central Europe vs West Asia      |  1.88| 0.115000|ns  |
|mnau_simpson_evenness               |Central Europe vs Europe         |  1.20| 0.287000|ns  |
|mnau_simpson_evenness               |Central Europe vs Southeast Asia | -1.82| 0.115000|ns  |
|mnau_simpson_evenness               |West Asia vs Europe              | -0.52| 0.666000|ns  |
|mnau_simpson_evenness               |West Asia vs Southeast Asia      | -3.18| 0.014900|*   |
|mnau_simpson_evenness               |Europe vs Southeast Asia         | -2.59| 0.048100|*   |
|mnau_top2_share_mcnaughton          |West Europe vs Central Europe    |  0.06| 0.954000|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs West Asia         | -2.13| 0.066100|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs Europe            | -1.35| 0.251000|ns  |
|mnau_top2_share_mcnaughton          |West Europe vs Southeast Asia    |  2.83| 0.015600|*   |
|mnau_top2_share_mcnaughton          |Central Europe vs West Asia      | -1.79| 0.123000|ns  |
|mnau_top2_share_mcnaughton          |Central Europe vs Europe         | -1.17| 0.302000|ns  |
|mnau_top2_share_mcnaughton          |Central Europe vs Southeast Asia |  2.40| 0.041100|*   |
|mnau_top2_share_mcnaughton          |West Asia vs Europe              |  0.47| 0.706000|ns  |
|mnau_top2_share_mcnaughton          |West Asia vs Southeast Asia      |  3.63| 0.002810|**  |
|mnau_top2_share_mcnaughton          |Europe vs Southeast Asia         |  3.08| 0.010500|*   |
|mnau_upper_appendicular_mean        |West Europe vs Central Europe    |  0.14| 0.892000|ns  |
|mnau_upper_appendicular_mean        |West Europe vs West Asia         |  2.07| 0.077200|ns  |
|mnau_upper_appendicular_mean        |West Europe vs Europe            |  1.68| 0.153000|ns  |
|mnau_upper_appendicular_mean        |West Europe vs Southeast Asia    | -2.44| 0.048800|*   |
|mnau_upper_appendicular_mean        |Central Europe vs West Asia      |  1.61| 0.153000|ns  |
|mnau_upper_appendicular_mean        |Central Europe vs Europe         |  1.32| 0.232000|ns  |
|mnau_upper_appendicular_mean        |Central Europe vs Southeast Asia | -2.18| 0.073900|ns  |
|mnau_upper_appendicular_mean        |West Asia vs Europe              | -0.19| 0.892000|ns  |
|mnau_upper_appendicular_mean        |West Asia vs Southeast Asia      | -3.29| 0.010200|*   |
|mnau_upper_appendicular_mean        |Europe vs Southeast Asia         | -3.01| 0.013300|*   |
|mne_arms                            |West Europe vs Central Europe    |  0.63| 0.526000|ns  |
|mne_arms                            |West Europe vs West Asia         |  2.08| 0.053600|ns  |
|mne_arms                            |West Europe vs Europe            |  3.68| 0.001180|**  |
|mne_arms                            |West Europe vs Southeast Asia    | -2.22| 0.043600|*   |
|mne_arms                            |Central Europe vs West Asia      |  1.30| 0.215000|ns  |
|mne_arms                            |Central Europe vs Europe         |  2.70| 0.017300|*   |
|mne_arms                            |Central Europe vs Southeast Asia | -2.27| 0.043600|*   |
|mne_arms                            |West Asia vs Europe              |  1.31| 0.215000|ns  |
|mne_arms                            |West Asia vs Southeast Asia      | -3.12| 0.005950|**  |
|mne_arms                            |Europe vs Southeast Asia         | -4.23| 0.000235|*** |
|postcranial_dominance_refined       |West Europe vs Central Europe    | -0.87| 0.424000|ns  |
|postcranial_dominance_refined       |West Europe vs West Asia         | -2.49| 0.039900|*   |
|postcranial_dominance_refined       |West Europe vs Europe            | -1.98| 0.078800|ns  |
|postcranial_dominance_refined       |West Europe vs Southeast Asia    |  2.22| 0.053300|ns  |
|postcranial_dominance_refined       |Central Europe vs West Asia      | -1.34| 0.260000|ns  |
|postcranial_dominance_refined       |Central Europe vs Europe         | -1.01| 0.393000|ns  |
|postcranial_dominance_refined       |Central Europe vs Southeast Asia |  2.41| 0.039900|*   |
|postcranial_dominance_refined       |West Asia vs Europe              |  0.26| 0.798000|ns  |
|postcranial_dominance_refined       |West Asia vs Southeast Asia      |  3.30| 0.009570|**  |
|postcranial_dominance_refined       |Europe vs Southeast Asia         |  3.02| 0.012600|*   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 1.99, R² = 0.069, p = 0.0277.
PCA variance explained: PC1 56.1%, PC2 9.3%, PC3 6.4% (cumulative 71.8%).
Dispersion caveat (PERMDISP): p = 0.109.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.161| -0.138|  0.028|
|mnau_appendicular_mean      | -0.160| -0.136| -0.024|
|mnau_gini                   |  0.159| -0.119|  0.014|
|mnau_top2_share_mcnaughton  |  0.158| -0.140|  0.004|
|mnau_simpson_evenness       | -0.158|  0.107| -0.010|
|mnau_inverse_simpson        | -0.158|  0.107| -0.010|
|effective_sections_hill1    | -0.158|  0.134| -0.010|
|mnau_heip_evenness          | -0.158|  0.134| -0.010|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
