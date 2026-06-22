# Accumulation process
*Automated taphonomic_context × skeletal-part representation*

- **Grouping column:** `taphonomic_context` (mode = single)
- **Groups (n):** Funerary Context = 48; Cannibalism = 25; Cuevas Sepulcrales = 24; Carnivore = 14; Geological transport = 13
- **Sites analysed:** 124  |  **features screened:** 63

## Hypothesis

**H:** Different accumulation causes produce different body-part profiles.

**Expected pattern:** Funerary contexts more anatomically balanced; carnivore/geological transport loses small, fragile, axial, low-density elements; cannibalism shows selective absence/over-representation of processed parts.

**Why it matters:** Strongest hypothesis: accumulation cause is directly linked to skeletal survival, transport and human/carnivore behaviour.


## Summary

56 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_appendicular_mean** (ε² = 0.601, FDR p = 5.78e-14). PERMANOVA pseudo-F = 12.71, p = 0.0001; PC1–PC3 explain 71.9% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 233 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 54 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|mnau_appendicular_mean                       |  0.601| 0.00e+00|large      |significant |
|mnau_lower_appendicular_mean                 |  0.587| 0.00e+00|large      |significant |
|mnau_upper_appendicular_mean                 |  0.587| 0.00e+00|large      |significant |
|mnau_postcranial_total_mean                  |  0.586| 0.00e+00|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.580| 0.00e+00|large      |significant |
|mnau_gini                                    |  0.570| 0.00e+00|large      |significant |
|mnau_proximal_appendicular_mean              |  0.568| 0.00e+00|large      |significant |
|effective_sections_hill1                     |  0.563| 0.00e+00|large      |significant |
|mnau_heip_evenness                           |  0.563| 0.00e+00|large      |significant |
|mnau_cv                                      |  0.559| 0.00e+00|large      |significant |
|mnau_inverse_simpson                         |  0.558| 0.00e+00|large      |significant |
|mnau_simpson_dominance                       |  0.558| 0.00e+00|large      |significant |
|mnau_simpson_evenness                        |  0.558| 0.00e+00|large      |significant |
|mnau_evenness_minus_dominance                |  0.557| 0.00e+00|large      |significant |
|low_density_survival_index                   |  0.552| 0.00e+00|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.548| 0.00e+00|large      |significant |
|lower_appendicular_continuity_hm             |  0.546| 0.00e+00|large      |significant |
|mnau_column_trunk_mean                       |  0.545| 0.00e+00|large      |significant |
|all_sections_dominance                       |  0.535| 0.00e+00|large      |significant |
|mnau_region_mean_evenness                    |  0.525| 0.00e+00|large      |significant |
|mnau_girdle_mean                             |  0.523| 0.00e+00|large      |significant |
|low_density_axial_survival                   |  0.513| 0.00e+00|large      |significant |
|mnau_distal_appendicular_mean                |  0.506| 0.00e+00|large      |significant |
|mnau_arms                                    |  0.503| 0.00e+00|large      |significant |
|mnau_legs                                    |  0.494| 0.00e+00|large      |significant |
|mnau_axial_main_mean                         |  0.488| 0.00e+00|large      |significant |
|appendicular_dominance                       |  0.485| 0.00e+00|large      |significant |
|appendicular_dominance_refined               |  0.485| 0.00e+00|large      |significant |
|mne_arms                                     |  0.481| 0.00e+00|large      |significant |
|mnau_dominance_of_region_means               |  0.476| 0.00e+00|large      |significant |
|postcranial_dominance_refined                |  0.473| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_radius              |  0.473| 0.00e+00|large      |significant |
|dominance_gap_all                            |  0.450| 0.00e+00|large      |significant |
|distal_appendicular_continuity_hm            |  0.449| 0.00e+00|large      |significant |
|density_evenness                             |  0.449| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_humerus             |  0.433| 0.00e+00|large      |significant |
|mnau_shoulder                                |  0.430| 0.00e+00|large      |significant |
|mnau_pelvic                                  |  0.430| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.413| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_fibula              |  0.397| 0.00e+00|large      |significant |
|mnau_foot                                    |  0.391| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_femur               |  0.391| 0.00e+00|large      |significant |
|mnau_hands                                   |  0.387| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_tibia               |  0.381| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.378| 0.00e+00|large      |significant |
|ReMNAU_radius                                |  0.377| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_clavicle            |  0.375| 0.00e+00|large      |significant |
|ProportionalRep_MNIbased_carpal              |  0.368| 0.00e+00|large      |significant |
|lower_appendicular_evenness                  |  0.325| 2.00e-07|large      |significant |
|lower_appendicular_evenness_refined          |  0.325| 2.00e-07|large      |significant |
|ProportionalRep_MNIbased_cervical            |  0.322| 0.00e+00|large      |significant |
|low_density_share                            |  0.316| 0.00e+00|large      |significant |
|ReMNAU_ulna                                  |  0.272| 3.00e-07|large      |significant |
|ReMNAU_cervical                              |  0.247| 1.10e-06|large      |significant |
|mne_cranial_share                            |  0.247| 1.10e-06|large      |significant |
|dominant_axial_share                         |  0.245| 1.30e-06|large      |significant |
|density_adjusted_appendicular_axial_contrast |  0.048| 5.10e-02|small      |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.039| 7.59e-02|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.033| 9.98e-02|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.023| 1.52e-01|small      |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.023| 1.52e-01|small      |n.s.        |
|mnau_arms_legs_diff                          |  0.013| 2.43e-01|small      |n.s.        |
|mne_arms_to_legs_ratio                       | -0.031| 9.86e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                   |     Z|  p (adj)|Sig  |
|:-----------------------------------|:------------------------------------------|-----:|--------:|:----|
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Cannibalism            | -3.64| 6.79e-04|***  |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Cuevas Sepulcrales     | -4.59| 1.51e-05|**** |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Carnivore              | -5.04| 4.60e-06|**** |
|ProportionalRep_MNIbased_carpal     |Funerary Context vs Geological transport   | -4.90| 4.80e-06|**** |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Cuevas Sepulcrales          | -0.87| 4.27e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Carnivore                   | -1.90| 1.06e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Cannibalism vs Geological transport        | -1.85| 1.06e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Cuevas Sepulcrales vs Carnivore            | -1.15| 3.29e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Cuevas Sepulcrales vs Geological transport | -1.12| 3.29e-01|ns   |
|ProportionalRep_MNIbased_carpal     |Carnivore vs Geological transport          |  0.00| 1.00e+00|ns   |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Cannibalism            | -3.77| 5.37e-04|***  |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Cuevas Sepulcrales     | -2.83| 1.17e-02|*    |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Carnivore              | -5.26| 1.40e-06|**** |
|ProportionalRep_MNIbased_cervical   |Funerary Context vs Geological transport   | -4.50| 3.45e-05|**** |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Cuevas Sepulcrales          |  0.78| 4.82e-01|ns   |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Carnivore                   | -2.00| 6.52e-02|ns   |
|ProportionalRep_MNIbased_cervical   |Cannibalism vs Geological transport        | -1.39| 2.06e-01|ns   |
|ProportionalRep_MNIbased_cervical   |Cuevas Sepulcrales vs Carnivore            | -2.65| 1.61e-02|*    |
|ProportionalRep_MNIbased_cervical   |Cuevas Sepulcrales vs Geological transport | -2.03| 6.52e-02|ns   |
|ProportionalRep_MNIbased_cervical   |Carnivore vs Geological transport          |  0.50| 6.18e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Cannibalism            | -3.81| 3.52e-04|***  |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Cuevas Sepulcrales     | -4.19| 9.24e-05|**** |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Carnivore              | -5.67| 1.00e-07|**** |
|ProportionalRep_MNIbased_clavicle   |Funerary Context vs Geological transport   | -4.47| 3.98e-05|**** |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Cuevas Sepulcrales          | -0.38| 7.03e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Carnivore                   | -2.35| 3.79e-02|*    |
|ProportionalRep_MNIbased_clavicle   |Cannibalism vs Geological transport        | -1.34| 2.58e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Cuevas Sepulcrales vs Carnivore            | -2.00| 7.50e-02|ns   |
|ProportionalRep_MNIbased_clavicle   |Cuevas Sepulcrales vs Geological transport | -1.01| 3.89e-01|ns   |
|ProportionalRep_MNIbased_clavicle   |Carnivore vs Geological transport          |  0.85| 4.42e-01|ns   |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Cannibalism            | -3.93| 2.78e-04|***  |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Cuevas Sepulcrales     | -3.49| 1.22e-03|**   |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Carnivore              | -5.08| 1.90e-06|**** |
|ProportionalRep_MNIbased_femur      |Funerary Context vs Geological transport   | -5.64| 2.00e-07|**** |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Cuevas Sepulcrales          |  0.35| 7.30e-01|ns   |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Carnivore                   | -1.71| 1.08e-01|ns   |
|ProportionalRep_MNIbased_femur      |Cannibalism vs Geological transport        | -2.31| 3.44e-02|*    |
|ProportionalRep_MNIbased_femur      |Cuevas Sepulcrales vs Carnivore            | -1.99| 6.59e-02|ns   |
|ProportionalRep_MNIbased_femur      |Cuevas Sepulcrales vs Geological transport | -2.59| 1.95e-02|*    |
|ProportionalRep_MNIbased_femur      |Carnivore vs Geological transport          | -0.57| 6.32e-01|ns   |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Cannibalism            | -3.63| 7.19e-04|***  |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Cuevas Sepulcrales     | -3.77| 5.51e-04|***  |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Carnivore              | -5.66| 1.00e-07|**** |
|ProportionalRep_MNIbased_fibula     |Funerary Context vs Geological transport   | -5.17| 1.20e-06|**** |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Cuevas Sepulcrales          | -0.17| 8.68e-01|ns   |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Carnivore                   | -2.47| 2.68e-02|*    |
|ProportionalRep_MNIbased_fibula     |Cannibalism vs Geological transport        | -2.11| 4.96e-02|*    |
|ProportionalRep_MNIbased_fibula     |Cuevas Sepulcrales vs Carnivore            | -2.31| 3.44e-02|*    |
|ProportionalRep_MNIbased_fibula     |Cuevas Sepulcrales vs Geological transport | -1.96| 6.26e-02|ns   |
|ProportionalRep_MNIbased_fibula     |Carnivore vs Geological transport          |  0.27| 8.68e-01|ns   |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Cannibalism            | -3.68| 7.84e-04|***  |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Cuevas Sepulcrales     | -2.86| 7.12e-03|**   |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Carnivore              | -6.14| 0.00e+00|**** |
|ProportionalRep_MNIbased_humerus    |Funerary Context vs Geological transport   | -5.30| 6.00e-07|**** |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Cuevas Sepulcrales          |  0.67| 5.56e-01|ns   |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Carnivore                   | -2.87| 7.12e-03|**   |
|ProportionalRep_MNIbased_humerus    |Cannibalism vs Geological transport        | -2.19| 3.53e-02|*    |
|ProportionalRep_MNIbased_humerus    |Cuevas Sepulcrales vs Carnivore            | -3.42| 1.54e-03|**   |
|ProportionalRep_MNIbased_humerus    |Cuevas Sepulcrales vs Geological transport | -2.74| 8.83e-03|**   |
|ProportionalRep_MNIbased_humerus    |Carnivore vs Geological transport          |  0.54| 5.88e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Cannibalism            | -4.25| 6.98e-05|**** |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Cuevas Sepulcrales     | -3.59| 8.40e-04|***  |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Carnivore              | -5.42| 6.00e-07|**** |
|ProportionalRep_MNIbased_metacarpal |Funerary Context vs Geological transport   | -4.90| 4.90e-06|**** |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Cuevas Sepulcrales          |  0.53| 6.59e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Carnivore                   | -1.79| 1.05e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Cannibalism vs Geological transport        | -1.41| 1.98e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Cuevas Sepulcrales vs Carnivore            | -2.23| 5.11e-02|ns   |
|ProportionalRep_MNIbased_metacarpal |Cuevas Sepulcrales vs Geological transport | -1.84| 1.05e-01|ns   |
|ProportionalRep_MNIbased_metacarpal |Carnivore vs Geological transport          |  0.30| 7.63e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Cannibalism            | -3.90| 2.38e-04|***  |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Cuevas Sepulcrales     | -4.41| 3.40e-05|**** |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Carnivore              | -5.59| 2.00e-07|**** |
|ProportionalRep_MNIbased_os_coxae   |Funerary Context vs Geological transport   | -5.12| 1.50e-06|**** |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Cuevas Sepulcrales          | -0.49| 6.92e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Carnivore                   | -2.21| 5.46e-02|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cannibalism vs Geological transport        | -1.87| 1.04e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cuevas Sepulcrales vs Carnivore            | -1.77| 1.09e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Cuevas Sepulcrales vs Geological transport | -1.44| 1.86e-01|ns   |
|ProportionalRep_MNIbased_os_coxae   |Carnivore vs Geological transport          |  0.26| 7.98e-01|ns   |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Cannibalism            | -3.64| 6.69e-04|***  |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Cuevas Sepulcrales     | -4.81| 5.00e-06|**** |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Carnivore              | -6.06| 0.00e+00|**** |
|ProportionalRep_MNIbased_radius     |Funerary Context vs Geological transport   | -5.39| 3.00e-07|**** |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Cuevas Sepulcrales          | -1.06| 3.19e-01|ns   |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Carnivore                   | -2.82| 9.52e-03|**   |
|ProportionalRep_MNIbased_radius     |Cannibalism vs Geological transport        | -2.30| 3.55e-02|*    |
|ProportionalRep_MNIbased_radius     |Cuevas Sepulcrales vs Carnivore            | -1.90| 8.24e-02|ns   |
|ProportionalRep_MNIbased_radius     |Cuevas Sepulcrales vs Geological transport | -1.40| 2.00e-01|ns   |
|ProportionalRep_MNIbased_radius     |Carnivore vs Geological transport          |  0.40| 6.88e-01|ns   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Cannibalism            | -3.24| 3.02e-03|**   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Cuevas Sepulcrales     | -3.39| 2.37e-03|**   |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Carnivore              | -5.77| 1.00e-07|**** |
|ProportionalRep_MNIbased_tibia      |Funerary Context vs Geological transport   | -4.98| 3.10e-06|**** |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Cuevas Sepulcrales          | -0.17| 8.66e-01|ns   |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Carnivore                   | -2.86| 8.52e-03|**   |
|ProportionalRep_MNIbased_tibia      |Cannibalism vs Geological transport        | -2.22| 3.76e-02|*    |
|ProportionalRep_MNIbased_tibia      |Cuevas Sepulcrales vs Carnivore            | -2.69| 1.18e-02|*    |
|ProportionalRep_MNIbased_tibia      |Cuevas Sepulcrales vs Geological transport | -2.07| 4.85e-02|*    |
|ProportionalRep_MNIbased_tibia      |Carnivore vs Geological transport          |  0.50| 6.82e-01|ns   |
|ReMNAU_cervical                     |Funerary Context vs Cannibalism            | -2.79| 1.32e-02|*    |
|ReMNAU_cervical                     |Funerary Context vs Cuevas Sepulcrales     | -1.44| 1.89e-01|ns   |
|ReMNAU_cervical                     |Funerary Context vs Carnivore              | -4.77| 1.84e-05|**** |
|ReMNAU_cervical                     |Funerary Context vs Geological transport   | -4.02| 2.90e-04|***  |
|ReMNAU_cervical                     |Cannibalism vs Cuevas Sepulcrales          |  1.15| 2.77e-01|ns   |
|ReMNAU_cervical                     |Cannibalism vs Carnivore                   | -2.28| 3.77e-02|*    |
|ReMNAU_cervical                     |Cannibalism vs Geological transport        | -1.66| 1.37e-01|ns   |
|ReMNAU_cervical                     |Cuevas Sepulcrales vs Carnivore            | -3.24| 3.96e-03|**   |
|ReMNAU_cervical                     |Cuevas Sepulcrales vs Geological transport | -2.61| 1.82e-02|*    |
|ReMNAU_cervical                     |Carnivore vs Geological transport          |  0.50| 6.18e-01|ns   |
|ReMNAU_radius                       |Funerary Context vs Cannibalism            | -2.18| 4.14e-02|*    |
|ReMNAU_radius                       |Funerary Context vs Cuevas Sepulcrales     | -3.68| 7.74e-04|***  |
|ReMNAU_radius                       |Funerary Context vs Carnivore              | -5.55| 3.00e-07|**** |
|ReMNAU_radius                       |Funerary Context vs Geological transport   | -5.09| 1.80e-06|**** |
|ReMNAU_radius                       |Cannibalism vs Cuevas Sepulcrales          | -1.34| 2.02e-01|ns   |
|ReMNAU_radius                       |Cannibalism vs Carnivore                   | -3.43| 1.49e-03|**   |
|ReMNAU_radius                       |Cannibalism vs Geological transport        | -3.08| 4.12e-03|**   |
|ReMNAU_radius                       |Cuevas Sepulcrales vs Carnivore            | -2.27| 3.84e-02|*    |
|ReMNAU_radius                       |Cuevas Sepulcrales vs Geological transport | -1.95| 6.37e-02|ns   |
|ReMNAU_radius                       |Carnivore vs Geological transport          |  0.24| 8.11e-01|ns   |
|ReMNAU_ulna                         |Funerary Context vs Cannibalism            | -2.35| 2.68e-02|*    |
|ReMNAU_ulna                         |Funerary Context vs Cuevas Sepulcrales     | -2.61| 2.26e-02|*    |
|ReMNAU_ulna                         |Funerary Context vs Carnivore              | -4.57| 2.47e-05|**** |
|ReMNAU_ulna                         |Funerary Context vs Geological transport   | -4.80| 1.57e-05|**** |
|ReMNAU_ulna                         |Cannibalism vs Cuevas Sepulcrales          | -0.25| 7.99e-01|ns   |
|ReMNAU_ulna                         |Cannibalism vs Carnivore                   | -2.42| 2.60e-02|*    |
|ReMNAU_ulna                         |Cannibalism vs Geological transport        | -2.69| 2.26e-02|*    |
|ReMNAU_ulna                         |Cuevas Sepulcrales vs Carnivore            | -2.18| 3.62e-02|*    |
|ReMNAU_ulna                         |Cuevas Sepulcrales vs Geological transport | -2.46| 2.60e-02|*    |
|ReMNAU_ulna                         |Carnivore vs Geological transport          | -0.30| 7.99e-01|ns   |
|all_sections_dominance              |Funerary Context vs Cannibalism            |  4.22| 8.32e-05|**** |
|all_sections_dominance              |Funerary Context vs Cuevas Sepulcrales     |  3.33| 1.73e-03|**   |
|all_sections_dominance              |Funerary Context vs Carnivore              |  6.31| 0.00e+00|**** |
|all_sections_dominance              |Funerary Context vs Geological transport   |  6.12| 0.00e+00|**** |
|all_sections_dominance              |Cannibalism vs Cuevas Sepulcrales          | -0.72| 5.21e-01|ns   |
|all_sections_dominance              |Cannibalism vs Carnivore                   |  2.84| 6.50e-03|**   |
|all_sections_dominance              |Cannibalism vs Geological transport        |  2.55| 1.34e-02|*    |
|all_sections_dominance              |Cuevas Sepulcrales vs Carnivore            |  3.40| 1.67e-03|**   |
|all_sections_dominance              |Cuevas Sepulcrales vs Geological transport |  3.13| 2.87e-03|**   |
|all_sections_dominance              |Carnivore vs Geological transport          | -0.31| 7.57e-01|ns   |
|appendicular_dominance              |Funerary Context vs Cannibalism            |  3.04| 4.77e-03|**   |
|appendicular_dominance              |Funerary Context vs Cuevas Sepulcrales     |  4.65| 1.65e-05|**** |
|appendicular_dominance              |Funerary Context vs Carnivore              |  6.22| 0.00e+00|**** |
|appendicular_dominance              |Funerary Context vs Geological transport   |  3.59| 8.41e-04|***  |
|appendicular_dominance              |Cannibalism vs Cuevas Sepulcrales          |  1.34| 2.23e-01|ns   |
|appendicular_dominance              |Cannibalism vs Carnivore                   |  3.67| 7.99e-04|***  |
|appendicular_dominance              |Cannibalism vs Geological transport        |  1.85| 9.11e-02|ns   |
|appendicular_dominance              |Cuevas Sepulcrales vs Carnivore            |  2.65| 1.33e-02|*    |
|appendicular_dominance              |Cuevas Sepulcrales vs Geological transport |  1.06| 3.20e-01|ns   |
|appendicular_dominance              |Carnivore vs Geological transport          | -0.87| 3.84e-01|ns   |
|appendicular_dominance_refined      |Funerary Context vs Cannibalism            |  3.04| 4.77e-03|**   |
|appendicular_dominance_refined      |Funerary Context vs Cuevas Sepulcrales     |  4.65| 1.65e-05|**** |
|appendicular_dominance_refined      |Funerary Context vs Carnivore              |  6.22| 0.00e+00|**** |
|appendicular_dominance_refined      |Funerary Context vs Geological transport   |  3.59| 8.41e-04|***  |
|appendicular_dominance_refined      |Cannibalism vs Cuevas Sepulcrales          |  1.34| 2.23e-01|ns   |
|appendicular_dominance_refined      |Cannibalism vs Carnivore                   |  3.67| 7.99e-04|***  |
|appendicular_dominance_refined      |Cannibalism vs Geological transport        |  1.85| 9.11e-02|ns   |
|appendicular_dominance_refined      |Cuevas Sepulcrales vs Carnivore            |  2.65| 1.33e-02|*    |
|appendicular_dominance_refined      |Cuevas Sepulcrales vs Geological transport |  1.06| 3.20e-01|ns   |
|appendicular_dominance_refined      |Carnivore vs Geological transport          | -0.87| 3.84e-01|ns   |
|density_evenness                    |Funerary Context vs Cannibalism            | -3.24| 2.24e-03|**   |
|density_evenness                    |Funerary Context vs Cuevas Sepulcrales     | -2.43| 1.88e-02|*    |
|density_evenness                    |Funerary Context vs Carnivore              | -5.97| 0.00e+00|**** |
|density_evenness                    |Funerary Context vs Geological transport   | -5.64| 1.00e-07|**** |
|density_evenness                    |Cannibalism vs Cuevas Sepulcrales          |  0.67| 5.58e-01|ns   |
|density_evenness                    |Cannibalism vs Carnivore                   | -3.21| 2.24e-03|**   |
|density_evenness                    |Cannibalism vs Geological transport        | -2.82| 6.85e-03|**   |
|density_evenness                    |Cuevas Sepulcrales vs Carnivore            | -3.73| 6.44e-04|***  |
|density_evenness                    |Cuevas Sepulcrales vs Geological transport | -3.36| 1.96e-03|**   |
|density_evenness                    |Carnivore vs Geological transport          |  0.40| 6.87e-01|ns   |
|distal_appendicular_continuity_hm   |Funerary Context vs Cannibalism            | -3.03| 3.51e-03|**   |
|distal_appendicular_continuity_hm   |Funerary Context vs Cuevas Sepulcrales     | -2.96| 3.84e-03|**   |
|distal_appendicular_continuity_hm   |Funerary Context vs Carnivore              | -5.83| 0.00e+00|**** |
|distal_appendicular_continuity_hm   |Funerary Context vs Geological transport   | -5.99| 0.00e+00|**** |
|distal_appendicular_continuity_hm   |Cannibalism vs Cuevas Sepulcrales          |  0.02| 9.81e-01|ns   |
|distal_appendicular_continuity_hm   |Cannibalism vs Carnivore                   | -3.06| 3.51e-03|**   |
|distal_appendicular_continuity_hm   |Cannibalism vs Geological transport        | -3.29| 2.53e-03|**   |
|distal_appendicular_continuity_hm   |Cuevas Sepulcrales vs Carnivore            | -3.06| 3.51e-03|**   |
|distal_appendicular_continuity_hm   |Cuevas Sepulcrales vs Geological transport | -3.29| 2.53e-03|**   |
|distal_appendicular_continuity_hm   |Carnivore vs Geological transport          | -0.27| 8.78e-01|ns   |
|dominance_gap_all                   |Funerary Context vs Cannibalism            |  3.80| 4.91e-04|***  |
|dominance_gap_all                   |Funerary Context vs Cuevas Sepulcrales     |  2.41| 2.30e-02|*    |
|dominance_gap_all                   |Funerary Context vs Carnivore              |  5.92| 0.00e+00|**** |
|dominance_gap_all                   |Funerary Context vs Geological transport   |  5.55| 1.00e-07|**** |
|dominance_gap_all                   |Cannibalism vs Cuevas Sepulcrales          | -1.17| 2.69e-01|ns   |
|dominance_gap_all                   |Cannibalism vs Carnivore                   |  2.77| 9.27e-03|**   |
|dominance_gap_all                   |Cannibalism vs Geological transport        |  2.34| 2.42e-02|*    |
|dominance_gap_all                   |Cuevas Sepulcrales vs Carnivore            |  3.70| 5.39e-04|***  |
|dominance_gap_all                   |Cuevas Sepulcrales vs Geological transport |  3.29| 1.98e-03|**   |
|dominance_gap_all                   |Carnivore vs Geological transport          | -0.43| 6.64e-01|ns   |
|dominant_axial_share                |Funerary Context vs Cannibalism            |  3.86| 5.78e-04|***  |
|dominant_axial_share                |Funerary Context vs Cuevas Sepulcrales     |  2.74| 2.06e-02|*    |
|dominant_axial_share                |Funerary Context vs Carnivore              |  2.13| 5.51e-02|ns   |
|dominant_axial_share                |Funerary Context vs Geological transport   |  5.08| 3.80e-06|**** |
|dominant_axial_share                |Cannibalism vs Cuevas Sepulcrales          | -0.93| 4.04e-01|ns   |
|dominant_axial_share                |Cannibalism vs Carnivore                   | -0.91| 4.04e-01|ns   |
|dominant_axial_share                |Cannibalism vs Geological transport        |  1.87| 8.88e-02|ns   |
|dominant_axial_share                |Cuevas Sepulcrales vs Carnivore            | -0.11| 9.12e-01|ns   |
|dominant_axial_share                |Cuevas Sepulcrales vs Geological transport |  2.63| 2.16e-02|*    |
|dominant_axial_share                |Carnivore vs Geological transport          |  2.44| 2.90e-02|*    |
|effective_sections_hill1            |Funerary Context vs Cannibalism            | -4.14| 1.15e-04|***  |
|effective_sections_hill1            |Funerary Context vs Cuevas Sepulcrales     | -3.74| 4.57e-04|***  |
|effective_sections_hill1            |Funerary Context vs Carnivore              | -6.44| 0.00e+00|**** |
|effective_sections_hill1            |Funerary Context vs Geological transport   | -6.31| 0.00e+00|**** |
|effective_sections_hill1            |Cannibalism vs Cuevas Sepulcrales          |  0.30| 7.88e-01|ns   |
|effective_sections_hill1            |Cannibalism vs Carnivore                   | -3.01| 3.73e-03|**   |
|effective_sections_hill1            |Cannibalism vs Geological transport        | -2.78| 6.80e-03|**   |
|effective_sections_hill1            |Cuevas Sepulcrales vs Carnivore            | -3.24| 2.42e-03|**   |
|effective_sections_hill1            |Cuevas Sepulcrales vs Geological transport | -3.01| 3.73e-03|**   |
|effective_sections_hill1            |Carnivore vs Geological transport          |  0.27| 7.88e-01|ns   |
|low_density_axial_survival          |Funerary Context vs Cannibalism            | -3.91| 3.03e-04|***  |
|low_density_axial_survival          |Funerary Context vs Cuevas Sepulcrales     | -2.96| 4.45e-03|**   |
|low_density_axial_survival          |Funerary Context vs Carnivore              | -6.69| 0.00e+00|**** |
|low_density_axial_survival          |Funerary Context vs Geological transport   | -5.70| 1.00e-07|**** |
|low_density_axial_survival          |Cannibalism vs Cuevas Sepulcrales          |  0.79| 4.78e-01|ns   |
|low_density_axial_survival          |Cannibalism vs Carnivore                   | -3.20| 2.77e-03|**   |
|low_density_axial_survival          |Cannibalism vs Geological transport        | -2.39| 2.10e-02|*    |
|low_density_axial_survival          |Cuevas Sepulcrales vs Carnivore            | -3.84| 3.03e-04|***  |
|low_density_axial_survival          |Cuevas Sepulcrales vs Geological transport | -3.03| 4.10e-03|**   |
|low_density_axial_survival          |Carnivore vs Geological transport          |  0.65| 5.17e-01|ns   |
|low_density_share                   |Funerary Context vs Cannibalism            | -2.69| 1.18e-02|*    |
|low_density_share                   |Funerary Context vs Cuevas Sepulcrales     | -1.74| 1.02e-01|ns   |
|low_density_share                   |Funerary Context vs Carnivore              | -5.05| 4.40e-06|**** |
|low_density_share                   |Funerary Context vs Geological transport   | -4.81| 7.60e-06|**** |
|low_density_share                   |Cannibalism vs Cuevas Sepulcrales          |  0.80| 4.70e-01|ns   |
|low_density_share                   |Cannibalism vs Carnivore                   | -2.75| 1.18e-02|*    |
|low_density_share                   |Cannibalism vs Geological transport        | -2.45| 2.02e-02|*    |
|low_density_share                   |Cuevas Sepulcrales vs Carnivore            | -3.38| 2.41e-03|**   |
|low_density_share                   |Cuevas Sepulcrales vs Geological transport | -3.10| 4.82e-03|**   |
|low_density_share                   |Carnivore vs Geological transport          |  0.32| 7.50e-01|ns   |
|low_density_survival_index          |Funerary Context vs Cannibalism            | -4.05| 1.68e-04|***  |
|low_density_survival_index          |Funerary Context vs Cuevas Sepulcrales     | -3.78| 3.87e-04|***  |
|low_density_survival_index          |Funerary Context vs Carnivore              | -6.92| 0.00e+00|**** |
|low_density_survival_index          |Funerary Context vs Geological transport   | -5.85| 0.00e+00|**** |
|low_density_survival_index          |Cannibalism vs Cuevas Sepulcrales          |  0.19| 8.50e-01|ns   |
|low_density_survival_index          |Cannibalism vs Carnivore                   | -3.30| 1.61e-03|**   |
|low_density_survival_index          |Cannibalism vs Geological transport        | -2.42| 1.92e-02|*    |
|low_density_survival_index          |Cuevas Sepulcrales vs Carnivore            | -3.44| 1.18e-03|**   |
|low_density_survival_index          |Cuevas Sepulcrales vs Geological transport | -2.56| 1.48e-02|*    |
|low_density_survival_index          |Carnivore vs Geological transport          |  0.71| 5.32e-01|ns   |
|lower_appendicular_continuity_hm    |Funerary Context vs Cannibalism            | -3.38| 1.41e-03|**   |
|lower_appendicular_continuity_hm    |Funerary Context vs Cuevas Sepulcrales     | -3.99| 2.18e-04|***  |
|lower_appendicular_continuity_hm    |Funerary Context vs Carnivore              | -6.42| 0.00e+00|**** |
|lower_appendicular_continuity_hm    |Funerary Context vs Geological transport   | -6.41| 0.00e+00|**** |
|lower_appendicular_continuity_hm    |Cannibalism vs Cuevas Sepulcrales          | -0.57| 6.30e-01|ns   |
|lower_appendicular_continuity_hm    |Cannibalism vs Carnivore                   | -3.34| 1.41e-03|**   |
|lower_appendicular_continuity_hm    |Cannibalism vs Geological transport        | -3.42| 1.41e-03|**   |
|lower_appendicular_continuity_hm    |Cuevas Sepulcrales vs Carnivore            | -2.83| 5.88e-03|**   |
|lower_appendicular_continuity_hm    |Cuevas Sepulcrales vs Geological transport | -2.92| 5.01e-03|**   |
|lower_appendicular_continuity_hm    |Carnivore vs Geological transport          | -0.14| 8.87e-01|ns   |
|lower_appendicular_evenness         |Funerary Context vs Cannibalism            | -2.38| 3.49e-02|*    |
|lower_appendicular_evenness         |Funerary Context vs Cuevas Sepulcrales     | -4.13| 1.84e-04|***  |
|lower_appendicular_evenness         |Funerary Context vs Carnivore              | -4.73| 2.25e-05|**** |
|lower_appendicular_evenness         |Funerary Context vs Geological transport   | -3.07| 7.12e-03|**   |
|lower_appendicular_evenness         |Cannibalism vs Cuevas Sepulcrales          | -1.47| 1.77e-01|ns   |
|lower_appendicular_evenness         |Cannibalism vs Carnivore                   | -2.93| 8.44e-03|**   |
|lower_appendicular_evenness         |Cannibalism vs Geological transport        | -1.84| 9.46e-02|ns   |
|lower_appendicular_evenness         |Cuevas Sepulcrales vs Carnivore            | -1.90| 9.46e-02|ns   |
|lower_appendicular_evenness         |Cuevas Sepulcrales vs Geological transport | -1.05| 3.27e-01|ns   |
|lower_appendicular_evenness         |Carnivore vs Geological transport          |  0.34| 7.34e-01|ns   |
|lower_appendicular_evenness_refined |Funerary Context vs Cannibalism            | -2.38| 3.49e-02|*    |
|lower_appendicular_evenness_refined |Funerary Context vs Cuevas Sepulcrales     | -4.13| 1.84e-04|***  |
|lower_appendicular_evenness_refined |Funerary Context vs Carnivore              | -4.73| 2.25e-05|**** |
|lower_appendicular_evenness_refined |Funerary Context vs Geological transport   | -3.07| 7.12e-03|**   |
|lower_appendicular_evenness_refined |Cannibalism vs Cuevas Sepulcrales          | -1.47| 1.77e-01|ns   |
|lower_appendicular_evenness_refined |Cannibalism vs Carnivore                   | -2.93| 8.44e-03|**   |
|lower_appendicular_evenness_refined |Cannibalism vs Geological transport        | -1.84| 9.46e-02|ns   |
|lower_appendicular_evenness_refined |Cuevas Sepulcrales vs Carnivore            | -1.90| 9.46e-02|ns   |
|lower_appendicular_evenness_refined |Cuevas Sepulcrales vs Geological transport | -1.05| 3.27e-01|ns   |
|lower_appendicular_evenness_refined |Carnivore vs Geological transport          |  0.34| 7.34e-01|ns   |
|mnau_appendicular_mean              |Funerary Context vs Cannibalism            | -4.83| 4.50e-06|**** |
|mnau_appendicular_mean              |Funerary Context vs Cuevas Sepulcrales     | -4.03| 1.42e-04|***  |
|mnau_appendicular_mean              |Funerary Context vs Carnivore              | -6.78| 0.00e+00|**** |
|mnau_appendicular_mean              |Funerary Context vs Geological transport   | -6.38| 0.00e+00|**** |
|mnau_appendicular_mean              |Cannibalism vs Cuevas Sepulcrales          |  0.65| 5.73e-01|ns   |
|mnau_appendicular_mean              |Cannibalism vs Carnivore                   | -2.59| 1.36e-02|*    |
|mnau_appendicular_mean              |Cannibalism vs Geological transport        | -2.34| 2.39e-02|*    |
|mnau_appendicular_mean              |Cuevas Sepulcrales vs Carnivore            | -3.13| 3.54e-03|**   |
|mnau_appendicular_mean              |Cuevas Sepulcrales vs Geological transport | -2.87| 6.92e-03|**   |
|mnau_appendicular_mean              |Carnivore vs Geological transport          |  0.17| 8.67e-01|ns   |
|mnau_arms                           |Funerary Context vs Cannibalism            | -3.87| 3.69e-04|***  |
|mnau_arms                           |Funerary Context vs Cuevas Sepulcrales     | -3.45| 1.42e-03|**   |
|mnau_arms                           |Funerary Context vs Carnivore              | -6.48| 0.00e+00|**** |
|mnau_arms                           |Funerary Context vs Geological transport   | -5.81| 0.00e+00|**** |
|mnau_arms                           |Cannibalism vs Cuevas Sepulcrales          |  0.32| 7.48e-01|ns   |
|mnau_arms                           |Cannibalism vs Carnivore                   | -3.04| 3.90e-03|**   |
|mnau_arms                           |Cannibalism vs Geological transport        | -2.52| 1.45e-02|*    |
|mnau_arms                           |Cuevas Sepulcrales vs Carnivore            | -3.29| 1.98e-03|**   |
|mnau_arms                           |Cuevas Sepulcrales vs Geological transport | -2.77| 7.94e-03|**   |
|mnau_arms                           |Carnivore vs Geological transport          |  0.40| 7.48e-01|ns   |
|mnau_axial_main_mean                |Funerary Context vs Cannibalism            | -3.65| 6.57e-04|***  |
|mnau_axial_main_mean                |Funerary Context vs Cuevas Sepulcrales     | -2.61| 1.31e-02|*    |
|mnau_axial_main_mean                |Funerary Context vs Carnivore              | -6.56| 0.00e+00|**** |
|mnau_axial_main_mean                |Funerary Context vs Geological transport   | -5.57| 1.00e-07|**** |
|mnau_axial_main_mean                |Cannibalism vs Cuevas Sepulcrales          |  0.87| 4.27e-01|ns   |
|mnau_axial_main_mean                |Cannibalism vs Carnivore                   | -3.27| 2.12e-03|**   |
|mnau_axial_main_mean                |Cannibalism vs Geological transport        | -2.46| 1.74e-02|*    |
|mnau_axial_main_mean                |Cuevas Sepulcrales vs Carnivore            | -3.99| 2.21e-04|***  |
|mnau_axial_main_mean                |Cuevas Sepulcrales vs Geological transport | -3.16| 2.59e-03|**   |
|mnau_axial_main_mean                |Carnivore vs Geological transport          |  0.65| 5.13e-01|ns   |
|mnau_column_trunk_mean              |Funerary Context vs Cannibalism            | -4.06| 1.66e-04|***  |
|mnau_column_trunk_mean              |Funerary Context vs Cuevas Sepulcrales     | -3.41| 1.31e-03|**   |
|mnau_column_trunk_mean              |Funerary Context vs Carnivore              | -6.77| 0.00e+00|**** |
|mnau_column_trunk_mean              |Funerary Context vs Geological transport   | -5.98| 0.00e+00|**** |
|mnau_column_trunk_mean              |Cannibalism vs Cuevas Sepulcrales          |  0.52| 6.28e-01|ns   |
|mnau_column_trunk_mean              |Cannibalism vs Carnivore                   | -3.17| 2.56e-03|**   |
|mnau_column_trunk_mean              |Cannibalism vs Geological transport        | -2.55| 1.36e-02|*    |
|mnau_column_trunk_mean              |Cuevas Sepulcrales vs Carnivore            | -3.58| 8.44e-04|***  |
|mnau_column_trunk_mean              |Cuevas Sepulcrales vs Geological transport | -2.96| 4.42e-03|**   |
|mnau_column_trunk_mean              |Carnivore vs Geological transport          |  0.49| 6.28e-01|ns   |
|mnau_cv                             |Funerary Context vs Cannibalism            |  4.41| 3.38e-05|**** |
|mnau_cv                             |Funerary Context vs Cuevas Sepulcrales     |  3.65| 6.48e-04|***  |
|mnau_cv                             |Funerary Context vs Carnivore              |  6.48| 0.00e+00|**** |
|mnau_cv                             |Funerary Context vs Geological transport   |  6.14| 0.00e+00|**** |
|mnau_cv                             |Cannibalism vs Cuevas Sepulcrales          | -0.61| 5.99e-01|ns   |
|mnau_cv                             |Cannibalism vs Carnivore                   |  2.85| 6.15e-03|**   |
|mnau_cv                             |Cannibalism vs Geological transport        |  2.43| 1.88e-02|*    |
|mnau_cv                             |Cuevas Sepulcrales vs Carnivore            |  3.33| 1.73e-03|**   |
|mnau_cv                             |Cuevas Sepulcrales vs Geological transport |  2.92| 5.77e-03|**   |
|mnau_cv                             |Carnivore vs Geological transport          | -0.43| 6.69e-01|ns   |
|mnau_distal_appendicular_mean       |Funerary Context vs Cannibalism            | -4.09| 1.43e-04|***  |
|mnau_distal_appendicular_mean       |Funerary Context vs Cuevas Sepulcrales     | -3.14| 2.78e-03|**   |
|mnau_distal_appendicular_mean       |Funerary Context vs Carnivore              | -6.11| 0.00e+00|**** |
|mnau_distal_appendicular_mean       |Funerary Context vs Geological transport   | -6.20| 0.00e+00|**** |
|mnau_distal_appendicular_mean       |Cannibalism vs Cuevas Sepulcrales          |  0.78| 4.83e-01|ns   |
|mnau_distal_appendicular_mean       |Cannibalism vs Carnivore                   | -2.54| 1.39e-02|*    |
|mnau_distal_appendicular_mean       |Cannibalism vs Geological transport        | -2.72| 9.26e-03|**   |
|mnau_distal_appendicular_mean       |Cuevas Sepulcrales vs Carnivore            | -3.18| 2.78e-03|**   |
|mnau_distal_appendicular_mean       |Cuevas Sepulcrales vs Geological transport | -3.35| 2.01e-03|**   |
|mnau_distal_appendicular_mean       |Carnivore vs Geological transport          | -0.22| 8.28e-01|ns   |
|mnau_dominance_of_region_means      |Funerary Context vs Cannibalism            |  4.21| 8.63e-05|**** |
|mnau_dominance_of_region_means      |Funerary Context vs Cuevas Sepulcrales     |  3.42| 1.56e-03|**   |
|mnau_dominance_of_region_means      |Funerary Context vs Carnivore              |  5.47| 2.00e-07|**** |
|mnau_dominance_of_region_means      |Funerary Context vs Geological transport   |  6.16| 0.00e+00|**** |
|mnau_dominance_of_region_means      |Cannibalism vs Cuevas Sepulcrales          | -0.64| 5.82e-01|ns   |
|mnau_dominance_of_region_means      |Cannibalism vs Carnivore                   |  2.07| 4.78e-02|*    |
|mnau_dominance_of_region_means      |Cannibalism vs Geological transport        |  2.60| 1.44e-02|*    |
|mnau_dominance_of_region_means      |Cuevas Sepulcrales vs Carnivore            |  2.57| 1.44e-02|*    |
|mnau_dominance_of_region_means      |Cuevas Sepulcrales vs Geological transport |  3.11| 3.74e-03|**   |
|mnau_dominance_of_region_means      |Carnivore vs Geological transport          |  0.40| 6.88e-01|ns   |
|mnau_evenness_minus_dominance       |Funerary Context vs Cannibalism            | -4.30| 5.76e-05|**** |
|mnau_evenness_minus_dominance       |Funerary Context vs Cuevas Sepulcrales     | -3.60| 7.95e-04|***  |
|mnau_evenness_minus_dominance       |Funerary Context vs Carnivore              | -6.43| 0.00e+00|**** |
|mnau_evenness_minus_dominance       |Funerary Context vs Geological transport   | -6.22| 0.00e+00|**** |
|mnau_evenness_minus_dominance       |Cannibalism vs Cuevas Sepulcrales          |  0.56| 6.40e-01|ns   |
|mnau_evenness_minus_dominance       |Cannibalism vs Carnivore                   | -2.89| 5.50e-03|**   |
|mnau_evenness_minus_dominance       |Cannibalism vs Geological transport        | -2.59| 1.20e-02|*    |
|mnau_evenness_minus_dominance       |Cuevas Sepulcrales vs Carnivore            | -3.32| 1.78e-03|**   |
|mnau_evenness_minus_dominance       |Cuevas Sepulcrales vs Geological transport | -3.04| 3.99e-03|**   |
|mnau_evenness_minus_dominance       |Carnivore vs Geological transport          |  0.32| 7.47e-01|ns   |
|mnau_foot                           |Funerary Context vs Cannibalism            | -3.49| 1.63e-03|**   |
|mnau_foot                           |Funerary Context vs Cuevas Sepulcrales     | -3.05| 5.80e-03|**   |
|mnau_foot                           |Funerary Context vs Carnivore              | -5.47| 2.00e-07|**** |
|mnau_foot                           |Funerary Context vs Geological transport   | -5.49| 2.00e-07|**** |
|mnau_foot                           |Cannibalism vs Cuevas Sepulcrales          |  0.34| 8.11e-01|ns   |
|mnau_foot                           |Cannibalism vs Carnivore                   | -2.40| 2.03e-02|*    |
|mnau_foot                           |Cannibalism vs Geological transport        | -2.50| 1.77e-02|*    |
|mnau_foot                           |Cuevas Sepulcrales vs Carnivore            | -2.68| 1.23e-02|*    |
|mnau_foot                           |Cuevas Sepulcrales vs Geological transport | -2.77| 1.12e-02|*    |
|mnau_foot                           |Carnivore vs Geological transport          | -0.14| 8.90e-01|ns   |
|mnau_gini                           |Funerary Context vs Cannibalism            |  4.17| 1.01e-04|***  |
|mnau_gini                           |Funerary Context vs Cuevas Sepulcrales     |  3.86| 2.88e-04|***  |
|mnau_gini                           |Funerary Context vs Carnivore              |  6.48| 0.00e+00|**** |
|mnau_gini                           |Funerary Context vs Geological transport   |  6.31| 0.00e+00|**** |
|mnau_gini                           |Cannibalism vs Cuevas Sepulcrales          | -0.23| 8.20e-01|ns   |
|mnau_gini                           |Cannibalism vs Carnivore                   |  3.03| 4.10e-03|**   |
|mnau_gini                           |Cannibalism vs Geological transport        |  2.76| 7.16e-03|**   |
|mnau_gini                           |Cuevas Sepulcrales vs Carnivore            |  3.19| 2.83e-03|**   |
|mnau_gini                           |Cuevas Sepulcrales vs Geological transport |  2.93| 4.81e-03|**   |
|mnau_gini                           |Carnivore vs Geological transport          | -0.30| 8.20e-01|ns   |
|mnau_girdle_mean                    |Funerary Context vs Cannibalism            | -4.15| 8.43e-05|**** |
|mnau_girdle_mean                    |Funerary Context vs Cuevas Sepulcrales     | -4.57| 1.61e-05|**** |
|mnau_girdle_mean                    |Funerary Context vs Carnivore              | -6.54| 0.00e+00|**** |
|mnau_girdle_mean                    |Funerary Context vs Geological transport   | -5.62| 1.00e-07|**** |
|mnau_girdle_mean                    |Cannibalism vs Cuevas Sepulcrales          | -0.42| 6.74e-01|ns   |
|mnau_girdle_mean                    |Cannibalism vs Carnivore                   | -2.89| 7.83e-03|**   |
|mnau_girdle_mean                    |Cannibalism vs Geological transport        | -2.15| 4.54e-02|*    |
|mnau_girdle_mean                    |Cuevas Sepulcrales vs Carnivore            | -2.51| 2.04e-02|*    |
|mnau_girdle_mean                    |Cuevas Sepulcrales vs Geological transport | -1.78| 9.33e-02|ns   |
|mnau_girdle_mean                    |Carnivore vs Geological transport          |  0.59| 6.14e-01|ns   |
|mnau_hands                          |Funerary Context vs Cannibalism            | -3.43| 2.01e-03|**   |
|mnau_hands                          |Funerary Context vs Cuevas Sepulcrales     | -3.11| 4.71e-03|**   |
|mnau_hands                          |Funerary Context vs Carnivore              | -5.53| 3.00e-07|**** |
|mnau_hands                          |Funerary Context vs Geological transport   | -5.37| 4.00e-07|**** |
|mnau_hands                          |Cannibalism vs Cuevas Sepulcrales          |  0.24| 8.99e-01|ns   |
|mnau_hands                          |Cannibalism vs Carnivore                   | -2.50| 1.79e-02|*    |
|mnau_hands                          |Cannibalism vs Geological transport        | -2.44| 1.84e-02|*    |
|mnau_hands                          |Cuevas Sepulcrales vs Carnivore            | -2.68| 1.45e-02|*    |
|mnau_hands                          |Cuevas Sepulcrales vs Geological transport | -2.62| 1.46e-02|*    |
|mnau_hands                          |Carnivore vs Geological transport          |  0.00| 1.00e+00|ns   |
|mnau_heip_evenness                  |Funerary Context vs Cannibalism            | -4.14| 1.15e-04|***  |
|mnau_heip_evenness                  |Funerary Context vs Cuevas Sepulcrales     | -3.74| 4.57e-04|***  |
|mnau_heip_evenness                  |Funerary Context vs Carnivore              | -6.44| 0.00e+00|**** |
|mnau_heip_evenness                  |Funerary Context vs Geological transport   | -6.31| 0.00e+00|**** |
|mnau_heip_evenness                  |Cannibalism vs Cuevas Sepulcrales          |  0.30| 7.88e-01|ns   |
|mnau_heip_evenness                  |Cannibalism vs Carnivore                   | -3.01| 3.73e-03|**   |
|mnau_heip_evenness                  |Cannibalism vs Geological transport        | -2.78| 6.80e-03|**   |
|mnau_heip_evenness                  |Cuevas Sepulcrales vs Carnivore            | -3.24| 2.42e-03|**   |
|mnau_heip_evenness                  |Cuevas Sepulcrales vs Geological transport | -3.01| 3.73e-03|**   |
|mnau_heip_evenness                  |Carnivore vs Geological transport          |  0.27| 7.88e-01|ns   |
|mnau_inverse_simpson                |Funerary Context vs Cannibalism            | -4.42| 3.22e-05|**** |
|mnau_inverse_simpson                |Funerary Context vs Cuevas Sepulcrales     | -3.65| 6.44e-04|***  |
|mnau_inverse_simpson                |Funerary Context vs Carnivore              | -6.41| 0.00e+00|**** |
|mnau_inverse_simpson                |Funerary Context vs Geological transport   | -6.20| 0.00e+00|**** |
|mnau_inverse_simpson                |Cannibalism vs Cuevas Sepulcrales          |  0.62| 5.93e-01|ns   |
|mnau_inverse_simpson                |Cannibalism vs Carnivore                   | -2.78| 7.71e-03|**   |
|mnau_inverse_simpson                |Cannibalism vs Geological transport        | -2.48| 1.66e-02|*    |
|mnau_inverse_simpson                |Cuevas Sepulcrales vs Carnivore            | -3.27| 2.18e-03|**   |
|mnau_inverse_simpson                |Cuevas Sepulcrales vs Geological transport | -2.98| 4.88e-03|**   |
|mnau_inverse_simpson                |Carnivore vs Geological transport          |  0.33| 7.45e-01|ns   |
|mnau_legs                           |Funerary Context vs Cannibalism            | -4.22| 8.32e-05|**** |
|mnau_legs                           |Funerary Context vs Cuevas Sepulcrales     | -3.75| 4.46e-04|***  |
|mnau_legs                           |Funerary Context vs Carnivore              | -6.06| 0.00e+00|**** |
|mnau_legs                           |Funerary Context vs Geological transport   | -6.00| 0.00e+00|**** |
|mnau_legs                           |Cannibalism vs Cuevas Sepulcrales          |  0.36| 7.99e-01|ns   |
|mnau_legs                           |Cannibalism vs Carnivore                   | -2.40| 2.06e-02|*    |
|mnau_legs                           |Cannibalism vs Geological transport        | -2.45| 2.05e-02|*    |
|mnau_legs                           |Cuevas Sepulcrales vs Carnivore            | -2.69| 1.20e-02|*    |
|mnau_legs                           |Cuevas Sepulcrales vs Geological transport | -2.73| 1.20e-02|*    |
|mnau_legs                           |Carnivore vs Geological transport          | -0.09| 9.25e-01|ns   |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Cannibalism            | -4.40| 3.68e-05|**** |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Cuevas Sepulcrales     | -3.67| 5.98e-04|***  |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Carnivore              | -6.53| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean          |Funerary Context vs Geological transport   | -6.17| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Cuevas Sepulcrales          |  0.58| 6.24e-01|ns   |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Carnivore                   | -2.69| 1.01e-02|*    |
|mnau_limb_shaft_proxy_mean          |Cannibalism vs Geological transport        | -2.48| 1.67e-02|*    |
|mnau_limb_shaft_proxy_mean          |Cuevas Sepulcrales vs Carnivore            | -3.16| 3.10e-03|**   |
|mnau_limb_shaft_proxy_mean          |Cuevas Sepulcrales vs Geological transport | -2.94| 5.49e-03|**   |
|mnau_limb_shaft_proxy_mean          |Carnivore vs Geological transport          |  0.14| 8.92e-01|ns   |
|mnau_lower_appendicular_mean        |Funerary Context vs Cannibalism            | -4.80| 5.40e-06|**** |
|mnau_lower_appendicular_mean        |Funerary Context vs Cuevas Sepulcrales     | -3.90| 2.43e-04|***  |
|mnau_lower_appendicular_mean        |Funerary Context vs Carnivore              | -6.60| 0.00e+00|**** |
|mnau_lower_appendicular_mean        |Funerary Context vs Geological transport   | -6.43| 0.00e+00|**** |
|mnau_lower_appendicular_mean        |Cannibalism vs Cuevas Sepulcrales          |  0.73| 5.16e-01|ns   |
|mnau_lower_appendicular_mean        |Cannibalism vs Carnivore                   | -2.46| 1.96e-02|*    |
|mnau_lower_appendicular_mean        |Cannibalism vs Geological transport        | -2.42| 1.96e-02|*    |
|mnau_lower_appendicular_mean        |Cuevas Sepulcrales vs Carnivore            | -3.06| 4.41e-03|**   |
|mnau_lower_appendicular_mean        |Cuevas Sepulcrales vs Geological transport | -3.01| 4.41e-03|**   |
|mnau_lower_appendicular_mean        |Carnivore vs Geological transport          | -0.02| 9.87e-01|ns   |
|mnau_pelvic                         |Funerary Context vs Cannibalism            | -3.91| 2.32e-04|***  |
|mnau_pelvic                         |Funerary Context vs Cuevas Sepulcrales     | -4.40| 3.53e-05|**** |
|mnau_pelvic                         |Funerary Context vs Carnivore              | -5.76| 1.00e-07|**** |
|mnau_pelvic                         |Funerary Context vs Geological transport   | -5.22| 9.00e-07|**** |
|mnau_pelvic                         |Cannibalism vs Cuevas Sepulcrales          | -0.48| 7.01e-01|ns   |
|mnau_pelvic                         |Cannibalism vs Carnivore                   | -2.35| 3.71e-02|*    |
|mnau_pelvic                         |Cannibalism vs Geological transport        | -1.96| 7.67e-02|ns   |
|mnau_pelvic                         |Cuevas Sepulcrales vs Carnivore            | -1.93| 7.67e-02|ns   |
|mnau_pelvic                         |Cuevas Sepulcrales vs Geological transport | -1.54| 1.53e-01|ns   |
|mnau_pelvic                         |Carnivore vs Geological transport          |  0.30| 7.61e-01|ns   |
|mnau_postcranial_total_mean         |Funerary Context vs Cannibalism            | -4.72| 7.90e-06|**** |
|mnau_postcranial_total_mean         |Funerary Context vs Cuevas Sepulcrales     | -3.80| 3.61e-04|***  |
|mnau_postcranial_total_mean         |Funerary Context vs Carnivore              | -6.75| 0.00e+00|**** |
|mnau_postcranial_total_mean         |Funerary Context vs Geological transport   | -6.28| 0.00e+00|**** |
|mnau_postcranial_total_mean         |Cannibalism vs Cuevas Sepulcrales          |  0.75| 5.04e-01|ns   |
|mnau_postcranial_total_mean         |Cannibalism vs Carnivore                   | -2.66| 1.12e-02|*    |
|mnau_postcranial_total_mean         |Cannibalism vs Geological transport        | -2.34| 2.40e-02|*    |
|mnau_postcranial_total_mean         |Cuevas Sepulcrales vs Carnivore            | -3.27| 2.11e-03|**   |
|mnau_postcranial_total_mean         |Cuevas Sepulcrales vs Geological transport | -2.95| 5.37e-03|**   |
|mnau_postcranial_total_mean         |Carnivore vs Geological transport          |  0.23| 8.22e-01|ns   |
|mnau_proximal_appendicular_mean     |Funerary Context vs Cannibalism            | -4.61| 1.34e-05|**** |
|mnau_proximal_appendicular_mean     |Funerary Context vs Cuevas Sepulcrales     | -4.06| 1.21e-04|***  |
|mnau_proximal_appendicular_mean     |Funerary Context vs Carnivore              | -6.71| 0.00e+00|**** |
|mnau_proximal_appendicular_mean     |Funerary Context vs Geological transport   | -6.09| 0.00e+00|**** |
|mnau_proximal_appendicular_mean     |Cannibalism vs Cuevas Sepulcrales          |  0.42| 7.30e-01|ns   |
|mnau_proximal_appendicular_mean     |Cannibalism vs Carnivore                   | -2.70| 1.16e-02|*    |
|mnau_proximal_appendicular_mean     |Cannibalism vs Geological transport        | -2.25| 3.09e-02|*    |
|mnau_proximal_appendicular_mean     |Cuevas Sepulcrales vs Carnivore            | -3.04| 4.74e-03|**   |
|mnau_proximal_appendicular_mean     |Cuevas Sepulcrales vs Geological transport | -2.58| 1.40e-02|*    |
|mnau_proximal_appendicular_mean     |Carnivore vs Geological transport          |  0.35| 7.30e-01|ns   |
|mnau_region_mean_evenness           |Funerary Context vs Cannibalism            | -4.15| 1.09e-04|***  |
|mnau_region_mean_evenness           |Funerary Context vs Cuevas Sepulcrales     | -3.56| 9.44e-04|***  |
|mnau_region_mean_evenness           |Funerary Context vs Carnivore              | -5.96| 0.00e+00|**** |
|mnau_region_mean_evenness           |Funerary Context vs Geological transport   | -6.34| 0.00e+00|**** |
|mnau_region_mean_evenness           |Cannibalism vs Cuevas Sepulcrales          |  0.47| 7.06e-01|ns   |
|mnau_region_mean_evenness           |Cannibalism vs Carnivore                   | -2.56| 1.30e-02|*    |
|mnau_region_mean_evenness           |Cannibalism vs Geological transport        | -2.80| 7.36e-03|**   |
|mnau_region_mean_evenness           |Cuevas Sepulcrales vs Carnivore            | -2.93| 5.70e-03|**   |
|mnau_region_mean_evenness           |Cuevas Sepulcrales vs Geological transport | -3.17| 3.03e-03|**   |
|mnau_region_mean_evenness           |Carnivore vs Geological transport          | -0.14| 8.87e-01|ns   |
|mnau_shoulder                       |Funerary Context vs Cannibalism            | -3.51| 1.14e-03|**   |
|mnau_shoulder                       |Funerary Context vs Cuevas Sepulcrales     | -4.33| 4.89e-05|**** |
|mnau_shoulder                       |Funerary Context vs Carnivore              | -6.10| 0.00e+00|**** |
|mnau_shoulder                       |Funerary Context vs Geological transport   | -4.93| 4.10e-06|**** |
|mnau_shoulder                       |Cannibalism vs Cuevas Sepulcrales          | -0.77| 4.44e-01|ns   |
|mnau_shoulder                       |Cannibalism vs Carnivore                   | -2.96| 6.09e-03|**   |
|mnau_shoulder                       |Cannibalism vs Geological transport        | -1.98| 6.81e-02|ns   |
|mnau_shoulder                       |Cuevas Sepulcrales vs Carnivore            | -2.29| 3.66e-02|*    |
|mnau_shoulder                       |Cuevas Sepulcrales vs Geological transport | -1.33| 2.29e-01|ns   |
|mnau_shoulder                       |Carnivore vs Geological transport          |  0.81| 4.44e-01|ns   |
|mnau_simpson_dominance              |Funerary Context vs Cannibalism            |  4.42| 3.22e-05|**** |
|mnau_simpson_dominance              |Funerary Context vs Cuevas Sepulcrales     |  3.65| 6.44e-04|***  |
|mnau_simpson_dominance              |Funerary Context vs Carnivore              |  6.41| 0.00e+00|**** |
|mnau_simpson_dominance              |Funerary Context vs Geological transport   |  6.20| 0.00e+00|**** |
|mnau_simpson_dominance              |Cannibalism vs Cuevas Sepulcrales          | -0.62| 5.93e-01|ns   |
|mnau_simpson_dominance              |Cannibalism vs Carnivore                   |  2.78| 7.71e-03|**   |
|mnau_simpson_dominance              |Cannibalism vs Geological transport        |  2.48| 1.66e-02|*    |
|mnau_simpson_dominance              |Cuevas Sepulcrales vs Carnivore            |  3.27| 2.18e-03|**   |
|mnau_simpson_dominance              |Cuevas Sepulcrales vs Geological transport |  2.98| 4.88e-03|**   |
|mnau_simpson_dominance              |Carnivore vs Geological transport          | -0.33| 7.45e-01|ns   |
|mnau_simpson_evenness               |Funerary Context vs Cannibalism            | -4.42| 3.22e-05|**** |
|mnau_simpson_evenness               |Funerary Context vs Cuevas Sepulcrales     | -3.65| 6.44e-04|***  |
|mnau_simpson_evenness               |Funerary Context vs Carnivore              | -6.41| 0.00e+00|**** |
|mnau_simpson_evenness               |Funerary Context vs Geological transport   | -6.20| 0.00e+00|**** |
|mnau_simpson_evenness               |Cannibalism vs Cuevas Sepulcrales          |  0.62| 5.93e-01|ns   |
|mnau_simpson_evenness               |Cannibalism vs Carnivore                   | -2.78| 7.71e-03|**   |
|mnau_simpson_evenness               |Cannibalism vs Geological transport        | -2.48| 1.66e-02|*    |
|mnau_simpson_evenness               |Cuevas Sepulcrales vs Carnivore            | -3.27| 2.18e-03|**   |
|mnau_simpson_evenness               |Cuevas Sepulcrales vs Geological transport | -2.98| 4.88e-03|**   |
|mnau_simpson_evenness               |Carnivore vs Geological transport          |  0.33| 7.45e-01|ns   |
|mnau_top2_share_mcnaughton          |Funerary Context vs Cannibalism            |  4.18| 9.88e-05|**** |
|mnau_top2_share_mcnaughton          |Funerary Context vs Cuevas Sepulcrales     |  3.74| 4.56e-04|***  |
|mnau_top2_share_mcnaughton          |Funerary Context vs Carnivore              |  6.49| 0.00e+00|**** |
|mnau_top2_share_mcnaughton          |Funerary Context vs Geological transport   |  6.46| 0.00e+00|**** |
|mnau_top2_share_mcnaughton          |Cannibalism vs Cuevas Sepulcrales          | -0.33| 8.23e-01|ns   |
|mnau_top2_share_mcnaughton          |Cannibalism vs Carnivore                   |  3.03| 3.48e-03|**   |
|mnau_top2_share_mcnaughton          |Cannibalism vs Geological transport        |  2.89| 4.78e-03|**   |
|mnau_top2_share_mcnaughton          |Cuevas Sepulcrales vs Carnivore            |  3.28| 2.09e-03|**   |
|mnau_top2_share_mcnaughton          |Cuevas Sepulcrales vs Geological transport |  3.15| 2.76e-03|**   |
|mnau_top2_share_mcnaughton          |Carnivore vs Geological transport          | -0.19| 8.51e-01|ns   |
|mnau_upper_appendicular_mean        |Funerary Context vs Cannibalism            | -4.41| 3.52e-05|**** |
|mnau_upper_appendicular_mean        |Funerary Context vs Cuevas Sepulcrales     | -4.13| 9.13e-05|**** |
|mnau_upper_appendicular_mean        |Funerary Context vs Carnivore              | -6.98| 0.00e+00|**** |
|mnau_upper_appendicular_mean        |Funerary Context vs Geological transport   | -6.09| 0.00e+00|**** |
|mnau_upper_appendicular_mean        |Cannibalism vs Cuevas Sepulcrales          |  0.19| 8.49e-01|ns   |
|mnau_upper_appendicular_mean        |Cannibalism vs Carnivore                   | -3.09| 3.29e-03|**   |
|mnau_upper_appendicular_mean        |Cannibalism vs Geological transport        | -2.39| 2.10e-02|*    |
|mnau_upper_appendicular_mean        |Cuevas Sepulcrales vs Carnivore            | -3.23| 2.45e-03|**   |
|mnau_upper_appendicular_mean        |Cuevas Sepulcrales vs Geological transport | -2.53| 1.62e-02|*    |
|mnau_upper_appendicular_mean        |Carnivore vs Geological transport          |  0.56| 6.40e-01|ns   |
|mne_arms                            |Funerary Context vs Cannibalism            | -1.69| 1.14e-01|ns   |
|mne_arms                            |Funerary Context vs Cuevas Sepulcrales     | -3.27| 2.14e-03|**   |
|mne_arms                            |Funerary Context vs Carnivore              | -6.13| 0.00e+00|**** |
|mne_arms                            |Funerary Context vs Geological transport   | -5.88| 0.00e+00|**** |
|mne_arms                            |Cannibalism vs Cuevas Sepulcrales          | -1.40| 1.79e-01|ns   |
|mne_arms                            |Cannibalism vs Carnivore                   | -4.33| 5.00e-05|**** |
|mne_arms                            |Cannibalism vs Geological transport        | -4.16| 8.00e-05|**** |
|mne_arms                            |Cuevas Sepulcrales vs Carnivore            | -3.10| 3.17e-03|**   |
|mne_arms                            |Cuevas Sepulcrales vs Geological transport | -2.97| 4.32e-03|**   |
|mne_arms                            |Carnivore vs Geological transport          |  0.06| 9.52e-01|ns   |
|mne_cranial_share                   |Funerary Context vs Cannibalism            |  3.91| 4.60e-04|***  |
|mne_cranial_share                   |Funerary Context vs Cuevas Sepulcrales     |  2.12| 5.66e-02|ns   |
|mne_cranial_share                   |Funerary Context vs Carnivore              |  2.28| 4.50e-02|*    |
|mne_cranial_share                   |Funerary Context vs Geological transport   |  5.11| 3.20e-06|**** |
|mne_cranial_share                   |Cannibalism vs Cuevas Sepulcrales          | -1.52| 1.61e-01|ns   |
|mne_cranial_share                   |Cannibalism vs Carnivore                   | -0.81| 4.62e-01|ns   |
|mne_cranial_share                   |Cannibalism vs Geological transport        |  1.86| 9.08e-02|ns   |
|mne_cranial_share                   |Cuevas Sepulcrales vs Carnivore            |  0.48| 6.28e-01|ns   |
|mne_cranial_share                   |Cuevas Sepulcrales vs Geological transport |  3.10| 6.38e-03|**   |
|mne_cranial_share                   |Carnivore vs Geological transport          |  2.35| 4.50e-02|*    |
|postcranial_dominance_refined       |Funerary Context vs Cannibalism            |  2.91| 7.21e-03|**   |
|postcranial_dominance_refined       |Funerary Context vs Cuevas Sepulcrales     |  4.61| 2.05e-05|**** |
|postcranial_dominance_refined       |Funerary Context vs Carnivore              |  6.19| 0.00e+00|**** |
|postcranial_dominance_refined       |Funerary Context vs Geological transport   |  3.44| 1.43e-03|**   |
|postcranial_dominance_refined       |Cannibalism vs Cuevas Sepulcrales          |  1.42| 1.96e-01|ns   |
|postcranial_dominance_refined       |Cannibalism vs Carnivore                   |  3.73| 6.35e-04|***  |
|postcranial_dominance_refined       |Cannibalism vs Geological transport        |  1.78| 1.06e-01|ns   |
|postcranial_dominance_refined       |Cuevas Sepulcrales vs Carnivore            |  2.66| 1.32e-02|*    |
|postcranial_dominance_refined       |Cuevas Sepulcrales vs Geological transport |  0.95| 3.42e-01|ns   |
|postcranial_dominance_refined       |Carnivore vs Geological transport          | -0.97| 3.42e-01|ns   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 12.71, R² = 0.333, p = 0.0001.
PCA variance explained: PC1 56.1%, PC2 9.5%, PC3 6.4% (cumulative 71.9%).
Dispersion caveat (PERMDISP): p = 0.028 — unequal group spread, read the location difference with care.

Top PC1 loadings:

|Feature                     |    PC1|    PC2|    PC3|
|:---------------------------|------:|------:|------:|
|mnau_postcranial_total_mean | -0.161|  0.137| -0.018|
|mnau_appendicular_mean      | -0.160|  0.135|  0.036|
|mnau_gini                   |  0.158|  0.119| -0.003|
|mnau_top2_share_mcnaughton  |  0.158|  0.140|  0.006|
|mnau_inverse_simpson        | -0.158| -0.109|  0.002|
|mnau_simpson_evenness       | -0.158| -0.109|  0.002|
|mnau_heip_evenness          | -0.157| -0.134| -0.003|
|effective_sections_hill1    | -0.157| -0.134| -0.003|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
