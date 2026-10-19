# E06 - hominin_species_controlled

Hypothesis: Species differences may partly reflect context rather than biology.

Expected pattern: Differences may weaken after contextual controls.

Why interesting: Checks taxonomic confounding.

## Grouping

Group variables: hominin_species

Covariates for PERMANOVA: geological_period + date_bin + taphonomic_context + site_environment

## Summary



|experiment_id |experiment_name            |group_vars      |covariates                                                           | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:---------------|:--------------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:--------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E06           |hominin_species_controlled |hominin_species |geological_period + date_bin + taphonomic_context + site_environment |       151|        5|                50|                41| 0.2182384|mnau_top2_share_mcnaughton |        0.2182384|          2.15e-05|          0.0071405|            0.8524|

## Group sizes



|group                      | n_records|
|:--------------------------|---------:|
|H. sapiens                 |        79|
|H. neanderthalensis        |        50|
|Middle Pleistocene hominin |        14|
|H. erectus                 |         5|
|Other_small_groups         |         3|

## Top 10 features



|feature                     |   n| n_groups|        H| df|       p|      eps2|    p_fdr|significant_fdr_05 |effect |
|:---------------------------|---:|--------:|--------:|--:|-------:|---------:|--------:|:------------------|:------|
|mnau_top2_share_mcnaughton  | 149|        5| 32.29928|  4| 1.7e-06| 0.2182384| 2.15e-05|TRUE               |large  |
|density_evenness            | 149|        5| 32.19818|  4| 1.7e-06| 0.2175553| 2.15e-05|TRUE               |large  |
|dominance_gap_all           | 149|        5| 30.60401|  4| 3.7e-06| 0.2067839| 2.15e-05|TRUE               |large  |
|all_sections_dominance      | 149|        5| 30.44855|  4| 4.0e-06| 0.2057335| 2.15e-05|TRUE               |large  |
|low_density_axial_survival  | 151|        5| 30.79397|  4| 3.4e-06| 0.2052931| 2.15e-05|TRUE               |large  |
|low_density_share           | 149|        5| 30.32997|  4| 4.2e-06| 0.2049322| 2.15e-05|TRUE               |large  |
|mnau_postcranial_total_mean | 151|        5| 30.69782|  4| 3.5e-06| 0.2046521| 2.15e-05|TRUE               |large  |
|mnau_appendicular_mean      | 151|        5| 30.41865|  4| 4.0e-06| 0.2027910| 2.15e-05|TRUE               |large  |
|low_density_survival_index  | 151|        5| 30.20256|  4| 4.5e-06| 0.2013504| 2.15e-05|TRUE               |large  |
|mnau_cv                     | 149|        5| 29.26189|  4| 6.9e-06| 0.1977155| 2.15e-05|TRUE               |large  |

## PERMANOVA



|term               |  df|      sumsq|        R2|          F|      p|note |
|:------------------|---:|----------:|---------:|----------:|------:|:----|
|group              |   4|   32.13238| 0.0071405|  0.4970074| 0.8524|NA   |
|geological_period  |   3|   50.77010| 0.0112822|  1.0470483| 0.3767|NA   |
|date_bin           |   3|   35.20876| 0.0078242|  0.7261217| 0.6043|NA   |
|taphonomic_context |   5| 1465.57126| 0.3256825| 18.1349726| 0.0001|NA   |
|site_environment   |   2|   81.75725| 0.0181683|  2.5291598| 0.0494|NA   |
|Residual           | 132| 2133.50647| 0.4741125|         NA|     NA|NA   |
|Total              | 150| 4500.00000| 1.0000000|         NA|     NA|NA   |
