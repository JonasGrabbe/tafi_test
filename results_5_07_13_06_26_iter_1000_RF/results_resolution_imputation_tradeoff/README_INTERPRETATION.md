# Resolution / performance / imputation analysis

Result folders scanned: 3000
Usable runs extracted: 3000

## Interpretation rules

- `accuracy_mean` is the saved cross-validated mean for each tested level vector.
- If `n_hyperparameter_combos = 1`, the folder does not contain a hyperparameter landscape; it contains only one RF configuration.
- When RF hyperparameters vary among level-vector runs, the adjusted models include available mtry, trees, and min_n covariates.
- The 1,000 level vectors are unique representation configurations, not 1,000 independent archaeological datasets.
- Native-support and imputation-burden outputs are produced only when `native_resolution_by_site.csv` is available.
- The site-level imputation burden is a proxy. If the actual loader randomly reallocates individual skeletal counts, a count-level imputation audit is preferable.
- Pareto and candidate-vector outputs are descriptive tools for choosing representations to validate; they do not prove a universal optimal vector.
