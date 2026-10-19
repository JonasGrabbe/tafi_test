TWO-RUN UNSUPERVISED ANALYSIS

RUN A: run_A_reference_fit_projection
  The four known archaeological contexts alone determine preprocessing, k and K-means.
  Unknown/Unkown and Sepulchral Cave/Cuevas Sepulcrales are projected afterward.

RUN B: run_B_all_contexts_in_kmeans_fit
  Known + Unknown/Unkown + Sepulchral Cave/Cuevas Sepulcrales all determine preprocessing, k and K-means.
  Label-association tests remain restricted to known archaeological labels.

Historical/early named records are included in the fit in BOTH runs.
Sima de los Huesos PNAS excluded from Unknown analyses: TRUE
Plots use cluster colors and 90% group-specific concentration/data ellipses (or 1D concentration intervals).
Concentration regions describe within-cluster dispersion and covariance; they are not confidence regions for centroids.
Ellipse overlap/non-overlap is not used as a significance test; formal group inference is reported separately via permutation association tests and PERMANOVA with dispersion checks.
