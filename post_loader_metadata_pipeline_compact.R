# post_loader_metadata_pipeline_compact.R
#
# Compact post-loader workflow:
# tapho.loader()
#   -> clean_metadata()
#   -> metadata hierarchy construction/audit
#   -> EDA
#   -> skeletal metadata experiments
#   -> funerary-subtype experiment
#   -> CONSOLIDATE into a small number of output files
#
# Default visible outputs (normally 3 files):
#   1. tapho_clean_hierarchical.rds
#   2. metadata_analysis_tables.xlsx
#   3. metadata_analysis_objects.rds
#
# The EDA / experiment runners are executed in a temporary folder so their
# many intermediate CSV/HTML files do not clutter the final output directory.

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(readr)
  library(openxlsx)
})

source("metadata_core.R")

if (!exists("run_eda", mode = "function")) {
  source("eda_taphonomy.R")
}
if (!exists("run_skeletal_metadata_experiments", mode = "function")) {
  source("skeletal_metadata_experiments_runner_v3.R")
}

# ------------------------------------------------------------------
# Hierarchy-aware experiment definitions
# ------------------------------------------------------------------

.project_experiments <- function() {
  tibble::tribble(
    ~experiment_id, ~experiment_name, ~group_vars, ~covariates,
    ~hypothesis, ~expected_pattern, ~why_interesting,

    "E01", "taphonomic_context",
    list(c("taphonomic_context")), list(character(0)),
    "Accumulation cause is associated with skeletal-part representation.",
    "Skeletal profiles may differ among accumulation causes.",
    "Direct taphonomic comparison using only the main accumulation label.",

    "E02", "site_environment_main",
    list(c("site_environment")), list(c("taphonomic_context")),
    "Karstic and open-air settings impose different depositional filters.",
    "Broad preservation patterns may differ between karstic and open-air contexts.",
    "Treats karstic/open-air as one mutually-exclusive main variable.",

    "E03", "site_environment_detail",
    list(c("site_environment_detail")),
    list(c("taphonomic_context", "geological_period")),
    "Subtypes within karstic/open-air settings may further structure preservation.",
    "Cave interior, entrance, rockshelter, fluvial, eolian, lake, etc. may differ.",
    "Uses one hierarchical setting label rather than two independent columns.",

    "E04", "age_category",
    list(c("age_category")), list(c("mni", "degree_of_excavation")),
    "Age affects preservation and recovery.",
    "Younger individuals may show lower representation of fragile/small elements.",
    "Biological control.",

    "E05", "geological_period_date",
    list(c("geological_period", "date_bin")),
    list(c("mis_stage", "site_environment", "taphonomic_context")),
    "Time depth may alter skeletal preservation.",
    "Older contexts may show stronger attrition of fragile elements.",
    "Tests temporal structure while controlling for environment and taphonomy.",

    "E06", "hominin_species_controlled",
    list(c("hominin_species")),
    list(c("geological_period", "date_bin", "taphonomic_context", "site_environment")),
    "Species differences may partly reflect context rather than biology.",
    "Differences may weaken after contextual controls.",
    "Checks taxonomic confounding.",

    "E07", "region_country",
    list(c("region")),
    list(c("country", "site_environment", "degree_of_excavation")),
    "Regional differences may reflect geology and research/recovery history.",
    "Some regions may systematically preserve or recover different body parts.",
    "Bias-detection analysis.",

    "E08", "recovery_context",
    list(c("degree_of_excavation", "discovery_context")),
    list(c("count_type")),
    "Recovery history affects the observed skeletal profile.",
    "More systematic excavation may recover more small/fragile elements.",
    "Recovery-bias control."
  )
}

.install_project_experiments <- function() {
  assign(
    ".skel_default_experiments",
    .project_experiments,
    envir = .GlobalEnv
  )
  invisible(TRUE)
}

# ------------------------------------------------------------------
# Funerary subtype analysis — only inside Funerary Context
# ------------------------------------------------------------------

