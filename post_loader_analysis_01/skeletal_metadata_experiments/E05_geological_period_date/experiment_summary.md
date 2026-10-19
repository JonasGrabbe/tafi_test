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
|E05           |geological_period_date |geological_period + date_bin |mis_stage + site_environment + taphonomic_context |       151|        8|                50|                16| 0.1671692|density_evenness |        0.1671692|         0.0211696|          0.0303638|            0.2555|

## Group sizes



|group                                               | n_records|
|:---------------------------------------------------|---------:|
|Late Pleistocene &#124; Late_Pleistocene            |        69|
|Holocene &#124; Holocene_or_recent                  |        45|
|Late Pleistocene &#124; Middle_Pleistocene          |        13|
|Middle Pleistocene &#124; Middle_Pleistocene        |        13|
|Holocene &#124; missing_date                        |         3|
|Late Pleistocene &#124; missing_date                |         3|
|Other_small_groups                                  |         3|
|Lower Pleistocene &#124; Early_Pleistocene_or_older |         2|

## Top 10 features



|feature                        |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|density_evenness               | 149|        8| 24.74104|  7| 0.0008433| 0.1671692| 0.0211696|TRUE               |large    |
|dominance_gap_all              | 149|        8| 24.73093|  7| 0.0008468| 0.1671009| 0.0211696|TRUE               |large    |
|low_density_share              | 149|        8| 22.01390|  7| 0.0025264| 0.1487425| 0.0299663|TRUE               |large    |
|all_sections_dominance         | 149|        8| 21.99700|  7| 0.0025434| 0.1486284| 0.0299663|TRUE               |large    |
|mne_arms                       | 151|        8| 21.49344|  7| 0.0031045| 0.1432896| 0.0299663|TRUE               |large    |
|mnau_dominance_of_region_means | 149|        8| 20.91209|  7| 0.0039025| 0.1412979| 0.0299663|TRUE               |large    |
|mnau_evenness_minus_dominance  | 149|        8| 19.70457|  7| 0.0062444| 0.1331390| 0.0299663|TRUE               |moderate |
|mnau_simpson_dominance         | 149|        8| 19.62976|  7| 0.0064274| 0.1326335| 0.0299663|TRUE               |moderate |
|mnau_inverse_simpson           | 149|        8| 19.62976|  7| 0.0064274| 0.1326335| 0.0299663|TRUE               |moderate |
|mnau_simpson_evenness          | 149|        8| 19.62976|  7| 0.0064274| 0.1326335| 0.0299663|TRUE               |moderate |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|      p|note |
|:------------------|---:|----------:|---------:|---------:|------:|:----|
|group              |   7|  136.63704| 0.0303638|  1.224080| 0.2555|NA   |
|mis_stage          |   7|  118.87677| 0.0264171|  1.064973| 0.3865|NA   |
|site_environment   |   2|   74.58866| 0.0165753|  2.338742| 0.0618|NA   |
|taphonomic_context |   5| 1646.84997| 0.3659667| 20.654918| 0.0001|NA   |
|Residual           | 129| 2057.07566| 0.4571279|        NA|     NA|NA   |
|Total              | 150| 4500.00000| 1.0000000|        NA|     NA|NA   |
