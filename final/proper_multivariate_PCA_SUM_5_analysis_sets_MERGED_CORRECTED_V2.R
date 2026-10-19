# ==============================================================================
# PROPER MULTIVARIATE PCA / ORDINATION ANALYSIS OF SKELETAL-PART REPRESENTATION
# ==============================================================================
#
# MERGED + CORRECTED VERSION
# - Full PCA / PERMANOVA / PERMDISP / Jaccard PCoA workflow.
# - Separate %MNAU and ReMNAU silhouette + elbow k-means diagnostics.
# - Corrected retained-PC permutation testing:
#     * uses colnames(pca$x), not names(pca$x)
#     * safely handles zero retained PCs.
# - Corrected ReMNAU PCA failure from NaN/Inf Hellinger rows:
#     * all-zero observed ReMNAU compositions are excluded with an audit file
#     * Hellinger transformation is implemented safely
#     * metadata rows remain aligned with transformed matrices
#     * non-finite inputs now stop with an informative error before svd()
#
#
# PRIMARY DATA:
#   final/tapho_db_sum.csv
#
# PURPOSE:
#   Multivariate analysis of skeletal-part representation across:
#     1) Four archaeological contexts
#     2) Funerary vs non-funerary
#     3) Funerary vs Cannibalism
#     4) C1-C5
#     5) G0-G5
#
# CONTINUOUS REPRESENTATIONS:
#   A) %MNAU  -> PCA on centered + standardized bone variables.
#                This retains the absolute skeletal-representation signal.
#
#   B) ReMNAU -> Hellinger transform followed by PCA.
#                ReMNAU is relative/compositional; Hellinger transformation
#                is used because it handles zeros without adding a pseudocount
#                and is appropriate for Euclidean ordination of relative data.
#
# PRESENCE / ABSENCE:
#   Presence is NOT analysed with ordinary PCA.
#   Binary bone occurrence is analysed with Jaccard PCoA, which is the more
#   appropriate multivariate ordination for presence/absence data.
#
# PRIMARY GROUP INFERENCE:
#   - PERMANOVA on the FULL multivariate feature matrix / distance matrix.
#     We do NOT test group separation using PC1 and PC2 alone.
#   - PERMDISP tests whether groups differ in multivariate dispersion.
#   - Pairwise PERMANOVA with Benjamini-Hochberg FDR correction.
#
# PCA-SPECIFIC INFERENCE:
#   - permutation parallel analysis for statistically supported PC retention
#   - broken-stick comparison
#   - permutation ANOVA of retained PC scores as SECONDARY interpretation
#
# IMPORTANT:
#   PCA itself is an ordination / dimension-reduction method. A PCA scatterplot
#   is not a significance test. Statistical group inference is performed with
#   PERMANOVA on the full transformed feature matrix, with PERMDISP reported
#   alongside it.
#
# C/G INDEPENDENCE:
#   A parent site that occurs in more than one C or G group is excluded from
#   the inferential C/G analysis by default. This prevents one archaeological
#   parent site from acting as two independent observations in PERMANOVA.
#
# C/G SUM JOIN:
#   tapho_db_ind is used ONLY as a bridge from site_id to C/G labels.
#   Skeletal values always come from tapho_db_sum.
#
#   The join first uses the detailed SUM key:
#       site_name + layer_name + taphonomic_context + funerary_context
#   and then fills unmatched SUM rows from a site-level C/G consensus ONLY
#   when that parent site has one unambiguous C and/or G assignment.
#   This fixes summed multi-layer rows such as Arago while preserving genuinely
#   multi-group sites such as Grotte de Fontbregoua and Cova Foradada.
#
# PCA ASSUMPTIONS / "PRE-PCA TESTS":
#   PCA does NOT require multivariate normality.
#   KMO and Bartlett tests are therefore not treated as PCA assumptions here.
#   Instead, the script audits:
#     - missingness
#     - zero-variance variables
#     - very rare skeletal parts
#     - sample size and feature count
#     - correlations
#     - numerical rank
#     - supported PC count by permutation parallel analysis
#
# OUTPUT:
#   proper_multivariate_PCA_SUM_outputs/
#
# ==============================================================================


# ==============================================================================
# 0. USER SETTINGS
# ==============================================================================

SEED <- 20260913

# Main permutation count for publication-quality inference.
# 9999 is recommended for final results. Use 999 while debugging if needed.
N_PERM <- 9999

# Parallel-analysis permutations. 499 or 999 is usually adequate.
N_PARALLEL <- 499

# Very rare standardized variables can dominate a correlation PCA.
# A bone must occur in at least this many independent site observations
# within the current analysis dataset to enter the PCA.
MIN_NONZERO_SITES <- 3

# Also require this minimum prevalence. Set 0 to disable.
MIN_PREVALENCE <- 0.05

# PCA plots show 90% concentration ellipses.
# These ellipses describe the scatter of observations; they are NOT confidence
# intervals for group means and are NOT significance tests.
ELLIPSE_LEVEL <- 0.90

# Correct presence/absence ordination.
RUN_PRESENCE_PCOA <- TRUE

# For C/G analyses, exclude parent sites occurring in >1 group from formal
# multivariate inference and PCA. This gives independent parent-site units.
EXCLUDE_CROSS_GROUP_SITES <- TRUE

# Stop if bone NAs are found. Change only if you KNOW that NA means absent.
ALLOW_NA_AS_ZERO <- FALSE

# ------------------------------------------------------------------------------
# Unsupervised cluster-number diagnostics for %MNAU and ReMNAU
# ------------------------------------------------------------------------------
# The clustering is performed separately for %MNAU and ReMNAU on independent
# parent-site rows. Archaeological labels are NOT used to create the clusters.
#
# k is evaluated with BOTH:
#   - average silhouette width (larger is better)
#   - elbow of total within-cluster sum of squares (WSS)
#
# The elbow is a heuristic, not a significance test. If silhouette and elbow
# disagree, both solutions are retained and reported rather than forcing one.
CLUSTER_K_MIN <- 2
CLUSTER_K_MAX <- 10
CLUSTER_NSTART <- 100
CLUSTER_ITER_MAX <- 1000

# Use the same known four archaeological-context sites as the main context
# analysis. Set FALSE only if you intentionally want unknown/other contexts.
CLUSTER_ONLY_KNOWN_FOUR_CLASS <- TRUE

OUT_DIR <- "proper_multivariate_PCA_SUM_outputs"


# ==============================================================================
# 1. PACKAGES
# ==============================================================================

required_packages <- c(
  "tidyverse",
  "vegan",
  "cluster"
)

missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(missing_packages) > 0) {
  stop(
    "Install the following packages before running this script:\n  ",
    paste(missing_packages, collapse = ", "),
    "\n\nRun:\ninstall.packages(c(",
    paste0('"', missing_packages, '"', collapse = ", "),
    "))"
  )
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(vegan)
})

set.seed(SEED)

dir.create(
  OUT_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(OUT_DIR, "plots"),
  recursive = TRUE,
  showWarnings = FALSE
)


# ==============================================================================
# 2. LOCATE INPUT FILES
# ==============================================================================

find_first_existing <- function(paths) {
  hits <- paths[file.exists(paths)]
  if (length(hits) == 0) NA_character_ else hits[[1]]
}

SUM_FILE <- find_first_existing(
  c(
    "final/tapho_db_sum.csv",
    "tapho_db_sum.csv"
  )
)

IND_FILE <- find_first_existing(
  c(
    "final/tapho_db_ind.csv",
    "tapho_db_ind.csv",
    "tapho_db_ind(2).csv"
  )
)

assignment_candidates <- c(
  "site_C1_C5_G0_G5_assignments_compact(2).csv",
  "site_C1_C5_G0_G5_assignments_compact.csv",
  file.path("final", "site_C1_C5_G0_G5_assignments_compact(2).csv"),
  file.path("final", "site_C1_C5_G0_G5_assignments_compact.csv"),
  "11_SITE_C1_C5_G0_G5_ASSIGNMENTS_USED.csv",
  file.path("final", "11_SITE_C1_C5_G0_G5_ASSIGNMENTS_USED.csv")
)

ASSIGNMENT_FILE <- find_first_existing(
  assignment_candidates
)

if (is.na(ASSIGNMENT_FILE)) {
  extra <- unique(
    c(
      list.files(
        ".",
        pattern = "C1_C5_G0_G5.*\\.csv$",
        full.names = TRUE
      ),
      if (dir.exists("final")) {
        list.files(
          "final",
          pattern = "C1_C5_G0_G5.*\\.csv$",
          full.names = TRUE
        )
      } else {
        character(0)
      }
    )
  )

  if (length(extra) == 1) {
    ASSIGNMENT_FILE <- extra[[1]]
  }
}

if (is.na(SUM_FILE)) {
  stop("Cannot find tapho_db_sum.csv.")
}

if (is.na(IND_FILE)) {
  stop(
    "Cannot find tapho_db_ind.csv. ",
    "It is required only to transfer site_id-based C/G labels."
  )
}

if (is.na(ASSIGNMENT_FILE)) {
  stop(
    "Cannot find the C1-C5 / G0-G5 assignment CSV."
  )
}

cat(
  "\n============================================================\n",
  "PROPER MULTIVARIATE PCA / PCoA ANALYSIS\n",
  "SUM skeletal data: ", SUM_FILE, "\n",
  "IND C/G bridge:    ", IND_FILE, "\n",
  "C/G assignments:   ", ASSIGNMENT_FILE, "\n",
  "Output directory:  ", OUT_DIR, "\n",
  "============================================================\n\n",
  sep = ""
)


# ==============================================================================
# 3. READ DATA
# ==============================================================================

d <- readr::read_csv(
  SUM_FILE,
  show_col_types = FALSE
) %>%
  mutate(
    sum_record_id = row_number()
  )

ind_bridge <- readr::read_csv(
  IND_FILE,
  show_col_types = FALSE
)

assignments <- readr::read_csv(
  ASSIGNMENT_FILE,
  show_col_types = FALSE
)


required_sum <- c(
  "site_name",
  "layer_name",
  "taphonomic_context",
  "funerary_context"
)

required_ind <- c(
  "site_id",
  "site_name",
  "layer_name",
  "taphonomic_context",
  "funerary_context"
)

required_assignment <- c(
  "site_id",
  "site_name",
  "C_group",
  "G_group"
)

for (x in setdiff(required_sum, names(d))) {
  stop("tapho_db_sum.csv is missing required column: ", x)
}

for (x in setdiff(required_ind, names(ind_bridge))) {
  stop("tapho_db_ind.csv is missing required column: ", x)
}

for (x in setdiff(required_assignment, names(assignments))) {
  stop("C/G assignment CSV is missing required column: ", x)
}

# Add optional description fields if absent.
if (!"C_description" %in% names(assignments)) {
  assignments$C_description <- NA_character_
}

if (!"G_description" %in% names(assignments)) {
  assignments$G_description <- NA_character_
}

ind_bridge <- ind_bridge %>%
  mutate(
    site_id = as.character(site_id)
  )

assignments <- assignments %>%
  mutate(
    site_id = as.character(site_id)
  )

if (anyDuplicated(assignments$site_id)) {
  stop(
    "site_id is duplicated in the C/G assignment table. ",
    "Each site_id must map to one assignment row."
  )
}


# ==============================================================================
# 4. ARCHAEOLOGICAL CLASS LABELS
# ==============================================================================