run_funeral_subtype_experiment_compact <- function(tb,
                                                   min_group_n = 3,
                                                   small_groups = "drop",
                                                   permutations = 9999) {
  if (!"funerary_subtype" %in% names(tb)) return(NULL)

  funerary_tb <- tb |>
    dplyr::filter(
      as.character(taphonomic_context) == "Funerary Context",
      !is.na(funerary_subtype),
      funerary_subtype != ""
    )

  if (nrow(funerary_tb) == 0 ||
      dplyr::n_distinct(funerary_tb$funerary_subtype) < 2) {
    message("Funerary subtype experiment skipped: fewer than 2 usable subtypes.")
    return(NULL)
  }

  tb_analysis <- .skel_prepare_tb(funerary_tb)
  features <- intersect(.skel_important_features_63(), names(tb_analysis))

  exp_row <- tibble::tibble(
    experiment_id = "F01",
    experiment_name = "funerary_subtype_within_funerary_context",
    group_vars = list(c("funerary_subtype")),
    covariates = list(c(
      "cultural_period",
      "degree_of_excavation",
      "discovery_context"
    )),
    hypothesis = "Burial subtype is associated with skeletal-part representation within Funerary Context only.",
    expected_pattern = "Different funerary practices may differ in completeness or selective representation.",
    why_interesting = "Respects funerary_context as a subtype, rather than treating it as independent of taphonomic_context."
  )

  .skel_analyse_one_experiment(
    tb_analysis = tb_analysis,
    experiment_row = exp_row,
    feature_cols = features,
    min_group_n = min_group_n,
    small_groups = small_groups,
    permutations = permutations
  )
}

# ------------------------------------------------------------------
# Workbook helpers
# ------------------------------------------------------------------

.safe_sheet <- function(x, used = character(0)) {
  x <- gsub("[\\[\\]\\*\\?/\\\\:]", "_", x)
  x <- substr(x, 1, 31)

  candidate <- x
  i <- 2
  while (candidate %in% used) {
    suffix <- paste0("_", i)
    candidate <- paste0(substr(x, 1, 31 - nchar(suffix)), suffix)
    i <- i + 1
  }
  candidate
}

.add_sheet <- function(wb, name, x, used) {
  if (is.null(x)) return(used)

  if (is.matrix(x)) {
    x <- tibble::as_tibble(x, rownames = "row")
  }

  if (!is.data.frame(x)) {
    x <- tibble::tibble(value = as.character(x))
  }

  nm <- .safe_sheet(name, used)
  openxlsx::addWorksheet(wb, nm)
  openxlsx::writeData(wb, nm, x)
  c(used, nm)
}

