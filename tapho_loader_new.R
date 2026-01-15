source("meta_new.R")
source("NewSiteDataLoader_new.R")
source("select_data_new.R")
source("data_loader_new.R")

library(dplyr)
library(tibble)

summarize_bone_sections_zero_na <- function(input_df, reference_df = elements_data) {
  colnames(input_df) <- c("element", "count")
  # Filter out rows where input_df$element is 0 or NA

  input_df <- input_df %>%
    filter(!is.na(input_df$count) & input_df$count != 0)


  # Add bone info using the filtered input_df
  bone_info_df <- add_bone_info(input_df, reference_df)

  # Define the ordered list of skeleton sections
    sections_order <- c("cranium","teeth","hyoid", "vertebrae", "thorax", "shoulder",
    "arms", "hands", "pelvic", "legs", "foot")

  # Summarize the minimum Level for each section
  summary_df <- bone_info_df %>%
    group_by(Skeleton_Section) %>%
    summarize(min_level = min(Level, na.rm = TRUE)) %>%
    ungroup()

  # Create a named vector with all sections, initializing with 1 (instead of NA)
  result_vector <- setNames(rep(1, length(sections_order)), sections_order)

  # Fill in the result_vector with available data
  for (section in sections_order) {
    if (section %in% summary_df$Skeleton_Section) {
      level <- summary_df$min_level[summary_df$Skeleton_Section == section]
      # If the level is NA, keep it as 1, otherwise use the actual level
      result_vector[section] <- if(is.na(level)) 1 else level
    }
    # If the section is not in summary_df, it will remain 1
  }

  # Return just the numeric vector without names
  return(unname(result_vector))
}