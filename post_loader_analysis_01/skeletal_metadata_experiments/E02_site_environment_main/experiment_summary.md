# E02 - site_environment_main

Hypothesis: Karstic and open-air settings impose different depositional filters.

Expected pattern: Broad preservation patterns may differ between karstic and open-air contexts.

Why interesting: Treats karstic/open-air as one mutually-exclusive main variable.

## Grouping

Group variables: site_environment

Covariates for PERMANOVA: taphonomic_context

## Summary



|experiment_id |experiment_name       |group_vars       |covariates         | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature       | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------------|:----------------|:------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------------|----------------:|-----------------:|------------------:|-----------------:|
|E02           |site_environment_main |site_environment |taphonomic_context |       151|        3|                50|                 0| 0.0764024|mne_cranial_share |        0.0764024|         0.0523551|          0.0168291|            0.0597|

## Group sizes



|group    | n_records|
|:--------|---------:|
|Karstic  |       123|
|Open air |        26|
|missing  |         2|

## Top 10 features



|feature                           |   n| n_groups|         H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:---------------------------------|---:|--------:|---------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mne_cranial_share                 | 151|        3| 11.460364|  2| 0.0032465| 0.0764024| 0.0523551|FALSE              |moderate |
|mnau_distal_appendicular_mean     | 151|        3| 11.304080|  2| 0.0035103| 0.0753605| 0.0523551|FALSE              |moderate |
|distal_appendicular_continuity_hm | 151|        3| 10.130281|  2| 0.0063130| 0.0675352| 0.0523551|FALSE              |moderate |
|dominant_axial_share              | 151|        3| 10.113062|  2| 0.0063676| 0.0674204| 0.0523551|FALSE              |moderate |
|mnau_region_mean_evenness         | 149|        3|  9.808245|  2| 0.0074159| 0.0662719| 0.0523551|FALSE              |moderate |
|mnau_top2_share_mcnaughton        | 149|        3|  9.266327|  2| 0.0097239| 0.0626103| 0.0523551|FALSE              |moderate |
|mnau_dominance_of_region_means    | 149|        3|  9.145074|  2| 0.0103317| 0.0617910| 0.0523551|FALSE              |moderate |
|lower_appendicular_continuity_hm  | 151|        3|  8.995366|  2| 0.0111348| 0.0599691| 0.0523551|FALSE              |small    |
|mnau_gini                         | 149|        3|  8.803802|  2| 0.0122540| 0.0594851| 0.0523551|FALSE              |small    |
|mnau_hands                        | 151|        3|  8.709062|  2| 0.0128485| 0.0580604| 0.0523551|FALSE              |small    |

## PERMANOVA



|term               |  df|      sumsq|        R2|         F|      p|note |
|:------------------|---:|----------:|---------:|---------:|------:|:----|
|group              |   2|   75.73078| 0.0168291|  2.371574| 0.0597|NA   |
|taphonomic_context |   5| 2029.11061| 0.4509135| 25.417336| 0.0001|NA   |
|Residual           | 143| 2283.18826| 0.5073752|        NA|     NA|NA   |
|Total              | 150| 4500.00000| 1.0000000|        NA|     NA|NA   |
