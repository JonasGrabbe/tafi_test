# =====================================================================
#  Recursive Feature Elimination (RFE) with randomForest
#  Target: taphonomic_context
#
#  Adapted workflow:
#    * Grouped K-fold CV by site_id: all rows for one site_id stay in
#      exactly one held-out fold.
#    * SMOTE is applied inside each training fold only. Held-out folds are
#      never oversampled.
#    * over_ratio = 1 balances minority classes to the training-fold
#      majority class size.
#    * Unknown-site report reuses the exact same grouped folds and SMOTE
#      setup as RFE step 1, so mean_acc equals the step-1 mean CV accuracy.
# =====================================================================

library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(readr)
library(randomForest)
library(rlang)

# ---------------------------------------------------------------------
# 0. Metadata columns to remove (everything except the target).
#    taphonomic_context is intentionally NOT here -- it is the label.
# ---------------------------------------------------------------------
meta_cols <- c(
  "site_name", "ind_name", "site_id", "individual_id", "layer_name",
  "count_type", "geological_period", "cultural_period", "culture_period_2",
  "start_date_cal_bp", "end_date_cal_bp", "mis_stage",
  "karstic_system", "karstic_system_2", "open_air_site", "open_air_site_2",
  "region", "country", "mni", "age_category",
  "n_infant", "n_juvenil", "n_subadult", "n_adult", "gender",
  "funerary_context", "discovery_context", "degree_of_excavation",
  "hominin_species", "observation", "reference",
  ".row_id"
)

