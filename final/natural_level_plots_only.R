# ==============================================================================
# RE-PLOT NATURAL SKELETAL-LEVEL RESULTS WITHOUT RELOADING THE EXCEL WORKBOOK
# ==============================================================================
# Run natural_level_statistics.R first. This script reads its main count table
# and regenerates the figures, so plot styling can be changed quickly.
# ==============================================================================

RESULT_DIR <- "natural_level_results"
COUNT_FILE <- file.path(RESULT_DIR, "natural_level_counts_observed_only.csv")
PLOT_DIR <- file.path(RESULT_DIR, "plots_restyled")

required_packages <- c("dplyr", "ggplot2", "readr")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace,
                                               logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Install first: ", paste(missing_packages, collapse = ", "), call. = FALSE)
}

library(dplyr)
library(ggplot2)
library(readr)

dir.create(PLOT_DIR, recursive = TRUE, showWarnings = FALSE)

sections_order <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
  "arms", "hands", "pelvic", "legs", "foot"
)
calc_methods <- c("min", "max", "mode")

counts <- readr::read_csv(COUNT_FILE, show_col_types = FALSE) %>%
  mutate(
    section = factor(section, levels = sections_order),
    calc_level = factor(calc_level, levels = calc_methods),
    sum_label = factor(
      ifelse(sum,
             "sum = TRUE (site, internally harmonized)",
             "sum = FALSE (record/sample)"),
      levels = c(
        "sum = FALSE (record/sample)",
        "sum = TRUE (site, internally harmonized)"
      )
    )
  )

save_both <- function(p, name, width, height) {
  ggsave(file.path(PLOT_DIR, paste0(name, ".png")), p,
         width = width, height = height, dpi = 300)
  ggsave(file.path(PLOT_DIR, paste0(name, ".pdf")), p,
         width = width, height = height)
}

# Six detailed count figures.
for (sum_i in c(FALSE, TRUE)) {
  for (method_i in calc_methods) {
    pdat <- counts %>%
      filter(sum == sum_i, as.character(calc_level) == method_i)

    p <- ggplot(pdat, aes(x = factor(level), y = n)) +
      geom_col(width = 0.75) +
      geom_text(aes(label = ifelse(n > 0, n, "")), vjust = -0.25, size = 3) +
      facet_wrap(~ section, ncol = 4, scales = "free_y") +
      labs(
        title = paste0("Natural levels: ", method_i, ", sum = ", sum_i),
        x = "Level",
        y = "Number of analytical units"
      ) +
      theme_bw(base_size = 11) +
      theme(strip.text = element_text(face = "bold"),
            panel.grid.major.x = element_blank())

    save_both(p, paste0("counts_", method_i, "_sum_", sum_i), 13, 9)
  }
}

# Two proportional-composition plots.
for (sum_i in c(FALSE, TRUE)) {
  pdat <- counts %>% filter(sum == sum_i)

  p <- ggplot(pdat, aes(x = section, y = n, fill = factor(level))) +
    geom_col(position = "fill", width = 0.8) +
    coord_flip() +
    facet_wrap(~ calc_level, ncol = 1) +
    scale_y_continuous(
      labels = function(x) paste0(round(100 * x), "%"),
      expand = c(0, 0)
    ) +
    labs(
      title = paste0("Relative natural-level composition, sum = ", sum_i),
      x = NULL,
      y = "Percent of analytical units",
      fill = "Level"
    ) +
    theme_bw(base_size = 11)

  save_both(p, paste0("composition_sum_", sum_i), 11, 12)
}

# One global count heat map.
p_heat <- ggplot(counts, aes(x = factor(level), y = section, fill = n)) +
  geom_tile() +
  geom_text(aes(label = ifelse(n > 0, n, "")), size = 3) +
  facet_grid(sum_label ~ calc_level) +
  labs(
    title = "Natural skeletal-resolution levels across the dataset",
    x = "Level",
    y = NULL,
    fill = "Count"
  ) +
  theme_bw(base_size = 10) +
  theme(panel.grid = element_blank(), strip.text = element_text(face = "bold"))

save_both(p_heat, "heatmap_all_six_analyses", 14, 11)

message("Plots written to: ", normalizePath(PLOT_DIR))
