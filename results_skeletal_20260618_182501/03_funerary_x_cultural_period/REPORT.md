# Mortuary practice through time
*Automated funerary_context × cultural_period × skeletal-part representation*

- **Grouping column:** `funerary_context × cultural_period` (mode = interaction)
- **Groups (n):** Inhumation single | Upper Paleolithic = 13; Inhumation single | Middle Paleolithic = 10; Collective burial | Neolithic = 4; Carnivore den(transport) | Middle Paleolithic = 3; Carnivore Scavenge (in situ) | Middle Paleolithic = 3
- **Sites analysed:** 33  |  **features screened:** 63

## Hypothesis

**H:** Mortuary practice changes completeness and element selection through time.

**Expected pattern:** Single inhumations approach complete skeletons; collective burials over-represent crania/long bones; non-inhumation contexts more fragmentary.

**Why it matters:** Separates intentional mortuary behaviour from preservation loss (Robb: human handling can pattern representation).


## Summary

47 of 63 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.609, FDR p = 0.01052). PERMANOVA pseudo-F = 5.46, p = 0.0001; PC1–PC3 explain 74.0% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 75 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 15 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.609|  0.0105|large      |significant |
|mnau_appendicular_mean                       |  0.496|  0.0105|large      |significant |
|mnau_girdle_mean                             |  0.493|  0.0105|large      |significant |
|mnau_proximal_appendicular_mean              |  0.483|  0.0105|large      |significant |
|mnau_upper_appendicular_mean                 |  0.476|  0.0105|large      |significant |
|mnau_legs                                    |  0.470|  0.0105|large      |significant |
|mnau_postcranial_total_mean                  |  0.461|  0.0105|large      |significant |
|effective_sections_hill1                     |  0.452|  0.0105|large      |significant |
|mnau_heip_evenness                           |  0.452|  0.0105|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.445|  0.0105|large      |significant |
|mnau_shoulder                                |  0.441|  0.0105|large      |significant |
|ProportionalRep_MNIbased_fibula              |  0.437|  0.0105|large      |significant |
|mnau_lower_appendicular_mean                 |  0.432|  0.0105|large      |significant |
|mnau_evenness_minus_dominance                |  0.430|  0.0105|large      |significant |
|ProportionalRep_MNIbased_humerus             |  0.427|  0.0105|large      |significant |
|mnau_column_trunk_mean                       |  0.421|  0.0105|large      |significant |
|mnau_cv                                      |  0.417|  0.0105|large      |significant |
|mnau_inverse_simpson                         |  0.417|  0.0105|large      |significant |
|mnau_simpson_dominance                       |  0.417|  0.0105|large      |significant |
|mnau_simpson_evenness                        |  0.417|  0.0105|large      |significant |
|mnau_axial_main_mean                         |  0.416|  0.0105|large      |significant |
|mnau_gini                                    |  0.411|  0.0105|large      |significant |
|low_density_survival_index                   |  0.408|  0.0105|large      |significant |
|low_density_axial_survival                   |  0.404|  0.0105|large      |significant |
|density_evenness                             |  0.400|  0.0105|large      |significant |
|all_sections_dominance                       |  0.399|  0.0105|large      |significant |
|ProportionalRep_MNIbased_tibia               |  0.392|  0.0106|large      |significant |
|postcranial_dominance_refined                |  0.389|  0.0106|large      |significant |
|dominance_gap_all                            |  0.386|  0.0106|large      |significant |
|mnau_arms                                    |  0.383|  0.0106|large      |significant |
|appendicular_dominance                       |  0.379|  0.0106|large      |significant |
|appendicular_dominance_refined               |  0.379|  0.0106|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.379|  0.0106|large      |significant |
|ProportionalRep_MNIbased_clavicle            |  0.377|  0.0106|large      |significant |
|mnau_region_mean_evenness                    |  0.374|  0.0106|large      |significant |
|ProportionalRep_MNIbased_femur               |  0.343|  0.0152|large      |significant |
|mnau_dominance_of_region_means               |  0.340|  0.0154|large      |significant |
|ProportionalRep_MNIbased_radius              |  0.330|  0.0167|large      |significant |
|ProportionalRep_MNIbased_os_coxae            |  0.320|  0.0186|large      |significant |
|lower_appendicular_continuity_hm             |  0.308|  0.0209|large      |significant |
|mnau_distal_appendicular_mean                |  0.306|  0.0209|large      |significant |
|ReMNAU_ulna                                  |  0.292|  0.0243|large      |significant |
|distal_appendicular_continuity_hm            |  0.287|  0.0251|large      |significant |
|ReMNAU_radius                                |  0.278|  0.0271|large      |significant |
|mnau_pelvic                                  |  0.270|  0.0294|large      |significant |
|mnau_hands                                   |  0.263|  0.0312|large      |significant |
|ProportionalRep_MNIbased_metacarpal          |  0.236|  0.0420|large      |significant |
|ReMNAU_cervical                              |  0.211|  0.0546|large      |n.s.        |
|ProportionalRep_MNIbased_cervical            |  0.210|  0.0546|large      |n.s.        |
|ProportionalRep_MNIbased_carpal              |  0.186|  0.0703|large      |n.s.        |
|mnau_foot                                    |  0.183|  0.0715|large      |n.s.        |
|low_density_share                            |  0.176|  0.0760|large      |n.s.        |
|lower_appendicular_evenness                  |  0.092|  0.2010|moderate   |n.s.        |
|lower_appendicular_evenness_refined          |  0.092|  0.2010|moderate   |n.s.        |
|mnau_arms_legs_logratio                      |  0.057|  0.2610|small      |n.s.        |
|mnau_arms_to_legs_ratio                      |  0.057|  0.2610|small      |n.s.        |
|density_adjusted_appendicular_axial_contrast |  0.053|  0.2670|small      |n.s.        |
|mne_vertebrae_to_thorax_ratio                |  0.010|  0.4030|negligible |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.004|  0.4160|negligible |n.s.        |
|mnau_arms_legs_diff                          | -0.025|  0.5360|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.041|  0.6040|negligible |n.s.        |
|dominant_axial_share                         | -0.059|  0.6810|negligible |n.s.        |
|mne_cranial_share                            | -0.067|  0.7130|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                             |Contrast                                                                                                     |     Z| p (adj)|Sig |
|:-----------------------------------|:------------------------------------------------------------------------------------------------------------|-----:|-------:|:---|
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.08| 0.93400|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.39| 0.28400|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.55| 0.03600|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.83| 0.03480|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.28| 0.28400|ns  |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.43| 0.03800|*   |
|ProportionalRep_MNIbased_clavicle   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.70| 0.03480|*   |
|ProportionalRep_MNIbased_clavicle   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.10| 0.34000|ns  |
|ProportionalRep_MNIbased_clavicle   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.33| 0.28400|ns  |
|ProportionalRep_MNIbased_clavicle   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.22| 0.91900|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.82| 0.51400|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.13| 0.37200|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.94| 0.03320|*   |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.65| 0.03970|*   |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.50| 0.68300|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.33| 0.06580|ns  |
|ProportionalRep_MNIbased_femur      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.06| 0.09920|ns  |
|ProportionalRep_MNIbased_femur      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.62| 0.21100|ns  |
|ProportionalRep_MNIbased_femur      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.38| 0.27800|ns  |
|ProportionalRep_MNIbased_femur      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.22| 0.82500|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.18| 0.34200|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.85| 0.13000|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.15| 0.01630|*   |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.87| 0.02040|*   |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.95| 0.38100|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.31| 0.06910|ns  |
|ProportionalRep_MNIbased_fibula     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.04| 0.10300|ns  |
|ProportionalRep_MNIbased_fibula     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.26| 0.34200|ns  |
|ProportionalRep_MNIbased_fibula     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.03| 0.38100|ns  |
|ProportionalRep_MNIbased_fibula     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.22| 0.82700|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.20| 0.87800|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.31| 0.27300|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.78| 0.01910|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.97| 0.01910|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.12| 0.32900|ns  |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.57| 0.02530|*   |
|ProportionalRep_MNIbased_humerus    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.76| 0.01910|*   |
|ProportionalRep_MNIbased_humerus    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.35| 0.27300|ns  |
|ProportionalRep_MNIbased_humerus    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.51| 0.26000|ns  |
|ProportionalRep_MNIbased_humerus    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.15| 0.87800|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.71| 0.68700|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.44| 0.82800|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.32| 0.10100|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.60| 0.09440|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.08| 0.93700|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.81| 0.14100|ns  |
|ProportionalRep_MNIbased_metacarpal |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.07| 0.12700|ns  |
|ProportionalRep_MNIbased_metacarpal |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.62| 0.17500|ns  |
|ProportionalRep_MNIbased_metacarpal |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.85| 0.14100|ns  |
|ProportionalRep_MNIbased_metacarpal |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.92300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.41| 0.76100|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.47| 0.28300|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.43| 0.05060|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.77| 0.05060|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.13| 0.36700|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.10| 0.08860|ns  |
|ProportionalRep_MNIbased_os_coxae   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.44| 0.05060|ns  |
|ProportionalRep_MNIbased_os_coxae   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -0.94| 0.43700|ns  |
|ProportionalRep_MNIbased_os_coxae   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.22| 0.36700|ns  |
|ProportionalRep_MNIbased_os_coxae   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.27| 0.78800|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.03| 1.00000|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.91| 0.45800|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.59| 0.02830|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.59| 0.02830|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.90| 0.45800|ns  |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.53| 0.02830|*   |
|ProportionalRep_MNIbased_radius     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.53| 0.02830|*   |
|ProportionalRep_MNIbased_radius     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.48| 0.23000|ns  |
|ProportionalRep_MNIbased_radius     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.48| 0.23000|ns  |
|ProportionalRep_MNIbased_radius     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.01| 0.43200|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.94| 0.43200|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.96| 0.01530|*   |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.96| 0.01530|*   |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.19| 0.94100|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.24| 0.06340|ns  |
|ProportionalRep_MNIbased_tibia      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.24| 0.06340|ns  |
|ProportionalRep_MNIbased_tibia      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.78| 0.12600|ns  |
|ProportionalRep_MNIbased_tibia      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.78| 0.12600|ns  |
|ProportionalRep_MNIbased_tibia      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.51| 0.87100|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.07| 1.00000|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.26| 0.05980|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.26| 0.05980|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.29| 0.96300|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.52| 0.05810|ns  |
|ReMNAU_radius                       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.52| 0.05810|ns  |
|ReMNAU_radius                       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.95| 0.08550|ns  |
|ReMNAU_radius                       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.95| 0.08550|ns  |
|ReMNAU_radius                       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.79| 0.61000|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.18| 0.95000|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.61| 0.04530|*   |
|ReMNAU_ulna                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.61| 0.04530|*   |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.39| 0.87200|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.03| 0.07040|ns  |
|ReMNAU_ulna                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.03| 0.07040|ns  |
|ReMNAU_ulna                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.05| 0.07040|ns  |
|ReMNAU_ulna                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.05| 0.07040|ns  |
|ReMNAU_ulna                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.26| 0.88400|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.93| 0.50200|ns  |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.40| 0.02750|*   |
|all_sections_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.56| 0.02500|*   |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.72| 0.59200|ns  |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.50| 0.02500|*   |
|all_sections_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.66| 0.02500|*   |
|all_sections_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.71| 0.02500|*   |
|all_sections_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.84| 0.02500|*   |
|all_sections_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.47| 0.89700|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.36| 0.89700|ns  |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.69| 0.03270|*   |
|appendicular_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.96| 0.03070|*   |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.02| 0.98600|ns  |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.32| 0.05080|ns  |
|appendicular_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.58| 0.03270|*   |
|appendicular_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.99| 0.07830|ns  |
|appendicular_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.21| 0.05390|ns  |
|appendicular_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.92500|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.47| 0.89700|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.36| 0.89700|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.69| 0.03270|*   |
|appendicular_dominance_refined      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.96| 0.03070|*   |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.02| 0.98600|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.32| 0.05080|ns  |
|appendicular_dominance_refined      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.58| 0.03270|*   |
|appendicular_dominance_refined      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.99| 0.07830|ns  |
|appendicular_dominance_refined      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.21| 0.05390|ns  |
|appendicular_dominance_refined      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.92500|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.56| 0.64100|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.09| 0.39400|ns  |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.35| 0.03110|*   |
|density_evenness                    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.35| 0.03110|*   |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.66| 0.64000|ns  |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.65| 0.02040|*   |
|density_evenness                    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.65| 0.02040|*   |
|density_evenness                    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.79| 0.02040|*   |
|density_evenness                    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.79| 0.02040|*   |
|density_evenness                    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.74| 0.57700|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.26| 0.84900|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.62| 0.05790|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.38| 0.05790|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.78| 0.57700|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.08| 0.07500|ns  |
|distal_appendicular_continuity_hm   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.84| 0.10900|ns  |
|distal_appendicular_continuity_hm   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.40| 0.05790|ns  |
|distal_appendicular_continuity_hm   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.19| 0.07080|ns  |
|distal_appendicular_continuity_hm   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.19| 0.84900|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.01| 0.99200|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.64| 0.67600|ns  |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.44| 0.02860|*   |
|dominance_gap_all                   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.71| 0.02720|*   |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.61| 0.67600|ns  |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.38| 0.02860|*   |
|dominance_gap_all                   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.65| 0.02720|*   |
|dominance_gap_all                   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.53| 0.02860|*   |
|dominance_gap_all                   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.75| 0.02720|*   |
|dominance_gap_all                   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.92500|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.10| 0.34000|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.36| 0.24800|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.14| 0.05440|ns  |
|effective_sections_hill1            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.30| 0.04310|*   |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.53| 0.66000|ns  |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.78| 0.01360|*   |
|effective_sections_hill1            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.94| 0.01360|*   |
|effective_sections_hill1            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.81| 0.01360|*   |
|effective_sections_hill1            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.95| 0.01360|*   |
|effective_sections_hill1            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.13| 0.89900|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.97| 0.47600|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.15| 0.89900|ns  |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.49| 0.04200|*   |
|low_density_axial_survival          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.33| 0.04910|*   |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.54| 0.73400|ns  |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.05| 0.01940|*   |
|low_density_axial_survival          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.89| 0.01940|*   |
|low_density_axial_survival          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.20| 0.05500|ns  |
|low_density_axial_survival          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.07| 0.06430|ns  |
|low_density_axial_survival          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.63| 0.61300|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.60| 0.61300|ns  |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.56| 0.02580|*   |
|low_density_survival_index          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.62| 0.02580|*   |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.02| 0.43700|ns  |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.90| 0.01880|*   |
|low_density_survival_index          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.95| 0.01880|*   |
|low_density_survival_index          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.71| 0.14700|ns  |
|low_density_survival_index          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.75| 0.14700|ns  |
|low_density_survival_index          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96600|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.69| 0.69800|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.38| 0.87700|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.76| 0.05000|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.58| 0.05000|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.12| 0.90300|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.25| 0.08210|ns  |
|lower_appendicular_continuity_hm    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.06| 0.08440|ns  |
|lower_appendicular_continuity_hm    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.03| 0.08440|ns  |
|lower_appendicular_continuity_hm    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.87| 0.10200|ns  |
|lower_appendicular_continuity_hm    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.15| 0.90300|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.26| 0.26100|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.73| 0.16800|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.06| 0.01090|*   |
|mnau_appendicular_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.33| 0.00860|**  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.78| 0.48500|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.18| 0.07340|ns  |
|mnau_appendicular_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.44| 0.04890|*   |
|mnau_appendicular_mean              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.28| 0.26100|ns  |
|mnau_appendicular_mean              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.50| 0.22200|ns  |
|mnau_appendicular_mean              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83300|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.27| 0.87300|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.13| 0.36700|ns  |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.70| 0.02770|*   |
|mnau_arms                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.89| 0.02770|*   |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.90| 0.45900|ns  |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.45| 0.03530|*   |
|mnau_arms                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.64| 0.02770|*   |
|mnau_arms                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.42| 0.26100|ns  |
|mnau_arms                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.58| 0.23000|ns  |
|mnau_arms                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.15| 0.88100|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.95| 0.43000|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.28| 0.86400|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.56| 0.03520|*   |
|mnau_axial_main_mean                |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.40| 0.04150|*   |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.95| 0.43000|ns  |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.09| 0.01670|*   |
|mnau_axial_main_mean                |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.94| 0.01670|*   |
|mnau_axial_main_mean                |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.93| 0.10600|ns  |
|mnau_axial_main_mean                |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.80| 0.12000|ns  |
|mnau_axial_main_mean                |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.67| 0.56100|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.89| 0.46400|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.54| 0.02800|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.64| 0.02730|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.34| 0.25800|ns  |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.89| 0.01910|*   |
|mnau_column_trunk_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.00| 0.01910|*   |
|mnau_column_trunk_mean              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.46| 0.24200|ns  |
|mnau_column_trunk_mean              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.55| 0.24200|ns  |
|mnau_column_trunk_mean              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.08| 0.93300|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.81| 0.52600|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.05| 0.41700|ns  |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.25| 0.04100|*   |
|mnau_cv                             |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.41| 0.03190|*   |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.45| 0.72900|ns  |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.70| 0.01870|*   |
|mnau_cv                             |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.86| 0.01870|*   |
|mnau_cv                             |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.67| 0.01870|*   |
|mnau_cv                             |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.81| 0.01870|*   |
|mnau_cv                             |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.16| 0.35000|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.46| 0.77800|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.82| 0.04800|*   |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.58| 0.04980|*   |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.39| 0.77800|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.00| 0.11300|ns  |
|mnau_distal_appendicular_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.77| 0.12900|ns  |
|mnau_distal_appendicular_mean       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.02| 0.11300|ns  |
|mnau_distal_appendicular_mean       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.82| 0.12900|ns  |
|mnau_distal_appendicular_mean       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.19| 0.84900|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.34| 0.92000|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.46| 0.92000|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.76| 0.03980|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.65| 0.03980|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.20| 0.93300|ns  |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.47| 0.04480|*   |
|mnau_dominance_of_region_means      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.37| 0.04480|*   |
|mnau_dominance_of_region_means      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.97| 0.09660|ns  |
|mnau_dominance_of_region_means      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.88| 0.09920|ns  |
|mnau_dominance_of_region_means      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.08| 0.93300|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.96| 0.42400|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.15| 0.35400|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.20| 0.04650|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.36| 0.03650|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.44| 0.73600|ns  |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.75| 0.01690|*   |
|mnau_evenness_minus_dominance       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.91| 0.01690|*   |
|mnau_evenness_minus_dominance       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.71| 0.01690|*   |
|mnau_evenness_minus_dominance       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.84| 0.01690|*   |
|mnau_evenness_minus_dominance       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.13| 0.89900|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.90| 0.47800|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.87| 0.47800|ns  |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.25| 0.04100|*   |
|mnau_gini                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.41| 0.03190|*   |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.20| 0.89900|ns  |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.77| 0.02500|*   |
|mnau_gini                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.92| 0.02500|*   |
|mnau_gini                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.54| 0.02780|*   |
|mnau_gini                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.67| 0.02500|*   |
|mnau_gini                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.83| 0.44900|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.81| 0.14000|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.95| 0.01580|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.28| 0.01050|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.16| 0.32800|ns  |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.34| 0.04820|*   |
|mnau_girdle_mean                    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.66| 0.02640|*   |
|mnau_girdle_mean                    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.12| 0.32800|ns  |
|mnau_girdle_mean                    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.39| 0.27300|ns  |
|mnau_girdle_mean                    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.79900|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.16| 0.35400|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.37| 0.79400|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.42| 0.07760|ns  |
|mnau_hands                          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.69| 0.07110|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.47| 0.79400|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.62| 0.17700|ns  |
|mnau_hands                          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.88| 0.15000|ns  |
|mnau_hands                          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.76| 0.15800|ns  |
|mnau_hands                          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.98| 0.15000|ns  |
|mnau_hands                          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83100|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.10| 0.34000|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.36| 0.24800|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.14| 0.05440|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.30| 0.04310|*   |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.53| 0.66000|ns  |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.78| 0.01360|*   |
|mnau_heip_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.94| 0.01360|*   |
|mnau_heip_evenness                  |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.81| 0.01360|*   |
|mnau_heip_evenness                  |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.95| 0.01360|*   |
|mnau_heip_evenness                  |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.13| 0.89900|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.81| 0.52500|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.05| 0.41700|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.25| 0.04090|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.41| 0.03190|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.45| 0.72900|ns  |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.70| 0.01870|*   |
|mnau_inverse_simpson                |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.86| 0.01870|*   |
|mnau_inverse_simpson                |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.67| 0.01870|*   |
|mnau_inverse_simpson                |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.81| 0.01870|*   |
|mnau_inverse_simpson                |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.13| 0.89900|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.20| 0.28600|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.70| 0.17700|ns  |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.27| 0.01090|*   |
|mnau_legs                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.99| 0.01370|*   |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.79| 0.47700|ns  |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.41| 0.05340|ns  |
|mnau_legs                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.15| 0.07980|ns  |
|mnau_legs                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.46| 0.23900|ns  |
|mnau_legs                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.24| 0.28600|ns  |
|mnau_legs                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.83200|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.79| 0.47900|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.42| 0.22200|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.05| 0.01160|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.05| 0.01160|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.81| 0.47900|ns  |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.46| 0.03460|*   |
|mnau_limb_shaft_proxy_mean          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.46| 0.03460|*   |
|mnau_limb_shaft_proxy_mean          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.49| 0.22200|ns  |
|mnau_limb_shaft_proxy_mean          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.49| 0.22200|ns  |
|mnau_limb_shaft_proxy_mean          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.00| 1.00000|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.98| 0.41000|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.42| 0.22400|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.11| 0.01470|*   |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.97| 0.01470|*   |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.67| 0.55700|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.40| 0.05480|ns  |
|mnau_lower_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.27| 0.05830|ns  |
|mnau_lower_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.55| 0.22400|ns  |
|mnau_lower_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.43| 0.22400|ns  |
|mnau_lower_appendicular_mean        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.11| 0.91600|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.48| 0.70500|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.18| 0.39700|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.34| 0.07170|ns  |
|mnau_pelvic                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.68| 0.07170|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.80| 0.52800|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.98| 0.12100|ns  |
|mnau_pelvic                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.30| 0.07170|ns  |
|mnau_pelvic                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.08| 0.39900|ns  |
|mnau_pelvic                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.36| 0.34700|ns  |
|mnau_pelvic                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.26| 0.79400|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.67| 0.56200|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.59| 0.22200|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.90| 0.01850|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.17| 0.01520|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.07| 0.35800|ns  |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.40| 0.04120|*   |
|mnau_postcranial_total_mean         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.66| 0.02600|*   |
|mnau_postcranial_total_mean         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.24| 0.30600|ns  |
|mnau_postcranial_total_mean         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.47| 0.23700|ns  |
|mnau_postcranial_total_mean         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83300|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.95| 0.38200|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.74| 0.16500|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.99| 0.01400|*   |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.26| 0.01120|*   |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.01| 0.38200|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.30| 0.05300|ns  |
|mnau_proximal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.57| 0.03420|*   |
|mnau_proximal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.21| 0.32500|ns  |
|mnau_proximal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.43| 0.25300|ns  |
|mnau_proximal_appendicular_mean     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83300|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.13| 0.89900|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.41| 0.89900|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.66| 0.02510|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.50| 0.02510|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.31| 0.89900|ns  |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.67| 0.02510|*   |
|mnau_region_mean_evenness           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.51| 0.02510|*   |
|mnau_region_mean_evenness           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.54| 0.02510|*   |
|mnau_region_mean_evenness           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.40| 0.02710|*   |
|mnau_region_mean_evenness           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.89| 0.41400|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.76| 0.15800|ns  |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.88| 0.02010|*   |
|mnau_shoulder                       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.12| 0.01800|*   |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.06| 0.36000|ns  |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.23| 0.06450|ns  |
|mnau_shoulder                       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.47| 0.04530|*   |
|mnau_shoulder                       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.10| 0.36000|ns  |
|mnau_shoulder                       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.30| 0.32100|ns  |
|mnau_shoulder                       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.19| 0.84700|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.81| 0.52500|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.05| 0.41700|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.25| 0.04090|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.41| 0.03190|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.45| 0.72900|ns  |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.70| 0.01870|*   |
|mnau_simpson_dominance              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.86| 0.01870|*   |
|mnau_simpson_dominance              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.67| 0.01870|*   |
|mnau_simpson_dominance              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.81| 0.01870|*   |
|mnau_simpson_dominance              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.13| 0.89900|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.81| 0.52500|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.05| 0.41700|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.25| 0.04090|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.41| 0.03190|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.45| 0.72900|ns  |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.70| 0.01870|*   |
|mnau_simpson_evenness               |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.86| 0.01870|*   |
|mnau_simpson_evenness               |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.67| 0.01870|*   |
|mnau_simpson_evenness               |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.81| 0.01870|*   |
|mnau_simpson_evenness               |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.13| 0.89900|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.28| 0.86400|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.52| 0.86400|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.56| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.50| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.30| 0.86400|ns  |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.67| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.62| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.53| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.48| 0.02160|*   |
|mnau_top2_share_mcnaughton          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96600|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.13| 0.32200|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.58| 0.18900|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.99| 0.01400|*   |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.31| 0.00924|**  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.73| 0.52000|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.19| 0.07210|ns  |
|mnau_upper_appendicular_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.50| 0.04140|*   |
|mnau_upper_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.32| 0.26600|ns  |
|mnau_upper_appendicular_mean        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.59| 0.18900|ns  |
|mnau_upper_appendicular_mean        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.80000|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.96| 0.37200|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  2.77| 0.01880|*   |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.86| 0.07790|ns  |
|mne_arms                            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.08| 0.06210|ns  |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  1.99| 0.06660|ns  |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.43| 0.03020|*   |
|mne_arms                            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.64| 0.02060|*   |
|mne_arms                            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -3.64| 0.00139|**  |
|mne_arms                            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -3.82| 0.00134|**  |
|mne_arms                            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.17| 0.86400|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.38| 0.78000|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.51| 0.75800|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.61| 0.02240|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.67| 0.02240|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.77| 0.63100|ns  |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.79| 0.02240|*   |
|postcranial_dominance_refined       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.84| 0.02240|*   |
|postcranial_dominance_refined       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.81| 0.11800|ns  |
|postcranial_dominance_refined       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.85| 0.11800|ns  |
|postcranial_dominance_refined       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.04| 0.96600|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 5.46, R² = 0.457, p = 0.0001.
PCA variance explained: PC1 54.9%, PC2 10.8%, PC3 8.3% (cumulative 74.0%).
Dispersion caveat (PERMDISP): p = 0.075.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|mnau_postcranial_total_mean   | -0.163| -0.064|  0.032|
|mnau_cv                       |  0.163| -0.053|  0.072|
|mnau_top2_share_mcnaughton    |  0.162| -0.067|  0.091|
|mnau_evenness_minus_dominance | -0.162|  0.055| -0.065|
|mnau_region_mean_evenness     | -0.160|  0.035| -0.020|
|all_sections_dominance        |  0.160| -0.061|  0.058|
|mnau_appendicular_mean        | -0.160| -0.025|  0.118|
|mnau_simpson_dominance        |  0.160| -0.036|  0.031|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