# ---------------------------------------------------------------------
# 1. Task recoder -- builds the labelled data frame.
# ---------------------------------------------------------------------
task_recode_data_first <- function(raw_df,
                             task_name,
                             target_variable = "taphonomic_context") {
  tvsym <- rlang::sym(target_variable)

  if (task_name == "4class") {
    class_levels <- c("Cannibalism", "Carnivore",
                      "Funerary Context", "Geological transport")
    df <- raw_df %>%
      dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))

  } else if (task_name == "cannibalism_vs_fc") {
    class_levels <- c("Cannibalism", "Funerary Context")
    df <- raw_df %>%
      dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))

  } else if (task_name == "fc_vs_rest") {
    rest_classes <- c("Cannibalism", "Carnivore", "Geological transport")
    class_levels <- c("Funerary Context", "rest")
    df <- raw_df %>%
      dplyr::mutate(!!tvsym := dplyr::case_when(
        .data[[target_variable]] %in% rest_classes     ~ "rest",
        .data[[target_variable]] == "Funerary Context" ~ "Funerary Context",
        TRUE                                           ~ NA_character_
      )) %>%
      dplyr::filter(!is.na(.data[[target_variable]])) %>%
      dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))

  } else {
    stop("Unknown task_name: ", task_name)
  }

  message("Class distribution (", task_name, "):")
  print(table(df[[target_variable]], useNA = "ifany"))

  missing_classes <- setdiff(levels(df[[target_variable]]), unique(df[[target_variable]]))
  if (length(missing_classes)) {
    warning("Some expected classes missing: ", paste(missing_classes, collapse = ", "))
  }

  list(df = df, class_levels = levels(df[[target_variable]]))
}
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# 1. Task recoder -- builds the labelled data frame.
# ---------------------------------------------------------------------
task_recode_data2nd <- function(raw_df,
  task_name,
  target_variable = "funerary_context") {
tvsym <- rlang::sym(target_variable)
if (task_name == "4class") {
class_levels <- c("Cannibalism", "Carnivore",
"Funerary Context", "Geological transport")
df <- raw_df %>%
dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "cannibalism_vs_fc") {
class_levels <- c("Cannibalism", "Funerary Context")
df <- raw_df %>%
dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "fc_vs_rest") {
rest_classes <- c("Cannibalism", "Carnivore", "Geological transport")
class_levels <- c("Funerary Context", "rest")
df <- raw_df %>%
dplyr::mutate(!!tvsym := dplyr::case_when(
.data[[target_variable]] %in% rest_classes     ~ "rest",
.data[[target_variable]] == "Funerary Context" ~ "Funerary Context",
TRUE                                           ~ NA_character_
)) %>%
dplyr::filter(!is.na(.data[[target_variable]])) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "funerary_5class") {
# NOTE: this task uses funerary_context as its source, not taphonomic_context.
# Call with target_variable = "funerary_context".
fc_source <- "funerary_context"
class_levels <- c("Collective burial", "Inhumation single",
"Mixed / multiple types", "No inhumation",
"Inhumation multiple")
df <- raw_df %>%
dplyr::mutate(
.fc_clean = stringr::str_squish(.data[[fc_source]]),
!!tvsym := dplyr::case_when(
is.na(.fc_clean) | .fc_clean == "NA"                 ~ NA_character_,
stringr::str_detect(.fc_clean, "Carnivore")          ~ NA_character_,  # non-funerary, dropped
stringr::str_detect(.fc_clean, ";")                  ~ "Mixed / multiple types",
stringr::str_detect(.fc_clean, "Collective")         ~ "Collective burial",
stringr::str_detect(.fc_clean, "Inhumation multiple")~ "Inhumation multiple",
stringr::str_detect(.fc_clean, "Inhumation single")  ~ "Inhumation single",
stringr::str_detect(.fc_clean, "No inhumation")      ~ "No inhumation",
TRUE                                                 ~ NA_character_   # Other funerary / Other, dropped
)
) %>%
dplyr::filter(!is.na(.data[[target_variable]])) %>%
dplyr::select(-.fc_clean) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else {
stop("Unknown task_name: ", task_name)
}
message("Class distribution (", task_name, "):")
print(table(df[[target_variable]], useNA = "ifany"))
missing_classes <- setdiff(levels(df[[target_variable]]), unique(df[[target_variable]]))
if (length(missing_classes)) {
warning("Some expected classes missing: ", paste(missing_classes, collapse = ", "))
}
list(df = df, class_levels = levels(df[[target_variable]]))
}

# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
task_recode_data <- function(raw_df,
  task_name,
  target_variable = "taphonomic_context") {
tvsym <- rlang::sym(target_variable)
if (task_name == "4class") {
class_levels <- c("Cannibalism", "Carnivore",
"Funerary Context", "Geological transport")
df <- raw_df %>%
dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "cannibalism_vs_fc") {
class_levels <- c("Cannibalism", "Funerary Context")
df <- raw_df %>%
dplyr::filter(.data[[target_variable]] %in% class_levels) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "fc_vs_rest") {
rest_classes <- c("Cannibalism", "Carnivore", "Geological transport")
class_levels <- c("Funerary Context", "rest")
df <- raw_df %>%
dplyr::mutate(!!tvsym := dplyr::case_when(
.data[[target_variable]] %in% rest_classes     ~ "rest",
.data[[target_variable]] == "Funerary Context" ~ "Funerary Context",
TRUE                                           ~ NA_character_
)) %>%
dplyr::filter(!is.na(.data[[target_variable]])) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "funerary_5class") {
# NOTE: this task uses funerary_context as its source, not taphonomic_context.
# Call with target_variable = "funerary_context".
fc_source <- "funerary_context"
class_levels <- c("Collective burial", "Inhumation single",
"Mixed / multiple types", "No inhumation",
"Inhumation multiple")
df <- raw_df %>%
dplyr::mutate(
.fc_clean = stringr::str_squish(.data[[fc_source]]),
!!tvsym := dplyr::case_when(
is.na(.fc_clean) | .fc_clean == "NA"                 ~ NA_character_,
stringr::str_detect(.fc_clean, "Carnivore")          ~ NA_character_,  # non-funerary, dropped
stringr::str_detect(.fc_clean, ";")                  ~ "Mixed / multiple types",
stringr::str_detect(.fc_clean, "Collective")         ~ "Collective burial",
stringr::str_detect(.fc_clean, "Inhumation multiple")~ "Inhumation multiple",
stringr::str_detect(.fc_clean, "Inhumation single")  ~ "Inhumation single",
stringr::str_detect(.fc_clean, "No inhumation")      ~ "No inhumation",
TRUE                                                 ~ NA_character_   # Other funerary / Other, dropped
)
) %>%
dplyr::filter(!is.na(.data[[target_variable]])) %>%
dplyr::select(-.fc_clean) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else if (task_name == "combined_7class") {
# NOTE: this task reads BOTH columns.
#   - non-funerary classes come from taphonomic_context
#   - "Funerary Context" rows are subdivided via funerary_context
#   - "Mixed / multiple types" (";") is folded into "Inhumation multiple"
# Call with target_variable = "taphonomic_context" (the default).
fc_source  <- "funerary_context"
tapho_keep <- c("Cannibalism", "Carnivore", "Geological transport")
class_levels <- c("Cannibalism", "Carnivore", "Geological transport",
"Collective burial", "Inhumation single",
"No inhumation", "Inhumation multiple")
df <- raw_df %>%
dplyr::mutate(
.fc_clean = stringr::str_squish(.data[[fc_source]]),
.tapho    = as.character(.data[[target_variable]]),
!!tvsym := dplyr::case_when(
# 1) keep the three non-funerary taphonomic classes as-is
.tapho %in% tapho_keep                                  ~ .tapho,
# 2) subdivide the funerary rows (order matters: ";" before singles)
.tapho == "Funerary Context" &
(is.na(.fc_clean) | .fc_clean == "NA")                ~ NA_character_,
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, "Carnivore")           ~ NA_character_,
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, ";")                   ~ "Inhumation multiple",  # Mixed folded in
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, "Collective")          ~ "Collective burial",
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, "Inhumation multiple") ~ "Inhumation multiple",
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, "Inhumation single")   ~ "Inhumation single",
.tapho == "Funerary Context" &
stringr::str_detect(.fc_clean, "No inhumation")       ~ "No inhumation",
# 3) everything else (Other funerary, Unknown, NA tapho) dropped
TRUE                                                    ~ NA_character_
)
) %>%
dplyr::filter(!is.na(.data[[target_variable]])) %>%
dplyr::select(-.fc_clean, -.tapho) %>%
dplyr::mutate(!!tvsym := factor(.data[[target_variable]], levels = class_levels))
} else {
stop("Unknown task_name: ", task_name)
}
message("Class distribution (", task_name, "):")
print(table(df[[target_variable]], useNA = "ifany"))
missing_classes <- setdiff(levels(df[[target_variable]]), unique(df[[target_variable]]))
if (length(missing_classes)) {
warning("Some expected classes missing: ", paste(missing_classes, collapse = ", "))
}
list(df = df, class_levels = levels(df[[target_variable]]))
}