collapse_class4 <- function(x) {

  case_when(
    x == "Funerary Context" ~ "Funerary Context",
    x == "Cannibalism" ~ "Cannibalism",

    x %in% c(
      "Carnivore",
      "Carnivore-related",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)",
      "Carnivore den (transport)"
    ) ~ "Carnivore",

    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

d <- d %>%
  mutate(
    class4 = collapse_class4(
      taphonomic_context
    ),

    F_NF = case_when(
      class4 == "Funerary Context" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    )
  )


# ==============================================================================
# 5. ROBUST C/G LABEL TRANSFER FROM IND -> SUM
# ==============================================================================

first_unique_non_na <- function(x) {
  y <- unique(na.omit(x))
  if (length(y) == 1) y[[1]] else NA_character_
}

# Join site_id assignments to IND rows.
ind_assignment_bridge <- ind_bridge %>%
  select(
    site_id,
    site_name,
    layer_name,
    taphonomic_context,
    funerary_context
  ) %>%
  distinct() %>%
  left_join(
    assignments %>%
      select(
        site_id,
        assignment_site_name = site_name,
        C_group,
        C_description,
        G_group,
        G_description
      ),
    by = "site_id"
  )

# Audit site_id -> name consistency.
bridge_audit <- ind_assignment_bridge %>%
  mutate(
    assignment_found =
      !is.na(C_group) |
      !is.na(G_group),

    site_name_agrees =
      is.na(assignment_site_name) |
      site_name == assignment_site_name
  )

write_csv(
  bridge_audit,
  file.path(
    OUT_DIR,
    "00A_IND_assignment_bridge_audit.csv"
  )
)

if (
  any(
    !bridge_audit$site_name_agrees,
    na.rm = TRUE
  )
) {
  warning(
    "Some site_id matches disagree on site_name. ",
    "Inspect 00A_IND_assignment_bridge_audit.csv."
  )
}


# ------------------------------------------------------------------------------
# 5A. Detailed exact-key join
# ------------------------------------------------------------------------------

SUM_KEYS <- c(
  "site_name",
  "layer_name",
  "taphonomic_context",
  "funerary_context"
)

exact_lookup <- ind_assignment_bridge %>%
  filter(
    !is.na(C_group) |
      !is.na(G_group)
  ) %>%
  group_by(
    across(
      all_of(SUM_KEYS)
    )
  ) %>%
  summarise(
    C_group_exact =
      first_unique_non_na(C_group),

    C_description_exact =
      first_unique_non_na(C_description),

    G_group_exact =
      first_unique_non_na(G_group),

    G_description_exact =
      first_unique_non_na(G_description),

    .groups = "drop"
  )

d <- d %>%
  left_join(
    exact_lookup,
    by = SUM_KEYS,
    na_matches = "na"
  )


# ------------------------------------------------------------------------------
# 5B. Site-level consensus fallback
# ------------------------------------------------------------------------------

# This is the important fix for SUM rows in which several IND layer names were
# concatenated. We fill a missing C or G label by site_name ONLY if all assigned
# IND rows for that parent site agree on that C or G group.
site_consensus <- ind_assignment_bridge %>%
  filter(
    !is.na(C_group) |
      !is.na(G_group)
  ) %>%
  group_by(
    site_name
  ) %>%
  summarise(
    n_C_groups =
      n_distinct(
        C_group[
          !is.na(C_group)
        ]
      ),

    n_G_groups =
      n_distinct(
        G_group[
          !is.na(G_group)
        ]
      ),

    C_group_consensus =
      first_unique_non_na(C_group),

    C_description_consensus =
      first_unique_non_na(C_description),

    G_group_consensus =
      first_unique_non_na(G_group),

    G_description_consensus =
      first_unique_non_na(G_description),

    .groups = "drop"
  )

write_csv(
  site_consensus,
  file.path(
    OUT_DIR,
    "00B_CG_site_consensus_audit.csv"
  )
)

d <- d %>%
  left_join(
    site_consensus,
    by = "site_name"
  ) %>%
  mutate(
    C_group =
      coalesce(
        C_group_exact,
        C_group_consensus
      ),

    C_description =
      coalesce(
        C_description_exact,
        C_description_consensus
      ),

    G_group =
      coalesce(
        G_group_exact,
        G_group_consensus
      ),

    G_description =
      coalesce(
        G_description_exact,
        G_description_consensus
      )
  ) %>%
  select(
    -ends_with("_exact"),
    -ends_with("_consensus"),
    -n_C_groups,
    -n_G_groups
  )


join_audit <- d %>%
  transmute(
    sum_record_id,
    site_name,
    layer_name,
    taphonomic_context,
    funerary_context,
    class4,
    F_NF,
    C_group,
    G_group,
    matched_C = !is.na(C_group),
    matched_G = !is.na(G_group)
  )

write_csv(
  join_audit,
  file.path(
    OUT_DIR,
    "00C_CG_join_audit_SUM_FIXED.csv"
  )
)


# ==============================================================================
# 6. IDENTIFY BONE VARIABLES AND AUDIT MISSING VALUES
# ==============================================================================

prop_cols_initial <- names(d)[
  stringr::str_starts(
    names(d),
    "ProportionalRep_MNIbased_"
  )
]

rem_cols_initial <- names(d)[
  stringr::str_starts(
    names(d),
    "ReMNAU_"
  ) &
    !stringr::str_starts(
      names(d),
      "ReMNAU_adjusted_"
    )
]

if (length(prop_cols_initial) == 0) {
  stop(
    "No ProportionalRep_MNIbased_* columns were found."
  )
}

if (length(rem_cols_initial) == 0) {
  stop(
    "No raw ReMNAU_* columns were found."
  )
}

bone_na_audit <- tibble(
  variable = c(
    prop_cols_initial,
    rem_cols_initial
  )
) %>%
  mutate(
    representation = if_else(
      str_starts(
        variable,
        "ProportionalRep_MNIbased_"
      ),
      "%MNAU",
      "ReMNAU"
    ),

    n_NA = map_int(
      variable,
      function(v) {
        sum(
          is.na(
            d[[v]]
          )
        )
      }
    )
  )

write_csv(
  bone_na_audit,
  file.path(
    OUT_DIR,
    "00D_bone_NA_audit.csv"
  )
)

if (any(bone_na_audit$n_NA > 0)) {

  if (!ALLOW_NA_AS_ZERO) {
    stop(
      "NA values were found in skeletal-part variables. ",
      "No imputation is used. Inspect 00D_bone_NA_audit.csv."
    )
  }

  bone_cols_all <- c(
    prop_cols_initial,
    rem_cols_initial
  )

  for (v in bone_cols_all) {
    d[[v]][is.na(d[[v]])] <- 0
  }
}


# ==============================================================================
# 7. BILATERAL INDETERMINATE REDISTRIBUTION
# ==============================================================================

find_exact_triplets <- function(
  data_names,
  prefix
) {

  cols <- data_names[
    str_starts(
      data_names,
      prefix
    )
  ]

  stems <- str_remove(
    cols,
    fixed(prefix)
  )

  indet_bases <- stems[
    str_ends(
      stems,
      "_indet"
    )
  ] %>%
    str_remove(
      "_indet$"
    )

  keep <- map_lgl(
    indet_bases,
    function(base) {

      all(
        paste0(
          prefix,
          base,
          c(
            "_indet",
            "_left",
            "_right"
          )
        ) %in%
          data_names
      )
    }
  )

  sort(
    unique(
      indet_bases[keep]
    )
  )
}


redistribute_triplets <- function(
  dat,
  prefix,
  cap = NULL
) {

  triplet_bases <- find_exact_triplets(
    names(dat),
    prefix
  )

  audit <- vector(
    "list",
    length(triplet_bases)
  )

  for (i in seq_along(triplet_bases)) {

    base <- triplet_bases[[i]]

    c_indet <- paste0(
      prefix,
      base,
      "_indet"
    )

    c_left <- paste0(
      prefix,
      base,
      "_left"
    )

    c_right <- paste0(
      prefix,
      base,
      "_right"
    )

    indet <- dat[[c_indet]]
    left <- dat[[c_left]]
    right <- dat[[c_right]]

    original_indet_total <- sum(
      indet,
      na.rm = TRUE
    )

    new_left <- left + indet / 2
    new_right <- right + indet / 2

    residual <- rep(
      0,
      nrow(dat)
    )

    if (!is.null(cap)) {

      overflow_left <- pmax(
        new_left - cap,
        0
      )

      overflow_right <- pmax(
        new_right - cap,
        0
      )

      new_left <- pmin(
        new_left,
        cap
      )

      new_right <- pmin(
        new_right,
        cap
      )

      room_right <- pmax(
        cap - new_right,
        0
      )

      move_left_to_right <- pmin(
        overflow_left,
        room_right
      )

      new_right <-
        new_right +
        move_left_to_right

      rem_left <-
        overflow_left -
        move_left_to_right

      room_left <- pmax(
        cap - new_left,
        0
      )

      move_right_to_left <- pmin(
        overflow_right,
        room_left
      )

      new_left <-
        new_left +
        move_right_to_left

      rem_right <-
        overflow_right -
        move_right_to_left

      residual <-
        rem_left +
        rem_right
    }

    dat[[c_left]] <- new_left
    dat[[c_right]] <- new_right
    dat[[c_indet]] <- residual

    audit[[i]] <- tibble(
      representation_prefix = prefix,
      bone = base,
      original_indet_total =
        original_indet_total,
      residual_indet_total =
        sum(
          residual,
          na.rm = TRUE
        )
    )
  }

  list(
    data = dat,
    triplet_bases = triplet_bases,
    audit = bind_rows(audit)
  )
}


prop_red <- redistribute_triplets(
  d,
  prefix = "ProportionalRep_MNIbased_",
  cap = 1
)

d <- prop_red$data

rem_red <- redistribute_triplets(
  d,
  prefix = "ReMNAU_",
  cap = NULL
)

d <- rem_red$data

write_csv(
  bind_rows(
    prop_red$audit,
    rem_red$audit
  ),
  file.path(
    OUT_DIR,
    "00E_bilateral_redistribution_audit.csv"
  )
)


# ==============================================================================
# 8. BUILD BONE-LEVEL WIDE MATRICES
# ==============================================================================

make_bone_wide <- function(
  dat,
  prefix,
  representation_name,
  triplet_bases,
  exclude_regex = NULL
) {

  vars <- names(dat)[
    str_starts(
      names(dat),
      prefix
    )
  ]

  if (!is.null(exclude_regex)) {
    vars <- vars[
      !str_detect(
        vars,
        exclude_regex
      )
    ]
  }

  paired_indet_cols <- paste0(
    prefix,
    triplet_bases,
    "_indet"
  )

  vars <- setdiff(
    vars,
    paired_indet_cols
  )

  manifest <- tibble(
    variable = vars,
    stem = str_remove(
      vars,
      fixed(prefix)
    )
  ) %>%
    mutate(
      bone = map_chr(
        stem,
        function(s) {

          matched_base <- triplet_bases[
            paste0(
              triplet_bases,
              "_left"
            ) == s |
              paste0(
                triplet_bases,
                "_right"
              ) == s
          ]

          if (length(matched_base) == 1) {
            matched_base[[1]]
          } else {
            s
          }
        }
      ),

      representation =
        representation_name
    )

  bones <- sort(
    unique(
      manifest$bone
    )
  )

  out <- dat %>%
    select(
      sum_record_id,
      site_name,
      layer_name,
      taphonomic_context,
      funerary_context,
      class4,
      F_NF,
      C_group,
      C_description,
      G_group,
      G_description,
      all_of(vars)
    )

  for (bone_name in bones) {

    v <- manifest %>%
      filter(
        bone == bone_name
      ) %>%
      pull(
        variable
      )

    out[[bone_name]] <- rowMeans(
      as.matrix(
        out[
          ,
          v,
          drop = FALSE
        ]
      ),
      na.rm = FALSE
    )
  }

  out <- out %>%
    select(
      sum_record_id,
      site_name,
      layer_name,
      taphonomic_context,
      funerary_context,
      class4,
      F_NF,
      C_group,
      C_description,
      G_group,
      G_description,
      all_of(bones)
    )

  list(
    wide = out,
    bones = bones,
    manifest = manifest
  )
}


prop_bones <- make_bone_wide(
  d,
  prefix = "ProportionalRep_MNIbased_",
  representation_name = "%MNAU",
  triplet_bases = prop_red$triplet_bases
)

rem_bones <- make_bone_wide(
  d,
  prefix = "ReMNAU_",
  representation_name = "ReMNAU",
  triplet_bases = rem_red$triplet_bases,
  exclude_regex = "^ReMNAU_adjusted_"
)

write_csv(
  bind_rows(
    prop_bones$manifest,
    rem_bones$manifest
  ),
  file.path(
    OUT_DIR,
    "01_bone_feature_manifest.csv"
  )
)


# ==============================================================================
# 9. TASK DEFINITIONS
# ==============================================================================

task_levels <- list(
  four_class = c(
    "Funerary Context",
    "Cannibalism",
    "Carnivore",
    "Geological transport"
  ),

  F_vs_NF = c(
    "NF",
    "F"
  ),

  Funerary_vs_Cannibalism = c(
    "Cannibalism",
    "Funerary Context"
  ),

  C1_C5 = paste0(
    "C",
    1:5
  ),

  G0_G5 = paste0(
    "G",
    0:5
  )
)


make_task_data <- function(
  wide,
  bone_cols,
  task
) {

  if (task == "four_class") {

    z <- wide %>%
      filter(
        !is.na(class4)
      ) %>%
      mutate(
        analysis_group = class4
      )

  } else if (task == "F_vs_NF") {

    z <- wide %>%
      filter(
        !is.na(F_NF)
      ) %>%
      mutate(
        analysis_group = F_NF
      )

  } else if (
    task ==
      "Funerary_vs_Cannibalism"
  ) {

    z <- wide %>%
      filter(
        class4 %in%
          c(
            "Funerary Context",
            "Cannibalism"
          )
      ) %>%
      mutate(
        analysis_group = class4
      )

  } else if (task == "C1_C5") {

    z <- wide %>%
      filter(
        !is.na(C_group)
      ) %>%
      mutate(
        analysis_group = C_group
      )

  } else if (task == "G0_G5") {

    z <- wide %>%
      filter(
        !is.na(G_group)
      ) %>%
      mutate(
        analysis_group = G_group
      )

  } else {
    stop(
      "Unknown task: ",
      task
    )
  }

  # Average repeated SUM rows from the same parent site inside the same group.
  # This keeps the inferential unit at parent-site level.
  z <- z %>%
    group_by(
      site_name,
      analysis_group
    ) %>%
    summarise(
      across(
        all_of(bone_cols),
        ~ mean(
          .x,
          na.rm = FALSE
        )
      ),
      .groups = "drop"
    )

  # Identify parent sites appearing in more than one group.
  multi_group_sites <- z %>%
    group_by(
      site_name
    ) %>%
    summarise(
      n_groups =
        n_distinct(
          analysis_group
        ),
      groups =
        paste(
          sort(
            unique(
              analysis_group
            )
          ),
          collapse = "; "
        ),
      .groups = "drop"
    ) %>%
    filter(
      n_groups > 1
    )

  if (
    task %in%
      c(
        "C1_C5",
        "G0_G5"
      ) &&
      EXCLUDE_CROSS_GROUP_SITES &&
      nrow(multi_group_sites) > 0
  ) {

    z <- z %>%
      filter(
        !site_name %in%
          multi_group_sites$site_name
      )
  }

  requested_levels <- task_levels[[task]]

  z <- z %>%
    mutate(
      analysis_group =
        factor(
          analysis_group,
          levels =
            requested_levels[
              requested_levels %in%
                unique(
                  as.character(
                    analysis_group
                  )
                )
            ]
        )
    ) %>%
    filter(
      !is.na(
        analysis_group
      )
    )

  list(
    data = z,
    multi_group_sites =
      multi_group_sites
  )
}


# ==============================================================================
# 10. PREPROCESSING FOR MULTIVARIATE ANALYSIS
# ==============================================================================

# ------------------------------------------------------------------------------
# Robust matrix helpers
# ------------------------------------------------------------------------------

assert_finite_matrix <- function(
  X,
  label = "matrix"
) {

  bad <- which(
    !is.finite(X),
    arr.ind = TRUE
  )

  if (nrow(bad) > 0) {

    bad_rows <- unique(
      bad[, "row"]
    )

    bad_cols <- unique(
      bad[, "col"]
    )

    bad_col_names <- colnames(X)[
      bad_cols
    ]

    stop(
      label,
      " contains non-finite values (NA/NaN/Inf).\n",
      "Affected row indices: ",
      paste(
        head(
          bad_rows,
          20
        ),
        collapse = ", "
      ),
      if (length(bad_rows) > 20) " ..." else "",
      "\nAffected variables: ",
      paste(
        head(
          bad_col_names,
          20
        ),
        collapse = ", "
      ),
      if (length(bad_col_names) > 20) " ..." else "",
      "\nThe PCA was stopped before svd() so the source data can be inspected."
    )
  }

  invisible(TRUE)
}


safe_hellinger <- function(
  X
) {

  X <- as.matrix(X)
  storage.mode(X) <- "double"

  assert_finite_matrix(
    X,
    "Hellinger input"
  )

  if (
    any(
      X < 0
    )
  ) {
    stop(
      "Hellinger transformation requires non-negative values, ",
      "but negative values were found."
    )
  }

  rs <- rowSums(X)

  out <- matrix(
    0,
    nrow = nrow(X),
    ncol = ncol(X),
    dimnames = dimnames(X)
  )

  positive_rows <-
    is.finite(rs) &
    rs > 0

  if (
    any(
      positive_rows
    )
  ) {

    out[
      positive_rows,
      ,
      drop = FALSE
    ] <-
      sqrt(
        X[
          positive_rows,
          ,
          drop = FALSE
        ] /
          rs[
            positive_rows
          ]
      )
  }

  assert_finite_matrix(
    out,
    "Hellinger-transformed matrix"
  )

  out
}


safe_z_scale <- function(
  X
) {

  X <- as.matrix(X)
  storage.mode(X) <- "double"

  assert_finite_matrix(
    X,
    "z-standardization input"
  )

  sds <- apply(
    X,
    2,
    sd
  )

  bad_sd <-
    !is.finite(sds) |
    sds <= sqrt(
      .Machine$double.eps
    )

  if (
    any(
      bad_sd
    )
  ) {
    stop(
      "Near-zero or non-finite standard deviations remain after feature filtering: ",
      paste(
        colnames(X)[
          bad_sd
        ],
        collapse = ", "
      )
    )
  }

  out <- scale(
    X,
    center = TRUE,
    scale = TRUE
  )

  assert_finite_matrix(
    out,
    "z-standardized matrix"
  )

  out
}


prepare_continuous_matrix <- function(
  task_df,
  bone_cols,
  representation
) {

  X_raw <- as.matrix(
    task_df[
      ,
      bone_cols,
      drop = FALSE
    ]
  )

  storage.mode(
    X_raw
  ) <- "double"

  assert_finite_matrix(
    X_raw,
    paste0(
      representation,
      " raw task matrix"
    )
  )

  feature_audit <- tibble(
    bone = colnames(X_raw),
    n_sites = nrow(X_raw),
    n_nonzero =
      colSums(
        X_raw > 0
      ),
    prevalence =
      colMeans(
        X_raw > 0
      ),
    mean =
      colMeans(
        X_raw
      ),
    sd =
      apply(
        X_raw,
        2,
        sd
      ),
    min =
      apply(
        X_raw,
        2,
        min
      ),
    max =
      apply(
        X_raw,
        2,
        max
      )
  ) %>%
    mutate(
      zero_or_near_zero_variance =
        !is.finite(sd) |
        sd <=
          sqrt(
            .Machine$double.eps
          ),

      too_rare =
        n_nonzero <
          MIN_NONZERO_SITES |
        prevalence <
          MIN_PREVALENCE,

      keep_for_PCA =
        !zero_or_near_zero_variance &
        !too_rare
    )

  keep_bones <- feature_audit %>%
    filter(
      keep_for_PCA
    ) %>%
    pull(
      bone
    )

  if (length(keep_bones) < 2) {
    stop(
      "Fewer than two usable bone variables remain after filtering for ",
      representation,
      "."
    )
  }

  X_keep_all <- X_raw[
    ,
    keep_bones,
    drop = FALSE
  ]

  # row_keep always refers to the rows of the incoming task_df.
  row_keep <- rep(
    TRUE,
    nrow(
      X_keep_all
    )
  )

  exclusion_reason <- rep(
    NA_character_,
    nrow(
      X_keep_all
    )
  )

  if (representation == "%MNAU") {

    X_keep <- X_keep_all

    X_model <- safe_z_scale(
      X_keep
    )

    pca <- prcomp(
      X_model,
      center = FALSE,
      scale. = FALSE
    )

    transform_note <-
      "raw %MNAU -> prevalence filter -> z-standardization"

  } else if (
    representation ==
      "ReMNAU"
  ) {

    if (
      any(
        X_keep_all < 0
      )
    ) {
      stop(
        "Negative ReMNAU values were found. ",
        "Hellinger PCA requires non-negative input."
      )
    }

    row_totals <- rowSums(
      X_keep_all
    )

    # A row containing zero across all retained ReMNAU parts has no defined
    # relative anatomical composition. It must not enter a compositional PCA.
    row_keep <-
      is.finite(
        row_totals
      ) &
      row_totals > 0

    exclusion_reason[
      !row_keep
    ] <-
      "all retained ReMNAU skeletal parts sum to zero"

    if (
      sum(
        row_keep
      ) < 3
    ) {
      stop(
        "Too few non-zero ReMNAU site rows remain for PCA after excluding ",
        "rows with undefined relative composition."
      )
    }

    X_keep <- X_keep_all[
      row_keep,
      ,
      drop = FALSE
    ]

    X_model <- safe_hellinger(
      X_keep
    )

    assert_finite_matrix(
      X_model,
      "ReMNAU Hellinger PCA matrix"
    )

    pca <- prcomp(
      X_model,
      center = TRUE,
      scale. = FALSE
    )

    transform_note <-
      paste0(
        "raw ReMNAU -> prevalence filter -> exclude all-zero composition rows -> ",
        "safe Hellinger transform"
      )

  } else {
    stop(
      "Unknown representation: ",
      representation
    )
  }

  assert_finite_matrix(
    pca$x,
    paste0(
      representation,
      " PCA scores"
    )
  )

  assert_finite_matrix(
    pca$rotation,
    paste0(
      representation,
      " PCA loadings"
    )
  )

  list(
    X_raw = X_raw,
    X_keep_all = X_keep_all,
    X_keep = X_keep,
    X_model = X_model,
    feature_audit = feature_audit,
    keep_bones = keep_bones,
    pca = pca,
    row_keep = row_keep,
    exclusion_reason =
      exclusion_reason,
    transform_note =
      transform_note
  )
}


# ==============================================================================
# 11. PARALLEL ANALYSIS + BROKEN-STICK
# ==============================================================================

fit_pca_for_representation <- function(
  X,
  representation
) {

  X <- as.matrix(X)
  storage.mode(X) <- "double"

  assert_finite_matrix(
    X,
    paste0(
      representation,
      " parallel-analysis input"
    )
  )

  if (representation == "%MNAU") {

    X_model <- safe_z_scale(
      X
    )

    prcomp(
      X_model,
      center = FALSE,
      scale. = FALSE
    )

  } else if (
    representation ==
      "ReMNAU"
  ) {

    if (
      any(
        X < 0
      )
    ) {
      stop(
        "Negative ReMNAU values encountered in parallel analysis."
      )
    }

    # Independent column permutation can occasionally create an all-zero row.
    # safe_hellinger() leaves such null-model rows as zero vectors rather than
    # generating NaN/Inf. Observed all-zero ReMNAU rows are excluded earlier.
    X_model <- safe_hellinger(
      X
    )

    prcomp(
      X_model,
      center = TRUE,
      scale. = FALSE
    )

  } else {
    stop(
      "Unknown representation in fit_pca_for_representation(): ",
      representation
    )
  }
}


parallel_analysis <- function(
  X_raw,
  representation,
  B = N_PARALLEL
) {

  observed_pca <-
    fit_pca_for_representation(
      X_raw,
      representation
    )

  obs_eigen <-
    observed_pca$sdev^2

  n_pc <-
    length(
      obs_eigen
    )

  perm_eigen <- matrix(
    NA_real_,
    nrow = B,
    ncol = n_pc
  )

  for (b in seq_len(B)) {

    X_perm <- apply(
      X_raw,
      2,
      sample,
      replace = FALSE
    )

    if (is.null(dim(X_perm))) {
      X_perm <- matrix(
        X_perm,
        ncol = ncol(X_raw)
      )
    }

    colnames(X_perm) <-
      colnames(X_raw)

    pp <-
      fit_pca_for_representation(
        X_perm,
        representation
      )

    ee <- pp$sdev^2

    perm_eigen[
      b,
      seq_along(ee)
    ] <- ee
  }

  q95 <- apply(
    perm_eigen,
    2,
    quantile,
    probs = 0.95,
    na.rm = TRUE
  )

  mean_perm <- colMeans(
    perm_eigen,
    na.rm = TRUE
  )

  var_prop <-
    obs_eigen /
    sum(
      obs_eigen
    )

  m <- length(
    obs_eigen
  )

  broken_stick <- vapply(
    seq_len(m),
    function(k) {
      sum(
        1 /
          seq(
            k,
            m
          )
      ) /
        m
    },
    numeric(1)
  )

  tibble(
    PC =
      paste0(
        "PC",
        seq_len(m)
      ),

    eigenvalue =
      obs_eigen,

    variance_percent =
      100 *
      var_prop,

    cumulative_percent =
      100 *
      cumsum(
        var_prop
      ),

    permuted_mean_eigenvalue =
      mean_perm,

    permuted_95pct_eigenvalue =
      q95,

    parallel_retain =
      obs_eigen >
      q95,

    broken_stick_percent =
      100 *
      broken_stick,

    above_broken_stick =
      var_prop >
      broken_stick
  )
}


# ==============================================================================
# 12. PERMANOVA / PERMDISP
# ==============================================================================

run_permanova <- function(
  X_model,
  group
) {

  meta <- tibble(
    group =
      droplevels(
        group
      )
  )

  D <- dist(
    X_model,
    method = "euclidean"
  )

  ad <- vegan::adonis2(
    D ~ group,
    data = meta,
    permutations =
      N_PERM
  )

  bd <- vegan::betadisper(
    D,
    meta$group,
    type = "median"
  )

  bd_perm <- permutest(
    bd,
    permutations =
      N_PERM
  )

  ad_row <- tibble(
    Df = ad["group", "Df"],
    SumOfSqs =
      ad[
        "group",
        "SumOfSqs"
      ],
    R2 =
      ad[
        "group",
        "R2"
      ],
    F =
      ad[
        "group",
        "F"
      ],
    p =
      ad[
        "group",
        "Pr(>F)"
      ]
  )

  dispersion_row <- tibble(
    F =
      bd_perm$tab[
        1,
        "F"
      ],
    p =
      bd_perm$tab[
        1,
        "Pr(>F)"
      ]
  )

  list(
    distance = D,
    permanova = ad_row,
    permdisp = dispersion_row
  )
}


run_pairwise_permanova <- function(
  X_model,
  group
) {

  g <- droplevels(
    group
  )

  lev <- levels(
    g
  )

  if (length(lev) < 2) {
    return(
      tibble()
    )
  }

  cmb <- combn(
    lev,
    2,
    simplify = FALSE
  )

  out <- map_dfr(
    cmb,
    function(pair) {

      idx <- g %in% pair

      X2 <- X_model[
        idx,
        ,
        drop = FALSE
      ]

      g2 <- droplevels(
        g[idx]
      )

      meta2 <- tibble(
        group = g2
      )

      D2 <- dist(
        X2,
        method = "euclidean"
      )

      ad <- vegan::adonis2(
        D2 ~ group,
        data = meta2,
        permutations =
          N_PERM
      )

      bd <- vegan::betadisper(
        D2,
        g2,
        type = "median"
      )

      bdp <- permutest(
        bd,
        permutations =
          N_PERM
      )

      centroid_A <-
        colMeans(
          X2[
            g2 ==
              pair[[1]],
            ,
            drop = FALSE
          ]
        )

      centroid_B <-
        colMeans(
          X2[
            g2 ==
              pair[[2]],
            ,
            drop = FALSE
          ]
        )

      tibble(
        group_A =
          pair[[1]],

        group_B =
          pair[[2]],

        contrast =
          paste(
            pair[[2]],
            "-",
            pair[[1]]
          ),

        n_A =
          sum(
            g2 ==
              pair[[1]]
          ),

        n_B =
          sum(
            g2 ==
              pair[[2]]
          ),

        centroid_distance =
          sqrt(
            sum(
              (
                centroid_B -
                  centroid_A
              )^2
            )
          ),

        R2 =
          ad[
            "group",
            "R2"
          ],

        F =
          ad[
            "group",
            "F"
          ],

        p =
          ad[
            "group",
            "Pr(>F)"
          ],

        dispersion_F =
          bdp$tab[
            1,
            "F"
          ],

        dispersion_p =
          bdp$tab[
            1,
            "Pr(>F)"
          ]
      )
    }
  )

  out %>%
    mutate(
      q_BH =
        p.adjust(
          p,
          method = "BH"
        ),

      dispersion_q_BH =
        p.adjust(
          dispersion_p,
          method = "BH"
        )
    )
}


# ==============================================================================
# 13. SECONDARY PERMUTATION TESTS OF RETAINED PC SCORES
# ==============================================================================

permutation_pc_omnibus <- function(
  scores,
  group,
  pcs,
  B = N_PERM
) {

  # Robust guard: an empty PC vector must still return the expected columns.
  if (length(pcs) == 0) {
    return(
      tibble(
        PC = character(),
        F = double(),
        permutation_p = double(),
        q_BH = double()
      )
    )
  }

  g <- droplevels(
    group
  )

  map_dfr(
    pcs,
    function(pc_name) {

      y <- scores[
        ,
        pc_name
      ]

      fit <- lm(
        y ~ g
      )

      F_obs <-
        anova(
          fit
        )[
          "g",
          "F value"
        ]

      F_perm <- numeric(
        B
      )

      for (b in seq_len(B)) {

        g_perm <- sample(
          g,
          replace = FALSE
        )

        F_perm[[b]] <-
          anova(
            lm(
              y ~ g_perm
            )
          )[
            "g_perm",
            "F value"
          ]
      }

      p_perm <-
        (
          1 +
            sum(
              F_perm >=
                F_obs,
              na.rm = TRUE
            )
        ) /
        (
          B +
            1
        )

      tibble(
        PC =
          pc_name,

        F =
          as.numeric(
            F_obs
          ),

        permutation_p =
          p_perm
      )
    }
  ) %>%
    mutate(
      q_BH =
        p.adjust(
          .data$permutation_p,
          method = "BH"
        )
    )
}


# ==============================================================================
# 14. PLOTTING HELPERS
# ==============================================================================

safe_file_name <- function(x) {
  str_replace_all(
    x,
    "[^A-Za-z0-9_-]+",
    "_"
  )
}


plot_pca_scores <- function(
  score_df,
  task,
  representation,
  variance_table
) {

  pc1_var <-
    variance_table$variance_percent[[1]]

  pc2_var <-
    if (
      nrow(
        variance_table
      ) >= 2
    ) {
      variance_table$variance_percent[[2]]
    } else {
      NA_real_
    }

  p <- ggplot(
    score_df,
    aes(
      x = PC1,
      y = PC2,
      color =
        analysis_group
    )
  ) +
    geom_point(
      size = 2.6,
      alpha = 0.80
    ) +
    stat_ellipse(
      aes(
        group =
          analysis_group
      ),
      level =
        ELLIPSE_LEVEL,
      type = "norm",
      linewidth = 0.7,
      na.rm = TRUE
    ) +
    labs(
      title =
        paste(
          task,
          "-",
          representation
        ),

      subtitle =
        paste0(
          round(
            ELLIPSE_LEVEL *
              100
          ),
          "% concentration ellipses; statistical testing uses full multivariate matrix"
        ),

      x =
        paste0(
          "PC1 (",
          round(
            pc1_var,
            1
          ),
          "%)"
        ),

      y =
        paste0(
          "PC2 (",
          round(
            pc2_var,
            1
          ),
          "%)"
        ),

      color =
        "Group"
    ) +
    theme_bw(
      base_size = 11
    ) +
    theme(
      legend.position =
        "right"
    )

  p
}


plot_scree <- function(
  variance_table,
  task,
  representation
) {

  variance_table %>%
    mutate(
      PC =
        factor(
          PC,
          levels = PC
        )
    ) %>%
    ggplot(
      aes(
        x = PC,
        y =
          variance_percent
      )
    ) +
    geom_col() +
    geom_point(
      aes(
        y =
          broken_stick_percent
      ),
      size = 2
    ) +
    geom_line(
      aes(
        y =
          broken_stick_percent,
        group = 1
      )
    ) +
    labs(
      title =
        paste(
          "Scree:",
          task,
          "-",
          representation
        ),
      subtitle =
        "Bars = observed PCA variance; points/line = broken-stick expectation",
      x = NULL,
      y =
        "Variance explained (%)"
    ) +
    theme_bw(
      base_size = 11
    )
}


# ==============================================================================
# 15. PRESENCE / ABSENCE: JACCARD PCoA
# ==============================================================================

run_presence_pcoa <- function(
  task_df,
  bone_cols,
  task,
  representation,
  base_name
) {

  P <- as.matrix(
    task_df[
      ,
      bone_cols,
      drop = FALSE
    ] >
      0
  ) *
    1

  feature_audit <- tibble(
    bone =
      colnames(P),

    n_present =
      colSums(P),

    prevalence =
      colMeans(P),

    zero_variance =
      apply(
        P,
        2,
        sd
      ) ==
      0
  ) %>%
    mutate(
      too_rare =
        n_present <
          MIN_NONZERO_SITES |
        prevalence <
          MIN_PREVALENCE,

      keep =
        !zero_variance &
        !too_rare
    )

  keep_bones <- feature_audit %>%
    filter(
      keep
    ) %>%
    pull(
      bone
    )

  write_csv(
    feature_audit,
    file.path(
      OUT_DIR,
      paste0(
        base_name,
        "_PRESENCE_feature_audit.csv"
      )
    )
  )

  if (length(keep_bones) < 2) {
    warning(
      "Presence PCoA skipped for ",
      task,
      " / ",
      representation,
      ": fewer than two usable variables."
    )
    return(
      NULL
    )
  }

  P2 <- P[
    ,
    keep_bones,
    drop = FALSE
  ]

  nonempty_rows <-
    rowSums(
      P2
    ) >
    0

  if (sum(nonempty_rows) < 4) {
    warning(
      "Presence PCoA skipped: too few non-empty site rows."
    )
    return(
      NULL
    )
  }

  P2 <-
    P2[
      nonempty_rows,
      ,
      drop = FALSE
    ]

  meta <-
    task_df[
      nonempty_rows,
      c(
        "site_name",
        "analysis_group"
      )
    ] %>%
    mutate(
      analysis_group = droplevels(analysis_group)
    )

  D <- vegan::vegdist(
    P2,
    method = "jaccard",
    binary = TRUE
  )

  k <-
    min(
      10,
      nrow(P2) -
        2
    )

  ord <- vegan::wcmdscale(
    D,
    k = k,
    eig = TRUE,
    add = "lingoes"
  )

  points <-
    as.data.frame(
      ord$points
    )

  colnames(points) <-
    paste0(
      "Axis",
      seq_len(
        ncol(
          points
        )
      )
    )

  score_df <- bind_cols(
    meta,
    points
  )

  eig <- ord$eig
  positive_eig <- eig[
    eig > 0
  ]

  eig_table <- tibble(
    Axis =
      paste0(
        "Axis",
        seq_along(
          positive_eig
        )
      ),

    eigenvalue =
      positive_eig,

    variance_percent =
      100 *
      positive_eig /
      sum(
        positive_eig
      ),

    cumulative_percent =
      100 *
      cumsum(
        positive_eig /
          sum(
            positive_eig
          )
      )
  )

  write_csv(
    score_df,
    file.path(
      OUT_DIR,
      paste0(
        base_name,
        "_PRESENCE_Jaccard_PCoA_scores.csv"
      )
    )
  )

  write_csv(
    eig_table,
    file.path(
      OUT_DIR,
      paste0(
        base_name,
        "_PRESENCE_Jaccard_PCoA_eigenvalues.csv"
      )
    )
  )

  # PERMANOVA directly on Jaccard distance.
  ad <- vegan::adonis2(
    D ~ analysis_group,
    data = meta,
    permutations =
      N_PERM
  )

  bd <- vegan::betadisper(
    D,
    meta$analysis_group,
    type = "median"
  )

  bdp <- permutest(
    bd,
    permutations =
      N_PERM
  )

  presence_stats <- tibble(
    task = task,
    representation =
      representation,
    method =
      "Jaccard presence/absence",

    n_sites =
      nrow(meta),

    n_features =
      ncol(P2),

    PERMANOVA_R2 =
      ad[
        "analysis_group",
        "R2"
      ],

    PERMANOVA_F =
      ad[
        "analysis_group",
        "F"
      ],

    PERMANOVA_p =
      ad[
        "analysis_group",
        "Pr(>F)"
      ],

    PERMDISP_F =
      bdp$tab[
        1,
        "F"
      ],

    PERMDISP_p =
      bdp$tab[
        1,
        "Pr(>F)"
      ]
  )

  write_csv(
    presence_stats,
    file.path(
      OUT_DIR,
      paste0(
        base_name,
        "_PRESENCE_multivariate_tests.csv"
      )
    )
  )


  # Pairwise Jaccard PERMANOVA.
  lev <- levels(
    droplevels(
      meta$analysis_group
    )
  )

  pairwise <- map_dfr(
    combn(
      lev,
      2,
      simplify = FALSE
    ),
    function(pair) {

      idx <-
        meta$analysis_group %in%
        pair

      P_pair <-
        P2[
          idx,
          ,
          drop = FALSE
        ]

      m_pair <-
        droplevels(
          meta[
            idx,
            ,
            drop = FALSE
          ]
        )

      D_pair <- vegan::vegdist(
        P_pair,
        method = "jaccard",
        binary = TRUE
      )

      ad2 <- vegan::adonis2(
        D_pair ~ analysis_group,
        data = m_pair,
        permutations =
          N_PERM
      )

      bd2 <- vegan::betadisper(
        D_pair,
        m_pair$analysis_group,
        type = "median"
      )

      bdp2 <- permutest(
        bd2,
        permutations =
          N_PERM
      )

      tibble(
        group_A =
          pair[[1]],

        group_B =
          pair[[2]],

        R2 =
          ad2[
            "analysis_group",
            "R2"
          ],

        F =
          ad2[
            "analysis_group",
            "F"
          ],

        p =
          ad2[
            "analysis_group",
            "Pr(>F)"
          ],

        dispersion_F =
          bdp2$tab[
            1,
            "F"
          ],

        dispersion_p =
          bdp2$tab[
            1,
            "Pr(>F)"
          ]
      )
    }
  ) %>%
    mutate(
      q_BH =
        p.adjust(
          p,
          method = "BH"
        ),

      dispersion_q_BH =
        p.adjust(
          dispersion_p,
          method = "BH"
        )
    )

  write_csv(
    pairwise,
    file.path(
      OUT_DIR,
      paste0(
        base_name,
        "_PRESENCE_pairwise_PERMANOVA.csv"
      )
    )
  )


  if (
    all(
      c(
        "Axis1",
        "Axis2"
      ) %in%
        names(
          score_df
        )
    )
  ) {

    p <- ggplot(
      score_df,
      aes(
        x = Axis1,
        y = Axis2,
        color =
          analysis_group
      )
    ) +
      geom_point(
        size = 2.6,
        alpha = 0.80
      ) +
      stat_ellipse(
        aes(
          group =
            analysis_group
        ),
        level =
          ELLIPSE_LEVEL,
        type = "norm",
        linewidth = 0.7,
        na.rm = TRUE
      ) +
      labs(
        title =
          paste(
            task,
            "- presence/absence"
          ),
        subtitle =
          "Jaccard PCoA; ellipses are descriptive concentration ellipses",
        x =
          paste0(
            "Axis 1 (",
            round(
              eig_table$variance_percent[[1]],
              1
            ),
            "%)"
          ),
        y =
          paste0(
            "Axis 2 (",
            round(
              eig_table$variance_percent[[2]],
              1
            ),
            "%)"
          ),
        color =
          "Group"
      ) +
      theme_bw(
        base_size = 11
      )

    ggsave(
      file.path(
        OUT_DIR,
        "plots",
        paste0(
          base_name,
          "_PRESENCE_Jaccard_PCoA.png"
        )
      ),
      p,
      width = 8,
      height = 6,
      dpi = 300
    )
  }

  presence_stats
}


# ==============================================================================
# 16. MAIN PCA ANALYSIS LOOP
# ==============================================================================

all_tasks <- c(
  "four_class",
  "F_vs_NF",
  "Funerary_vs_Cannibalism",
  "C1_C5",
  "G0_G5"
)

representations <- list(
  "%MNAU" =
    prop_bones,

  "ReMNAU" =
    rem_bones
)

master_permanova <- list()
master_permdisp <- list()
master_pairwise <- list()
master_pc_tests <- list()
master_sample_sizes <- list()
master_presence <- list()

result_counter <- 0


for (
  representation in
    names(
      representations
    )
) {

  rep_obj <- representations[[representation]]

  for (task in all_tasks) {

    result_counter <-
      result_counter +
      1

    cat(
      "\nRunning ",
      task,
      " / ",
      representation,
      " ...\n",
      sep = ""
    )

    task_obj <- make_task_data(
      rep_obj$wide,
      rep_obj$bones,
      task
    )

    task_df <- task_obj$data

    if (
      nlevels(
        task_df$analysis_group
      ) <
      2
    ) {
      warning(
        "Skipping ",
        task,
        " / ",
        representation,
        ": fewer than two groups."
      )
      next
    }

    base_name <- paste0(
      sprintf(
        "%02d",
        result_counter
      ),
      "_",
      safe_file_name(
        task
      ),
      "_",
      safe_file_name(
        representation
      )
    )

    # Save any parent sites excluded for cross-group dependence.
    if (
      nrow(
        task_obj$multi_group_sites
      ) >
      0
    ) {

      write_csv(
        task_obj$multi_group_sites,
        file.path(
          OUT_DIR,
          paste0(
            base_name,
            "_cross_group_parent_sites.csv"
          )
        )
      )
    }


    # Save the pre-transformation sample sizes for audit.
    input_sample_sizes <- task_df %>%
      count(
        analysis_group,
        name = "n_input_sites"
      ) %>%
      mutate(
        task = task,
        representation =
          representation,
        .before = 1
      )

    write_csv(
      input_sample_sizes,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_input_sample_sizes.csv"
        )
      )
    )


    prep <- prepare_continuous_matrix(
      task_df,
      rep_obj$bones,
      representation
    )


    # ReMNAU rows with all-zero retained composition cannot be entered into
    # Hellinger PCA/PERMANOVA. Keep the metadata perfectly aligned with X_model.
    if (
      any(
        !prep$row_keep
      )
    ) {

      excluded_rows <- task_df[
        !prep$row_keep,
        ,
        drop = FALSE
      ] %>%
        mutate(
          exclusion_reason =
            prep$exclusion_reason[
              !prep$row_keep
            ]
        ) %>%
        select(
          site_name,
          analysis_group,
          exclusion_reason
        )

      write_csv(
        excluded_rows,
        file.path(
          OUT_DIR,
          paste0(
            base_name,
            "_excluded_rows_before_PCA.csv"
          )
        )
      )
    }

    task_df <- task_df[
      prep$row_keep,
      ,
      drop = FALSE
    ] %>%
      mutate(
        analysis_group =
          droplevels(
            analysis_group
          )
      )

    if (
      nrow(
        task_df
      ) !=
        nrow(
          prep$X_model
        )
    ) {
      stop(
        "Internal row-alignment error: task metadata and transformed matrix ",
        "have different numbers of rows."
      )
    }

    if (
      nlevels(
        task_df$analysis_group
      ) <
        2
    ) {
      warning(
        "Skipping ",
        task,
        " / ",
        representation,
        " after preprocessing because fewer than two groups remain."
      )
      next
    }


    sample_sizes <- task_df %>%
      count(
        analysis_group,
        name = "n_sites"
      ) %>%
      mutate(
        task = task,
        representation =
          representation,
        .before = 1
      )

    write_csv(
      sample_sizes,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_sample_sizes.csv"
        )
      )
    )

    master_sample_sizes[[length(master_sample_sizes) + 1]] <- sample_sizes

    feature_audit <-
      prep$feature_audit %>%
      mutate(
        task = task,
        representation =
          representation,
        .before = 1
      )

    write_csv(
      feature_audit,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_feature_preprocessing_audit.csv"
        )
      )
    )


    # Correlation matrix on retained raw bone variables.
    cor_matrix <- cor(
      prep$X_keep,
      use = "pairwise.complete.obs"
    )

    write_csv(
      as.data.frame(
        cor_matrix
      ) %>%
        rownames_to_column(
          "bone"
        ),
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_correlation_matrix.csv"
        )
      )
    )


    # Numerical rank / n:p audit.
    assert_finite_matrix(
      prep$X_model,
      paste0(
        task,
        " / ",
        representation,
        " transformed model matrix"
      )
    )

    rank_value <-
      qr(
        prep$X_model
      )$rank

    dimension_audit <- tibble(
      task = task,
      representation =
        representation,
      n_sites =
        nrow(
          prep$X_model
        ),
      n_retained_features =
        ncol(
          prep$X_model
        ),
      n_to_p_ratio =
        nrow(
          prep$X_model
        ) /
        ncol(
          prep$X_model
        ),
      matrix_rank =
        rank_value,
      transform =
        prep$transform_note
    )

    write_csv(
      dimension_audit,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_dimension_audit.csv"
        )
      )
    )


    # --------------------------------------------------------------------------
    # PCA and component retention
    # --------------------------------------------------------------------------

    pca <- prep$pca

    parallel <- parallel_analysis(
      prep$X_keep,
      representation,
      B =
        N_PARALLEL
    )

    write_csv(
      parallel,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PCA_variance_parallel_brokenstick.csv"
        )
      )
    )

    scores <- as.data.frame(
      pca$x
    )

    scores <- bind_cols(
      task_df %>%
        select(
          site_name,
          analysis_group
        ),
      scores
    )

    write_csv(
      scores,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PCA_scores.csv"
        )
      )
    )


    loadings <- as.data.frame(
      pca$rotation
    ) %>%
      rownames_to_column(
        "bone"
      ) %>%
      pivot_longer(
        cols =
          starts_with(
            "PC"
          ),
        names_to = "PC",
        values_to =
          "loading"
      ) %>%
      group_by(
        PC
      ) %>%
      mutate(
        squared_loading =
          loading^2,

        contribution_percent =
          100 *
          squared_loading /
          sum(
            squared_loading
          )
      ) %>%
      ungroup()

    write_csv(
      loadings,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PCA_loadings.csv"
        )
      )
    )

    top_loadings <- loadings %>%
      group_by(
        PC
      ) %>%
      arrange(
        desc(
          abs(
            loading
          )
        ),
        .by_group = TRUE
      ) %>%
      slice_head(
        n = 10
      ) %>%
      ungroup()

    write_csv(
      top_loadings,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PCA_top10_loadings_each_PC.csv"
        )
      )
    )


    # --------------------------------------------------------------------------
    # PRIMARY multivariate inference
    # --------------------------------------------------------------------------

    mv <- run_permanova(
      prep$X_model,
      task_df$analysis_group
    )

    permanova_row <-
      mv$permanova %>%
      mutate(
        task = task,
        representation =
          representation,
        n_sites =
          nrow(
            task_df
          ),
        n_features =
          ncol(
            prep$X_model
          ),
        transform =
          prep$transform_note,
        .before = 1
      )

    permdisp_row <-
      mv$permdisp %>%
      mutate(
        task = task,
        representation =
          representation,
        n_sites =
          nrow(
            task_df
          ),
        .before = 1
      )

    write_csv(
      permanova_row,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PERMANOVA_omnibus.csv"
        )
      )
    )

    write_csv(
      permdisp_row,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_PERMDISP_omnibus.csv"
        )
      )
    )

    master_permanova[[length(master_permanova) + 1]] <- permanova_row

    master_permdisp[[length(master_permdisp) + 1]] <- permdisp_row


    pairwise <- run_pairwise_permanova(
      prep$X_model,
      task_df$analysis_group
    ) %>%
      mutate(
        task = task,
        representation =
          representation,
        .before = 1
      )

    write_csv(
      pairwise,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_pairwise_PERMANOVA_PERMDISP.csv"
        )
      )
    )

    master_pairwise[[length(master_pairwise) + 1]] <- pairwise


    # --------------------------------------------------------------------------
    # SECONDARY PC-score permutation tests
    # --------------------------------------------------------------------------

    retained_pcs <-
      parallel %>%
      filter(
        parallel_retain
      ) %>%
      pull(
        PC
      )

    if (length(retained_pcs) == 0) {

      # If parallel analysis retains none, do not manufacture significance.
      # We still plot PC1/PC2 descriptively.
      pc_tests <- tibble(
        task = character(),
        representation =
          character(),
        PC = character(),
        F = double(),
        permutation_p =
          double(),
        q_BH = double()
      )

    } else {

      # pca$x is a matrix, so PC labels are stored in colnames().
      retained_pcs <- intersect(
        retained_pcs,
        colnames(pca$x)
      )

      if (length(retained_pcs) == 0) {

        pc_tests <- tibble(
          task = character(),
          representation = character(),
          PC = character(),
          F = double(),
          permutation_p = double(),
          q_BH = double()
        )

      } else {

        pc_tests <-
          permutation_pc_omnibus(
            as.data.frame(
              pca$x
            ),
            task_df$analysis_group,
            retained_pcs,
            B =
              N_PERM
          ) %>%
          mutate(
            task = task,
            representation =
              representation,
            .before = 1
          )
      }
    }

    write_csv(
      pc_tests,
      file.path(
        OUT_DIR,
        paste0(
          base_name,
          "_retained_PC_score_permutation_tests.csv"
        )
      )
    )

    master_pc_tests[[length(master_pc_tests) + 1]] <- pc_tests


    # --------------------------------------------------------------------------
    # PCA plots
    # --------------------------------------------------------------------------

    if (
      all(
        c(
          "PC1",
          "PC2"
        ) %in%
          names(
            scores
          )
      )
    ) {

      p_scores <- plot_pca_scores(
        scores,
        task,
        representation,
        parallel
      )

      ggsave(
        file.path(
          OUT_DIR,
          "plots",
          paste0(
            base_name,
            "_PCA_PC1_PC2.png"
          )
        ),
        p_scores,
        width = 8,
        height = 6,
        dpi = 300
      )
    }

    p_scree <- plot_scree(
      parallel,
      task,
      representation
    )

    ggsave(
      file.path(
        OUT_DIR,
        "plots",
        paste0(
          base_name,
          "_PCA_scree.png"
        )
      ),
      p_scree,
      width = 8,
      height = 5,
      dpi = 300
    )


    # --------------------------------------------------------------------------
    # Presence / absence: Jaccard PCoA
    # --------------------------------------------------------------------------

    if (
      RUN_PRESENCE_PCOA &&
      representation == "%MNAU"
    ) {

      presence_result <-
        run_presence_pcoa(
          task_df,
          rep_obj$bones,
          task,
          representation,
          base_name
        )

      if (
        !is.null(
          presence_result
        )
      ) {

        master_presence[[length(master_presence) + 1]] <- presence_result
      }
    }
  }
}



