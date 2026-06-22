# E02 - karstic_system_open_air_site

Hypothesis: Depositional environment filters the skeleton before excavation.

Expected pattern: Cave interiors may preserve more small elements; cave entrances and rockshelters may show disturbance or carnivore activity; fluvial/open-air contexts may preferentially preserve dense or large elements.

Why interesting: This tests whether site formation, rather than species or culture, explains skeletal-part differences.

## Grouping

Group variables: karstic_system + open_air_site

Covariates for PERMANOVA: 

## Summary



|experiment_id |experiment_name              |group_vars                     |covariates | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature                | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:----------------------------|:------------------------------|:----------|---------:|--------:|-----------------:|-----------------:|---------:|:--------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E02           |karstic_system_open_air_site |karstic_system + open_air_site |           |       151|        4|                63|                51| 0.1385122|mnau_limb_shaft_proxy_mean |        0.1385122|         0.0014278|           0.103597|             1e-04|

## Group sizes



|group                 | n_records|
|:---------------------|---------:|
|Cave &#124; NA        |       104|
|NA &#124; Open air    |        21|
|Rockshelter &#124; NA |        17|
|Other_small_groups    |         9|

## Top 10 features



|feature                         |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:-------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mnau_limb_shaft_proxy_mean      | 151|        4| 20.77684|  3| 0.0001171| 0.1385122| 0.0014278|TRUE               |moderate |
|mnau_appendicular_mean          | 151|        4| 20.51536|  3| 0.0001327| 0.1367690| 0.0014278|TRUE               |moderate |
|mnau_region_mean_evenness       | 149|        4| 20.17546|  3| 0.0001561| 0.1363207| 0.0014278|TRUE               |moderate |
|ReMNAU_ulna                     | 151|        4| 20.33689|  3| 0.0001445| 0.1355793| 0.0014278|TRUE               |moderate |
|mnau_arms                       | 151|        4| 20.00133|  3| 0.0001696| 0.1333422| 0.0014278|TRUE               |moderate |
|mnau_upper_appendicular_mean    | 151|        4| 19.76671|  3| 0.0001897| 0.1317781| 0.0014278|TRUE               |moderate |
|mnau_postcranial_total_mean     | 151|        4| 19.70217|  3| 0.0001957| 0.1313478| 0.0014278|TRUE               |moderate |
|ProportionalRep_MNIbased_radius | 151|        4| 19.66414|  3| 0.0001992| 0.1310943| 0.0014278|TRUE               |moderate |
|mnau_top2_share_mcnaughton      | 149|        4| 18.71585|  3| 0.0003130| 0.1264584| 0.0014278|TRUE               |moderate |
|mnau_gini                       | 149|        4| 18.70352|  3| 0.0003148| 0.1263752| 0.0014278|TRUE               |moderate |

## PERMANOVA



|term     |  df|     sumsq|       R2|        F|     p|note |
|:--------|---:|---------:|--------:|--------:|-----:|:----|
|group    |   3|  466.1866| 0.103597| 5.662915| 1e-04|NA   |
|Residual | 147| 4033.8134| 0.896403|       NA|    NA|NA   |
|Total    | 150| 4500.0000| 1.000000|       NA|    NA|NA   |
