# E06 - hominin_species_controlled

Hypothesis: Species-level differences may reflect different depositional histories rather than species anatomy alone.

Expected pattern: Species may differ descriptively, but many differences may weaken after controlling for period, site type, and taphonomic context.

Why interesting: This is interpretively interesting but risky; the script reports both group effects and PERMANOVA with covariates.

## Grouping

Group variables: hominin_species

Covariates for PERMANOVA: geological_period + date_bin + taphonomic_context + karstic_system + open_air_site

## Summary



|experiment_id |experiment_name            |group_vars      |covariates                                                                         | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:---------------|:----------------------------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:--------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E06           |hominin_species_controlled |hominin_species |geological_period + date_bin + taphonomic_context + karstic_system + open_air_site |       151|        5|                63|                56| 0.2182384|mnau_top2_share_mcnaughton |        0.2182384|          2.71e-05|          0.0068604|            0.8966|

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
|mnau_top2_share_mcnaughton  | 149|        5| 32.29928|  4| 1.7e-06| 0.2182384| 2.71e-05|TRUE               |large  |
|density_evenness            | 149|        5| 32.19818|  4| 1.7e-06| 0.2175553| 2.71e-05|TRUE               |large  |
|dominance_gap_all           | 149|        5| 30.60401|  4| 3.7e-06| 0.2067839| 2.71e-05|TRUE               |large  |
|all_sections_dominance      | 149|        5| 30.44855|  4| 4.0e-06| 0.2057335| 2.71e-05|TRUE               |large  |
|low_density_axial_survival  | 151|        5| 30.79397|  4| 3.4e-06| 0.2052931| 2.71e-05|TRUE               |large  |
|low_density_share           | 149|        5| 30.32997|  4| 4.2e-06| 0.2049322| 2.71e-05|TRUE               |large  |
|mnau_postcranial_total_mean | 151|        5| 30.69782|  4| 3.5e-06| 0.2046521| 2.71e-05|TRUE               |large  |
|mnau_appendicular_mean      | 151|        5| 30.41865|  4| 4.0e-06| 0.2027910| 2.71e-05|TRUE               |large  |
|low_density_survival_index  | 151|        5| 30.20256|  4| 4.5e-06| 0.2013504| 2.71e-05|TRUE               |large  |
|mnau_cv                     | 149|        5| 29.26189|  4| 6.9e-06| 0.1977155| 2.71e-05|TRUE               |large  |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|      p|note |
|:------------------|---:|----------:|---------:|---------:|------:|:----|
|group              |   4|   30.87181| 0.0068604| 0.4402800| 0.8966|NA   |
|geological_period  |   4|   78.31121| 0.0174025| 1.1168395| 0.3462|NA   |
|date_bin           |   3|   43.09458| 0.0095766| 0.8194608| 0.5347|NA   |
|taphonomic_context |  10| 1318.03956| 0.2928977| 7.5189162| 0.0001|NA   |
|karstic_system     |   3|   75.55036| 0.0167890| 1.4366207| 0.1994|NA   |
|open_air_site      |   3|  116.45257| 0.0258783| 2.2143927| 0.0493|NA   |
|Residual           | 122| 2138.61709| 0.4752482|        NA|     NA|NA   |
|Total              | 150| 4500.00000| 1.0000000|        NA|     NA|NA   |
