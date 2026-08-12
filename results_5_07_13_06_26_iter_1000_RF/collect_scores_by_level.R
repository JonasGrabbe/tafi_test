# =====================================================================
# collect_scores_by_level.R
#
# PURPOSE
# -------
# Compare approximately 1,000 skeletal-level definitions separately for
# each classification task. There is one RandomForest model/configuration
# per level, so this script ranks LEVELS, not hyperparameter combinations
# or model families.
#
# Scanned folders:
#   results_tuning_<task>_<representation>_<discretization>_<level>_<model>
#
# Example:
#   results_tuning_4class_ProportionalRep_MNIbased_
#     L3_1_1_3_1_1_2_3_1_2_2_RandomForest
#
# Ignored folders:
#   results_tuning_summary_*
#
# Primary output:
#   accuracy_f1_RandomForest_by_level.csv
#
# The first 14 columns intentionally preserve the old output layout:
#   task, level, 11 skeletal parts, f1_mean
# IMPORTANT: f1_mean is retained only as a backward-compatible alias of
# accuracy_mean because the old script extracted the classification-report
# "accuracy" row and called it f1_mean. Use macro_f1_mean for model selection.
#
# Selection order within each task:
#   1. macro_f1_mean       descending
#   2. min_class_recall    descending
#   3. macro_f1_sd         ascending
#   4. balanced_accuracy   descending
#   5. accuracy_mean       descending
#
# Base R only.
# =====================================================================

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg))
    return(dirname(normalizePath(sub("^--file=", "", file_arg[1]))))

  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    ofile <- frames[[i]]$ofile
    if (!is.null(ofile)) return(dirname(normalizePath(ofile)))
  }
  normalizePath(getwd())
}

PROJECT_ROOT <- get_script_dir()
ROOT_DIR <- PROJECT_ROOT

LEVEL_PART_NAMES <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
  "arms", "hands", "pelvic", "legs", "foot"
)
EXPECTED_LEVEL_PARTS <- length(LEVEL_PART_NAMES)
TOP_N <- 25L

OUT_MAIN <- file.path(PROJECT_ROOT, "accuracy_f1_RandomForest_by_level.csv")
OUT_ALL <- file.path(PROJECT_ROOT, "level_scores_all_tasks.csv")
OUT_BEST <- file.path(PROJECT_ROOT, "best_level_per_task.csv")
OUT_TOP <- file.path(PROJECT_ROOT, sprintf("top%d_levels_per_task.csv", TOP_N))
OUT_ONE_SE <- file.path(PROJECT_ROOT, "one_se_levels_per_task.csv")
OUT_WARN <- file.path(PROJECT_ROOT, "level_selection_warnings.csv")

normalize_key <- function(x) {
  x <- tolower(trimws(as.character(x)))
  x <- gsub("[^a-z0-9]+", "_", x)
  gsub("^_+|_+$", "", x)
}

as_num <- function(x) suppressWarnings(as.numeric(as.character(x)))

first_finite <- function(x, fallback = NA_real_) {
  x <- as_num(x)
  x <- x[is.finite(x)]
  if (length(x)) x[1] else fallback
}

safe_read_csv <- function(path) {
  if (!file.exists(path)) return(NULL)
  tryCatch(
    read.csv(path, check.names = FALSE, stringsAsFactors = FALSE),
    error = function(e) NULL
  )
}

parse_mean_sd <- function(x) {
  if (!length(x) || is.na(x) || !nzchar(trimws(as.character(x))))
    return(c(mean = NA_real_, sd = NA_real_))

  s <- trimws(as.character(x))
  pattern <- paste0(
    "^([-+]?[0-9]*\\.?[0-9]+(?:[eE][-+]?[0-9]+)?)",
    "(?:\\s*\\(([-+]?[0-9]*\\.?[0-9]+(?:[eE][-+]?[0-9]+)?)\\))?$"
  )
  m <- regmatches(s, regexec(pattern, s, perl = TRUE))[[1]]
  if (!length(m)) return(c(mean = as_num(s), sd = NA_real_))

  c(
    mean = as_num(m[2]),
    sd = if (length(m) >= 3 && nzchar(m[3])) as_num(m[3]) else NA_real_
  )
}

