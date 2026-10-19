TWO-RUN UNSUPERVISED ANALYSIS

RUN A: run_A_reference_fit_projection
  The four known archaeological contexts alone determine preprocessing, k and K-means.
  Unknown/Unkown and Sepulchral Cave/Cuevas Sepulcrales are projected afterward.

RUN B: run_B_all_contexts_in_kmeans_fit
  Known + Unknown/Unkown + Sepulchral Cave/Cuevas Sepulcrales all determine preprocessing, k and K-means.
  Label-association tests remain restricted to known archaeological labels.

Historical/early named records are included in the fit in BOTH runs.
Before either run, exact bilateral *_indet features are redistributed as evenly as possible to matching left/right features.
For %MNAU, redistribution cannot push a side above 1.0; any unassignable remainder stays in *_indet and is audited.
For ReMNAU, the indeterminate value is split 50:50 without an artificial 1.0 cap.
Paired redistributed *_indet columns are then excluded from clustering to avoid double-counting.
Precomputed C, Heip evenness and engineered variables are retained as supplied and are not recomputed after redistribution.
Sima de los Huesos PNAS excluded from Unknown analyses: TRUE
Plots use cluster colors and 90% group-specific concentration/data ellipses (or 1D concentration intervals).
Concentration regions describe within-cluster dispersion and covariance; they are not confidence regions for centroids.
Ellipse overlap/non-overlap is not used as a significance test; formal group inference is reported separately via permutation association tests and PERMANOVA with dispersion checks.
