# E03 - site_environment_detail

Hypothesis: Subtypes within karstic/open-air settings may further structure preservation.

Expected pattern: Cave interior, entrance, rockshelter, fluvial, eolian, lake, etc. may differ.

Why interesting: Uses one hierarchical setting label rather than two independent columns.

## Grouping

Group variables: site_environment_detail

Covariates for PERMANOVA: taphonomic_context + geological_period

## Summary



|experiment_id |experiment_name         |group_vars              |covariates                             | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature               | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:-----------------------|:-----------------------|:--------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E03           |site_environment_detail |site_environment_detail |taphonomic_context + geological_period |       151|        6|                50|                35| 0.1263565|mnau_region_mean_evenness |        0.1263565|         0.0119712|          0.0274832|            0.1142|

## Group sizes



|group                      | n_records|
|:--------------------------|---------:|
|Karstic &#124; Cave        |       104|
|Open air                   |        25|
|Karstic &#124; Rockshelter |        17|
|Karstic &#124; Open air    |         2|
|missing                    |         2|
|Other_small_groups         |         1|

## Top 10 features



|feature                       |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:-----------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mnau_region_mean_evenness     | 149|        6| 18.70077|  5| 0.0021850| 0.1263565| 0.0119712|TRUE               |moderate |
|mnau_appendicular_mean        | 151|        6| 18.85265|  5| 0.0020475| 0.1256843| 0.0119712|TRUE               |moderate |
|mnau_distal_appendicular_mean | 151|        6| 18.80722|  5| 0.0020877| 0.1253815| 0.0119712|TRUE               |moderate |
|mnau_top2_share_mcnaughton    | 149|        6| 18.37919|  5| 0.0025069| 0.1241837| 0.0119712|TRUE               |moderate |
|mnau_upper_appendicular_mean  | 151|        6| 18.58709|  5| 0.0022939| 0.1239139| 0.0119712|TRUE               |moderate |
|mnau_postcranial_total_mean   | 151|        6| 18.01550|  5| 0.0029270| 0.1201033| 0.0119712|TRUE               |moderate |
|all_sections_dominance        | 149|        6| 17.67517|  5| 0.0033823| 0.1194269| 0.0119712|TRUE               |moderate |
|mnau_limb_shaft_proxy_mean    | 151|        6| 17.80713|  5| 0.0031981| 0.1187142| 0.0119712|TRUE               |moderate |
|mnau_simpson_dominance        | 149|        6| 17.50437|  5| 0.0036362| 0.1182728| 0.0119712|TRUE               |moderate |
|mnau_inverse_simpson          | 149|        6| 17.50437|  5| 0.0036362| 0.1182728| 0.0119712|TRUE               |moderate |

## PERMANOVA



|term               |  df|     sumsq|        R2|         F|      p|note |
|:------------------|---:|---------:|---------:|---------:|------:|:----|
|group              |   5|  123.6746| 0.0274832|  1.580280| 0.1142|NA   |
|taphonomic_context |   5| 1736.7403| 0.3859423| 22.191586| 0.0001|NA   |
|geological_period  |   4|  106.2296| 0.0236066|  1.696715| 0.1026|NA   |
|Residual           | 136| 2128.7049| 0.4730455|        NA|     NA|NA   |
|Total              | 150| 4500.0000| 1.0000000|        NA|     NA|NA   |