# ---------------------------------------------------------------------
# 2. Drop meta + non-usable columns; keep target + clean numeric features.
# ---------------------------------------------------------------------
prep_features <- function(df,
                          target_variable = "funerary_context",
                          drop_meta       = meta_cols) {

  y <- df[[target_variable]]
  if (!is.factor(y)) y <- factor(y)

  X <- df %>%
    dplyr::select(-dplyr::any_of(setdiff(drop_meta, target_variable))) %>%
    dplyr::select(-dplyr::any_of(target_variable)) %>%
    dplyr::select(where(~ !is.list(.x))) %>%
    dplyr::select(where(~ is.numeric(.x) || is.logical(.x))) %>%
    dplyr::mutate(dplyr::across(where(is.logical), as.numeric)) %>%
    dplyr::mutate(dplyr::across(
      everything(),
      ~ ifelse(is.nan(.x) | is.infinite(.x), NA_real_, .x)
    ))

  # Drop all-NA or zero-variance predictors.
  keep <- vapply(X, function(col) {
    v <- col[!is.na(col)]
    length(v) > 0 && stats::var(v) > 0
  }, logical(1))
  X <- X[, keep, drop = FALSE]

  # Median-impute remaining NAs.
  X <- X %>%
    dplyr::mutate(dplyr::across(
      everything(),
      ~ ifelse(is.na(.x), stats::median(.x, na.rm = TRUE), .x)
    ))

  message("Predictors kept after cleaning: ", ncol(X))
  list(X = X, y = y)
}

