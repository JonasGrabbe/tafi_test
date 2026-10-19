# Mortuary practice through time
*Automated funerary_context × cultural_period × skeletal-part representation*

- **Grouping column:** `funerary_context × cultural_period` (mode = interaction)
- **Groups (n):** Inhumation single | Upper Paleolithic = 13; Inhumation single | Middle Paleolithic = 11; Collective burial | Neolithic = 4; Carnivore den(transport) | Middle Paleolithic = 3; Carnivore Scavenge (in situ) | Middle Paleolithic = 3
- **Sites analysed:** 34  |  **features screened:** 50

## Hypothesis

**H:** Mortuary practice changes completeness and element selection through time.

**Expected pattern:** Single inhumations approach complete skeletons; collective burials over-represent crania/long bones; non-inhumation contexts more fragmentary.

**Why it matters:** Separates intentional mortuary behaviour from preservation loss (Robb: human handling can pattern representation).


## Summary

38 of 50 features differ significantly across groups after BH-FDR correction. Strongest discriminator: **mne_arms** (ε² = 0.584, FDR p = 0.007405). PERMANOVA pseudo-F = 6.29, p = 0.0001; PC1–PC3 explain 77.5% of variance.


## 1. Data-quality screening

Flagged 4 numerically degenerate ratio feature(s): mnau_arms_to_legs_ratio, mne_arms_to_legs_ratio, mnau_vertebrae_to_thorax_ratio, mne_vertebrae_to_thorax_ratio. These are kept for the rank tests (scale-invariant) but dropped from / log-transformed for the multivariate analysis.


## 2. Assumption checks

Shapiro-Wilk: 66 feature×group cells depart from normality (p < 0.05). Levene (median-centred): 11 features show heterogeneous variance. Rank-based testing is therefore the appropriate primary route.


## 3. Omnibus comparison (Kruskal-Wallis, BH-FDR)

