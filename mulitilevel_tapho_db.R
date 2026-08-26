build_multilevel_tapho_features <- function(
  excel_path,
  position_max = c(5, 1, 1, 3, 4, 3, 3, 5, 4, 3, 5),
  levels = 1:5,
  source_scripts = TRUE,
  source_loader = "tapho_loader_new.R",
  source_wfl = "tapho_loader_wfl_features.R",
  append_range = c("sum_count", "mne_cranium")
) {
  library(dplyr)
  library(tidyr)

  if (source_scripts) {
    source(source_loader)
    source(source_wfl)
  }

  feature_cols <- c(
    "MNE", "MNAU", "MAU", "PercentMAU", "PercentMNAU",
    "ReMNAU", "AcReMNAU", "CumulativeReMNAU",
    "ProportionalRep_MNIbased"
  )

  assemblage_first_cols <- c(
    "MNI_used_assemblage",
    "Mean_MNAU_assemblage",
    "Mean_part_abundance",
    "OverallProportionalRep_assemblage"
  )

  raw_list_cols_drop <- c(
    "bone.level",
    "element",
    "One_Skeleton_count",
    "Skeleton_Section"
  )

  raw_list_names <- c(
    raw_list_cols_drop,
    feature_cols
  )

  first_value <- function(x) {
    if (is.null(x) || length(x) == 0) {
      return(NA_real_)
    }

    x <- unlist(x, recursive = TRUE, use.names = FALSE)

    if (length(x) == 0) {
      return(NA_real_)
    }

    x[[1]]
  }

  name_by_element_lvl <- function(vec, elems, k) {
    vec   <- unlist(vec, use.names = FALSE)
    elems <- unlist(elems, use.names = FALSE)

    n <- min(length(vec), length(elems))

    if (n == 0) {
      return(vec[0])
    }

    vec   <- vec[seq_len(n)]
    elems <- elems[seq_len(n)]

    ok <- !is.na(elems) &
      elems != "" &
      !grepl("^[0-9]+$", elems)

    vec   <- vec[ok]
    elems <- elems[ok]

    names(vec) <- paste0(elems, "_lvl_", k)

    vec
  }

  make_one_level <- function(k) {
    lvl <- pmin(k, position_max)

    cat("Step", k, ":", lvl, "\n")

    result <- tapho.loader.wfl.features(
      excel_path,
      level = lvl
    )

    appended <- dplyr::filter(result$db_id, count_type == FALSE) |>
      dplyr::mutate(site_id = as.character(site_id))

    tapho_db <- dplyr::bind_rows(
      result$db_sum,
      appended
    )

    feature_cols_here <- intersect(feature_cols, names(tapho_db))
    assemblage_cols_here <- intersect(assemblage_first_cols, names(tapho_db))

    if (!"element" %in% names(tapho_db)) {
      stop("Column `element` is missing from `tapho_db`.")
    }

    tb <- tapho_db |>
      dplyr::mutate(
        dplyr::across(
          dplyr::all_of(assemblage_cols_here),
          ~ vapply(.x, first_value, numeric(1))
        ),
        dplyr::across(
          dplyr::all_of(feature_cols_here),
          ~ Map(
            function(x, e) name_by_element_lvl(x, e, k),
            .x,
            element
          )
        )
      ) |>
      dplyr::select(-dplyr::any_of(raw_list_cols_drop)) |>
      tidyr::unnest_wider(
        dplyr::all_of(feature_cols_here),
        names_sep = "_",
        names_repair = "unique"
      )

    tb
  }

  keep_append_range <- function(tb, k) {
    start_col <- append_range[[1]]
    end_col   <- append_range[[2]]
  
    start_idx <- match(start_col, names(tb))
    end_idx   <- match(end_col, names(tb))
  
    if (is.na(start_idx) || is.na(end_idx)) {
      warning(
        "Could not find exclusive append range between `",
        start_col,
        "` and `",
        end_col,
        "` for level ",
        k,
        ". Keeping only columns ending in `_lvl_",
        k,
        "`."
      )
  
      keep_cols <- grep(
        paste0("_lvl_", k, "$"),
        names(tb),
        value = TRUE
      )
  
    } else if ((end_idx - start_idx) <= 1) {
      warning(
        "No columns found between `",
        start_col,
        "` and `",
        end_col,
        "` for level ",
        k,
        "."
      )
  
      keep_cols <- character(0)
  
    } else {
      keep_cols <- names(tb)[(start_idx + 1):(end_idx - 1)]
      keep_cols <- setdiff(keep_cols, raw_list_names)
    }
  
    out <- tb[, keep_cols, drop = FALSE]
  
    suffix <- paste0("_lvl_", k)
  
    names(out) <- ifelse(
      grepl(paste0(suffix, "$"), names(out)),
      names(out),
      paste0(names(out), suffix)
    )
  
    out
  }

  tb_levels <- vector("list", length(levels))
  names(tb_levels) <- paste0("lvl_", levels)

  for (i in seq_along(levels)) {
    k <- levels[[i]]
    tb_levels[[i]] <- make_one_level(k)
  }

  tb_out <- tb_levels[[1]]

  if (length(tb_levels) > 1) {
    for (i in 2:length(tb_levels)) {
      k <- levels[[i]]

      tb_out <- dplyr::bind_cols(
        tb_out,
        keep_append_range(tb_levels[[i]], k)
      )
    }
  }

  attr(tb_out, "level_tables") <- tb_levels

  tb_out
}