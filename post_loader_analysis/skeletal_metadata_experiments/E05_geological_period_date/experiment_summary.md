# E05 - geological_period_date

Hypothesis: Time depth may alter skeletal preservation.

Expected pattern: Older contexts may show stronger attrition of fragile elements.

Why interesting: Tests temporal structure while controlling for environment and taphonomy.

## Grouping

Group variables: geological_period + date_bin

Covariates for PERMANOVA: mis_stage + site_environment + taphonomic_context

## Summary



|experiment_id |experiment_name        |group_vars                   |covariates                                        | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature      | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:----------------------|:----------------------------|:-------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:----------------|----------------:|-----------------:|------------------:|-----------------:|
|E05           |geological_period_date |geological_period + date_bin |mis_stage + site_environment + taphonomic_context |       410|        9|                50|                43| 0.1949902|density_evenness |        0.1949902|                 0|          0.0238284|             0.054|

## Group sizes



|group                                               | n_records|
|:---------------------------------------------------|---------:|
|Late Pleistocene &#124; Late_Pleistocene            |       184|
|Holocene &#124; Holocene_or_recent                  |       134|
|Late Pleistocene &#124; Middle_Pleistocene          |        50|
|Middle Pleistocene &#124; Middle_Pleistocene        |        20|
|Middle Pleistocene &#124; missing_date              |        11|
|Late Pleistocene &#124; missing_date                |         4|
|Holocene &#124; missing_date                        |         3|
|Lower Pleistocene &#124; Early_Pleistocene_or_older |         2|
|Other_small_groups                                  |         2|

## Top 10 features



|feature                       |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-----------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|density_evenness              | 394|        9| 76.63113|  8|  0| 0.1949902|     0|TRUE               |large  |
|low_density_axial_survival    | 410|        9| 72.25730|  8|  0| 0.1766682|     0|TRUE               |large  |
|mnau_axial_main_mean          | 410|        9| 70.78052|  8|  0| 0.1730575|     0|TRUE               |large  |
|mnau_region_mean_evenness     | 394|        9| 67.40417|  8|  0| 0.1715119|     0|TRUE               |large  |
|low_density_survival_index    | 410|        9| 68.50054|  8|  0| 0.1674830|     0|TRUE               |large  |
|mnau_heip_evenness            | 394|        9| 63.91063|  8|  0| 0.1626225|     0|TRUE               |large  |
|effective_sections_hill1      | 394|        9| 63.91063|  8|  0| 0.1626225|     0|TRUE               |large  |
|mne_arms                      | 410|        9| 66.20401|  8|  0| 0.1618680|     0|TRUE               |large  |
|low_density_share             | 394|        9| 63.36705|  8|  0| 0.1612393|     0|TRUE               |large  |
|mnau_evenness_minus_dominance | 394|        9| 61.93353|  8|  0| 0.1575917|     0|TRUE               |large  |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|      p|note |
|:------------------|---:|----------:|---------:|---------:|------:|:----|
|group              |   8|   292.3745| 0.0238284|  1.720674| 0.0540|NA   |
|mis_stage          |   7|   662.5643| 0.0539987|  4.456347| 0.0001|NA   |
|site_environment   |   2|   116.8188| 0.0095207|  2.749994| 0.0326|NA   |
|taphonomic_context |   5|  2349.2883| 0.1914660| 22.121537| 0.0001|NA   |
|Residual           | 387|  8219.8140| 0.6699115|        NA|     NA|NA   |
|Total              | 409| 12270.0000| 1.0000000|        NA|     NA|NA   |
