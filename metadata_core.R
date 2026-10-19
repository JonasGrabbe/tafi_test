# metadata_core.R
# Shared metadata cleaning + hierarchy logic.
#
# Expected companion file:
#   clean_metadata.R

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(stringr)
})

if (!exists("clean_metadata", mode = "function")) {
  source("clean_metadata.R")
}

.nonblank <- function(x) {
  z <- stringr::str_trim(as.character(x))
  z_low <- stringr::str_to_lower(z)

  !is.na(x) &
    !is.na(z) &
    !(z_low %in% c("", "na", "n/a", "n.a.", "not applicable", "none", "null"))
}

add_project_metadata_hierarchies <- function(tb, verbose = TRUE, strict = FALSE) {
  tb <- tibble::as_tibble(tb)

  # Ensure columns exist so case_when logic is stable.
  needed <- c(
    "karstic_system", "open_air_site",
    "taphonomic_context", "funerary_context"
  )
  for (nm in setdiff(needed, names(tb))) tb[[nm]] <- NA_character_

  karstic_present <- .nonblank(tb$karstic_system)
  openair_present <- .nonblank(tb$open_air_site)

  tb <- tb |>
    dplyr::mutate(
      site_environment_conflict = karstic_present & openair_present,

      # Main mutually-exclusive setting.
      site_environment = dplyr::case_when(
        karstic_present & !openair_present ~ "Karstic",
        openair_present & !karstic_present ~ "Open air",
        karstic_present & openair_present  ~ "Conflict: both recorded",
        TRUE ~ NA_character_
      ),

      # Subcategory valid within the selected main setting.
      site_environment_subtype = dplyr::case_when(
        karstic_present & !openair_present ~ as.character(karstic_system),
        openair_present & !karstic_present ~ as.character(open_air_site),
        karstic_present & openair_present ~ paste(
          as.character(karstic_system),
          as.character(open_air_site),
          sep = " + "
        ),
        TRUE ~ NA_character_
      ),

      # One convenient hierarchical label.
      site_environment_detail = dplyr::case_when(
        .nonblank(site_environment) & .nonblank(site_environment_subtype) &
          stringr::str_to_lower(stringr::str_trim(site_environment)) !=
          stringr::str_to_lower(stringr::str_trim(site_environment_subtype)) ~
          paste(site_environment, site_environment_subtype, sep = " | "),
        .nonblank(site_environment) ~ site_environment,
        TRUE ~ NA_character_
      )
    )

  funeral_present <- .nonblank(tb$funerary_context)
  is_funeral_main <- !is.na(tb$taphonomic_context) &
    as.character(tb$taphonomic_context) == "Funerary Context"

  tb <- tb |>
    dplyr::mutate(
      funerary_subtype_conflict = funeral_present & !is_funeral_main,

      # Keep funerary subtype only where it is structurally applicable.
      funerary_subtype = dplyr::case_when(
        is_funeral_main & funeral_present ~ as.character(funerary_context),
        TRUE ~ NA_character_
      ),

      # Main taphonomic label remains untouched; detail expands only funerary rows.
      taphonomic_detail = dplyr::case_when(
        is_funeral_main & .nonblank(funerary_subtype) ~
          paste("Funerary Context", funerary_subtype, sep = " | "),
        TRUE ~ as.character(taphonomic_context)
      )
    )

  n_env_conflict <- sum(tb$site_environment_conflict, na.rm = TRUE)
  n_fun_conflict <- sum(tb$funerary_subtype_conflict, na.rm = TRUE)

  if (verbose) {
    message("---- metadata hierarchy audit ----")
    message("site environment conflicts (both karstic + open air): ", n_env_conflict)
    message("funerary subtype on non-funerary row: ", n_fun_conflict)
    message("----------------------------------")
  }

  if (strict && (n_env_conflict > 0 || n_fun_conflict > 0)) {
    stop(
      "Hierarchy conflicts found. Inspect site_environment_conflict and ",
      "funerary_subtype_conflict before continuing.",
      call. = FALSE
    )
  }

  tb
}

prepare_project_metadata <- function(tb, verbose = TRUE, strict = FALSE) {
  tb |>
    clean_metadata(verbose = verbose) |>
    add_project_metadata_hierarchies(verbose = verbose, strict = strict)
}

metadata_hierarchy_audit <- function(tb) {
  tibble::tibble(
    check = c(
      "rows",
      "site_environment_conflicts",
      "funerary_subtype_conflicts",
      "missing_site_environment",
      "funerary_rows",
      "funerary_rows_missing_subtype"
    ),
    n = c(
      nrow(tb),
      sum(tb$site_environment_conflict %in% TRUE, na.rm = TRUE),
      sum(tb$funerary_subtype_conflict %in% TRUE, na.rm = TRUE),
      sum(is.na(tb$site_environment) | tb$site_environment == ""),
      sum(as.character(tb$taphonomic_context) == "Funerary Context", na.rm = TRUE),
      sum(
        as.character(tb$taphonomic_context) == "Funerary Context" &
          (is.na(tb$funerary_subtype) | tb$funerary_subtype == ""),
        na.rm = TRUE
      )
    )
  )
}

augmentation_metadata_manifest <- function(tb = NULL) {
  x <- tibble::tribble(
    ~family, ~variable, ~default_for_taphonomy_target, ~role,
    "temporal", "geological_period", TRUE, "candidate",
    "temporal", "cultural_period", TRUE, "candidate",
    "temporal", "culture_period_2", TRUE, "candidate",
    "temporal", "start_date_cal_bp", TRUE, "candidate",
    "temporal", "end_date_cal_bp", TRUE, "candidate",
    "temporal", "mis_stage", TRUE, "candidate",

    "spatial", "region", TRUE, "candidate",
    "spatial", "country", TRUE, "candidate",

    "environment", "site_environment", TRUE, "main mutually-exclusive setting",
    "environment", "site_environment_detail", TRUE, "hierarchical setting + subtype",

    "biological", "age_category", TRUE, "candidate",
    "biological", "gender", TRUE, "candidate",

    "taxonomy", "hominin_species", TRUE, "candidate",

    "recovery", "degree_of_excavation", FALSE, "optional sensitivity variable",
    "recovery", "discovery_context", FALSE, "optional sensitivity variable",

    "target_derived", "taphonomic_context", FALSE, "prediction target; exclude",
    "target_derived", "funerary_context", FALSE, "nested target information; exclude",
    "target_derived", "funerary_subtype", FALSE, "nested target information; exclude",
    "target_derived", "taphonomic_detail", FALSE, "contains prediction target; exclude",

    "superseded", "karstic_system", FALSE, "use site_environment hierarchy instead",
    "superseded", "open_air_site", FALSE, "use site_environment hierarchy instead"
  )

  if (!is.null(tb)) {
    x <- x |>
      dplyr::mutate(present = variable %in% names(tb))
  }

  x
}