# ==============================================================================
# 17. UNSUPERVISED GROUP-NUMBER ANALYSIS:
#     %MNAU AND ReMNAU VIA SILHOUETTE + ELBOW
# ==============================================================================

# This is intentionally a separate unsupervised analysis.
#
# It asks:
#   "How many natural skeletal-representation groups are supported by the
#    multivariate %MNAU pattern?"
# and separately:
#   "How many natural skeletal-representation groups are supported by the
#    multivariate ReMNAU pattern?"
#
# IMPORTANT:
#   - Groups are NOT supplied to k-means.
#   - Clustering is done in the full transformed skeletal-part feature space,
#     not only on PC1/PC2.
#   - %MNAU uses the same z-standardized feature logic as the PCA.
#   - ReMNAU uses the same Hellinger-transformed feature logic as the PCA.
#   - Silhouette and elbow are diagnostic criteria, not formal hypothesis tests.
#   - If they disagree, the script reports both candidate k values.


prepare_site_clustering_data <- function(
  wide,
  bone_cols
) {

  z <- wide

  if (CLUSTER_ONLY_KNOWN_FOUR_CLASS) {
    z <- z %>%
      filter(
        !is.na(class4)
      )
  }

  # One independent parent-site row.
  # C/G labels are retained only when the parent site has one unique label.
  site_df <- z %>%
    group_by(
      site_name
    ) %>%
    summarise(
      class4 =
        first_unique_non_na(
          class4
        ),

      C_group =
        first_unique_non_na(
          C_group
        ),

      G_group =
        first_unique_non_na(
          G_group
        ),

      across(
        all_of(bone_cols),
        ~ mean(
          .x,
          na.rm = FALSE
        )
      ),

      .groups = "drop"
    )

  site_df
}


