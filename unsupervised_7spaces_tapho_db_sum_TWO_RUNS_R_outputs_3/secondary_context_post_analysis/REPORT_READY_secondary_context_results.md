# Secondary-context interpretation of abundance–Heip clusters

This post-analysis interprets the existing unsupervised K-means solution for `C + Heip evenness`. K-means was not refit and archaeological labels were not used to construct the clusters.

For detailed archaeological interpretation, funerary records were assigned their normalized `funerary_context`; non-funerary records were assigned the collapsed broad process (`Cannibalism`, `Carnivore-related`, or `Geological transport`). Missing funerary subtype values, if present, were assigned the fallback `Funerary Context`. Unknown and Sepulchral records were excluded from formal label-association inference and are reported separately as cluster placements.

Permutation tests used 19,999 shuffles. This gives a minimum attainable add-one permutation p-value of 0.00005.

## Run A: known-reference fit

The detailed secondary-context table contained **13 labels across 2 clusters** (`n = 103`). Because **61.5%** of expected contingency cells were below 5, inference was based on label permutation rather than the ordinary asymptotic chi-square p-value.

Detailed secondary context was associated with cluster membership: **χ² = 62.13**, permutation **p = 0.00005 (minimum attainable)**, Cramér's **V = 0.777**, bias-corrected **V = 0.700**, and **NMI = 0.327**.

For comparison, the broad funerary/non-funerary association had bias-corrected **V = 0.705** (permutation p = 0.00005 (minimum attainable)).

A stratified permutation that shuffled detailed labels only within the broad funerary/non-funerary classes gave **p = 0.080**. This asks whether the fine archaeological labels contribute cluster organization beyond the already-known binary division.

Within funerary records alone, the subtype permutation p-value was **0.250**; within non-funerary records alone, the process-level permutation p-value was **0.027**.

### Cluster composition

| Cluster | n total | n known | Median C | Median Heip | Funerary % | Dominant broad context | Dominant secondary context | FDR-significant context signals |
|---|---:|---:|---:|---:|---:|---|---|---|
| C1 | 57 | 57 | 0.037 | 0.070 | 15.8 | Cannibalism | Cannibalism | Single inhumation [Depleted] (OR=0.07, q=0.0000); Carnivore-related [Enriched] (OR=Inf, q=0.0001); Geological transport [Enriched] (OR=Inf, q=0.0021) |
| C2 | 46 | 46 | 0.309 | 0.689 | 87.0 | Funerary | Single inhumation | Single inhumation [Enriched] (OR=14.70, q=0.0000); Carnivore-related [Depleted] (OR=0.00, q=0.0001); Geological transport [Depleted] (OR=0.00, q=0.0021) |

### FDR-controlled cellwise enrichments and depletions

| Cluster | Secondary context | Direction | Count | Context in cluster % | Context assigned here % | Odds ratio | q (BH) |
|---|---|---|---:|---:|---:|---:|---:|
| C1 | Single inhumation | Depleted | 3 | 5.3 | 12.5 | 0.07 | 0.0000 |
| C1 | Carnivore-related | Enriched | 17 | 29.8 | 100.0 | Inf | 0.0001 |
| C1 | Geological transport | Enriched | 12 | 21.1 | 100.0 | Inf | 0.0021 |
| C2 | Single inhumation | Enriched | 21 | 45.7 | 87.5 | 14.70 | 0.0000 |
| C2 | Carnivore-related | Depleted | 0 | 0.0 | 0.0 | 0.00 | 0.0001 |
| C2 | Geological transport | Depleted | 0 | 0.0 | 0.0 | 0.00 | 0.0021 |

## Run B: all contexts in fit

The detailed secondary-context table contained **13 labels across 2 clusters** (`n = 103`). Because **61.5%** of expected contingency cells were below 5, inference was based on label permutation rather than the ordinary asymptotic chi-square p-value.

