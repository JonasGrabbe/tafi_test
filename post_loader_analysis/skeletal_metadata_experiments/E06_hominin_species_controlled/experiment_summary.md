# E06 - hominin_species_controlled

Hypothesis: Species differences may partly reflect context rather than biology.

Expected pattern: Differences may weaken after contextual controls.

Why interesting: Checks taxonomic confounding.

## Grouping

Group variables: hominin_species

Covariates for PERMANOVA: geological_period + date_bin + taphonomic_context + site_environment

## Summary



|experiment_id |experiment_name            |group_vars      |covariates                                                           | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                 | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:---------------|:--------------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:---------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E06           |hominin_species_controlled |hominin_species |geological_period + date_bin + taphonomic_context + site_environment |       410|        6|                50|                45| 0.2735713|mnau_postcranial_total_mean |        0.2735713|                 0|          0.0136265|            0.1374|

## Group sizes



|group                      | n_records|
|:--------------------------|---------:|
|H. sapiens                 |       244|
|H. neanderthalensis        |       116|
|Middle Pleistocene hominin |        24|
|H. erectus                 |        22|
|Homo sapiens               |         2|
|Other_small_groups         |         2|

## Top 10 features



|feature                         |   n| n_groups|         H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-------------------------------|---:|--------:|---------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_postcranial_total_mean     | 410|        6| 111.89066|  5|  0| 0.2735713|     0|TRUE               |large  |
|mnau_appendicular_mean          | 410|        6| 109.02958|  5|  0| 0.2665760|     0|TRUE               |large  |
|mnau_proximal_appendicular_mean | 410|        6| 106.21257|  5|  0| 0.2596884|     0|TRUE               |large  |
|mnau_region_mean_evenness       | 394|        6| 100.64499|  5|  0| 0.2560941|     0|TRUE               |large  |
|density_evenness                | 394|        6|  96.01292|  5|  0| 0.2443077|     0|TRUE               |large  |
|mnau_upper_appendicular_mean    | 410|        6|  97.97936|  5|  0| 0.2395583|     0|TRUE               |large  |
|mnau_gini                       | 394|        6|  93.73369|  5|  0| 0.2385081|     0|TRUE               |large  |
|mnau_evenness_minus_dominance   | 394|        6|  93.68609|  5|  0| 0.2383870|     0|TRUE               |large  |
|mnau_inverse_simpson            | 394|        6|  93.63316|  5|  0| 0.2382523|     0|TRUE               |large  |
|mnau_simpson_evenness           | 394|        6|  93.63316|  5|  0| 0.2382523|     0|TRUE               |large  |

## PERMANOVA



|term               |  df|       sumsq|        R2|          F|      p|note |
|:------------------|---:|-----------:|---------:|----------:|------:|:----|
|group              |   5|   167.19714| 0.0136265|  1.5102393| 0.1374|NA   |
|geological_period  |   3|    59.92965| 0.0048842|  0.9022095| 0.4679|NA   |
|date_bin           |   3|    45.72546| 0.0037266|  0.6883729| 0.6212|NA   |
|taphonomic_context |   5|  1182.06335| 0.0963377| 10.6772070| 0.0001|NA   |
|site_environment   |   2|    86.89176| 0.0070816|  1.9621649| 0.1013|NA   |
|Residual           | 390|  8635.30522| 0.7037739|         NA|     NA|NA   |
|Total              | 409| 12270.00000| 1.0000000|         NA|     NA|NA   |
