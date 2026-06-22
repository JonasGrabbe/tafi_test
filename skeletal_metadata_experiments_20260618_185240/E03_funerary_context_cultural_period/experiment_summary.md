# E03 - funerary_context_cultural_period

Hypothesis: Mortuary practice changes skeletal completeness and element selection through time.

Expected pattern: Single inhumations should approach complete skeletons; collective burials may overrepresent crania, long bones, or curated elements; non-inhumation contexts may be more fragmentary.

Why interesting: This separates intentional mortuary behavior from preservation and recovery loss.

## Grouping

Group variables: funerary_context + cultural_period

Covariates for PERMANOVA: degree_of_excavation + discovery_context

## Summary



|experiment_id |experiment_name                  |group_vars                         |covariates                               | n_records| n_groups| n_features_tested| n_fdr_significant|  max_eps2|top_feature            | top_feature_eps2| top_feature_p_fdr| permanova_group_R2| permanova_group_p|
|:-------------|:--------------------------------|:----------------------------------|:----------------------------------------|---------:|--------:|-----------------:|-----------------:|---------:|:----------------------|----------------:|-----------------:|------------------:|-----------------:|
|E03           |funerary_context_cultural_period |funerary_context + cultural_period |degree_of_excavation + discovery_context |       151|        8|                63|                56| 0.4549622|mnau_appendicular_mean |        0.4549622|                 0|          0.3093906|             1e-04|

## Group sizes



|group                                       | n_records|
|:-------------------------------------------|---------:|
|Other_small_groups                          |        48|
|NA &#124; Bronze Age                        |        25|
|NA &#124; Middle Paleolithic                |        23|
|Inhumation single &#124; Upper Paleolithic  |        13|
|NA &#124; NA                                |        11|
|NA &#124; Upper Paleolithic                 |        11|
|Inhumation single &#124; Middle Paleolithic |        10|
|NA &#124; Lower Paleolithic                 |        10|

## Top 10 features



|feature                         |   n| n_groups|        H| df|  p|      eps2| p_fdr|significant_fdr_05 |effect |
|:-------------------------------|---:|--------:|--------:|--:|--:|---------:|-----:|:------------------|:------|
|mnau_appendicular_mean          | 151|        8| 68.24433|  7|  0| 0.4549622|     0|TRUE               |large  |
|mnau_postcranial_total_mean     | 151|        8| 67.62673|  7|  0| 0.4508449|     0|TRUE               |large  |
|mnau_upper_appendicular_mean    | 151|        8| 66.08684|  7|  0| 0.4405789|     0|TRUE               |large  |
|mnau_proximal_appendicular_mean | 151|        8| 64.56056|  7|  0| 0.4304037|     0|TRUE               |large  |
|mnau_lower_appendicular_mean    | 151|        8| 63.88558|  7|  0| 0.4259039|     0|TRUE               |large  |
|mnau_limb_shaft_proxy_mean      | 151|        8| 63.72764|  7|  0| 0.4248509|     0|TRUE               |large  |
|mnau_legs                       | 151|        8| 62.03193|  7|  0| 0.4135462|     0|TRUE               |large  |
|low_density_survival_index      | 151|        8| 61.18354|  7|  0| 0.4078903|     0|TRUE               |large  |
|mnau_top2_share_mcnaughton      | 149|        8| 59.31692|  7|  0| 0.4007900|     0|TRUE               |large  |
|ProportionalRep_MNIbased_fibula | 151|        8| 59.20063|  7|  0| 0.3946708|     0|TRUE               |large  |

## PERMANOVA



|term                 |  df|     sumsq|        R2|         F|      p|note |
|:--------------------|---:|---------:|---------:|---------:|------:|:----|
|group                |   7| 1392.2577| 0.3093906| 10.974950| 0.0001|NA   |
|degree_of_excavation |   3|  122.2120| 0.0271582|  2.247882| 0.0525|NA   |
|discovery_context    |   6|  169.1312| 0.0375847|  1.555441| 0.1155|NA   |
|Residual             | 134| 2428.4201| 0.5396489|        NA|     NA|NA   |
|Total                | 150| 4500.0000| 1.0000000|        NA|     NA|NA   |
