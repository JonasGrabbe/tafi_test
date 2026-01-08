source("meta.R")
source("NewSiteDataLoader.R")
source("select_data.R")
source("data_loader.R")


generate_special_vector <- function(seed = 123) {
  # Set the seed for reproducibility
  #set.seed(seed)

  # Initialize the vector with length 281
  vec <- numeric(281)

  # Randomly assign 100 entries as NA
  na_indices <- sample(1:281, 100)
  vec[na_indices] <- NA

  # Randomly assign 100 entries as 0
  zero_indices <- sample(setdiff(1:281, na_indices), 100)
  vec[zero_indices] <- 0

  # Fill the remaining entries with random integers between 1 and 9
  remaining_indices <- setdiff(1:281, union(na_indices, zero_indices))
  vec[remaining_indices] <- sample(1:9, length(remaining_indices), replace = TRUE)

  return(vec)
}

generate_dataset_new <- function(n_samples) {
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

  # Define site_index
  site_index <- paste0("Site_", 1:n_samples)

  # Create the dataset
  dataset <- c(
    1:n_samples,  # Sample index
    site_index,  # Site index
    paste0("Site_", 1:n_samples),  # Site name
    rep(1, n_samples),  # Sum (set to 1 for all rows)
    sample(time_range, n_samples, replace = TRUE),
    sample(geological_context, n_samples, replace = TRUE),
    sample(1:125, n_samples, replace = TRUE),
    sample(age_category, n_samples, replace = TRUE),
    sample(gender, n_samples, replace = TRUE),
    sample(accumulation_cause, n_samples, replace = TRUE),
    sample(hominin_species, n_samples, replace = TRUE)
  )


  return(dataset)
}

rnd_taphor_site_data<-function(metas=meta_names,whole=elements_data$ElementsOne){

  vec <- c(2, NA, 0, NA, 0, 6, NA, 0, NA, NA, NA, 0, 0, 0, 0, 0, NA, 0, 3, 0, NA, 7, NA, NA,
           NA, 0, 3, 0, 0, 0, NA, 0, 0, 7, NA, NA, 0, 7, 0, 7, 0, NA, 7, 0, 8, 0, 8, NA,
           NA, NA, 0, 0, NA, 1, 5, NA, 9, 1, NA, 6, 0, 9, 0, NA, 0, NA, NA, NA, NA, NA, NA, NA,
           0, NA, 8, NA, 0, 8, NA, 7, 7, 0, 0, 1, 0, 9, 0, NA, NA, NA, 8, 3, NA, 0, 8, 0,
           6, 0, 0, 0, NA, 0, 1, 4, NA, NA, 0, NA, NA, NA, NA, NA, 3, 5, 0, 0, 0, 0, NA, NA,
           0, NA, 0, NA, 0, 7, 0, NA, NA, NA, NA, 2, NA, 8, NA, 0, 0, 0, 0, 0, 0, 8, NA, 4,
           8, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 2, 0, 1, 9, NA, NA, 3, 0, 0, 0, NA, NA, 0,
           NA, 5, NA, NA, NA, 0, NA, 5, 9, 0, 4, NA, 3, 3, 6, NA, 4, 0, 0, NA, NA, 7, 0, 0,
           9, 3, 6, 5, NA, 0, 9, 0, 4, NA, 3, 7, 4, 5, NA, 8, NA, 7, 0, 8, 6, 0, NA, 0,
           NA, 8, 7, NA, 1, NA, 0, NA, 0, 6, 0, 6, NA, NA, NA, NA, NA, 4, 0, 0, NA, NA, NA, 9,
           9, NA, NA, 0, 4, 0, 0, NA, 0, 0, 0, NA, 0, NA, 5, 9, NA, 3, NA, NA, NA, 0, NA, NA,
           NA, NA, 0, 3, 0, 0, 2, 0, 0, 0, NA, 0, 0, 7, NA, 1, 0)


  random_strings <- generate_dataset_new(1)
  special_vector <- generate_special_vector()
  #special_vector <- vec


  element_column <- c(metas, whole)
  count_column <- c(random_strings, special_vector)


  tibble <- tibble::tibble(element = element_column,count = count_column)

  return(tibble)
}
