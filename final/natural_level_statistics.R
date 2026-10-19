# ==============================================================================
# NATURAL SKELETAL-LEVEL DISTRIBUTIONS
# ==============================================================================
# Purpose
#   Quantify which anatomical resolution levels occur naturally in the dataset
#   for every skeletal section, separately for:
#     calc_level = "min", "max", "mode"
#     sum = FALSE and sum = TRUE
#
# Scientific interpretation used here
#   sum = FALSE:
#     Use each original loaded record/sample/individual's inferred 11-section
#     level vector. No second harmonization is applied.
#
#   sum = TRUE:
#     Group by site_id and use unique_level = FALSE + recalc_method = "min".
#     Therefore each site is harmonized independently to its own minimum-
#     compatible 11-section vector: "best internally consistent resolution
#     available for that site" under the current Tapho-R logic.
#
# IMPORTANT ABOUT ABSENT SECTIONS
#   summarize_bone_sections_zero_na() initializes absent sections to the maximum
#   defined level (e.g. cranium=5, hands=5, foot=5). Those are implementation
#   defaults, not observed evidence. The PRIMARY statistics and plots below only
#   count section-level values when that section has count > 0 in the analytical
#   unit. An audit table with all stored values is exported separately.
#
# Run this script from the root of your Tapho-R project so the source() paths in
# tapho_loader_new.R can resolve its dependencies.
# ============================================================================== 

# ------------------------------- USER SETTINGS --------------------------------

DATA_FILE <- "hspa.xlsx"              # <-- CHANGE to your workbook
LOADER_FILE <- "tapho_loader_new.R"   # <-- CHANGE if your file has another name
OUTPUT_DIR <- "natural_level_results"

INDET <- TRUE
INDET_METHOD <- "up"                  # "up", "dist", or "delet"
FRAGMENTS_PER_BONE <- 3
SITE_RECALC_METHOD <- "min"           # keep "min" for internal site compatibility
VERBOSE_LOADING <- FALSE

CALC_METHODS <- c("min", "max", "mode")

# ------------------------------- PACKAGES -------------------------------------

required_packages <- c("dplyr", "tidyr", "purrr", "ggplot2", "readr", "tibble")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace,
                                               logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop(
    "Install the following packages first: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(readr)
library(tibble)

# ------------------------------- LOAD TAPHO-R ---------------------------------

if (!file.exists(LOADER_FILE)) {
  stop("LOADER_FILE not found: ", LOADER_FILE, call. = FALSE)
}
if (!file.exists(DATA_FILE)) {
  stop("DATA_FILE not found: ", DATA_FILE, call. = FALSE)
}

source(LOADER_FILE)

dir.create(OUTPUT_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(OUTPUT_DIR, "plots"), recursive = TRUE, showWarnings = FALSE)

# ------------------------------- CONSTANTS ------------------------------------

sections_order <- c(
  "cranium", "teeth", "hyoid", "vertebrae", "thorax", "shoulder",
  "arms", "hands", "pelvic", "legs", "foot"
)

# Same maximum levels used by summarize_bone_sections_zero_na().
max_level_by_section <- c(
  cranium   = 5,
  teeth     = 5,
  hyoid     = 1,
  vertebrae = 3,
  thorax    = 4,
  shoulder  = 3,
  arms      = 3,
  hands     = 5,
  pelvic    = 4,
  legs      = 3,
  foot      = 5
)

allowed_levels <- purrr::map2_dfr(
  names(max_level_by_section),
  as.integer(max_level_by_section),
  ~ tibble(section = .x, level = seq_len(.y))
) %>%
  mutate(section = factor(section, levels = sections_order))

# ------------------------------- HELPERS --------------------------------------

as_numeric_level_vector <- function(x) {
  v <- suppressWarnings(as.numeric(unlist(x, use.names = FALSE)))
  if (length(v) != length(sections_order)) {
    stop(
      "A bone.level vector had length ", length(v),
      "; expected ", length(sections_order), ".",
      call. = FALSE
    )
  }
  as.integer(v)
}

# Identify whether each skeletal section is genuinely represented by a positive
# count in one analytical row. This prevents absent-section defaults from being
# interpreted as observed natural levels.
section_presence <- function(elements, counts, element_lookup) {
  el <- as.character(unlist(elements, use.names = FALSE))
  ct <- suppressWarnings(as.numeric(unlist(counts, use.names = FALSE)))

  if (length(el) != length(ct)) {
    stop("element/count length mismatch while determining section presence.",
         call. = FALSE)
  }

  ct[is.na(ct)] <- 0
  keys <- gsub(" ", ".", el)
  sec <- element_lookup$section[match(keys, element_lookup$element_key)]

  present_sections <- unique(sec[!is.na(sec) & ct > 0])
  stats::setNames(sections_order %in% present_sections, sections_order)
}

expand_level_rows <- function(db, calc_method, sum_flag, element_lookup) {
  if (nrow(db) == 0) return(tibble())

  purrr::map_dfr(seq_len(nrow(db)), function(i) {
    levels_i <- as_numeric_level_vector(db$bone.level[[i]])
    present_i <- section_presence(
      db$element[[i]],
      db$count[[i]],
      element_lookup
    )

    site_id_i <- if ("site_id" %in% names(db)) as.character(db$site_id[[i]]) else NA_character_
    site_name_i <- if ("site_name" %in% names(db)) as.character(db$site_name[[i]]) else NA_character_
    individual_id_i <- if ("individual_id" %in% names(db)) as.character(db$individual_id[[i]]) else NA_character_
    ind_name_i <- if ("ind_name" %in% names(db)) as.character(db$ind_name[[i]]) else NA_character_

    unit_id_i <- if (isTRUE(sum_flag)) {
      ifelse(is.na(site_id_i) || site_id_i == "", paste0("site_row_", i), site_id_i)
    } else {
      paste(
        ifelse(is.na(site_id_i), "NA_site", site_id_i),
        ifelse(is.na(individual_id_i), "NA_individual", individual_id_i),
        ifelse(is.na(ind_name_i), paste0("row_", i), ind_name_i),
        sep = " | "
      )
    }

    tibble(
      sum = isTRUE(sum_flag),
      unit_type = ifelse(isTRUE(sum_flag), "site", "record/sample"),
      calc_level = calc_method,
      unit_index = i,
      unit_id = unit_id_i,
      site_id = site_id_i,
      site_name = site_name_i,
      individual_id = individual_id_i,
      ind_name = ind_name_i,
      section = factor(sections_order, levels = sections_order),
      level = levels_i,
      observed_section = as.logical(present_i[sections_order])
    )
  })
}

mode_first <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_integer_)
  ux <- unique(x)
  as.integer(ux[which.max(tabulate(match(x, ux)))])
}