prepare_cluster_matrix <- function(
  site_df,
  bone_cols,
  representation
) {

  X_raw <- as.matrix(
    site_df[
      ,
      bone_cols,
      drop = FALSE
    ]
  )

  storage.mode(X_raw) <- "double"

  assert_finite_matrix(
    X_raw,
    paste0(
      representation,
      " clustering raw matrix"
    )
  )

  audit <- tibble(
    bone = colnames(X_raw),
    n_sites = nrow(X_raw),
    n_nonzero =
      colSums(
        X_raw > 0
      ),
    prevalence =
      colMeans(
        X_raw > 0
      ),
    mean =
      colMeans(
        X_raw
      ),
    sd =
      apply(
        X_raw,
        2,
        sd
      )
  ) %>%
    mutate(
      zero_or_near_zero_variance =
        !is.finite(sd) |
        sd <=
          sqrt(
            .Machine$double.eps
          ),

      too_rare =
        n_nonzero <
          MIN_NONZERO_SITES |
        prevalence <
          MIN_PREVALENCE,

      keep =
        !zero_or_near_zero_variance &
        !too_rare
    )

  keep_bones <- audit %>%
    filter(
      keep
    ) %>%
    pull(
      bone
    )

  if (length(keep_bones) < 2) {
    stop(
      "Fewer than two usable variables remain for ",
      representation,
      " clustering."
    )
  }

  X_keep_all <- X_raw[
    ,
    keep_bones,
    drop = FALSE
  ]

  row_keep <- rep(
    TRUE,
    nrow(
      X_keep_all
    )
  )

  if (representation == "%MNAU") {

    X_keep <- X_keep_all

    X_model <- safe_z_scale(
      X_keep
    )

    transform_note <-
      "raw %MNAU -> prevalence filter -> z-standardization"

  } else if (representation == "ReMNAU") {

    if (
      any(
        X_keep_all < 0
      )
    ) {
      stop(
        "Negative ReMNAU values found in clustering input."
      )
    }

    row_keep <-
      rowSums(
        X_keep_all
      ) >
      0

    if (
      sum(
        row_keep
      ) <
      3
    ) {
      stop(
        "Too few non-zero ReMNAU parent-site rows remain for clustering."
      )
    }

    X_keep <- X_keep_all[
      row_keep,
      ,
      drop = FALSE
    ]

    X_model <- safe_hellinger(
      X_keep
    )

    transform_note <-
      paste0(
        "raw ReMNAU -> prevalence filter -> exclude all-zero composition rows -> ",
        "safe Hellinger transform"
      )

  } else {
    stop(
      "Unknown representation in clustering: ",
      representation
    )
  }

  assert_finite_matrix(
    X_model,
    paste0(
      representation,
      " clustering transformed matrix"
    )
  )

  list(
    X_raw = X_raw,
    X_keep_all = X_keep_all,
    X_keep = X_keep,
    X_model = X_model,
    audit = audit,
    keep_bones = keep_bones,
    row_keep = row_keep,
    transform_note = transform_note
  )
}


