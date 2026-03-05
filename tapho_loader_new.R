source("meta_new_indet.R")
source("NewSiteDataLoader_new.R")
source("select_data_new.R")
source("data_loader_new.R")
source("archo_preload_2.R")
source("collapse_down_step.R")
source("indet.R")

library(dplyr)
library(tibble)
library(readxl)

summarize_bone_sections_zero_na <- function(input_df,
  method = "min",
  reference_df = elements_data) {

    # Ensure method is a single string
    method <- as.character(method)
    if (length(method) != 1) {
    stop("'method' must be a single value: 'min', 'max', or 'mode'. Got length = ", length(method))
    }

    input_df <- input_df %>%
    dplyr::filter(!is.na(count) & count != 0)

    bone_info_df <- add_bone_info(input_df, reference_df)

    sections_order <- c(
    "cranium","teeth","hyoid", "vertebrae", "thorax", "shoulder",
    "arms", "hands", "pelvic", "legs", "foot"
    )

    stat_mode <- function(x) {
    x <- x[!is.na(x)]
    if (length(x) == 0) return(NA_real_)
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
    }

    stat_fn <- switch(method,
    "min"  = function(x) min(x, na.rm = TRUE),
    "max"  = function(x) max(x, na.rm = TRUE),
    "mode" = stat_mode,
    stop("method must be 'min', 'max', or 'mode'. Got: ", method)
    )

    summary_df <- bone_info_df %>%
    dplyr::group_by(Skeleton_Section) %>%
    dplyr::summarize(min_level = stat_fn(max_Level), .groups = "drop")

    most_detailed_level <- c(5,5,1,3,4,3,3,5,4,3,5)
    result_vector <- stats::setNames(most_detailed_level, sections_order)

    for (section in sections_order) {
    if (section %in% summary_df$Skeleton_Section) {
    level <- summary_df$min_level[summary_df$Skeleton_Section == section]
    result_vector[section] <- if (is.na(level)) 1 else level
    }
    }

    unname(result_vector)
}


distribute_surplus <- function(counts, max_counts, n_indet) {
  if (n_indet == 0) return(counts)
  open_slots <- max_counts - counts
  if (sum(open_slots, na.rm=TRUE) < as.numeric(n_indet))
    stop("Not enough open slots to place all indeterminate specimens.")
  slot_pool <- rep(seq_along(counts), times = open_slots)
  chosen    <- sample(slot_pool, size = n_indet, replace = FALSE)
  for (i in chosen) counts[i] <- counts[i] + 1
  counts
}

collapse_up_step <- function(data, part, current_level, target_level) {
  key <- paste0(part, "_", current_level, "_to_", target_level)
  if (!key %in% names(category_hierarchy)) stop("Missing mapping: ", key)

  element_map <- stack(category_hierarchy[[key]]) %>%
    setNames(c("child", "parent")) %>%
    mutate(across(everything(), \(x) gsub(" ", ".", x)))

  mappable     <- inner_join(data, element_map, by = c("std_element" = "child"))
  non_mappable <- anti_join(data, element_map, by = c("std_element" = "child"))

  aggregated <- mappable %>%
    group_by(std_element = parent) %>%
    summarise(count = sum(count, na.rm = TRUE), .groups = "drop")

 data <-  full_join(non_mappable, aggregated, by = "std_element") %>%
    mutate(count = coalesce(count.x, 0) + coalesce(count.y, 0)) %>%
    select(std_element, count)


  full_join(non_mappable, aggregated, by = "std_element") %>%
    mutate(count = coalesce(count.x, 0) + coalesce(count.y, 0)) %>%
    select(std_element, count)
  }




drop_indet_if_possible <- function(x) {
  x <- gsub(" ", ".", x)
  if (length(x) > 1) {
    tmp <- x[!grepl("_indet$", x)]
    if (length(tmp) > 0) return(tmp)
  }
  x
}



