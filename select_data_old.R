select_data <- function(
  data,
  time_range_filter = NULL,
  geological_context_filter = NULL,
  number_of_individuals_filter = NULL,
  age_filter = NULL,
  gender_filter = NULL,
  accumulation_cause_filter = NULL,
  bone_parts_filter = NULL,
  site_name_filter = NULL,
  sum_filter = NULL,
  hominin_species_filter = NULL
) {
  library(dplyr)
  
  data_filtered <- data
  
  # Filter based on metadata fields
  if (!is.null(time_range_filter)) {
    data_filtered <- data_filtered %>%
      filter(time_range %in% time_range_filter)
  }
  
  if (!is.null(geological_context_filter)) {
    data_filtered <- data_filtered %>%
      filter(geological_context %in% geological_context_filter)
  }
  
  if (!is.null(number_of_individuals_filter)) {
    if (length(number_of_individuals_filter) == 1) {
      data_filtered <- data_filtered %>%
        filter(number_of_individuals == number_of_individuals_filter)
    } else {
      data_filtered <- data_filtered %>%
        filter(number_of_individuals >= min(number_of_individuals_filter),
               number_of_individuals <= max(number_of_individuals_filter))
    }
  }
  
  if (!is.null(age_filter)) {
    data_filtered <- data_filtered %>%
      filter(age %in% age_filter)
  }
  
  if (!is.null(gender_filter)) {
    data_filtered <- data_filtered %>%
      filter(gender %in% gender_filter)
  }
  
  if (!is.null(accumulation_cause_filter)) {
    data_filtered <- data_filtered %>%
      filter(accumulation_cause %in% accumulation_cause_filter)
  }
  
  if (!is.null(site_name_filter)) {
    data_filtered <- data_filtered %>%
      filter(site_name %in% site_name_filter)
  }
  
  if (!is.null(sum_filter)) {
    data_filtered <- data_filtered %>%
      filter(sum %in% sum_filter)
  }
  
  if (!is.null(hominin_species_filter)) {
    if ("hominin_species" %in% colnames(data_filtered)) {
      data_filtered <- data_filtered %>%
        filter(hominin_species %in% hominin_species_filter)
    } else {
      warning("The 'hominin_species' field is not present in the data.")
    }
  }
  
  # Filter based on 'element' without unnesting 'bone.level'
  if (!is.null(bone_parts_filter)) {
    data_filtered <- data_filtered %>%
      rowwise() %>%
      filter(any(element %in% bone_parts_filter)) %>%
      ungroup()
  }
  
  return(data_filtered)
}


############################


get_min <- function(selected_data) {

  # Convert the 'bone.level' list-column to a data frame
  bone_levels_df <- selected_data %>%
    # Select only the 'bone.level' column to simplify
    select(bone.level) %>%
    # Unnest the 'bone.level' list into wider format
    unnest_wider(bone.level)
  
  # Calculate the minimum for each bone section
  min_bone_level <- bone_levels_df %>%
    summarise(across(everything(), ~ min(.x, na.rm = TRUE)))
  
  # Convert to a named vector for easier use
  min_bone_level_vec <- as.numeric(min_bone_level)
  names(min_bone_level_vec) <- colnames(min_bone_level)
  
  # Display the result
  return (unname(min_bone_level_vec))
  }


##########################


recalculate_counts <- function(data_filtered) {
  library(dplyr)
  library(tidyr)
  library(purrr)
  
  #### Integration of recal_mne function ####
  
  # Calculate the minimum bone level across the filtered data
  min_bone_level <- get_min(data_filtered)
  
  # Recalculate 'bone.level' to the minimum bone level
  data_recalculated <- data_filtered %>%
    mutate(bone.level = list(min_bone_level))
  
  # Recalculate counts and elements for each row
  recalculated_list <- pmap(
    list(data_recalculated$count, data_recalculated$bone.level, data_recalculated$element),
    function(count_i, bone_level_i, element_i) {
      recal_mne(
        current_mne = unlist(count_i),
        current_levels = bone_level_i,
        target_levels = min_bone_level,
        skeleton_hierarchy = skeleton_hierarchy,
        bone_names = unlist(element_i),
        sections_order = sections_order
      )
    }
  )
  
  # Extract elements and counts from recalculated results
  data_recalculated <- data_recalculated %>%
    mutate(
      recalculated = recalculated_list,
      element = map(recalculated, "element"),
      count = map(recalculated, "count")
    ) %>%
    select(-recalculated)
  
  # Ensure that all samples have counts for the same set of elements
  # Collect all unique elements across the data
  unique_elements <- data_recalculated %>%
    pull(element) %>%
    unlist() %>%
    unique()
  
  # Sort the unique elements for consistency
  unique_elements <- sort(unique_elements)
  
  # Align counts across all rows by creating a consistent element list
  data_recalculated <- data_recalculated %>%
    mutate(
      count_vector = map2(element, count, ~ setNames(.y, .x)),
      aligned_counts = map(count_vector, ~ {
        counts <- .x[unique_elements]
        counts[is.na(counts)] <- 0
        counts
      })
    )
  
  # Create a wide-format data frame with elements as columns
  counts_df <- data_recalculated %>%
    select(aligned_counts) %>%
    mutate(sample_id = row_number()) %>%
    unnest_wider(aligned_counts)
  
  # Combine the counts with the original data
  data_recalculated <- data_recalculated %>%
    select(-count_vector, -aligned_counts, -count, -element) %>%
    bind_cols(counts_df %>% select(-sample_id))
  
  # Now, 'data_recalculated' has counts for each element aligned across all samples
  return(data_recalculated)
}
