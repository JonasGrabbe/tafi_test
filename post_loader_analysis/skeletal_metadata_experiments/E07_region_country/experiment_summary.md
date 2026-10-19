# E07 - region_country

Hypothesis: Regional differences may reflect geology and research/recovery history.

Expected pattern: Some regions may systematically preserve or recover different body parts.

Why interesting: Bias-detection analysis.

## Grouping

Group variables: region

Covariates for PERMANOVA: country + site_environment + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars |covariates                                        | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:----------|:-------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E07           |region_country  |region     |country + site_environment + degree_of_excavation |       410|       10|                50|                42| 0.1538861|mne_arms    |        0.1538861|                 0|          0.0054836|            0.2289|

## Group sizes



|group                   | n_records|
|:-----------------------|---------:|
|West Europe             |       271|
|Central Europe          |        45|
|West Asia               |        42|
|Southeast Asia          |        22|
|Eastern Europe          |        10|
|Europe                  |         6|
|Other_small_groups      |         6|
|North America           |         4|
|Oceania (South Pacific) |         2|
|South America           |         2|

## Top 10 features



|feature                           |   n| n_groups|        H| df|     p|      eps2|   p_fdr|significant_fdr_05 |effect   |
|:---------------------------------|---:|--------:|--------:|--:|-----:|---------:|-------:|:------------------|:--------|
|mne_arms                          | 410|       10| 62.93943|  9| 0e+00| 0.1538861| 0.0e+00|TRUE               |large    |
|mnau_region_mean_evenness         | 394|       10| 49.34829|  9| 1e-07| 0.1255682| 1.8e-06|TRUE               |moderate |
|mnau_postcranial_total_mean       | 410|       10| 50.76395|  9| 1e-07| 0.1241172| 1.8e-06|TRUE               |moderate |
|mnau_distal_appendicular_mean     | 410|       10| 49.39359|  9| 1e-07| 0.1207667| 1.8e-06|TRUE               |moderate |
|mnau_heip_evenness                | 394|       10| 46.77868|  9| 4e-07| 0.1190297| 2.7e-06|TRUE               |moderate |
|effective_sections_hill1          | 394|       10| 46.77868|  9| 4e-07| 0.1190297| 2.7e-06|TRUE               |moderate |
|mnau_gini                         | 394|       10| 46.76296|  9| 4e-07| 0.1189897| 2.7e-06|TRUE               |moderate |
|mnau_appendicular_mean            | 410|       10| 48.33602|  9| 2e-07| 0.1181810| 2.2e-06|TRUE               |moderate |
|mnau_dominance_of_region_means    | 394|       10| 45.79284|  9| 7e-07| 0.1165212| 3.3e-06|TRUE               |moderate |
|distal_appendicular_continuity_hm | 410|       10| 46.44869|  9| 5e-07| 0.1135665| 2.8e-06|TRUE               |moderate |

## PERMANOVA



|term                 |  df|       sumsq|        R2|        F|      p|note |
|:--------------------|---:|-----------:|---------:|--------:|------:|:----|
|group                |   2|    67.28339| 0.0054836| 1.420389| 0.2289|NA   |
|country              |  20|   959.86898| 0.0782289| 2.026335| 0.0015|NA   |
|site_environment     |   1|    24.85770| 0.0020259| 1.049519| 0.3206|NA   |
|degree_of_excavation |   3|   674.43002| 0.0549658| 9.491722| 0.0001|NA   |
|Residual             | 375|  8881.81847| 0.7238646|       NA|     NA|NA   |
|Total                | 409| 12270.00000| 1.0000000|       NA|     NA|NA   |
