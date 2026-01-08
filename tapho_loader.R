source("meta.R")
source("NewSiteDataLoader.R")
source("select_data.R")
source("data_loader.R")

library(dplyr)
library(tibble)

summarize_bone_sections_zero_na <- function(input_df, reference_df = elements_data) {
  # Filter out rows where input_df$element is 0 or NA
  input_df <- input_df %>%
    filter(!is.na(input_df$count) & input_df$count != 0)


  # Add bone info using the filtered input_df
  bone_info_df <- add_bone_info(input_df, reference_df)

  # Define the ordered list of skeleton sections
  sections_order <- c("Skull", "Hyoid", "Vertebrae", "Thorax", "Shoulder",
                      "Arms", "Hands", "Pelvic", "Legs", "Foot")

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
  current_levels = c(5,1,3,4,3,3,5,4,3,5)


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

loaded_tapho <- function(meta, level, col_element, col_count) {
  # Ensure that level is a 10-element vector
  if (length(level) != 10) {
    stop("The level vector must have exactly 10 elements.")
  }

  # Ensure that col_element and col_count are of the same length
  if (length(col_element) != length(col_count)) {
    stop("The length of col_element and col_count must be the same.")
  }

  # Create the tibble with the specified columns
  dataset <- tibble::tibble(
    site_index = meta[1],
    sample_index = meta[2],
    site_name = meta[3],
    sum = meta[4],
    time_range = meta[5],
    geological_context = meta[6],
    number_of_individuals = meta[7],
    age = meta[8],
    gender = meta[9],
    accumulation_cause = meta[10],
    hominin_species = meta[11],
    bone.level = list(level),  # Store level as a list
    element = list(col_element),  # Store col_element as a list
    count = list(col_count)  # Store col_count as a list
  )

  return(dataset)
}

########################################### tapho-r loader function sum=0 ##############
tapho.load <- function(new_site_data){

  new_site_meta <- new_site_data[1:11,]
  new_site_raw <- new_site_data[-c(1:11),]
  target_levels <- summarize_bone_sections_zero_na(new_site_raw)

  new_site_raw$count[is.na(new_site_raw$count)] <- 0

  recalc_new_site_raw <- recal_mne_six(as.numeric(new_site_raw$count), target_levels, skeleton_hierarchy, new_site_raw$element, sections_order)

  one_skeleton = get_bones_dataframe(target_levels)

  data_aligned <- align_loaded_data(one_skeleton$element, recalc_new_site_raw$element, recalc_new_site_raw$count)

  tapho_loaded <- loaded_tapho(new_site_meta$count, target_levels, data_aligned$element, data_aligned$count)

  return(tapho_loaded)

}
