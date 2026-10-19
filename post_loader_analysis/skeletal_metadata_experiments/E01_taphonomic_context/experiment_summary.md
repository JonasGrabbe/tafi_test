# E01 - taphonomic_context

Hypothesis: Accumulation cause is associated with skeletal-part representation.

Expected pattern: Skeletal profiles may differ among accumulation causes.

Why interesting: Direct taphonomic comparison using only the main accumulation label.

## Grouping

Group variables: taphonomic_context

Covariates for PERMANOVA: 

## Summary



|experiment_id |experiment_name    |group_vars         |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                 | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:------------------|:------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:---------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E01           |taphonomic_context |taphonomic_context |           |       410|        6|                50|                48| 0.3412004|mnau_postcranial_total_mean |        0.3412004|                 0|          0.2520154|             1e-04|

## Group sizes



|group                | n_records|
|:--------------------|---------:|
|Funerary Context     |       241|
|Cannibalism          |        54|
|Unknown              |        34|
|Geological transport |        30|
|Sepulchral Cave      |        27|
|Carnivore            |        24|

## Top 10 features



|feature                         |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-------------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_postcranial_total_mean     | 410|        6| 139.5509|  5|  0| 0.3412004|     0|TRUE               |large  |
|mnau_appendicular_mean          | 410|        6| 135.7717|  5|  0| 0.3319601|     0|TRUE               |large  |
|mnau_proximal_appendicular_mean | 410|        6| 130.7753|  5|  0| 0.3197440|     0|TRUE               |large  |
|mnau_region_mean_evenness       | 394|        6| 123.2486|  5|  0| 0.3136097|     0|TRUE               |large  |
|mnau_simpson_dominance          | 394|        6| 122.5891|  5|  0| 0.3119316|     0|TRUE               |large  |
|mnau_inverse_simpson            | 394|        6| 122.5891|  5|  0| 0.3119316|     0|TRUE               |large  |
|mnau_simpson_evenness           | 394|        6| 122.5891|  5|  0| 0.3119316|     0|TRUE               |large  |
|all_sections_dominance          | 394|        6| 121.9317|  5|  0| 0.3102588|     0|TRUE               |large  |
|mnau_upper_appendicular_mean    | 410|        6| 126.7920|  5|  0| 0.3100048|     0|TRUE               |large  |
|mnau_evenness_minus_dominance   | 394|        6| 121.7498|  5|  0| 0.3097959|     0|TRUE               |large  |

## PERMANOVA



|term     |  df|     sumsq|        R2|        F|     p|note |
|:--------|---:|---------:|---------:|--------:|-----:|:----|
|group    |   5|  3092.229| 0.2520154| 27.22362| 1e-04|NA   |
|Residual | 404|  9177.770| 0.7479846|       NA|    NA|NA   |
|Total    | 409| 12270.000| 1.0000000|       NA|    NA|NA   |
