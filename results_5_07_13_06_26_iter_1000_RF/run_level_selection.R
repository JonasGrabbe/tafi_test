# Runs the across-level collector from the folder containing this script.
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
source(file.path(PROJECT_ROOT, "collect_scores_by_level.R"), chdir = TRUE)
cat("Level-selection analysis finished.\n")
