# E08 - recovery_context

Hypothesis: Recovery history affects the observed skeletal profile.

Expected pattern: More systematic excavation may recover more small/fragile elements.

Why interesting: Recovery-bias control.

## Grouping

Group variables: degree_of_excavation + discovery_context

Covariates for PERMANOVA: count_type

## Summary



|experiment_id |experiment_name  |group_vars                               |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                     | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:----------------|:----------------------------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:-------------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E08           |recovery_context |degree_of_excavation + discovery_context |count_type |       410|       10|                50|                39| 0.1872419|mnau_proximal_appendicular_mean |        0.1872419|                 0|          0.1143132|             1e-04|

## Group sizes



|group                             | n_records|
|:---------------------------------|---------:|
|NA &#124; Formal excavation       |       107|
|Partial &#124; Formal excavation  |       103|
|Complete &#124; Casual            |        79|
|NA &#124; NA                      |        60|
|NA &#124; Casual                  |        21|
|Complete &#124; Formal excavation |        19|
|NA &#124; Quarry                  |        12|
|Other_small_groups                |         5|
|NA &#124; Formal excavations      |         2|
|Partial &#124; Formal             |         2|

## Top 10 features



|feature                         |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-------------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_proximal_appendicular_mean | 410|       10| 76.58192|  9|  0| 0.1872419|     0|TRUE               |large  |
|mnau_postcranial_total_mean     | 410|       10| 73.73405|  9|  0| 0.1802789|     0|TRUE               |large  |
|mnau_appendicular_mean          | 410|       10| 73.26393|  9|  0| 0.1791294|     0|TRUE               |large  |
|mnau_limb_shaft_proxy_mean      | 410|       10| 70.24473|  9|  0| 0.1717475|     0|TRUE               |large  |
|mnau_girdle_mean                | 410|       10| 66.58016|  9|  0| 0.1627877|     0|TRUE               |large  |
|mnau_lower_appendicular_mean    | 410|       10| 64.76974|  9|  0| 0.1583612|     0|TRUE               |large  |
|mnau_upper_appendicular_mean    | 410|       10| 63.68748|  9|  0| 0.1557151|     0|TRUE               |large  |
|mnau_arms                       | 410|       10| 61.17148|  9|  0| 0.1495635|     0|TRUE               |large  |
|mnau_column_trunk_mean          | 410|       10| 60.87384|  9|  0| 0.1488358|     0|TRUE               |large  |
|mnau_legs                       | 410|       10| 60.58781|  9|  0| 0.1481364|     0|TRUE               |large  |

## PERMANOVA



|term       |  df|       sumsq|        R2|        F|      p|note |
|:----------|---:|-----------:|---------:|--------:|------:|:----|
|group      |   9|  1402.62303| 0.1143132| 5.743699| 0.0001|NA   |
|count_type |   1|    65.98116| 0.0053774| 2.431718| 0.0913|NA   |
|Residual   | 399| 10826.29103| 0.8823383|       NA|     NA|NA   |
|Total      | 409| 12270.00000| 1.0000000|       NA|     NA|NA   |
