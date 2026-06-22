# E06 - hominin_species_controlled

Hypothesis: Species-level differences may reflect different depositional histories rather than species anatomy alone.

Expected pattern: Species may differ descriptively, but many differences may weaken after controlling for period, site type, and taphonomic context.

Why interesting: This is interpretively interesting but risky; the script reports both group effects and PERMANOVA with covariates.

## Grouping

Group variables: hominin_species

Covariates for PERMANOVA: geological_period + date_bin + taphonomic_context + karstic_system + open_air_site

## Summary



|experiment_id |experiment_name            |group_vars      |covariates                                                                         | n_records| n_groups| n_features_tested| n_fdr_significant| max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:---------------|:----------------------------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|--------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E06           |hominin_species_controlled |hominin_species |geological_period + date_bin + taphonomic_context + karstic_system + open_air_site |        NA|       NA|                NA|                NA|       NA|NA          |               NA|                NA|                 NA|                NA|

## Group sizes





## Top 10 features





## PERMANOVA



|term | df| sumsq| R2|  F|  p|note                 |
|:----|--:|-----:|--:|--:|--:|:--------------------|
|NA   | NA|    NA| NA| NA| NA|object '.' not found |
