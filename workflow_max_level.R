# workflow_max_level.R
# ------------------------------------------------------------
# Load multi-sheet Excel (Tapho-R style), convert to internal Tapho tibble,
# select subset by metadata, and harmonize MNE to the *maximum* combined bone.level.
#
# This file intentionally uses explicit package namespaces (dplyr::, tidyr::, etc.)
# so it works even if packages aren't attached.
#
# REQUIRED objects/functions expected elsewhere in your project:
# - meta.R must define: elements_data, skeleton_hierarchy, category_hierarchy, meta_names (optional)
# - data_loader.R must define: add_bone_info()
# - tapho_loader.R must define: tapho.load()  (raw table -> internal tibble row)
# - select_data.R must define: select_data()  (metadata filtering + optional collapsing)
#
# Optional: if you don't have select_data(), you can still filter with dplyr manually.
# ------------------------------------------------------------
source("meta.R")
source("data_loader.R")     
source("tapho_loader.R")    
source("select_data.R")     

# ---------- helpers ----------

default_sections_order <- function() {
  c("Skull","Hyoid","Vertebrae","Thorax","Shoulder","Arms","Hands","Pelvic","Legs","Foot")
}

# Standardize element naming for matching:
# - remove "Section_" prefix (e.g., "Skull_frontal_bone" -> "frontal_bone") when section is known
# - remove family prefix before "." (e.g., "Neurocranium_bone.frontal_bone" -> "frontal_bone")
# - normalize spaces/dots to underscores
standardize_element_name <- function(x, sections_order = default_sections_order()) {
  x <- as.character(x)
  # Strip leading "<Section>_" if present
  x <- vapply(x, function(s) {
    m <- regexec("^([^_]+)_(.+)$", s)
    r <- regmatches(s, m)[[1]]
    if (length(r) == 3 && r[2] %in% sections_order) return(r[3])
    s
  }, character(1))
  # Strip family prefix before dot
  x <- sub("^[^.]+\\.", "", x)
  # Normalize separators
  x <- gsub("[ .]", "_", x)
  x <- gsub("__+", "_", x)
  tolower(x)
}


# Safe variant of add_bone_info() that works whether `element`/`count` are vectors or list-columns.
# Returns: data.frame with element, count, Level, Skeleton_Section.
add_bone_info_safe <- function(input_df, reference_df) {
  df <- input_df

  # If list-cols, unnest (element + count together if both are lists)
  if ("element" %in% names(df) && is.list(df$element)) {
    if ("count" %in% names(df) && is.list(df$count)) {
      df <- tidyr::unnest(df, cols = c(element, count))
    } else {
      df <- tidyr::unnest(df, cols = element)
    }
  }

  df <- dplyr::mutate(df,
                      element = as.character(.data$element),
                      element = stringr::str_replace(.data$element, "^[^.]+\\.", ""))

  missing_cols <- setdiff(c("ElementsOne","Level","Skeleton_Section"), names(reference_df))
  if (length(missing_cols) > 0) stop("reference_df missing columns: ", paste(missing_cols, collapse=", "))

  out <- dplyr::left_join(
    df,
    dplyr::select(reference_df, element = .data$ElementsOne, Level = .data$Level, Skeleton_Section = .data$Skeleton_Section),
    by = "element"
  )

  out
}

# Flatten skeleton_hierarchy section/level into a named numeric vector of expected counts.
# Names are standardized to match data element names.
get_section_expected <- function(section, level, skeleton_hierarchy, sections_order = default_sections_order()) {
  lvl_name <- paste0("Level ", level)
  if (is.null(skeleton_hierarchy[[section]]) || is.null(skeleton_hierarchy[[section]][[lvl_name]])) {
    stop(sprintf("skeleton_hierarchy missing %s / %s", section, lvl_name))
  }
  raw <- unlist(skeleton_hierarchy[[section]][[lvl_name]], recursive = TRUE, use.names = TRUE)
  nm <- names(raw)
  nm <- standardize_element_name(nm, sections_order = sections_order)
  out <- as.numeric(raw)
  names(out) <- nm
  # If duplicate names occur after standardization, sum them
  tapply(out, names(out), sum)
}