# Task names may contain underscores. Representation ends in "Rep" and
# discretization ends in "based" under the current naming convention.
RESULT_DIR_RE <- paste0(
  "^results_tuning_(.*?)_([^_]+Rep)_([^_]+based)_",
  "(L[0-9]+(?:_[0-9]+)+)_([^_]+)$"
)

parse_result_dir <- function(path) {
  nm <- basename(path)
  if (startsWith(nm, "results_tuning_summary_")) return(NULL)

  m <- regmatches(nm, regexec(RESULT_DIR_RE, nm, perl = TRUE))[[1]]
  if (length(m) != 6) return(NULL)

  data.frame(
    results_dir = nm,
    task = m[2],
    representation = m[3],
    discretization = m[4],
    level = m[5],
    model = m[6],
    stringsAsFactors = FALSE
  )
}

split_level <- function(level) {
  values <- as_num(strsplit(sub("^L", "", level), "_", fixed = TRUE)[[1]])
  padded <- rep(NA_real_, EXPECTED_LEVEL_PARTS)
  n_copy <- min(length(values), EXPECTED_LEVEL_PARTS)
  if (n_copy > 0) padded[seq_len(n_copy)] <- values[seq_len(n_copy)]

  list(
    values = padded,
    n_parts = length(values),
    parse_ok = length(values) == EXPECTED_LEVEL_PARTS && all(is.finite(values))
  )
}

metric_from_summary <- function(summary_df, aliases) {
  blank <- list(mean = NA_real_, se = NA_real_, sd = NA_real_, n = NA_real_)
  if (is.null(summary_df) || !nrow(summary_df) || !(".metric" %in% names(summary_df)))
    return(blank)

  keys <- normalize_key(summary_df$.metric)
  hit <- which(keys %in% normalize_key(aliases))
  if (!length(hit)) return(blank)

  row <- summary_df[hit[1], , drop = FALSE]
  mean_value <- if ("mean" %in% names(row)) first_finite(row$mean) else NA_real_
  se_value <- if ("std_err" %in% names(row)) first_finite(row$std_err) else NA_real_
  sd_value <- if ("std_dev" %in% names(row)) first_finite(row$std_dev) else NA_real_
  n_value <- if ("n" %in% names(row)) first_finite(row$n) else NA_real_

  if (!is.finite(sd_value) && is.finite(se_value) && is.finite(n_value) && n_value > 0)
    sd_value <- se_value * sqrt(n_value)
  if (!is.finite(se_value) && is.finite(sd_value) && is.finite(n_value) && n_value > 0)
    se_value <- sd_value / sqrt(n_value)

  list(mean = mean_value, se = se_value, sd = sd_value, n = n_value)
}

