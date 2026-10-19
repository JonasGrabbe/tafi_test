# E03 - site_environment_detail

Hypothesis: Subtypes within karstic/open-air settings may further structure preservation.

Expected pattern: Cave interior, entrance, rockshelter, fluvial, eolian, lake, etc. may differ.

Why interesting: Uses one hierarchical setting label rather than two independent columns.

## Grouping

Group variables: site_environment_detail

Covariates for PERMANOVA: taphonomic_context + geological_period

## Summary



|experiment_id |experiment_name         |group_vars              |covariates                             | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature       | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:-----------------------|:-----------------------|:--------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------------|----------------:|-----------------:|------------------:|-----------------:|
|E03           |site_environment_detail |site_environment_detail |taphonomic_context + geological_period |       410|        6|                50|                43| 0.0782184|low_density_share |        0.0782184|         0.0002036|          0.0385306|             1e-04|

## Group sizes



|group                      | n_records|
|:--------------------------|---------:|
|Karstic &#124; Cave        |       183|
|Karstic &#124; Rockshelter |       129|
|Open air                   |        88|
|Karstic &#124; Open air    |         7|
|missing                    |         2|
|Other_small_groups         |         1|

## Top 10 features



|feature                       |   n| n_groups|        H| df|        p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:-----------------------------|---:|--------:|--------:|--:|--------:|---------:|---------:|:------------------|:--------|
|low_density_share             | 394|        6| 30.73983|  5| 1.05e-05| 0.0782184| 0.0002036|TRUE               |moderate |
|mnau_region_mean_evenness     | 394|        6| 30.19652|  5| 1.35e-05| 0.0768359| 0.0002036|TRUE               |moderate |
|low_density_survival_index    | 410|        6| 29.96830|  5| 1.50e-05| 0.0732721| 0.0002036|TRUE               |moderate |
|density_evenness              | 394|        6| 27.17198|  5| 5.28e-05| 0.0691399| 0.0002036|TRUE               |moderate |
|mnau_column_trunk_mean        | 410|        6| 28.20797|  5| 3.31e-05| 0.0689681| 0.0002036|TRUE               |moderate |
|mnau_heip_evenness            | 394|        6| 27.05280|  5| 5.57e-05| 0.0688366| 0.0002036|TRUE               |moderate |
|effective_sections_hill1      | 394|        6| 27.05280|  5| 5.57e-05| 0.0688366| 0.0002036|TRUE               |moderate |
|mnau_evenness_minus_dominance | 394|        6| 26.62461|  5| 6.75e-05| 0.0677471| 0.0002036|TRUE               |moderate |
|mnau_girdle_mean              | 410|        6| 27.58299|  5| 4.39e-05| 0.0674401| 0.0002036|TRUE               |moderate |
|mnau_gini                     | 394|        6| 26.42092|  5| 7.39e-05| 0.0672288| 0.0002036|TRUE               |moderate |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|     p|note |
|:------------------|---:|----------:|---------:|---------:|-----:|:----|
|group              |   5|   472.7707| 0.0385306|  4.407404| 1e-04|NA   |
|taphonomic_context |   5|  2357.4874| 0.1921343| 21.977671| 1e-04|NA   |
|geological_period  |   4|   506.6091| 0.0412884|  5.903578| 1e-04|NA   |
|Residual           | 395|  8474.1238| 0.6906376|        NA|    NA|NA   |
|Total              | 409| 12270.0000| 1.0000000|        NA|    NA|NA   |