# Allocate an integer total across categories with weights, conserving sum.
# Returns integer vector summing to total.
allocate_integer_proportionally <- function(total, weights) {
  k <- length(weights)
  if (k == 1) return(as.integer(total))
  w <- as.numeric(weights)
  if (all(is.na(w)) || all(w <= 0)) w <- rep(1, k)
  w[w < 0] <- 0
  if (sum(w) == 0) w <- rep(1, k)
  p <- w / sum(w)
  raw <- total * p
  base <- floor(raw)
  rem <- as.integer(total - sum(base))
  if (rem > 0) {
    frac <- raw - base
    idx <- order(frac, decreasing = TRUE)[seq_len(rem)]
    base[idx] <- base[idx] + 1
  }
  as.integer(base)
}

# ---------- core: compute max bone levels ----------

get_max_levels <- function(data, sections_order = default_sections_order()) {
  # data$bone.level should be a list-column of named vectors/lists
  bl <- data$bone.level
  if (!is.list(bl) || length(bl) == 0) stop("data$bone.level must be a non-empty list-column")

  # Convert each entry to a numeric named vector aligned to sections_order
  bl_mat <- do.call(rbind, lapply(bl, function(x) {
    if (is.null(names(x)) && length(x) == length(sections_order)) {
      names(x) <- sections_order
    }
    x <- unlist(x)
    out <- rep(NA_real_, length(sections_order))
    names(out) <- sections_order
    for (s in sections_order) if (!is.null(x[[s]])) out[[s]] <- as.numeric(x[[s]])
    out
  }))

  apply(bl_mat, 2, function(col) max(col, na.rm = TRUE))
}

# ---------- core: promote counts to a higher target level (max-level harmonization) ----------

# Promote (refit) an element/count vector from current_levels to target_levels *without inventing new detail*:
# - if target contains the same element -> keep it
# - else if target contains children named "<element>_*" -> distribute counts across children
#   using expected-count weights from skeleton_hierarchy at target level.
# - else keep element unchanged (and optionally warn)
#
# Returns a tibble with standardized element names and counts.
promote_mne_to_target_levels <- function(bone_names,
                                        counts,
                                        current_levels,
                                        target_levels,
                                        sections_order = default_sections_order(),
                                        elements_data,
                                        skeleton_hierarchy,
                                        integer_allocation = TRUE,
                                        keep_unmapped = TRUE) {
  if (length(bone_names) != length(counts)) stop("bone_names and counts must have same length")

  # Attach section/level metadata
  df <- tibble::tibble(element = bone_names, count = counts)

  # Requires add_bone_info() from data_loader.R
  df_info <- add_bone_info_safe(df, reference_df = elements_data)

  # Standardize element names for matching
  df_info$element_std <- standardize_element_name(df_info$element, sections_order = sections_order)

  out_parts <- list()

  for (sec in sections_order) {
    sec_rows <- df_info[df_info$Skeleton_Section == sec, , drop = FALSE]
    if (nrow(sec_rows) == 0) next

    cur_lvl <- as.numeric(current_levels[[sec]])
    tgt_lvl <- as.numeric(target_levels[[sec]])

    # If already at or above target, keep names standardized and return as-is.
    # (In max-harmonization, typically cur <= tgt; this keeps it safe.)
    if (!is.finite(cur_lvl) || !is.finite(tgt_lvl) || cur_lvl >= tgt_lvl) {
      sec_out <- dplyr::summarise(dplyr::group_by(sec_rows, element_std), count = sum(count), .groups="drop")
      out_parts[[sec]] <- sec_out
      next
    }

    expected <- get_section_expected(sec, tgt_lvl, skeleton_hierarchy = skeleton_hierarchy, sections_order = sections_order)
    target_set <- names(expected)

    mapped_elements <- character(0)
    mapped_counts <- integer(0)

    for (i in seq_len(nrow(sec_rows))) {
      e <- sec_rows$element_std[i]
      c0 <- sec_rows$count[i]
      if (is.na(c0) || c0 == 0) next

      # Direct match at target
      if (e %in% target_set) {
        mapped_elements <- c(mapped_elements, e)
        mapped_counts   <- c(mapped_counts, as.integer(round(c0)))
        next
      }

      # Candidate children in target
      cand <- grep(paste0("^", gsub("([.^$|()\\[\\]{}*+?\\\\-])","\\\\\\1", e), "_"), target_set, value = TRUE)

      if (length(cand) > 0) {
        w <- expected[cand]
        if (integer_allocation && isTRUE(all(abs(c0 - round(c0)) < 1e-9))) {
          alloc <- allocate_integer_proportionally(as.integer(round(c0)), w)
        } else {
          # numeric allocation
          w2 <- as.numeric(w)
          if (all(is.na(w2)) || all(w2 <= 0)) w2 <- rep(1, length(cand))
          p <- w2 / sum(w2)
          alloc <- as.numeric(c0) * p
        }
        mapped_elements <- c(mapped_elements, cand)
        mapped_counts   <- c(mapped_counts, alloc)
        next
      }

      # No match: keep or drop
      if (keep_unmapped) {
        mapped_elements <- c(mapped_elements, e)
        mapped_counts   <- c(mapped_counts, as.integer(round(c0)))
      } else {
        # drop silently
      }
    }

    if (length(mapped_elements) == 0) next

    sec_out <- tibble::tibble(element_std = mapped_elements, count = mapped_counts) |>
      dplyr::group_by(element_std) |>
      dplyr::summarise(count = sum(count), .groups="drop")

    out_parts[[sec]] <- sec_out
  }

  if (length(out_parts) == 0) {
    return(tibble::tibble(element = character(0), count = numeric(0)))
  }

  out <- dplyr::bind_rows(out_parts) |>
    dplyr::group_by(element_std) |>
    dplyr::summarise(count = sum(count), .groups="drop") |>
    dplyr::rename(element = element_std)

  out
}

