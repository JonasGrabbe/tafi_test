# E05 - geological_period_mis_date

Hypothesis: Older assemblages are more altered by long-term attrition and recovery bias.

Expected pattern: Earlier Pleistocene contexts may show stronger loss of fragile elements and more dominance of durable cranial, dental, shaft, or dense long-bone remains.

Why interesting: This tests time-depth and preservation intensity, while retaining depositional and contextual covariates for PERMANOVA.

## Grouping

Group variables: geological_period + date_bin

Covariates for PERMANOVA: mis_stage + karstic_system + open_air_site + taphonomic_context

## Summary



|experiment_id |experiment_name            |group_vars                   |covariates                                                      | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature       | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:----------------------------|:---------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------------|----------------:|-----------------:|------------------:|-----------------:|
|E05           |geological_period_mis_date |geological_period + date_bin |mis_stage + karstic_system + open_air_site + taphonomic_context |       151|        5|                63|                27| 0.1445032|dominance_gap_all |        0.1445032|         0.0108654|          0.0170265|            0.3676|

## Group sizes



|group                                        | n_records|
|:--------------------------------------------|---------:|
|Late Pleistocene &#124; Late_Pleistocene     |        69|
|Holocene &#124; Holocene_or_recent           |        45|
|Middle Pleistocene &#124; Middle_Pleistocene |        13|
|Late Pleistocene &#124; Middle_Pleistocene   |        12|
|Other_small_groups                           |        12|

## Top 10 features



|feature                        |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|dominance_gap_all              | 149|        5| 21.38647|  4| 0.0002654| 0.1445032| 0.0108654|TRUE               |large    |
|density_evenness               | 149|        5| 20.81266|  4| 0.0003449| 0.1406261| 0.0108654|TRUE               |large    |
|low_density_share              | 149|        5| 19.34318|  4| 0.0006728| 0.1306972| 0.0114617|TRUE               |moderate |
|all_sections_dominance         | 149|        5| 19.05595|  4| 0.0007663| 0.1287565| 0.0114617|TRUE               |moderate |
|mne_arms                       | 151|        5| 17.56887|  4| 0.0014980| 0.1171258| 0.0114617|TRUE               |moderate |
|mnau_evenness_minus_dominance  | 149|        5| 17.20761|  4| 0.0017614| 0.1162676| 0.0114617|TRUE               |moderate |
|mnau_simpson_dominance         | 149|        5| 17.15079|  4| 0.0018068| 0.1158837| 0.0114617|TRUE               |moderate |
|mnau_inverse_simpson           | 149|        5| 17.15079|  4| 0.0018068| 0.1158837| 0.0114617|TRUE               |moderate |
|mnau_simpson_evenness          | 149|        5| 17.15079|  4| 0.0018068| 0.1158837| 0.0114617|TRUE               |moderate |
|mnau_dominance_of_region_means | 149|        5| 16.93326|  4| 0.0019915| 0.1144139| 0.0114617|TRUE               |moderate |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|      p|note |
|:------------------|---:|----------:|---------:|---------:|------:|:----|
|group              |   4|   76.61918| 0.0170265| 1.0786329| 0.3676|NA   |
|mis_stage          |  26|  343.36158| 0.0763026| 0.7436602| 0.9116|NA   |
|karstic_system     |   3|   62.13510| 0.0138078| 1.1663044| 0.3158|NA   |
|open_air_site      |   3|   81.78945| 0.0181754| 1.5352257| 0.1642|NA   |
|taphonomic_context |  10| 1289.19786| 0.2864884| 7.2596514| 0.0001|NA   |
|Residual           | 104| 1846.87351| 0.4104163|        NA|     NA|NA   |
|Total              | 150| 4500.00000| 1.0000000|        NA|     NA|NA   |
