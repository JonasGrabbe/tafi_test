# E01 - taphonomic_context

Hypothesis: Accumulation cause is associated with skeletal-part representation.

Expected pattern: Skeletal profiles may differ among accumulation causes.

Why interesting: Direct taphonomic comparison using only the main accumulation label.

## Grouping

Group variables: taphonomic_context

Covariates for PERMANOVA: 

## Summary



|experiment_id |experiment_name    |group_vars         |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:------------------|:------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:--------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E01           |taphonomic_context |taphonomic_context |           |       151|        6|                50|                46| 0.6334791|mnau_top2_share_mcnaughton |        0.6334791|                 0|          0.4806968|             1e-04|

## Group sizes



|group                | n_records|
|:--------------------|---------:|
|Funerary Context     |        49|
|Cannibalism          |        25|
|Sepulchral Cave      |        25|
|Unknown              |        23|
|Carnivore            |        17|
|Geological transport |        12|

## Top 10 features



|feature                       |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-----------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_top2_share_mcnaughton    | 149|        6| 93.75490|  5|  0| 0.6334791|     0|TRUE               |large  |
|mnau_gini                     | 149|        6| 89.68412|  5|  0| 0.6059738|     0|TRUE               |large  |
|low_density_survival_index    | 151|        6| 90.86894|  5|  0| 0.6057929|     0|TRUE               |large  |
|mnau_heip_evenness            | 149|        6| 89.30411|  5|  0| 0.6034062|     0|TRUE               |large  |
|effective_sections_hill1      | 149|        6| 89.30411|  5|  0| 0.6034062|     0|TRUE               |large  |
|mnau_simpson_dominance        | 149|        6| 89.26027|  5|  0| 0.6031099|     0|TRUE               |large  |
|mnau_inverse_simpson          | 149|        6| 89.26027|  5|  0| 0.6031099|     0|TRUE               |large  |
|mnau_simpson_evenness         | 149|        6| 89.26027|  5|  0| 0.6031099|     0|TRUE               |large  |
|mnau_cv                       | 149|        6| 89.09858|  5|  0| 0.6020175|     0|TRUE               |large  |
|mnau_evenness_minus_dominance | 149|        6| 88.98402|  5|  0| 0.6012434|     0|TRUE               |large  |

## PERMANOVA



|term     |  df|    sumsq|        R2|        F|     p|note |
|:--------|---:|--------:|---------:|--------:|-----:|:----|
|group    |   5| 2163.136| 0.4806968| 26.84406| 1e-04|NA   |
|Residual | 145| 2336.864| 0.5193032|       NA|    NA|NA   |
|Total    | 150| 4500.000| 1.0000000|       NA|    NA|NA   |
