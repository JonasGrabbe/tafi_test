# E05 - geological_period_mis_date

Hypothesis: Older assemblages are more altered by long-term attrition and recovery bias.

Expected pattern: Earlier Pleistocene contexts may show stronger loss of fragile elements and more dominance of durable cranial, dental, shaft, or dense long-bone remains.

Why interesting: This tests time-depth and preservation intensity, while retaining depositional and contextual covariates for PERMANOVA.

## Grouping

Group variables: geological_period + date_bin

Covariates for PERMANOVA: mis_stage + karstic_system + open_air_site + taphonomic_context

## Summary



|experiment_id |experiment_name            |group_vars                   |covariates                                                      | n_records| n_groups| n_features_tested| n_fdr_significant| max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------|:----------------------------|:---------------------------------------------------------------|---------:|--------:|-----------------:|-----------------:|--------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E05           |geological_period_mis_date |geological_period + date_bin |mis_stage + karstic_system + open_air_site + taphonomic_context |        NA|       NA|                NA|                NA|       NA|NA          |               NA|                NA|                 NA|                NA|

## Group sizes





## Top 10 features





## PERMANOVA



|term | df| sumsq| R2|  F|  p|note                                                                                                                                                                                                                                                                                                                                                  |
|:----|--:|-----:|--:|--:|--:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|NA   | NA|    NA| NA| NA| NA|[1m[22m`n` must be a constant.
[1mCaused by error in `dplyr::n()` at ]8;line = 905:col = 3;file://C:\Users\jonas.grabbe\tafi_test-1\skeletal_metadata_experiments_runner_fixed.Rskeletal_metadata_experiments_runner_fixed.R:905:3]8;;:[22m
[1m[22m[33m![39m Must only be used inside data-masking verbs like `mutate()`, `filter()`, and `group_by()`. |
