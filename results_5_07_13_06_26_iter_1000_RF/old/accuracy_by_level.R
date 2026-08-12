# =====================================================================
# accuracy_by_level.R
#
# From consolidated_classification_reports.csv, keep rows where
#   class == "accuracy"  AND  model == "RandomForest",
# keep  task, level, f1_mean,  and split the level code into 11 parts.
#
#   "L1_1_1_1_2_1_3_4_3_2_2"  ->
#     cranium=1, teeth=1, hyoid=1, vertebrae=1, thorax=2, shoulder=1,
#     arms=3, hands=4, pelvic=3, legs=2, foot=2
#   (the leading "L" is stripped from the first token)
#
# Base R only.
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
in_csv  <- file.path(PROJECT_ROOT, "consolidated_classification_reports.csv")
out_csv <- file.path(PROJECT_ROOT, "accuracy_f1_RandomForest_by_level.csv")
# -----------------------------------------------------------------------

parts_cols <- c("cranium", "teeth", "hyoid", "vertebrae", "thorax",
                "shoulder", "arms", "hands", "pelvic", "legs", "foot")

d <- read.csv(in_csv, check.names = FALSE, stringsAsFactors = FALSE)

# filter
sel <- d[d$class == "accuracy" & d$model == "RandomForest", c("task", "level", "f1_mean")]

# split level -> 11 numeric columns
split_level <- function(level) {
  v <- as.integer(strsplit(sub("^L", "", level), "_", fixed = TRUE)[[1]])
  if (length(v) != length(parts_cols))
    stop(sprintf("Level '%s' has %d values, expected %d.", level, length(v), length(parts_cols)))
  v
}
mat <- t(vapply(sel$level, split_level, integer(length(parts_cols))))
colnames(mat) <- parts_cols

out <- cbind(
  sel[, c("task", "level")],
  as.data.frame(mat, stringsAsFactors = FALSE),
  f1_mean = sel$f1_mean
)
rownames(out) <- NULL

write.csv(out, out_csv, row.names = FALSE, na = "")
cat(sprintf("Done. %d rows -> %s\n", nrow(out), normalizePath(out_csv)))
