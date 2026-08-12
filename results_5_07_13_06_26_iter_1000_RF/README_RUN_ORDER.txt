PURPOSE
=======
Rank approximately 1,000 skeletal levels separately for each classification task.
The design has one RandomForest model/configuration per level, so this is LEVEL
SELECTION. It is not hyperparameter ranking and not model-family comparison.

SUPPORTED FOLDER NAME
=====================
results_tuning_<task>_<representation>_<discretization>_<level>_<model>

Example:
results_tuning_4class_ProportionalRep_MNIbased_L3_1_1_3_1_1_2_3_1_2_2_RandomForest

Task names may contain underscores, such as:
  cannibalism_vs_fc
  fc_vs_rest

Folders beginning with results_tuning_summary_ are ignored. They can remain in
the project directory.

EXPECTED PROJECT STRUCTURE
==========================
results_5_07_13_06_26_iter_1000_RF/
  collect_scores_by_level.R
  run_level_selection.R
  run_level_selection.bat
  results_tuning_4class_..._RandomForest/
  results_tuning_4class_..._RandomForest/
  results_tuning_cannibalism_vs_fc_..._RandomForest/
  results_tuning_fc_vs_rest_..._RandomForest/
  results_tuning_summary_.../                    ignored

PREFERRED FILES INSIDE EACH MODEL-RESULT FOLDER
===============================================
1. summary_metrics_best_config.csv
   Used for:
     macro_f1_mean, macro_f1_sd, macro_f1_se
     accuracy_mean, accuracy_sd, accuracy_se
     balanced_accuracy and its SD/SE

   In the supplied files, the summary metric named "recall" is macro recall,
   which is balanced accuracy for multiclass and binary classification.

2. classification_report_best_config.csv
   Used for:
     weighted_f1_mean
     min_class_recall and worst_recall_class
     min_class_f1 and worst_f1_class
     class count and support

3. accuracy_summary_all_combos.csv
   Used only for documentation:
     config_id, mtry, trees, min_n

The Markdown classification report is used as a fallback.

RUN
===
From a command prompt opened in the project folder:

  Rscript run_level_selection.R

On Windows, double-click:

  run_level_selection.bat

PRIMARY OUTPUT
==============
accuracy_f1_RandomForest_by_level.csv

Its first columns are exactly:

task
level
cranium
teeth
hyoid
vertebrae
thorax
shoulder
arms
hands
pelvic
legs
foot
f1_mean

Then it adds:

representation
discretization
model
config_id
macro_f1_mean
macro_f1_sd
macro_f1_se
accuracy_mean
accuracy_sd
accuracy_se
balanced_accuracy
balanced_accuracy_sd
balanced_accuracy_se
weighted_f1_mean
weighted_f1_sd
macro_precision_mean
min_class_recall
worst_recall_class
min_class_f1
worst_f1_class
rank_within_task
is_best_level
macro_f1_delta_from_best
one_se_threshold
within_one_se_of_best
...plus audit/source fields.

IMPORTANT LEGACY COLUMN
=======================
The requested leading column f1_mean is retained for compatibility with the old
output. It equals accuracy_mean, because the old script extracted the report row
called "accuracy" and named that value f1_mean.

Do not use f1_mean for level selection. Use macro_f1_mean.

RANKING RULE WITHIN EACH TASK
=============================
1. Highest macro_f1_mean
2. Highest min_class_recall
3. Lowest macro_f1_sd
4. Highest balanced_accuracy
5. Highest accuracy_mean

The 4-class task and the two binary tasks are ranked separately. Their raw scores
are not used to rank one task against another.

ADDITIONAL OUTPUTS
==================
level_scores_all_tasks.csv
  Identical comprehensive table under a clearer generic filename.

best_level_per_task.csv
  One row per task: the rank-1 level.

top25_levels_per_task.csv
  The 25 highest-ranked levels in each task.

one_se_levels_per_task.csv
  All levels whose macro-F1 is no more than one standard error below the best
  level in the same task.

level_selection_warnings.csv
  Missing/unreadable files, malformed level labels, or absent macro-F1 values.

VALIDATION NOTE
===============
These cross-validation results are suitable for selecting a level. A final
unbiased performance estimate still requires nested outer cross-validation or an
untouched final test set.