# Apply max-level harmonization across a selected dataset (internal format).
# Updates bone.level to the max vector and rewrites element/count lists per row.
recal_mne_selected_data_max <- function(selected_data,
                                       sections_order = default_sections_order(),
                                       elements_data,
                                       skeleton_hierarchy,
                                       integer_allocation = TRUE,
                                       keep_unmapped = TRUE) {
  if (!is.data.frame(selected_data)) stop("selected_data must be a data.frame/tibble")
  if (!("bone.level" %in% names(selected_data))) stop("selected_data must have bone.level")
  if (!("element" %in% names(selected_data)) || !("count" %in% names(selected_data))) {
    stop("selected_data must have element and count list-columns")
  }

  max_levels <- get_max_levels(selected_data, sections_order = sections_order)

  # Update each row
  promoted <- purrr::pmap(
    list(selected_data$element, selected_data$count, selected_data$bone.level),
    function(el, ct, bl) {
      # Align current level vector to sections_order
      if (is.null(names(bl)) && length(bl) == length(sections_order)) names(bl) <- sections_order
      cur_levels <- unlist(bl)
      # ensure named
      cur_vec <- setNames(rep(NA_real_, length(sections_order)), sections_order)
      for (s in sections_order) if (!is.null(cur_levels[[s]])) cur_vec[[s]] <- as.numeric(cur_levels[[s]])

      tgt_vec <- max_levels
      names(tgt_vec) <- sections_order

      df_out <- promote_mne_to_target_levels(
        bone_names = el,
        counts = ct,
        current_levels = cur_vec,
        target_levels = tgt_vec,
        sections_order = sections_order,
        elements_data = elements_data,
        skeleton_hierarchy = skeleton_hierarchy,
        integer_allocation = integer_allocation,
        keep_unmapped = keep_unmapped
      )
      list(element = df_out$element, count = df_out$count)
    }
  )

  selected_data$bone.level <- rep(list(as.list(max_levels)), nrow(selected_data))
  selected_data$element <- lapply(promoted, `[[`, "element")
  selected_data$count   <- lapply(promoted, `[[`, "count")

  selected_data
}

# ---------- IO: Excel -> internal Tapho tibble ----------

