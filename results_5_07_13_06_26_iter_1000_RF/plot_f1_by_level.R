# =====================================================================
# plot_f1_by_level.R
#
# Reads accuracy_f1_RandomForest_by_level.csv from this script's folder.
# Prints each plot in an interactive R session, then saves two PNG files
# per task to:
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
  library(tidyr)
  library(ggplot2)
})

PART_COLS <- c("cranium", "teeth", "hyoid", "vertebrae", "thorax",
               "shoulder", "arms", "hands", "pelvic", "legs", "foot")
PART_LABELS <- c("Cranium", "Teeth", "Hyoid", "Vertebrae", "Thorax",
                 "Shoulder", "Arm", "Hand", "Pelvis", "Leg", "Foot")

make_f1_level_plots <- function(in_csv = INPUT_CSV,
                                out_dir = OUTPUT_DIR,
                                acc_col = "f1_mean") {
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  cat("Input CSV     : ", normalizePath(in_csv, winslash = "/", mustWork = FALSE), "\n", sep = "")
  cat("Output folder: ", normalizePath(out_dir, winslash = "/", mustWork = TRUE), "\n\n", sep = "")

  if (!file.exists(in_csv)) {
    stop("CSV not found: ", normalizePath(in_csv, winslash = "/", mustWork = FALSE))
  }

  df <- readr::read_csv(in_csv, show_col_types = FALSE)

  miss <- setdiff(c("task", "level", PART_COLS, acc_col), names(df))
  if (length(miss)) stop("Missing column(s): ", paste(miss, collapse = ", "))

  df$sum_level <- rowSums(df[, PART_COLS], na.rm = FALSE)
  df$.acc <- df[[acc_col]]

  safe <- function(x) gsub("[^A-Za-z0-9._-]+", "_", x)

  build_p1 <- function(d, task_name) {
    long <- d %>%
      tidyr::pivot_longer(
        cols = dplyr::all_of(PART_COLS),
        names_to = "part",
        values_to = "value"
      ) %>%
      mutate(section = factor(part, levels = PART_COLS, labels = PART_LABELS))

    ggplot(long, aes(x = section, y = value, group = level, colour = .acc)) +
      geom_line(alpha = 0.8, linewidth = 0.6) +
      geom_point(size = 1.4) +
      scale_colour_viridis_c(name = "Accuracy\n(F1)", option = "C") +
      scale_y_continuous(breaks = 1:5, limits = c(1, 5)) +
      labs(
        title = paste0("Level vectors across skeletal sections - ", task_name),
        x = "Skeletal section",
        y = "Detail level (1-5)"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.minor = element_blank()
      )
  }

  build_p2 <- function(d, task_name) {
    ggplot(d, aes(x = sum_level, y = .acc)) +
      geom_point(size = 2.4, alpha = 0.85, colour = "#2c7fb8") +
      labs(
        title = paste0("Accuracy vs total detail - ", task_name),
        x = "Sum of level vector",
        y = "F1 (accuracy)"
      ) +
      theme_minimal(base_size = 11)
  }

  saved <- character(0)

  for (task_name in sort(unique(df$task))) {
    task_data <- dplyr::filter(df, task == task_name)

    plot1 <- build_p1(task_data, task_name)
    if (interactive()) print(plot1)

    plot1_path <- file.path(
      out_dir,
      paste0("plot1_level_vectors_", safe(task_name), ".png")
    )
    ggplot2::ggsave(
      filename = plot1_path,
      plot = plot1,
      width = 11,
      height = 7,
      dpi = 300
    )
    saved <- c(saved, normalizePath(plot1_path, winslash = "/", mustWork = TRUE))
    cat("Saved: ", tail(saved, 1), "\n", sep = "")

    plot2 <- build_p2(task_data, task_name)
    if (interactive()) print(plot2)

    plot2_path <- file.path(
      out_dir,
      paste0("plot2_accuracy_vs_sum_level_", safe(task_name), ".png")
    )
    ggplot2::ggsave(
      filename = plot2_path,
      plot = plot2,
      width = 9,
      height = 6,
      dpi = 300
    )
    saved <- c(saved, normalizePath(plot2_path, winslash = "/", mustWork = TRUE))
    cat("Saved: ", tail(saved, 1), "\n", sep = "")
  }

  invisible(saved)
}

make_f1_level_plots()