|Feature                                      |   eps2| p (FDR)|Effect     |Result      |
|:--------------------------------------------|------:|-------:|:----------|:-----------|
|mne_arms                                     |  0.584| 0.00740|large      |significant |
|dominance_gap_all                            |  0.523| 0.00740|large      |significant |
|mnau_appendicular_mean                       |  0.488| 0.00740|large      |significant |
|mnau_legs                                    |  0.467| 0.00740|large      |significant |
|mnau_proximal_appendicular_mean              |  0.467| 0.00740|large      |significant |
|mnau_limb_shaft_proxy_mean                   |  0.466| 0.00740|large      |significant |
|mnau_postcranial_total_mean                  |  0.456| 0.00740|large      |significant |
|mnau_upper_appendicular_mean                 |  0.455| 0.00740|large      |significant |
|effective_sections_hill1                     |  0.455| 0.00740|large      |significant |
|mnau_heip_evenness                           |  0.455| 0.00740|large      |significant |
|mnau_shoulder                                |  0.430| 0.00740|large      |significant |
|mnau_lower_appendicular_mean                 |  0.429| 0.00740|large      |significant |
|mnau_gini                                    |  0.426| 0.00740|large      |significant |
|mnau_evenness_minus_dominance                |  0.426| 0.00740|large      |significant |
|mnau_axial_main_mean                         |  0.423| 0.00740|large      |significant |
|low_density_axial_survival                   |  0.418| 0.00740|large      |significant |
|mnau_girdle_mean                             |  0.414| 0.00740|large      |significant |
|mnau_cv                                      |  0.412| 0.00740|large      |significant |
|mnau_inverse_simpson                         |  0.412| 0.00740|large      |significant |
|mnau_simpson_dominance                       |  0.412| 0.00740|large      |significant |
|mnau_simpson_evenness                        |  0.412| 0.00740|large      |significant |
|low_density_survival_index                   |  0.406| 0.00755|large      |significant |
|mnau_column_trunk_mean                       |  0.401| 0.00774|large      |significant |
|density_evenness                             |  0.395| 0.00798|large      |significant |
|mnau_top2_share_mcnaughton                   |  0.390| 0.00818|large      |significant |
|mnau_arms                                    |  0.378| 0.00859|large      |significant |
|appendicular_dominance                       |  0.376| 0.00859|large      |significant |
|appendicular_dominance_refined               |  0.376| 0.00859|large      |significant |
|mnau_region_mean_evenness                    |  0.375| 0.00859|large      |significant |
|all_sections_dominance                       |  0.366| 0.00926|large      |significant |
|postcranial_dominance_refined                |  0.364| 0.00926|large      |significant |
|mnau_arms_legs_diff                          |  0.339| 0.01220|large      |significant |
|mnau_pelvic                                  |  0.326| 0.01390|large      |significant |
|mnau_dominance_of_region_means               |  0.313| 0.01600|large      |significant |
|lower_appendicular_continuity_hm             |  0.300| 0.01830|large      |significant |
|mnau_distal_appendicular_mean                |  0.290| 0.02030|large      |significant |
|distal_appendicular_continuity_hm            |  0.275| 0.02380|large      |significant |
|mnau_hands                                   |  0.258| 0.02840|large      |significant |
|low_density_share                            |  0.206| 0.05260|large      |n.s.        |
|mnau_foot                                    |  0.191| 0.06120|large      |n.s.        |
|lower_appendicular_evenness                  |  0.109| 0.16500|moderate   |n.s.        |
|lower_appendicular_evenness_refined          |  0.109| 0.16500|moderate   |n.s.        |
|mnau_vertebrae_to_thorax_ratio               |  0.066| 0.23800|moderate   |n.s.        |
|mne_vertebrae_to_thorax_ratio                | -0.008| 0.49700|negligible |n.s.        |
|density_adjusted_appendicular_axial_contrast | -0.010| 0.49700|negligible |n.s.        |
|mnau_arms_legs_logratio                      | -0.024| 0.54000|negligible |n.s.        |
|mnau_arms_to_legs_ratio                      | -0.024| 0.54000|negligible |n.s.        |
|mne_arms_to_legs_ratio                       | -0.032| 0.56800|negligible |n.s.        |
|dominant_axial_share                         | -0.056| 0.68100|negligible |n.s.        |
|mne_cranial_share                            | -0.074| 0.76100|negligible |n.s.        |

## 4. Post-hoc pairwise contrasts (Dunn, BH)

