# post_loader_metadata_pipeline.R
#
# Call AFTER tapho.loader().
#
# Example:
#   source("post_loader_metadata_pipeline.R")
#   analysis <- run_post_loader_metadata_pipeline(tapho_db)
#   tapho_clean <- analysis$data

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(readr)
})

source("metadata_core.R")

if (!exists("run_eda", mode = "function")) {
  source("eda_taphonomy.R")
}
if (!exists("run_skeletal_metadata_experiments", mode = "function")) {
  source("skeletal_metadata_experiments_runner_v3.R")
}

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
  # The runner looks up .skel_default_experiments() when it runs.
  assign(
    ".skel_default_experiments",
    .project_experiments,
    envir = .GlobalEnv
  )
  invisible(TRUE)
}

run_funeral_subtype_experiment <- function(tb,
                                           output_dir,
                                           min_group_n = 3,
                                           small_groups = "drop",
                                           permutations = 9999) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

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

  res <- .skel_analyse_one_experiment(
    tb_analysis = tb_analysis,
    experiment_row = exp_row,
    feature_cols = features,
    min_group_n = min_group_n,
    small_groups = small_groups,
    permutations = permutations
  )

  saveRDS(res, file.path(output_dir, "funerary_subtype_experiment.rds"))
  readr::write_csv(res$summary, file.path(output_dir, "funerary_subtype_summary.csv"))
  readr::write_csv(res$group_sizes, file.path(output_dir, "funerary_subtype_group_sizes.csv"))
  readr::write_csv(res$top_features, file.path(output_dir, "funerary_subtype_top_features.csv"))

  res
}

run_post_loader_metadata_pipeline <- function(tb,
                                              output_root = "post_loader_analysis",
                                              run_eda_step = TRUE,
                                              run_metadata_experiments = TRUE,
                                              run_funeral_subtype = TRUE,
                                              min_group_n = 5,
                                              permutations = 9999,
                                              strict_hierarchy = FALSE) {
  dir.create(output_root, recursive = TRUE, showWarnings = FALSE)

  # 1) Clean first, then encode the hierarchical metadata.
  tb_clean <- prepare_project_metadata(
    tb,
    verbose = TRUE,
    strict = strict_hierarchy
  )

  audit <- metadata_hierarchy_audit(tb_clean)
  manifest <- augmentation_metadata_manifest(tb_clean)

  readr::write_csv(audit, file.path(output_root, "metadata_hierarchy_audit.csv"))
  readr::write_csv(manifest, file.path(output_root, "augmentation_metadata_manifest.csv"))
  saveRDS(tb_clean, file.path(output_root, "tapho_clean_hierarchical.rds"))

  # 2) EDA. Replace raw mutually-exclusive columns with hierarchy-aware fields
  # in the contextual cross-tabs.
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
      out_dir = file.path(output_root, "eda")
    )
  }

  # 3) Metadata experiments with project-specific hierarchy-aware definitions.
  metadata_run <- NULL
  if (isTRUE(run_metadata_experiments)) {
    .install_project_experiments()

    metadata_run <- run_skeletal_metadata_experiments(
      tb_clean,
      output_root = file.path(output_root, "skeletal_metadata_experiments"),
      min_group_n = min_group_n,
      small_groups = "other",
      permutations = permutations,
      open_report = FALSE
    )
  }

  # 4) Dedicated funerary subtype analysis, restricted to Funerary Context rows.
  funeral_run <- NULL
  if (isTRUE(run_funeral_subtype)) {
    funeral_run <- tryCatch(
      run_funeral_subtype_experiment(
        tb_clean,
        output_dir = file.path(output_root, "funerary_subtype_experiment"),
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

  invisible(list(
    data = tb_clean,
    hierarchy_audit = audit,
    augmentation_manifest = manifest,
    eda = eda_out,
    metadata_experiments = metadata_run,
    funerary_subtype_experiment = funeral_run
  ))
}
