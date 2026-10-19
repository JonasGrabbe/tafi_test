# E08 - recovery_context

Hypothesis: Recovery history affects the observed skeletal profile.

Expected pattern: More systematic excavation may recover more small/fragile elements.

Why interesting: Recovery-bias control.

## Grouping

Group variables: degree_of_excavation + discovery_context

Covariates for PERMANOVA: count_type

## Summary



|experiment_id |experiment_name  |group_vars                               |covariates | n_records| n_groups| n_features_tested| n_fdr_significant| max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:----------------|:----------------------------------------|:----------|---------:|--------:|-----------------:|-----------------:|--------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E08           |recovery_context |degree_of_excavation + discovery_context |count_type |       151|        8|                50|                16| 0.189551|mnau_arms   |         0.189551|         0.0053396|          0.1261582|             9e-04|

## Group sizes



|group                             | n_records|
|:---------------------------------|---------:|
|NA &#124; NA                      |        51|
|Partial &#124; Formal excavation  |        36|
|NA &#124; Formal excavation       |        35|
|NA &#124; Casual                  |        13|
|Other_small_groups                |         6|
|Complete &#124; Formal excavation |         4|
|NA &#124; Quarry                  |         4|
|NA &#124; Formal excavations      |         2|

## Top 10 features



|feature                           |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect |
|:---------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:------|
|mnau_arms                         | 151|        8| 28.43265|  7| 0.0001835| 0.1895510| 0.0053396|TRUE               |large  |
|mnau_limb_shaft_proxy_mean        | 151|        8| 28.06975|  7| 0.0002136| 0.1871316| 0.0053396|TRUE               |large  |
|mnau_legs                         | 151|        8| 25.47950|  7| 0.0006237| 0.1698633| 0.0077195|TRUE               |large  |
|mne_arms                          | 151|        8| 24.63383|  7| 0.0008809| 0.1642255| 0.0077195|TRUE               |large  |
|mnau_appendicular_mean            | 151|        8| 24.59931|  7| 0.0008934| 0.1639954| 0.0077195|TRUE               |large  |
|mnau_upper_appendicular_mean      | 151|        8| 24.44161|  7| 0.0009525| 0.1629440| 0.0077195|TRUE               |large  |
|distal_appendicular_continuity_hm | 151|        8| 23.93492|  7| 0.0011697| 0.1595661| 0.0077195|TRUE               |large  |
|mnau_proximal_appendicular_mean   | 151|        8| 23.80042|  7| 0.0012351| 0.1586695| 0.0077195|TRUE               |large  |
|mnau_postcranial_total_mean       | 151|        8| 23.24252|  7| 0.0015465| 0.1549501| 0.0085915|TRUE               |large  |
|mnau_hands                        | 151|        8| 22.23301|  7| 0.0023157| 0.1482201| 0.0115786|TRUE               |large  |

## PERMANOVA



|term     |  df|     sumsq|        R2|        F|     p|note |
|:--------|---:|---------:|---------:|--------:|-----:|:----|
|group    |   7|  567.7119| 0.1261582| 2.949312| 9e-04|NA   |
|Residual | 143| 3932.2881| 0.8738418|       NA|    NA|NA   |
|Total    | 150| 4500.0000| 1.0000000|       NA|    NA|NA   |
