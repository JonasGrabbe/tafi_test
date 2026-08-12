# =====================================================================
# plot_section_level_vs_accuracy.R
#
# Reads accuracy_f1_RandomForest_by_level.csv from this script's folder.
# Prints each plot in an interactive R session, then saves 11 PNG files to:
#   results_f1_level_plots/
# =====================================================================

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg[1]),
                                  winslash = "/", mustWork = TRUE)))
  }

  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    ofile <- frames[[i]]$ofile
    if (!is.null(ofile) && nzchar(ofile)) {
      return(dirname(normalizePath(ofile, winslash = "/", mustWork = TRUE)))
    }
  }

  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

PROJECT_ROOT <- get_script_dir()
INPUT_CSV    <- file.path(PROJECT_ROOT, "accuracy_f1_RandomForest_by_level.csv")
OUTPUT_DIR   <- file.path(PROJECT_ROOT, "results_f1_level_plots")

dir.create(OUTPUT_DIR, showWarnings = FALSE, recursive = TRUE)
if (!dir.exists(OUTPUT_DIR)) stop("Could not create output folder: ", OUTPUT_DIR)

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
})

PART_COLS <- c("cranium", "teeth", "hyoid", "vertebrae", "thorax",
               "shoulder", "arms", "hands", "pelvic", "legs", "foot")
PART_LABELS <- c("Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
                 "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot")

make_section_plots <- function(in_csv = INPUT_CSV,
                               out_dir = OUTPUT_DIR,
                               acc_col = "f1_mean") {
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  cat("Input CSV     : ", normalizePath(in_csv, winslash = "/", mustWork = FALSE), "\n", sep = "")
  cat("Output folder: ", normalizePath(out_dir, winslash = "/", mustWork = TRUE), "\n\n", sep = "")

  if (!file.exists(in_csv)) {
    stop("CSV not found: ", normalizePath(in_csv, winslash = "/", mustWork = FALSE))
  }

  df <- readr::read_csv(in_csv, show_col_types = FALSE)
  miss <- setdiff(c("task", PART_COLS, acc_col), names(df))
  if (length(miss)) stop("Missing column(s): ", paste(miss, collapse = ", "))
  df$.acc <- df[[acc_col]]

  saved <- character(0)

  for (i in seq_along(PART_COLS)) {
    sec_col <- PART_COLS[i]
    sec_lab <- PART_LABELS[i]

    d <- df
    d$.level <- factor(d[[sec_col]], levels = 1:5)

    p <- ggplot(d, aes(x = .level, y = .acc)) +
      geom_jitter(width = 0.15, height = 0, alpha = 0.55,
                  size = 1.8, colour = "#2c7fb8") +
      stat_summary(fun = mean, geom = "point",
                   shape = 18, size = 3.2, colour = "#d7301f") +
      facet_wrap(~ task, scales = "free_y") +
      scale_x_discrete(drop = FALSE) +
      labs(
        title = paste0("Detail level vs accuracy - ", sec_lab),
        subtitle = "Red diamond = mean F1 at each level",
        x = paste0(sec_lab, " detail level (1-5)"),
        y = "F1 (accuracy)"
      ) +
      theme_minimal(base_size = 11) +
      theme(panel.grid.minor = element_blank())

    # Display in the RStudio Plots pane when run interactively.
    if (interactive()) print(p)

    file_path <- file.path(
      out_dir,
      paste0("plot3_", sec_col, "_level_vs_accuracy.png")
    )
    ggplot2::ggsave(
      filename = file_path,
      plot = p,
      width = 10,
      height = 5,
      dpi = 300
    )

    saved <- c(saved, normalizePath(file_path, winslash = "/", mustWork = TRUE))
    cat("Saved: ", tail(saved, 1), "\n", sep = "")
  }

  invisible(saved)
}

make_section_plots()
