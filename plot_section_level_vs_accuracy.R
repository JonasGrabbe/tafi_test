# =====================================================================
# plot_section_level_vs_accuracy.R
#
# 11 plots (one per skeletal section) from
# accuracy_f1_RandomForest_by_level.csv.
#
# For each section:  x = detail level (1-5) at that section,
#                    y = f1_mean (accuracy),
#                    faceted by task.
# Jittered points show every level vector; the red diamond is the
# mean accuracy at each level.
#
#   -> plot3_<section>_level_vs_accuracy.png   (x11)
#
# Saved into the output folder (created if missing); absolute paths
# are printed. Runs whether sourced or run with Rscript.
# =====================================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
})

PART_COLS <- c("cranium", "teeth", "hyoid", "vertebrae", "thorax",
               "shoulder", "arms", "hands", "pelvic", "legs", "foot")
PART_LABELS <- c("Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
                 "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot")

make_section_plots <- function(in_csv  = "accuracy_f1_RandomForest_by_level.csv",
                               out_dir = "results_f1_level_plots",
                               acc_col = "f1_mean") {

  if (!file.exists(in_csv)) {
    stop("CSV not found: ", normalizePath(in_csv, mustWork = FALSE),
         "\n  Working directory is: ", getwd())
  }

  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  out_dir_abs <- normalizePath(out_dir, mustWork = TRUE)
  cat("Working directory : ", getwd(), "\n", sep = "")
  cat("Output folder     : ", out_dir_abs, "\n\n", sep = "")

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
      labs(title = paste0("Detail level vs accuracy - ", sec_lab),
           subtitle = "red diamond = mean F1 at each level",
           x = paste0(sec_lab, " detail level (1-5)"),
           y = "F1 (accuracy)") +
      theme_minimal(base_size = 11) +
      theme(panel.grid.minor = element_blank())

    f <- file.path(out_dir, paste0("plot3_", sec_col, "_level_vs_accuracy.png"))
    ggsave(f, p, width = 10, height = 5, dpi = 300)
    saved <- c(saved, normalizePath(f))
  }

  cat("Saved ", length(saved), " plot(s):\n", sep = "")
  cat(paste0("  ", saved, collapse = "\n"), "\n", sep = "")
  invisible(saved)
}

# Always run.
make_section_plots(
  in_csv  = "accuracy_f1_RandomForest_by_level.csv",
  out_dir = "results_f1_level_plots",
  acc_col = "f1_mean"
)
