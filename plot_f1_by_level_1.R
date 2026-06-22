# =====================================================================
# plot_f1_by_level.R
#
# Two plots PER TASK from accuracy_f1_RandomForest_by_level.csv
# (the file produced by accuracy_by_level.R).
#
# Expected columns:
#   task, level,
#   cranium, teeth, hyoid, vertebrae, thorax, shoulder,
#   arms, hands, pelvic, legs, foot,
#   f1_mean
#
# Plot 1  (parallel coordinates):
#   x = the 11 skeletal sections (discrete, ordered)
#   y = detail level (1-5) chosen at each section
#   one line per level vector, coloured by f1_mean (accuracy)
#   -> plot1_level_vectors_<task>.png
#
# Plot 2  (scatter):
#   x = sum of the level vector, y = f1_mean (accuracy)
#   -> plot2_accuracy_vs_sum_level_<task>.png
# =====================================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

# column names in the CSV, in section order ...
PART_COLS <- c("cranium", "teeth", "hyoid", "vertebrae", "thorax",
               "shoulder", "arms", "hands", "pelvic", "legs", "foot")
# ... and the labels shown on the axis (same order)
PART_LABELS <- c("Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
                 "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot")

make_f1_level_plots <- function(in_csv  = "accuracy_f1_RandomForest_by_level.csv",
                                out_dir = "results_f1_level_plots",
                                acc_col = "f1_mean") {

  if (!file.exists(in_csv)) stop("CSV not found: ", in_csv)
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  df <- readr::read_csv(in_csv, show_col_types = FALSE)

  miss <- setdiff(c("task", "level", PART_COLS, acc_col), names(df))
  if (length(miss)) stop("Missing column(s): ", paste(miss, collapse = ", "))

  # total detail = sum of the 11 section levels
  df$sum_level <- rowSums(df[, PART_COLS])
  df$.acc <- df[[acc_col]]

  safe <- function(x) gsub("[^A-Za-z0-9._-]+", "_", x)

  build_p1 <- function(d, task_name) {
    long <- d %>%
      tidyr::pivot_longer(cols = dplyr::all_of(PART_COLS),
                          names_to = "part", values_to = "value") %>%
      mutate(section = factor(part, levels = PART_COLS, labels = PART_LABELS))

    ggplot(long, aes(x = section, y = value,
                     group = level, colour = .acc)) +
      geom_line(alpha = 0.8, linewidth = 0.6) +
      geom_point(size = 1.4) +
      scale_colour_viridis_c(name = "Accuracy\n(F1)", option = "C") +
      scale_y_continuous(breaks = 1:5, limits = c(1, 5)) +
      labs(title = paste0("Level vectors across skeletal sections - ", task_name),
           x = "Skeletal section", y = "Detail level (1-5)") +
      theme_minimal(base_size = 11) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            panel.grid.minor = element_blank())
  }

  build_p2 <- function(d, task_name) {
    ggplot(d, aes(x = sum_level, y = .acc)) +
      geom_point(size = 2.4, alpha = 0.85, colour = "#2c7fb8") +
      labs(title = paste0("Accuracy vs total detail (sum of level vector) - ", task_name),
           x = "Sum of level vector", y = "F1 (accuracy)") +
      theme_minimal(base_size = 11)
  }

  saved <- character(0)
  for (tk in sort(unique(df$task))) {
    dt <- dplyr::filter(df, task == tk)

    p1 <- file.path(out_dir, paste0("plot1_level_vectors_", safe(tk), ".png"))
    ggsave(p1, build_p1(dt, tk), width = 11, height = 7, dpi = 300)

    p2 <- file.path(out_dir, paste0("plot2_accuracy_vs_sum_level_", safe(tk), ".png"))
    ggsave(p2, build_p2(dt, tk), width = 9, height = 6, dpi = 300)

    saved <- c(saved, p1, p2)
  }

  cat("Saved plots:\n", paste0("  ", saved, collapse = "\n"), "\n", sep = "")
  invisible(saved)
}

# run directly
if (sys.nframe() == 0) {
  make_f1_level_plots(
    in_csv  = "accuracy_f1_RandomForest_by_level.csv",
    out_dir = "results_f1_level_plots",
    acc_col = "f1_mean"
  )
}
