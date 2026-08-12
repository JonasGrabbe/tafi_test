# =====================================================================
# consolidate_classification_reports.R
#
# Walks every  results_tuning_<task>_<rep>_<disc>_<level>_<model>  folder,
# reads the best-config classification report, and writes ONE long-format
# CSV with columns:
#   task, model, rep, discretization, level, class,
#   precision_mean, precision_sd, recall_mean, recall_sd,
#   f1_mean, f1_sd, support
#
# task   in {4class, cannibalism_vs_fc, fc_vs_rest}
# model  in {RandomForest, XGBoost}
# Summary folders (results_tuning_summary_*) are ignored automatically.
#
# Base R only -- no packages required.
# =====================================================================

# ---- PROJECT FOLDER ----------------------------------------------------
# All scripts, input result folders, and newly generated outputs are kept
# together. The project folder is the folder containing this script.
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
# -----------------------------------------------------------------------

# ---- CONFIG -----------------------------------------------------------
root_dir <- PROJECT_ROOT
out_csv  <- file.path(PROJECT_ROOT, "consolidated_classification_reports.csv")
# Source of the report. The .md holds the "mean (sd)" table you showed.
report_source <- "md"   # "md"  -> classification_report_best_<MODEL>.md
                        # "csv" -> classification_report_best_config.csv (raw passthrough)
# -----------------------------------------------------------------------

folder_re <- "^results_tuning_(.+)_([A-Za-z]+Rep)_([A-Za-z0-9]+based)_(L[0-9][0-9_]*)_(RandomForest|XGBoost)$"

dirs <- list.dirs(root_dir, full.names = TRUE, recursive = FALSE)
bn   <- basename(dirs)
keep <- grepl(folder_re, bn)
dirs <- dirs[keep]; bn <- bn[keep]

if (length(dirs) == 0)
  stop("No matching results_tuning_* folders found under: ", normalizePath(root_dir))

# ---- helpers ----------------------------------------------------------
split_row <- function(l) {
  x <- trimws(strsplit(l, "\\|", perl = TRUE)[[1]])
  if (length(x) && x[1] == "") x <- x[-1]   # drop cell before the leading pipe
  x
}

# "0.608 (0.101)" -> c(mean=0.608, sd=0.101);  "23.0" -> c(mean=23, sd=NA);  "" -> c(NA, NA)
parse_cell <- function(s) {
  if (is.na(s) || s == "") return(c(mean = NA_real_, sd = NA_real_))
  m <- regmatches(s, regexec("^([0-9.]+)\\s*\\(([0-9.]+)\\)$", s))[[1]]
  if (length(m) == 3) return(c(mean = as.numeric(m[2]), sd = as.numeric(m[3])))
  c(mean = suppressWarnings(as.numeric(s)), sd = NA_real_)
}

parse_md_report <- function(path) {
  lines <- readLines(path, warn = FALSE)
  tbl <- lines[grepl("^\\s*\\|", lines)]                       # markdown table rows
  tbl <- tbl[!grepl("^\\s*\\|[ :|-]+\\|\\s*$", tbl)]           # drop the ":---:" separator
  if (length(tbl) < 2) return(NULL)

  header <- split_row(tbl[1]); nc <- length(header)
  h <- tolower(header)
  ci    <- match("class",     h); pi <- match("precision", h)
  ri    <- match("recall",    h); fi <- match("f1",        h)
  si    <- match("support",   h)

  rows <- lapply(tbl[-1], function(l) { x <- split_row(l); length(x) <- nc; x })

  do.call(rbind, lapply(rows, function(cells) {
    p <- parse_cell(cells[pi]); r <- parse_cell(cells[ri]); f <- parse_cell(cells[fi])
    data.frame(
      class          = cells[ci],
      precision_mean = p["mean"], precision_sd = p["sd"],
      recall_mean    = r["mean"], recall_sd    = r["sd"],
      f1_mean        = f["mean"], f1_sd        = f["sd"],
      support        = parse_cell(cells[si])["mean"],
      stringsAsFactors = FALSE, row.names = NULL
    )
  }))
}

# ---- main loop --------------------------------------------------------
all <- list(); missing <- character(0)

for (i in seq_along(dirs)) {
  m     <- regmatches(bn[i], regexec(folder_re, bn[i]))[[1]]
  task  <- m[2]; rep <- m[3]; disc <- m[4]; level <- m[5]; model <- m[6]

  if (report_source == "md") {
    f <- file.path(dirs[i], paste0("classification_report_best_", model, ".md"))
    rep_df <- if (file.exists(f)) parse_md_report(f) else NULL
  } else {
    f <- file.path(dirs[i], "classification_report_best_config.csv")
    rep_df <- if (file.exists(f)) {
      d <- read.csv(f, check.names = FALSE, stringsAsFactors = FALSE)
      if (names(d)[1] %in% c("", "X", "...1")) names(d)[1] <- "class"
      d
    } else NULL
  }

  if (is.null(rep_df)) { missing <- c(missing, bn[i]); next }

  rep_df <- cbind(
    task = task, model = model, rep = rep, discretization = disc, level = level,
    rep_df, stringsAsFactors = FALSE
  )
  all[[length(all) + 1]] <- rep_df
}

# bind even if column sets differ slightly between tasks
all_cols <- unique(unlist(lapply(all, names)))
all <- lapply(all, function(d) { for (c in setdiff(all_cols, names(d))) d[[c]] <- NA; d[all_cols] })
out <- do.call(rbind, all)

write.csv(out, out_csv, row.names = FALSE, na = "")

cat(sprintf("Done. %d folders -> %d rows written to %s\n",
            length(all), nrow(out), normalizePath(out_csv)))
if (length(missing))
  cat(sprintf("WARNING: %d folder(s) had no report file and were skipped:\n  %s\n",
              length(missing), paste(missing, collapse = "\n  ")))