# Automatic elbow heuristic:
# choose the k with the greatest perpendicular distance from the straight line
# connecting the first and last WSS points after normalization.
#
# This is only a reproducible elbow heuristic. It does not convert the elbow
# into a formal statistical test.
choose_elbow_k <- function(
  k_values,
  wss
) {

  if (length(k_values) < 3) {
    return(
      k_values[[1]]
    )
  }

  x <- (
    k_values -
      min(k_values)
  ) /
    (
      max(k_values) -
        min(k_values)
    )

  if (
    max(wss) ==
      min(wss)
  ) {
    return(
      k_values[[1]]
    )
  }

  y <- (
    wss -
      min(wss)
  ) /
    (
      max(wss) -
        min(wss)
    )

  x1 <- x[[1]]
  y1 <- y[[1]]
  x2 <- x[[length(x)]]
  y2 <- y[[length(y)]]

  denom <- sqrt(
    (y2 - y1)^2 +
      (x2 - x1)^2
  )

  distances <- abs(
    (y2 - y1) * x -
      (x2 - x1) * y +
      x2 * y1 -
      y2 * x1
  ) /
    denom

  k_values[
    which.max(
      distances
    )
  ]
}


fit_kmeans_solution <- function(
  X,
  k,
  seed_offset = 0L
) {

  set.seed(
    SEED +
      as.integer(k) +
      as.integer(seed_offset)
  )

  kmeans(
    X,
    centers = k,
    nstart = CLUSTER_NSTART,
    iter.max = CLUSTER_ITER_MAX,
    algorithm = "Hartigan-Wong"
  )
}


