# =====================================================================
#  clean_metadata() — hard-coded fixes for the metadata columns
#
#  Run this ONCE, before RFE / PCA / EDA, so every downstream step
#  sees the same harmonised labels:
#
#      tb <- clean_metadata(tb)
#
#  The recode tables below are deliberately explicit and editable —
#  the taphonomic_context merges in particular encode archaeological
#  judgement calls; change them if you disagree.
# =====================================================================

library(dplyr)

# ---------------------------------------------------------------------
# helper: map known values, leave everything else (and NA) untouched
# ---------------------------------------------------------------------
.apply_map <- function(x, map) {
  x   <- as.character(x)
  hit <- !is.na(x) & x %in% names(map)
  x[hit] <- unname(map[x[hit]])
  x
}
.squish <- function(x) if (is.character(x)) gsub("\\s+", " ", trimws(x)) else x

# =====================================================================
#  RECODE TABLES  (edit these freely)
# =====================================================================

# --- taphonomic_context -------------------------------------------------
#  canonical target classes: Cannibalism, Carnivore, Funerary Context,
#  Geological transport, Unknown.
#  >>> REVIEW the lines marked ## CHECK — these are interpretive. <<<
class_recode <- c(
  "Cannibalism"                              = "Cannibalism",
  "Carnivore"                                = "Carnivore",
  "Carnivore den(transport)"                 = "Carnivore",              ## CHECK (vs Geological transport?)
  "Carnivore Scavenge (in situ)"             = "Carnivore",              ## CHECK
  "Funerary Context"                         = "Funerary Context",
  "Cuevas Sepulcrales"                       = "Sepulchral Cave",        # Sp. "sepulchral caves"
  "Sepulchral Cave"                          = "Sepulchral Cave",
  "Geological transport"                     = "Geological transport",
  "Disarticulated within occupation layers"  = "Unknown",               ## CHECK (own class? or Unknown)
  "Unknown"                                  = "Unknown",
  "Unkown"                                   = "Unknown"                 # typo
)

# --- cultural_period (typo fixes; whitespace already squished) ----------
cultural_period_recode <- c(
  "Middle Paleolithi" = "Middle Paleolithic"
)

# --- age_category -------------------------------------------------------
age_category_recode <- c(
  "Adult"     = "Adult",
  "Adults"    = "Adult",
  "Infant"    = "Infant",
  "Infantile" = "Infant",
  "Juvenil"   = "Juvenile",
  "Juvenile"  = "Juvenile",
  "Subadult"  = "Subadult",
  "Mixed"     = "Mixed",
  "Indet"     = "Indet"
)

# =====================================================================
#  main
# =====================================================================
clean_metadata <- function(tb, verbose = TRUE) {

  # 0. squish whitespace on all character columns (kills " x " / "x  " dupes)
  tb <- tb %>% dplyr::mutate(dplyr::across(where(is.character), .squish))

  before <- list()  # snapshot for the change report

  # 1. taphonomic_context
  if ("taphonomic_context" %in% names(tb)) {
    before$taphonomic_context <- sort(unique(tb$taphonomic_context))
    tb$taphonomic_context <- .apply_map(tb$taphonomic_context, class_recode)
  }

  # 2. cultural_period
  if ("cultural_period" %in% names(tb)) {
    before$cultural_period <- sort(unique(tb$cultural_period))
    tb$cultural_period <- .apply_map(tb$cultural_period, cultural_period_recode)
  }

  # 3. mis_stage -> first digit only ("3"->"3", "345"->"3", "5-7"->"5")
  if ("mis_stage" %in% names(tb)) {
    before$mis_stage <- sort(unique(as.character(tb$mis_stage)))
    v   <- as.character(tb$mis_stage)
    out <- sub("^\\D*(\\d).*", "\\1", v)        # first digit
    out[is.na(v) | !grepl("\\d", v)] <- NA_character_
    tb$mis_stage <- out
  }

  # 4. region: "Levant / Occupied Palestine" (and any "Levant ...") -> "Levant"
  if ("region" %in% names(tb)) {
    before$region <- sort(unique(tb$region))
    tb$region <- ifelse(grepl("^Levant", tb$region), "Levant", tb$region)
  }
  # apply the same on country if a Levant variant lives there too
  if ("country" %in% names(tb)) {
    tb$country <- ifelse(grepl("^Levant", tb$country %||% NA), "Levant", tb$country)
  }

  # 5. age_category
  if ("age_category" %in% names(tb)) {
    before$age_category <- sort(unique(tb$age_category))
    tb$age_category <- .apply_map(tb$age_category, age_category_recode)
  }

  # --- change report ---------------------------------------------------
  if (verbose) {
    message("---- clean_metadata: harmonised columns ----")
    for (col in names(before)) {
      after <- sort(unique(as.character(tb[[col]])))
      message(sprintf("%-20s %2d -> %2d distinct values",
                      col, length(before[[col]]), length(after)))
    }
    if ("taphonomic_context" %in% names(tb)) {
      message("\ntaphonomic_context after cleaning:")
      print(table(tb$taphonomic_context, useNA = "ifany"))
    }
    message("--------------------------------------------")
  }

  tb
}

# tiny null-coalescing helper used above
`%||%` <- function(a, b) if (is.null(a)) b else a

# ---------------------------------------------------------------------
# Example — run BEFORE the modelling / EDA pipeline
# ---------------------------------------------------------------------
# tb  <- clean_metadata(tb)
# res <- run_rfe(tb, task_name = "fc_vs_rest")
# eda <- run_eda(tb)
