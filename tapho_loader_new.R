source("meta_new.R")
source("NewSiteDataLoader_new.R")
source("select_data_new.R")
source("data_loader_new.R")
source("archo_preload.R")

library(dplyr)
library(tibble)

summarize_bone_sections_zero_na <- function(input_df, reference_df = elements_data) {
  
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

recal_mne_six <- function(current_mne,  target_levels, skeleton_hierarchy, bone_names, sections_order) {
  current_levels = c(5,5,1,3,4,3,3,5,4,3,5)


  # Initialize results list
  new_mne <- list()

  # Create initial tibble with bone info
  current_mne_named <- tibble(count = current_mne, element = bone_names) %>%
    add_bone_info() %>%
    mutate(std_element = gsub(" ", ".", element))

  # Process each skeleton section
  for (part in sections_order) {
    part_idx <- which(sections_order == part)
    current_level <- current_levels[part_idx]
    target_level <- target_levels[part_idx]

    cat("\nProcessing", part, ": Starting at level", current_level, "-> Target", target_level, "\n")

    # Initialize working data
    working_data <- current_mne_named %>%
      filter(Skeleton_Section == part) %>%
      select(std_element, count)

    iteration <- 1
    while(current_level > target_level) {
      intermediate_level <- max(target_level, current_level - 1)
      mapping_name <- paste0(part, "_", current_level, "_to_", intermediate_level)

      if (mapping_name %in% names(category_hierarchy)) {
        # Create element-category mapping
        element_map <- stack(category_hierarchy[[mapping_name]]) %>%
          setNames(c("child", "parent")) %>%
          mutate(
            child = gsub(" ", ".", child),
            parent = gsub(" ", ".", parent)
          )

        # Split data into mappable and non-mappable elements
        mappable <- working_data %>%
          inner_join(element_map, by = c("std_element" = "child"))

        non_mappable <- working_data %>%
          anti_join(element_map, by = c("std_element" = "child"))

        # Aggregate mappable elements
        aggregated <- mappable %>%
          group_by(parent) %>%
          summarize(count = sum(count, na.rm = TRUE)) %>%
          rename(std_element = parent)

        # Combine with non-mappable elements
        working_data <- bind_rows(non_mappable, aggregated)

        current_level <- intermediate_level
        cat("  Step", iteration, "| Level:", current_level, "| Elements:", nrow(working_data), "\n")
        iteration <- iteration + 1
      } else {
        warning(paste("Missing mapping:", mapping_name))
        break
      }
    }

    # Store final results
    if(nrow(working_data) > 0) {
      for(i in seq_len(nrow(working_data))) {
        element_name <- paste(part, working_data$std_element[i], sep = "_")
        new_mne[[element_name]] <- working_data$count[i]
      }
    }
  }

  # Convert to tibble with proper ordering
  new_mne_df <- tibble(
    element = names(new_mne),
    count = unlist(new_mne)
  )

  return(new_mne_df)
}



align_loaded_data <- function(one_skeleton, longer_elements, longer_counts) {

  shorter_elements <- sub(".*\\.", "",one_skeleton)
  longer_elements <- sub(".*\\_", "", gsub("\\.", " ", longer_elements))

  # Find the elements in the longer vector that are not in the shorter vector
  elements_to_remove <- longer_elements[!longer_elements %in% shorter_elements]

  # Find the positions of these elements in the longer vector
  positions_to_remove <- which(longer_elements %in% elements_to_remove)

  # Remove these elements and their corresponding counts from both vectors
  aligned_longer_elements <- longer_elements[-positions_to_remove]
  aligned_longer_counts <- longer_counts[-positions_to_remove]

  align_loaded_db <- data.frame(element = aligned_longer_elements, count = aligned_longer_counts)

  return(align_loaded_db)
}






