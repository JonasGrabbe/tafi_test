archo_preload_site_table <- function(x, strict = FALSE) {

  issues <- character(0)
  add_issue <- function(z) issues <<- c(issues, z)
  warn_or_stop <- function(z) {
    if (isTRUE(strict)) stop(z, call. = FALSE)
    add_issue(z)
  }

  if (!is.data.frame(x)) stop("archo_preload_site_table(): input must be a data.frame.", call. = FALSE)
  if (ncol(x) < 2) stop("archo_preload_site_table(): input must have at least 2 columns.", call. = FALSE)
  if (nrow(x) < 32) stop("archo_preload_site_table(): expected >= 32 rows (31 meta + skeletal).", call. = FALSE)

  # keep 2 columns only
  x <- x[, 1:2, drop = FALSE]

  # preserve site column name
  site_col <- colnames(x)[2]
  if (is.null(site_col) || !nzchar(site_col)) site_col <- "sample_1"

  colnames(x) <- c("element", site_col)

  x$element <- trimws(as.character(x$element))

  # split
  meta <- x[1:31, , drop = FALSE]
  raw  <- x[-c(1:31), , drop = FALSE]

  # ---- meta checks (hard-coded required keys) ----
  required_meta <- c("site_id", "individual_id", "site_name", "count_type",
                     "geological_period", "cultural_period")

  missing_meta <- setdiff(required_meta, meta$element)
  if (length(missing_meta) > 0) {
    warn_or_stop(paste0("Missing required meta row(s): ", paste(missing_meta, collapse = ", ")))
  }

  # ---- skeletal checks ----
  raw_num <- suppressWarnings(as.numeric(raw[[site_col]]))
  if (any(is.na(raw_num) & !is.na(raw[[site_col]]))) {
    warn_or_stop("Non-numeric skeletal values found; coerced to NA then set to 0.")
  }

  # NA -> 0 rule
  if (any(is.na(raw_num))) {
    warn_or_stop("NA skeletal counts replaced with 0 (NA = not identified).")
    raw_num[is.na(raw_num)] <- 0
  }

  # integer coercion
  non_int <- abs(raw_num - round(raw_num)) > 1e-9
  if (any(non_int)) {
    warn_or_stop("Non-integer skeletal counts detected; rounded to nearest integer.")
    raw_num <- round(raw_num)
  }

  if (any(raw_num < 0, na.rm = TRUE)) {
    warn_or_stop("Negative skeletal counts detected; set to 0.")
    raw_num[raw_num < 0] <- 0
  }

  raw[[site_col]] <- as.integer(raw_num)

  # rebuild
  out <- rbind(meta, raw)

  # aggregated warning
  if (length(issues) > 0 && !isTRUE(strict)) {
    warning(paste0("archo_preload_site_table validation report:\n- ",
                   paste(unique(issues), collapse = "\n- ")), call. = FALSE)
  }

  attr(out, "validation_report") <- unique(issues)
  return(out)
}