collapse_down_step <- function(data, part, current_level, target_level,section_name, MNI) {
  key         <- paste0(part, "_", target_level, "_to_", current_level)
  if (!key %in% names(category_hierarchy)) stop("Missing mapping: ", key)

  mapping      <- category_hierarchy[[key]]
  level_label  <- paste0("Level ", target_level)
  level_maxima <- skeleton_hierarchy[[section_name]][[level_label]]
#print(level_maxima)
  new_rows <- purrr::map_dfr(names(mapping), function(parent_elem) {

    parent_clean <- gsub(" ", ".", parent_elem)
    children     <- gsub(" ", ".", mapping[[parent_elem]])
    real_children <- drop_indet_if_possible(children)

    parent_count <- data %>%
      filter(std_element == parent_clean) %>%
      pull(count) %>%
      { if (length(.) == 0) 0L else . }

    existing_counts <- purrr::map_int(real_children, \(ch) {
      val <- data %>% filter(std_element == ch) %>% pull(count)
      if (length(val) == 0) 0L else as.integer(val)
    })

    max_counts <- purrr::map_int(real_children, \(ch) {
      base <- level_maxima[[ch]]
     # print("###############################    WTF      ########################################")
     # print("base :")
     # print(str(base))
     # print(base)
     # print("MNI : ")
     # print(str(MNI))
     # print(MNI)
  #print("#######################################################################")
      if (is.null(base)) 0L else as.integer(base * MNI)
    })


  if (length(real_children) == 1 && real_children[1] == parent_clean) {
    #if (part == "pelvic") {print("Pelvic: length(real_children) == 1 && real_children[1] == parent_clean") 
     # print(real_children)}
            return(tibble(std_element = real_children, count = as.integer(parent_count)))
      }

    surplus      <- max(0L, parent_count) # no double - sum(existing_counts))
    final_counts <- distribute_surplus(existing_counts, max_counts, surplus)
    if (part == "pelvic") {}

    tibble(std_element = real_children, count = final_counts)
  })

  parent_names <- gsub(" ", ".", names(mapping))
  child_names <- unique(gsub(" ", ".", unlist(mapping)))
  child_names <- drop_indet_if_possible(child_names)
  #if (part == "pelvic") {print("Pelvic: child_names & parent_names ") 
  #print(parent_names)
  #  print(child_names)
  #}
  data %>%
    filter(!std_element %in% c(parent_names, child_names)) %>%
    bind_rows(new_rows)

}

is_special <- function(part) part %in% c("pelvic", "cranium")

recal_mne_six <- function(current_mne, target_levels, skeleton_hierarchy,
  bone_names, sections_order, MNI) {
    max_levels <- c(5, 5, 1, 3, 4, 3, 3, 5, 4, 3, 5)
    min_levels <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
    working_base <- tibble(count = current_mne, element = bone_names) %>%
    add_bone_info() %>%
    mutate(std_element = gsub(" ", ".", element))

    purrr::imap(sections_order, \(part, i) {
    data <- working_base %>%
    filter(Skeleton_Section == part) %>%
    select(std_element, count)

    current_max <- max_levels[i]
    current_min <- min_levels[i]
    tgt <- target_levels[i]

    # Pass 1 — collapse from finest detail down to target
    while (current_max > tgt) {
    step_up_level <- current_max - 1
    print("up: from to ")
    print(current_max)
    print(step_up_level)
      if (is_special(part)){
        data <- collapse_up_step_special(data, part,
          current_level = current_max,
          target_level  = step_up_level)
      } 
      else{
          data <- collapse_up_step(data, part,
                current_level = current_max,
                target_level  = step_up_level)}
    current_max <- current_max - 1
    print(data, n=42)
    }

    # Pass 2 — expand from coarsest detail up to target
    while (current_min < tgt) {
      print("down: from to ")
          print(current_min)
    print(current_min + 1)
    if (is_special(part)){   
          data <- collapse_down_step_special(data, part,
                        current_level = current_min,
                        target_level  = current_min + 1,
                        section_name  = part,
          MNI           = MNI)}
      else{
        data <- collapse_down_step(data, part,
                current_level = current_min,
                target_level  = current_min + 1,
                section_name  = part,
                MNI           = MNI)}
    current_min <- current_min + 1
    
    print(data, n=42)
   # if (part == "pelvic") { print(data$)}
    }

    data
    }) %>%
    bind_rows() %>%
    rename(element = std_element)
}