# Convert a "multi-count" raw table (element column + multiple count columns) into multiple internal-format rows.
tapho_load_db <- function(data,
                          element_col = 1,
                          count_cols = NULL,
                          count_prefix = "^count",
                          sheet_name = NA_character_) {
  if (!is.data.frame(data)) stop("data must be a data.frame/tibble")

  # Determine element column name
  if (is.numeric(element_col)) {
    element_col_name <- names(data)[element_col]
  } else {
    element_col_name <- element_col
  }
  if (is.null(element_col_name) || !(element_col_name %in% names(data))) stop("element_col not found")

  # Determine count columns
  if (is.null(count_cols)) {
    count_cols <- names(data)[grepl(count_prefix, names(data))]
    # If no count-prefixed columns, assume everything except element column is a count column
    if (length(count_cols) == 0) count_cols <- setdiff(names(data), element_col_name)
  }

  out_list <- lapply(count_cols, function(cc) {
    site_df <- dplyr::transmute(
      data,
      element = .data[[element_col_name]],
      count   = .data[[cc]]
    )
    tb_one <- tapho.load(site_df)
    tb_one$source_sheet <- sheet_name
    tb_one$source_count_col <- cc
    tb_one
  })

  dplyr::bind_rows(out_list)
}

# Read an Excel file (all sheets by default) and return one combined internal-format tibble.
read_excel_sheets_tapho <- function(file_path,
                                    sheets = NULL,
                                    element_col = 1,
                                    count_cols = NULL,
                                    count_prefix = "^count") {
  if (is.null(sheets)) sheets <- readxl::excel_sheets(file_path)

  out <- lapply(sheets, function(sh) {
    df <- readxl::read_excel(file_path, sheet = sh)
    tapho_load_db(df,
                 element_col = element_col,
                 count_cols = count_cols,
                 count_prefix = count_prefix,
                 sheet_name = sh)
  })

  dplyr::bind_rows(out)
}



# Create a wide (matrix-like) dataframe after max-level harmonization.
# Each element becomes a column; missing elements are filled with 0.
recalculate_counts_max <- function(data_filtered,
                                   sections_order = default_sections_order(),
                                   elements_data,
                                   skeleton_hierarchy,
                                   integer_allocation = TRUE,
                                   keep_unmapped = TRUE,
                                   fill_value = 0) {
  data_max <- recal_mne_selected_data_max(
    selected_data = data_filtered,
    sections_order = sections_order,
    elements_data = elements_data,
    skeleton_hierarchy = skeleton_hierarchy,
    integer_allocation = integer_allocation,
    keep_unmapped = keep_unmapped
  )

  all_elements <- unique(unlist(data_max$element))
  # Build per-row named vectors, then bind into a data.frame
  rows <- lapply(seq_len(nrow(data_max)), function(i) {
    el <- data_max$element[[i]]
    ct <- data_max$count[[i]]
    v <- setNames(rep(fill_value, length(all_elements)), all_elements)
    if (length(el) > 0) v[el] <- as.numeric(ct)
    v
  })

  mat <- do.call(rbind, rows)
  mat <- as.data.frame(mat, check.names = FALSE)

  # Keep metadata columns + wide counts
  meta_cols <- setdiff(names(data_max), c("element","count"))
  dplyr::bind_cols(data_max[meta_cols], mat)
}

# ---------- End-to-end convenience wrapper ----------

# End-to-end:
# 1) read Excel (all sheets) -> internal Tapho tibble
# 2) select subset using existing select_data() filters
# 3) harmonize to max bone.level across selected set (promote)
#
# Returns: list(data_selected = ..., data_max = ...)
workflow_load_select_recalc_max <- function(excel_path,
                                           sheets = NULL,
                                           element_col = 1,
                                           count_cols = NULL,
                                           count_prefix = "^count",
                                           # selection filters passed to select_data():
                                           ...,
                                           sections_order = default_sections_order(),
                                           elements_data,
                                           skeleton_hierarchy,
                                           integer_allocation = TRUE,
                                           keep_unmapped = TRUE) {
  data_all <- read_excel_sheets_tapho(
    file_path = excel_path,
    sheets = sheets,
    element_col = element_col,
    count_cols = count_cols,
    count_prefix = count_prefix
  )

  # Use your existing select_data() to filter by metadata and (optionally) collapse individuals.
  data_selected <- select_data(data_all, ...)

  data_max <- recal_mne_selected_data_max(
    selected_data = data_selected,
    sections_order = sections_order,
    elements_data = elements_data,
    skeleton_hierarchy = skeleton_hierarchy,
    integer_allocation = integer_allocation,
    keep_unmapped = keep_unmapped
  )

  list(data_selected = data_selected, data_max = data_max)
}