# ---------------------------------------------------------------------
# 3a. Build grouped folds. Each site_id appears in one fold only.
# ---------------------------------------------------------------------
make_group_folds_01 <- function(y, group_id, folds = 3, seed = 37) {
  if (length(y) != length(group_id)) {
    stop("`y` and `group_id` must have the same length.")
  }
  if (is.null(folds) || folds < 2) {
    stop("`folds` must be >= 2.")
  }

  y <- factor(y, levels = levels(y))
  class_levels <- levels(y)

  group_id <- as.character(group_id)
  bad_group <- is.na(group_id) | trimws(group_id) == ""
  if (any(bad_group)) {
    group_id[bad_group] <- paste0("__missing_group_row_", which(bad_group))
    warning("Some group IDs were missing. They were treated as row-unique groups.")
  }

  idx_by_group <- split(seq_along(y), group_id)
  group_names <- names(idx_by_group)
  n_groups <- length(group_names)

  if (n_groups < folds) {
    stop("Number of unique groups/site_id values (", n_groups,
         ") is smaller than cv_folds (", folds, ").")
  }

  group_n <- lengths(idx_by_group)
  group_class <- vapply(idx_by_group, function(idx) {
    tab <- table(factor(y[idx], levels = class_levels))
    class_levels[which.max(tab)]
  }, character(1))

  set.seed(seed)

  fold_id_by_group <- setNames(integer(n_groups), group_names)
  fold_load <- rep(0L, folds)
  class_load <- matrix(
    0L,
    nrow = folds,
    ncol = length(class_levels),
    dimnames = list(NULL, class_levels)
  )

  # Stratified greedy assignment. Within each majority-class bucket, the
  # largest groups are assigned first to the fold with the lowest load for
  # that class, using total fold load as a tie-breaker.
  for (cl in class_levels) {
    cl_groups <- group_names[group_class == cl]
    if (!length(cl_groups)) next

    rnd <- stats::runif(length(cl_groups))
    cl_groups <- cl_groups[order(-unname(group_n[cl_groups]), rnd)]
    cl_idx <- match(cl, class_levels)

    for (g in cl_groups) {
      min_class_load <- min(class_load[, cl_idx])
      candidate_folds <- which(class_load[, cl_idx] == min_class_load)
      chosen <- candidate_folds[which.min(fold_load[candidate_folds])]

      fold_id_by_group[[g]] <- chosen
      class_load[chosen, cl_idx] <- class_load[chosen, cl_idx] + group_n[[g]]
      fold_load[chosen] <- fold_load[chosen] + group_n[[g]]
    }
  }

  fold_id <- integer(length(y))
  for (g in group_names) {
    fold_id[idx_by_group[[g]]] <- fold_id_by_group[[g]]
  }

  if (any(fold_id == 0L)) {
    stop("Internal error: at least one row was not assigned to a fold.")
  }

  leakage <- vapply(idx_by_group, function(idx) {
    length(unique(fold_id[idx])) != 1L
  }, logical(1))
  if (any(leakage)) {
    stop("Internal error: a group/site_id was assigned to more than one fold.")
  }

  fold_assignment <- tibble::tibble(
    group_id = names(fold_id_by_group),
    fold = as.integer(unname(fold_id_by_group)),
    n_rows = as.integer(group_n[names(fold_id_by_group)]),
    majority_class = unname(group_class[names(fold_id_by_group)])
  ) %>%
    dplyr::arrange(.data$fold, dplyr::desc(.data$n_rows), .data$group_id)

  list(
    fold_id = fold_id,
    fold_assignment = fold_assignment,
    fold_class_table = table(fold_id, y)
  )
}
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# 3a. Build grouped folds. Each site_id appears in one fold only.
# ---------------------------------------------------------------------
make_group_folds <- function(y, group_id, folds = 3, seed = 37) {
  if (length(y) != length(group_id)) {
    stop("`y` and `group_id` must have the same length.")
  }
  if (is.null(folds) || folds < 2) {
    stop("`folds` must be >= 2.")
  }
  y <- factor(y, levels = levels(y))
  class_levels <- levels(y)

  # --- workaround: tolerate y arriving with empty/dropped levels.
  #     Rebuild levels from observed values. No rows are removed. ---
  if (length(class_levels) == 0L) {
    observed <- unique(as.character(y[!is.na(y)]))
    if (length(observed) == 0L) {
      stop("`y` has no non-missing values; cannot build folds.")
    }
    class_levels <- sort(observed)
    y <- factor(as.character(y), levels = class_levels)
  }

  group_id <- as.character(group_id)
  bad_group <- is.na(group_id) | trimws(group_id) == ""
  if (any(bad_group)) {
    group_id[bad_group] <- paste0("__missing_group_row_", which(bad_group))
    warning("Some group IDs were missing. They were treated as row-unique groups.")
  }
  idx_by_group <- split(seq_along(y), group_id)
  group_names <- names(idx_by_group)
  n_groups <- length(group_names)
  if (n_groups < folds) {
    stop("Number of unique groups/site_id values (", n_groups,
         ") is smaller than cv_folds (", folds, ").")
  }
  group_n <- lengths(idx_by_group)
  group_class <- vapply(idx_by_group, function(idx) {
    tab <- table(factor(y[idx], levels = class_levels))
    if (sum(tab) == 0L) {
      # group has only NA labels -> keep its rows, assign a placeholder
      # majority so the group is still distributed to a fold (not dropped)
      return(class_levels[[1L]])
    }
    class_levels[[which.max(tab)]]   # `[[` guarantees a length-1 result
  }, character(1))
  set.seed(seed)
  fold_id_by_group <- setNames(integer(n_groups), group_names)
  fold_load <- rep(0L, folds)
  class_load <- matrix(
    0L,
    nrow = folds,
    ncol = length(class_levels),
    dimnames = list(NULL, class_levels)
  )
  # Stratified greedy assignment. Within each majority-class bucket, the
  # largest groups are assigned first to the fold with the lowest load for
  # that class, using total fold load as a tie-breaker.
  for (cl in class_levels) {
    cl_groups <- group_names[group_class == cl]
    if (!length(cl_groups)) next
    rnd <- stats::runif(length(cl_groups))
    cl_groups <- cl_groups[order(-unname(group_n[cl_groups]), rnd)]
    cl_idx <- match(cl, class_levels)
    for (g in cl_groups) {
      min_class_load <- min(class_load[, cl_idx])
      candidate_folds <- which(class_load[, cl_idx] == min_class_load)
      chosen <- candidate_folds[which.min(fold_load[candidate_folds])]
      fold_id_by_group[[g]] <- chosen
      class_load[chosen, cl_idx] <- class_load[chosen, cl_idx] + group_n[[g]]
      fold_load[chosen] <- fold_load[chosen] + group_n[[g]]
    }
  }
  fold_id <- integer(length(y))
  for (g in group_names) {
    fold_id[idx_by_group[[g]]] <- fold_id_by_group[[g]]
  }
  if (any(fold_id == 0L)) {
    stop("Internal error: at least one row was not assigned to a fold.")
  }
  leakage <- vapply(idx_by_group, function(idx) {
    length(unique(fold_id[idx])) != 1L
  }, logical(1))
  if (any(leakage)) {
    stop("Internal error: a group/site_id was assigned to more than one fold.")
  }
  fold_assignment <- tibble::tibble(
    group_id = names(fold_id_by_group),
    fold = as.integer(unname(fold_id_by_group)),
    n_rows = as.integer(group_n[names(fold_id_by_group)]),
    majority_class = unname(group_class[names(fold_id_by_group)])
  ) %>%
    dplyr::arrange(.data$fold, dplyr::desc(.data$n_rows), .data$group_id)
  list(
    fold_id = fold_id,
    fold_assignment = fold_assignment,
    fold_class_table = table(fold_id, y)
  )
}