evaluate_k_range <- function(
  X_model,
  representation
) {

  n <- nrow(X_model)

  k_max_allowed <- min(
    CLUSTER_K_MAX,
    n - 1
  )

  if (k_max_allowed < CLUSTER_K_MIN) {
    stop(
      "Too few independent parent sites for cluster-number analysis."
    )
  }

  k_values <- seq.int(
    CLUSTER_K_MIN,
    k_max_allowed
  )

  D <- dist(
    X_model,
    method = "euclidean"
  )

  results <- map_dfr(
    k_values,
    function(k) {

      km <- fit_kmeans_solution(
        X_model,
        k,
        seed_offset =
          if_else(
            representation == "%MNAU",
            1000L,
            2000L
          )
      )

      sil <- cluster::silhouette(
        km$cluster,
        D
      )

      cluster_sizes <- table(
        km$cluster
      )

      tibble(
        representation =
          representation,

        k = k,

        total_WSS =
          km$tot.withinss,

        between_SS =
          km$betweenss,

        total_SS =
          km$totss,

        explained_SS =
          if_else(
            km$totss > 0,
            km$betweenss /
              km$totss,
            NA_real_
          ),

        average_silhouette =
          mean(
            sil[
              ,
              "sil_width"
            ]
          ),

        median_silhouette =
          median(
            sil[
              ,
              "sil_width"
            ]
          ),

        minimum_silhouette =
          min(
            sil[
              ,
              "sil_width"
            ]
          ),

        n_negative_silhouette =
          sum(
            sil[
              ,
              "sil_width"
            ] <
              0
          ),

        smallest_cluster =
          min(
            cluster_sizes
          ),

        largest_cluster =
          max(
            cluster_sizes
          )
      )
    }
  ) %>%
    arrange(
      k
    ) %>%
    mutate(
      WSS_reduction_from_previous =
        c(
          NA_real_,
          head(
            total_WSS,
            -1
          ) -
            tail(
              total_WSS,
              -1
            )
        ),

      WSS_percent_reduction_from_previous =
        c(
          NA_real_,
          100 *
            (
              head(
                total_WSS,
                -1
              ) -
                tail(
                  total_WSS,
                  -1
                )
            ) /
            head(
              total_WSS,
              -1
            )
        )
    )

  k_silhouette <- results$k[
    which.max(
      results$average_silhouette
    )
  ]

  k_elbow <- choose_elbow_k(
    results$k,
    results$total_WSS
  )

  results <- results %>%
    mutate(
      silhouette_best =
        k ==
        k_silhouette,

      elbow_best =
        k ==
        k_elbow
    )

  recommendation <- tibble(
    representation =
      representation,

    n_sites =
      nrow(
        X_model
      ),

    n_features =
      ncol(
        X_model
      ),

    k_silhouette =
      k_silhouette,

    best_average_silhouette =
      max(
        results$average_silhouette
      ),

    k_elbow =
      k_elbow,

    criteria_agree =
      k_silhouette ==
      k_elbow,

    interpretation =
      if_else(
        k_silhouette ==
          k_elbow,
        paste0(
          "Silhouette and elbow both support k=",
          k_silhouette,
          "."
        ),
        paste0(
          "Silhouette supports k=",
          k_silhouette,
          "; elbow supports k=",
          k_elbow,
          ". Inspect both solutions rather than forcing one."
        )
      )
  )

  list(
    diagnostics = results,
    recommendation =
      recommendation,
    distance = D
  )
}


