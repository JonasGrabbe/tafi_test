# E02 - site_environment_main

Hypothesis: Karstic and open-air settings impose different depositional filters.

Expected pattern: Broad preservation patterns may differ between karstic and open-air contexts.

Why interesting: Treats karstic/open-air as one mutually-exclusive main variable.

## Grouping

Group variables: site_environment

Covariates for PERMANOVA: taphonomic_context

## Summary



|experiment_id |experiment_name       |group_vars       |covariates         | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature       | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------------|:----------------|:------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------------|----------------:|-----------------:|------------------:|-----------------:|
|E02           |site_environment_main |site_environment |taphonomic_context |       410|        3|                50|                35| 0.0617941|low_density_share |        0.0617941|         0.0002664|          0.0080476|            0.0752|

## Group sizes



|group    | n_records|
|:--------|---------:|
|Karstic  |       319|
|Open air |        89|
|missing  |         2|

## Top 10 features



|feature                           |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:---------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|low_density_share                 | 394|        3| 24.28509|  2| 0.0000053| 0.0617941| 0.0002664|TRUE               |moderate |
|mnau_distal_appendicular_mean     | 410|        3| 20.64641|  2| 0.0000329| 0.0504802| 0.0008215|TRUE               |small    |
|mnau_region_mean_evenness         | 394|        3| 19.29141|  2| 0.0000647| 0.0490876| 0.0008295|TRUE               |small    |
|mnau_heip_evenness                | 394|        3| 17.84165|  2| 0.0001336| 0.0453986| 0.0008295|TRUE               |small    |
|effective_sections_hill1          | 394|        3| 17.84165|  2| 0.0001336| 0.0453986| 0.0008295|TRUE               |small    |
|mnau_gini                         | 394|        3| 17.82109|  2| 0.0001350| 0.0453463| 0.0008295|TRUE               |small    |
|distal_appendicular_continuity_hm | 410|        3| 18.47356|  2| 0.0000974| 0.0451676| 0.0008295|TRUE               |small    |
|mne_cranial_share                 | 410|        3| 17.83469|  2| 0.0001340| 0.0436056| 0.0008295|TRUE               |small    |
|low_density_axial_survival        | 410|        3| 17.47949|  2| 0.0001601| 0.0427371| 0.0008295|TRUE               |small    |
|low_density_survival_index        | 410|        3| 17.33416|  2| 0.0001722| 0.0423818| 0.0008295|TRUE               |small    |

## PERMANOVA



|term               |  df|       sumsq|        R2|         F|      p|note |
|:------------------|---:|-----------:|---------:|---------:|------:|:----|
|group              |   2|    98.74394| 0.0080476|  2.134077| 0.0752|NA   |
|taphonomic_context |   5|  2611.15640| 0.2128082| 22.573171| 0.0001|NA   |
|Residual           | 402|  9300.28744| 0.7579696|        NA|     NA|NA   |
|Total              | 409| 12270.00000| 1.0000000|        NA|     NA|NA   |