# ---------------------------------------------------------------------
# 3b. Minimal numeric SMOTE implementation.
#     Applied to training folds only by cv_fit_importance/cv_unknown_report.
# ---------------------------------------------------------------------
.nearest_same_class <- function(mat, k = 5) {
  n <- nrow(mat)
  if (n <= 1L) {
    return(rep(list(integer(0)), n))
  }

  k_eff <- min(as.integer(k), n - 1L)
  if (is.na(k_eff) || k_eff < 1L) k_eff <- 1L

  scaled <- scale(mat)
  scaled[is.nan(scaled) | is.infinite(scaled)] <- 0

  d <- as.matrix(stats::dist(scaled, method = "euclidean"))
  diag(d) <- Inf

  lapply(seq_len(n), function(i) {
    order(d[i, ])[seq_len(k_eff)]
  })
}

smote_training_fold <- function(X,
                                y,
                                over_ratio = 1,
                                k = 5,
                                seed = NULL) {
  if (is.null(over_ratio) || is.na(over_ratio) || over_ratio <= 0) {
    return(list(X = as.data.frame(X), y = factor(y, levels = levels(y))))
  }

  X <- as.data.frame(X)
  y <- factor(y, levels = levels(y))

  counts <- table(y)
  present <- counts[counts > 0]

  if (length(present) < 2L) {
    return(list(X = X, y = y))
  }

  target_n <- ceiling(max(present) * over_ratio)
  if (target_n <= min(present)) {
    return(list(X = X, y = y))
  }

  if (!is.null(seed)) set.seed(seed)

  X_parts <- list(X)
  y_parts <- list(y)

  for (cl in names(present)) {
    n_i <- as.integer(present[[cl]])
    if (n_i >= target_n) next

    need <- target_n - n_i
    idx <- which(y == cl)
    Xc <- as.matrix(X[idx, , drop = FALSE])

    if (n_i == 1L) {
      synth <- matrix(rep(Xc[1, ], times = need), nrow = need, byrow = TRUE)
    } else {
      nn <- .nearest_same_class(Xc, k = k)
      synth <- matrix(NA_real_, nrow = need, ncol = ncol(Xc))

      for (i in seq_len(need)) {
        base_i <- sample.int(n_i, 1L)
        neigh_pool <- nn[[base_i]]
        neigh_i <- if (length(neigh_pool)) sample(neigh_pool, 1L) else base_i
        lambda <- stats::runif(1)
        synth[i, ] <- Xc[base_i, ] + lambda * (Xc[neigh_i, ] - Xc[base_i, ])
      }
    }

    synth <- as.data.frame(synth)
    names(synth) <- names(X)

    X_parts[[length(X_parts) + 1L]] <- synth
    y_parts[[length(y_parts) + 1L]] <- factor(rep(cl, need), levels = levels(y))
  }

  X_smote <- do.call(rbind, X_parts)
  rownames(X_smote) <- NULL

  y_smote <- factor(
    unlist(lapply(y_parts, as.character), use.names = FALSE),
    levels = levels(y)
  )

  list(X = X_smote, y = y_smote)
}