parse_report_csv <- function(path) {
  d <- safe_read_csv(path)
  if (is.null(d) || !nrow(d)) return(NULL)

  names(d) <- normalize_key(names(d))
  if (!("class" %in% names(d))) names(d)[1] <- "class"
  required <- c("class", "precision", "recall", "f1", "support")
  if (length(setdiff(required, names(d)))) return(NULL)

  rows <- lapply(seq_len(nrow(d)), function(i) {
    p <- parse_mean_sd(d$precision[i])
    r <- parse_mean_sd(d$recall[i])
    f <- parse_mean_sd(d$f1[i])
    s <- parse_mean_sd(d$support[i])

    data.frame(
      class = as.character(d$class[i]),
      precision_mean = unname(p["mean"]),
      precision_sd = unname(p["sd"]),
      recall_mean = unname(r["mean"]),
      recall_sd = unname(r["sd"]),
      f1_mean = unname(f["mean"]),
      f1_sd = unname(f["sd"]),
      support = unname(s["mean"]),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

split_md_row <- function(line) {
  x <- trimws(strsplit(line, "\\|", perl = TRUE)[[1]])
  if (length(x) && identical(x[1], "")) x <- x[-1]
  if (length(x) && identical(x[length(x)], "")) x <- x[-length(x)]
  x
}

parse_report_md <- function(path) {
  if (!file.exists(path)) return(NULL)
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  table_lines <- lines[grepl("^\\s*\\|", lines)]
  table_lines <- table_lines[!grepl("^\\s*\\|[ :|-]+\\|\\s*$", table_lines)]
  if (length(table_lines) < 2) return(NULL)

  header <- normalize_key(split_md_row(table_lines[1]))
  positions <- match(c("class", "precision", "recall", "f1", "support"), header)
  if (any(is.na(positions))) return(NULL)

  rows <- lapply(table_lines[-1], function(line) {
    cells <- split_md_row(line)
    length(cells) <- length(header)
    p <- parse_mean_sd(cells[positions[2]])
    r <- parse_mean_sd(cells[positions[3]])
    f <- parse_mean_sd(cells[positions[4]])
    s <- parse_mean_sd(cells[positions[5]])

    data.frame(
      class = cells[positions[1]],
      precision_mean = unname(p["mean"]),
      precision_sd = unname(p["sd"]),
      recall_mean = unname(r["mean"]),
      recall_sd = unname(r["sd"]),
      f1_mean = unname(f["mean"]),
      f1_sd = unname(f["sd"]),
      support = unname(s["mean"]),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

read_classification_report <- function(result_dir, model) {
  csv_path <- file.path(result_dir, "classification_report_best_config.csv")
  report <- parse_report_csv(csv_path)
  if (!is.null(report)) return(list(data = report, source = basename(csv_path)))

  md_path <- file.path(result_dir, paste0("classification_report_best_", model, ".md"))
  report <- parse_report_md(md_path)
  if (!is.null(report)) return(list(data = report, source = basename(md_path)))

  list(data = NULL, source = NA_character_)
}

report_metric <- function(report, class_aliases, column) {
  if (is.null(report) || !nrow(report) || !(column %in% names(report)))
    return(NA_real_)

  hit <- which(normalize_key(report$class) %in% normalize_key(class_aliases))
  if (!length(hit)) return(NA_real_)
  first_finite(report[[column]][hit])
}

minimum_class_metric <- function(report, column) {
  blank <- list(value = NA_real_, class = NA_character_)
  if (is.null(report) || !nrow(report) || !(column %in% names(report)))
    return(blank)

  summary_rows <- c(
    "accuracy", "macro_avg", "macro_average", "weighted_avg",
    "weighted_average", "micro_avg", "samples_avg"
  )
  keep <- !(normalize_key(report$class) %in% summary_rows)
  values <- as_num(report[[column]][keep])
  classes <- as.character(report$class[keep])
  valid <- which(is.finite(values))
  if (!length(valid)) return(blank)

  j <- valid[which.min(values[valid])]
  list(value = values[j], class = classes[j])
}

read_config_and_parameters <- function(result_dir, model) {
  candidates <- c(
    file.path(result_dir, "accuracy_summary_all_combos.csv"),
    file.path(result_dir, "f_meas_summary_all_combos.csv"),
    file.path(result_dir, "macro_f1_summary_all_combos.csv"),
    file.path(result_dir, paste0("tuning_results_", model, ".csv"))
  )
  candidates <- candidates[file.exists(candidates)]

  blank <- list(
    source = NA_character_, config_id = NA_character_,
    mtry = NA_real_, trees = NA_real_, min_n = NA_real_,
    parameters = NA_character_
  )
  if (!length(candidates)) return(blank)

  d <- safe_read_csv(candidates[1])
  if (is.null(d) || !nrow(d)) return(blank)

  # There is one configuration per run in the user's design. If more than one
  # row is ever present, use rank=1 when available, otherwise the first row.
  rank_columns <- intersect(
    c("rank", "rank_by_accuracy", "rank_by_f_meas", "rank_by_macro_f1"),
    names(d)
  )
  if (length(rank_columns)) {
    ord <- order(as_num(d[[rank_columns[1]]]), na.last = TRUE)
    row <- d[ord[1], , drop = FALSE]
  } else {
    row <- d[1, , drop = FALSE]
  }

  metadata <- c(
    "rank", "rank_by_accuracy", "rank_by_f_meas", "rank_by_macro_f1",
    ".metric", ".estimator", "mean", "n", "std_err", "std_dev", ".config"
  )
  parameter_columns <- setdiff(names(row), metadata)
  parameter_text <- NA_character_
  if (length(parameter_columns)) {
    parameter_values <- vapply(
      parameter_columns,
      function(nm) as.character(row[[nm]][1]),
      character(1)
    )
    parameter_text <- paste(
      paste0(parameter_columns, "=", parameter_values),
      collapse = "; "
    )
  }

  list(
    source = basename(candidates[1]),
    config_id = if (".config" %in% names(row)) as.character(row$.config[1]) else NA_character_,
    mtry = if ("mtry" %in% names(row)) first_finite(row$mtry) else NA_real_,
    trees = if ("trees" %in% names(row)) first_finite(row$trees) else NA_real_,
    min_n = if ("min_n" %in% names(row)) first_finite(row$min_n) else NA_real_,
    parameters = parameter_text
  )
}

make_warning <- function(meta, code, message) {
  data.frame(
    results_dir = meta$results_dir,
    task = meta$task,
    level = meta$level,
    warning_code = code,
    message = message,
    stringsAsFactors = FALSE
  )
}

all_dirs <- list.dirs(ROOT_DIR, full.names = TRUE, recursive = FALSE)
parsed <- lapply(all_dirs, parse_result_dir)
parsed <- parsed[!vapply(parsed, is.null, logical(1))]

if (!length(parsed)) {
  stop(
    "No result folders matched the expected convention under: ",
    normalizePath(ROOT_DIR),
    "\nExpected: results_tuning_<task>_<*Rep>_<*based>_<L...>_<model>"
  )
}

rows <- list()
warnings <- list()

for (i in seq_along(parsed)) {
  meta <- parsed[[i]]
  result_dir <- file.path(ROOT_DIR, meta$results_dir)

  summary_path <- file.path(result_dir, "summary_metrics_best_config.csv")
  summary_df <- safe_read_csv(summary_path)

  accuracy <- metric_from_summary(summary_df, c("accuracy"))
  balanced <- metric_from_summary(
    summary_df,
    c("recall", "macro_recall", "balanced_accuracy", "bal_accuracy")
  )
  macro_precision <- metric_from_summary(
    summary_df,
    c("precision", "macro_precision")
  )
  macro_f1 <- metric_from_summary(
    summary_df,
    c("f_meas", "f1", "macro_f1", "f_meas_macro")
  )

  report_info <- read_classification_report(result_dir, meta$model)
  report <- report_info$data

  # Classification-report fallbacks when the dedicated summary is absent.
  if (!is.finite(accuracy$mean))
    accuracy$mean <- report_metric(report, "accuracy", "f1_mean")
  if (!is.finite(accuracy$sd))
    accuracy$sd <- report_metric(report, "accuracy", "f1_sd")

  if (!is.finite(balanced$mean))
    balanced$mean <- report_metric(report, c("macro_avg", "macro_average"), "recall_mean")
  if (!is.finite(balanced$sd))
    balanced$sd <- report_metric(report, c("macro_avg", "macro_average"), "recall_sd")

  if (!is.finite(macro_precision$mean))
    macro_precision$mean <- report_metric(report, c("macro_avg", "macro_average"), "precision_mean")
  if (!is.finite(macro_precision$sd))
    macro_precision$sd <- report_metric(report, c("macro_avg", "macro_average"), "precision_sd")

  if (!is.finite(macro_f1$mean))
    macro_f1$mean <- report_metric(report, c("macro_avg", "macro_average"), "f1_mean")
  if (!is.finite(macro_f1$sd))
    macro_f1$sd <- report_metric(report, c("macro_avg", "macro_average"), "f1_sd")

  weighted_f1_mean <- report_metric(
    report,
    c("weighted_avg", "weighted_average"),
    "f1_mean"
  )
  weighted_f1_sd <- report_metric(
    report,
    c("weighted_avg", "weighted_average"),
    "f1_sd"
  )

  min_recall <- minimum_class_metric(report, "recall_mean")
  min_f1 <- minimum_class_metric(report, "f1_mean")

  summary_rows <- c(
    "accuracy", "macro_avg", "macro_average", "weighted_avg",
    "weighted_average", "micro_avg", "samples_avg"
  )
  if (!is.null(report)) {
    class_rows <- !(normalize_key(report$class) %in% summary_rows)
    n_classes <- length(unique(normalize_key(report$class[class_rows])))
    support_total <- report_metric(report, "accuracy", "support")
    if (!is.finite(support_total)) {
      supports <- as_num(report$support[class_rows])
      supports <- supports[is.finite(supports)]
      support_total <- if (length(supports)) sum(supports) else NA_real_
    }
  } else {
    n_classes <- NA_integer_
    support_total <- NA_real_
  }

  chance_balanced_accuracy <- if (is.finite(n_classes) && n_classes > 0)
    1 / n_classes else NA_real_
  adjusted_balanced_accuracy <- if (
    is.finite(balanced$mean) &&
    is.finite(chance_balanced_accuracy) &&
    chance_balanced_accuracy < 1
  ) {
    (balanced$mean - chance_balanced_accuracy) /
      (1 - chance_balanced_accuracy)
  } else {
    NA_real_
  }

  config <- read_config_and_parameters(result_dir, meta$model)
  level_info <- split_level(meta$level)
  level_columns <- as.data.frame(
    as.list(setNames(level_info$values, LEVEL_PART_NAMES)),
    stringsAsFactors = FALSE
  )

  # First 14 columns are fixed later. f1_mean is deliberately the legacy
  # accuracy alias requested by the user; macro_f1_mean is the ranking metric.
  row <- cbind(
    data.frame(
      task = meta$task,
      level = meta$level,
      stringsAsFactors = FALSE
    ),
    level_columns,
    data.frame(
      f1_mean = accuracy$mean,
      representation = meta$representation,
      discretization = meta$discretization,
      model = meta$model,
      config_id = config$config_id,
      macro_f1_mean = macro_f1$mean,
      macro_f1_sd = macro_f1$sd,
      macro_f1_se = macro_f1$se,
      accuracy_mean = accuracy$mean,
      accuracy_sd = accuracy$sd,
      accuracy_se = accuracy$se,
      balanced_accuracy = balanced$mean,
      balanced_accuracy_sd = balanced$sd,
      balanced_accuracy_se = balanced$se,
      weighted_f1_mean = weighted_f1_mean,
      weighted_f1_sd = weighted_f1_sd,
      macro_precision_mean = macro_precision$mean,
      min_class_recall = min_recall$value,
      worst_recall_class = min_recall$class,
      min_class_f1 = min_f1$value,
      worst_f1_class = min_f1$class,
      n_classes = n_classes,
      cv_n = first_finite(c(macro_f1$n, accuracy$n, balanced$n)),
      support_total = support_total,
      chance_balanced_accuracy = chance_balanced_accuracy,
      adjusted_balanced_accuracy = adjusted_balanced_accuracy,
      mtry = config$mtry,
      trees = config$trees,
      min_n = config$min_n,
      model_parameters = config$parameters,
      level_n_parts = level_info$n_parts,
      level_parse_ok = level_info$parse_ok,
      results_dir = meta$results_dir,
      overall_metrics_source = if (!is.null(summary_df)) basename(summary_path) else report_info$source,
      per_class_metrics_source = report_info$source,
      config_source = config$source,
      stringsAsFactors = FALSE
    )
  )

  rows[[length(rows) + 1]] <- row

  if (is.null(summary_df)) {
    warnings[[length(warnings) + 1]] <- make_warning(
      meta,
      "missing_summary_metrics",
      "summary_metrics_best_config.csv was missing or unreadable; summary-row fallbacks were used where possible."
    )
  }
  if (is.null(report)) {
    warnings[[length(warnings) + 1]] <- make_warning(
      meta,
      "missing_classification_report",
      "No readable classification report was found; per-class diagnostics are blank."
    )
  }
  if (!isTRUE(level_info$parse_ok)) {
    warnings[[length(warnings) + 1]] <- make_warning(
      meta,
      "unexpected_level_format",
      sprintf(
        "Level contains %d numeric components; expected %d.",
        level_info$n_parts,
        EXPECTED_LEVEL_PARTS
      )
    )
  }
  if (!is.finite(macro_f1$mean)) {
    warnings[[length(warnings) + 1]] <- make_warning(
      meta,
      "missing_macro_f1",
      "No finite macro-F1 value could be extracted; this row cannot receive a task rank."
    )
  }
}

out <- do.call(rbind, rows)
rownames(out) <- NULL

# Rank levels independently inside each task.
out$rank_within_task <- NA_integer_
out$is_best_level <- FALSE
out$macro_f1_delta_from_best <- NA_real_
out$one_se_threshold <- NA_real_
out$within_one_se_of_best <- NA

tasks <- unique(out$task)
for (task_name in tasks) {
  indices <- which(out$task == task_name)
  valid <- indices[is.finite(out$macro_f1_mean[indices])]
  if (!length(valid)) next

  min_recall_key <- out$min_class_recall[valid]
  min_recall_key[!is.finite(min_recall_key)] <- -Inf

  macro_sd_key <- out$macro_f1_sd[valid]
  macro_sd_key[!is.finite(macro_sd_key)] <- Inf

  balanced_key <- out$balanced_accuracy[valid]
  balanced_key[!is.finite(balanced_key)] <- -Inf

  accuracy_key <- out$accuracy_mean[valid]
  accuracy_key[!is.finite(accuracy_key)] <- -Inf

  ranked <- valid[order(
    -out$macro_f1_mean[valid],
    -min_recall_key,
    macro_sd_key,
    -balanced_key,
    -accuracy_key,
    out$level[valid],
    na.last = TRUE
  )]

  out$rank_within_task[ranked] <- seq_along(ranked)
  out$is_best_level[ranked[1]] <- TRUE

  best_mean <- out$macro_f1_mean[ranked[1]]
  out$macro_f1_delta_from_best[indices] <- best_mean - out$macro_f1_mean[indices]

  best_se <- out$macro_f1_se[ranked[1]]
  if (is.finite(best_se)) {
    threshold <- best_mean - best_se
    out$one_se_threshold[indices] <- threshold
    out$within_one_se_of_best[indices] <-
      is.finite(out$macro_f1_mean[indices]) &
      out$macro_f1_mean[indices] >= threshold
  }
}

# Exact requested leading column order.
leading_columns <- c(
  "task", "level",
  "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
  "arms", "hands", "pelvic", "legs", "foot",
  "f1_mean"
)

chosen_columns <- c(
  "representation", "discretization", "model", "config_id",
  "macro_f1_mean", "macro_f1_sd", "macro_f1_se",
  "accuracy_mean", "accuracy_sd", "accuracy_se",
  "balanced_accuracy", "balanced_accuracy_sd", "balanced_accuracy_se",
  "weighted_f1_mean", "weighted_f1_sd",
  "macro_precision_mean",
  "min_class_recall", "worst_recall_class",
  "min_class_f1", "worst_f1_class",
  "rank_within_task", "is_best_level",
  "macro_f1_delta_from_best",
  "one_se_threshold", "within_one_se_of_best"
)

out <- out[c(
  leading_columns,
  chosen_columns,
  setdiff(names(out), c(leading_columns, chosen_columns))
)]

# Best levels first inside each task.
out <- out[order(
  out$task,
  out$rank_within_task,
  out$level,
  na.last = TRUE
), , drop = FALSE]
rownames(out) <- NULL

# Main and generic all-task output contain the same comprehensive table.
write.csv(out, OUT_MAIN, row.names = FALSE, na = "")
write.csv(out, OUT_ALL, row.names = FALSE, na = "")

best <- out[out$is_best_level, , drop = FALSE]
write.csv(best, OUT_BEST, row.names = FALSE, na = "")

top <- out[!is.na(out$rank_within_task) & out$rank_within_task <= TOP_N, , drop = FALSE]
write.csv(top, OUT_TOP, row.names = FALSE, na = "")

one_se <- out[!is.na(out$within_one_se_of_best) & out$within_one_se_of_best, , drop = FALSE]
write.csv(one_se, OUT_ONE_SE, row.names = FALSE, na = "")

if (length(warnings)) {
  warning_table <- do.call(rbind, warnings)
} else {
  warning_table <- data.frame(
    results_dir = character(),
    task = character(),
    level = character(),
    warning_code = character(),
    message = character(),
    stringsAsFactors = FALSE
  )
}
write.csv(warning_table, OUT_WARN, row.names = FALSE, na = "")

cat(sprintf("Scanned %d model-result folders across %d task(s).\n", nrow(out), length(unique(out$task))))
cat("Primary by-level output:\n  ", normalizePath(OUT_MAIN), "\n", sep = "")
cat("Best level per task:\n  ", normalizePath(OUT_BEST), "\n", sep = "")
cat(sprintf("Top %d levels per task:\n  %s\n", TOP_N, normalizePath(OUT_TOP)))
cat("One-standard-error candidates:\n  ", normalizePath(OUT_ONE_SE), "\n", sep = "")
cat(sprintf("Warnings: %d -> %s\n", nrow(warning_table), normalizePath(OUT_WARN)))
