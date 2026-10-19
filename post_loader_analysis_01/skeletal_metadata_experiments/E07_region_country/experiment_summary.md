# E07 - region_country

Hypothesis: Regional differences may reflect geology and research/recovery history.

Expected pattern: Some regions may systematically preserve or recover different body parts.

Why interesting: Bias-detection analysis.

## Grouping

Group variables: region

Covariates for PERMANOVA: country + site_environment + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars |covariates                                        | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:----------|:-------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E07           |region_country  |region     |country + site_environment + degree_of_excavation |       151|        8|                50|                33| 0.1932913|mne_arms    |        0.1932913|         0.0072535|          0.0163604|            0.2433|

## Group sizes



|group              | n_records|
|:------------------|---------:|
|West Europe        |       107|
|Central Europe     |        12|
|Other_small_groups |         8|
|West Asia          |         7|
|Europe             |         6|
|Southeast Asia     |         5|
|Eastern Europe     |         3|
|North America      |         3|

## Top 10 features



|feature                             |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect |
|:-----------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:------|
|mne_arms                            | 151|        8| 28.99369|  7| 0.0001451| 0.1932913| 0.0072535|TRUE               |large  |
|mnau_distal_appendicular_mean       | 151|        8| 27.11940|  7| 0.0003172| 0.1807960| 0.0079296|TRUE               |large  |
|distal_appendicular_continuity_hm   | 151|        8| 25.60690|  7| 0.0005919| 0.1707127| 0.0098656|TRUE               |large  |
|appendicular_dominance_refined      | 128|        8| 20.55349|  7| 0.0044904| 0.1618385| 0.0237253|TRUE               |large  |
|appendicular_dominance              | 128|        8| 20.55349|  7| 0.0044904| 0.1618385| 0.0237253|TRUE               |large  |
|mnau_foot                           | 151|        8| 23.66067|  7| 0.0013068| 0.1577378| 0.0163351|TRUE               |large  |
|postcranial_dominance_refined       | 128|        8| 19.19700|  7| 0.0075921| 0.1511575| 0.0237253|TRUE               |large  |
|mnau_region_mean_evenness           | 149|        8| 21.90145|  7| 0.0026417| 0.1479828| 0.0237253|TRUE               |large  |
|lower_appendicular_evenness_refined | 123|        8| 17.24787|  7| 0.0158659| 0.1413760| 0.0330540|TRUE               |large  |
|lower_appendicular_evenness         | 123|        8| 17.24787|  7| 0.0158659| 0.1413760| 0.0330540|TRUE               |large  |

## PERMANOVA



|term                 |  df|      sumsq|        R2|        F|      p|note |
|:--------------------|---:|----------:|---------:|--------:|------:|:----|
|group                |   2|   73.62163| 0.0163604| 1.356741| 0.2433|NA   |
|country              |  22|  605.73804| 0.1346085| 1.014808| 0.4478|NA   |
|site_environment     |   1|   28.23547| 0.0062745| 1.040679| 0.3138|NA   |
|degree_of_excavation |   2|   76.37445| 0.0169721| 1.407472| 0.2075|NA   |
|Residual             | 117| 3174.41895| 0.7054264|       NA|     NA|NA   |
|Total                | 150| 4500.00000| 1.0000000|       NA|     NA|NA   |