# ---------------------------------------------------------------------
# 3c. K-fold CV fit used at EVERY RFE step.
# ---------------------------------------------------------------------
cv_fit_importance <- function(X,
                              y,
                              ntree,
                              folds,
                              seed,
                              fold_id,
                              use_smote = TRUE,
                              over_ratio = 1,
                              smote_k = 5) {
  if (length(fold_id) != length(y)) {
    stop("`fold_id` must have the same length as `y`.")
  }

  feat_names <- names(X)
  imp_mat <- matrix(
    NA_real_,
    nrow = length(feat_names),
    ncol = folds,
    dimnames = list(feat_names, NULL)
  )
  accs <- rep(NA_real_, folds)

  for (f in seq_len(folds)) {
    tr <- fold_id != f
    te <- fold_id == f

    if (!any(te)) next
    if (sum(table(y[tr]) > 0) < 2L) next

    X_train <- X[tr, , drop = FALSE]
    y_train <- droplevels(y[tr])

    if (use_smote) {
      sm <- smote_training_fold(
        X_train,
        y_train,
        over_ratio = over_ratio,
        k = smote_k,
        seed = seed + 10000L + f
      )
      X_train <- sm$X
      y_train <- sm$y
    }

    set.seed(seed + f)
    m <- randomForest::randomForest(
      x = X_train,
      y = y_train,
      ntree = ntree
    )

    pr <- predict(m, X[te, , drop = FALSE])
    accs[f] <- mean(as.character(pr) == as.character(y[te]))

    imp <- randomForest::importance(m, type = 2)
    imp_mat[rownames(imp), f] <- imp[, 1]
  }

  list(
    accuracy = mean(accs, na.rm = TRUE),
    importance = rowMeans(imp_mat, na.rm = TRUE),
    fold_acc = accs
  )
}

# ---------------------------------------------------------------------
# 3d. Clean an UNKNOWN data frame to the SAME feature columns/order as the
#     known matrix, imputing with the KNOWN-data medians.
# ---------------------------------------------------------------------
.clean_like <- function(df, feats, medians) {
  X <- as.data.frame(df)[, intersect(feats, names(df)), drop = FALSE]
  for (m in setdiff(feats, names(X))) X[[m]] <- NA_real_
  X <- X[, feats, drop = FALSE]

  X[] <- lapply(X, function(col) {
    v <- suppressWarnings(as.numeric(col))
    v[is.nan(v) | is.infinite(v)] <- NA_real_
    v
  })

  for (nm in names(X)) X[[nm]][is.na(X[[nm]])] <- medians[[nm]]
  X
}

# ---------------------------------------------------------------------
# 3e. FIRST model (ALL features) report.
# ---------------------------------------------------------------------
cv_unknown_report <- function(X,
                              y,
                              unknown_df,
                              ntree = 500,
                              folds = 3,
                              seed = 42,
                              fold_id,
                              focus_class = "Funerary Context",
                              use_smote = TRUE,
                              over_ratio = 1,
                              smote_k = 5) {

  if (length(fold_id) != length(y)) {
    stop("`fold_id` must have the same length as `y`.")
  }

  feats <- names(X)
  classes <- levels(y)

  if (!focus_class %in% classes) {
    stop("focus_class '", focus_class, "' is not a level of the target.")
  }

  medians <- vapply(X, function(c) stats::median(c, na.rm = TRUE), numeric(1))
  Xu <- .clean_like(unknown_df, feats, medians)

  accs <- rep(NA_real_, folds)
  pf_mat <- matrix(NA_real_, nrow = nrow(Xu), ncol = folds)
  prob_acc <- matrix(
    0,
    nrow = nrow(Xu),
    ncol = length(classes),
    dimnames = list(NULL, classes)
  )
  trained_models <- 0L

  for (f in seq_len(folds)) {
    tr <- fold_id != f
    te <- fold_id == f

    if (!any(te)) next
    if (sum(table(y[tr]) > 0) < 2L) next

    X_train <- X[tr, , drop = FALSE]
    y_train <- droplevels(y[tr])

    if (use_smote) {
      sm <- smote_training_fold(
        X_train,
        y_train,
        over_ratio = over_ratio,
        k = smote_k,
        seed = seed + 10000L + f
      )
      X_train <- sm$X
      y_train <- sm$y
    }

    set.seed(seed + f)
    m <- randomForest::randomForest(
      x = X_train,
      y = y_train,
      ntree = ntree
    )

    accs[f] <- mean(as.character(predict(m, X[te, , drop = FALSE])) ==
                      as.character(y[te]))

    pp <- stats::predict(m, Xu, type = "prob")
    for (cl in intersect(classes, colnames(pp))) {
      prob_acc[, cl] <- prob_acc[, cl] + pp[, cl]
    }
    pf_mat[, f] <- if (focus_class %in% colnames(pp)) pp[, focus_class] else 0
    trained_models <- trained_models + 1L
  }

  if (trained_models == 0L) {
    stop("No CV models could be trained. Check grouped folds and class balance.")
  }

  mean_probs <- prob_acc / trained_models
  pred <- classes[max.col(mean_probs, ties.method = "first")]
  colnames(pf_mat) <- paste0("p_model", seq_len(folds))

  tbl <- tibble::tibble(
    site_name = unknown_df$site_name,
    predicted = factor(pred, levels = classes)
  ) %>%
    dplyr::bind_cols(tibble::as_tibble(round(pf_mat, 4))) %>%
    dplyr::mutate(p_focus_mean = round(mean_probs[, focus_class], 4)) %>%
    dplyr::arrange(dplyr::desc(.data$p_focus_mean))

  list(
    table = tbl,
    fold_acc = accs,
    mean_acc = mean(accs, na.rm = TRUE),
    focus_class = focus_class,
    trained_models = trained_models
  )
}