make_cluster_assignment_table <- function(
  site_df,
  X_model,
  representation,
  k_silhouette,
  k_elbow
) {

  km_sil <- fit_kmeans_solution(
    X_model,
    k_silhouette,
    seed_offset =
      if_else(
        representation == "%MNAU",
        1000L,
        2000L
      )
  )

  km_elbow <- fit_kmeans_solution(
    X_model,
    k_elbow,
    seed_offset =
      if_else(
        representation == "%MNAU",
        3000L,
        4000L
      )
  )

  D <- dist(
    X_model
  )

  sil_sil <- cluster::silhouette(
    km_sil$cluster,
    D
  )

  sil_elbow <- cluster::silhouette(
    km_elbow$cluster,
    D
  )

  tibble(
    representation =
      representation,

    site_name =
      site_df$site_name,

    class4 =
      site_df$class4,

    C_group =
      site_df$C_group,

    G_group =
      site_df$G_group,

    k_silhouette =
      k_silhouette,

    silhouette_cluster =
      paste0(
        "K",
        k_silhouette,
        "_",
        km_sil$cluster
      ),

    silhouette_width =
      sil_sil[
        ,
        "sil_width"
      ],

    k_elbow =
      k_elbow,

    elbow_cluster =
      paste0(
        "K",
        k_elbow,
        "_",
        km_elbow$cluster
      ),

    elbow_silhouette_width =
      sil_elbow[
        ,
        "sil_width"
      ]
  )
}


cluster_group_crosswalk <- function(
  assignments,
  cluster_col,
  external_group_col
) {

  cluster_sym <-
    rlang::sym(
      cluster_col
    )

  group_sym <-
    rlang::sym(
      external_group_col
    )

  assignments %>%
    filter(
      !is.na(
        !!group_sym
      )
    ) %>%
    count(
      !!cluster_sym,
      !!group_sym,
      name = "n"
    ) %>%
    group_by(
      !!cluster_sym
    ) %>%
    mutate(
      percent_within_cluster =
        100 *
        n /
        sum(
          n
        )
    ) %>%
    ungroup() %>%
    rename(
      cluster =
        !!cluster_sym,
      external_group =
        !!group_sym
    ) %>%
    mutate(
      external_group_type =
        external_group_col,
      .before = 1
    )
}


cluster_diagnostics_all <- list()
cluster_recommendations_all <- list()
cluster_assignments_all <- list()
cluster_crosswalks_all <- list()


for (
  representation in
    c(
      "%MNAU",
      "ReMNAU"
    )
) {

  rep_obj <-
    representations[[representation]]

  site_df <- prepare_site_clustering_data(
    rep_obj$wide,
    rep_obj$bones
  )

  prep_cluster <- prepare_cluster_matrix(
    site_df,
    rep_obj$bones,
    representation
  )

  if (
    any(
      !prep_cluster$row_keep
    )
  ) {

    cluster_excluded <- site_df[
      !prep_cluster$row_keep,
      ,
      drop = FALSE
    ] %>%
      select(
        site_name,
        class4,
        C_group,
        G_group
      ) %>%
      mutate(
        exclusion_reason =
          "all retained ReMNAU skeletal parts sum to zero"
      )

    write_csv(
      cluster_excluded,
      file.path(
        OUT_DIR,
        paste0(
          "CLUSTER_",
          safe_file_name(
            representation
          ),
          "_excluded_zero_composition_sites.csv"
        )
      )
    )
  }

  site_df <- site_df[
    prep_cluster$row_keep,
    ,
    drop = FALSE
  ]

  if (
    nrow(
      site_df
    ) !=
      nrow(
        prep_cluster$X_model
      )
  ) {
    stop(
      "Internal clustering row-alignment error."
    )
  }

  eval <- evaluate_k_range(
    prep_cluster$X_model,
    representation
  )

  rec <- eval$recommendation %>%
    mutate(
      transform =
        prep_cluster$transform_note
    )

  k_sil <-
    rec$k_silhouette[[1]]

  k_elbow <-
    rec$k_elbow[[1]]

  assignments <- make_cluster_assignment_table(
    site_df,
    prep_cluster$X_model,
    representation,
    k_sil,
    k_elbow
  )

  # Save feature audit.
  write_csv(
    prep_cluster$audit,
    file.path(
      OUT_DIR,
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_feature_audit.csv"
      )
    )
  )

  # Save k diagnostics.
  write_csv(
    eval$diagnostics,
    file.path(
      OUT_DIR,
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_k_diagnostics_silhouette_elbow.csv"
      )
    )
  )

  # Save recommended k values.
  write_csv(
    rec,
    file.path(
      OUT_DIR,
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_recommended_k.csv"
      )
    )
  )

  # Save site assignments for BOTH candidate k solutions.
  write_csv(
    assignments,
    file.path(
      OUT_DIR,
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_site_assignments.csv"
      )
    )
  )


  # Cross-tab the unsupervised clusters against known archaeological/C/G labels.
  # These external labels do NOT influence clustering.
  crosswalks <- bind_rows(
    cluster_group_crosswalk(
      assignments,
      "silhouette_cluster",
      "class4"
    ) %>%
      mutate(
        criterion =
          "silhouette"
      ),

    cluster_group_crosswalk(
      assignments,
      "silhouette_cluster",
      "C_group"
    ) %>%
      mutate(
        criterion =
          "silhouette"
      ),

    cluster_group_crosswalk(
      assignments,
      "silhouette_cluster",
      "G_group"
    ) %>%
      mutate(
        criterion =
          "silhouette"
      ),

    cluster_group_crosswalk(
      assignments,
      "elbow_cluster",
      "class4"
    ) %>%
      mutate(
        criterion =
          "elbow"
      ),

    cluster_group_crosswalk(
      assignments,
      "elbow_cluster",
      "C_group"
    ) %>%
      mutate(
        criterion =
          "elbow"
      ),

    cluster_group_crosswalk(
      assignments,
      "elbow_cluster",
      "G_group"
    ) %>%
      mutate(
        criterion =
          "elbow"
      )
  ) %>%
    mutate(
      representation =
        representation,
      .before = 1
    )

  write_csv(
    crosswalks,
    file.path(
      OUT_DIR,
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_crosswalk_archaeological_C_G_groups.csv"
      )
    )
  )


  # Diagnostic plots.
  p_elbow <- ggplot(
    eval$diagnostics,
    aes(
      x = k,
      y = total_WSS
    )
  ) +
    geom_line() +
    geom_point(
      size = 2.5
    ) +
    geom_vline(
      xintercept =
        k_elbow,
      linetype =
        "dashed"
    ) +
    scale_x_continuous(
      breaks =
        eval$diagnostics$k
    ) +
    labs(
      title =
        paste(
          representation,
          "- elbow diagnostic"
        ),

      subtitle =
        paste0(
          "Automatic elbow heuristic: k=",
          k_elbow
        ),

      x =
        "Number of clusters (k)",

      y =
        "Total within-cluster sum of squares"
    ) +
    theme_bw(
      base_size = 11
    )

  ggsave(
    file.path(
      OUT_DIR,
      "plots",
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_elbow.png"
      )
    ),
    p_elbow,
    width = 7,
    height = 5,
    dpi = 300
  )


  p_sil <- ggplot(
    eval$diagnostics,
    aes(
      x = k,
      y =
        average_silhouette
    )
  ) +
    geom_line() +
    geom_point(
      size = 2.5
    ) +
    geom_vline(
      xintercept =
        k_sil,
      linetype =
        "dashed"
    ) +
    scale_x_continuous(
      breaks =
        eval$diagnostics$k
    ) +
    labs(
      title =
        paste(
          representation,
          "- silhouette diagnostic"
        ),

      subtitle =
        paste0(
          "Maximum average silhouette: k=",
          k_sil
        ),

      x =
        "Number of clusters (k)",

      y =
        "Average silhouette width"
    ) +
    theme_bw(
      base_size = 11
    )

  ggsave(
    file.path(
      OUT_DIR,
      "plots",
      paste0(
        "CLUSTER_",
        safe_file_name(
          representation
        ),
        "_silhouette.png"
      )
    ),
    p_sil,
    width = 7,
    height = 5,
    dpi = 300
  )


  # PCA visualization of the SILHOUETTE-optimal clusters only.
  # Clustering itself was performed in the full transformed feature space.
  cluster_pca <- prcomp(
    prep_cluster$X_model,
    center = FALSE,
    scale. = FALSE
  )

  cluster_plot_df <- bind_cols(
    assignments %>%
      select(
        site_name,
        silhouette_cluster
      ),
    as.data.frame(
      cluster_pca$x[
        ,
        1:min(
          2,
          ncol(
            cluster_pca$x
          )
        ),
        drop = FALSE
      ]
    )
  )

  if (
    all(
      c(
        "PC1",
        "PC2"
      ) %in%
        names(
          cluster_plot_df
        )
    )
  ) {

    variance_prop <-
      cluster_pca$sdev^2 /
      sum(
        cluster_pca$sdev^2
      )

    p_cluster <- ggplot(
      cluster_plot_df,
      aes(
        x = PC1,
        y = PC2,
        color =
          silhouette_cluster
      )
    ) +
      geom_point(
        size = 2.6,
        alpha = 0.85
      ) +
      stat_ellipse(
        aes(
          group =
            silhouette_cluster
        ),
        level =
          ELLIPSE_LEVEL,
        type = "norm",
        linewidth = 0.7,
        na.rm = TRUE
      ) +
      labs(
        title =
          paste(
            representation,
            "- silhouette-optimal unsupervised clusters"
          ),

        subtitle =
          paste0(
            "k=",
            k_sil,
            "; clustering used full transformed feature space"
          ),

        x =
          paste0(
            "PC1 (",
            round(
              100 *
                variance_prop[[1]],
              1
            ),
            "%)"
          ),

        y =
          paste0(
            "PC2 (",
            round(
              100 *
                variance_prop[[2]],
              1
            ),
            "%)"
          ),

        color =
          "Cluster"
      ) +
      theme_bw(
        base_size = 11
      )

    ggsave(
      file.path(
        OUT_DIR,
        "plots",
        paste0(
          "CLUSTER_",
          safe_file_name(
            representation
          ),
          "_silhouette_optimal_PCA_view.png"
        )
      ),
      p_cluster,
      width = 8,
      height = 6,
      dpi = 300
    )
  }


  cluster_diagnostics_all[[length(cluster_diagnostics_all) + 1]] <- eval$diagnostics

  cluster_recommendations_all[[length(cluster_recommendations_all) + 1]] <- rec

  cluster_assignments_all[[length(cluster_assignments_all) + 1]] <- assignments

  cluster_crosswalks_all[[length(cluster_crosswalks_all) + 1]] <- crosswalks
}


