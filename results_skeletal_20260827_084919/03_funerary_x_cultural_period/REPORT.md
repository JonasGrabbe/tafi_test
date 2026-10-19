# Mortuary practice through time
*Automated funerary_context × cultural_period × skeletal-part representation*

- **Grouping column:** `funerary_context × cultural_period` (mode = interaction)
- **Groups (n):** Inhumation single | Upper Paleolithic = 13; Inhumation single | Middle Paleolithic = 11; Collective burial | Neolithic = 4; Carnivore den(transport) | Middle Paleolithic = 3; Carnivore Scavenge (in situ) | Middle Paleolithic = 3
- **Sites analysed:** 34  |  **features screened:** 63

## Hypothesis

**H:** Mortuary practice changes completeness and element selection through time.

**Expected pattern:** Single inhumations approach complete skeletons; collective burials over-represent crania/long bones; non-inhumation contexts more fragmentary.

**Why it matters:** Separates intentional mortuary behaviour from preservation loss (Robb: human handling can pattern representation).


## Summary

49 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.584, FDR p = 0.008628). PERMANOVA pseudo-F = 5.72, p = 0.0001; PC1–PC3 explain 74.2% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 77 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 16 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.584| 0.00863|large      |significant |
|mnau_appendicular_mean                       |  0.490| 0.00863|large      |significant |
|mnau_girdle_mean                             |  0.478| 0.00863|large      |significant |
|mnau_proximal_appendicular_mean              |  0.472| 0.00863|large      |significant |
|mnau_upper_appendicular_mean                 |  0.467| 0.00863|large      |significant |
|mnau_legs                                    |  0.467| 0.00863|large      |significant |
|mnau_postcranial_total_mean                  |  0.452| 0.00863|large      |significant |
|effective_sections_hill1                     |  0.444| 0.00863|large      |significant |
|mnau_heip_evenness                           |  0.444| 0.00863|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.440| 0.00863|large      |significant |
|ProportionalRep_MNIbased_fibula              |  0.435| 0.00863|large      |significant |
|mnau_column_trunk_mean                       |  0.430| 0.00863|large      |significant |
|mnau_shoulder                                |  0.430| 0.00863|large      |significant |
|mnau_lower_appendicular_mean                 |  0.429| 0.00863|large      |significant |
|mnau_axial_main_mean                         |  0.427| 0.00863|large      |significant |
|ProportionalRep_MNIbased_humerus             |  0.427| 0.00863|large      |significant |
|mnau_evenness_minus_dominance                |  0.423| 0.00863|large      |significant |
|low_density_axial_survival                   |  0.415| 0.00863|large      |significant |
|low_density_survival_index                   |  0.414| 0.00863|large      |significant |
|mnau_cv                                      |  0.411| 0.00863|large      |significant |
|mnau_inverse_simpson                         |  0.411| 0.00863|large      |significant |
|mnau_simpson_dominance                       |  0.411| 0.00863|large      |significant |
|mnau_simpson_evenness                        |  0.411| 0.00863|large      |significant |
|mnau_gini                                    |  0.404| 0.00900|large      |significant |
|density_evenness                             |  0.392| 0.00966|large      |significant |
|ProportionalRep_MNIbased_tibia               |  0.391| 0.00966|large      |significant |
|all_sections_dominance                       |  0.389| 0.00966|large      |significant |
|postcranial_dominance_refined                |  0.383| 0.00978|large      |significant |
|dominance_gap_all                            |  0.378| 0.00978|large      |significant |
|ProportionalRep_MNIbased_clavicle            |  0.378| 0.00978|large      |significant |
|mnau_arms                                    |  0.378| 0.00978|large      |significant |
|appendicular_dominance                       |  0.369| 0.00995|large      |significant |
|appendicular_dominance_refined               |  0.369| 0.00995|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.369| 0.00995|large      |significant |
|mnau_region_mean_evenness                    |  0.365| 0.01010|large      |significant |
|mnau_dominance_of_region_means               |  0.333| 0.01480|large      |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.326| 0.01570|large      |significant |
|ProportionalRep_MNIbased_radius              |  0.324| 0.01580|large      |significant |
|ProportionalRep_MNIbased_femur               |  0.307| 0.01910|large      |significant |
|lower_appendicular_continuity_hm             |  0.305| 0.01910|large      |significant |
|mnau_distal_appendicular_mean                |  0.303| 0.01910|large      |significant |
|ReMNAU_ulna                                  |  0.297| 0.02000|large      |significant |
|distal_appendicular_continuity_hm            |  0.284| 0.02300|large      |significant |
|mnau_pelvic                                  |  0.272| 0.02590|large      |significant |
|ReMNAU_radius                                |  0.269| 0.02650|large      |significant |
|mnau_hands                                   |  0.258| 0.02960|large      |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.232| 0.03990|large      |significant |
|ReMNAU_cervical                              |  0.229| 0.04060|large      |significant |
|ProportionalRep_MNIbased_cervical            |  0.219| 0.04490|large      |significant |
|mnau_foot                                    |  0.191| 0.06170|large      |n.s.        |
|low_density_share                            |  0.189| 0.06180|large      |n.s.        |
|ProportionalRep_MNIbased_carpal              |  0.182| 0.06640|large      |n.s.        |
|lower_appendicular_evenness                  |  0.097| 0.18100|moderate   |n.s.        |
|lower_appendicular_evenness_refined          |  0.097| 0.18100|moderate   |n.s.        |
|density_adjusted_appendicular_axial_contrast |  0.090| 0.18100|moderate   |n.s.        |
|mnau_arms_legs_logratio                      |  0.065| 0.22900|moderate   |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.065| 0.22900|moderate   |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.008| 0.47800|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               | -0.011| 0.48200|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.014| 0.48500|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.032| 0.56300|negligible |n.s.        |
|dominant_axial_share                         | -0.055| 0.67100|negligible |n.s.        |
|mne_cranial_share                            | -0.062| 0.69800|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                                                                                     |     Z| p (adj)|Sig |
|:-----------------------------------|:------------------------------------------------------------------------------------------------------------|-----:|-------:|:---|
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.37| 0.78900|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.77| 0.55400|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.15| 0.07890|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.15| 0.07890|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.01| 0.44600|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.35| 0.07890|ns  |
|ProportionalRep_MNIbased_cervical   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.35| 0.07890|ns  |
|ProportionalRep_MNIbased_cervical   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.23| 0.36500|ns  |
|ProportionalRep_MNIbased_cervical   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.23| 0.36500|ns  |
|ProportionalRep_MNIbased_cervical   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.10| 0.92100|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.39| 0.27300|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.51| 0.02980|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.78| 0.02680|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.43| 0.27300|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.53| 0.02980|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.80| 0.02680|*   |
|ProportionalRep_MNIbased_clavicle   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.07| 0.35800|ns  |
|ProportionalRep_MNIbased_clavicle   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.29| 0.28000|ns  |
|ProportionalRep_MNIbased_clavicle   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.92100|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.18| 0.34000|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.08| 0.34800|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.89| 0.03840|*   |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.62| 0.04420|*   |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.23| 0.83000|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.10| 0.11900|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.83| 0.16700|ns  |
|ProportionalRep_MNIbased_femur      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.61| 0.21300|ns  |
|ProportionalRep_MNIbased_femur      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.38| 0.27700|ns  |
|ProportionalRep_MNIbased_femur      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.83000|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.26| 0.29900|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.89| 0.11900|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.18| 0.01480|*   |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.91| 0.01810|*   |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.96| 0.37200|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.34| 0.06500|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.07| 0.09600|ns  |
|ProportionalRep_MNIbased_fibula     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.25| 0.29900|ns  |
|ProportionalRep_MNIbased_fibula     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.03| 0.37200|ns  |
|ProportionalRep_MNIbased_fibula     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.83200|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.06| 0.95400|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.33| 0.25900|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.76| 0.01870|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.95| 0.01870|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.26| 0.25900|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.67| 0.01870|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.86| 0.01870|*   |
|ProportionalRep_MNIbased_humerus    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.32| 0.25900|ns  |
|ProportionalRep_MNIbased_humerus    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.48| 0.25900|ns  |
|ProportionalRep_MNIbased_humerus    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.15| 0.95400|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.59| 0.76700|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.51| 0.76700|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.33| 0.09870|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.59| 0.09560|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.08| 0.93700|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.92| 0.13900|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.18| 0.09870|ns  |
|ProportionalRep_MNIbased_metacarpal |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.57| 0.19300|ns  |
|ProportionalRep_MNIbased_metacarpal |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.79| 0.14500|ns  |
|ProportionalRep_MNIbased_metacarpal |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.92900|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.28| 0.79300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.51| 0.26300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.43| 0.04980|*   |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.77| 0.04980|*   |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.28| 0.33300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.21| 0.06690|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.54| 0.04980|*   |
|ProportionalRep_MNIbased_os_coxae   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -0.91| 0.45200|ns  |
|ProportionalRep_MNIbased_os_coxae   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.19| 0.33300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.26| 0.79300|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.09| 1.00000|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.92| 0.50100|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.62| 0.02920|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.62| 0.02920|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.84| 0.50100|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.52| 0.02920|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.52| 0.02920|*   |
|ProportionalRep_MNIbased_radius     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.51| 0.21900|ns  |
|ProportionalRep_MNIbased_radius     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.51| 0.21900|ns  |
|ProportionalRep_MNIbased_radius     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.15| 0.35600|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.98| 0.41100|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.01| 0.01330|*   |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.01| 0.01330|*   |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.15| 0.98100|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.23| 0.06430|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.23| 0.06430|ns  |
|ProportionalRep_MNIbased_tibia      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.79| 0.12300|ns  |
|ProportionalRep_MNIbased_tibia      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.79| 0.12300|ns  |
|ProportionalRep_MNIbased_tibia      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.91| 0.45300|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.38| 0.78400|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.96| 0.12500|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -1.96| 0.12500|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.01| 0.44700|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.50| 0.06190|ns  |
|ReMNAU_cervical                     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.50| 0.06190|ns  |
|ReMNAU_cervical                     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.36| 0.28900|ns  |
|ReMNAU_cervical                     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.36| 0.28900|ns  |
|ReMNAU_cervical                     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.32| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.07| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.31| 0.05180|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.31| 0.05180|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.16| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.48| 0.05180|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.48| 0.05180|ns  |
|ReMNAU_radius                       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.99| 0.07760|ns  |
|ReMNAU_radius                       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.99| 0.07760|ns  |
|ReMNAU_radius                       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.95| 0.48800|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.19| 0.94000|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.67| 0.03840|*   |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.67| 0.03840|*   |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.48| 0.79100|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.02| 0.07180|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.02| 0.07180|ns  |
|ReMNAU_ulna                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.09| 0.07180|ns  |
|ReMNAU_ulna                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.09| 0.07180|ns  |
|ReMNAU_ulna                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.14| 0.90200|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.92| 0.51400|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.44| 0.02470|*   |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.59| 0.02380|*   |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.80| 0.52900|ns  |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.48| 0.02470|*   |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.64| 0.02380|*   |
|all_sections_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.73| 0.02380|*   |
|all_sections_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.86| 0.02380|*   |
|all_sections_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.47| 0.90000|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.36| 0.90000|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.70| 0.02960|*   |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.96| 0.02960|*   |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.02| 0.98100|ns  |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.36| 0.04570|*   |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.62| 0.02960|*   |
|appendicular_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.99| 0.07680|ns  |
|appendicular_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.21| 0.05370|ns  |
|appendicular_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.93100|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.47| 0.90000|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.36| 0.90000|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.70| 0.02960|*   |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.96| 0.02960|*   |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.02| 0.98100|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.36| 0.04570|*   |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.62| 0.02960|*   |
|appendicular_dominance_refined      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.99| 0.07680|ns  |
|appendicular_dominance_refined      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.21| 0.05370|ns  |
|appendicular_dominance_refined      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.93100|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.58| 0.62100|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.12| 0.37400|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.34| 0.03180|*   |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.34| 0.03180|*   |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.69| 0.61400|ns  |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.67| 0.01880|*   |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.67| 0.01880|*   |
|density_evenness                    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.81| 0.01880|*   |
|density_evenness                    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.81| 0.01880|*   |
|density_evenness                    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.72| 0.58800|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.29| 0.85300|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.63| 0.05560|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.39| 0.05560|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.79| 0.58800|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.13| 0.06610|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.90| 0.09580|ns  |
|distal_appendicular_continuity_hm   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.43| 0.05560|ns  |
|distal_appendicular_continuity_hm   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.23| 0.06470|ns  |
|distal_appendicular_continuity_hm   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.18| 0.85300|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.15| 0.88400|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.62| 0.67000|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.49| 0.02530|*   |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.75| 0.02530|*   |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.71| 0.67000|ns  |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.36| 0.03040|*   |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.62| 0.02530|*   |
|dominance_gap_all                   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.55| 0.02530|*   |
|dominance_gap_all                   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.77| 0.02530|*   |
|dominance_gap_all                   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.88400|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.14| 0.31900|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.40| 0.23100|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.12| 0.05630|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.28| 0.04530|*   |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.57| 0.63100|ns  |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.80| 0.01260|*   |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.96| 0.01260|*   |
|effective_sections_hill1            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.83| 0.01260|*   |
|effective_sections_hill1            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.96| 0.01260|*   |
|effective_sections_hill1            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.22| 0.31600|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.15| 0.90200|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.42| 0.05150|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.26| 0.05880|ns  |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.72| 0.59200|ns  |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.15| 0.01360|*   |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.00| 0.01360|*   |
|low_density_axial_survival          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.14| 0.06470|ns  |
|low_density_axial_survival          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.01| 0.07440|ns  |
|low_density_axial_survival          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.85| 0.49200|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.59| 0.61600|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.50| 0.03080|*   |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.55| 0.03080|*   |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.18| 0.34100|ns  |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.00| 0.01360|*   |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.05| 0.01360|*   |
|low_density_survival_index          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.66| 0.16300|ns  |
|low_density_survival_index          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.70| 0.16300|ns  |
|low_density_survival_index          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.74| 0.65900|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.35| 0.88600|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.78| 0.04700|*   |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.60| 0.04700|*   |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.18| 0.88600|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.27| 0.07670|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.09| 0.07670|ns  |
|lower_appendicular_continuity_hm    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.07| 0.07670|ns  |
|lower_appendicular_continuity_hm    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.92| 0.09190|ns  |
|lower_appendicular_continuity_hm    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.14| 0.88600|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.33| 0.25500|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.77| 0.15400|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.10| 0.00983|**  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.36| 0.00789|**  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.80| 0.47200|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.21| 0.06860|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.46| 0.04600|*   |
|mnau_appendicular_mean              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.27| 0.25500|ns  |
|mnau_appendicular_mean              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.49| 0.22700|ns  |
|mnau_appendicular_mean              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.20| 0.83800|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.38| 0.78600|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.19| 0.33700|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.74| 0.02800|*   |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.92| 0.02800|*   |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.90| 0.46200|ns  |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.45| 0.03530|*   |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.64| 0.02800|*   |
|mnau_arms                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.41| 0.26600|ns  |
|mnau_arms                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.56| 0.23600|ns  |
|mnau_arms                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.15| 0.88500|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.20| 0.33100|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.27| 0.87100|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.48| 0.04350|*   |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.33| 0.05010|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.11| 0.33500|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.19| 0.01190|*   |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.04| 0.01190|*   |
|mnau_axial_main_mean                |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.88| 0.12100|ns  |
|mnau_axial_main_mean                |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.74| 0.13500|ns  |
|mnau_axial_main_mean                |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.92| 0.42800|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.87| 0.42800|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.46| 0.03450|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.57| 0.03420|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.50| 0.22300|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.00| 0.01340|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.10| 0.01340|*   |
|mnau_column_trunk_mean              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.41| 0.22500|ns  |
|mnau_column_trunk_mean              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.50| 0.22300|ns  |
|mnau_column_trunk_mean              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.08| 0.93500|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.86| 0.48900|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.10| 0.38700|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.23| 0.04280|*   |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.39| 0.03390|*   |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.48| 0.70400|ns  |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.73| 0.01760|*   |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.89| 0.01760|*   |
|mnau_cv                             |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.70| 0.01760|*   |
|mnau_cv                             |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.83| 0.01760|*   |
|mnau_cv                             |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.18| 0.34200|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.42| 0.75300|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.83| 0.04590|*   |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.60| 0.04670|*   |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.42| 0.75300|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.05| 0.10200|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.82| 0.11600|ns  |
|mnau_distal_appendicular_mean       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.06| 0.10200|ns  |
|mnau_distal_appendicular_mean       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.87| 0.11600|ns  |
|mnau_distal_appendicular_mean       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.18| 0.85300|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.32| 0.88500|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.49| 0.88500|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.77| 0.03890|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.66| 0.03890|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.26| 0.88500|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.52| 0.03930|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.42| 0.03930|*   |
|mnau_dominance_of_region_means      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.95| 0.10200|ns  |
|mnau_dominance_of_region_means      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.86| 0.10400|ns  |
|mnau_dominance_of_region_means      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.08| 0.93500|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.00| 0.39700|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.20| 0.32900|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.18| 0.04840|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.34| 0.03860|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.47| 0.70700|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.78| 0.01590|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.93| 0.01590|*   |
|mnau_evenness_minus_dominance       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.73| 0.01590|*   |
|mnau_evenness_minus_dominance       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.86| 0.01590|*   |
|mnau_evenness_minus_dominance       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.97| 0.47300|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.88| 0.47300|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.23| 0.04280|*   |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.39| 0.03390|*   |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.18| 0.90200|ns  |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.80| 0.02530|*   |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.96| 0.02530|*   |
|mnau_gini                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.53| 0.02840|*   |
|mnau_gini                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.66| 0.02590|*   |
|mnau_gini                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.69| 0.54500|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.82| 0.13800|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.92| 0.01750|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.24| 0.01220|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.30| 0.27800|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.44| 0.03690|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.75| 0.02000|*   |
|mnau_girdle_mean                    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.09| 0.34600|ns  |
|mnau_girdle_mean                    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.35| 0.27800|ns  |
|mnau_girdle_mean                    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.80500|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.12| 0.37600|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.42| 0.78600|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.44| 0.07240|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.71| 0.06750|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.37| 0.78600|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.70| 0.14900|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.96| 0.12600|ns  |
|mnau_hands                          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.74| 0.14900|ns  |
|mnau_hands                          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.96| 0.12600|ns  |
|mnau_hands                          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83600|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.14| 0.31900|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.40| 0.23100|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.12| 0.05630|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.28| 0.04530|*   |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.57| 0.63100|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.80| 0.01260|*   |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.96| 0.01260|*   |
|mnau_heip_evenness                  |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.83| 0.01260|*   |
|mnau_heip_evenness                  |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.96| 0.01260|*   |
|mnau_heip_evenness                  |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.86| 0.48900|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.10| 0.38700|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.23| 0.04280|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.39| 0.03390|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.48| 0.70400|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.73| 0.01760|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.89| 0.01760|*   |
|mnau_inverse_simpson                |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.70| 0.01760|*   |
|mnau_inverse_simpson                |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.83| 0.01760|*   |
|mnau_inverse_simpson                |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.41| 0.22700|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.68| 0.18500|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.31| 0.00918|**  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.05| 0.01140|*   |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.66| 0.56600|ns  |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.37| 0.05880|ns  |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.11| 0.08610|ns  |
|mnau_legs                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.52| 0.21400|ns  |
|mnau_legs                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.30| 0.24200|ns  |
|mnau_legs                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.83700|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.95| 0.42700|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.44| 0.21400|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.09| 0.01000|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.09| 0.01000|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.74| 0.50800|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.44| 0.03660|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.44| 0.03660|*   |
|mnau_limb_shaft_proxy_mean          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.51| 0.21400|ns  |
|mnau_limb_shaft_proxy_mean          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.51| 0.21400|ns  |
|mnau_limb_shaft_proxy_mean          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.07| 0.35800|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.47| 0.22000|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.14| 0.01320|*   |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.01| 0.01320|*   |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.69| 0.54600|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.42| 0.05230|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.29| 0.05550|ns  |
|mnau_lower_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.53| 0.22000|ns  |
|mnau_lower_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.42| 0.22000|ns  |
|mnau_lower_appendicular_mean        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.10| 0.91800|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.30| 0.79900|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.20| 0.38100|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.33| 0.06590|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.65| 0.06590|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.97| 0.41800|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.10| 0.08930|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.42| 0.06590|ns  |
|mnau_pelvic                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.05| 0.41800|ns  |
|mnau_pelvic                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.32| 0.37100|ns  |
|mnau_pelvic                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.79900|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.59| 0.61700|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.63| 0.20700|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.89| 0.01920|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.15| 0.01620|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.18| 0.29700|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.47| 0.03360|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.73| 0.02120|*   |
|mnau_postcranial_total_mean         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.21| 0.29700|ns  |
|mnau_postcranial_total_mean         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.42| 0.25700|ns  |
|mnau_postcranial_total_mean         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.20| 0.83800|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.96| 0.37400|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.75| 0.16000|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.00| 0.01350|*   |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.26| 0.01110|*   |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.04| 0.37300|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.35| 0.04750|*   |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.60| 0.03080|*   |
|mnau_proximal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.21| 0.32600|ns  |
|mnau_proximal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.42| 0.25700|ns  |
|mnau_proximal_appendicular_mean     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83800|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.19| 0.90200|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.42| 0.90200|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.64| 0.02600|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.48| 0.02600|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.28| 0.90200|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.72| 0.02600|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.56| 0.02600|*   |
|mnau_region_mean_evenness           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.53| 0.02600|*   |
|mnau_region_mean_evenness           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.40| 0.02740|*   |
|mnau_region_mean_evenness           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.78| 0.48500|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.78| 0.15100|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.86| 0.02140|*   |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.10| 0.01970|*   |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.20| 0.33100|ns  |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.32| 0.05080|ns  |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.55| 0.03550|*   |
|mnau_shoulder                       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.06| 0.35900|ns  |
|mnau_shoulder                       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.26| 0.33100|ns  |
|mnau_shoulder                       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.19| 0.85200|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.86| 0.48900|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.10| 0.38700|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.23| 0.04280|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.39| 0.03390|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.48| 0.70400|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.73| 0.01760|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.89| 0.01760|*   |
|mnau_simpson_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.70| 0.01760|*   |
|mnau_simpson_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.83| 0.01760|*   |
|mnau_simpson_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.86| 0.48900|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.10| 0.38700|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.23| 0.04280|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.39| 0.03390|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.48| 0.70400|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.73| 0.01760|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.89| 0.01760|*   |
|mnau_simpson_evenness               |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.70| 0.01760|*   |
|mnau_simpson_evenness               |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.83| 0.01760|*   |
|mnau_simpson_evenness               |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.30| 0.85800|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.51| 0.85800|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.55| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.50| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.29| 0.85800|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.70| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.65| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.52| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.48| 0.02200|*   |
|mnau_top2_share_mcnaughton          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.11| 0.33400|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.65| 0.19900|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.00| 0.01350|*   |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.31| 0.00923|**  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.83| 0.45000|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.25| 0.06090|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.56| 0.03490|*   |
|mnau_upper_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.28| 0.28500|ns  |
|mnau_upper_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.55| 0.20300|ns  |
|mnau_upper_appendicular_mean        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.80600|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.77| 0.49200|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  2.73| 0.02140|*   |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.93| 0.06700|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.14| 0.04730|*   |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  2.13| 0.04730|*   |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.38| 0.03460|*   |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.59| 0.02400|*   |
|mne_arms                            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -3.66| 0.00127|**  |
|mne_arms                            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -3.84| 0.00125|**  |
|mne_arms                            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.17| 0.86800|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.43| 0.73800|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.52| 0.73800|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.60| 0.02350|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.65| 0.02350|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.82| 0.59100|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.83| 0.02350|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.88| 0.02350|*   |
|postcranial_dominance_refined       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.79| 0.12300|ns  |
|postcranial_dominance_refined       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.83| 0.12300|ns  |
|postcranial_dominance_refined       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.04| 0.96700|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 5.72, R² = 0.459, p = 0.0001.
PCA variance explained: PC1 54.5%, PC2 11.1%, PC3 8.6% (cumulative 74.2%).
Dispersion caveat (PERMDISP): p = 0.059.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_cv                       |  0.164| -0.042|  0.078|
|mnau_postcranial_total_mean   | -0.164| -0.062|  0.042|
|mnau_top2_share_mcnaughton    |  0.163| -0.052|  0.099|
|mnau_evenness_minus_dominance | -0.163|  0.044| -0.072|
|mnau_region_mean_evenness     | -0.161|  0.031| -0.026|
|all_sections_dominance        |  0.161| -0.053|  0.065|
|mnau_simpson_dominance        |  0.161| -0.031|  0.036|
|mnau_appendicular_mean        | -0.160| -0.003|  0.122|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