|Feature                           |Contrast                                                                                                     |     Z| p (adj)|Sig |
|:---------------------------------|:------------------------------------------------------------------------------------------------------------|-----:|-------:|:---|
|all_sections_dominance            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.64| 0.74500|ns  |
|all_sections_dominance            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.06| 0.94900|ns  |
|all_sections_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.26| 0.04820|*   |
|all_sections_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.67| 0.02920|*   |
|all_sections_dominance            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.39| 0.82500|ns  |
|all_sections_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.62| 0.02920|*   |
|all_sections_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  3.03| 0.02430|*   |
|all_sections_dominance            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.94| 0.08740|ns  |
|all_sections_dominance            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.29| 0.04820|*   |
|all_sections_dominance            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.33| 0.82500|ns  |
|appendicular_dominance            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.25| 0.89400|ns  |
|appendicular_dominance            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.53| 0.74200|ns  |
|appendicular_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.58| 0.02230|*   |
|appendicular_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.74| 0.02230|*   |
|appendicular_dominance            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.70| 0.69500|ns  |
|appendicular_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.38| 0.02860|*   |
|appendicular_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.54| 0.02230|*   |
|appendicular_dominance            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.56| 0.02230|*   |
|appendicular_dominance            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.70| 0.02230|*   |
|appendicular_dominance            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|appendicular_dominance_refined    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.25| 0.89400|ns  |
|appendicular_dominance_refined    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.53| 0.74200|ns  |
|appendicular_dominance_refined    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.58| 0.02230|*   |
|appendicular_dominance_refined    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.74| 0.02230|*   |
|appendicular_dominance_refined    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.70| 0.69500|ns  |
|appendicular_dominance_refined    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.38| 0.02860|*   |
|appendicular_dominance_refined    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.54| 0.02230|*   |
|appendicular_dominance_refined    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.56| 0.02230|*   |
|appendicular_dominance_refined    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.70| 0.02230|*   |
|appendicular_dominance_refined    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|density_evenness                  |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.13| 0.36900|ns  |
|density_evenness                  |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.95| 0.42800|ns  |
|density_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.01| 0.07320|ns  |
|density_evenness                  |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.38| 0.03460|*   |
|density_evenness                  |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.14| 0.89100|ns  |
|density_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.69| 0.02370|*   |
|density_evenness                  |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.05| 0.02280|*   |
|density_evenness                  |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.40| 0.03460|*   |
|density_evenness                  |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.71| 0.02370|*   |
|density_evenness                  |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.29| 0.86000|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.68| 0.61700|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.37| 0.79400|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.61| 0.06610|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.32| 0.06610|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.84| 0.57400|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.13| 0.06610|ns  |
|distal_appendicular_continuity_hm |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.85| 0.10800|ns  |
|distal_appendicular_continuity_hm |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.46| 0.06610|ns  |
|distal_appendicular_continuity_hm |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.22| 0.06610|ns  |
|distal_appendicular_continuity_hm |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.23| 0.82100|ns  |
|dominance_gap_all                 |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.49| 0.68900|ns  |
|dominance_gap_all                 |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.38| 0.24100|ns  |
|dominance_gap_all                 |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.62| 0.02230|*   |
|dominance_gap_all                 |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  3.13| 0.00888|**  |
|dominance_gap_all                 |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  1.69| 0.18000|ns  |
|dominance_gap_all                 |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.88| 0.01310|*   |
|dominance_gap_all                 |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  3.38| 0.00714|**  |
|dominance_gap_all                 |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.16| 0.30600|ns  |
|dominance_gap_all                 |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.59| 0.18600|ns  |
|dominance_gap_all                 |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.40| 0.68900|ns  |
|effective_sections_hill1          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.28| 0.24900|ns  |
|effective_sections_hill1          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.40| 0.23300|ns  |
|effective_sections_hill1          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.98| 0.07910|ns  |
|effective_sections_hill1          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.35| 0.03780|*   |
|effective_sections_hill1          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.47| 0.71300|ns  |
|effective_sections_hill1          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.76| 0.01700|*   |
|effective_sections_hill1          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.12| 0.01290|*   |
|effective_sections_hill1          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.71| 0.01700|*   |
|effective_sections_hill1          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -3.01| 0.01290|*   |
|effective_sections_hill1          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.29| 0.77400|ns  |
|low_density_axial_survival        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.23| 0.31400|ns  |
|low_density_axial_survival        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.04| 0.96500|ns  |
|low_density_axial_survival        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.43| 0.04980|*   |
|low_density_axial_survival        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.28| 0.05700|ns  |
|low_density_axial_survival        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.82| 0.51700|ns  |
|low_density_axial_survival        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.17| 0.01300|*   |
|low_density_axial_survival        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.01| 0.01300|*   |
|low_density_axial_survival        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.07| 0.07610|ns  |
|low_density_axial_survival        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.94| 0.08680|ns  |
|low_density_axial_survival        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.96500|ns  |
|low_density_survival_index        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.97| 0.41700|ns  |
|low_density_survival_index        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.30| 0.85100|ns  |
|low_density_survival_index        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.44| 0.03710|*   |
|low_density_survival_index        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.49| 0.03710|*   |
|low_density_survival_index        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.97| 0.41700|ns  |
|low_density_survival_index        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.00| 0.01330|*   |
|low_density_survival_index        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.06| 0.01330|*   |
|low_density_survival_index        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.82| 0.11500|ns  |
|low_density_survival_index        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.86| 0.11500|ns  |
|low_density_survival_index        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.63| 0.75400|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.36| 0.89400|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.76| 0.05040|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.57| 0.05040|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.09| 0.93100|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.31| 0.06910|ns  |
|lower_appendicular_continuity_hm  |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.13| 0.08230|ns  |
|lower_appendicular_continuity_hm  |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.04| 0.08310|ns  |
|lower_appendicular_continuity_hm  |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.88| 0.09910|ns  |
|lower_appendicular_continuity_hm  |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.14| 0.93100|ns  |
|mnau_appendicular_mean            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.21| 0.28400|ns  |
|mnau_appendicular_mean            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.83| 0.13400|ns  |
|mnau_appendicular_mean            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.18| 0.00747|**  |
|mnau_appendicular_mean            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.23| 0.00747|**  |
|mnau_appendicular_mean            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.95| 0.38200|ns  |
|mnau_appendicular_mean            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.36| 0.04520|*   |
|mnau_appendicular_mean            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.42| 0.04520|*   |
|mnau_appendicular_mean            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.29| 0.28000|ns  |
|mnau_appendicular_mean            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.34| 0.28000|ns  |
|mnau_appendicular_mean            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|mnau_arms                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.38| 0.78600|ns  |
|mnau_arms                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.19| 0.33700|ns  |
|mnau_arms                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.74| 0.02800|*   |
|mnau_arms                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.92| 0.02800|*   |
|mnau_arms                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.90| 0.46200|ns  |
|mnau_arms                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.45| 0.03530|*   |
|mnau_arms                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.64| 0.02800|*   |
|mnau_arms                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.41| 0.26600|ns  |
|mnau_arms                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.56| 0.23600|ns  |
|mnau_arms                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.15| 0.88500|ns  |
|mnau_arms_legs_diff               |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.40| 0.23900|ns  |
|mnau_arms_legs_diff               |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.50| 0.23900|ns  |
|mnau_arms_legs_diff               |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.99| 0.02810|*   |
|mnau_arms_legs_diff               |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.67| 0.03750|*   |
|mnau_arms_legs_diff               |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.49| 0.69700|ns  |
|mnau_arms_legs_diff               |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.06| 0.13300|ns  |
|mnau_arms_legs_diff               |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  1.75| 0.20200|ns  |
|mnau_arms_legs_diff               |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  1.38| 0.23900|ns  |
|mnau_arms_legs_diff               |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  1.12| 0.32900|ns  |
|mnau_arms_legs_diff               |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.80600|ns  |
|mnau_axial_main_mean              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.17| 0.34300|ns  |
|mnau_axial_main_mean              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.23| 0.90200|ns  |
|mnau_axial_main_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.48| 0.04350|*   |
|mnau_axial_main_mean              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.33| 0.05010|ns  |
|mnau_axial_main_mean              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.05| 0.36800|ns  |
|mnau_axial_main_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -3.18| 0.01240|*   |
|mnau_axial_main_mean              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.03| 0.01240|*   |
|mnau_axial_main_mean              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.91| 0.11200|ns  |
|mnau_axial_main_mean              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.78| 0.12600|ns  |
|mnau_axial_main_mean              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.90200|ns  |
|mnau_column_trunk_mean            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.69| 0.54300|ns  |
|mnau_column_trunk_mean            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.89| 0.47000|ns  |
|mnau_column_trunk_mean            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.46| 0.03430|*   |
|mnau_column_trunk_mean            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.62| 0.02920|*   |
|mnau_column_trunk_mean            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.35| 0.25100|ns  |
|mnau_column_trunk_mean            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.86| 0.02120|*   |
|mnau_column_trunk_mean            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.01| 0.02120|*   |
|mnau_column_trunk_mean            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.40| 0.25100|ns  |
|mnau_column_trunk_mean            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.54| 0.24900|ns  |
|mnau_column_trunk_mean            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_cv                           |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.00| 0.39700|ns  |
|mnau_cv                           |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.16| 0.35400|ns  |
|mnau_cv                           |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.03| 0.07130|ns  |
|mnau_cv                           |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.44| 0.02900|*   |
|mnau_cv                           |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.43| 0.74100|ns  |
|mnau_cv                           |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.62| 0.02590|*   |
|mnau_cv                           |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  3.03| 0.01780|*   |
|mnau_cv                           |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.56| 0.02590|*   |
|mnau_cv                           |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.91| 0.01780|*   |
|mnau_cv                           |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.33| 0.74300|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.14| 0.36600|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.45| 0.80200|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.82| 0.04760|*   |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.53| 0.05630|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.36| 0.80200|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.06| 0.10600|ns  |
|mnau_distal_appendicular_mean     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.78| 0.12600|ns  |
|mnau_distal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.03| 0.10600|ns  |
|mnau_distal_appendicular_mean     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.79| 0.12600|ns  |
|mnau_distal_appendicular_mean     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.23| 0.82100|ns  |
|mnau_dominance_of_region_means    |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.04| 0.99200|ns  |
|mnau_dominance_of_region_means    |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.01| 0.99200|ns  |
|mnau_dominance_of_region_means    |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.45| 0.03730|*   |
|mnau_dominance_of_region_means    |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.61| 0.03730|*   |
|mnau_dominance_of_region_means    |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.04| 0.99200|ns  |
|mnau_dominance_of_region_means    |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.43| 0.03730|*   |
|mnau_dominance_of_region_means    |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.59| 0.03730|*   |
|mnau_dominance_of_region_means    |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.05| 0.06750|ns  |
|mnau_dominance_of_region_means    |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.18| 0.05850|ns  |
|mnau_dominance_of_region_means    |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.12| 0.99200|ns  |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.17| 0.34500|ns  |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.05| 0.36700|ns  |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.05| 0.06660|ns  |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.42| 0.03100|*   |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.21| 0.83600|ns  |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.76| 0.01950|*   |
|mnau_evenness_minus_dominance     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.12| 0.01830|*   |
|mnau_evenness_minus_dominance     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.51| 0.03020|*   |
|mnau_evenness_minus_dominance     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.82| 0.01950|*   |
|mnau_evenness_minus_dominance     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.29| 0.83600|ns  |
|mnau_gini                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.06| 0.36000|ns  |
|mnau_gini                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.17| 0.34700|ns  |
|mnau_gini                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.07| 0.06470|ns  |
|mnau_gini                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.43| 0.03000|*   |
|mnau_gini                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.40| 0.76700|ns  |
|mnau_gini                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.70| 0.02280|*   |
|mnau_gini                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  3.06| 0.01780|*   |
|mnau_gini                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.61| 0.02280|*   |
|mnau_gini                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.91| 0.01780|*   |
|mnau_gini                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.29| 0.77400|ns  |
|mnau_girdle_mean                  |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.66| 0.56500|ns  |
|mnau_girdle_mean                  |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.63| 0.20700|ns  |
|mnau_girdle_mean                  |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.66| 0.02600|*   |
|mnau_girdle_mean                  |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.18| 0.01450|*   |
|mnau_girdle_mean                  |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.13| 0.36900|ns  |
|mnau_girdle_mean                  |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.20| 0.06950|ns  |
|mnau_girdle_mean                  |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.72| 0.02600|*   |
|mnau_girdle_mean                  |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.01| 0.38900|ns  |
|mnau_girdle_mean                  |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.45| 0.24400|ns  |
|mnau_girdle_mean                  |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.41| 0.68100|ns  |
|mnau_hands                        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.12| 0.37600|ns  |
|mnau_hands                        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.42| 0.78600|ns  |
|mnau_hands                        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.44| 0.07240|ns  |
|mnau_hands                        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.71| 0.06750|ns  |
|mnau_hands                        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.37| 0.78600|ns  |
|mnau_hands                        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -1.70| 0.14900|ns  |
|mnau_hands                        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -1.96| 0.12600|ns  |
|mnau_hands                        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.74| 0.14900|ns  |
|mnau_hands                        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.96| 0.12600|ns  |
|mnau_hands                        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.21| 0.83600|ns  |
|mnau_heip_evenness                |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.28| 0.24900|ns  |
|mnau_heip_evenness                |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.40| 0.23300|ns  |
|mnau_heip_evenness                |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.98| 0.07910|ns  |
|mnau_heip_evenness                |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.35| 0.03780|*   |
|mnau_heip_evenness                |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.47| 0.71300|ns  |
|mnau_heip_evenness                |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.76| 0.01700|*   |
|mnau_heip_evenness                |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.12| 0.01290|*   |
|mnau_heip_evenness                |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.71| 0.01700|*   |
|mnau_heip_evenness                |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -3.01| 0.01290|*   |
|mnau_heip_evenness                |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.29| 0.77400|ns  |
|mnau_inverse_simpson              |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.00| 0.39700|ns  |
|mnau_inverse_simpson              |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.16| 0.35400|ns  |
|mnau_inverse_simpson              |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.03| 0.07120|ns  |
|mnau_inverse_simpson              |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.44| 0.02900|*   |
|mnau_inverse_simpson              |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.43| 0.74100|ns  |
|mnau_inverse_simpson              |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.62| 0.02590|*   |
|mnau_inverse_simpson              |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.03| 0.01780|*   |
|mnau_inverse_simpson              |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.56| 0.02590|*   |
|mnau_inverse_simpson              |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.91| 0.01780|*   |
|mnau_inverse_simpson              |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.33| 0.74300|ns  |
|mnau_legs                         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.41| 0.22700|ns  |
|mnau_legs                         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.68| 0.18500|ns  |
|mnau_legs                         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.31| 0.00918|**  |
|mnau_legs                         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.05| 0.01140|*   |
|mnau_legs                         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.66| 0.56600|ns  |
|mnau_legs                         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.37| 0.05880|ns  |
|mnau_legs                         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.11| 0.08610|ns  |
|mnau_legs                         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.52| 0.21400|ns  |
|mnau_legs                         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.30| 0.24200|ns  |
|mnau_legs                         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.21| 0.83700|ns  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.24| 0.27000|ns  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.59| 0.21200|ns  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.23| 0.00879|**  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.13| 0.00879|**  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.68| 0.54800|ns  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.40| 0.05390|ns  |
|mnau_limb_shaft_proxy_mean        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.30| 0.05390|ns  |
|mnau_limb_shaft_proxy_mean        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.52| 0.21200|ns  |
|mnau_limb_shaft_proxy_mean        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.44| 0.21600|ns  |
|mnau_limb_shaft_proxy_mean        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.08| 0.93500|ns  |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.07| 0.35800|ns  |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.47| 0.22000|ns  |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.14| 0.01320|*   |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.01| 0.01320|*   |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.69| 0.54600|ns  |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.42| 0.05230|ns  |
|mnau_lower_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.29| 0.05550|ns  |
|mnau_lower_appendicular_mean      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.53| 0.22000|ns  |
|mnau_lower_appendicular_mean      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.42| 0.22000|ns  |
|mnau_lower_appendicular_mean      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.10| 0.91800|ns  |
|mnau_pelvic                       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.28| 0.79300|ns  |
|mnau_pelvic                       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.51| 0.26300|ns  |
|mnau_pelvic                       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.43| 0.04980|*   |
|mnau_pelvic                       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.77| 0.04980|*   |
|mnau_pelvic                       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.28| 0.33300|ns  |
|mnau_pelvic                       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.21| 0.06690|ns  |
|mnau_pelvic                       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.54| 0.04980|*   |
|mnau_pelvic                       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -0.91| 0.45200|ns  |
|mnau_pelvic                       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.19| 0.33300|ns  |
|mnau_pelvic                       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.26| 0.79300|ns  |
|mnau_postcranial_total_mean       |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.71| 0.52900|ns  |
|mnau_postcranial_total_mean       |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.67| 0.19000|ns  |
|mnau_postcranial_total_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.03| 0.01220|*   |
|mnau_postcranial_total_mean       |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.08| 0.01220|*   |
|mnau_postcranial_total_mean       |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.13| 0.32100|ns  |
|mnau_postcranial_total_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.53| 0.02830|*   |
|mnau_postcranial_total_mean       |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.58| 0.02830|*   |
|mnau_postcranial_total_mean       |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.29| 0.28000|ns  |
|mnau_postcranial_total_mean       |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.34| 0.28000|ns  |
|mnau_postcranial_total_mean       |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.90| 0.41000|ns  |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.73| 0.16700|ns  |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.03| 0.01210|*   |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.19| 0.01210|*   |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.06| 0.35900|ns  |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.42| 0.03900|*   |
|mnau_proximal_appendicular_mean   |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.57| 0.03370|*   |
|mnau_proximal_appendicular_mean   |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.25| 0.30200|ns  |
|mnau_proximal_appendicular_mean   |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.38| 0.27900|ns  |
|mnau_proximal_appendicular_mean   |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_region_mean_evenness         |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.31| 0.84000|ns  |
|mnau_region_mean_evenness         |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  0.67| 0.72300|ns  |
|mnau_region_mean_evenness         |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.42| 0.02560|*   |
|mnau_region_mean_evenness         |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.58| 0.02270|*   |
|mnau_region_mean_evenness         |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.43| 0.83000|ns  |
|mnau_region_mean_evenness         |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.58| 0.02270|*   |
|mnau_region_mean_evenness         |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.73| 0.02270|*   |
|mnau_region_mean_evenness         |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.53| 0.02270|*   |
|mnau_region_mean_evenness         |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.66| 0.02270|*   |
|mnau_region_mean_evenness         |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.12| 0.90200|ns  |
|mnau_shoulder                     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.78| 0.48500|ns  |
|mnau_shoulder                     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.78| 0.15100|ns  |
|mnau_shoulder                     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.86| 0.02140|*   |
|mnau_shoulder                     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.10| 0.01970|*   |
|mnau_shoulder                     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -1.20| 0.33100|ns  |
|mnau_shoulder                     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.32| 0.05080|ns  |
|mnau_shoulder                     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.55| 0.03550|*   |
|mnau_shoulder                     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.06| 0.35900|ns  |
|mnau_shoulder                     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.26| 0.33100|ns  |
|mnau_shoulder                     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.19| 0.85200|ns  |
|mnau_simpson_dominance            |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.00| 0.39700|ns  |
|mnau_simpson_dominance            |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.16| 0.35400|ns  |
|mnau_simpson_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.03| 0.07120|ns  |
|mnau_simpson_dominance            |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.44| 0.02900|*   |
|mnau_simpson_dominance            |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.43| 0.74100|ns  |
|mnau_simpson_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.62| 0.02590|*   |
|mnau_simpson_dominance            |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  3.03| 0.01780|*   |
|mnau_simpson_dominance            |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.56| 0.02590|*   |
|mnau_simpson_dominance            |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.91| 0.01780|*   |
|mnau_simpson_dominance            |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.33| 0.74300|ns  |
|mnau_simpson_evenness             |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  1.00| 0.39700|ns  |
|mnau_simpson_evenness             |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  1.16| 0.35400|ns  |
|mnau_simpson_evenness             |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -2.03| 0.07120|ns  |
|mnau_simpson_evenness             |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.44| 0.02900|*   |
|mnau_simpson_evenness             |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.43| 0.74100|ns  |
|mnau_simpson_evenness             |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.62| 0.02590|*   |
|mnau_simpson_evenness             |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -3.03| 0.01780|*   |
|mnau_simpson_evenness             |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -2.56| 0.02590|*   |
|mnau_simpson_evenness             |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -2.91| 0.01780|*   |
|mnau_simpson_evenness             |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.33| 0.74300|ns  |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.81| 0.58400|ns  |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.73| 0.58400|ns  |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.40| 0.03170|*   |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.35| 0.03170|*   |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.14| 0.96700|ns  |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.87| 0.02440|*   |
|mnau_top2_share_mcnaughton        |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.81| 0.02440|*   |
|mnau_top2_share_mcnaughton        |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.55| 0.03010|*   |
|mnau_top2_share_mcnaughton        |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.51| 0.03010|*   |
|mnau_top2_share_mcnaughton        |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.04| 0.96700|ns  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -1.28| 0.24900|ns  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -1.40| 0.23200|ns  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -3.01| 0.01300|*   |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -3.33| 0.00884|**  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            | -0.47| 0.71300|ns  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.15| 0.07830|ns  |
|mnau_upper_appendicular_mean      |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.46| 0.04610|*   |
|mnau_upper_appendicular_mean      |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -1.48| 0.23100|ns  |
|mnau_upper_appendicular_mean      |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -1.74| 0.16300|ns  |
|mnau_upper_appendicular_mean      |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.25| 0.80600|ns  |
|mne_arms                          |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    |  0.77| 0.49200|ns  |
|mne_arms                          |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             |  2.73| 0.02140|*   |
|mne_arms                          |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             | -1.93| 0.06700|ns  |
|mne_arms                          |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         | -2.14| 0.04730|*   |
|mne_arms                          |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  2.13| 0.04730|*   |
|mne_arms                          |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            | -2.38| 0.03460|*   |
|mne_arms                          |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        | -2.59| 0.02400|*   |
|mne_arms                          |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     | -3.66| 0.00127|**  |
|mne_arms                          |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 | -3.84| 0.00125|**  |
|mne_arms                          |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic | -0.17| 0.86800|ns  |
|postcranial_dominance_refined     |Inhumation single &#124; Upper Paleolithic vs Inhumation single &#124; Middle Paleolithic                    | -0.35| 0.98900|ns  |
|postcranial_dominance_refined     |Inhumation single &#124; Upper Paleolithic vs Collective burial &#124; Neolithic                             | -0.01| 0.98900|ns  |
|postcranial_dominance_refined     |Inhumation single &#124; Upper Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic             |  2.55| 0.02700|*   |
|postcranial_dominance_refined     |Inhumation single &#124; Upper Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic         |  2.60| 0.02700|*   |
|postcranial_dominance_refined     |Inhumation single &#124; Middle Paleolithic vs Collective burial &#124; Neolithic                            |  0.23| 0.98900|ns  |
|postcranial_dominance_refined     |Inhumation single &#124; Middle Paleolithic vs Carnivore den(transport) &#124; Middle Paleolithic            |  2.73| 0.02700|*   |
|postcranial_dominance_refined     |Inhumation single &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic        |  2.78| 0.02700|*   |
|postcranial_dominance_refined     |Collective burial &#124; Neolithic vs Carnivore den(transport) &#124; Middle Paleolithic                     |  2.15| 0.05280|ns  |
|postcranial_dominance_refined     |Collective burial &#124; Neolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic                 |  2.19| 0.05280|ns  |
|postcranial_dominance_refined     |Carnivore den(transport) &#124; Middle Paleolithic vs Carnivore Scavenge (in situ) &#124; Middle Paleolithic |  0.04| 0.98900|ns  |

