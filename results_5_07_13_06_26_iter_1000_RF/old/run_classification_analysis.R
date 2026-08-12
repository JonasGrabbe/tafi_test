# Runs the two dependent classification-analysis scripts in the correct order.

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

cat("Project folder:", PROJECT_ROOT, "\n")
cat("1/2 Consolidating classification reports...\n")
source(file.path(PROJECT_ROOT, "consolidate_classification_reports.R"), chdir = TRUE)

cat("2/2 Creating Random Forest accuracy-by-level table...\n")
source(file.path(PROJECT_ROOT, "accuracy_by_level.R"), chdir = TRUE)

cat("Classification analysis finished.\n")
