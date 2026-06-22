# E07 - region_country

Hypothesis: Regional research history, geology, climate, and excavation tradition affect recovery.

Expected pattern: Some regions may have more complete profiles because of cave preservation or modern excavation, whereas others may be biased toward diagnostic cranial or dental material.

Why interesting: This is a bias-detection analysis rather than a strong behavioral model.

## Grouping

Group variables: region

Covariates for PERMANOVA: country + karstic_system + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars |covariates                                      | n_records| n_groups| n_features_tested| n_fdr_significant| max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:----------|:-----------------------------------------------|---------:|--------:|-----------------:|-----------------:|--------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E07           |region_country  |region     |country + karstic_system + degree_of_excavation |        NA|       NA|                NA|                NA|       NA|NA          |               NA|                NA|                 NA|                NA|

## Group sizes





## Top 10 features





## PERMANOVA



|term | df| sumsq| R2|  F|  p|note                                                                                                                                                                                                                                                                                                                                                  |
|:----|--:|-----:|--:|--:|--:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|NA   | NA|    NA| NA| NA| NA|[1m[22m`n` must be a constant.
[1mCaused by error in `dplyr::n()` at ]8;line = 905:col = 3;file://C:\Users\jonas.grabbe\tafi_test-1\skeletal_metadata_experiments_runner_fixed.Rskeletal_metadata_experiments_runner_fixed.R:905:3]8;;:[22m
[1m[22m[33m![39m Must only be used inside data-masking verbs like `mutate()`, `filter()`, and `group_by()`. |