## 5. Multivariate structure

PERMANOVA (adonis2, 9999 permutations): pseudo-F = 6.29, R² = 0.482, p = 0.0001.
PCA variance explained: PC1 59.0%, PC2 11.7%, PC3 6.8% (cumulative 77.5%).
Dispersion caveat (PERMDISP): p = 0.162.

Top PC1 loadings:

|Feature                       |    PC1|    PC2|    PC3|
|:-----------------------------|------:|------:|------:|
|all_sections_dominance        | -0.181| -0.017|  0.085|
|mnau_top2_share_mcnaughton    | -0.181| -0.045|  0.096|
|mnau_evenness_minus_dominance |  0.181|  0.026| -0.111|
|mnau_cv                       | -0.181| -0.032|  0.122|
|mnau_gini                     | -0.177| -0.059|  0.146|
|mnau_heip_evenness            |  0.177|  0.054| -0.159|
|effective_sections_hill1      |  0.177|  0.054| -0.159|
|mnau_simpson_evenness         |  0.177|  0.056| -0.142|

## 6. Figures

1. `plot1_top_features.html` — the three most differential raw features, 3D, coloured by group.
2. `plot2_composites.html` — completeness / density-survival / axial-appendicular composite axes.
3. `plot3_pca.html` — PCA ordination (PC1–PC3).

---
*Methods: Kruskal-Wallis + ε² effect size, Dunn post-hoc (BH-FDR); PCA + Euclidean PERMANOVA (9999 perms) with PERMDISP caveat. Seed = 20260616.*
