# plot_level_accuracy.R
# Two summary plots from the master accuracy CSV produced by the tuning sweep.
#
# Expected columns in the CSV:
#   task, variant, level_str, model, best_accuracy,
#   pos1 ... posN  (the level vector, one column per skeletal section),
#   sum_level      (= sum of pos1..posN)
#
# Plot 1: parallel-coordinates style. x = the N skeletal sections (discrete,
#         ordered), y = the detail level (1-5) chosen at each section. Each
#         level vector is drawn as a connected line, coloured by its accuracy.
# Plot 2: scatter. x = sum of the level vector, y = best accuracy, one point
#         per model (coloured by model).

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

# Default section names; the caller can override via the argument.
# Must be in the SAME ORDER as pos1, pos2, ... in the CSV.
SECTION_LABELS_DEFAULT <- c(
  "Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
  "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot"
)

make_level_plots <- function(master_csv,
                             section_labels = SECTION_LABELS_DEFAULT,
                             out_dir        = ".") {

  if (!file.exists(master_csv)) {
    stop("Master CSV not found: ", master_csv)
  }
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  df <- readr::read_csv(master_csv, show_col_types = FALSE)

  # identify the position columns (pos1, pos2, ...) in numeric order
  pos_cols <- grep("^pos[0-9]+$", names(df), value = TRUE)
  pos_cols <- pos_cols[order(as.integer(sub("^pos", "", pos_cols)))]
  if (length(pos_cols) == 0) {
    stop("No pos1..posN columns found in ", master_csv)
  }
  if (length(section_labels) != length(pos_cols)) {
    warning("section_labels length (", length(section_labels),
            ") != number of pos columns (", length(pos_cols),
            "); falling back to the pos column names.")
    section_labels <- pos_cols
  }

  # a stable id for each plotted line (one line per task/variant/model/level)
  df <- df %>%
    mutate(line_id = paste(task, variant, model, level_str, sep = " | "))

  # -------------------------------------------------------------
  # Plot 1: level vectors as connected lines, coloured by accuracy
  # -------------------------------------------------------------
  long <- df %>%
    tidyr::pivot_longer(
      cols      = dplyr::all_of(pos_cols),
      names_to  = "pos",
      values_to = "value"
    ) %>%
    mutate(
      pos_idx = as.integer(sub("^pos", "", pos)),
      section = factor(section_labels[pos_idx], levels = section_labels)
    )

  p1 <- ggplot(
      long,
      aes(x = section, y = value,
          group = line_id, colour = best_accuracy)
    ) +
    geom_line(alpha = 0.7, linewidth = 0.6) +
    geom_point(size = 1.4) +
    scale_colour_viridis_c(name = "Accuracy", option = "C") +
    scale_y_continuous(breaks = 1:5, limits = c(1, 5)) +
    facet_grid(task ~ model) +
    labs(
      title = "Level vectors across skeletal sections, coloured by accuracy",
      x     = "Skeletal section",
      y     = "Detail level (1-5)"
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid.minor = element_blank()
    )

  p1_path <- file.path(out_dir, "plot1_level_vectors_by_accuracy.png")
  ggsave(p1_path, p1, width = 11, height = 7, dpi = 300)

  # -------------------------------------------------------------
  # Plot 2: accuracy vs total detail (sum of level vector)
  # -------------------------------------------------------------
  p2 <- ggplot(
      df,
      aes(x = sum_level, y = best_accuracy, colour = model)
    ) +
    geom_point(size = 2.4, alpha = 0.8) +
    facet_wrap(~ task, scales = "free_y") +
    labs(
      title = "Accuracy vs total detail (sum of level vector)",
      x     = "Sum of level vector",
      y     = "Best CV accuracy",
      colour = "Model"
    ) +
    theme_minimal(base_size = 11)

  p2_path <- file.path(out_dir, "plot2_accuracy_vs_sum_level.png")
  ggsave(p2_path, p2, width = 9, height = 6, dpi = 300)

  cat("Saved plots:\n  ", p1_path, "\n  ", p2_path, "\n", sep = "")

  invisible(list(plot1 = p1, plot2 = p2, data = df))
}

# If run directly (not sourced), make the plots from the default CSV.
if (sys.nframe() == 0) {
  make_level_plots(
    master_csv     = "level_accuracy_master.csv",
    section_labels = SECTION_LABELS_DEFAULT,
    out_dir        = "results_level_accuracy_plots"
  )
}