save_plot_both <- function(plot, filename_base, width, height) {
  ggsave(
    filename = file.path(OUTPUT_DIR, "plots", paste0(filename_base, ".png")),
    plot = plot, width = width, height = height, dpi = 300
  )
  ggsave(
    filename = file.path(OUTPUT_DIR, "plots", paste0(filename_base, ".pdf")),
    plot = plot, width = width, height = height
  )
}

# ------------------------------- MAIN ANALYSIS --------------------------------

run_natural_level_analysis <- function() {

  # meta_set() attaches meta_env, which the recalculation functions use.
  meta <- meta_set(INDET)
  on.exit({
    if ("meta_env" %in% search()) detach("meta_env")
  }, add = TRUE)

  # Normalized element -> skeletal-section lookup.
  element_lookup <- elements_data %>%
    transmute(
      element_key = gsub(" ", ".", as.character(ElementsOne)),
      section = as.character(Skeleton_Section)
    ) %>%
    distinct(element_key, .keep_all = TRUE)

  all_level_rows <- vector("list", length(CALC_METHODS) * 2L)
  k <- 1L

  for (method_i in CALC_METHODS) {
    message("Loading calc_level = ", method_i, " ...")

    # Stage 1: natural per-record inference with level = NULL.
    raw_db <- read_excel_sheets(
      file_path = DATA_FILE,
      level = NULL,
      calc_level = method_i,
      indet = INDET,
      indet_method = INDET_METHOD,
      fragments_per_bone = FRAGMENTS_PER_BONE,
      meta = meta,
      verbose = VERBOSE_LOADING
    )

    # sum = FALSE:
    # Keep raw Stage-1 rows. This is equivalent to select_and_group_by(...,
    # group_by = NULL, unique_level = FALSE), which returns data unchanged.
    db_sum_false <- raw_db

    all_level_rows[[k]] <- expand_level_rows(
      db = db_sum_false,
      calc_method = method_i,
      sum_flag = FALSE,
      element_lookup = element_lookup
    )
    k <- k + 1L

    # sum = TRUE:
    # Harmonize independently inside each site, then summarize each site.
    # This implements: each site at its best internally consistent resolution.
    db_sum_true <- select_and_group_by(
      data = raw_db,
      group_by = "site_id",
      select = NULL,
      method = SITE_RECALC_METHOD,
      level = NULL,
      unique_level = FALSE
    )

    all_level_rows[[k]] <- expand_level_rows(
      db = db_sum_true,
      calc_method = method_i,
      sum_flag = TRUE,
      element_lookup = element_lookup
    )
    k <- k + 1L
  }

  levels_all <- bind_rows(all_level_rows) %>%
    mutate(
      calc_level = factor(calc_level, levels = CALC_METHODS),
      section = factor(section, levels = sections_order),
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

  # PRIMARY scientific table: exclude section-level defaults where that section
  # has no positive skeletal counts in the unit.
  levels_observed <- levels_all %>%
    filter(observed_section)

  # Build complete count grid so zero-frequency levels are explicit in CSVs/plots.
  analysis_combinations <- tidyr::expand_grid(
    sum = c(FALSE, TRUE),
    calc_level = factor(CALC_METHODS, levels = CALC_METHODS)
  )

  complete_grid <- analysis_combinations %>%
    mutate(.join_key = 1L) %>%
    left_join(
      allowed_levels %>% mutate(.join_key = 1L),
      by = ".join_key"
    ) %>%
    select(-.join_key)

  raw_counts <- levels_observed %>%
    count(sum, calc_level, section, level, name = "n")

  counts_observed <- complete_grid %>%
    left_join(raw_counts, by = c("sum", "calc_level", "section", "level")) %>%
    mutate(n = tidyr::replace_na(n, 0L)) %>%
    group_by(sum, calc_level, section) %>%
    mutate(
      n_units_with_section = sum(n),
      percent = ifelse(n_units_with_section > 0,
                       100 * n / n_units_with_section,
                       NA_real_)
    ) %>%
    ungroup() %>%
    mutate(
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

  # Audit counts: all stored level values, including absent-section defaults.
  stored_counts <- levels_all %>%
    count(sum, calc_level, section, level, name = "n_stored") %>%
    group_by(sum, calc_level, section) %>%
    mutate(
      n_stored_total = sum(n_stored),
      percent_stored = 100 * n_stored / n_stored_total
    ) %>%
    ungroup()

  # Descriptive statistics for observed sections only.
  section_summary <- levels_observed %>%
    group_by(sum, calc_level, section) %>%
    summarise(
      n_units_with_section = n(),
      mean_level = mean(level, na.rm = TRUE),
      sd_level = ifelse(n() > 1, sd(level, na.rm = TRUE), NA_real_),
      median_level = median(level, na.rm = TRUE),
      min_level = min(level, na.rm = TRUE),
      max_level = max(level, na.rm = TRUE),
      modal_level = mode_first(level),
      .groups = "drop"
    )

  dominant_from_counts <- counts_observed %>%
    filter(n_units_with_section > 0) %>%
    group_by(sum, calc_level, section) %>%
    arrange(level, .by_group = TRUE) %>%
    slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
    transmute(
      sum, calc_level, section,
      modal_level_from_counts = level,
      modal_level_n = n,
      modal_level_percent = percent
    ) %>%
    ungroup()

  section_summary <- section_summary %>%
    left_join(dominant_from_counts,
              by = c("sum", "calc_level", "section"))

  # Wide vectors: useful for inspecting actual site/record-level resolutions.
  vectors_all_stored <- levels_all %>%
    select(sum, unit_type, calc_level, unit_index, unit_id,
           site_id, site_name, individual_id, ind_name, section, level) %>%
    pivot_wider(names_from = section, values_from = level)

  vectors_observed <- levels_all %>%
    mutate(level_observed = ifelse(observed_section, level, NA_integer_)) %>%
    select(sum, unit_type, calc_level, unit_index, unit_id,
           site_id, site_name, individual_id, ind_name,
           section, level_observed) %>%
    pivot_wider(names_from = section, values_from = level_observed)

  # ------------------------------- EXPORT TABLES ------------------------------

  readr::write_csv(
    levels_observed %>% mutate(section = as.character(section),
                               calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_levels_long_observed_only.csv")
  )

  readr::write_csv(
    levels_all %>% mutate(section = as.character(section),
                          calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_levels_long_all_stored_audit.csv")
  )

  readr::write_csv(
    counts_observed %>% mutate(section = as.character(section),
                               calc_level = as.character(calc_level),
                               sum_label = as.character(sum_label)),
    file.path(OUTPUT_DIR, "natural_level_counts_observed_only.csv")
  )

  readr::write_csv(
    stored_counts %>% mutate(section = as.character(section),
                             calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_level_counts_all_stored_audit.csv")
  )

  readr::write_csv(
    section_summary %>% mutate(section = as.character(section),
                               calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_level_section_summary.csv")
  )

  readr::write_csv(
    vectors_observed %>% mutate(calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_level_vectors_observed_only.csv")
  )

  readr::write_csv(
    vectors_all_stored %>% mutate(calc_level = as.character(calc_level)),
    file.path(OUTPUT_DIR, "natural_level_vectors_all_stored_audit.csv")
  )

  # ------------------------------- PLOTS --------------------------------------

  # A. Six detailed figures: one for each calc_level x sum combination.
  for (sum_i in c(FALSE, TRUE)) {
    for (method_i in CALC_METHODS) {
      pdat <- counts_observed %>%
        filter(sum == sum_i, as.character(calc_level) == method_i)

      p <- ggplot(pdat, aes(x = factor(level), y = n)) +
        geom_col(width = 0.75) +
        geom_text(
          aes(label = ifelse(n > 0, n, "")),
          vjust = -0.25,
          size = 3
        ) +
        facet_wrap(~ section, ncol = 4, scales = "free_y") +
        labs(
          title = paste0(
            "Natural skeletal resolution levels: calc_level = ", method_i,
            ", sum = ", sum_i
          ),
          subtitle = if (sum_i) {
            "One internally harmonized vector per site; absent sections excluded"
          } else {
            "Original record/sample vectors; absent sections excluded"
          },
          x = "Level",
          y = "Number of analytical units"
        ) +
        theme_bw(base_size = 11) +
        theme(
          strip.text = element_text(face = "bold"),
          panel.grid.major.x = element_blank()
        )

      save_plot_both(
        p,
        paste0("counts_", method_i, "_sum_", sum_i),
        width = 13,
        height = 9
      )
    }
  }

  # B. Relative composition of levels within each skeletal section.
  for (sum_i in c(FALSE, TRUE)) {
    pdat <- counts_observed %>% filter(sum == sum_i)

    p <- ggplot(
      pdat,
      aes(x = section, y = n, fill = factor(level))
    ) +
      geom_col(position = "fill", width = 0.8) +
      coord_flip() +
      facet_wrap(~ calc_level, ncol = 1) +
      scale_y_continuous(
        labels = function(x) paste0(round(100 * x), "%"),
        expand = c(0, 0)
      ) +
      labs(
        title = paste0("Relative natural-level composition, sum = ", sum_i),
        subtitle = "Percentages are within skeletal section; absent sections excluded",
        x = NULL,
        y = "Percent of analytical units with that section",
        fill = "Level"
      ) +
      theme_bw(base_size = 11) +
      theme(panel.grid.major.y = element_blank())

    save_plot_both(
      p,
      paste0("composition_sum_", sum_i),
      width = 11,
      height = 12
    )
  }

  # C. Compact global overview: counts as a heat map for all six analyses.
  p_heat <- ggplot(
    counts_observed,
    aes(x = factor(level), y = section, fill = n)
  ) +
    geom_tile() +
    geom_text(aes(label = ifelse(n > 0, n, "")), size = 3) +
    facet_grid(sum_label ~ calc_level) +
    labs(
      title = "Natural skeletal-resolution levels across the dataset",
      subtitle = "Cell labels are counts; absent skeletal sections are excluded",
      x = "Level",
      y = NULL,
      fill = "Count"
    ) +
    theme_bw(base_size = 10) +
    theme(
      strip.text = element_text(face = "bold"),
      panel.grid = element_blank()
    )

  save_plot_both(
    p_heat,
    "heatmap_all_six_analyses",
    width = 14,
    height = 11
  )

  # ------------------------------- CONSOLE SUMMARY ----------------------------

  message("\nFinished. Main outputs written to: ", normalizePath(OUTPUT_DIR))
  message("Primary frequency table: natural_level_counts_observed_only.csv")
  message("Section summary:        natural_level_section_summary.csv")
  message("Observed vectors:       natural_level_vectors_observed_only.csv")
  message("Audit vectors:          natural_level_vectors_all_stored_audit.csv")
  message("Plots:                  ", file.path(OUTPUT_DIR, "plots"))

  invisible(list(
    levels_observed = levels_observed,
    levels_all = levels_all,
    counts_observed = counts_observed,
    stored_counts = stored_counts,
    section_summary = section_summary,
    vectors_observed = vectors_observed,
    vectors_all_stored = vectors_all_stored
  ))
}

# Run analysis and keep returned objects available in the R session.
natural_level_results <- run_natural_level_analysis()
