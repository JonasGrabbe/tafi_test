# E04 - age_category

Hypothesis: Age affects preservation because infant and juvenile bones are smaller, less fused, and more fragile.

Expected pattern: Infants and juveniles should show lower representation of small unfused bones, axial elements, ribs, vertebrae, hands, feet, and pelvis.

Why interesting: This is a biological/taphonomic control that should be tested before interpreting cultural or species differences.

## Grouping

Group variables: age_category

Covariates for PERMANOVA: mni + degree_of_excavation

## Summary



|experiment_id |experiment_name |group_vars   |covariates                 | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:---------------|:------------|:--------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:-----------|----------------:|-----------------:|------------------:|-----------------:|
|E04           |age_category    |age_category |mni + degree_of_excavation |       151|        5|                63|                 1| 0.1431048|mne_arms    |        0.1431048|         0.0161258|          0.0540323|             0.018|

## Group sizes



|group              | n_records|
|:------------------|---------:|
|Mixed              |        55|
|Adult              |        51|
|Indet              |        27|
|Other_small_groups |        13|
|Subadult           |         5|

## Top 10 features



|feature                                      |   n| n_groups|         H| df|         p|      eps2|     p_fdr|significant_fdr_05 |effect   |
|:--------------------------------------------|---:|--------:|---------:|--:|---------:|---------:|---------:|:------------------|:--------|
|mne_arms                                     | 151|        5| 21.465727|  4| 0.0002560| 0.1431048| 0.0161258|TRUE               |large    |
|density_adjusted_appendicular_axial_contrast | 151|        5| 13.740039|  4| 0.0081727| 0.0916003| 0.2574393|FALSE              |moderate |
|dominant_axial_share                         | 151|        5| 10.422736|  4| 0.0338781| 0.0694849| 0.7114399|FALSE              |moderate |
|ReMNAU_radius                                | 151|        5|  8.761298|  4| 0.0673508| 0.0584087| 0.7883648|FALSE              |small    |
|distal_appendicular_continuity_hm            | 151|        5|  8.707108|  4| 0.0688522| 0.0580474| 0.7883648|FALSE              |small    |
|mne_cranial_share                            | 151|        5|  8.424599|  4| 0.0772060| 0.0561640| 0.7883648|FALSE              |small    |
|ProportionalRep_MNIbased_carpal              | 151|        5|  8.012820|  4| 0.0911097| 0.0534188| 0.7883648|FALSE              |small    |
|lower_appendicular_evenness_refined          | 123|        5|  5.834320|  4| 0.2118677| 0.0478223| 0.7883648|FALSE              |small    |
|lower_appendicular_evenness                  | 123|        5|  5.834320|  4| 0.2118677| 0.0478223| 0.7883648|FALSE              |small    |
|ProportionalRep_MNIbased_femur               | 151|        5|  6.872761|  4| 0.1427669| 0.0458184| 0.7883648|FALSE              |small    |

## PERMANOVA



|term                 |  df|      sumsq|        R2|        F|      p|note |
|:--------------------|---:|----------:|---------:|--------:|------:|:----|
|group                |   4|  243.14514| 0.0540323| 2.229908| 0.0180|NA   |
|mni                  |   1|   84.07819| 0.0186840| 3.084358| 0.0322|NA   |
|degree_of_excavation |   3|  218.83063| 0.0486290| 2.675890| 0.0102|NA   |
|Residual             | 142| 3870.85549| 0.8601901|       NA|     NA|NA   |
|Total                | 150| 4500.00000| 1.0000000|       NA|     NA|NA   |
