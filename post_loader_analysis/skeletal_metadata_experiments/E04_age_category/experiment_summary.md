# E04 - age_category

Hypothesis: Age affects preservation and recovery.

Expected pattern: Younger individuals may show lower representation of fragile/small elements.

Why interesting: Biological control.

## Grouping

Group variables: age_category

Covariates for PERMANOVA: mni + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars   |covariates                 | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                     | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:------------|:--------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-------------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E04           |age_category    |age_category |mni + degree_of_excavation |       410|        8|                50|                38| 0.0886184|mnau_proximal_appendicular_mean |        0.0886184|         0.0001615|          0.0402655|            0.0022|

## Group sizes



|group              | n_records|
|:------------------|---------:|
|Adult              |       191|
|Juvenile           |        61|
|Indet              |        46|
|Infant             |        39|
|Mixed              |        34|
|Subadult           |        34|
|Subadults          |         3|
|Other_small_groups |         2|

## Top 10 features



|feature                          |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:--------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mnau_proximal_appendicular_mean  | 410|        8| 36.24492|  7| 0.0000065| 0.0886184| 0.0001615|TRUE               |moderate |
|mnau_limb_shaft_proxy_mean       | 410|        8| 35.79346|  7| 0.0000079| 0.0875146| 0.0001615|TRUE               |moderate |
|mnau_appendicular_mean           | 410|        8| 35.33122|  7| 0.0000097| 0.0863844| 0.0001615|TRUE               |moderate |
|mnau_postcranial_total_mean      | 410|        8| 33.90830|  7| 0.0000179| 0.0829054| 0.0002240|TRUE               |moderate |
|mnau_legs                        | 410|        8| 33.04625|  7| 0.0000260| 0.0807977| 0.0002596|TRUE               |moderate |
|mnau_lower_appendicular_mean     | 410|        8| 31.91375|  7| 0.0000421| 0.0780287| 0.0003512|TRUE               |moderate |
|mnau_girdle_mean                 | 410|        8| 28.12646|  7| 0.0002086| 0.0687689| 0.0014899|TRUE               |moderate |
|mnau_upper_appendicular_mean     | 410|        8| 27.25670|  7| 0.0002996| 0.0666423| 0.0018726|TRUE               |moderate |
|lower_appendicular_continuity_hm | 410|        8| 26.46295|  7| 0.0004162| 0.0647016| 0.0021183|TRUE               |moderate |
|mne_arms                         | 410|        8| 26.41980|  7| 0.0004237| 0.0645961| 0.0021183|TRUE               |moderate |

## PERMANOVA



|term                 |  df|      sumsq|        R2|        F|      p|note |
|:--------------------|---:|----------:|---------:|--------:|------:|:----|
|group                |   7|   494.0577| 0.0402655| 2.720284| 0.0022|NA   |
|mni                  |   1|   196.4364| 0.0160095| 7.571059| 0.0012|NA   |
|degree_of_excavation |   4|   843.6432| 0.0687566| 8.128930| 0.0001|NA   |
|Residual             | 397| 10300.4438| 0.8394820|       NA|     NA|NA   |
|Total                | 409| 12270.0000| 1.0000000|       NA|     NA|NA   |
