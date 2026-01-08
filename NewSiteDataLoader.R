library(tibble)
library(dplyr)
library(purrr)

source("meta.R")

#Function generats random bone.level vector 
generate_skeletal_inventory <- function() {
  inventory <- list(
    Skull = sample(2:5, 1),
    Hyoid = sample(1:1, 1),
    Vertebrae = sample(1:3, 1),
    Thorax = sample(1:4, 1),
    Shoulder = sample(1:3, 1),
    Arms = sample(1:3, 1),
    Hands = sample(1:5, 1),
    Pelvic = sample(1:4, 1),
    Leg = sample(1:3, 1),
    Foot = sample(1:5, 1)
  )

  # Remove zero entries
  inventory[inventory == 0] <- NA
  return(inventory)
}



generate_dataset <- function(n_samples) {
  # Define the metadata
  time_range <- c(
    "Zanclean", "Piacenzian", "Gelasian", "Calabrian", "Chibanian", "Tarantian",
    "Oldowan", "Acheulean", "Mousterian", "Aterian", "Aurignacian", "Gravettian",
    "Solutrean", "Magdalenian", "Natufian", "Kebaran", "Azilian", "Maglemosian",
    "Pre-Pottery Neolithic A", "Pre-Pottery Neolithic B", "Pottery Neolithic",
    "Chalcolithic", "Early Bronze Age", "Middle Bronze Age", "Late Bronze Age",
    "Early Iron Age", "Middle Iron Age", "Late Iron Age",
    "Medieval Period", "Early Modern Period", "Late Modern Period"
  )

  age_category <- c(
    "Infant (0-2 years)",
    "Child (3-7 years)",
    "Adolescent (8-16 years)",
    "Subadult",  # General category if specific age is not available
    "Adult (17+ years)"
  )

  gender <- c("Male", "Female", "Unknown")

  accumulation_cause <- c(
    "Cannibalism", "Burial", "Collective burial", "Mass graves",
    "Secondary position", "Surface disposal", "Disposal", "Scavenged",
    "Intentional accumulation", "Funerary assemblage", "Cemetery",
    "Cuevas Sepulcrales", "Transport or accumulation from carnivores",
    "Possible burial"
  )

  geological_context <- c(
    "Cave", "Sepulchral Cave", "Rockshelter", "Open air", "Surface disposal"
  )

  hominin_species <- c(
    "Australopithecus anamensis", "Australopithecus afarensis",
    "Australopithecus africanus", "Paranthropus aethiopicus",
    "Homo habilis", "Homo rudolfensis", "Paranthropus boisei",
    "Paranthropus robustus", "Homo ergaster", "Homo erectus",
    "Homo antecessor", "Homo heidelbergensis",
    "Neanderthals (Homo neanderthalensis)", "Denisovans",
    "Homo naledi", "Homo sapiens"
  )

  dataset <- tibble::tibble(
    site_index = 1:n_samples,
    sample_index = paste0(site_index, 1:n_samples),
    site_name = paste0("Site_", 1:n_samples),  # Set site_name based on index
    sum = 1,  # Set sum to 1 for all rows
    time_range = sample(time_range, n_samples, replace = TRUE),
    geological_context = sample(geological_context, n_samples, replace = TRUE),
    number_of_individuals = sample(1:125, n_samples, replace = TRUE),
    age = sample(age_category, n_samples, replace = TRUE),
    gender = sample(gender, n_samples, replace = TRUE),
    accumulation_cause = sample(accumulation_cause, n_samples, replace = TRUE),
    hominin_species = sample(hominin_species, n_samples, replace = TRUE)
  )
  
  # Add bone.level as a list column using the skeletal inventory generation function
  dataset <- dataset %>%
    mutate(bone.level = map(1:n_samples, ~generate_skeletal_inventory()))
  
  return(dataset)
}