write_compact_metadata_workbook <- function(path,
                                            audit,
                                            manifest,
                                            eda_out,
                                            metadata_run,
                                            funeral_run) {
  wb <- openxlsx::createWorkbook()
  used <- character(0)

  used <- .add_sheet(wb, "hierarchy_audit", audit, used)
  used <- .add_sheet(wb, "augmentation_manifest", manifest, used)

  # ---------------- EDA ----------------
  if (!is.null(eda_out)) {
    used <- .add_sheet(wb, "EDA_feature_health", eda_out$health, used)
    used <- .add_sheet(wb, "EDA_by_class_stats", eda_out$by_class_stats, used)
    used <- .add_sheet(wb, "EDA_discriminative", eda_out$discriminative, used)
    used <- .add_sheet(wb, "EDA_redundant_pairs", eda_out$redundant, used)
    used <- .add_sheet(wb, "EDA_metadata_crosstabs", eda_out$crosstabs, used)

    if (!is.null(eda_out$correlation)) {
      cor_df <- as.data.frame(eda_out$correlation)
      cor_df <- tibble::rownames_to_column(cor_df, "feature")
      used <- .add_sheet(wb, "EDA_correlation", cor_df, used)
    }

    if (!is.null(eda_out$pca)) {
      pca_var <- summary(eda_out$pca)$importance |>
        as.data.frame() |>
        tibble::rownames_to_column("metric")
      used <- .add_sheet(wb, "EDA_PCA_variance", pca_var, used)

      pca_loadings <- as.data.frame(eda_out$pca$rotation) |>
        tibble::rownames_to_column("feature")
      used <- .add_sheet(wb, "EDA_PCA_loadings", pca_loadings, used)

      pca_scores <- as.data.frame(eda_out$pca$x) |>
        tibble::rownames_to_column("row")
      used <- .add_sheet(wb, "EDA_PCA_scores", pca_scores, used)
    }
  }

  # ---------------- Metadata experiments ----------------
  if (!is.null(metadata_run)) {
    used <- .add_sheet(
      wb, "META_master_summary",
      metadata_run$master_summary, used
    )
    used <- .add_sheet(
      wb, "META_feature_manifest",
      metadata_run$feature_manifest, used
    )

    if (!is.null(metadata_run$experiments)) {
      exp_export <- metadata_run$experiments
      list_cols <- names(exp_export)[vapply(exp_export, is.list, logical(1))]
      for (nm in list_cols) {
        exp_export[[nm]] <- vapply(
          exp_export[[nm]],
          function(z) paste(unlist(z), collapse = " + "),
          character(1)
        )
      }
      used <- .add_sheet(wb, "META_experiments", exp_export, used)
    }

    if (!is.null(metadata_run$results)) {
      for (id in names(metadata_run$results)) {
        res <- metadata_run$results[[id]]
        if (is.null(res)) next

        # Four compact sheets per experiment. Many sheets, but ONE workbook/file.
        used <- .add_sheet(wb, paste0(id, "_summary"), res$summary, used)
        used <- .add_sheet(wb, paste0(id, "_groups"), res$group_sizes, used)
        used <- .add_sheet(wb, paste0(id, "_top_features"), res$top_features, used)
        used <- .add_sheet(wb, paste0(id, "_permanova"), res$permanova, used)

        # Full statistical tables are stacked into one sheet per experiment.
        full_parts <- list()

        if (!is.null(res$kw) && nrow(res$kw)) {
          z <- res$kw
          z$table_type <- "kruskal_wallis"
          full_parts[[length(full_parts) + 1]] <- z
        }
        if (!is.null(res$dunn) && nrow(res$dunn)) {
          z <- res$dunn
          z$table_type <- "dunn_posthoc"
          full_parts[[length(full_parts) + 1]] <- z
        }
        if (!is.null(res$descriptives) && nrow(res$descriptives)) {
          z <- res$descriptives
          z$table_type <- "descriptives"
          full_parts[[length(full_parts) + 1]] <- z
        }

        if (length(full_parts)) {
          # Different tables have different columns; bind_rows keeps all information.
          full_tbl <- dplyr::bind_rows(full_parts)
          used <- .add_sheet(wb, paste0(id, "_full_stats"), full_tbl, used)
        }
      }
    }
  }

  # ---------------- Funerary subtype ----------------
  if (!is.null(funeral_run)) {
    used <- .add_sheet(wb, "FUN_summary", funeral_run$summary, used)
    used <- .add_sheet(wb, "FUN_groups", funeral_run$group_sizes, used)
    used <- .add_sheet(wb, "FUN_top_features", funeral_run$top_features, used)
    used <- .add_sheet(wb, "FUN_permanova", funeral_run$permanova, used)

    fun_parts <- list()
    if (!is.null(funeral_run$kw) && nrow(funeral_run$kw)) {
      z <- funeral_run$kw
      z$table_type <- "kruskal_wallis"
      fun_parts[[length(fun_parts) + 1]] <- z
    }
    if (!is.null(funeral_run$dunn) && nrow(funeral_run$dunn)) {
      z <- funeral_run$dunn
      z$table_type <- "dunn_posthoc"
      fun_parts[[length(fun_parts) + 1]] <- z
    }
    if (!is.null(funeral_run$descriptives) && nrow(funeral_run$descriptives)) {
      z <- funeral_run$descriptives
      z$table_type <- "descriptives"
      fun_parts[[length(fun_parts) + 1]] <- z
    }
    if (length(fun_parts)) {
      used <- .add_sheet(
        wb, "FUN_full_stats",
        dplyr::bind_rows(fun_parts),
        used
      )
    }
  }

  openxlsx::saveWorkbook(wb, path, overwrite = TRUE)
  invisible(path)
}