CLUSTER_DIAGNOSTICS_ALL <-
  bind_rows(
    cluster_diagnostics_all
  )

CLUSTER_RECOMMENDATIONS_ALL <-
  bind_rows(
    cluster_recommendations_all
  )

CLUSTER_ASSIGNMENTS_ALL <-
  bind_rows(
    cluster_assignments_all
  )

CLUSTER_CROSSWALKS_ALL <-
  bind_rows(
    cluster_crosswalks_all
  )

write_csv(
  CLUSTER_DIAGNOSTICS_ALL,
  file.path(
    OUT_DIR,
    "MASTER_CLUSTER_k_diagnostics_silhouette_elbow.csv"
  )
)

write_csv(
  CLUSTER_RECOMMENDATIONS_ALL,
  file.path(
    OUT_DIR,
    "MASTER_CLUSTER_recommended_k.csv"
  )
)

write_csv(
  CLUSTER_ASSIGNMENTS_ALL,
  file.path(
    OUT_DIR,
    "MASTER_CLUSTER_site_assignments.csv"
  )
)

write_csv(
  CLUSTER_CROSSWALKS_ALL,
  file.path(
    OUT_DIR,
    "MASTER_CLUSTER_crosswalk_archaeological_C_G_groups.csv"
  )
)



# ==============================================================================
# 18. COMBINED SUMMARY TABLES
# ==============================================================================

PERMANOVA_ALL <-
  bind_rows(
    master_permanova
  ) %>%
  mutate(
    q_BH =
      p.adjust(
        p,
        method = "BH"
      ),

    dispersion_warning =
      map2_lgl(
        task,
        representation,
        function(tt, rr) {

          z <- bind_rows(
            master_permdisp
          ) %>%
            filter(
              task == tt,
              representation == rr
            )

          if (nrow(z) == 0) {
            return(
              NA
            )
          }

          z$p[[1]] <
            0.05
        }
      )
  )

PERMDISP_ALL <-
  bind_rows(
    master_permdisp
  ) %>%
  mutate(
    q_BH =
      p.adjust(
        p,
        method = "BH"
      )
  )

PAIRWISE_ALL <-
  bind_rows(
    master_pairwise
  )

PC_TESTS_ALL <-
  bind_rows(
    master_pc_tests
  )

SAMPLE_SIZES_ALL <-
  bind_rows(
    master_sample_sizes
  )

PRESENCE_ALL <-
  bind_rows(
    master_presence
  )

write_csv(
  PERMANOVA_ALL,
  file.path(
    OUT_DIR,
    "MASTER_PERMANOVA_omnibus.csv"
  )
)

write_csv(
  PERMDISP_ALL,
  file.path(
    OUT_DIR,
    "MASTER_PERMDISP_omnibus.csv"
  )
)

write_csv(
  PAIRWISE_ALL,
  file.path(
    OUT_DIR,
    "MASTER_pairwise_PERMANOVA_PERMDISP.csv"
  )
)

write_csv(
  PC_TESTS_ALL,
  file.path(
    OUT_DIR,
    "MASTER_retained_PC_score_tests.csv"
  )
)

write_csv(
  SAMPLE_SIZES_ALL,
  file.path(
    OUT_DIR,
    "MASTER_sample_sizes.csv"
  )
)

if (nrow(PRESENCE_ALL) > 0) {
  write_csv(
    PRESENCE_ALL,
    file.path(
      OUT_DIR,
      "MASTER_presence_Jaccard_tests.csv"
    )
  )
}


# ==============================================================================
# 19. INTERPRETATION AID
# ==============================================================================

interpretation <- c(
  "HOW TO READ THIS ANALYSIS",
  "",
  "1. PCA is descriptive ordination, not the significance test.",
  "",
  "2. PRIMARY group inference is MASTER_PERMANOVA_omnibus.csv.",
  "   R2 = proportion of multivariate variation associated with group.",
  "   q_BH < 0.05 = FDR-significant group difference.",
  "",
  "3. Always inspect MASTER_PERMDISP_omnibus.csv.",
  "   If PERMDISP is significant, groups differ in within-group spread.",
  "   A significant PERMANOVA can then reflect both centroid separation and dispersion.",
  "",
  "4. Pairwise group results are in MASTER_pairwise_PERMANOVA_PERMDISP.csv.",
  "   Use q_BH rather than raw p for multiple pairwise comparisons.",
  "",
  "5. PCA variance and retained components are in each",
  "   *_PCA_variance_parallel_brokenstick.csv file.",
  "   parallel_retain = TRUE means the observed eigenvalue exceeds the 95th",
  "   percentile from independently permuted variables.",
  "",
  "6. PCA loadings identify which bones define each PC.",
  "   Use *_PCA_top10_loadings_each_PC.csv for interpretation.",
  "",
  "7. The retained-PC score permutation tests are secondary.",
  "   They help identify which supported PCA axes differ among groups,",
  "   but they do NOT replace the full-space PERMANOVA.",
  "",
  "8. Presence/absence is analysed once (from %MNAU zero/non-zero status)",
  "   with Jaccard PCoA, not ordinary PCA. It is not duplicated for ReMNAU.",
  "",
  "9. %MNAU uses standardized PCA because the aim is to retain absolute",
  "   skeletal representation while giving retained bones comparable weight.",
  "",
  "10. ReMNAU uses Hellinger PCA because it is a relative non-negative",
  "    composition containing zeros.",
  "",
  "11. For C/G analyses, cross-group parent sites are excluded from inference",
  "    by default to preserve independent parent-site units.",
  "",
  "12. 90% ellipses on plots are concentration ellipses only.",
  "    They are not confidence intervals and do not establish significance.",
  "",
  "13. A separate unsupervised k-means analysis evaluates natural group count",
  "    independently for %MNAU and ReMNAU.",
  "    It uses the full transformed skeletal-part feature space.",
  "",
  "14. MASTER_CLUSTER_k_diagnostics_silhouette_elbow.csv reports WSS and",
  "    average silhouette width for every tested k.",
  "",
  "15. MASTER_CLUSTER_recommended_k.csv reports the silhouette-optimal k and",
  "    the automatic elbow k. If they disagree, both are retained.",
  "",
  "16. Elbow is a heuristic rather than a formal significance test.",
  "    Silhouette measures within-cluster cohesion versus between-cluster",
  "    separation; larger average silhouette is better.",
  "",
  "17. MASTER_CLUSTER_site_assignments.csv gives each parent site's cluster",
  "    under both the silhouette-optimal and elbow solutions.",
  "",
  "18. MASTER_CLUSTER_crosswalk_archaeological_C_G_groups.csv compares those",
  "    unsupervised clusters with class4, C and G labels for interpretation;",
  "    those labels were not used to construct the clusters."
)

writeLines(
  interpretation,
  file.path(
    OUT_DIR,
    "README_INTERPRETATION.txt"
  )
)


# ==============================================================================
# 20. SESSION INFO / COMPLETION
# ==============================================================================

capture.output(
  sessionInfo(),
  file =
    file.path(
      OUT_DIR,
      "sessionInfo.txt"
    )
)

writeLines(
  c(
    paste0(
      "Finished: ",
      Sys.time()
    ),
    paste0(
      "SUM file: ",
      SUM_FILE
    ),
    paste0(
      "IND bridge: ",
      IND_FILE
    ),
    paste0(
      "Assignment file: ",
      ASSIGNMENT_FILE
    ),
    paste0(
      "N_PERM: ",
      N_PERM
    ),
    paste0(
      "N_PARALLEL: ",
      N_PARALLEL
    )
  ),
  file.path(
    OUT_DIR,
    "RUN_FINISHED.txt"
  )
)

cat(
  "\n============================================================\n",
  "ANALYSIS FINISHED\n",
  "Results written to: ",
  OUT_DIR,
  "\nPrimary files:\n",
  "  MASTER_PERMANOVA_omnibus.csv\n",
  "  MASTER_PERMDISP_omnibus.csv\n",
  "  MASTER_pairwise_PERMANOVA_PERMDISP.csv\n",
  "  MASTER_retained_PC_score_tests.csv\n",
  "  MASTER_presence_Jaccard_tests.csv\n",
  "  MASTER_CLUSTER_k_diagnostics_silhouette_elbow.csv\n",
  "  MASTER_CLUSTER_recommended_k.csv\n",
  "  MASTER_CLUSTER_site_assignments.csv\n",
  "  MASTER_CLUSTER_crosswalk_archaeological_C_G_groups.csv\n",
  "  README_INTERPRETATION.txt\n",
  "============================================================\n",
  sep = ""
)
