# plot_level_accuracy.R
# Summary plots from the master accuracy CSV produced by the tuning sweep.
#
# Expected columns in the CSV:
#   task, variant, level_str, model, best_accuracy,
#   pos1 ... posN  (the level vector, one column per skeletal section),
#   sum_level      (= sum of pos1..posN)
#
# By default this writes ONE pair of plots PER MODEL:
#   plot1_level_vectors_by_accuracy_<model>.png
#   plot2_accuracy_vs_sum_level_<model>.png
#
# Plot 1: parallel-coordinates style. x = the N skeletal sections (discrete,
#         ordered), y = the detail level (1-5) chosen at each section. Each
#         level vector is drawn as a connected line, coloured by its accuracy.
# Plot 2: scatter. x = sum of the level vector, y = best accuracy.
#
# Set combined = TRUE to ALSO get all-models-overlaid versions.

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
                             out_dir        = ".",
                             per_model      = TRUE,
                             combined       = FALSE) {

  if (!file.exists(master_csv)) {
    stop("Master CSV not found: ", master_csv)
  }
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  df <- readr::read_csv(master_csv, show_col_types = FALSE)

  # Collapse accidental duplicates. If the script was re-run (or the loop was
  # re-executed interactively) the master file can accumulate repeated rows for
  # the same combo. Keep one row per task/variant/level/model: the best accuracy.
  df <- df %>%
    dplyr::group_by(task, variant, level_str, model) %>%
    dplyr::slice_max(best_accuracy, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()

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

  # ----------------------------------------------------------------
  # builders (so combined and per-model versions share the same code)
  # ----------------------------------------------------------------
  build_p1 <- function(d, title_extra) {
    long <- d %>%
      tidyr::pivot_longer(
        cols      = dplyr::all_of(pos_cols),
        names_to  = "pos",
        values_to = "value"
      ) %>%
      mutate(
        pos_idx = as.integer(sub("^pos", "", pos)),
        section = factor(section_labels[pos_idx], levels = section_labels)
      )

    ggplot(long, aes(x = section, y = value,
                     group = line_id, colour = best_accuracy)) +
      geom_line(alpha = 0.8, linewidth = 0.6) +
      geom_point(size = 1.4) +
      scale_colour_viridis_c(name = "Accuracy", option = "C") +
      scale_y_continuous(breaks = 1:5, limits = c(1, 5)) +
      facet_wrap(~ task) +
      labs(
        title = paste0("Level vectors across skeletal sections", title_extra),
        x     = "Skeletal section",
        y     = "Detail level (1-5)"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.minor = element_blank()
      )
  }

  build_p2 <- function(d, title_extra, colour_by_model) {
    aes_base <- if (colour_by_model) {
      aes(x = sum_level, y = best_accuracy, colour = model)
    } else {
      aes(x = sum_level, y = best_accuracy)
    }
    p <- ggplot(d, aes_base) +
      facet_wrap(~ task, scales = "free_y") +
      labs(
        title = paste0("Accuracy vs total detail (sum of level vector)", title_extra),
        x     = "Sum of level vector",
        y     = "Best CV accuracy"
      ) +
      theme_minimal(base_size = 11)
    if (colour_by_model) {
      p + geom_point(size = 2.4, alpha = 0.85) + labs(colour = "Model")
    } else {
      p + geom_point(size = 2.4, alpha = 0.85, colour = "#2c7fb8")
    }
  }

  # safe-ish filename fragment from a model name
  safe <- function(x) gsub("[^A-Za-z0-9._-]+", "_", x)

  saved <- character(0)

  # ----------------------------------------------------------------
  # per-model plots (default)
  # ----------------------------------------------------------------
  if (isTRUE(per_model)) {
    for (m in sort(unique(df$model))) {
      dm <- dplyr::filter(df, model == m)

      p1 <- build_p1(dm, title_extra = paste0(" - ", m))
      p1_path <- file.path(out_dir,
        paste0("plot1_level_vectors_by_accuracy_", safe(m), ".png"))
      ggsave(p1_path, p1, width = 11, height = 7, dpi = 300)

      p2 <- build_p2(dm, title_extra = paste0(" - ", m), colour_by_model = FALSE)
      p2_path <- file.path(out_dir,
        paste0("plot2_accuracy_vs_sum_level_", safe(m), ".png"))
      ggsave(p2_path, p2, width = 9, height = 6, dpi = 300)

      saved <- c(saved, p1_path, p2_path)
    }
  }

  # ----------------------------------------------------------------
  # combined plots (optional)
  # ----------------------------------------------------------------
  if (isTRUE(combined)) {
    p1c <- build_p1(df, title_extra = " - all models")
    p1c_path <- file.path(out_dir, "plot1_level_vectors_by_accuracy_ALL.png")
    ggsave(p1c_path, p1c, width = 11, height = 7, dpi = 300)

    p2c <- build_p2(df, title_extra = " - all models", colour_by_model = TRUE)
    p2c_path <- file.path(out_dir, "plot2_accuracy_vs_sum_level_ALL.png")
    ggsave(p2c_path, p2c, width = 9, height = 6, dpi = 300)

    saved <- c(saved, p1c_path, p2c_path)
  }

  cat("Saved plots:\n", paste0("  ", saved, collapse = "\n"), "\n", sep = "")
  invisible(list(saved = saved, data = df))
}

# If run directly (not sourced), make the plots from the default CSV.
if (sys.nframe() == 0) {
  make_level_plots(
    master_csv     = "level_accuracy_master.csv",
    section_labels = SECTION_LABELS_DEFAULT,
    out_dir        = "results_level_accuracy_plots",
    per_model      = TRUE,
    combined       = FALSE
  )
}