manipulate_rows <- function(hpa) {
  # Define metadata for generating individual-specific data
  age_category <- c(
    "Infant (0-2 years)",
    "Child (3-7 years)",
    "Adolescent (8-16 years)",
    "Subadult",  # General category if specific age is not available
    "Adult (17+ years)"
  )
  
  gender_category <- c("Male", "Female", "Unknown")
  
  # Identify positions of small_samples in the original data
  small_samples_indices <- which(hpa$number_of_individuals < 15 & hpa$number_of_individuals > 0)
  
  # Initialize a list to store the data frames in order
  data_list <- list()
  
  # Initialize a counter for the data_list
  list_counter <- 1
  
  # Iterate over each row of the original dataset
  for (i in seq_len(nrow(hpa))) {
    row_data <- hpa[i, ]
    if (i %in% small_samples_indices) {
      # Expand the row by number_of_individuals
      expanded_row <- row_data %>%
        uncount(number_of_individuals, .remove = FALSE)
      
      # Generate individual-specific data and set sum and number_of_individuals
      expanded_row <- expanded_row %>%
        mutate(
          sum = 0,
          number_of_individuals = 1,
          sample_index = paste0(site_index, "_", seq_len(n())),
          age = sample(age_category, n(), replace = TRUE),
          gender = sample(gender_category, n(), replace = TRUE),
          bone.level = map(1:n(), ~generate_skeletal_inventory())
        )
      
      # Add expanded rows to the data list
      data_list[[list_counter]] <- expanded_row
    } else {
      # Keep the original row
      data_list[[list_counter]] <- row_data
    }
    list_counter <- list_counter + 1
  }
  
  # Combine all data frames in the list
  final_dataset <- bind_rows(data_list)
  
  # Reorder columns if necessary
  final_dataset <- final_dataset %>%
    select(
      site_index, sample_index, site_name, sum, time_range, geological_context,
      number_of_individuals, age, gender, accumulation_cause, hominin_species, bone.level
    )
  
  return(final_dataset)
}


generate_element_count <- function(bone_level) {
  
  # Extract the skeletal data from the bone_level using get_bones_dataframe
  # Assuming get_bones_dataframe returns a dataframe with columns "Element" and "Count"
  skeleton_tb <- get_bones_dataframe(bone_level)
  
  # Modify the Count values by applying generate_scaled_integer() function
  skeleton_tb$count <- sapply(skeleton_tb$count, generate_scaled_integer)
  
  # Return a list with two elements: the bone elements and the modified counts
  list(
    element = skeleton_tb$element,  # List of bone elements
    count = skeleton_tb$count       # List of modified bone counts
  )
}

# Example usage inside add_element_count function
add_element_count <- function(dataset) {
  dataset <- dataset %>%
    mutate(
      element_count = map(bone.level, generate_element_count),  # Generate elements and counts for each row
      element = map(element_count, "element"),  # Extract element from the list
      count = map(element_count, "count")  # Extract count from the list
    ) %>%
    select(-element_count)  # Drop the temporary column
  
  return(dataset)
}


# Function to look up bones and return a dataframe with correct element-count mapping
get_bones_dataframe <- function(levels_vector) {

  # Ensure the levels_vector has exactly 10 elements
  if (length(levels_vector) != 10) {
    stop("The input vector must have exactly 10 elements.")
  }

  # Sections in the skeleton hierarchy
  sections <- c("Skull", "Hyoid", "Vertebrae", "Thorax", "Shoulder", "Arms", "Hands", "Pelvic", "Legs", "Foot")

  # Initialize a list to store the elements and counts
  elements <- c()
  counts <- c()

  # Loop through each section and level
  for (i in seq_along(sections)) {
    section <- sections[i]
    level <- paste0("Level ", levels_vector[i])

    # Extract the corresponding bones and counts at the specified level
    bones_at_level <- skeleton_hierarchy[[section]][[level]]

    # If the result is a list, unlist it; otherwise, just use it as is
    if (is.list(bones_at_level)) {
      bones_flat <- unlist(bones_at_level)
    } else {
      bones_flat <- bones_at_level
    }

    # Append names (elements) and counts to the vectors
    elements <- c(elements, names(bones_flat))
    counts <- c(counts, as.numeric(bones_flat))
  }

  # Convert the vectors to a dataframe
  df <- data.frame(
    element = elements,
    count = counts,
    stringsAsFactors = FALSE
  )

  return(df)
}

generate_scaled_integer <- function(max_values) {
  # Generate a vector of random numbers using the mirrored exponential distribution
  random_numbers <- generate_mirrored_exponential(length(max_values), transform_power = 0.5)

  # Scale the random numbers by max_values
  scaled_values <- max_values * random_numbers

  # Convert to integers using a rounding convention (cutoff of 0.5)
  rounded_values <- ifelse(scaled_values - floor(scaled_values) >= 0.5, ceiling(scaled_values), floor(scaled_values))

  return(rounded_values)
}

generate_mirrored_exponential <- function(n, transform_power = 1) {
  lambda <- 2.5 # Rate parameter for the exponential distribution

  # Generate n random numbers from the exponential distribution
  exp_random <- rexp(n, rate = lambda)

  # Apply a power transformation to adjust the distribution shape
  exp_random_transformed <- exp_random^transform_power

  # Reflect the distribution over [0, 1]
  mirrored_random <- 1 - exp_random_transformed

  # Ensure the values are within the [0, 1] range
  mirrored_random <- pmax(0, pmin(1, mirrored_random))

  return(mirrored_random)
}



