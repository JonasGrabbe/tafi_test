# E04 - age_category

Hypothesis: Age affects preservation and recovery.

Expected pattern: Younger individuals may show lower representation of fragile/small elements.

Why interesting: Biological control.

## Grouping

Group variables: age_category

Covariates for PERMANOVA: mni + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars   |covariates                 | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:------------|:--------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E04           |age_category    |age_category |mni + degree_of_excavation |       151|        6|                50|                 1| 0.1447038|mne_arms    |        0.1447038|         0.0297776|          0.0512299|            0.0682|

## Group sizes



|group    | n_records|
|:--------|---------:|
|Mixed    |        55|
|Adult    |        53|
|Indet    |        27|
|Juvenile |         6|
|Infant   |         5|
|Subadult |         5|

## Top 10 features



|feature                                      |   n| n_groups|         H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:--------------------------------------------|---:|--------:|---------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mne_arms                                     | 151|        6| 21.705564|  5| 0.0005956| 0.1447038| 0.0297776|TRUE               |large    |
|density_adjusted_appendicular_axial_contrast | 151|        6| 14.938638|  5| 0.0106278| 0.0995909| 0.2656943|FALSE              |moderate |
|dominant_axial_share                         | 151|        6|  9.125871|  5| 0.1041477| 0.0608391| 0.9008992|FALSE              |moderate |
|lower_appendicular_evenness_refined          | 123|        6|  7.015809|  5| 0.2194672| 0.0575066| 0.9008992|FALSE              |small    |
|lower_appendicular_evenness                  | 123|        6|  7.015809|  5| 0.2194672| 0.0575066| 0.9008992|FALSE              |small    |
|distal_appendicular_continuity_hm            | 151|        6|  8.533196|  5| 0.1291957| 0.0568880| 0.9008992|FALSE              |small    |
|mne_cranial_share                            | 151|        6|  7.071366|  5| 0.2153866| 0.0471424| 0.9008992|FALSE              |small    |
|postcranial_dominance_refined                | 128|        6|  5.752906|  5| 0.3310095| 0.0452985| 0.9008992|FALSE              |small    |
|mnau_foot                                    | 151|        6|  5.547283|  5| 0.3527889| 0.0369819| 0.9008992|FALSE              |small    |
|density_evenness                             | 149|        6|  5.376401|  5| 0.3716893| 0.0363270| 0.9008992|FALSE              |small    |

## PERMANOVA



|term                 |  df|      sumsq|        R2|        F|      p|note |
|:--------------------|---:|----------:|---------:|--------:|------:|:----|
|group                |   5|  230.53461| 0.0512299| 1.676270| 0.0682|NA   |
|mni                  |   1|   96.65813| 0.0214796| 3.514118| 0.0239|NA   |
|degree_of_excavation |   3|  227.35514| 0.0505234| 2.755253| 0.0107|NA   |
|Residual             | 141| 3878.29809| 0.8618440|       NA|     NA|NA   |
|Total                | 150| 4500.00000| 1.0000000|       NA|     NA|NA   |