# ---------------------------------------------------------------------
# 4. RFE loop driven by grouped-CV mean importance.
# ---------------------------------------------------------------------
rfe_rf <- function(X,
                   y,
                   fold_id,
                   big_step        = 100,
                   small_threshold = 250,
                   small_step      = 1,
                   min_features    = 1,
                   ntree           = 1000,
                   cv_folds        = 3,
                   guard_overshoot = TRUE,
                   seed            = 37,
                   use_smote       = TRUE,
                   over_ratio      = 1,
                   smote_k         = 5) {

  if (is.null(cv_folds) || cv_folds < 2) {
    stop("cv_folds must be >= 2 for cross-validated importance.")
  }

  current <- names(X)
  history <- list()
  eliminated <- list()
  step <- 0L

  repeat {
    step <- step + 1L
    Xc <- X[, current, drop = FALSE]

    fit <- cv_fit_importance(
      Xc,
      y,
      ntree = ntree,
      folds = cv_folds,
      seed = seed,
      fold_id = fold_id,
      use_smote = use_smote,
      over_ratio = over_ratio,
      smote_k = smote_k
    )
    acc <- fit$accuracy

    imp_df <- tibble::tibble(
      feature = names(fit$importance),
      importance = as.numeric(fit$importance)
    ) %>%
      dplyr::arrange(.data$importance)

    history[[step]] <- tibble::tibble(
      step = step,
      n_features = length(current),
      accuracy = acc
    )

    n <- length(current)
    message(sprintf(
      "step %2d | %3d features | grouped-CV accuracy = %.4f (folds: %s)",
      step,
      n,
      acc,
      paste(sprintf("%.3f", fit$fold_acc), collapse = ", ")
    ))

    if (n <= min_features) break

    k <- if (n > small_threshold) big_step else small_step
    if (guard_overshoot && n > small_threshold) {
      k <- min(k, n - small_threshold)
    }
    k <- min(k, n - 1L)

    drop_feats <- imp_df$feature[seq_len(k)]
    eliminated[[step]] <- tibble::tibble(
      step = step,
      n_features_before = n,
      accuracy_before = acc,
      feature = drop_feats,
      importance = imp_df$importance[seq_len(k)]
    )

    current <- setdiff(current, drop_feats)
  }

  history <- dplyr::bind_rows(history)
  eliminated <- dplyr::bind_rows(eliminated)
  retained <- current

  elim_ranked <- eliminated %>%
    dplyr::mutate(status = "eliminated") %>%
    dplyr::arrange(.data$step, .data$importance) %>%
    dplyr::mutate(elimination_rank = dplyr::row_number())

  retained_tbl <- tibble::tibble(
    step = NA_integer_,
    n_features_before = length(retained),
    accuracy_before = dplyr::last(history$accuracy),
    feature = retained,
    importance = NA_real_,
    status = "retained",
    elimination_rank = nrow(elim_ranked) + seq_along(retained)
  )

  ranking <- dplyr::bind_rows(elim_ranked, retained_tbl)
  best <- history %>% dplyr::slice_max(.data$accuracy, n = 1, with_ties = FALSE)

  list(
    history = history,
    eliminated = eliminated,
    ranking = ranking,
    retained = retained,
    best = best
  )
}

