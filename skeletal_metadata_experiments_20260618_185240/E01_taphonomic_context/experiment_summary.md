# E01 - taphonomic_context

Hypothesis: Different accumulation causes produce different body-part profiles.

Expected pattern: Funerary contexts should be more anatomically balanced; carnivore/geological transport should lose small, fragile, axial, or low-density elements; cannibalism may show selective absence or overrepresentation of processed parts.

Why interesting: This is the strongest direct taphonomic hypothesis because accumulation cause is directly linked to skeletal survival, transport, human handling, and carnivore behavior.

## Grouping

Group variables: taphonomic_context

Covariates for PERMANOVA: 

## Summary



|experiment_id |experiment_name    |group_vars         |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:------------------|:------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:--------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E01           |taphonomic_context |taphonomic_context |           |       151|        7|                63|                57| 0.5830315|mnau_top2_share_mcnaughton |        0.5830315|                 0|          0.4541113|             1e-04|

## Group sizes



|group                | n_records|
|:--------------------|---------:|
|Funerary Context     |        48|
|Cannibalism          |        25|
|Cuevas Sepulcrales   |        24|
|Unknown              |        20|
|Carnivore            |        14|
|Geological transport |        13|
|Other_small_groups   |         7|

## Top 10 features



|feature                       |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-----------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_top2_share_mcnaughton    | 149|        7| 86.28866|  6|  0| 0.5830315|     0|TRUE               |large  |
|low_density_survival_index    | 151|        7| 83.50957|  6|  0| 0.5567305|     0|TRUE               |large  |
|mnau_gini                     | 149|        7| 82.24076|  6|  0| 0.5556808|     0|TRUE               |large  |
|mnau_cv                       | 149|        7| 82.21329|  6|  0| 0.5554952|     0|TRUE               |large  |
|mnau_evenness_minus_dominance | 149|        7| 82.15696|  6|  0| 0.5551146|     0|TRUE               |large  |
|mnau_simpson_dominance        | 149|        7| 82.12963|  6|  0| 0.5549299|     0|TRUE               |large  |
|mnau_inverse_simpson          | 149|        7| 82.12963|  6|  0| 0.5549299|     0|TRUE               |large  |
|mnau_simpson_evenness         | 149|        7| 82.12963|  6|  0| 0.5549299|     0|TRUE               |large  |
|mnau_heip_evenness            | 149|        7| 81.78783|  6|  0| 0.5526205|     0|TRUE               |large  |
|effective_sections_hill1      | 149|        7| 81.78783|  6|  0| 0.5526205|     0|TRUE               |large  |

## PERMANOVA



|term     |  df|    sumsq|        R2|        F|     p|note |
|:--------|---:|--------:|---------:|--------:|-----:|:----|
|group    |   6| 2043.501| 0.4541113| 19.96501| 1e-04|NA   |
|Residual | 144| 2456.499| 0.5458887|       NA|    NA|NA   |
|Total    | 150| 4500.000| 1.0000000|       NA|    NA|NA   |