align_counts_to_skeleton <- function(one_skeleton_element,
  recalc_element,
  recalc_count,
  fill_value = NA,
  aggregate = c("sum", "first")) {
aggregate <- match.arg(aggregate)

# Build a lookup table (handle duplicate elements in recalc data)
recalc_df <- data.frame(element = recalc_element, count = recalc_count)

if (aggregate == "sum") {
recalc_df <- aggregate(count ~ element, data = recalc_df, FUN = sum)
} else if (aggregate == "first") {
recalc_df <- recalc_df[!duplicated(recalc_df$element), ]
}

# Match skeleton elements to recalc counts
aligned_counts <- recalc_df$count[match(one_skeleton_element, recalc_df$element)]

# Fill missing matches if requested
aligned_counts[is.na(aligned_counts)] <- fill_value

# Output aligned dataframe
align_loaded_db <- data.frame(
element = one_skeleton_element,
count = aligned_counts
)

return(align_loaded_db)
}
########################################### tapho-r loader function sum=0 ##############
tapho.load <- function(new_site_data, strict = FALSE) {

  #Validate & coerce first (warn now, not later)
  new_site_data <- archo_preload_site_table(new_site_data, strict = strict)

  ind_name <- colnames(new_site_data)[2]

  colnames(new_site_data) <- c("element", "count")

  new_site_meta <- new_site_data[1:31, , drop = FALSE]
  new_site_raw  <- new_site_data[-c(1:31), , drop = FALSE]

  # NA skeletal values
  new_site_raw$count <- as.numeric(new_site_raw$count)
  new_site_raw$count[is.na(new_site_raw$count)] <- 0
  #MNI
  MNI <- as.numeric(new_site_meta[18,]$count)


  #_indet/_fragments out/in
  new_site_raw <- resolve_indeterminate(new_site_raw, MNI, indet = FALSE,  indet_method = "up")

  #print(new_site_raw) 
  target_levels <- summarize_bone_sections_zero_na(new_site_raw)


  #print("########################################### tapho-r loader function sum=0 ##############")
  #print(new_site_raw$count)
  #print("########################################### tapho-r loader function sum=0 ##############")

  #mni <- new_site_data[18,2]
  mni <- suppressWarnings(as.numeric(new_site_data$count[18]))

  recalc_new_site_raw <- recal_mne_six(
    as.numeric(new_site_raw$count),
    target_levels,
    skeleton_hierarchy,
    new_site_raw$element,
    sections_order,
    mni
  )

  #print("########################################### tapho-r loader function sum=0 ##############")
  #print(recalc_new_site_raw)
  #print("########################################### tapho-r loader function sum=0 ##############")

  one_skeleton <- get_bones_dataframe(target_levels)
  #(one_skeleton)
  # print(recalc_new_site_raw)
  data_aligned <- align_counts_to_skeleton(
    one_skeleton$element,
    recalc_new_site_raw$element,
    recalc_new_site_raw$count
  )

  #  FIXED CALL SIGNATURE: pass meta DF, not meta$count
  tapho_loaded <- loaded_tapho(
    ind_name     = ind_name,
    meta         = new_site_meta,
    level        = target_levels,
    col_element  = data_aligned$element,
    col_count    = data_aligned$count,
    strict       = strict
  )

  return(tapho_loaded)
}

########################################### tapho-r loader function sum=False, ie db and sheets ##############
tapho.load.db <- function(data) {
  tb <- tapho.load(data[, 1:2])

  if (tb$count_type == FALSE) { 
  for (i in 3:ncol(data)) {
    one_column <- data[, c(1,i)]
    #one_column <- one_column %>% rename(count = !!paste0("count", i-1))
    tb_one <- tapho.load(one_column)
    tb <- tb %>% add_row(tb_one)
  }}

  return(tb)
}



library(dplyr)

# Define the function to read an Excel file with multiple sheets
read_excel_sheets <- function(file_path) {
  
  # Get all sheet names in the Excel file
  sheet_names <- readxl::excel_sheets(file_path)
  print(sheet_names)
  # Read each sheet, process it, and store in a list
  processed_list <- lapply(sheet_names, function(sname) {
    
    # Read the current sheet
    sheet_data <- readxl::read_excel(file_path, sheet = sname)
    
    # Process it using your tapho.load.db() function
    processed_sheet <- tapho.load.db(sheet_data)
    
    # Optionally, you might want to keep track of which sheet it came from
    # processed_sheet <- processed_sheet %>% 
    #   mutate(sheet_name = sname)
    
    processed_sheet
  })
  
  # Combine all processed sheets into one tibble
  combined_df <- bind_rows(processed_list)
  
  return(combined_df)
}