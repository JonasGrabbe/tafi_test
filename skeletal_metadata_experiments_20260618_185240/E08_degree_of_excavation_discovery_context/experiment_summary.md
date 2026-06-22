# E08 - degree_of_excavation_discovery_context

Hypothesis: Recovery method affects what bones enter the dataset.

Expected pattern: Formal and complete excavations should recover more small bones; quarry, casual, and partial discoveries should overrepresent large, visible, diagnostic elements.

Why interesting: This is essential as a recovery-bias control because it can explain patterns that otherwise look biological, cultural, or taphonomic.

## Grouping

Group variables: degree_of_excavation + discovery_context

Covariates for PERMANOVA: count_type

## Summary



|experiment_id |experiment_name                        |group_vars                               |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                     | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------------------|:----------------------------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:-------------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E08           |degree_of_excavation_discovery_context |degree_of_excavation + discovery_context |count_type |       151|        5|                63|                26| 0.1912029|ProportionalRep_MNIbased_radius |        0.1912029|         0.0005719|          0.1173829|             1e-04|

## Group sizes



|group                            | n_records|
|:--------------------------------|---------:|
|NA &#124; NA                     |        51|
|Partial &#124; Formal excavation |        36|
|NA &#124; Formal excavation      |        35|
|Other_small_groups               |        16|
|NA &#124; Casual                 |        13|

## Top 10 features



|feature                          |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:--------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|ProportionalRep_MNIbased_radius  | 151|        5| 28.68044|  4| 0.0000091| 0.1912029| 0.0005719|TRUE               |large    |
|ReMNAU_radius                    | 151|        5| 25.23465|  4| 0.0000451| 0.1682310| 0.0014216|TRUE               |large    |
|ProportionalRep_MNIbased_fibula  | 151|        5| 23.98659|  4| 0.0000804| 0.1599106| 0.0016878|TRUE               |large    |
|mnau_arms                        | 151|        5| 22.07935|  4| 0.0001933| 0.1471957| 0.0030439|TRUE               |large    |
|mnau_limb_shaft_proxy_mean       | 151|        5| 21.46309|  4| 0.0002563| 0.1430873| 0.0032290|TRUE               |large    |
|mnau_legs                        | 151|        5| 19.24554|  4| 0.0007033| 0.1283036| 0.0057826|TRUE               |moderate |
|mnau_upper_appendicular_mean     | 151|        5| 19.13423|  4| 0.0007396| 0.1275615| 0.0057826|TRUE               |moderate |
|ProportionalRep_MNIbased_tibia   | 151|        5| 19.09642|  4| 0.0007524| 0.1273094| 0.0057826|TRUE               |moderate |
|ProportionalRep_MNIbased_humerus | 151|        5| 18.84858|  4| 0.0008416| 0.1256572| 0.0057826|TRUE               |moderate |
|mne_arms                         | 151|        5| 18.63056|  4| 0.0009288| 0.1242037| 0.0057826|TRUE               |moderate |

## PERMANOVA



|term     |  df|    sumsq|        R2|        F|     p|note |
|:--------|---:|--------:|---------:|--------:|-----:|:----|
|group    |   4|  528.223| 0.1173829| 4.854285| 1e-04|NA   |
|Residual | 146| 3971.777| 0.8826171|       NA|    NA|NA   |
|Total    | 150| 4500.000| 1.0000000|       NA|    NA|NA   |
