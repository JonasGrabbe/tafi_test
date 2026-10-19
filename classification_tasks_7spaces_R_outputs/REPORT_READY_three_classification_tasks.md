# Three archaeological classification framings across seven feature spaces

This analysis uses the archaeological task labels directly as the grouping variable; it does not perform K-means or select k. Each task is analysed independently in the same seven feature representations. PCA is visualization only for spaces with more than two variables, while PERMANOVA uses the full standardized feature matrix. Ellipses are 90% group-specific concentration/data ellipses and describe within-class dispersion rather than uncertainty in class means.

## 4class

Sample: Cannibalism n=25; Carnivore n=17; Funerary Context n=49; Geological transport n=12.

| Feature space | Label silhouette | PERMANOVA R2 | PERMANOVA p | Dispersion p | In-sample nearest-centroid match |
|---|---:|---:|---:|---:|---:|
| C only | -0.014 | 0.506 | <=0.0002 | <=0.0002 | 60.2% |
| Heip evenness only | 0.054 | 0.617 | <=0.0002 | 0.0010 | 60.2% |
| C + Heip evenness | 0.059 | 0.561 | <=0.0002 | <=0.0002 | 65.0% |
| %MNAU raw | -0.068 | 0.287 | <=0.0002 | <=0.0002 | 64.1% |
| ReMNAU raw | 0.016 | 0.206 | <=0.0002 | 0.0124 | 74.8% |
| Engineered | 0.043 | 0.366 | <=0.0002 | 6e-04 | 71.8% |
| Combined | 0.018 | 0.295 | <=0.0002 | <=0.0002 | 74.8% |

## cannibalism_vs_fc

Sample: Cannibalism n=25; Funerary Context n=49.

| Feature space | Label silhouette | PERMANOVA R2 | PERMANOVA p | Dispersion p | In-sample nearest-centroid match |
|---|---:|---:|---:|---:|---:|
| C only | 0.250 | 0.305 | <=0.0002 | 0.0026 | 78.4% |
| Heip evenness only | 0.258 | 0.280 | <=0.0002 | 0.1710 | 77.0% |
| C + Heip evenness | 0.257 | 0.293 | <=0.0002 | 0.4566 | 82.4% |
| %MNAU raw | 0.130 | 0.165 | <=0.0002 | <=0.0002 | 78.4% |
| ReMNAU raw | 0.070 | 0.073 | <=0.0002 | 0.9434 | 81.1% |
| Engineered | 0.163 | 0.185 | <=0.0002 | 0.4606 | 83.8% |
| Combined | 0.124 | 0.145 | <=0.0002 | 0.1176 | 86.5% |

## fc_vs_rest

Sample: Funerary Context n=49; Rest n=54.

| Feature space | Label silhouette | PERMANOVA R2 | PERMANOVA p | Dispersion p | In-sample nearest-centroid match |
|---|---:|---:|---:|---:|---:|
| C only | 0.443 | 0.481 | <=0.0002 | <=0.0002 | 83.5% |
| Heip evenness only | 0.407 | 0.500 | <=0.0002 | 0.3694 | 80.6% |
| C + Heip evenness | 0.418 | 0.490 | <=0.0002 | 0.0228 | 85.4% |
| %MNAU raw | 0.306 | 0.272 | <=0.0002 | <=0.0002 | 85.4% |
| ReMNAU raw | 0.173 | 0.142 | <=0.0002 | 0.9156 | 86.4% |
| Engineered | 0.273 | 0.308 | <=0.0002 | 0.0302 | 86.4% |
| Combined | 0.237 | 0.247 | <=0.0002 | 0.0024 | 87.4% |

## Interpretation guardrails

- The task labels are predefined archaeological classes, so no cluster-label association test is appropriate here: the labels themselves define the plotted groups.
- Mean silhouette of the true task labels is descriptive evidence of geometric compactness/separation, not classifier accuracy.
- Nearest-centroid matches are in-sample descriptive geometry and are not cross-validated predictive performance.
- PERMANOVA tests differences in multivariate location; its interpretation should be considered alongside the dispersion test.
- 90% concentration ellipses describe within-class score dispersion and are not significance tests.
- Unknown and Sepulchral nearest-centroid labels are descriptive affinities, not probabilities or validated archaeological classifications.

