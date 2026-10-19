# Accumulation process
*Automated taphonomic_context × skeletal-part representation*

- **Grouping column:** `taphonomic_context` (mode = single)
- **Groups (n):** Funerary Context = 49; Cannibalism = 25; Sepulchral Cave = 25; Carnivore = 17; Geological transport = 12
- **Sites analysed:** 128  |  **features screened:** 63

## Hypothesis

**H:** Different accumulation causes produce different body-part profiles.

**Expected pattern:** Funerary contexts more anatomically balanced; carnivore/geological transport loses small, fragile, axial, low-density elements; cannibalism shows selective absence/over-representation of processed parts.

**Why it matters:** Strongest hypothesis: accumulation cause is directly linked to skeletal survival, transport and human/carnivore behaviour.


## Summary

59 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_upper_appendicular_mean** (ε² = 0.650, FDR p = 1.575e-15). PERMANOVA pseudo-F = 14.51, p = 0.0001; PC1–PC3 explain 71.6% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 224 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 54 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|mnau_upper_appendicular_mean                 |  0.650| 0.00e+00|large      |significant |
|mnau_appendicular_mean                       |  0.635| 0.00e+00|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.633| 0.00e+00|large      |significant |
|mnau_postcranial_total_mean                  |  0.631| 0.00e+00|large      |significant |
|mnau_gini                                    |  0.620| 0.00e+00|large      |significant |
|low_density_survival_index                   |  0.613| 0.00e+00|large      |significant |
|effective_sections_hill1                     |  0.611| 0.00e+00|large      |significant |
|mnau_heip_evenness                           |  0.611| 0.00e+00|large      |significant |
|mnau_cv                                      |  0.603| 0.00e+00|large      |significant |
|mnau_inverse_simpson                         |  0.602| 0.00e+00|large      |significant |
|mnau_simpson_dominance                       |  0.602| 0.00e+00|large      |significant |
|mnau_simpson_evenness                        |  0.602| 0.00e+00|large      |significant |
|mnau_evenness_minus_dominance                |  0.599| 0.00e+00|large      |significant |
|mnau_proximal_appendicular_mean              |  0.596| 0.00e+00|large      |significant |
|mnau_lower_appendicular_mean                 |  0.595| 0.00e+00|large      |significant |
|mnau_column_trunk_mean                       |  0.583| 0.00e+00|large      |significant |
|lower_appendicular_continuity_hm             |  0.578| 0.00e+00|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.572| 0.00e+00|large      |significant |
|mnau_region_mean_evenness                    |  0.571| 0.00e+00|large      |significant |
|low_density_axial_survival                   |  0.569| 0.00e+00|large      |significant |
|all_sections_dominance                       |  0.569| 0.00e+00|large      |significant |
|mnau_distal_appendicular_mean                |  0.568| 0.00e+00|large      |significant |
|mnau_arms                                    |  0.564| 0.00e+00|large      |significant |
|mnau_girdle_mean                             |  0.550| 0.00e+00|large      |significant |
|mnau_axial_main_mean                         |  0.543| 0.00e+00|large      |significant |
|appendicular_dominance                       |  0.538| 0.00e+00|large      |significant |
|appendicular_dominance_refined               |  0.538| 0.00e+00|large      |significant |
|postcranial_dominance_refined                |  0.537| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_radius              |  0.511| 0.00e+00|large      |significant |
|distal_appendicular_continuity_hm            |  0.509| 0.00e+00|large      |significant |
|mnau_dominance_of_region_means               |  0.509| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_humerus             |  0.504| 0.00e+00|large      |significant |
|mne_arms                                     |  0.501| 0.00e+00|large      |significant |
|density_evenness                             |  0.493| 0.00e+00|large      |significant |
|mnau_shoulder                                |  0.484| 0.00e+00|large      |significant |
|mnau_legs                                    |  0.478| 0.00e+00|large      |significant |
|dominance_gap_all                            |  0.447| 0.00e+00|large      |significant |
|mnau_hands                                   |  0.446| 0.00e+00|large      |significant |
|mnau_pelvic                                  |  0.446| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_fibula              |  0.446| 0.00e+00|large      |significant |
|mnau_foot                                    |  0.433| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.429| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.426| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_clavicle            |  0.426| 0.00e+00|large      |significant |
|ReMNAU_radius                                |  0.397| 0.00e+00|large      |significant |
|low_density_share                            |  0.387| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_tibia               |  0.377| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_cervical            |  0.376| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_carpal              |  0.349| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_femur               |  0.328| 0.00e+00|large      |significant |
|lower_appendicular_evenness                  |  0.322| 1.00e-07|large      |significant |
|lower_appendicular_evenness_refined          |  0.322| 1.00e-07|large      |significant |
|ReMNAU_cervical                              |  0.301| 0.00e+00|large      |significant |
|ReMNAU_ulna                                  |  0.292| 1.00e-07|large      |significant |
|mne_cranial_share                            |  0.262| 3.00e-07|large      |significant |
|dominant_axial_share                         |  0.256| 4.00e-07|large      |significant |
|mnau_arms_legs_logratio                      |  0.061| 2.31e-02|moderate   |significant |
|mnau_arms_to_legs_ratio                      |  0.061| 2.31e-02|moderate   |significant |
|mnau_vertebrae_to_thorax_ratio               |  0.048| 4.55e-02|small      |significant |
|mnau_arms_legs_diff                          |  0.043| 5.72e-02|small      |n.s.        |
|density_adjusted_appendicular_axial_contrast |  0.042| 5.99e-02|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.040| 6.42e-02|small      |n.s.        |
|mne_arms_to_legs_ratio                       | -0.023| 8.78e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                 |     Z|  p (adj)|Sig  |
|:-----------------------------------|:----------------------------------------|-----:|--------:|:----|
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Cannibalism          | -3.54| 1.01e-03|**   |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Sepulchral Cave      | -4.34| 4.75e-05|**** |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Carnivore            | -5.36| 8.00e-07|**** |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Geological transport | -4.68| 1.42e-05|**** |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Sepulchral Cave           | -0.70| 5.40e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Carnivore                 | -2.03| 8.45e-02|ns   |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Geological transport      | -1.82| 1.15e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Sepulchral Cave vs Carnivore             | -1.40| 2.29e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Sepulchral Cave vs Geological transport  | -1.26| 2.61e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Carnivore vs Geological transport        |  0.00| 1.00e+00|ns   |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Cannibalism          | -3.84| 4.10e-04|***  |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Sepulchral Cave      | -3.08| 5.09e-03|**   |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Carnivore            | -5.76| 1.00e-07|**** |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Geological transport | -5.04| 2.40e-06|**** |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Sepulchral Cave           |  0.66| 5.69e-01|ns   |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Carnivore                 | -2.16| 4.41e-02|*    |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Geological transport      | -1.93| 6.67e-02|ns   |
|ProportionalRep_MNIbased_cervical   |Sepulchral Cave vs Carnivore             | -2.75| 1.20e-02|*    |
|ProportionalRep_MNIbased_cervical   |Sepulchral Cave vs Geological transport  | -2.46| 2.31e-02|*    |
|ProportionalRep_MNIbased_cervical   |Carnivore vs Geological transport        |  0.00| 1.00e+00|ns   |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Cannibalism          | -3.89| 2.56e-04|***  |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Sepulchral Cave      | -4.17| 1.04e-04|***  |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Carnivore            | -6.24| 0.00e+00|**** |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Geological transport | -4.98| 3.30e-06|**** |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Sepulchral Cave           | -0.24| 8.07e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Carnivore                 | -2.55| 2.17e-02|*    |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Geological transport      | -1.84| 9.31e-02|ns   |
|ProportionalRep_MNIbased_clavicle   |Sepulchral Cave vs Carnivore             | -2.33| 3.31e-02|*    |
|ProportionalRep_MNIbased_clavicle   |Sepulchral Cave vs Geological transport  | -1.65| 1.24e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Carnivore vs Geological transport        |  0.41| 7.60e-01|ns   |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Cannibalism          | -3.80| 4.76e-04|***  |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Sepulchral Cave      | -3.38| 1.78e-03|**   |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Carnivore            | -4.69| 1.39e-05|**** |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Geological transport | -5.29| 1.20e-06|**** |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Sepulchral Cave           |  0.36| 7.16e-01|ns   |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Carnivore                 | -1.22| 2.77e-01|ns   |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Geological transport      | -2.19| 4.75e-02|*    |
|ProportionalRep_MNIbased_femur      |Sepulchral Cave vs Carnivore             | -1.55| 1.73e-01|ns   |
|ProportionalRep_MNIbased_femur      |Sepulchral Cave vs Geological transport  | -2.48| 2.60e-02|*    |
|ProportionalRep_MNIbased_femur      |Carnivore vs Geological transport        | -1.02| 3.41e-01|ns   |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Cannibalism          | -3.64| 6.69e-04|***  |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Sepulchral Cave      | -3.78| 5.14e-04|***  |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Carnivore            | -6.20| 0.00e+00|**** |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Geological transport | -5.57| 1.00e-07|**** |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Sepulchral Cave           | -0.12| 9.04e-01|ns   |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Carnivore                 | -2.70| 1.39e-02|*    |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Geological transport      | -2.56| 1.49e-02|*    |
|ProportionalRep_MNIbased_fibula     |Sepulchral Cave vs Carnivore             | -2.59| 1.49e-02|*    |
|ProportionalRep_MNIbased_fibula     |Sepulchral Cave vs Geological transport  | -2.46| 1.72e-02|*    |
|ProportionalRep_MNIbased_fibula     |Carnivore vs Geological transport        | -0.14| 9.04e-01|ns   |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Cannibalism          | -3.71| 5.19e-04|***  |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Sepulchral Cave      | -2.89| 5.55e-03|**   |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Carnivore            | -6.77| 0.00e+00|**** |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Geological transport | -5.81| 0.00e+00|**** |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Sepulchral Cave           |  0.71| 5.28e-01|ns   |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Carnivore                 | -3.16| 2.63e-03|**   |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Geological transport      | -2.73| 7.84e-03|**   |
|ProportionalRep_MNIbased_humerus    |Sepulchral Cave vs Carnivore             | -3.80| 4.78e-04|***  |
|ProportionalRep_MNIbased_humerus    |Sepulchral Cave vs Geological transport  | -3.31| 1.87e-03|**   |
|ProportionalRep_MNIbased_humerus    |Carnivore vs Geological transport        |  0.09| 9.30e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Cannibalism          | -4.32| 5.25e-05|**** |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Sepulchral Cave      | -3.53| 1.06e-03|**   |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Carnivore            | -5.96| 0.00e+00|**** |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Geological transport | -5.41| 3.00e-07|**** |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Sepulchral Cave           |  0.69| 5.46e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Carnivore                 | -1.96| 6.57e-02|ns   |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Geological transport      | -1.94| 6.57e-02|ns   |
|ProportionalRep_MNIbased_metacarpal |Sepulchral Cave vs Carnivore             | -2.58| 1.97e-02|*    |
|ProportionalRep_MNIbased_metacarpal |Sepulchral Cave vs Geological transport  | -2.49| 2.11e-02|*    |
|ProportionalRep_MNIbased_metacarpal |Carnivore vs Geological transport        | -0.17| 8.65e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Cannibalism          | -3.97| 1.82e-04|***  |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Sepulchral Cave      | -4.39| 3.72e-05|**** |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Carnivore            | -5.62| 1.00e-07|**** |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Geological transport | -5.58| 1.00e-07|**** |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Sepulchral Cave           | -0.37| 7.12e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Carnivore                 | -1.93| 7.62e-02|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Geological transport      | -2.34| 3.83e-02|*    |
|ProportionalRep_MNIbased_os_coxae   |Sepulchral Cave vs Carnivore             | -1.60| 1.37e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Sepulchral Cave vs Geological transport  | -2.04| 6.81e-02|ns   |
|ProportionalRep_MNIbased_os_coxae   |Carnivore vs Geological transport        | -0.57| 6.31e-01|ns   |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Cannibalism          | -3.67| 6.18e-04|***  |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Sepulchral Cave      | -4.75| 6.80e-06|**** |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Carnivore            | -6.57| 0.00e+00|**** |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Geological transport | -5.74| 0.00e+00|**** |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Sepulchral Cave           | -0.94| 3.84e-01|ns   |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Carnivore                 | -3.02| 5.06e-03|**   |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Geological transport      | -2.70| 1.14e-02|*    |
|ProportionalRep_MNIbased_radius     |Sepulchral Cave vs Carnivore             | -2.17| 4.27e-02|*    |
|ProportionalRep_MNIbased_radius     |Sepulchral Cave vs Geological transport  | -1.94| 6.49e-02|ns   |
|ProportionalRep_MNIbased_radius     |Carnivore vs Geological transport        |  0.00| 1.00e+00|ns   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Cannibalism          | -3.23| 3.13e-03|**   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Sepulchral Cave      | -3.39| 2.31e-03|**   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Carnivore            | -5.71| 1.00e-07|**** |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Geological transport | -5.25| 8.00e-07|**** |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Sepulchral Cave           | -0.14| 8.85e-01|ns   |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Carnivore                 | -2.59| 1.78e-02|*    |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Geological transport      | -2.55| 1.78e-02|*    |
|ProportionalRep_MNIbased_tibia      |Sepulchral Cave vs Carnivore             | -2.46| 1.85e-02|*    |
|ProportionalRep_MNIbased_tibia      |Sepulchral Cave vs Geological transport  | -2.44| 1.85e-02|*    |
|ProportionalRep_MNIbased_tibia      |Carnivore vs Geological transport        | -0.22| 8.85e-01|ns   |
|ReMNAU_cervical                     |Funerary Context vs Cannibalism          | -2.90| 7.39e-03|**   |
|ReMNAU_cervical                     |Funerary Context vs Sepulchral Cave      | -1.75| 9.98e-02|ns   |
|ReMNAU_cervical                     |Funerary Context vs Carnivore            | -5.26| 1.40e-06|**** |
|ReMNAU_cervical                     |Funerary Context vs Geological transport | -4.60| 2.12e-05|**** |
|ReMNAU_cervical                     |Cannibalism vs Sepulchral Cave           |  1.00| 3.52e-01|ns   |
|ReMNAU_cervical                     |Cannibalism vs Carnivore                 | -2.44| 2.43e-02|*    |
|ReMNAU_cervical                     |Cannibalism vs Geological transport      | -2.19| 4.12e-02|*    |
|ReMNAU_cervical                     |Sepulchral Cave vs Carnivore             | -3.34| 2.77e-03|**   |
|ReMNAU_cervical                     |Sepulchral Cave vs Geological transport  | -2.99| 6.93e-03|**   |
|ReMNAU_cervical                     |Carnivore vs Geological transport        |  0.00| 1.00e+00|ns   |
|ReMNAU_radius                       |Funerary Context vs Cannibalism          | -2.15| 3.92e-02|*    |
|ReMNAU_radius                       |Funerary Context vs Sepulchral Cave      | -3.52| 1.10e-03|**   |
|ReMNAU_radius                       |Funerary Context vs Carnivore            | -5.96| 0.00e+00|**** |
|ReMNAU_radius                       |Funerary Context vs Geological transport | -5.21| 1.00e-06|**** |
|ReMNAU_radius                       |Cannibalism vs Sepulchral Cave           | -1.18| 2.63e-01|ns   |
|ReMNAU_radius                       |Cannibalism vs Carnivore                 | -3.65| 8.62e-04|***  |
|ReMNAU_radius                       |Cannibalism vs Geological transport      | -3.27| 2.15e-03|**   |
|ReMNAU_radius                       |Sepulchral Cave vs Carnivore             | -2.59| 1.61e-02|*    |
|ReMNAU_radius                       |Sepulchral Cave vs Geological transport  | -2.32| 2.93e-02|*    |
|ReMNAU_radius                       |Carnivore vs Geological transport        |  0.00| 1.00e+00|ns   |
|ReMNAU_ulna                         |Funerary Context vs Cannibalism          | -2.31| 2.58e-02|*    |
|ReMNAU_ulna                         |Funerary Context vs Sepulchral Cave      | -2.33| 2.58e-02|*    |
|ReMNAU_ulna                         |Funerary Context vs Carnivore            | -5.00| 5.30e-06|**** |
|ReMNAU_ulna                         |Funerary Context vs Geological transport | -4.88| 5.30e-06|**** |
|ReMNAU_ulna                         |Cannibalism vs Sepulchral Cave           | -0.02| 9.86e-01|ns   |
|ReMNAU_ulna                         |Cannibalism vs Carnivore                 | -2.67| 1.33e-02|*    |
|ReMNAU_ulna                         |Cannibalism vs Geological transport      | -2.85| 1.13e-02|*    |
|ReMNAU_ulna                         |Sepulchral Cave vs Carnivore             | -2.65| 1.33e-02|*    |
|ReMNAU_ulna                         |Sepulchral Cave vs Geological transport  | -2.84| 1.13e-02|*    |
|ReMNAU_ulna                         |Carnivore vs Geological transport        | -0.43| 7.39e-01|ns   |
|all_sections_dominance              |Funerary Context vs Cannibalism          |  4.22| 8.18e-05|**** |
|all_sections_dominance              |Funerary Context vs Sepulchral Cave      |  3.29| 1.67e-03|**   |
|all_sections_dominance              |Funerary Context vs Carnivore            |  6.67| 0.00e+00|**** |
|all_sections_dominance              |Funerary Context vs Geological transport |  6.45| 0.00e+00|**** |
|all_sections_dominance              |Cannibalism vs Sepulchral Cave           | -0.81| 4.66e-01|ns   |
|all_sections_dominance              |Cannibalism vs Carnivore                 |  2.85| 5.38e-03|**   |
|all_sections_dominance              |Cannibalism vs Geological transport      |  2.96| 4.42e-03|**   |
|all_sections_dominance              |Sepulchral Cave vs Carnivore             |  3.55| 7.60e-04|***  |
|all_sections_dominance              |Sepulchral Cave vs Geological transport  |  3.61| 7.60e-04|***  |
|all_sections_dominance              |Carnivore vs Geological transport        |  0.27| 7.83e-01|ns   |
|appendicular_dominance              |Funerary Context vs Cannibalism          |  3.04| 4.75e-03|**   |
|appendicular_dominance              |Funerary Context vs Sepulchral Cave      |  4.56| 2.57e-05|**** |
|appendicular_dominance              |Funerary Context vs Carnivore            |  6.66| 0.00e+00|**** |
|appendicular_dominance              |Funerary Context vs Geological transport |  4.15| 1.10e-04|***  |
|appendicular_dominance              |Cannibalism vs Sepulchral Cave           |  1.22| 2.47e-01|ns   |
|appendicular_dominance              |Cannibalism vs Carnivore                 |  3.87| 2.78e-04|***  |
|appendicular_dominance              |Cannibalism vs Geological transport      |  2.57| 1.47e-02|*    |
|appendicular_dominance              |Sepulchral Cave vs Carnivore             |  2.92| 5.91e-03|**   |
|appendicular_dominance              |Sepulchral Cave vs Geological transport  |  1.93| 6.74e-02|ns   |
|appendicular_dominance              |Carnivore vs Geological transport        |  0.02| 9.81e-01|ns   |
|appendicular_dominance_refined      |Funerary Context vs Cannibalism          |  3.04| 4.75e-03|**   |
|appendicular_dominance_refined      |Funerary Context vs Sepulchral Cave      |  4.56| 2.57e-05|**** |
|appendicular_dominance_refined      |Funerary Context vs Carnivore            |  6.66| 0.00e+00|**** |
|appendicular_dominance_refined      |Funerary Context vs Geological transport |  4.15| 1.10e-04|***  |
|appendicular_dominance_refined      |Cannibalism vs Sepulchral Cave           |  1.22| 2.47e-01|ns   |
|appendicular_dominance_refined      |Cannibalism vs Carnivore                 |  3.87| 2.78e-04|***  |
|appendicular_dominance_refined      |Cannibalism vs Geological transport      |  2.57| 1.47e-02|*    |
|appendicular_dominance_refined      |Sepulchral Cave vs Carnivore             |  2.92| 5.91e-03|**   |
|appendicular_dominance_refined      |Sepulchral Cave vs Geological transport  |  1.93| 6.74e-02|ns   |
|appendicular_dominance_refined      |Carnivore vs Geological transport        |  0.02| 9.81e-01|ns   |
|density_evenness                    |Funerary Context vs Cannibalism          | -3.27| 1.80e-03|**   |
|density_evenness                    |Funerary Context vs Sepulchral Cave      | -2.40| 2.03e-02|*    |
|density_evenness                    |Funerary Context vs Carnivore            | -6.37| 0.00e+00|**** |
|density_evenness                    |Funerary Context vs Geological transport | -6.00| 0.00e+00|**** |
|density_evenness                    |Cannibalism vs Sepulchral Cave           |  0.75| 5.02e-01|ns   |
|density_evenness                    |Cannibalism vs Carnivore                 | -3.29| 1.80e-03|**   |
|density_evenness                    |Cannibalism vs Geological transport      | -3.22| 1.86e-03|**   |
|density_evenness                    |Sepulchral Cave vs Carnivore             | -3.95| 2.64e-04|***  |
|density_evenness                    |Sepulchral Cave vs Geological transport  | -3.82| 3.32e-04|***  |
|density_evenness                    |Carnivore vs Geological transport        | -0.14| 8.91e-01|ns   |
|distal_appendicular_continuity_hm   |Funerary Context vs Cannibalism          | -3.02| 3.56e-03|**   |
|distal_appendicular_continuity_hm   |Funerary Context vs Sepulchral Cave      | -2.85| 5.46e-03|**   |
|distal_appendicular_continuity_hm   |Funerary Context vs Carnivore            | -6.43| 0.00e+00|**** |
|distal_appendicular_continuity_hm   |Funerary Context vs Geological transport | -6.34| 0.00e+00|**** |
|distal_appendicular_continuity_hm   |Cannibalism vs Sepulchral Cave           |  0.15| 8.80e-01|ns   |
|distal_appendicular_continuity_hm   |Cannibalism vs Carnivore                 | -3.39| 1.14e-03|**   |
|distal_appendicular_continuity_hm   |Cannibalism vs Geological transport      | -3.70| 5.34e-04|***  |
|distal_appendicular_continuity_hm   |Sepulchral Cave vs Carnivore             | -3.53| 8.27e-04|***  |
|distal_appendicular_continuity_hm   |Sepulchral Cave vs Geological transport  | -3.82| 4.37e-04|***  |
|distal_appendicular_continuity_hm   |Carnivore vs Geological transport        | -0.62| 5.96e-01|ns   |
|dominance_gap_all                   |Funerary Context vs Cannibalism          |  3.74| 5.18e-04|***  |
|dominance_gap_all                   |Funerary Context vs Sepulchral Cave      |  2.27| 2.87e-02|*    |
|dominance_gap_all                   |Funerary Context vs Carnivore            |  5.94| 0.00e+00|**** |
|dominance_gap_all                   |Funerary Context vs Geological transport |  5.75| 0.00e+00|**** |
|dominance_gap_all                   |Cannibalism vs Sepulchral Cave           | -1.27| 2.26e-01|ns   |
|dominance_gap_all                   |Cannibalism vs Carnivore                 |  2.55| 1.53e-02|*    |
|dominance_gap_all                   |Cannibalism vs Geological transport      |  2.65| 1.33e-02|*    |
|dominance_gap_all                   |Sepulchral Cave vs Carnivore             |  3.65| 5.18e-04|***  |
|dominance_gap_all                   |Sepulchral Cave vs Geological transport  |  3.68| 5.18e-04|***  |
|dominance_gap_all                   |Carnivore vs Geological transport        |  0.25| 8.00e-01|ns   |
|dominant_axial_share                |Funerary Context vs Cannibalism          |  3.87| 5.51e-04|***  |
|dominant_axial_share                |Funerary Context vs Sepulchral Cave      |  2.73| 1.29e-02|*    |
|dominant_axial_share                |Funerary Context vs Carnivore            |  2.26| 4.01e-02|*    |
|dominant_axial_share                |Funerary Context vs Geological transport |  5.32| 1.10e-06|**** |
|dominant_axial_share                |Cannibalism vs Sepulchral Cave           | -0.99| 3.57e-01|ns   |
|dominant_axial_share                |Cannibalism vs Carnivore                 | -1.00| 3.57e-01|ns   |
|dominant_axial_share                |Cannibalism vs Geological transport      |  2.17| 4.29e-02|*    |
|dominant_axial_share                |Sepulchral Cave vs Carnivore             | -0.11| 9.12e-01|ns   |
|dominant_axial_share                |Sepulchral Cave vs Geological transport  |  2.97| 9.96e-03|**   |
|dominant_axial_share                |Carnivore vs Geological transport        |  2.86| 1.07e-02|*    |
|effective_sections_hill1            |Funerary Context vs Cannibalism          | -4.14| 1.15e-04|***  |
|effective_sections_hill1            |Funerary Context vs Sepulchral Cave      | -3.62| 6.49e-04|***  |
|effective_sections_hill1            |Funerary Context vs Carnivore            | -6.94| 0.00e+00|**** |
|effective_sections_hill1            |Funerary Context vs Geological transport | -6.68| 0.00e+00|**** |
|effective_sections_hill1            |Cannibalism vs Sepulchral Cave           |  0.45| 7.25e-01|ns   |
|effective_sections_hill1            |Cannibalism vs Carnivore                 | -3.15| 2.01e-03|**   |
|effective_sections_hill1            |Cannibalism vs Geological transport      | -3.23| 1.75e-03|**   |
|effective_sections_hill1            |Sepulchral Cave vs Carnivore             | -3.54| 6.58e-04|***  |
|effective_sections_hill1            |Sepulchral Cave vs Geological transport  | -3.59| 6.49e-04|***  |
|effective_sections_hill1            |Carnivore vs Geological transport        | -0.27| 7.86e-01|ns   |
|low_density_axial_survival          |Funerary Context vs Cannibalism          | -3.99| 2.19e-04|***  |
|low_density_axial_survival          |Funerary Context vs Sepulchral Cave      | -3.04| 3.33e-03|**   |
|low_density_axial_survival          |Funerary Context vs Carnivore            | -7.03| 0.00e+00|**** |
|low_density_axial_survival          |Funerary Context vs Geological transport | -6.30| 0.00e+00|**** |
|low_density_axial_survival          |Cannibalism vs Sepulchral Cave           |  0.82| 4.57e-01|ns   |
|low_density_axial_survival          |Cannibalism vs Carnivore                 | -3.18| 2.50e-03|**   |
|low_density_axial_survival          |Cannibalism vs Geological transport      | -2.98| 3.58e-03|**   |
|low_density_axial_survival          |Sepulchral Cave vs Carnivore             | -3.92| 2.26e-04|***  |
|low_density_axial_survival          |Sepulchral Cave vs Geological transport  | -3.64| 5.36e-04|***  |
|low_density_axial_survival          |Carnivore vs Geological transport        | -0.13| 8.96e-01|ns   |
|low_density_share                   |Funerary Context vs Cannibalism          | -2.77| 8.05e-03|**   |
|low_density_share                   |Funerary Context vs Sepulchral Cave      | -1.81| 8.82e-02|ns   |
|low_density_share                   |Funerary Context vs Carnivore            | -5.64| 2.00e-07|**** |
|low_density_share                   |Funerary Context vs Geological transport | -5.37| 4.00e-07|**** |
|low_density_share                   |Cannibalism vs Sepulchral Cave           |  0.83| 4.49e-01|ns   |
|low_density_share                   |Cannibalism vs Carnivore                 | -3.02| 4.62e-03|**   |
|low_density_share                   |Cannibalism vs Geological transport      | -2.99| 4.62e-03|**   |
|low_density_share                   |Sepulchral Cave vs Carnivore             | -3.74| 6.17e-04|***  |
|low_density_share                   |Sepulchral Cave vs Geological transport  | -3.66| 6.20e-04|***  |
|low_density_share                   |Carnivore vs Geological transport        | -0.17| 8.65e-01|ns   |
|low_density_survival_index          |Funerary Context vs Cannibalism          | -4.12| 1.27e-04|***  |
|low_density_survival_index          |Funerary Context vs Sepulchral Cave      | -3.85| 2.98e-04|***  |
|low_density_survival_index          |Funerary Context vs Carnivore            | -7.37| 0.00e+00|**** |
|low_density_survival_index          |Funerary Context vs Geological transport | -6.41| 0.00e+00|**** |
|low_density_survival_index          |Cannibalism vs Sepulchral Cave           |  0.24| 9.04e-01|ns   |
|low_density_survival_index          |Cannibalism vs Carnivore                 | -3.37| 1.23e-03|**   |
|low_density_survival_index          |Cannibalism vs Geological transport      | -3.00| 3.40e-03|**   |
|low_density_survival_index          |Sepulchral Cave vs Carnivore             | -3.59| 6.69e-04|***  |
|low_density_survival_index          |Sepulchral Cave vs Geological transport  | -3.19| 2.05e-03|**   |
|low_density_survival_index          |Carnivore vs Geological transport        |  0.02| 9.83e-01|ns   |
|lower_appendicular_continuity_hm    |Funerary Context vs Cannibalism          | -3.39| 1.07e-03|**   |
|lower_appendicular_continuity_hm    |Funerary Context vs Sepulchral Cave      | -3.90| 3.17e-04|***  |
|lower_appendicular_continuity_hm    |Funerary Context vs Carnivore            | -6.72| 0.00e+00|**** |
|lower_appendicular_continuity_hm    |Funerary Context vs Geological transport | -6.76| 0.00e+00|**** |
|lower_appendicular_continuity_hm    |Cannibalism vs Sepulchral Cave           | -0.44| 6.58e-01|ns   |
|lower_appendicular_continuity_hm    |Cannibalism vs Carnivore                 | -3.37| 1.07e-03|**   |
|lower_appendicular_continuity_hm    |Cannibalism vs Geological transport      | -3.83| 3.17e-04|***  |
|lower_appendicular_continuity_hm    |Sepulchral Cave vs Carnivore             | -2.97| 3.70e-03|**   |
|lower_appendicular_continuity_hm    |Sepulchral Cave vs Geological transport  | -3.48| 1.02e-03|**   |
|lower_appendicular_continuity_hm    |Carnivore vs Geological transport        | -0.76| 4.97e-01|ns   |
|lower_appendicular_evenness         |Funerary Context vs Cannibalism          | -2.31| 4.21e-02|*    |
|lower_appendicular_evenness         |Funerary Context vs Sepulchral Cave      | -3.76| 8.52e-04|***  |
|lower_appendicular_evenness         |Funerary Context vs Carnivore            | -4.94| 7.80e-06|**** |
|lower_appendicular_evenness         |Funerary Context vs Geological transport | -3.29| 3.35e-03|**   |
|lower_appendicular_evenness         |Cannibalism vs Sepulchral Cave           | -1.18| 2.64e-01|ns   |
|lower_appendicular_evenness         |Cannibalism vs Carnivore                 | -2.99| 7.06e-03|**   |
|lower_appendicular_evenness         |Cannibalism vs Geological transport      | -2.24| 4.21e-02|*    |
|lower_appendicular_evenness         |Sepulchral Cave vs Carnivore             | -2.11| 4.97e-02|*    |
|lower_appendicular_evenness         |Sepulchral Cave vs Geological transport  | -1.69| 1.14e-01|ns   |
|lower_appendicular_evenness         |Carnivore vs Geological transport        | -0.37| 7.13e-01|ns   |
|lower_appendicular_evenness_refined |Funerary Context vs Cannibalism          | -2.31| 4.21e-02|*    |
|lower_appendicular_evenness_refined |Funerary Context vs Sepulchral Cave      | -3.76| 8.52e-04|***  |
|lower_appendicular_evenness_refined |Funerary Context vs Carnivore            | -4.94| 7.80e-06|**** |
|lower_appendicular_evenness_refined |Funerary Context vs Geological transport | -3.29| 3.35e-03|**   |
|lower_appendicular_evenness_refined |Cannibalism vs Sepulchral Cave           | -1.18| 2.64e-01|ns   |
|lower_appendicular_evenness_refined |Cannibalism vs Carnivore                 | -2.99| 7.06e-03|**   |
|lower_appendicular_evenness_refined |Cannibalism vs Geological transport      | -2.24| 4.21e-02|*    |
|lower_appendicular_evenness_refined |Sepulchral Cave vs Carnivore             | -2.11| 4.97e-02|*    |
|lower_appendicular_evenness_refined |Sepulchral Cave vs Geological transport  | -1.69| 1.14e-01|ns   |
|lower_appendicular_evenness_refined |Carnivore vs Geological transport        | -0.37| 7.13e-01|ns   |
|mnau_appendicular_mean              |Funerary Context vs Cannibalism          | -4.87| 3.70e-06|**** |
|mnau_appendicular_mean              |Funerary Context vs Sepulchral Cave      | -4.06| 1.24e-04|***  |
|mnau_appendicular_mean              |Funerary Context vs Carnivore            | -7.04| 0.00e+00|**** |
|mnau_appendicular_mean              |Funerary Context vs Geological transport | -6.81| 0.00e+00|**** |
|mnau_appendicular_mean              |Cannibalism vs Sepulchral Cave           |  0.71| 5.34e-01|ns   |
|mnau_appendicular_mean              |Cannibalism vs Carnivore                 | -2.50| 1.56e-02|*    |
|mnau_appendicular_mean              |Cannibalism vs Geological transport      | -2.83| 6.55e-03|**   |
|mnau_appendicular_mean              |Sepulchral Cave vs Carnivore             | -3.13| 2.88e-03|**   |
|mnau_appendicular_mean              |Sepulchral Cave vs Geological transport  | -3.40| 1.33e-03|**   |
|mnau_appendicular_mean              |Carnivore vs Geological transport        | -0.56| 5.77e-01|ns   |
|mnau_arms                           |Funerary Context vs Cannibalism          | -3.85| 3.94e-04|***  |
|mnau_arms                           |Funerary Context vs Sepulchral Cave      | -3.38| 1.26e-03|**   |
|mnau_arms                           |Funerary Context vs Carnivore            | -7.08| 0.00e+00|**** |
|mnau_arms                           |Funerary Context vs Geological transport | -6.21| 0.00e+00|**** |
|mnau_arms                           |Cannibalism vs Sepulchral Cave           |  0.41| 7.61e-01|ns   |
|mnau_arms                           |Cannibalism vs Carnivore                 | -3.33| 1.26e-03|**   |
|mnau_arms                           |Cannibalism vs Geological transport      | -3.00| 3.38e-03|**   |
|mnau_arms                           |Sepulchral Cave vs Carnivore             | -3.69| 5.50e-04|***  |
|mnau_arms                           |Sepulchral Cave vs Geological transport  | -3.33| 1.26e-03|**   |
|mnau_arms                           |Carnivore vs Geological transport        | -0.02| 9.86e-01|ns   |
|mnau_arms_legs_logratio             |Funerary Context vs Cannibalism          | -0.44| 8.64e-01|ns   |
|mnau_arms_legs_logratio             |Funerary Context vs Sepulchral Cave      | -0.40| 8.64e-01|ns   |
|mnau_arms_legs_logratio             |Funerary Context vs Carnivore            | -2.78| 5.36e-02|ns   |
|mnau_arms_legs_logratio             |Funerary Context vs Geological transport | -2.25| 7.92e-02|ns   |
|mnau_arms_legs_logratio             |Cannibalism vs Sepulchral Cave           |  0.04| 9.69e-01|ns   |
|mnau_arms_legs_logratio             |Cannibalism vs Carnivore                 | -2.15| 7.92e-02|ns   |
|mnau_arms_legs_logratio             |Cannibalism vs Geological transport      | -1.76| 1.32e-01|ns   |
|mnau_arms_legs_logratio             |Sepulchral Cave vs Carnivore             | -2.18| 7.92e-02|ns   |
|mnau_arms_legs_logratio             |Sepulchral Cave vs Geological transport  | -1.79| 1.32e-01|ns   |
|mnau_arms_legs_logratio             |Carnivore vs Geological transport        |  0.15| 9.69e-01|ns   |
|mnau_arms_to_legs_ratio             |Funerary Context vs Cannibalism          | -0.44| 8.64e-01|ns   |
|mnau_arms_to_legs_ratio             |Funerary Context vs Sepulchral Cave      | -0.40| 8.64e-01|ns   |
|mnau_arms_to_legs_ratio             |Funerary Context vs Carnivore            | -2.78| 5.36e-02|ns   |
|mnau_arms_to_legs_ratio             |Funerary Context vs Geological transport | -2.25| 7.92e-02|ns   |
|mnau_arms_to_legs_ratio             |Cannibalism vs Sepulchral Cave           |  0.04| 9.69e-01|ns   |
|mnau_arms_to_legs_ratio             |Cannibalism vs Carnivore                 | -2.15| 7.92e-02|ns   |
|mnau_arms_to_legs_ratio             |Cannibalism vs Geological transport      | -1.76| 1.32e-01|ns   |
|mnau_arms_to_legs_ratio             |Sepulchral Cave vs Carnivore             | -2.18| 7.92e-02|ns   |
|mnau_arms_to_legs_ratio             |Sepulchral Cave vs Geological transport  | -1.79| 1.32e-01|ns   |
|mnau_arms_to_legs_ratio             |Carnivore vs Geological transport        |  0.15| 9.69e-01|ns   |
|mnau_axial_main_mean                |Funerary Context vs Cannibalism          | -3.73| 3.81e-04|***  |
|mnau_axial_main_mean                |Funerary Context vs Sepulchral Cave      | -2.69| 8.99e-03|**   |
|mnau_axial_main_mean                |Funerary Context vs Carnivore            | -6.88| 0.00e+00|**** |
|mnau_axial_main_mean                |Funerary Context vs Geological transport | -6.18| 0.00e+00|**** |
|mnau_axial_main_mean                |Cannibalism vs Sepulchral Cave           |  0.91| 4.05e-01|ns   |
|mnau_axial_main_mean                |Cannibalism vs Carnivore                 | -3.24| 1.96e-03|**   |
|mnau_axial_main_mean                |Cannibalism vs Geological transport      | -3.05| 3.24e-03|**   |
|mnau_axial_main_mean                |Sepulchral Cave vs Carnivore             | -4.06| 1.63e-04|***  |
|mnau_axial_main_mean                |Sepulchral Cave vs Geological transport  | -3.78| 3.81e-04|***  |
|mnau_axial_main_mean                |Carnivore vs Geological transport        | -0.14| 8.90e-01|ns   |
|mnau_column_trunk_mean              |Funerary Context vs Cannibalism          | -4.13| 1.20e-04|***  |
|mnau_column_trunk_mean              |Funerary Context vs Sepulchral Cave      | -3.49| 8.59e-04|***  |
|mnau_column_trunk_mean              |Funerary Context vs Carnivore            | -6.93| 0.00e+00|**** |
|mnau_column_trunk_mean              |Funerary Context vs Geological transport | -6.56| 0.00e+00|**** |
|mnau_column_trunk_mean              |Cannibalism vs Sepulchral Cave           |  0.56| 6.42e-01|ns   |
|mnau_column_trunk_mean              |Cannibalism vs Carnivore                 | -2.97| 3.69e-03|**   |
|mnau_column_trunk_mean              |Cannibalism vs Geological transport      | -3.12| 2.56e-03|**   |
|mnau_column_trunk_mean              |Sepulchral Cave vs Carnivore             | -3.47| 8.59e-04|***  |
|mnau_column_trunk_mean              |Sepulchral Cave vs Geological transport  | -3.57| 8.59e-04|***  |
|mnau_column_trunk_mean              |Carnivore vs Geological transport        | -0.43| 6.67e-01|ns   |
|mnau_cv                             |Funerary Context vs Cannibalism          |  4.42| 3.31e-05|**** |
|mnau_cv                             |Funerary Context vs Sepulchral Cave      |  3.58| 7.45e-04|***  |
|mnau_cv                             |Funerary Context vs Carnivore            |  6.92| 0.00e+00|**** |
|mnau_cv                             |Funerary Context vs Geological transport |  6.52| 0.00e+00|**** |
|mnau_cv                             |Cannibalism vs Sepulchral Cave           | -0.73| 5.18e-01|ns   |
|mnau_cv                             |Cannibalism vs Carnivore                 |  2.93| 4.81e-03|**   |
|mnau_cv                             |Cannibalism vs Geological transport      |  2.89| 4.81e-03|**   |
|mnau_cv                             |Sepulchral Cave vs Carnivore             |  3.56| 7.45e-04|***  |
|mnau_cv                             |Sepulchral Cave vs Geological transport  |  3.48| 8.44e-04|***  |
|mnau_cv                             |Carnivore vs Geological transport        |  0.15| 8.79e-01|ns   |
|mnau_distal_appendicular_mean       |Funerary Context vs Cannibalism          | -4.07| 1.56e-04|***  |
|mnau_distal_appendicular_mean       |Funerary Context vs Sepulchral Cave      | -3.08| 2.96e-03|**   |
|mnau_distal_appendicular_mean       |Funerary Context vs Carnivore            | -6.74| 0.00e+00|**** |
|mnau_distal_appendicular_mean       |Funerary Context vs Geological transport | -6.59| 0.00e+00|**** |
|mnau_distal_appendicular_mean       |Cannibalism vs Sepulchral Cave           |  0.86| 4.32e-01|ns   |
|mnau_distal_appendicular_mean       |Cannibalism vs Carnivore                 | -2.85| 5.42e-03|**   |
|mnau_distal_appendicular_mean       |Cannibalism vs Geological transport      | -3.20| 2.30e-03|**   |
|mnau_distal_appendicular_mean       |Sepulchral Cave vs Carnivore             | -3.63| 5.72e-04|***  |
|mnau_distal_appendicular_mean       |Sepulchral Cave vs Geological transport  | -3.89| 2.48e-04|***  |
|mnau_distal_appendicular_mean       |Carnivore vs Geological transport        | -0.60| 5.48e-01|ns   |
|mnau_dominance_of_region_means      |Funerary Context vs Cannibalism          |  4.24| 7.37e-05|**** |
|mnau_dominance_of_region_means      |Funerary Context vs Sepulchral Cave      |  3.34| 1.67e-03|**   |
|mnau_dominance_of_region_means      |Funerary Context vs Carnivore            |  5.68| 1.00e-07|**** |
|mnau_dominance_of_region_means      |Funerary Context vs Geological transport |  6.62| 0.00e+00|**** |
|mnau_dominance_of_region_means      |Cannibalism vs Sepulchral Cave           | -0.78| 4.34e-01|ns   |
|mnau_dominance_of_region_means      |Cannibalism vs Carnivore                 |  1.94| 6.57e-02|ns   |
|mnau_dominance_of_region_means      |Cannibalism vs Geological transport      |  3.11| 3.16e-03|**   |
|mnau_dominance_of_region_means      |Sepulchral Cave vs Carnivore             |  2.62| 1.27e-02|*    |
|mnau_dominance_of_region_means      |Sepulchral Cave vs Geological transport  |  3.74| 4.67e-04|***  |
|mnau_dominance_of_region_means      |Carnivore vs Geological transport        |  1.18| 2.64e-01|ns   |
|mnau_evenness_minus_dominance       |Funerary Context vs Cannibalism          | -4.30| 5.77e-05|**** |
|mnau_evenness_minus_dominance       |Funerary Context vs Sepulchral Cave      | -3.52| 7.18e-04|***  |
|mnau_evenness_minus_dominance       |Funerary Context vs Carnivore            | -6.87| 0.00e+00|**** |
|mnau_evenness_minus_dominance       |Funerary Context vs Geological transport | -6.57| 0.00e+00|**** |
|mnau_evenness_minus_dominance       |Cannibalism vs Sepulchral Cave           |  0.67| 5.55e-01|ns   |
|mnau_evenness_minus_dominance       |Cannibalism vs Carnivore                 | -2.97| 3.72e-03|**   |
|mnau_evenness_minus_dominance       |Cannibalism vs Geological transport      | -3.02| 3.58e-03|**   |
|mnau_evenness_minus_dominance       |Sepulchral Cave vs Carnivore             | -3.55| 7.18e-04|***  |
|mnau_evenness_minus_dominance       |Sepulchral Cave vs Geological transport  | -3.57| 7.18e-04|***  |
|mnau_evenness_minus_dominance       |Carnivore vs Geological transport        | -0.24| 8.13e-01|ns   |
|mnau_foot                           |Funerary Context vs Cannibalism          | -3.45| 1.88e-03|**   |
|mnau_foot                           |Funerary Context vs Sepulchral Cave      | -2.89| 5.69e-03|**   |
|mnau_foot                           |Funerary Context vs Carnivore            | -6.00| 0.00e+00|**** |
|mnau_foot                           |Funerary Context vs Geological transport | -5.77| 0.00e+00|**** |
|mnau_foot                           |Cannibalism vs Sepulchral Cave           |  0.49| 6.54e-01|ns   |
|mnau_foot                           |Cannibalism vs Carnivore                 | -2.68| 9.24e-03|**   |
|mnau_foot                           |Cannibalism vs Geological transport      | -2.88| 5.69e-03|**   |
|mnau_foot                           |Sepulchral Cave vs Carnivore             | -3.12| 3.64e-03|**   |
|mnau_foot                           |Sepulchral Cave vs Geological transport  | -3.27| 2.66e-03|**   |
|mnau_foot                           |Carnivore vs Geological transport        | -0.45| 6.54e-01|ns   |
|mnau_gini                           |Funerary Context vs Cannibalism          |  4.18| 9.80e-05|**** |
|mnau_gini                           |Funerary Context vs Sepulchral Cave      |  3.75| 4.42e-04|***  |
|mnau_gini                           |Funerary Context vs Carnivore            |  6.99| 0.00e+00|**** |
|mnau_gini                           |Funerary Context vs Geological transport |  6.70| 0.00e+00|**** |
|mnau_gini                           |Cannibalism vs Sepulchral Cave           | -0.37| 7.89e-01|ns   |
|mnau_gini                           |Cannibalism vs Carnivore                 |  3.17| 1.89e-03|**   |
|mnau_gini                           |Cannibalism vs Geological transport      |  3.22| 1.82e-03|**   |
|mnau_gini                           |Sepulchral Cave vs Carnivore             |  3.49| 7.90e-04|***  |
|mnau_gini                           |Sepulchral Cave vs Geological transport  |  3.52| 7.90e-04|***  |
|mnau_gini                           |Carnivore vs Geological transport        |  0.25| 8.06e-01|ns   |
|mnau_girdle_mean                    |Funerary Context vs Cannibalism          | -4.21| 6.33e-05|**** |
|mnau_girdle_mean                    |Funerary Context vs Sepulchral Cave      | -4.59| 1.47e-05|**** |
|mnau_girdle_mean                    |Funerary Context vs Carnivore            | -6.72| 0.00e+00|**** |
|mnau_girdle_mean                    |Funerary Context vs Geological transport | -6.11| 0.00e+00|**** |
|mnau_girdle_mean                    |Cannibalism vs Sepulchral Cave           | -0.33| 8.24e-01|ns   |
|mnau_girdle_mean                    |Cannibalism vs Carnivore                 | -2.72| 1.30e-02|*    |
|mnau_girdle_mean                    |Cannibalism vs Geological transport      | -2.66| 1.30e-02|*    |
|mnau_girdle_mean                    |Sepulchral Cave vs Carnivore             | -2.42| 2.08e-02|*    |
|mnau_girdle_mean                    |Sepulchral Cave vs Geological transport  | -2.39| 2.08e-02|*    |
|mnau_girdle_mean                    |Carnivore vs Geological transport        | -0.21| 8.35e-01|ns   |
|mnau_hands                          |Funerary Context vs Cannibalism          | -3.46| 1.80e-03|**   |
|mnau_hands                          |Funerary Context vs Sepulchral Cave      | -3.08| 3.67e-03|**   |
|mnau_hands                          |Funerary Context vs Carnivore            | -6.11| 0.00e+00|**** |
|mnau_hands                          |Funerary Context vs Geological transport | -5.82| 0.00e+00|**** |
|mnau_hands                          |Cannibalism vs Sepulchral Cave           |  0.33| 7.44e-01|ns   |
|mnau_hands                          |Cannibalism vs Carnivore                 | -2.77| 7.06e-03|**   |
|mnau_hands                          |Cannibalism vs Geological transport      | -2.92| 5.07e-03|**   |
|mnau_hands                          |Sepulchral Cave vs Carnivore             | -3.06| 3.67e-03|**   |
|mnau_hands                          |Sepulchral Cave vs Geological transport  | -3.18| 3.67e-03|**   |
|mnau_hands                          |Carnivore vs Geological transport        | -0.41| 7.44e-01|ns   |
|mnau_heip_evenness                  |Funerary Context vs Cannibalism          | -4.14| 1.15e-04|***  |
|mnau_heip_evenness                  |Funerary Context vs Sepulchral Cave      | -3.62| 6.49e-04|***  |
|mnau_heip_evenness                  |Funerary Context vs Carnivore            | -6.94| 0.00e+00|**** |
|mnau_heip_evenness                  |Funerary Context vs Geological transport | -6.68| 0.00e+00|**** |
|mnau_heip_evenness                  |Cannibalism vs Sepulchral Cave           |  0.45| 7.25e-01|ns   |
|mnau_heip_evenness                  |Cannibalism vs Carnivore                 | -3.15| 2.01e-03|**   |
|mnau_heip_evenness                  |Cannibalism vs Geological transport      | -3.23| 1.75e-03|**   |
|mnau_heip_evenness                  |Sepulchral Cave vs Carnivore             | -3.54| 6.58e-04|***  |
|mnau_heip_evenness                  |Sepulchral Cave vs Geological transport  | -3.59| 6.49e-04|***  |
|mnau_heip_evenness                  |Carnivore vs Geological transport        | -0.27| 7.86e-01|ns   |
|mnau_inverse_simpson                |Funerary Context vs Cannibalism          | -4.43| 3.15e-05|**** |
|mnau_inverse_simpson                |Funerary Context vs Sepulchral Cave      | -3.58| 7.63e-04|***  |
|mnau_inverse_simpson                |Funerary Context vs Carnivore            | -6.86| 0.00e+00|**** |
|mnau_inverse_simpson                |Funerary Context vs Geological transport | -6.58| 0.00e+00|**** |
|mnau_inverse_simpson                |Cannibalism vs Sepulchral Cave           |  0.74| 5.12e-01|ns   |
|mnau_inverse_simpson                |Cannibalism vs Carnivore                 | -2.87| 5.19e-03|**   |
|mnau_inverse_simpson                |Cannibalism vs Geological transport      | -2.94| 4.73e-03|**   |
|mnau_inverse_simpson                |Sepulchral Cave vs Carnivore             | -3.50| 7.63e-04|***  |
|mnau_inverse_simpson                |Sepulchral Cave vs Geological transport  | -3.53| 7.63e-04|***  |
|mnau_inverse_simpson                |Carnivore vs Geological transport        | -0.25| 8.05e-01|ns   |
|mnau_legs                           |Funerary Context vs Cannibalism          | -4.20| 8.95e-05|**** |
|mnau_legs                           |Funerary Context vs Sepulchral Cave      | -3.74| 4.55e-04|***  |
|mnau_legs                           |Funerary Context vs Carnivore            | -5.99| 0.00e+00|**** |
|mnau_legs                           |Funerary Context vs Geological transport | -6.12| 0.00e+00|**** |
|mnau_legs                           |Cannibalism vs Sepulchral Cave           |  0.40| 6.92e-01|ns   |
|mnau_legs                           |Cannibalism vs Carnivore                 | -2.08| 4.69e-02|*    |
|mnau_legs                           |Cannibalism vs Geological transport      | -2.67| 1.25e-02|*    |
|mnau_legs                           |Sepulchral Cave vs Carnivore             | -2.44| 2.12e-02|*    |
|mnau_legs                           |Sepulchral Cave vs Geological transport  | -2.99| 5.52e-03|**   |
|mnau_legs                           |Carnivore vs Geological transport        | -0.76| 4.99e-01|ns   |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Cannibalism          | -4.41| 3.44e-05|**** |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Sepulchral Cave      | -3.67| 6.08e-04|***  |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Carnivore            | -6.75| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Geological transport | -6.52| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Sepulchral Cave           |  0.64| 5.77e-01|ns   |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Carnivore                 | -2.60| 1.18e-02|*    |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Geological transport      | -2.89| 5.50e-03|**   |
|mnau_limb_shaft_proxy_mean          |Sepulchral Cave vs Carnivore             | -3.18| 2.49e-03|**   |
|mnau_limb_shaft_proxy_mean          |Sepulchral Cave vs Geological transport  | -3.41| 1.30e-03|**   |
|mnau_limb_shaft_proxy_mean          |Carnivore vs Geological transport        | -0.53| 5.98e-01|ns   |
|mnau_lower_appendicular_mean        |Funerary Context vs Cannibalism          | -4.82| 4.80e-06|**** |
|mnau_lower_appendicular_mean        |Funerary Context vs Sepulchral Cave      | -3.90| 2.36e-04|***  |
|mnau_lower_appendicular_mean        |Funerary Context vs Carnivore            | -6.60| 0.00e+00|**** |
|mnau_lower_appendicular_mean        |Funerary Context vs Geological transport | -6.79| 0.00e+00|**** |
|mnau_lower_appendicular_mean        |Cannibalism vs Sepulchral Cave           |  0.79| 4.27e-01|ns   |
|mnau_lower_appendicular_mean        |Cannibalism vs Carnivore                 | -2.14| 4.03e-02|*    |
|mnau_lower_appendicular_mean        |Cannibalism vs Geological transport      | -2.86| 6.13e-03|**   |
|mnau_lower_appendicular_mean        |Sepulchral Cave vs Carnivore             | -2.86| 6.13e-03|**   |
|mnau_lower_appendicular_mean        |Sepulchral Cave vs Geological transport  | -3.50| 9.41e-04|***  |
|mnau_lower_appendicular_mean        |Carnivore vs Geological transport        | -0.88| 4.23e-01|ns   |
|mnau_pelvic                         |Funerary Context vs Cannibalism          | -3.98| 1.76e-04|***  |
|mnau_pelvic                         |Funerary Context vs Sepulchral Cave      | -4.42| 3.26e-05|**** |
|mnau_pelvic                         |Funerary Context vs Carnivore            | -5.77| 1.00e-07|**** |
|mnau_pelvic                         |Funerary Context vs Geological transport | -5.72| 1.00e-07|**** |
|mnau_pelvic                         |Cannibalism vs Sepulchral Cave           | -0.39| 6.98e-01|ns   |
|mnau_pelvic                         |Cannibalism vs Carnivore                 | -2.06| 5.60e-02|ns   |
|mnau_pelvic                         |Cannibalism vs Geological transport      | -2.46| 2.76e-02|*    |
|mnau_pelvic                         |Sepulchral Cave vs Carnivore             | -1.71| 1.08e-01|ns   |
|mnau_pelvic                         |Sepulchral Cave vs Geological transport  | -2.15| 5.26e-02|ns   |
|mnau_pelvic                         |Carnivore vs Geological transport        | -0.57| 6.28e-01|ns   |
|mnau_postcranial_total_mean         |Funerary Context vs Cannibalism          | -4.78| 5.90e-06|**** |
|mnau_postcranial_total_mean         |Funerary Context vs Sepulchral Cave      | -3.85| 2.94e-04|***  |
|mnau_postcranial_total_mean         |Funerary Context vs Carnivore            | -7.05| 0.00e+00|**** |
|mnau_postcranial_total_mean         |Funerary Context vs Geological transport | -6.81| 0.00e+00|**** |
|mnau_postcranial_total_mean         |Cannibalism vs Sepulchral Cave           |  0.81| 4.68e-01|ns   |
|mnau_postcranial_total_mean         |Cannibalism vs Carnivore                 | -2.58| 1.23e-02|*    |
|mnau_postcranial_total_mean         |Cannibalism vs Geological transport      | -2.90| 5.37e-03|**   |
|mnau_postcranial_total_mean         |Sepulchral Cave vs Carnivore             | -3.31| 1.58e-03|**   |
|mnau_postcranial_total_mean         |Sepulchral Cave vs Geological transport  | -3.55| 7.81e-04|***  |
|mnau_postcranial_total_mean         |Carnivore vs Geological transport        | -0.55| 5.84e-01|ns   |
|mnau_proximal_appendicular_mean     |Funerary Context vs Cannibalism          | -4.64| 1.18e-05|**** |
|mnau_proximal_appendicular_mean     |Funerary Context vs Sepulchral Cave      | -4.09| 1.09e-04|***  |
|mnau_proximal_appendicular_mean     |Funerary Context vs Carnivore            | -6.92| 0.00e+00|**** |
|mnau_proximal_appendicular_mean     |Funerary Context vs Geological transport | -6.52| 0.00e+00|**** |
|mnau_proximal_appendicular_mean     |Cannibalism vs Sepulchral Cave           |  0.48| 6.84e-01|ns   |
|mnau_proximal_appendicular_mean     |Cannibalism vs Carnivore                 | -2.57| 1.27e-02|*    |
|mnau_proximal_appendicular_mean     |Cannibalism vs Geological transport      | -2.74| 8.86e-03|**   |
|mnau_proximal_appendicular_mean     |Sepulchral Cave vs Carnivore             | -3.00| 4.51e-03|**   |
|mnau_proximal_appendicular_mean     |Sepulchral Cave vs Geological transport  | -3.12| 3.60e-03|**   |
|mnau_proximal_appendicular_mean     |Carnivore vs Geological transport        | -0.41| 6.84e-01|ns   |
|mnau_region_mean_evenness           |Funerary Context vs Cannibalism          | -4.18| 9.91e-05|**** |
|mnau_region_mean_evenness           |Funerary Context vs Sepulchral Cave      | -3.40| 1.35e-03|**   |
|mnau_region_mean_evenness           |Funerary Context vs Carnivore            | -6.38| 0.00e+00|**** |
|mnau_region_mean_evenness           |Funerary Context vs Geological transport | -6.77| 0.00e+00|**** |
|mnau_region_mean_evenness           |Cannibalism vs Sepulchral Cave           |  0.67| 5.00e-01|ns   |
|mnau_region_mean_evenness           |Cannibalism vs Carnivore                 | -2.62| 1.10e-02|*    |
|mnau_region_mean_evenness           |Cannibalism vs Geological transport      | -3.29| 1.70e-03|**   |
|mnau_region_mean_evenness           |Sepulchral Cave vs Carnivore             | -3.20| 1.95e-03|**   |
|mnau_region_mean_evenness           |Sepulchral Cave vs Geological transport  | -3.83| 3.22e-04|***  |
|mnau_region_mean_evenness           |Carnivore vs Geological transport        | -0.77| 4.90e-01|ns   |
|mnau_shoulder                       |Funerary Context vs Cannibalism          | -3.54| 9.98e-04|***  |
|mnau_shoulder                       |Funerary Context vs Sepulchral Cave      | -4.31| 5.48e-05|**** |
|mnau_shoulder                       |Funerary Context vs Carnivore            | -6.68| 0.00e+00|**** |
|mnau_shoulder                       |Funerary Context vs Geological transport | -5.41| 3.00e-07|**** |
|mnau_shoulder                       |Cannibalism vs Sepulchral Cave           | -0.67| 5.61e-01|ns   |
|mnau_shoulder                       |Cannibalism vs Carnivore                 | -3.21| 2.65e-03|**   |
|mnau_shoulder                       |Cannibalism vs Geological transport      | -2.48| 1.87e-02|*    |
|mnau_shoulder                       |Sepulchral Cave vs Carnivore             | -2.61| 1.51e-02|*    |
|mnau_shoulder                       |Sepulchral Cave vs Geological transport  | -1.94| 6.49e-02|ns   |
|mnau_shoulder                       |Carnivore vs Geological transport        |  0.37| 7.14e-01|ns   |
|mnau_simpson_dominance              |Funerary Context vs Cannibalism          |  4.43| 3.15e-05|**** |
|mnau_simpson_dominance              |Funerary Context vs Sepulchral Cave      |  3.58| 7.63e-04|***  |
|mnau_simpson_dominance              |Funerary Context vs Carnivore            |  6.86| 0.00e+00|**** |
|mnau_simpson_dominance              |Funerary Context vs Geological transport |  6.58| 0.00e+00|**** |
|mnau_simpson_dominance              |Cannibalism vs Sepulchral Cave           | -0.74| 5.12e-01|ns   |
|mnau_simpson_dominance              |Cannibalism vs Carnivore                 |  2.87| 5.19e-03|**   |
|mnau_simpson_dominance              |Cannibalism vs Geological transport      |  2.94| 4.73e-03|**   |
|mnau_simpson_dominance              |Sepulchral Cave vs Carnivore             |  3.50| 7.63e-04|***  |
|mnau_simpson_dominance              |Sepulchral Cave vs Geological transport  |  3.53| 7.63e-04|***  |
|mnau_simpson_dominance              |Carnivore vs Geological transport        |  0.25| 8.05e-01|ns   |
|mnau_simpson_evenness               |Funerary Context vs Cannibalism          | -4.43| 3.15e-05|**** |
|mnau_simpson_evenness               |Funerary Context vs Sepulchral Cave      | -3.58| 7.63e-04|***  |
|mnau_simpson_evenness               |Funerary Context vs Carnivore            | -6.86| 0.00e+00|**** |
|mnau_simpson_evenness               |Funerary Context vs Geological transport | -6.58| 0.00e+00|**** |
|mnau_simpson_evenness               |Cannibalism vs Sepulchral Cave           |  0.74| 5.12e-01|ns   |
|mnau_simpson_evenness               |Cannibalism vs Carnivore                 | -2.87| 5.19e-03|**   |
|mnau_simpson_evenness               |Cannibalism vs Geological transport      | -2.94| 4.73e-03|**   |
|mnau_simpson_evenness               |Sepulchral Cave vs Carnivore             | -3.50| 7.63e-04|***  |
|mnau_simpson_evenness               |Sepulchral Cave vs Geological transport  | -3.53| 7.63e-04|***  |
|mnau_simpson_evenness               |Carnivore vs Geological transport        | -0.25| 8.05e-01|ns   |
|mnau_top2_share_mcnaughton          |Funerary Context vs Cannibalism          |  4.20| 9.07e-05|**** |
|mnau_top2_share_mcnaughton          |Funerary Context vs Sepulchral Cave      |  3.69| 4.56e-04|***  |
|mnau_top2_share_mcnaughton          |Funerary Context vs Carnivore            |  6.97| 0.00e+00|**** |
|mnau_top2_share_mcnaughton          |Funerary Context vs Geological transport |  6.89| 0.00e+00|**** |
|mnau_top2_share_mcnaughton          |Cannibalism vs Sepulchral Cave           | -0.44| 6.77e-01|ns   |
|mnau_top2_share_mcnaughton          |Cannibalism vs Carnivore                 |  3.14| 2.10e-03|**   |
|mnau_top2_share_mcnaughton          |Cannibalism vs Geological transport      |  3.38| 1.03e-03|**   |
|mnau_top2_share_mcnaughton          |Sepulchral Cave vs Carnivore             |  3.53| 7.04e-04|***  |
|mnau_top2_share_mcnaughton          |Sepulchral Cave vs Geological transport  |  3.74| 4.56e-04|***  |
|mnau_top2_share_mcnaughton          |Carnivore vs Geological transport        |  0.42| 6.77e-01|ns   |
|mnau_upper_appendicular_mean        |Funerary Context vs Cannibalism          | -4.38| 3.89e-05|**** |
|mnau_upper_appendicular_mean        |Funerary Context vs Sepulchral Cave      | -4.06| 1.25e-04|***  |
|mnau_upper_appendicular_mean        |Funerary Context vs Carnivore            | -7.61| 0.00e+00|**** |
|mnau_upper_appendicular_mean        |Funerary Context vs Geological transport | -6.50| 0.00e+00|**** |
|mnau_upper_appendicular_mean        |Cannibalism vs Sepulchral Cave           |  0.29| 8.62e-01|ns   |
|mnau_upper_appendicular_mean        |Cannibalism vs Carnivore                 | -3.38| 1.19e-03|**   |
|mnau_upper_appendicular_mean        |Cannibalism vs Geological transport      | -2.90| 4.72e-03|**   |
|mnau_upper_appendicular_mean        |Sepulchral Cave vs Carnivore             | -3.64| 5.46e-04|***  |
|mnau_upper_appendicular_mean        |Sepulchral Cave vs Geological transport  | -3.13| 2.53e-03|**   |
|mnau_upper_appendicular_mean        |Carnivore vs Geological transport        |  0.12| 9.02e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Funerary Context vs Cannibalism          | -2.80| 5.17e-02|ns   |
|mnau_vertebrae_to_thorax_ratio      |Funerary Context vs Sepulchral Cave      | -0.11| 9.11e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Funerary Context vs Carnivore            | -0.97| 5.55e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Funerary Context vs Geological transport | -1.61| 3.57e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Cannibalism vs Sepulchral Cave           |  2.33| 9.84e-02|ns   |
|mnau_vertebrae_to_thorax_ratio      |Cannibalism vs Carnivore                 |  1.32| 3.74e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Cannibalism vs Geological transport      |  0.48| 7.02e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Sepulchral Cave vs Carnivore             | -0.78| 6.23e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Sepulchral Cave vs Geological transport  | -1.40| 3.74e-01|ns   |
|mnau_vertebrae_to_thorax_ratio      |Carnivore vs Geological transport        | -0.65| 6.41e-01|ns   |
|mne_arms                            |Funerary Context vs Cannibalism          | -1.60| 1.38e-01|ns   |
|mne_arms                            |Funerary Context vs Sepulchral Cave      | -2.94| 4.73e-03|**   |
|mne_arms                            |Funerary Context vs Carnivore            | -6.57| 0.00e+00|**** |
|mne_arms                            |Funerary Context vs Geological transport | -5.89| 0.00e+00|**** |
|mne_arms                            |Cannibalism vs Sepulchral Cave           | -1.16| 2.71e-01|ns   |
|mne_arms                            |Cannibalism vs Carnivore                 | -4.64| 1.18e-05|**** |
|mne_arms                            |Cannibalism vs Geological transport      | -4.29| 4.53e-05|**** |
|mne_arms                            |Sepulchral Cave vs Carnivore             | -3.59| 6.63e-04|***  |
|mne_arms                            |Sepulchral Cave vs Geological transport  | -3.35| 1.35e-03|**   |
|mne_arms                            |Carnivore vs Geological transport        | -0.13| 8.99e-01|ns   |
|mne_cranial_share                   |Funerary Context vs Cannibalism          |  3.91| 4.54e-04|***  |
|mne_cranial_share                   |Funerary Context vs Sepulchral Cave      |  2.09| 5.21e-02|ns   |
|mne_cranial_share                   |Funerary Context vs Carnivore            |  2.50| 2.51e-02|*    |
|mne_cranial_share                   |Funerary Context vs Geological transport |  5.37| 8.00e-07|**** |
|mne_cranial_share                   |Cannibalism vs Sepulchral Cave           | -1.58| 1.42e-01|ns   |
|mne_cranial_share                   |Cannibalism vs Carnivore                 | -0.83| 4.55e-01|ns   |
|mne_cranial_share                   |Cannibalism vs Geological transport      |  2.19| 4.80e-02|*    |
|mne_cranial_share                   |Sepulchral Cave vs Carnivore             |  0.60| 5.49e-01|ns   |
|mne_cranial_share                   |Sepulchral Cave vs Geological transport  |  3.46| 1.79e-03|**   |
|mne_cranial_share                   |Carnivore vs Geological transport        |  2.72| 1.61e-02|*    |
|postcranial_dominance_refined       |Funerary Context vs Cannibalism          |  2.93| 5.87e-03|**   |
|postcranial_dominance_refined       |Funerary Context vs Sepulchral Cave      |  4.56| 2.58e-05|**** |
|postcranial_dominance_refined       |Funerary Context vs Carnivore            |  6.66| 0.00e+00|**** |
|postcranial_dominance_refined       |Funerary Context vs Geological transport |  4.14| 1.16e-04|***  |
|postcranial_dominance_refined       |Cannibalism vs Sepulchral Cave           |  1.31| 2.11e-01|ns   |
|postcranial_dominance_refined       |Cannibalism vs Carnivore                 |  3.94| 2.02e-04|***  |
|postcranial_dominance_refined       |Cannibalism vs Geological transport      |  2.61| 1.31e-02|*    |
|postcranial_dominance_refined       |Sepulchral Cave vs Carnivore             |  2.92| 5.87e-03|**   |
|postcranial_dominance_refined       |Sepulchral Cave vs Geological transport  |  1.92| 6.90e-02|ns   |
|postcranial_dominance_refined       |Carnivore vs Geological transport        |  0.01| 9.89e-01|ns   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 14.51, R² = 0.356, p = 0.0001.
PCA variance explained: PC1 55.8%, PC2 9.4%, PC3 6.4% (cumulative 71.6%).
Dispersion caveat (PERMDISP): p = 0.011 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.161|  0.137| -0.018|
|mnau_appendicular_mean      | -0.160|  0.136|  0.035|
|mnau_gini                   |  0.159|  0.120| -0.001|
|mnau_top2_share_mcnaughton  |  0.159|  0.140|  0.006|
|mnau_simpson_evenness       | -0.158| -0.109|  0.002|
|mnau_inverse_simpson        | -0.158| -0.109|  0.002|
|effective_sections_hill1    | -0.158| -0.135| -0.004|
|mnau_heip_evenness          | -0.158| -0.135| -0.004|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
