# =====================================================================
# build_level_accuracy_master.R
#
# POST-TRAINING utility.
# Scans all completed results_tuning_summary_* folders beneath the folder
# containing this script, reads each best_models_summary.csv, and rebuilds:
#
#   level_accuracy_master.csv
#
# Expected summary-folder format:
#   results_tuning_summary_<task>_<variant>_L<pos1>_<pos2>_..._<pos11>
# =====================================================================

# ---- project folder ---------------------------------------------------
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
OUT_CSV <- file.path(PROJECT_ROOT, "level_accuracy_master.csv")

# Must contain every task name used during training.
# Longest names are checked first to avoid ambiguous matches.
TASK_NAMES <- c("cannibalism_vs_fc", "fc_vs_rest", "4class")
EXPECTED_POSITIONS <- 11L

# ---- parse one summary-folder name -----------------------------------
parse_summary_folder <- function(path) {
  folder <- basename(path)
  prefix <- "results_tuning_summary_"
  body <- sub(paste0("^", prefix), "", folder)

  m <- regmatches(body, regexec("^(.*)_L([0-9]+(?:_[0-9]+)*)$", body, perl = TRUE))[[1]]
  if (length(m) != 3L) return(NULL)

  task_variant <- m[2]
  level_str <- m[3]

  tasks <- TASK_NAMES[order(nchar(TASK_NAMES), decreasing = TRUE)]
  task <- tasks[vapply(tasks, function(x) startsWith(task_variant, paste0(x, "_")), logical(1))]
  if (!length(task)) return(NULL)
  task <- task[1]

  variant <- substring(task_variant, nchar(task) + 2L)
  level <- suppressWarnings(as.integer(strsplit(level_str, "_", fixed = TRUE)[[1]]))

  if (!nzchar(variant) || anyNA(level) || length(level) != EXPECTED_POSITIONS)
    return(NULL)

  list(task = task, variant = variant, level_str = level_str, level = level)
}

# ---- locate and read completed summaries -----------------------------
all_dirs <- list.dirs(PROJECT_ROOT, recursive = TRUE, full.names = TRUE)
summary_dirs <- all_dirs[grepl(
  "^results_tuning_summary_.*_L[0-9]+(?:_[0-9]+)*$",
  basename(all_dirs),
  perl = TRUE
)]

if (!length(summary_dirs)) {
  stop("No results_tuning_summary_* folders found under: ", PROJECT_ROOT)
}

blocks <- list()
skipped <- character()

for (dir in summary_dirs) {
  meta <- parse_summary_folder(dir)
  summary_csv <- file.path(dir, "best_models_summary.csv")

  if (is.null(meta) || !file.exists(summary_csv)) {
    skipped <- c(skipped, dir)
    next
  }

  d <- tryCatch(
    read.csv(summary_csv, check.names = FALSE, stringsAsFactors = FALSE),
    error = function(e) NULL
  )

  if (is.null(d) || !all(c("model", "best_score") %in% names(d))) {
    skipped <- c(skipped, dir)
    next
  }

  best_accuracy <- suppressWarnings(as.numeric(d$best_score))
  keep <- !is.na(d$model) & nzchar(as.character(d$model)) & is.finite(best_accuracy)
  if (!any(keep)) {
    skipped <- c(skipped, dir)
    next
  }

  block <- data.frame(
    task = meta$task,
    variant = meta$variant,
    level_str = meta$level_str,
    model = as.character(d$model[keep]),
    best_accuracy = best_accuracy[keep],
    stringsAsFactors = FALSE
  )

  for (i in seq_len(EXPECTED_POSITIONS)) {
    block[[paste0("pos", i)]] <- meta$level[i]
  }
  block$sum_level <- sum(meta$level)
  blocks[[length(blocks) + 1L]] <- block
}

if (!length(blocks)) {
  stop("Summary folders were found, but none contained a usable best_models_summary.csv.")
}

out <- do.call(rbind, blocks)

# Keep one best row per task/variant/level/model if duplicate summaries exist.
key <- paste(out$task, out$variant, out$level_str, out$model, sep = "\r")
out <- out[order(key, -out$best_accuracy), , drop = FALSE]
out <- out[!duplicated(key[order(key, -out$best_accuracy)]), , drop = FALSE]

# Stable output order.
out <- out[order(out$task, out$variant, out$model, out$level_str), , drop = FALSE]
rownames(out) <- NULL

write.csv(out, OUT_CSV, row.names = FALSE, na = "")

cat(sprintf(
  "Done. %d summary folders -> %d rows written to:\n%s\n",
  length(blocks), nrow(out), normalizePath(OUT_CSV)
))

if (length(skipped)) {
  cat(sprintf(
    "WARNING: %d folder(s) were skipped because the folder name or summary CSV was invalid.\n",
    length(skipped)
  ))
}