# ------------------------------------------------------------------
# Main compact pipeline
# ------------------------------------------------------------------

run_post_loader_metadata_pipeline <- function(tb,
                                              output_root = "post_loader_analysis",
                                              run_eda_step = TRUE,
                                              run_metadata_experiments = TRUE,
                                              run_funeral_subtype = TRUE,
                                              min_group_n = 5,
                                              permutations = 9999,
                                              strict_hierarchy = FALSE,
                                              compact_output = TRUE) {
  dir.create(output_root, recursive = TRUE, showWarnings = FALSE)

  # Use a temporary working directory for the verbose runners.
  work_root <- if (isTRUE(compact_output)) {
    tempfile("metadata_analysis_work_")
  } else {
    file.path(output_root, "detailed_outputs")
  }
  dir.create(work_root, recursive = TRUE, showWarnings = FALSE)

  # 1) Clean + hierarchy
  tb_clean <- prepare_project_metadata(
    tb,
    verbose = TRUE,
    strict = strict_hierarchy
  )

  audit <- metadata_hierarchy_audit(tb_clean)
  manifest <- augmentation_metadata_manifest(tb_clean)

  # Final visible file 1
  clean_path <- file.path(output_root, "tapho_clean_hierarchical.rds")
  saveRDS(tb_clean, clean_path)

  # 2) EDA
  eda_out <- NULL
  if (isTRUE(run_eda_step)) {
    assign(
      "context_vars",
      c(
        "geological_period", "cultural_period", "mis_stage",
        "region", "country", "hominin_species", "age_category",
        "site_environment", "site_environment_detail"
      ),
      envir = .GlobalEnv
    )

    eda_out <- run_eda(
      tb_clean,
      out_dir = file.path(work_root, "eda")
    )
  }

  # 3) Metadata experiments
  metadata_run <- NULL
  if (isTRUE(run_metadata_experiments)) {
    .install_project_experiments()

    metadata_run <- run_skeletal_metadata_experiments(
      tb_clean,
      output_root = file.path(work_root, "skeletal_metadata_experiments"),
      min_group_n = min_group_n,
      small_groups = "other",
      permutations = permutations,
      open_report = FALSE
    )
  }

  # 4) Funerary subtype experiment
  funeral_run <- NULL
  if (isTRUE(run_funeral_subtype)) {
    funeral_run <- tryCatch(
      run_funeral_subtype_experiment_compact(
        tb_clean,
        min_group_n = max(3, min_group_n),
        small_groups = "drop",
        permutations = permutations
      ),
      error = function(e) {
        message("Funerary subtype experiment failed: ", conditionMessage(e))
        NULL
      }
    )
  }

  # 5) Consolidate all tabular results into ONE workbook.
  workbook_path <- file.path(output_root, "metadata_analysis_tables.xlsx")
  write_compact_metadata_workbook(
    path = workbook_path,
    audit = audit,
    manifest = manifest,
    eda_out = eda_out,
    metadata_run = metadata_run,
    funeral_run = funeral_run
  )

  # 6) Preserve the complete R objects, including PCA and Plotly objects,
  # in ONE RDS file.
  object_path <- file.path(output_root, "metadata_analysis_objects.rds")
  full_object <- list(
    data = tb_clean,
    hierarchy_audit = audit,
    augmentation_manifest = manifest,
    eda = eda_out,
    metadata_experiments = metadata_run,
    funerary_subtype_experiment = funeral_run,
    settings = list(
      min_group_n = min_group_n,
      permutations = permutations,
      strict_hierarchy = strict_hierarchy
    )
  )
  saveRDS(full_object, object_path)

  # Delete verbose intermediate files when compact mode is on.
  if (isTRUE(compact_output) && dir.exists(work_root)) {
    unlink(work_root, recursive = TRUE, force = TRUE)
  }

  message("\nCompact metadata analysis complete.")
  message("Final output files:")
  message("  1. ", normalizePath(clean_path, mustWork = FALSE))
  message("  2. ", normalizePath(workbook_path, mustWork = FALSE))
  message("  3. ", normalizePath(object_path, mustWork = FALSE))

  invisible(full_object)
}