Detailed secondary context was associated with cluster membership: **χ² = 63.66**, permutation **p = 0.00005 (minimum attainable)**, Cramér's **V = 0.786**, bias-corrected **V = 0.711**, and **NMI = 0.338**.

For comparison, the broad funerary/non-funerary association had bias-corrected **V = 0.704** (permutation p = 0.00005 (minimum attainable)).

A stratified permutation that shuffled detailed labels only within the broad funerary/non-funerary classes gave **p = 0.025**. This asks whether the fine archaeological labels contribute cluster organization beyond the already-known binary division.

Within funerary records alone, the subtype permutation p-value was **0.138**; within non-funerary records alone, the process-level permutation p-value was **0.009**.

### Cluster composition

| Cluster | n total | n known | Median C | Median Heip | Funerary % | Dominant broad context | Dominant secondary context | FDR-significant context signals |
|---|---:|---:|---:|---:|---:|---|---|---|
| C1 | 93 | 55 | 0.037 | 0.095 | 14.5 | Cannibalism | Cannibalism | Single inhumation [Depleted] (OR=0.05, q=0.0000); Carnivore-related [Enriched] (OR=Inf, q=0.0000); Geological transport [Enriched] (OR=Inf, q=0.0014) |
| C2 | 57 | 48 | 0.288 | 0.660 | 85.4 | Funerary | Single inhumation | Single inhumation [Enriched] (OR=21.76, q=0.0000); Carnivore-related [Depleted] (OR=0.00, q=0.0000); Geological transport [Depleted] (OR=0.00, q=0.0014) |

### FDR-controlled cellwise enrichments and depletions

| Cluster | Secondary context | Direction | Count | Context in cluster % | Context assigned here % | Odds ratio | q (BH) |
|---|---|---|---:|---:|---:|---:|---:|
| C1 | Single inhumation | Depleted | 2 | 3.6 | 8.3 | 0.05 | 0.0000 |
| C1 | Carnivore-related | Enriched | 17 | 30.9 | 100.0 | Inf | 0.0000 |
| C1 | Geological transport | Enriched | 12 | 21.8 | 100.0 | Inf | 0.0014 |
| C2 | Single inhumation | Enriched | 22 | 45.8 | 91.7 | 21.76 | 0.0000 |
| C2 | Carnivore-related | Depleted | 0 | 0.0 | 0.0 | 0.00 | 0.0000 |
| C2 | Geological transport | Depleted | 0 | 0.0 | 0.0 | 0.00 | 0.0014 |

## Interpretation guardrails

The cellwise Fisher tests are exploratory localizations of a sparse global association and are therefore reported with BH/FDR correction. Rare funerary subtypes can still generate unstable odds ratios and should be interpreted with their raw counts.

Unknown and Sepulchral cluster placements are not probabilities of funerary behavior. The reported funerary percentage is the proportion of **known archaeological reference labels** occupying the cluster to which the special record was assigned.

The concentration ellipses in the preceding clustering analysis describe within-cluster dispersion in the displayed 2D/PCA space and are not inferential tests of archaeological-group separation. Formal inference is supplied by the permutation and enrichment analyses reported here.

## Output files

- `cluster_binary_funerary_nonfunerary_percent.csv`: what percentage of each cluster is F vs NF.
- `cluster_broad_context_percent.csv`: what percentage of each cluster is Funerary, Cannibalism, Carnivore-related, or Geological transport.
- `cluster_secondary_context_percent.csv`: detailed funerary-subtype/process composition of every cluster.
- `secondary_context_distribution_across_clusters.csv`: where each context falls across clusters.
- `cellwise_cluster_secondary_context_fisher_FDR.csv`: cluster × context enrichment/depletion tests with BH/FDR.
- `site_level_secondary_context_and_clusters.csv`: every fitted/projected record, cluster, archaeological labels and assigned-cluster composition.
- `Unknown_Sepulchral_site_cluster_mapping.csv`: feature-space-specific special-site placements.
- `historical_early_named_site_cluster_mapping.csv`: feature-space-specific locations of named historical/early records.