# ---------------------------------------------------------------------
# 5. Driver: run end-to-end, plot, write CSV, report unknown sites.
# ---------------------------------------------------------------------
run_rfe <- function(tapho_db,
                    task_name      = "4class",
                    out_csv        = "feature_elimination_ranking.csv",
                    out_plot       = "feature_elimination_curve.png",
                    cv_folds       = 3,
                    small_step     = 1,
                    seed           = 36,
                    unknown_sites  = NULL,
                    focus_class    = "Funerary Context",
                    report_unknown = TRUE,
                    ntree          = 1000,
                    group_col      = "site_id",
                    use_smote      = TRUE,
                    over_ratio     = 1,
                    smote_k        = 5) {

  db <- tapho_db %>% dplyr::mutate(.row_id = dplyr::row_number())

  rec <- task_recode_data(
    db,
    task_name = task_name,
    target_variable = "funerary_context"
  )

  if (!group_col %in% names(rec$df)) {
    stop("Grouping column `", group_col, "` is missing from the recoded data.")
  }

  grouped_folds <- make_group_folds(
    y = rec$df$funerary_context,
    group_id = rec$df[[group_col]],
    folds = cv_folds,
    seed = seed
  )

  message("Grouped fold class distribution before SMOTE:")
  print(grouped_folds$fold_class_table)
  message("SMOTE inside training folds: ", use_smote,
          if (use_smote) paste0(" | over_ratio = ", over_ratio,
                                " | k = ", smote_k) else "")

  prep <- prep_features(rec$df, target_variable = "funerary_context")

  res <- rfe_rf(
    prep$X,
    prep$y,
    fold_id = grouped_folds$fold_id,
    small_step = small_step,
    cv_folds = cv_folds,
    ntree = ntree,
    seed = seed,
    use_smote = use_smote,
    over_ratio = over_ratio,
    smote_k = smote_k
  )

  res$fold_assignment <- grouped_folds$fold_assignment
  res$fold_class_table <- grouped_folds$fold_class_table
  res$cv_settings <- list(
    group_col = group_col,
    cv_folds = cv_folds,
    use_smote = use_smote,
    over_ratio = over_ratio,
    smote_k = smote_k,
    seed = seed
  )

  p <- ggplot(res$history, aes(x = n_features, y = accuracy)) +
    geom_line(linewidth = 0.7, colour = "grey40") +
    geom_point(size = 2) +
    geom_point(data = res$best, colour = "firebrick", size = 3.5) +
    geom_text(
      data = res$best,
      aes(label = sprintf("best: %d feats\nacc %.3f", n_features, accuracy)),
      vjust = -0.8,
      hjust = 0.5,
      size = 3,
      colour = "firebrick"
    ) +
    scale_x_reverse() +
    labs(
      title = paste0("RFE (randomForest, grouped ", cv_folds, "-fold CV) — ", task_name),
      subtitle = paste0(
        "Fold groups = ", group_col,
        if (use_smote) paste0("; SMOTE inside training folds, over_ratio = ", over_ratio) else ""
      ),
      x = "Number of features (eliminated left to right)",
      y = "Mean grouped-CV accuracy"
    ) +
    theme_minimal(base_size = 12)

  ggsave(out_plot, p, width = 8, height = 5, dpi = 150)
  print(p)

  readr::write_csv(res$ranking, out_csv)
  message("Wrote ranking -> ", out_csv)
  message("Wrote plot    -> ", out_plot)
  message(sprintf(
    "Best subset: %d features at mean grouped-CV accuracy %.4f",
    res$best$n_features,
    res$best$accuracy
  ))

  if (report_unknown) {
    unknown_df <- db %>% dplyr::filter(!(.data[[".row_id"]] %in% rec$df$.row_id))

    if (!is.null(unknown_sites)) {
      missing_sites <- setdiff(unknown_sites, unique(db$site_name))
      if (length(missing_sites)) {
        warning("site_name(s) not found in data: ", paste(missing_sites, collapse = ", "))
      }
      unknown_df <- unknown_df %>% dplyr::filter(.data$site_name %in% unknown_sites)
    }

    if (nrow(unknown_df) == 0) {
      message("No unknown instances to report.")
    } else {
      rep <- cv_unknown_report(
        prep$X,
        prep$y,
        unknown_df,
        ntree = ntree,
        folds = cv_folds,
        seed = seed,
        fold_id = grouped_folds$fold_id,
        focus_class = focus_class,
        use_smote = use_smote,
        over_ratio = over_ratio,
        smote_k = smote_k
      )
      res$unknown_all_features <- rep

      message(sprintf(
        "\n=== FIRST model (ALL %d features) | grouped %d-fold CV by %s ===",
        ncol(prep$X), cv_folds, group_col
      ))
      message(sprintf(
        "Per-fold held-out accuracy: %s | mean = %.4f",
        paste(sprintf("%.3f", rep$fold_acc), collapse = ", "),
        rep$mean_acc
      ))
      message(sprintf(
        "=== Predicted P('%s') per unknown site (all features, per-fold + mean over %d trained models) ===",
        focus_class, rep$trained_models
      ))
      print(as.data.frame(rep$table), row.names = FALSE)
    }
  }

  invisible(res)
}

# ---------------------------------------------------------------------
# 6. Example call
# ---------------------------------------------------------------------
# source("mulitilevel_tapho_db.R")
# system.time({
#   tb <- build_multilevel_tapho_features(
#     excel_path = "hspa.xlsx",
#     position_max = c(5, 1, 1, 3, 4, 3, 3, 5, 4, 3, 5),
#     levels = 1:5
#   )
# })
#
# source("rfe_randomforest_taphonomy.R")
# source("pca_funerary_surface_color.R")
#
# res <- run_rfe(
#   tb,
#   task_name = "fc_vs_rest",
#   unknown_sites = focus_sites,
#   group_col = "site_id",
#   use_smote = TRUE,
#   over_ratio = 1
# )
#
# res$unknown_all_features$table
# res$unknown_all_features$mean_acc
# res$fold_assignment
