# E07 - region_country

Hypothesis: Regional research history, geology, climate, and excavation tradition affect recovery.

Expected pattern: Some regions may have more complete profiles because of cave preservation or modern excavation, whereas others may be biased toward diagnostic cranial or dental material.

Why interesting: This is a bias-detection analysis rather than a strong behavioral model.

## Grouping

Group variables: region

Covariates for PERMANOVA: country + karstic_system + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars |covariates                                      | n_records| n_groups| n_features_tested| n_fdr_significant| max_eps2|top_feature                   | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:----------|:-----------------------------------------------|---------:|--------:|-----------------:|-----------------:|--------:|:-----------------------------|----------------:|-----------------:|------------------:|-----------------:|
|E07           |region_country  |region     |country + karstic_system + degree_of_excavation |       151|        6|                63|                26| 0.154707|mnau_distal_appendicular_mean |         0.154707|         0.0114109|          0.0192452|            0.1646|

## Group sizes



|group              | n_records|
|:------------------|---------:|
|West Europe        |       107|
|Other_small_groups |        14|
|Central Europe     |        12|
|West Asia          |         7|
|Europe             |         6|
|Southeast Asia     |         5|

## Top 10 features



|feature                             |   n| n_groups|        H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:-----------------------------------|---:|--------:|--------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mnau_distal_appendicular_mean       | 151|        6| 23.20605|  5| 0.0003083| 0.1547070| 0.0114109|TRUE               |large    |
|mne_arms                            | 151|        6| 22.83960|  5| 0.0003623| 0.1522640| 0.0114109|TRUE               |large    |
|distal_appendicular_continuity_hm   | 151|        6| 21.31242|  5| 0.0007070| 0.1420828| 0.0143064|TRUE               |large    |
|ProportionalRep_MNIbased_carpal     | 151|        6| 20.73654|  5| 0.0009083| 0.1382436| 0.0143064|TRUE               |moderate |
|mnau_foot                           | 151|        6| 19.79838|  5| 0.0013634| 0.1319892| 0.0171788|TRUE               |moderate |
|appendicular_dominance_refined      | 128|        6| 16.58865|  5| 0.0053498| 0.1306193| 0.0279840|TRUE               |moderate |
|appendicular_dominance              | 128|        6| 16.58865|  5| 0.0053498| 0.1306193| 0.0279840|TRUE               |moderate |
|lower_appendicular_evenness_refined | 123|        6| 15.25463|  5| 0.0093280| 0.1250379| 0.0279840|TRUE               |moderate |
|lower_appendicular_evenness         | 123|        6| 15.25463|  5| 0.0093280| 0.1250379| 0.0279840|TRUE               |moderate |
|postcranial_dominance_refined       | 128|        6| 15.64929|  5| 0.0079201| 0.1232228| 0.0279840|TRUE               |moderate |

## PERMANOVA



|term                 |  df|      sumsq|        R2|         F|      p|note |
|:--------------------|---:|----------:|---------:|---------:|------:|:----|
|group                |   2|   86.60343| 0.0192452| 1.6098832| 0.1646|NA   |
|country              |  24|  619.36798| 0.1376373| 0.9594598| 0.5427|NA   |
|karstic_system       |   3|  147.50162| 0.0327781| 1.8279521| 0.0919|NA   |
|degree_of_excavation |   2|   60.80153| 0.0135115| 1.1302481| 0.3118|NA   |
|Residual             | 115| 3093.20400| 0.6873787|        NA|     NA|NA   |
|Total                | 150| 4500.00000| 1.0000000|        NA|     NA|NA   |
