# Accumulation process
*Automated taphonomic_context × skeletal-part representation*

- **Grouping column:** `taphonomic_context` (mode = single)
- **Groups (n):** Funerary Context = 49; Cannibalism = 25; Sepulchral Cave = 25; Carnivore = 17; Geological transport = 12
- **Sites analysed:** 128  |  **features screened:** 50

## Hypothesis

**H:** Different accumulation causes produce different body-part profiles.

**Expected pattern:** Funerary contexts more anatomically balanced; carnivore/geological transport loses small, fragile, axial, low-density elements; cannibalism shows selective absence/over-representation of processed parts.

**Why it matters:** Strongest hypothesis: accumulation cause is directly linked to skeletal survival, transport and human/carnivore behaviour.


## Summary

46 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mnau_upper_appendicular_mean** (ε² = 0.660, FDR p = 6.9e-16). PERMANOVA pseudo-F = 15.22, p = 0.0001; PC1–PC3 explain 74.5% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 186 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 39 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2|  p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|--------:|:----------|:-----------|
|mnau_upper_appendicular_mean                 |  0.660| 0.00e+00|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.635| 0.00e+00|large      |significant |
|mnau_postcranial_total_mean                  |  0.617| 0.00e+00|large      |significant |
|mnau_appendicular_mean                       |  0.613| 0.00e+00|large      |significant |
|low_density_survival_index                   |  0.606| 0.00e+00|large      |significant |
|effective_sections_hill1                     |  0.598| 0.00e+00|large      |significant |
|mnau_heip_evenness                           |  0.598| 0.00e+00|large      |significant |
|mnau_gini                                    |  0.596| 0.00e+00|large      |significant |
|mnau_evenness_minus_dominance                |  0.596| 0.00e+00|large      |significant |
|mnau_cv                                      |  0.595| 0.00e+00|large      |significant |
|mnau_simpson_dominance                       |  0.595| 0.00e+00|large      |significant |
|mnau_inverse_simpson                         |  0.595| 0.00e+00|large      |significant |
|mnau_simpson_evenness                        |  0.595| 0.00e+00|large      |significant |
|all_sections_dominance                       |  0.582| 0.00e+00|large      |significant |
|mnau_lower_appendicular_mean                 |  0.575| 0.00e+00|large      |significant |
|lower_appendicular_continuity_hm             |  0.574| 0.00e+00|large      |significant |
|low_density_axial_survival                   |  0.572| 0.00e+00|large      |significant |
|mnau_distal_appendicular_mean                |  0.569| 0.00e+00|large      |significant |
|mnau_column_trunk_mean                       |  0.568| 0.00e+00|large      |significant |
|mnau_region_mean_evenness                    |  0.565| 0.00e+00|large      |significant |
|mnau_proximal_appendicular_mean              |  0.565| 0.00e+00|large      |significant |
|mnau_arms                                    |  0.563| 0.00e+00|large      |significant |
|mnau_axial_main_mean                         |  0.552| 0.00e+00|large      |significant |
|mnau_dominance_of_region_means               |  0.536| 0.00e+00|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.533| 0.00e+00|large      |significant |
|density_evenness                             |  0.523| 0.00e+00|large      |significant |
|mnau_girdle_mean                             |  0.521| 0.00e+00|large      |significant |
|distal_appendicular_continuity_hm            |  0.508| 0.00e+00|large      |significant |
|mne_arms                                     |  0.501| 0.00e+00|large      |significant |
|mnau_shoulder                                |  0.484| 0.00e+00|large      |significant |
|mnau_legs                                    |  0.478| 0.00e+00|large      |significant |
|dominance_gap_all                            |  0.474| 0.00e+00|large      |significant |
|postcranial_dominance_refined                |  0.468| 0.00e+00|large      |significant |
|mnau_hands                                   |  0.446| 0.00e+00|large      |significant |
|low_density_share                            |  0.440| 0.00e+00|large      |significant |
|mnau_foot                                    |  0.433| 0.00e+00|large      |significant |
|appendicular_dominance                       |  0.425| 0.00e+00|large      |significant |
|appendicular_dominance_refined               |  0.425| 0.00e+00|large      |significant |
|mnau_pelvic                                  |  0.421| 0.00e+00|large      |significant |
|lower_appendicular_evenness                  |  0.325| 1.00e-07|large      |significant |
|lower_appendicular_evenness_refined          |  0.325| 1.00e-07|large      |significant |
|mnau_arms_legs_diff                          |  0.295| 0.00e+00|large      |significant |
|dominant_axial_share                         |  0.291| 1.00e-07|large      |significant |
|mne_cranial_share                            |  0.274| 1.00e-07|large      |significant |
|mnau_vertebrae_to_thorax_ratio               |  0.189| 2.00e-05|large      |significant |
|density_adjusted_appendicular_axial_contrast |  0.132| 4.87e-04|moderate   |significant |
|mne_vertebrae_to_thorax_ratio                |  0.040| 6.72e-02|small      |n.s.        |
|mnau_arms_legs_logratio                      |  0.002| 3.85e-01|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.002| 3.85e-01|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.023| 8.78e-01|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                                      |Contrast                                 |     Z|  p (adj)|Sig  |
|:--------------------------------------------|:----------------------------------------|-----:|--------:|:----|
|all_sections_dominance                       |Funerary Context vs Cannibalism          |  4.31| 5.43e-05|**** |
|all_sections_dominance                       |Funerary Context vs Sepulchral Cave      |  3.69| 5.51e-04|***  |
|all_sections_dominance                       |Funerary Context vs Carnivore            |  6.52| 0.00e+00|**** |
|all_sections_dominance                       |Funerary Context vs Geological transport |  6.71| 0.00e+00|**** |
|all_sections_dominance                       |Cannibalism vs Sepulchral Cave           | -0.54| 5.93e-01|ns   |
|all_sections_dominance                       |Cannibalism vs Carnivore                 |  2.64| 1.02e-02|*    |
|all_sections_dominance                       |Cannibalism vs Geological transport      |  3.14| 2.69e-03|**   |
|all_sections_dominance                       |Sepulchral Cave vs Carnivore             |  3.11| 2.69e-03|**   |
|all_sections_dominance                       |Sepulchral Cave vs Geological transport  |  3.57| 7.11e-04|***  |
|all_sections_dominance                       |Carnivore vs Geological transport        |  0.62| 5.93e-01|ns   |
|appendicular_dominance                       |Funerary Context vs Cannibalism          |  2.47| 1.96e-02|*    |
|appendicular_dominance                       |Funerary Context vs Sepulchral Cave      |  3.60| 7.84e-04|***  |
|appendicular_dominance                       |Funerary Context vs Carnivore            |  5.96| 0.00e+00|**** |
|appendicular_dominance                       |Funerary Context vs Geological transport |  4.09| 2.13e-04|***  |
|appendicular_dominance                       |Cannibalism vs Sepulchral Cave           |  0.91| 4.04e-01|ns   |
|appendicular_dominance                       |Cannibalism vs Carnivore                 |  3.64| 7.84e-04|***  |
|appendicular_dominance                       |Cannibalism vs Geological transport      |  2.78| 9.10e-03|**   |
|appendicular_dominance                       |Sepulchral Cave vs Carnivore             |  2.94| 6.56e-03|**   |
|appendicular_dominance                       |Sepulchral Cave vs Geological transport  |  2.31| 2.63e-02|*    |
|appendicular_dominance                       |Carnivore vs Geological transport        |  0.36| 7.16e-01|ns   |
|appendicular_dominance_refined               |Funerary Context vs Cannibalism          |  2.47| 1.96e-02|*    |
|appendicular_dominance_refined               |Funerary Context vs Sepulchral Cave      |  3.60| 7.84e-04|***  |
|appendicular_dominance_refined               |Funerary Context vs Carnivore            |  5.96| 0.00e+00|**** |
|appendicular_dominance_refined               |Funerary Context vs Geological transport |  4.09| 2.13e-04|***  |
|appendicular_dominance_refined               |Cannibalism vs Sepulchral Cave           |  0.91| 4.04e-01|ns   |
|appendicular_dominance_refined               |Cannibalism vs Carnivore                 |  3.64| 7.84e-04|***  |
|appendicular_dominance_refined               |Cannibalism vs Geological transport      |  2.78| 9.10e-03|**   |
|appendicular_dominance_refined               |Sepulchral Cave vs Carnivore             |  2.94| 6.56e-03|**   |
|appendicular_dominance_refined               |Sepulchral Cave vs Geological transport  |  2.31| 2.63e-02|*    |
|appendicular_dominance_refined               |Carnivore vs Geological transport        |  0.36| 7.16e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Funerary Context vs Cannibalism          | -1.82| 1.38e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Funerary Context vs Sepulchral Cave      | -1.38| 2.37e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Funerary Context vs Carnivore            |  0.09| 9.32e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Funerary Context vs Geological transport | -4.23| 2.36e-04|***  |
|density_adjusted_appendicular_axial_contrast |Cannibalism vs Sepulchral Cave           |  0.38| 7.84e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Cannibalism vs Carnivore                 |  1.50| 2.23e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Cannibalism vs Geological transport      | -2.60| 2.30e-02|*    |
|density_adjusted_appendicular_axial_contrast |Sepulchral Cave vs Carnivore             |  1.16| 3.08e-01|ns   |
|density_adjusted_appendicular_axial_contrast |Sepulchral Cave vs Geological transport  | -2.91| 1.21e-02|*    |
|density_adjusted_appendicular_axial_contrast |Carnivore vs Geological transport        | -3.68| 1.19e-03|**   |
|density_evenness                             |Funerary Context vs Cannibalism          | -3.46| 1.07e-03|**   |
|density_evenness                             |Funerary Context vs Sepulchral Cave      | -2.90| 4.63e-03|**   |
|density_evenness                             |Funerary Context vs Carnivore            | -6.38| 0.00e+00|**** |
|density_evenness                             |Funerary Context vs Geological transport | -6.36| 0.00e+00|**** |
|density_evenness                             |Cannibalism vs Sepulchral Cave           |  0.48| 6.68e-01|ns   |
|density_evenness                             |Cannibalism vs Carnivore                 | -3.16| 2.23e-03|**   |
|density_evenness                             |Cannibalism vs Geological transport      | -3.41| 1.07e-03|**   |
|density_evenness                             |Sepulchral Cave vs Carnivore             | -3.58| 8.62e-04|***  |
|density_evenness                             |Sepulchral Cave vs Geological transport  | -3.80| 4.80e-04|***  |
|density_evenness                             |Carnivore vs Geological transport        | -0.43| 6.68e-01|ns   |
|distal_appendicular_continuity_hm            |Funerary Context vs Cannibalism          | -3.03| 3.51e-03|**   |
|distal_appendicular_continuity_hm            |Funerary Context vs Sepulchral Cave      | -2.85| 5.39e-03|**   |
|distal_appendicular_continuity_hm            |Funerary Context vs Carnivore            | -6.42| 0.00e+00|**** |
|distal_appendicular_continuity_hm            |Funerary Context vs Geological transport | -6.34| 0.00e+00|**** |
|distal_appendicular_continuity_hm            |Cannibalism vs Sepulchral Cave           |  0.15| 8.80e-01|ns   |
|distal_appendicular_continuity_hm            |Cannibalism vs Carnivore                 | -3.38| 1.20e-03|**   |
|distal_appendicular_continuity_hm            |Cannibalism vs Geological transport      | -3.70| 5.41e-04|***  |
|distal_appendicular_continuity_hm            |Sepulchral Cave vs Carnivore             | -3.52| 8.71e-04|***  |
|distal_appendicular_continuity_hm            |Sepulchral Cave vs Geological transport  | -3.82| 4.42e-04|***  |
|distal_appendicular_continuity_hm            |Carnivore vs Geological transport        | -0.63| 5.90e-01|ns   |
|dominance_gap_all                            |Funerary Context vs Cannibalism          |  3.68| 5.74e-04|***  |
|dominance_gap_all                            |Funerary Context vs Sepulchral Cave      |  2.69| 1.02e-02|*    |
|dominance_gap_all                            |Funerary Context vs Carnivore            |  5.74| 0.00e+00|**** |
|dominance_gap_all                            |Funerary Context vs Geological transport |  6.32| 0.00e+00|**** |
|dominance_gap_all                            |Cannibalism vs Sepulchral Cave           | -0.86| 3.88e-01|ns   |
|dominance_gap_all                            |Cannibalism vs Carnivore                 |  2.41| 2.00e-02|*    |
|dominance_gap_all                            |Cannibalism vs Geological transport      |  3.22| 2.54e-03|**   |
|dominance_gap_all                            |Sepulchral Cave vs Carnivore             |  3.16| 2.66e-03|**   |
|dominance_gap_all                            |Sepulchral Cave vs Geological transport  |  3.92| 2.99e-04|***  |
|dominance_gap_all                            |Carnivore vs Geological transport        |  0.89| 3.88e-01|ns   |
|dominant_axial_share                         |Funerary Context vs Cannibalism          |  4.01| 3.10e-04|***  |
|dominant_axial_share                         |Funerary Context vs Sepulchral Cave      |  3.42| 2.11e-03|**   |
|dominant_axial_share                         |Funerary Context vs Carnivore            |  2.43| 2.52e-02|*    |
|dominant_axial_share                         |Funerary Context vs Geological transport |  5.55| 3.00e-07|**** |
|dominant_axial_share                         |Cannibalism vs Sepulchral Cave           | -0.51| 6.20e-01|ns   |
|dominant_axial_share                         |Cannibalism vs Carnivore                 | -0.96| 4.24e-01|ns   |
|dominant_axial_share                         |Cannibalism vs Geological transport      |  2.29| 3.15e-02|*    |
|dominant_axial_share                         |Sepulchral Cave vs Carnivore             | -0.50| 6.20e-01|ns   |
|dominant_axial_share                         |Sepulchral Cave vs Geological transport  |  2.70| 1.38e-02|*    |
|dominant_axial_share                         |Carnivore vs Geological transport        |  2.93| 8.48e-03|**   |
|effective_sections_hill1                     |Funerary Context vs Cannibalism          | -3.89| 3.40e-04|***  |
|effective_sections_hill1                     |Funerary Context vs Sepulchral Cave      | -3.76| 4.31e-04|***  |
|effective_sections_hill1                     |Funerary Context vs Carnivore            | -6.79| 0.00e+00|**** |
|effective_sections_hill1                     |Funerary Context vs Geological transport | -6.72| 0.00e+00|**** |
|effective_sections_hill1                     |Cannibalism vs Sepulchral Cave           |  0.11| 9.10e-01|ns   |
|effective_sections_hill1                     |Cannibalism vs Carnivore                 | -3.21| 1.67e-03|**   |
|effective_sections_hill1                     |Cannibalism vs Geological transport      | -3.45| 9.43e-04|***  |
|effective_sections_hill1                     |Sepulchral Cave vs Carnivore             | -3.31| 1.35e-03|**   |
|effective_sections_hill1                     |Sepulchral Cave vs Geological transport  | -3.54| 8.06e-04|***  |
|effective_sections_hill1                     |Carnivore vs Geological transport        | -0.42| 7.49e-01|ns   |
|low_density_axial_survival                   |Funerary Context vs Cannibalism          | -4.12| 1.27e-04|***  |
|low_density_axial_survival                   |Funerary Context vs Sepulchral Cave      | -2.92| 4.59e-03|**   |
|low_density_axial_survival                   |Funerary Context vs Carnivore            | -7.02| 0.00e+00|**** |
|low_density_axial_survival                   |Funerary Context vs Geological transport | -6.31| 0.00e+00|**** |
|low_density_axial_survival                   |Cannibalism vs Sepulchral Cave           |  1.05| 3.29e-01|ns   |
|low_density_axial_survival                   |Cannibalism vs Carnivore                 | -3.06| 3.63e-03|**   |
|low_density_axial_survival                   |Cannibalism vs Geological transport      | -2.91| 4.59e-03|**   |
|low_density_axial_survival                   |Sepulchral Cave vs Carnivore             | -4.01| 1.55e-04|***  |
|low_density_axial_survival                   |Sepulchral Cave vs Geological transport  | -3.75| 3.58e-04|***  |
|low_density_axial_survival                   |Carnivore vs Geological transport        | -0.15| 8.80e-01|ns   |
|low_density_share                            |Funerary Context vs Cannibalism          | -3.30| 1.92e-03|**   |
|low_density_share                            |Funerary Context vs Sepulchral Cave      | -2.25| 3.04e-02|*    |
|low_density_share                            |Funerary Context vs Carnivore            | -5.85| 0.00e+00|**** |
|low_density_share                            |Funerary Context vs Geological transport | -5.85| 0.00e+00|**** |
|low_density_share                            |Cannibalism vs Sepulchral Cave           |  0.91| 4.02e-01|ns   |
|low_density_share                            |Cannibalism vs Carnivore                 | -2.80| 7.31e-03|**   |
|low_density_share                            |Cannibalism vs Geological transport      | -3.06| 3.71e-03|**   |
|low_density_share                            |Sepulchral Cave vs Carnivore             | -3.59| 8.29e-04|***  |
|low_density_share                            |Sepulchral Cave vs Geological transport  | -3.79| 4.96e-04|***  |
|low_density_share                            |Carnivore vs Geological transport        | -0.41| 6.80e-01|ns   |
|low_density_survival_index                   |Funerary Context vs Cannibalism          | -4.26| 6.88e-05|**** |
|low_density_survival_index                   |Funerary Context vs Sepulchral Cave      | -3.42| 1.04e-03|**   |
|low_density_survival_index                   |Funerary Context vs Carnivore            | -7.28| 0.00e+00|**** |
|low_density_survival_index                   |Funerary Context vs Geological transport | -6.41| 0.00e+00|**** |
|low_density_survival_index                   |Cannibalism vs Sepulchral Cave           |  0.73| 5.20e-01|ns   |
|low_density_survival_index                   |Cannibalism vs Carnivore                 | -3.19| 2.01e-03|**   |
|low_density_survival_index                   |Cannibalism vs Geological transport      | -2.90| 4.65e-03|**   |
|low_density_survival_index                   |Sepulchral Cave vs Carnivore             | -3.85| 3.00e-04|***  |
|low_density_survival_index                   |Sepulchral Cave vs Geological transport  | -3.49| 9.80e-04|***  |
|low_density_survival_index                   |Carnivore vs Geological transport        | -0.04| 9.68e-01|ns   |
|lower_appendicular_continuity_hm             |Funerary Context vs Cannibalism          | -3.37| 1.09e-03|**   |
|lower_appendicular_continuity_hm             |Funerary Context vs Sepulchral Cave      | -3.83| 3.21e-04|***  |
|lower_appendicular_continuity_hm             |Funerary Context vs Carnivore            | -6.70| 0.00e+00|**** |
|lower_appendicular_continuity_hm             |Funerary Context vs Geological transport | -6.75| 0.00e+00|**** |
|lower_appendicular_continuity_hm             |Cannibalism vs Sepulchral Cave           | -0.40| 6.87e-01|ns   |
|lower_appendicular_continuity_hm             |Cannibalism vs Carnivore                 | -3.37| 1.09e-03|**   |
|lower_appendicular_continuity_hm             |Cannibalism vs Geological transport      | -3.83| 3.21e-04|***  |
|lower_appendicular_continuity_hm             |Sepulchral Cave vs Carnivore             | -3.01| 3.29e-03|**   |
|lower_appendicular_continuity_hm             |Sepulchral Cave vs Geological transport  | -3.51| 9.03e-04|***  |
|lower_appendicular_continuity_hm             |Carnivore vs Geological transport        | -0.76| 4.97e-01|ns   |
|lower_appendicular_evenness                  |Funerary Context vs Cannibalism          | -2.41| 3.19e-02|*    |
|lower_appendicular_evenness                  |Funerary Context vs Sepulchral Cave      | -3.77| 8.20e-04|***  |
|lower_appendicular_evenness                  |Funerary Context vs Carnivore            | -4.95| 7.30e-06|**** |
|lower_appendicular_evenness                  |Funerary Context vs Geological transport | -3.30| 3.22e-03|**   |
|lower_appendicular_evenness                  |Cannibalism vs Sepulchral Cave           | -1.10| 3.03e-01|ns   |
|lower_appendicular_evenness                  |Cannibalism vs Carnivore                 | -2.93| 8.48e-03|**   |
|lower_appendicular_evenness                  |Cannibalism vs Geological transport      | -2.20| 4.58e-02|*    |
|lower_appendicular_evenness                  |Sepulchral Cave vs Carnivore             | -2.12| 4.87e-02|*    |
|lower_appendicular_evenness                  |Sepulchral Cave vs Geological transport  | -1.70| 1.12e-01|ns   |
|lower_appendicular_evenness                  |Carnivore vs Geological transport        | -0.37| 7.11e-01|ns   |
|lower_appendicular_evenness_refined          |Funerary Context vs Cannibalism          | -2.41| 3.19e-02|*    |
|lower_appendicular_evenness_refined          |Funerary Context vs Sepulchral Cave      | -3.77| 8.20e-04|***  |
|lower_appendicular_evenness_refined          |Funerary Context vs Carnivore            | -4.95| 7.30e-06|**** |
|lower_appendicular_evenness_refined          |Funerary Context vs Geological transport | -3.30| 3.22e-03|**   |
|lower_appendicular_evenness_refined          |Cannibalism vs Sepulchral Cave           | -1.10| 3.03e-01|ns   |
|lower_appendicular_evenness_refined          |Cannibalism vs Carnivore                 | -2.93| 8.48e-03|**   |
|lower_appendicular_evenness_refined          |Cannibalism vs Geological transport      | -2.20| 4.58e-02|*    |
|lower_appendicular_evenness_refined          |Sepulchral Cave vs Carnivore             | -2.12| 4.87e-02|*    |
|lower_appendicular_evenness_refined          |Sepulchral Cave vs Geological transport  | -1.70| 1.12e-01|ns   |
|lower_appendicular_evenness_refined          |Carnivore vs Geological transport        | -0.37| 7.11e-01|ns   |
|mnau_appendicular_mean                       |Funerary Context vs Cannibalism          | -4.74| 7.00e-06|**** |
|mnau_appendicular_mean                       |Funerary Context vs Sepulchral Cave      | -4.00| 1.60e-04|***  |
|mnau_appendicular_mean                       |Funerary Context vs Carnivore            | -6.83| 0.00e+00|**** |
|mnau_appendicular_mean                       |Funerary Context vs Geological transport | -6.81| 0.00e+00|**** |
|mnau_appendicular_mean                       |Cannibalism vs Sepulchral Cave           |  0.65| 5.17e-01|ns   |
|mnau_appendicular_mean                       |Cannibalism vs Carnivore                 | -2.41| 2.01e-02|*    |
|mnau_appendicular_mean                       |Cannibalism vs Geological transport      | -2.93| 4.90e-03|**   |
|mnau_appendicular_mean                       |Sepulchral Cave vs Carnivore             | -2.99| 4.65e-03|**   |
|mnau_appendicular_mean                       |Sepulchral Cave vs Geological transport  | -3.45| 1.13e-03|**   |
|mnau_appendicular_mean                       |Carnivore vs Geological transport        | -0.72| 5.17e-01|ns   |
|mnau_arms                                    |Funerary Context vs Cannibalism          | -3.85| 4.00e-04|***  |
|mnau_arms                                    |Funerary Context vs Sepulchral Cave      | -3.37| 1.24e-03|**   |
|mnau_arms                                    |Funerary Context vs Carnivore            | -7.08| 0.00e+00|**** |
|mnau_arms                                    |Funerary Context vs Geological transport | -6.21| 0.00e+00|**** |
|mnau_arms                                    |Cannibalism vs Sepulchral Cave           |  0.41| 7.56e-01|ns   |
|mnau_arms                                    |Cannibalism vs Carnivore                 | -3.33| 1.24e-03|**   |
|mnau_arms                                    |Cannibalism vs Geological transport      | -3.00| 3.38e-03|**   |
|mnau_arms                                    |Sepulchral Cave vs Carnivore             | -3.70| 5.39e-04|***  |
|mnau_arms                                    |Sepulchral Cave vs Geological transport  | -3.33| 1.24e-03|**   |
|mnau_arms                                    |Carnivore vs Geological transport        | -0.02| 9.86e-01|ns   |
|mnau_arms_legs_diff                          |Funerary Context vs Cannibalism          |  3.56| 1.22e-03|**   |
|mnau_arms_legs_diff                          |Funerary Context vs Sepulchral Cave      |  3.02| 6.24e-03|**   |
|mnau_arms_legs_diff                          |Funerary Context vs Carnivore            |  4.73| 1.15e-05|**** |
|mnau_arms_legs_diff                          |Funerary Context vs Geological transport |  4.89| 1.03e-05|**** |
|mnau_arms_legs_diff                          |Cannibalism vs Sepulchral Cave           | -0.47| 6.38e-01|ns   |
|mnau_arms_legs_diff                          |Cannibalism vs Carnivore                 |  1.44| 1.86e-01|ns   |
|mnau_arms_legs_diff                          |Cannibalism vs Geological transport      |  1.99| 7.83e-02|ns   |
|mnau_arms_legs_diff                          |Sepulchral Cave vs Carnivore             |  1.87| 8.83e-02|ns   |
|mnau_arms_legs_diff                          |Sepulchral Cave vs Geological transport  |  2.37| 3.60e-02|*    |
|mnau_arms_legs_diff                          |Carnivore vs Geological transport        |  0.65| 5.76e-01|ns   |
|mnau_axial_main_mean                         |Funerary Context vs Cannibalism          | -3.91| 2.23e-04|***  |
|mnau_axial_main_mean                         |Funerary Context vs Sepulchral Cave      | -2.62| 1.10e-02|*    |
|mnau_axial_main_mean                         |Funerary Context vs Carnivore            | -6.90| 0.00e+00|**** |
|mnau_axial_main_mean                         |Funerary Context vs Geological transport | -6.21| 0.00e+00|**** |
|mnau_axial_main_mean                         |Cannibalism vs Sepulchral Cave           |  1.12| 2.91e-01|ns   |
|mnau_axial_main_mean                         |Cannibalism vs Carnivore                 | -3.12| 3.00e-03|**   |
|mnau_axial_main_mean                         |Cannibalism vs Geological transport      | -2.96| 4.38e-03|**   |
|mnau_axial_main_mean                         |Sepulchral Cave vs Carnivore             | -4.13| 1.20e-04|***  |
|mnau_axial_main_mean                         |Sepulchral Cave vs Geological transport  | -3.86| 2.23e-04|***  |
|mnau_axial_main_mean                         |Carnivore vs Geological transport        | -0.15| 8.77e-01|ns   |
|mnau_column_trunk_mean                       |Funerary Context vs Cannibalism          | -3.97| 2.44e-04|***  |
|mnau_column_trunk_mean                       |Funerary Context vs Sepulchral Cave      | -3.57| 8.93e-04|***  |
|mnau_column_trunk_mean                       |Funerary Context vs Carnivore            | -6.80| 0.00e+00|**** |
|mnau_column_trunk_mean                       |Funerary Context vs Geological transport | -6.55| 0.00e+00|**** |
|mnau_column_trunk_mean                       |Cannibalism vs Sepulchral Cave           |  0.35| 7.29e-01|ns   |
|mnau_column_trunk_mean                       |Cannibalism vs Carnivore                 | -2.99| 3.50e-03|**   |
|mnau_column_trunk_mean                       |Cannibalism vs Geological transport      | -3.23| 1.76e-03|**   |
|mnau_column_trunk_mean                       |Sepulchral Cave vs Carnivore             | -3.30| 1.61e-03|**   |
|mnau_column_trunk_mean                       |Sepulchral Cave vs Geological transport  | -3.51| 8.93e-04|***  |
|mnau_column_trunk_mean                       |Carnivore vs Geological transport        | -0.52| 6.72e-01|ns   |
|mnau_cv                                      |Funerary Context vs Cannibalism          |  4.13| 1.23e-04|***  |
|mnau_cv                                      |Funerary Context vs Sepulchral Cave      |  3.81| 3.54e-04|***  |
|mnau_cv                                      |Funerary Context vs Carnivore            |  6.71| 0.00e+00|**** |
|mnau_cv                                      |Funerary Context vs Geological transport |  6.71| 0.00e+00|**** |
|mnau_cv                                      |Cannibalism vs Sepulchral Cave           | -0.28| 7.80e-01|ns   |
|mnau_cv                                      |Cannibalism vs Carnivore                 |  2.96| 3.85e-03|**   |
|mnau_cv                                      |Cannibalism vs Geological transport      |  3.26| 1.83e-03|**   |
|mnau_cv                                      |Sepulchral Cave vs Carnivore             |  3.20| 1.95e-03|**   |
|mnau_cv                                      |Sepulchral Cave vs Geological transport  |  3.49| 9.71e-04|***  |
|mnau_cv                                      |Carnivore vs Geological transport        |  0.46| 7.14e-01|ns   |
|mnau_distal_appendicular_mean                |Funerary Context vs Cannibalism          | -4.10| 1.37e-04|***  |
|mnau_distal_appendicular_mean                |Funerary Context vs Sepulchral Cave      | -3.10| 2.79e-03|**   |
|mnau_distal_appendicular_mean                |Funerary Context vs Carnivore            | -6.73| 0.00e+00|**** |
|mnau_distal_appendicular_mean                |Funerary Context vs Geological transport | -6.60| 0.00e+00|**** |
|mnau_distal_appendicular_mean                |Cannibalism vs Sepulchral Cave           |  0.87| 4.25e-01|ns   |
|mnau_distal_appendicular_mean                |Cannibalism vs Carnivore                 | -2.82| 6.01e-03|**   |
|mnau_distal_appendicular_mean                |Cannibalism vs Geological transport      | -3.18| 2.43e-03|**   |
|mnau_distal_appendicular_mean                |Sepulchral Cave vs Carnivore             | -3.61| 6.24e-04|***  |
|mnau_distal_appendicular_mean                |Sepulchral Cave vs Geological transport  | -3.89| 2.55e-04|***  |
|mnau_distal_appendicular_mean                |Carnivore vs Geological transport        | -0.61| 5.39e-01|ns   |
|mnau_dominance_of_region_means               |Funerary Context vs Cannibalism          |  4.23| 7.76e-05|**** |
|mnau_dominance_of_region_means               |Funerary Context vs Sepulchral Cave      |  3.65| 5.22e-04|***  |
|mnau_dominance_of_region_means               |Funerary Context vs Carnivore            |  5.79| 0.00e+00|**** |
|mnau_dominance_of_region_means               |Funerary Context vs Geological transport |  6.83| 0.00e+00|**** |
|mnau_dominance_of_region_means               |Cannibalism vs Sepulchral Cave           | -0.50| 6.14e-01|ns   |
|mnau_dominance_of_region_means               |Cannibalism vs Carnivore                 |  2.04| 5.11e-02|ns   |
|mnau_dominance_of_region_means               |Cannibalism vs Geological transport      |  3.30| 1.61e-03|**   |
|mnau_dominance_of_region_means               |Sepulchral Cave vs Carnivore             |  2.48| 1.87e-02|*    |
|mnau_dominance_of_region_means               |Sepulchral Cave vs Geological transport  |  3.71| 5.22e-04|***  |
|mnau_dominance_of_region_means               |Carnivore vs Geological transport        |  1.27| 2.27e-01|ns   |
|mnau_evenness_minus_dominance                |Funerary Context vs Cannibalism          | -4.09| 1.47e-04|***  |
|mnau_evenness_minus_dominance                |Funerary Context vs Sepulchral Cave      | -3.75| 4.34e-04|***  |
|mnau_evenness_minus_dominance                |Funerary Context vs Carnivore            | -6.71| 0.00e+00|**** |
|mnau_evenness_minus_dominance                |Funerary Context vs Geological transport | -6.74| 0.00e+00|**** |
|mnau_evenness_minus_dominance                |Cannibalism vs Sepulchral Cave           |  0.29| 7.74e-01|ns   |
|mnau_evenness_minus_dominance                |Cannibalism vs Carnivore                 | -2.99| 3.53e-03|**   |
|mnau_evenness_minus_dominance                |Cannibalism vs Geological transport      | -3.32| 1.49e-03|**   |
|mnau_evenness_minus_dominance                |Sepulchral Cave vs Carnivore             | -3.23| 1.74e-03|**   |
|mnau_evenness_minus_dominance                |Sepulchral Cave vs Geological transport  | -3.55| 7.61e-04|***  |
|mnau_evenness_minus_dominance                |Carnivore vs Geological transport        | -0.49| 6.90e-01|ns   |
|mnau_foot                                    |Funerary Context vs Cannibalism          | -3.45| 1.88e-03|**   |
|mnau_foot                                    |Funerary Context vs Sepulchral Cave      | -2.89| 5.69e-03|**   |
|mnau_foot                                    |Funerary Context vs Carnivore            | -6.00| 0.00e+00|**** |
|mnau_foot                                    |Funerary Context vs Geological transport | -5.77| 0.00e+00|**** |
|mnau_foot                                    |Cannibalism vs Sepulchral Cave           |  0.49| 6.54e-01|ns   |
|mnau_foot                                    |Cannibalism vs Carnivore                 | -2.68| 9.24e-03|**   |
|mnau_foot                                    |Cannibalism vs Geological transport      | -2.88| 5.69e-03|**   |
|mnau_foot                                    |Sepulchral Cave vs Carnivore             | -3.12| 3.64e-03|**   |
|mnau_foot                                    |Sepulchral Cave vs Geological transport  | -3.27| 2.66e-03|**   |
|mnau_foot                                    |Carnivore vs Geological transport        | -0.45| 6.54e-01|ns   |
|mnau_gini                                    |Funerary Context vs Cannibalism          |  3.89| 3.35e-04|***  |
|mnau_gini                                    |Funerary Context vs Sepulchral Cave      |  3.75| 4.40e-04|***  |
|mnau_gini                                    |Funerary Context vs Carnivore            |  6.73| 0.00e+00|**** |
|mnau_gini                                    |Funerary Context vs Geological transport |  6.75| 0.00e+00|**** |
|mnau_gini                                    |Cannibalism vs Sepulchral Cave           | -0.12| 9.04e-01|ns   |
|mnau_gini                                    |Cannibalism vs Carnivore                 |  3.15| 2.03e-03|**   |
|mnau_gini                                    |Cannibalism vs Geological transport      |  3.47| 8.58e-04|***  |
|mnau_gini                                    |Sepulchral Cave vs Carnivore             |  3.26| 1.62e-03|**   |
|mnau_gini                                    |Sepulchral Cave vs Geological transport  |  3.57| 7.15e-04|***  |
|mnau_gini                                    |Carnivore vs Geological transport        |  0.49| 6.92e-01|ns   |
|mnau_girdle_mean                             |Funerary Context vs Cannibalism          | -3.93| 2.14e-04|***  |
|mnau_girdle_mean                             |Funerary Context vs Sepulchral Cave      | -4.27| 6.44e-05|**** |
|mnau_girdle_mean                             |Funerary Context vs Carnivore            | -6.47| 0.00e+00|**** |
|mnau_girdle_mean                             |Funerary Context vs Geological transport | -6.15| 0.00e+00|**** |
|mnau_girdle_mean                             |Cannibalism vs Sepulchral Cave           | -0.30| 7.65e-01|ns   |
|mnau_girdle_mean                             |Cannibalism vs Carnivore                 | -2.73| 1.07e-02|*    |
|mnau_girdle_mean                             |Cannibalism vs Geological transport      | -2.89| 7.71e-03|**   |
|mnau_girdle_mean                             |Sepulchral Cave vs Carnivore             | -2.46| 1.75e-02|*    |
|mnau_girdle_mean                             |Sepulchral Cave vs Geological transport  | -2.65| 1.15e-02|*    |
|mnau_girdle_mean                             |Carnivore vs Geological transport        | -0.42| 7.51e-01|ns   |
|mnau_hands                                   |Funerary Context vs Cannibalism          | -3.46| 1.79e-03|**   |
|mnau_hands                                   |Funerary Context vs Sepulchral Cave      | -3.08| 3.62e-03|**   |
|mnau_hands                                   |Funerary Context vs Carnivore            | -6.11| 0.00e+00|**** |
|mnau_hands                                   |Funerary Context vs Geological transport | -5.82| 0.00e+00|**** |
|mnau_hands                                   |Cannibalism vs Sepulchral Cave           |  0.33| 7.39e-01|ns   |
|mnau_hands                                   |Cannibalism vs Carnivore                 | -2.77| 7.09e-03|**   |
|mnau_hands                                   |Cannibalism vs Geological transport      | -2.91| 5.10e-03|**   |
|mnau_hands                                   |Sepulchral Cave vs Carnivore             | -3.07| 3.62e-03|**   |
|mnau_hands                                   |Sepulchral Cave vs Geological transport  | -3.18| 3.62e-03|**   |
|mnau_hands                                   |Carnivore vs Geological transport        | -0.41| 7.39e-01|ns   |
|mnau_heip_evenness                           |Funerary Context vs Cannibalism          | -3.89| 3.40e-04|***  |
|mnau_heip_evenness                           |Funerary Context vs Sepulchral Cave      | -3.76| 4.31e-04|***  |
|mnau_heip_evenness                           |Funerary Context vs Carnivore            | -6.79| 0.00e+00|**** |
|mnau_heip_evenness                           |Funerary Context vs Geological transport | -6.72| 0.00e+00|**** |
|mnau_heip_evenness                           |Cannibalism vs Sepulchral Cave           |  0.11| 9.10e-01|ns   |
|mnau_heip_evenness                           |Cannibalism vs Carnivore                 | -3.21| 1.67e-03|**   |
|mnau_heip_evenness                           |Cannibalism vs Geological transport      | -3.45| 9.43e-04|***  |
|mnau_heip_evenness                           |Sepulchral Cave vs Carnivore             | -3.31| 1.35e-03|**   |
|mnau_heip_evenness                           |Sepulchral Cave vs Geological transport  | -3.54| 8.06e-04|***  |
|mnau_heip_evenness                           |Carnivore vs Geological transport        | -0.42| 7.49e-01|ns   |
|mnau_inverse_simpson                         |Funerary Context vs Cannibalism          | -4.13| 1.20e-04|***  |
|mnau_inverse_simpson                         |Funerary Context vs Sepulchral Cave      | -3.81| 3.52e-04|***  |
|mnau_inverse_simpson                         |Funerary Context vs Carnivore            | -6.68| 0.00e+00|**** |
|mnau_inverse_simpson                         |Funerary Context vs Geological transport | -6.74| 0.00e+00|**** |
|mnau_inverse_simpson                         |Cannibalism vs Sepulchral Cave           |  0.28| 7.77e-01|ns   |
|mnau_inverse_simpson                         |Cannibalism vs Carnivore                 | -2.93| 4.25e-03|**   |
|mnau_inverse_simpson                         |Cannibalism vs Geological transport      | -3.29| 1.69e-03|**   |
|mnau_inverse_simpson                         |Sepulchral Cave vs Carnivore             | -3.17| 2.15e-03|**   |
|mnau_inverse_simpson                         |Sepulchral Cave vs Geological transport  | -3.52| 8.78e-04|***  |
|mnau_inverse_simpson                         |Carnivore vs Geological transport        | -0.51| 6.77e-01|ns   |
|mnau_legs                                    |Funerary Context vs Cannibalism          | -4.20| 8.95e-05|**** |
|mnau_legs                                    |Funerary Context vs Sepulchral Cave      | -3.74| 4.55e-04|***  |
|mnau_legs                                    |Funerary Context vs Carnivore            | -5.99| 0.00e+00|**** |
|mnau_legs                                    |Funerary Context vs Geological transport | -6.12| 0.00e+00|**** |
|mnau_legs                                    |Cannibalism vs Sepulchral Cave           |  0.40| 6.92e-01|ns   |
|mnau_legs                                    |Cannibalism vs Carnivore                 | -2.08| 4.69e-02|*    |
|mnau_legs                                    |Cannibalism vs Geological transport      | -2.67| 1.25e-02|*    |
|mnau_legs                                    |Sepulchral Cave vs Carnivore             | -2.44| 2.12e-02|*    |
|mnau_legs                                    |Sepulchral Cave vs Geological transport  | -2.99| 5.52e-03|**   |
|mnau_legs                                    |Carnivore vs Geological transport        | -0.76| 4.99e-01|ns   |
|mnau_limb_shaft_proxy_mean                   |Funerary Context vs Cannibalism          | -4.28| 6.32e-05|**** |
|mnau_limb_shaft_proxy_mean                   |Funerary Context vs Sepulchral Cave      | -3.74| 4.67e-04|***  |
|mnau_limb_shaft_proxy_mean                   |Funerary Context vs Carnivore            | -6.43| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean                   |Funerary Context vs Geological transport | -6.38| 0.00e+00|**** |
|mnau_limb_shaft_proxy_mean                   |Cannibalism vs Sepulchral Cave           |  0.47| 6.38e-01|ns   |
|mnau_limb_shaft_proxy_mean                   |Cannibalism vs Carnivore                 | -2.41| 1.97e-02|*    |
|mnau_limb_shaft_proxy_mean                   |Cannibalism vs Geological transport      | -2.86| 6.49e-03|**   |
|mnau_limb_shaft_proxy_mean                   |Sepulchral Cave vs Carnivore             | -2.84| 6.49e-03|**   |
|mnau_limb_shaft_proxy_mean                   |Sepulchral Cave vs Geological transport  | -3.24| 2.42e-03|**   |
|mnau_limb_shaft_proxy_mean                   |Carnivore vs Geological transport        | -0.65| 5.74e-01|ns   |
|mnau_lower_appendicular_mean                 |Funerary Context vs Cannibalism          | -4.46| 2.74e-05|**** |
|mnau_lower_appendicular_mean                 |Funerary Context vs Sepulchral Cave      | -3.80| 3.55e-04|***  |
|mnau_lower_appendicular_mean                 |Funerary Context vs Carnivore            | -6.52| 0.00e+00|**** |
|mnau_lower_appendicular_mean                 |Funerary Context vs Geological transport | -6.75| 0.00e+00|**** |
|mnau_lower_appendicular_mean                 |Cannibalism vs Sepulchral Cave           |  0.57| 5.69e-01|ns   |
|mnau_lower_appendicular_mean                 |Cannibalism vs Carnivore                 | -2.35| 2.34e-02|*    |
|mnau_lower_appendicular_mean                 |Cannibalism vs Geological transport      | -3.07| 3.54e-03|**   |
|mnau_lower_appendicular_mean                 |Sepulchral Cave vs Carnivore             | -2.86| 5.98e-03|**   |
|mnau_lower_appendicular_mean                 |Sepulchral Cave vs Geological transport  | -3.53| 8.28e-04|***  |
|mnau_lower_appendicular_mean                 |Carnivore vs Geological transport        | -0.90| 4.08e-01|ns   |
|mnau_pelvic                                  |Funerary Context vs Cannibalism          | -3.73| 4.78e-04|***  |
|mnau_pelvic                                  |Funerary Context vs Sepulchral Cave      | -4.11| 1.31e-04|***  |
|mnau_pelvic                                  |Funerary Context vs Carnivore            | -5.69| 1.00e-07|**** |
|mnau_pelvic                                  |Funerary Context vs Geological transport | -5.63| 1.00e-07|**** |
|mnau_pelvic                                  |Cannibalism vs Sepulchral Cave           | -0.33| 7.40e-01|ns   |
|mnau_pelvic                                  |Cannibalism vs Carnivore                 | -2.18| 4.22e-02|*    |
|mnau_pelvic                                  |Cannibalism vs Geological transport      | -2.55| 2.16e-02|*    |
|mnau_pelvic                                  |Sepulchral Cave vs Carnivore             | -1.88| 7.56e-02|ns   |
|mnau_pelvic                                  |Sepulchral Cave vs Geological transport  | -2.28| 3.74e-02|*    |
|mnau_pelvic                                  |Carnivore vs Geological transport        | -0.56| 6.39e-01|ns   |
|mnau_postcranial_total_mean                  |Funerary Context vs Cannibalism          | -4.76| 6.40e-06|**** |
|mnau_postcranial_total_mean                  |Funerary Context vs Sepulchral Cave      | -3.77| 4.02e-04|***  |
|mnau_postcranial_total_mean                  |Funerary Context vs Carnivore            | -6.88| 0.00e+00|**** |
|mnau_postcranial_total_mean                  |Funerary Context vs Geological transport | -6.83| 0.00e+00|**** |
|mnau_postcranial_total_mean                  |Cannibalism vs Sepulchral Cave           |  0.86| 4.34e-01|ns   |
|mnau_postcranial_total_mean                  |Cannibalism vs Carnivore                 | -2.43| 1.87e-02|*    |
|mnau_postcranial_total_mean                  |Cannibalism vs Geological transport      | -2.93| 4.83e-03|**   |
|mnau_postcranial_total_mean                  |Sepulchral Cave vs Carnivore             | -3.21| 2.24e-03|**   |
|mnau_postcranial_total_mean                  |Sepulchral Cave vs Geological transport  | -3.62| 5.85e-04|***  |
|mnau_postcranial_total_mean                  |Carnivore vs Geological transport        | -0.70| 4.84e-01|ns   |
|mnau_proximal_appendicular_mean              |Funerary Context vs Cannibalism          | -4.43| 3.20e-05|**** |
|mnau_proximal_appendicular_mean              |Funerary Context vs Sepulchral Cave      | -3.98| 1.69e-04|***  |
|mnau_proximal_appendicular_mean              |Funerary Context vs Carnivore            | -6.62| 0.00e+00|**** |
|mnau_proximal_appendicular_mean              |Funerary Context vs Geological transport | -6.52| 0.00e+00|**** |
|mnau_proximal_appendicular_mean              |Cannibalism vs Sepulchral Cave           |  0.38| 7.01e-01|ns   |
|mnau_proximal_appendicular_mean              |Cannibalism vs Carnivore                 | -2.47| 1.70e-02|*    |
|mnau_proximal_appendicular_mean              |Cannibalism vs Geological transport      | -2.88| 6.63e-03|**   |
|mnau_proximal_appendicular_mean              |Sepulchral Cave vs Carnivore             | -2.81| 6.99e-03|**   |
|mnau_proximal_appendicular_mean              |Sepulchral Cave vs Geological transport  | -3.19| 2.86e-03|**   |
|mnau_proximal_appendicular_mean              |Carnivore vs Geological transport        | -0.62| 5.92e-01|ns   |
|mnau_region_mean_evenness                    |Funerary Context vs Cannibalism          | -3.86| 3.84e-04|***  |
|mnau_region_mean_evenness                    |Funerary Context vs Sepulchral Cave      | -3.64| 5.41e-04|***  |
|mnau_region_mean_evenness                    |Funerary Context vs Carnivore            | -6.26| 0.00e+00|**** |
|mnau_region_mean_evenness                    |Funerary Context vs Geological transport | -6.86| 0.00e+00|**** |
|mnau_region_mean_evenness                    |Cannibalism vs Sepulchral Cave           |  0.19| 8.52e-01|ns   |
|mnau_region_mean_evenness                    |Cannibalism vs Carnivore                 | -2.75| 7.36e-03|**   |
|mnau_region_mean_evenness                    |Cannibalism vs Geological transport      | -3.59| 5.46e-04|***  |
|mnau_region_mean_evenness                    |Sepulchral Cave vs Carnivore             | -2.92| 5.08e-03|**   |
|mnau_region_mean_evenness                    |Sepulchral Cave vs Geological transport  | -3.74| 4.56e-04|***  |
|mnau_region_mean_evenness                    |Carnivore vs Geological transport        | -0.94| 3.89e-01|ns   |
|mnau_shoulder                                |Funerary Context vs Cannibalism          | -3.53| 1.02e-03|**   |
|mnau_shoulder                                |Funerary Context vs Sepulchral Cave      | -4.30| 5.69e-05|**** |
|mnau_shoulder                                |Funerary Context vs Carnivore            | -6.67| 0.00e+00|**** |
|mnau_shoulder                                |Funerary Context vs Geological transport | -5.40| 3.00e-07|**** |
|mnau_shoulder                                |Cannibalism vs Sepulchral Cave           | -0.67| 5.62e-01|ns   |
|mnau_shoulder                                |Cannibalism vs Carnivore                 | -3.21| 2.64e-03|**   |
|mnau_shoulder                                |Cannibalism vs Geological transport      | -2.48| 1.87e-02|*    |
|mnau_shoulder                                |Sepulchral Cave vs Carnivore             | -2.61| 1.49e-02|*    |
|mnau_shoulder                                |Sepulchral Cave vs Geological transport  | -1.95| 6.45e-02|ns   |
|mnau_shoulder                                |Carnivore vs Geological transport        |  0.37| 7.14e-01|ns   |
|mnau_simpson_dominance                       |Funerary Context vs Cannibalism          |  4.13| 1.20e-04|***  |
|mnau_simpson_dominance                       |Funerary Context vs Sepulchral Cave      |  3.81| 3.52e-04|***  |
|mnau_simpson_dominance                       |Funerary Context vs Carnivore            |  6.68| 0.00e+00|**** |
|mnau_simpson_dominance                       |Funerary Context vs Geological transport |  6.74| 0.00e+00|**** |
|mnau_simpson_dominance                       |Cannibalism vs Sepulchral Cave           | -0.28| 7.77e-01|ns   |
|mnau_simpson_dominance                       |Cannibalism vs Carnivore                 |  2.93| 4.25e-03|**   |
|mnau_simpson_dominance                       |Cannibalism vs Geological transport      |  3.29| 1.69e-03|**   |
|mnau_simpson_dominance                       |Sepulchral Cave vs Carnivore             |  3.17| 2.15e-03|**   |
|mnau_simpson_dominance                       |Sepulchral Cave vs Geological transport  |  3.52| 8.78e-04|***  |
|mnau_simpson_dominance                       |Carnivore vs Geological transport        |  0.51| 6.77e-01|ns   |
|mnau_simpson_evenness                        |Funerary Context vs Cannibalism          | -4.13| 1.20e-04|***  |
|mnau_simpson_evenness                        |Funerary Context vs Sepulchral Cave      | -3.81| 3.52e-04|***  |
|mnau_simpson_evenness                        |Funerary Context vs Carnivore            | -6.68| 0.00e+00|**** |
|mnau_simpson_evenness                        |Funerary Context vs Geological transport | -6.74| 0.00e+00|**** |
|mnau_simpson_evenness                        |Cannibalism vs Sepulchral Cave           |  0.28| 7.77e-01|ns   |
|mnau_simpson_evenness                        |Cannibalism vs Carnivore                 | -2.93| 4.25e-03|**   |
|mnau_simpson_evenness                        |Cannibalism vs Geological transport      | -3.29| 1.69e-03|**   |
|mnau_simpson_evenness                        |Sepulchral Cave vs Carnivore             | -3.17| 2.15e-03|**   |
|mnau_simpson_evenness                        |Sepulchral Cave vs Geological transport  | -3.52| 8.78e-04|***  |
|mnau_simpson_evenness                        |Carnivore vs Geological transport        | -0.51| 6.77e-01|ns   |
|mnau_top2_share_mcnaughton                   |Funerary Context vs Cannibalism          |  4.16| 1.08e-04|***  |
|mnau_top2_share_mcnaughton                   |Funerary Context vs Sepulchral Cave      |  3.84| 3.03e-04|***  |
|mnau_top2_share_mcnaughton                   |Funerary Context vs Carnivore            |  6.97| 0.00e+00|**** |
|mnau_top2_share_mcnaughton                   |Funerary Context vs Geological transport |  6.89| 0.00e+00|**** |
|mnau_top2_share_mcnaughton                   |Cannibalism vs Sepulchral Cave           | -0.27| 7.86e-01|ns   |
|mnau_top2_share_mcnaughton                   |Cannibalism vs Carnivore                 |  3.17| 1.90e-03|**   |
|mnau_top2_share_mcnaughton                   |Cannibalism vs Geological transport      |  3.41| 9.40e-04|***  |
|mnau_top2_share_mcnaughton                   |Sepulchral Cave vs Carnivore             |  3.41| 9.40e-04|***  |
|mnau_top2_share_mcnaughton                   |Sepulchral Cave vs Geological transport  |  3.63| 5.68e-04|***  |
|mnau_top2_share_mcnaughton                   |Carnivore vs Geological transport        |  0.42| 7.51e-01|ns   |
|mnau_upper_appendicular_mean                 |Funerary Context vs Cannibalism          | -4.54| 1.84e-05|**** |
|mnau_upper_appendicular_mean                 |Funerary Context vs Sepulchral Cave      | -3.96| 1.91e-04|***  |
|mnau_upper_appendicular_mean                 |Funerary Context vs Carnivore            | -7.64| 0.00e+00|**** |
|mnau_upper_appendicular_mean                 |Funerary Context vs Geological transport | -6.55| 0.00e+00|**** |
|mnau_upper_appendicular_mean                 |Cannibalism vs Sepulchral Cave           |  0.51| 6.77e-01|ns   |
|mnau_upper_appendicular_mean                 |Cannibalism vs Carnivore                 | -3.29| 1.66e-03|**   |
|mnau_upper_appendicular_mean                 |Cannibalism vs Geological transport      | -2.83| 5.83e-03|**   |
|mnau_upper_appendicular_mean                 |Sepulchral Cave vs Carnivore             | -3.75| 3.52e-04|***  |
|mnau_upper_appendicular_mean                 |Sepulchral Cave vs Geological transport  | -3.24| 1.70e-03|**   |
|mnau_upper_appendicular_mean                 |Carnivore vs Geological transport        |  0.11| 9.13e-01|ns   |
|mnau_vertebrae_to_thorax_ratio               |Funerary Context vs Cannibalism          | -3.10| 5.00e-03|**   |
|mnau_vertebrae_to_thorax_ratio               |Funerary Context vs Sepulchral Cave      | -0.73| 4.80e-01|ns   |
|mnau_vertebrae_to_thorax_ratio               |Funerary Context vs Carnivore            | -3.55| 1.96e-03|**   |
|mnau_vertebrae_to_thorax_ratio               |Funerary Context vs Geological transport | -3.93| 8.63e-04|***  |
|mnau_vertebrae_to_thorax_ratio               |Cannibalism vs Sepulchral Cave           |  2.06| 6.63e-02|ns   |
|mnau_vertebrae_to_thorax_ratio               |Cannibalism vs Carnivore                 | -0.76| 4.80e-01|ns   |
|mnau_vertebrae_to_thorax_ratio               |Cannibalism vs Geological transport      | -1.43| 2.16e-01|ns   |
|mnau_vertebrae_to_thorax_ratio               |Sepulchral Cave vs Carnivore             | -2.60| 1.84e-02|*    |
|mnau_vertebrae_to_thorax_ratio               |Sepulchral Cave vs Geological transport  | -3.09| 5.00e-03|**   |
|mnau_vertebrae_to_thorax_ratio               |Carnivore vs Geological transport        | -0.71| 4.80e-01|ns   |
|mne_arms                                     |Funerary Context vs Cannibalism          | -1.60| 1.38e-01|ns   |
|mne_arms                                     |Funerary Context vs Sepulchral Cave      | -2.94| 4.73e-03|**   |
|mne_arms                                     |Funerary Context vs Carnivore            | -6.57| 0.00e+00|**** |
|mne_arms                                     |Funerary Context vs Geological transport | -5.89| 0.00e+00|**** |
|mne_arms                                     |Cannibalism vs Sepulchral Cave           | -1.16| 2.71e-01|ns   |
|mne_arms                                     |Cannibalism vs Carnivore                 | -4.64| 1.18e-05|**** |
|mne_arms                                     |Cannibalism vs Geological transport      | -4.29| 4.53e-05|**** |
|mne_arms                                     |Sepulchral Cave vs Carnivore             | -3.59| 6.63e-04|***  |
|mne_arms                                     |Sepulchral Cave vs Geological transport  | -3.35| 1.35e-03|**   |
|mne_arms                                     |Carnivore vs Geological transport        | -0.13| 8.99e-01|ns   |
|mne_cranial_share                            |Funerary Context vs Cannibalism          |  3.93| 4.19e-04|***  |
|mne_cranial_share                            |Funerary Context vs Sepulchral Cave      |  2.38| 2.89e-02|*    |
|mne_cranial_share                            |Funerary Context vs Carnivore            |  2.68| 1.47e-02|*    |
|mne_cranial_share                            |Funerary Context vs Geological transport |  5.49| 4.00e-07|**** |
|mne_cranial_share                            |Cannibalism vs Sepulchral Cave           | -1.35| 2.21e-01|ns   |
|mne_cranial_share                            |Cannibalism vs Carnivore                 | -0.67| 5.56e-01|ns   |
|mne_cranial_share                            |Cannibalism vs Geological transport      |  2.28| 3.20e-02|*    |
|mne_cranial_share                            |Sepulchral Cave vs Carnivore             |  0.54| 5.89e-01|ns   |
|mne_cranial_share                            |Sepulchral Cave vs Geological transport  |  3.37| 2.50e-03|**   |
|mne_cranial_share                            |Carnivore vs Geological transport        |  2.69| 1.47e-02|*    |
|postcranial_dominance_refined                |Funerary Context vs Cannibalism          |  2.88| 6.58e-03|**   |
|postcranial_dominance_refined                |Funerary Context vs Sepulchral Cave      |  3.99| 2.18e-04|***  |
|postcranial_dominance_refined                |Funerary Context vs Carnivore            |  6.19| 0.00e+00|**** |
|postcranial_dominance_refined                |Funerary Context vs Geological transport |  4.18| 1.47e-04|***  |
|postcranial_dominance_refined                |Cannibalism vs Sepulchral Cave           |  0.88| 4.24e-01|ns   |
|postcranial_dominance_refined                |Cannibalism vs Carnivore                 |  3.56| 9.42e-04|***  |
|postcranial_dominance_refined                |Cannibalism vs Geological transport      |  2.67| 1.10e-02|*    |
|postcranial_dominance_refined                |Sepulchral Cave vs Carnivore             |  2.89| 6.58e-03|**   |
|postcranial_dominance_refined                |Sepulchral Cave vs Geological transport  |  2.21| 3.37e-02|*    |
|postcranial_dominance_refined                |Carnivore vs Geological transport        |  0.31| 7.58e-01|ns   |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 15.22, R² = 0.367, p = 0.0001.
PCA variance explained: PC1 59.8%, PC2 8.8%, PC3 5.9% (cumulative 74.5%).
Dispersion caveat (PERMDISP): p = 0.063.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_top2_share_mcnaughton    |  0.178|  0.110| -0.032|
|mnau_simpson_evenness         | -0.177| -0.083|  0.035|
|mnau_inverse_simpson          | -0.177| -0.083|  0.035|
|mnau_gini                     |  0.177|  0.111| -0.041|
|effective_sections_hill1      | -0.176| -0.126|  0.034|
|mnau_heip_evenness            | -0.176| -0.126|  0.034|
|mnau_cv                       |  0.174|  0.161| -0.008|
|mnau_evenness_minus_dominance | -0.173| -0.164|  0.006|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
