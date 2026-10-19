# ==============================================================================
# SKELETAL-PART DIFFERENCES ACROSS ARCHAEOLOGICAL / PHENOTYPIC GROUPS
# ==============================================================================
#
# Research questions
# ------------------
# 1) Four-class:
#    Which skeletal parts differ among Funerary Context, Cannibalism,
#    Carnivore, and Geological transport assemblages?
#
# 2) Funerary vs non-funerary:
#    Which skeletal parts are more or less represented in Funerary Context
#    than in the combined non-funerary reference?
#
# 3) Funerary vs Cannibalism:
#    Which skeletal parts distinguish Funerary Context from Cannibalism?
#
# 4) C1-C5:
#    Which skeletal parts characterize the five C + Heip phenotypic groups?
#
# 5) G groups:
#    Which skeletal parts characterize the G groups?
#
# IMPORTANT ABOUT THE UPLOADED GROUP FILE
# ---------------------------------------
# The supplied assignment file contains:
#   C1-C5  = 5 C groups
#   G0-G5  = 6 G groups
#
# The fifth analysis uses the complete supplied G0-G5 solution
# (all six G groups).
#
# DATA / PREPROCESSING
# --------------------
# - Input assemblage table: final/tapho_db_sum.csv
# - Group assignment file: site_C1_C5_G0_G5_assignments_compact*.csv
# - No imputation.
# - No scaling.
# - A skeletal part not found should already be represented by 0 in the input.
# - If NA is found in a bone variable, the script stops by default rather than
#   silently turning it into zero.
# - Exact bilateral _indet/_left/_right triplets are redistributed using the
#   same logic as the supervised workflow:
#       * %MNAU: approximately 50:50, each side capped at 1
#       * ReMNAU: approximately 50:50, no cap
# - Paired left/right variables are then averaged to a single bone-level value.
#   Unpaired "_indet" variables remain separate variables.
#
# STATISTICAL STRATEGY
# --------------------
# For each skeletal part, separately for %MNAU and ReMNAU:
#
# A. Descriptive:
#    - n unique sites
#    - mean
#    - median
#    - IQR
#    - prevalence / presence (% of site-group observations > 0)
#
# B. Primary inference:
#    - linear model of bone representation ~ group
#    - CR2 cluster-robust covariance, clustered by site_name
#    - omnibus Wald test for multi-group comparisons
#    - pairwise CR2/Satterthwaite contrasts
#
# Why cluster by site?
# Some parent sites contribute more than one assemblage record. In the C/G
# assignments, a small number of sites can even occupy more than one group.
# Treating every row as fully independent would therefore be inappropriate.
#
# C. Effect size:
#    - mean difference
#    - median difference
#    - Cliff's delta (group B versus group A) for abundance
#
# D. Presence:
#    The same CR2 framework is applied to presence (value > 0), giving
#    differences in the probability/frequency with which a skeletal part occurs.
#
# E. Permutation confirmation:
#    For the archaeological-label tasks in which every site has only one group
#    after site-level aggregation (4-class, F-vs-NF, F-vs-Cannibalism), the
#    script also performs site-level label permutation tests.
#
#    It deliberately DOES NOT use naive label permutation for C/G comparisons
#    when one site can occur in more than one C/G group. CR2 site-clustered
#    inference is used there instead.
#
# F. Multiple testing:
#    Benjamini-Hochberg FDR correction is applied:
#       - omnibus tests across bones within task x representation x measure
#       - pairwise tests across bones within each specific contrast
#    A second q-value across ALL pairwise bone tests within a task is also saved.
#
# INTERPRETATION
# --------------
# Pairwise estimate = mean(group_B) - mean(group_A).
# Positive estimate -> skeletal part is more represented in group_B.
# Negative estimate -> skeletal part is more represented in group_A.
#
# For the presence analysis, an estimate of +0.20 means approximately
# 20 percentage points higher occurrence in group_B.
#
# C1-C5 CAUTION
# -------------
# The C groups were created from C + Heip, which themselves summarize skeletal
# representation. Bone-by-C-group tests therefore CHARACTERIZE the discovered
# phenotypes; they should not be presented as independent confirmation that the
# same skeletal data differ among clusters.
# ==============================================================================


# ------------------------------------------------------------------------------
# 0. USER SETTINGS
# ------------------------------------------------------------------------------

INPUT_FILE <- "final/tapho_db_sum.csv"

ASSIGNMENT_FILE <- "site_C1_C5_G0_G5_assignments_compact(2).csv"

# If the exact filename above is not present, automatically look for one
# matching C1-C5 / G0-G5 assignment CSV in the working directory.
if (!file.exists(ASSIGNMENT_FILE)) {
  assignment_candidates <- list.files(
    path = ".",
    pattern = "^site_C1_C5_G0_G5_assignments_compact.*\\.csv$",
    full.names = TRUE
  )

  if (length(assignment_candidates) == 1L) {
    ASSIGNMENT_FILE <- assignment_candidates[[1]]
  } else if (length(assignment_candidates) > 1L) {
    stop(
      "More than one C/G assignment file was found. ",
      "Set ASSIGNMENT_FILE explicitly at the top of the script.\n",
      paste(assignment_candidates, collapse = "\n")
    )
  }
}

OUT_DIR <- "skeletal_part_group_statistics_outputs"

SEED <- 42L

# Monte-Carlo permutations for tasks where a valid site-level label permutation
# is possible. Increase to 9999 or 19999 for final publication runs if desired.
N_PERM <- 4999L

# Dataset is expected to encode absence as 0, not NA.
# Keep FALSE unless you have verified that every NA truly means anatomical absence.
ALLOW_NA_AS_ZERO <- FALSE

FDR_ALPHA <- 0.05


# ------------------------------------------------------------------------------
# 1. PACKAGES
# ------------------------------------------------------------------------------

required_packages <- c(
  "tidyverse",
  "clubSandwich"
)

missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
]

if (length(missing_packages) > 0) {
  stop(
    "Install these packages before running:\n  ",
    paste(missing_packages, collapse = "\n  ")
  )
}

library(tidyverse)
library(clubSandwich)

set.seed(SEED)

dir.create(
  OUT_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


# ------------------------------------------------------------------------------
# 2. READ INPUTS
# ------------------------------------------------------------------------------

if (!file.exists(INPUT_FILE)) {
  stop(
    "Cannot find INPUT_FILE: ", INPUT_FILE,
    "\nCurrent working directory: ", getwd()
  )
}

if (!file.exists(ASSIGNMENT_FILE)) {
  stop(
    "Cannot find ASSIGNMENT_FILE: ", ASSIGNMENT_FILE,
    "\nPut the supplied C/G assignment CSV in the working directory ",
    "or change ASSIGNMENT_FILE at the top of this script."
  )
}

d <- readr::read_csv(
  INPUT_FILE,
  show_col_types = FALSE
)

assignments <- readr::read_csv(
  ASSIGNMENT_FILE,
  show_col_types = FALSE
)

required_data_cols <- c(
  "site_id",
  "site_name",
  "taphonomic_context"
)

required_assignment_cols <- c(
  "site_id",
  "site_name",
  "C_group",
  "C_description",
  "G_group",
  "G_description"
)

miss_d <- setdiff(
  required_data_cols,
  names(d)
)

miss_a <- setdiff(
  required_assignment_cols,
  names(assignments)
)

if (length(miss_d) > 0) {
  stop(
    "tapho_db_sum.csv is missing required columns: ",
    paste(miss_d, collapse = ", ")
  )
}

if (length(miss_a) > 0) {
  stop(
    "C/G assignment file is missing required columns: ",
    paste(miss_a, collapse = ", ")
  )
}

if (anyDuplicated(assignments$site_id)) {
  stop(
    "site_id must uniquely identify rows in the C/G assignment file."
  )
}


# ------------------------------------------------------------------------------
# 3. BROAD ARCHAEOLOGICAL CLASS LABELS
# ------------------------------------------------------------------------------

collapse_class4 <- function(x) {

  case_when(

    x == "Funerary Context" ~
      "Funerary Context",

    x == "Cannibalism" ~
      "Cannibalism",

    x %in% c(
      "Carnivore",
      "Carnivore-related",
      "Carnivore Scavenge (in situ)",
      "Carnivore den(transport)",
      "Carnivore den (transport)"
    ) ~
      "Carnivore",

    x == "Geological transport" ~
      "Geological transport",

    TRUE ~
      NA_character_
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


# ------------------------------------------------------------------------------
# 4. JOIN C/G ASSIGNMENTS BY site_id
# ------------------------------------------------------------------------------

assignment_small <- assignments %>%
  select(
    site_id,
    assignment_site_name = site_name,
    C_group,
    C_description,
    G_group,
    G_description
  )

d <- d %>%
  left_join(
    assignment_small,
    by = "site_id"
  )

# Audit site-name agreement for matched IDs.
join_audit <- d %>%
  transmute(
    site_id,
    site_name,
    assignment_site_name,
    C_group,
    G_group,
    matched_assignment =
      !is.na(assignment_site_name),
    site_name_agrees =
      is.na(assignment_site_name) |
      site_name == assignment_site_name
  )

write_csv(
  join_audit,
  file.path(
    OUT_DIR,
    "00_CG_join_audit.csv"
  )
)

if (
  any(
    !join_audit$site_name_agrees,
    na.rm = TRUE
  )
) {
  warning(
    "Some site_id values matched but site_name differs. ",
    "Inspect 00_CG_join_audit.csv before interpreting C/G results."
  )
}


# ------------------------------------------------------------------------------
# 5. CHECK / HANDLE BONE-VARIABLE NAs
# ------------------------------------------------------------------------------

prop_cols_initial <- names(d)[
  str_starts(
    names(d),
    "ProportionalRep_MNIbased_"
  )
]

rem_cols_initial <- names(d)[
  str_starts(
    names(d),
    "ReMNAU_"
  ) &
    !str_starts(
      names(d),
      "ReMNAU_adjusted_"
    )
]

if (length(prop_cols_initial) == 0) {
  stop(
    "No ProportionalRep_MNIbased_* variables found."
  )
}

if (length(rem_cols_initial) == 0) {
  stop(
    "No raw ReMNAU_* variables found."
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
      ~ sum(
        is.na(
          d[[.x]]
        )
      )
    )
  )

write_csv(
  bone_na_audit,
  file.path(
    OUT_DIR,
    "00_bone_NA_audit.csv"
  )
)

if (
  any(
    bone_na_audit$n_NA > 0
  )
) {

  if (!ALLOW_NA_AS_ZERO) {

    bad <- bone_na_audit %>%
      filter(
        n_NA > 0
      )

    stop(
      "NA values were found in skeletal-part variables.\n",
      "No imputation is performed by this script.\n",
      "Inspect 00_bone_NA_audit.csv.\n",
      "If, and only if, those NAs truly mean 'bone not found', ",
      "set ALLOW_NA_AS_ZERO <- TRUE."
    )

  } else {

    bone_cols_all <- c(
      prop_cols_initial,
      rem_cols_initial
    )

    for (v in bone_cols_all) {
      d[[v]][is.na(d[[v]])] <- 0
    }
  }
}


# ------------------------------------------------------------------------------
# 6. EXACT BILATERAL _indet REDISTRIBUTION
# ------------------------------------------------------------------------------

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

  for (
    i in seq_along(
      triplet_bases
    )
  ) {

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

    # First split as evenly as possible.
    new_left <- left + indet / 2
    new_right <- right + indet / 2

    residual <- rep(
      0,
      nrow(dat)
    )

    if (!is.null(cap)) {

      # Cap each side.
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

      # Flow overflow from left to right where possible.
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

      # Flow overflow from right to left where possible.
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

      # Any amount that cannot be assigned because both sides are full
      # remains in the indeterminate column.
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


# %MNAU: cap sides at 1.
prop_red <- redistribute_triplets(
  d,
  prefix = "ProportionalRep_MNIbased_",
  cap = 1
)

d <- prop_red$data

# ReMNAU: no cap.
rem_red <- redistribute_triplets(
  d,
  prefix = "ReMNAU_",
  cap = NULL
)

d <- rem_red$data

redistribution_audit <- bind_rows(
  prop_red$audit,
  rem_red$audit
)

write_csv(
  redistribution_audit,
  file.path(
    OUT_DIR,
    "00_bilateral_indet_redistribution_audit.csv"
  )
)


# ------------------------------------------------------------------------------
# 7. BUILD BONE-LEVEL %MNAU AND ReMNAU VALUES
# ------------------------------------------------------------------------------

make_bone_level <- function(
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

  # Remove the paired indeterminate variables after redistribution.
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

          if (
            length(
              matched_base
            ) == 1
          ) {
            matched_base
          } else {
            # Unpaired _indet variables deliberately keep their full name.
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

  bone_wide <- dat %>%
    select(
      site_id,
      site_name,
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
      pull(variable)

    bone_wide[[bone_name]] <- rowMeans(
      as.matrix(
        bone_wide[
          ,
          v,
          drop = FALSE
        ]
      ),
      na.rm = FALSE
    )
  }

  bone_wide <- bone_wide %>%
    select(
      site_id,
      site_name,
      class4,
      F_NF,
      C_group,
      C_description,
      G_group,
      G_description,
      all_of(bones)
    )

  bone_long <- bone_wide %>%
    pivot_longer(
      cols = all_of(bones),
      names_to = "bone",
      values_to = "value"
    ) %>%
    mutate(
      representation =
        representation_name,
      .before = bone
    )

  list(
    long = bone_long,
    manifest = manifest
  )
}


prop_bones <- make_bone_level(
  d,
  prefix =
    "ProportionalRep_MNIbased_",
  representation_name =
    "%MNAU",
  triplet_bases =
    prop_red$triplet_bases
)

rem_bones <- make_bone_level(
  d,
  prefix =
    "ReMNAU_",
  representation_name =
    "ReMNAU",
  triplet_bases =
    rem_red$triplet_bases,
  exclude_regex =
    "^ReMNAU_adjusted_"
)

bone_long_all <- bind_rows(
  prop_bones$long,
  rem_bones$long
)

bone_manifest <- bind_rows(
  prop_bones$manifest,
  rem_bones$manifest
)

write_csv(
  bone_manifest,
  file.path(
    OUT_DIR,
    "01_bone_variable_manifest.csv"
  )
)


# ------------------------------------------------------------------------------
# 8. TASK DEFINITIONS
# ------------------------------------------------------------------------------

task_four_class <- bone_long_all %>%
  filter(
    !is.na(class4)
  ) %>%
  mutate(
    analysis_group = factor(
      class4,
      levels = c(
        "Geological transport",
        "Carnivore",
        "Cannibalism",
        "Funerary Context"
      )
    )
  )


task_F_vs_NF <- bone_long_all %>%
  filter(
    !is.na(F_NF)
  ) %>%
  mutate(
    analysis_group = factor(
      F_NF,
      levels = c(
        "NF",
        "F"
      )
    )
  )


task_F_vs_Cann <- bone_long_all %>%
  filter(
    class4 %in%
      c(
        "Cannibalism",
        "Funerary Context"
      )
  ) %>%
  mutate(
    analysis_group = factor(
      class4,
      levels = c(
        "Cannibalism",
        "Funerary Context"
      )
    )
  )


task_C1_C5 <- bone_long_all %>%
  filter(
    C_group %in%
      paste0(
        "C",
        1:5
      )
  ) %>%
  mutate(
    analysis_group = factor(
      C_group,
      levels = paste0(
        "C",
        1:5
      )
    )
  )


# Full supplied G solution.
task_G0_G5 <- bone_long_all %>%
  filter(
    G_group %in%
      paste0(
        "G",
        0:5
      )
  ) %>%
  mutate(
    analysis_group = factor(
      G_group,
      levels = paste0(
        "G",
        0:5
      )
    )
  )



task_list <- list(
  `four_class` =
    task_four_class,

  `Funerary_vs_Cannibalism` =
    task_F_vs_Cann,

  `F_vs_NF` =
    task_F_vs_NF,

  `C1_C5` =
    task_C1_C5,

  `G0_G5` =
    task_G0_G5
)



# Group dictionary
group_dictionary <- bind_rows(
  assignments %>%
    distinct(
      C_group,
      C_description
    ) %>%
    filter(
      !is.na(C_group)
    ) %>%
    transmute(
      scheme = "C",
      group = C_group,
      description = C_description
    ),

  assignments %>%
    distinct(
      G_group,
      G_description
    ) %>%
    filter(
      !is.na(G_group)
    ) %>%
    transmute(
      scheme = "G",
      group = G_group,
      description = G_description
    )
) %>%
  arrange(
    scheme,
    group
  )

write_csv(
  group_dictionary,
  file.path(
    OUT_DIR,
    "01_group_dictionary.csv"
  )
)


# ------------------------------------------------------------------------------
# 9. SITE-GROUP AGGREGATION
# ------------------------------------------------------------------------------

# If the same parent site has multiple rows in the SAME analysis group,
# average them before formal testing.
#
# If the same site genuinely occurs in DIFFERENT C/G groups, retain one value
# for each site x group combination and account for the repeated parent site
# using site-clustered CR2 variance.

aggregate_site_group <- function(
  dat
) {

  dat %>%
    filter(
      !is.na(
        analysis_group
      )
    ) %>%
    group_by(
      representation,
      bone,
      site_name,
      analysis_group
    ) %>%
    summarise(
      value = mean(
        value,
        na.rm = FALSE
      ),
      n_source_rows = n(),
      .groups = "drop"
    ) %>%
    mutate(
      analysis_group =
        droplevels(
          analysis_group
        )
    )
}


# ------------------------------------------------------------------------------
# 10. HELPER FUNCTIONS: DESCRIPTIVE STATISTICS
# ------------------------------------------------------------------------------

safe_q <- function(
  x,
  p
) {

  if (
    length(x) == 0
  ) {
    return(
      NA_real_
    )
  }

  as.numeric(
    quantile(
      x,
      probs = p,
      na.rm = TRUE,
      names = FALSE
    )
  )
}


descriptive_summary <- function(
  dat,
  measure_name
) {

  dat %>%
    group_by(
      representation,
      bone,
      analysis_group
    ) %>%
    summarise(
      measure = measure_name,
      n_site_group_observations = n(),
      n_unique_sites =
        n_distinct(
          site_name
        ),
      mean =
        mean(
          outcome,
          na.rm = TRUE
        ),
      median =
        median(
          outcome,
          na.rm = TRUE
        ),
      q25 =
        safe_q(
          outcome,
          0.25
        ),
      q75 =
        safe_q(
          outcome,
          0.75
        ),
      sd =
        sd(
          outcome,
          na.rm = TRUE
        ),
      .groups = "drop"
    )
}


# ------------------------------------------------------------------------------
# 11. EFFECT SIZE: CLIFF'S DELTA
# ------------------------------------------------------------------------------

# Delta is defined as:
# P(group B > group A) - P(group B < group A)
#
# Comparisons involving the same parent site on both sides are excluded.
# This is especially relevant to the rare C/G cases where one site can occupy
# more than one group.

cliffs_delta_B_vs_A <- function(
  dat,
  group_A,
  group_B
) {

  A <- dat %>%
    filter(
      analysis_group == group_A
    ) %>%
    select(
      site_name,
      outcome
    )

  B <- dat %>%
    filter(
      analysis_group == group_B
    ) %>%
    select(
      site_name,
      outcome
    )

  if (
    nrow(A) == 0 |
      nrow(B) == 0
  ) {
    return(
      NA_real_
    )
  }

  comparison_grid <- tidyr::crossing(
    iB = seq_len(
      nrow(B)
    ),
    iA = seq_len(
      nrow(A)
    )
  ) %>%
    mutate(
      same_site =
        B$site_name[iB] ==
        A$site_name[iA],

      signed_difference =
        sign(
          B$outcome[iB] -
            A$outcome[iA]
        )
    ) %>%
    filter(
      !same_site
    )

  if (
    nrow(
      comparison_grid
    ) == 0
  ) {
    return(
      NA_real_
    )
  }

  mean(
    comparison_grid$signed_difference
  )
}


# ------------------------------------------------------------------------------
# 12. PERMUTATION HELPERS
# ------------------------------------------------------------------------------

oneway_F_stat <- function(
  y,
  g
) {

  g <- factor(g)

  k <- nlevels(g)
  n <- length(y)

  if (
    k < 2 |
      n <= k
  ) {
    return(
      NA_real_
    )
  }

  grand <- mean(y)

  means <- tapply(
    y,
    g,
    mean
  )

  ns <- table(g)

  ss_between <- sum(
    as.numeric(ns) *
      (
        means -
          grand
      ) ^ 2
  )

  ss_within <- sum(
    vapply(
      levels(g),
      function(level_now) {

        z <- y[
          g == level_now
        ]

        sum(
          (
            z -
              mean(z)
          ) ^ 2
        )
      },
      numeric(1)
    )
  )

  df_between <-
    k - 1

  df_within <-
    n - k

  if (
    df_within <= 0 |
      ss_within <= 0
  ) {

    if (
      ss_between > 0
    ) {
      return(
        Inf
      )
    }

    return(
      0
    )
  }

  (
    ss_between /
      df_between
  ) /
    (
      ss_within /
        df_within
    )
}


permutation_omnibus_p <- function(
  dat,
  n_perm,
  seed
) {

  # Valid only where each parent site has one group label.
  unique_group_per_site <- dat %>%
    distinct(
      site_name,
      analysis_group
    ) %>%
    count(
      site_name
    ) %>%
    summarise(
      max_n =
        max(n)
    ) %>%
    pull(
      max_n
    )

  if (
    unique_group_per_site > 1
  ) {
    return(
      NA_real_
    )
  }

  y <- dat$outcome
  g <- dat$analysis_group

  obs <- oneway_F_stat(
    y,
    g
  )

  if (
    is.na(obs)
  ) {
    return(
      NA_real_
    )
  }

  set.seed(seed)

  perm_stats <- replicate(
    n_perm,
    oneway_F_stat(
      y,
      sample(g)
    )
  )

  (
    1 +
      sum(
        perm_stats >= obs,
        na.rm = TRUE
      )
  ) /
    (
      n_perm + 1
    )
}


permutation_pairwise_p <- function(
  dat,
  group_A,
  group_B,
  n_perm,
  seed
) {

  sub <- dat %>%
    filter(
      analysis_group %in%
        c(
          group_A,
          group_B
        )
    ) %>%
    mutate(
      analysis_group =
        droplevels(
          factor(
            analysis_group,
            levels = c(
              group_A,
              group_B
            )
          )
        )
    )

  unique_group_per_site <- sub %>%
    distinct(
      site_name,
      analysis_group
    ) %>%
    count(
      site_name
    ) %>%
    summarise(
      max_n =
        max(n)
    ) %>%
    pull(
      max_n
    )

  if (
    unique_group_per_site > 1
  ) {
    return(
      NA_real_
    )
  }

  y <- sub$outcome
  g <- sub$analysis_group

  obs <- abs(
    mean(
      y[
        g == group_B
      ]
    ) -
      mean(
        y[
          g == group_A
        ]
      )
  )

  set.seed(seed)

  perm_stats <- replicate(
    n_perm,
    {

      gp <- sample(g)

      abs(
        mean(
          y[
            gp == group_B
          ]
        ) -
          mean(
            y[
              gp == group_A
            ]
          )
      )
    }
  )

  (
    1 +
      sum(
        perm_stats >= obs,
        na.rm = TRUE
      )
  ) /
    (
      n_perm + 1
    )
}


# ------------------------------------------------------------------------------
# 13. CR2 OMNIBUS TEST FOR ONE BONE
# ------------------------------------------------------------------------------

extract_first_named <- function(
  x,
  candidate_names
) {

  hit <- intersect(
    candidate_names,
    names(x)
  )

  if (
    length(hit) == 0
  ) {
    return(
      NA_real_
    )
  }

  suppressWarnings(
    as.numeric(
      x[[hit[[1]]]][[1]]
    )
  )
}


robust_omnibus_one_bone <- function(
  dat,
  seed
) {

  dat <- dat %>%
    filter(
      is.finite(outcome)
    ) %>%
    mutate(
      analysis_group =
        droplevels(
          factor(
            analysis_group
          )
        )
    )

  k <- nlevels(
    dat$analysis_group
  )

  if (
    k < 2 |
      nrow(dat) <= k
  ) {

    return(
      tibble(
        n = nrow(dat),
        n_unique_sites =
          n_distinct(
            dat$site_name
          ),
        n_groups = k,
        CR2_F = NA_real_,
        CR2_df_num = NA_real_,
        CR2_df_denom = NA_real_,
        CR2_p = NA_real_,
        permutation_p = NA_real_,
        permutation_valid = FALSE
      )
    )
  }

  fit <- lm(
    outcome ~ analysis_group,
    data = dat
  )

  V <- tryCatch(
    clubSandwich::vcovCR(
      fit,
      cluster =
        dat$site_name,
      type = "CR2"
    ),
    error = function(e) {
      NULL
    }
  )

  Fstat <- NA_real_
  df_num <- NA_real_
  df_denom <- NA_real_
  p_cr2 <- NA_real_

  if (!is.null(V)) {

    wt <- tryCatch(
      clubSandwich::Wald_test(
        fit,
        constraints =
          clubSandwich::constrain_zero(
            2:length(
              coef(fit)
            )
          ),
        vcov = V,
        test = "HTZ"
      ),
      error = function(e) {
        NULL
      }
    )

    if (!is.null(wt)) {

      Fstat <- extract_first_named(
        wt,
        c(
          "Fstat",
          "F_stat"
        )
      )

      df_num <- extract_first_named(
        wt,
        c(
          "df_num",
          "df_num."
        )
      )

      df_denom <- extract_first_named(
        wt,
        c(
          "df_denom",
          "df_denom."
        )
      )

      p_cr2 <- extract_first_named(
        wt,
        c(
          "p_val",
          "p",
          "p.value"
        )
      )
    }
  }

  # Site-level permutation confirmation is valid only if a parent site occurs
  # in exactly one group in this task.
  max_groups_per_site <- dat %>%
    distinct(
      site_name,
      analysis_group
    ) %>%
    count(
      site_name
    ) %>%
    summarise(
      max_n =
        max(n)
    ) %>%
    pull(
      max_n
    )

  perm_valid <-
    max_groups_per_site == 1

  p_perm <- if (
    perm_valid
  ) {

    permutation_omnibus_p(
      dat,
      n_perm = N_PERM,
      seed = seed
    )

  } else {

    NA_real_
  }

  tibble(
    n = nrow(dat),

    n_unique_sites =
      n_distinct(
        dat$site_name
      ),

    n_groups = k,

    CR2_F = Fstat,

    CR2_df_num =
      df_num,

    CR2_df_denom =
      df_denom,

    CR2_p =
      p_cr2,

    permutation_p =
      p_perm,

    permutation_valid =
      perm_valid
  )
}


# ------------------------------------------------------------------------------
# 14. CR2 PAIRWISE TEST FOR ONE BONE
# ------------------------------------------------------------------------------

robust_pairwise_one_bone <- function(
  dat,
  group_A,
  group_B,
  seed,
  calculate_cliff = TRUE
) {

  sub <- dat %>%
    filter(
      analysis_group %in%
        c(
          group_A,
          group_B
        ),
      is.finite(
        outcome
      )
    ) %>%
    mutate(
      analysis_group = factor(
        analysis_group,
        levels = c(
          group_A,
          group_B
        )
      )
    )

  n_A <- sum(
    sub$analysis_group ==
      group_A
  )

  n_B <- sum(
    sub$analysis_group ==
      group_B
  )

  if (
    n_A < 2 |
      n_B < 2
  ) {

    return(
      tibble(
        group_A = group_A,
        group_B = group_B,
        n_A = n_A,
        n_B = n_B,
        mean_A = NA_real_,
        mean_B = NA_real_,
        median_A = NA_real_,
        median_B = NA_real_,
        estimate_B_minus_A = NA_real_,
        robust_SE = NA_real_,
        t_stat = NA_real_,
        df_Satt = NA_real_,
        CR2_p = NA_real_,
        permutation_p = NA_real_,
        permutation_valid = FALSE,
        cliffs_delta_B_vs_A = NA_real_
      )
    )
  }

  mean_A <- mean(
    sub$outcome[
      sub$analysis_group ==
        group_A
    ]
  )

  mean_B <- mean(
    sub$outcome[
      sub$analysis_group ==
        group_B
    ]
  )

  median_A <- median(
    sub$outcome[
      sub$analysis_group ==
        group_A
    ]
  )

  median_B <- median(
    sub$outcome[
      sub$analysis_group ==
        group_B
    ]
  )

  fit <- lm(
    outcome ~ analysis_group,
    data = sub
  )

  V <- tryCatch(
    clubSandwich::vcovCR(
      fit,
      cluster =
        sub$site_name,
      type = "CR2"
    ),
    error = function(e) {
      NULL
    }
  )

  estimate <- mean_B - mean_A
  robust_SE <- NA_real_
  t_stat <- NA_real_
  df_Satt <- NA_real_
  p_cr2 <- NA_real_

  if (!is.null(V)) {

    ct <- tryCatch(
      clubSandwich::coef_test(
        fit,
        vcov = V,
        test = "Satterthwaite"
      ),
      error = function(e) {
        NULL
      }
    )

    if (
      !is.null(ct) &
        nrow(ct) >= 2
    ) {

      row_contrast <- ct[
        2,
        ,
        drop = FALSE
      ]

      estimate <- extract_first_named(
        row_contrast,
        c(
          "beta",
          "Coef",
          "Estimate"
        )
      )

      robust_SE <- extract_first_named(
        row_contrast,
        c(
          "SE",
          "Std. Error",
          "Std_Error"
        )
      )

      t_stat <- extract_first_named(
        row_contrast,
        c(
          "tstat",
          "t_stat",
          "t value"
        )
      )

      df_Satt <- extract_first_named(
        row_contrast,
        c(
          "df_Satt",
          "df",
          "df_satt"
        )
      )

      p_cr2 <- extract_first_named(
        row_contrast,
        c(
          "p_Satt",
          "p_val",
          "p",
          "p.value"
        )
      )
    }
  }

  max_groups_per_site <- sub %>%
    distinct(
      site_name,
      analysis_group
    ) %>%
    count(
      site_name
    ) %>%
    summarise(
      max_n =
        max(n)
    ) %>%
    pull(
      max_n
    )

  perm_valid <-
    max_groups_per_site == 1

  p_perm <- if (
    perm_valid
  ) {

    permutation_pairwise_p(
      sub,
      group_A = group_A,
      group_B = group_B,
      n_perm = N_PERM,
      seed = seed
    )

  } else {

    NA_real_
  }

  cliff <- if (
    calculate_cliff
  ) {

    cliffs_delta_B_vs_A(
      sub,
      group_A,
      group_B
    )

  } else {

    NA_real_
  }

  tibble(
    group_A = group_A,
    group_B = group_B,

    n_A = n_A,
    n_B = n_B,

    mean_A = mean_A,
    mean_B = mean_B,

    median_A = median_A,
    median_B = median_B,

    estimate_B_minus_A =
      estimate,

    robust_SE =
      robust_SE,

    t_stat =
      t_stat,

    df_Satt =
      df_Satt,

    CR2_p =
      p_cr2,

    permutation_p =
      p_perm,

    permutation_valid =
      perm_valid,

    cliffs_delta_B_vs_A =
      cliff
  )
}


# ------------------------------------------------------------------------------
# 15. ANALYSE ONE TASK
# ------------------------------------------------------------------------------

analyse_task <- function(
  raw_task_data,
  task_name
) {

  cat(
    "\n============================================================\n"
  )

  cat(
    "TASK:",
    task_name,
    "\n"
  )

  cat(
    "============================================================\n"
  )

  site_group <- aggregate_site_group(
    raw_task_data
  )

  # Record sites that still occur in >1 group.
  multi_group_sites <- site_group %>%
    distinct(
      site_name,
      analysis_group
    ) %>%
    count(
      site_name,
      name =
        "n_analysis_groups"
    ) %>%
    filter(
      n_analysis_groups > 1
    )

  if (
    nrow(
      multi_group_sites
    ) > 0
  ) {

    write_csv(
      multi_group_sites,
      file.path(
        OUT_DIR,
        paste0(
          "AUDIT_multi_group_sites_",
          task_name,
          ".csv"
        )
      )
    )
  }

  # Sample size per analysis group.
  group_sizes <- site_group %>%
    distinct(
      representation,
      site_name,
      analysis_group
    ) %>%
    count(
      representation,
      analysis_group,
      name =
        "n_site_group_observations"
    ) %>%
    mutate(
      task = task_name,
      .before = 1
    )

  # ------------------------------------------------------------
  # Two outcome definitions:
  # 1) abundance / relative representation
  # 2) presence
  # ------------------------------------------------------------

  outcomes <- list(

    abundance =
      site_group %>%
      mutate(
        outcome = value
      ),

    presence =
      site_group %>%
      mutate(
        outcome =
          as.numeric(
            value > 0
          )
      )
  )

  desc_parts <- list()
  omnibus_parts <- list()
  pairwise_parts <- list()

  desc_i <- 1L
  omni_i <- 1L
  pair_i <- 1L

  for (
    measure_name in names(
      outcomes
    )
  ) {

    dat_measure <- outcomes[[measure_name]]

    # ------------------------------------------
    # Descriptive table.
    # ------------------------------------------

    desc_parts[[desc_i]] <-
      descriptive_summary(
        dat_measure,
        measure_name
      ) %>%
      mutate(
        task = task_name,
        .before = 1
      )

    desc_i <- desc_i + 1L


    # ------------------------------------------
    # Omnibus tests.
    # ------------------------------------------

    split_bones <- dat_measure %>%
      group_by(
        representation,
        bone
      ) %>%
      group_split(
        .keep = TRUE
      )

    omnibus_here <- map2_dfr(
      split_bones,
      seq_along(
        split_bones
      ),
      function(dd, bone_index) {

        robust_omnibus_one_bone(
          dd,
          seed =
            SEED +
            bone_index *
            100L +
            match(
              measure_name,
              names(
                outcomes
              )
            )
        ) %>%
          mutate(
            task =
              task_name,

            measure =
              measure_name,

            representation =
              first(
                dd$representation
              ),

            bone =
              first(
                dd$bone
              ),

            .before = 1
          )
      }
    )

    omnibus_parts[[omni_i]] <-
      omnibus_here

    omni_i <- omni_i + 1L


    # ------------------------------------------
    # Pairwise tests.
    # ------------------------------------------

    groups_present <- dat_measure %>%
      distinct(
        analysis_group
      ) %>%
      filter(
        !is.na(
          analysis_group
        )
      ) %>%
      pull(
        analysis_group
      ) %>%
      as.character()

    # Preserve factor ordering.
    groups_present <- levels(
      droplevels(
        factor(
          dat_measure$analysis_group
        )
      )
    )

    if (
      length(
        groups_present
      ) >= 2
    ) {

      pairs <- combn(
        groups_present,
        2,
        simplify = FALSE
      )

      pairwise_here <- map_dfr(
        seq_along(
          pairs
        ),
        function(pair_index) {

          pair_now <- pairs[[pair_index]]

          A <- pair_now[[1]]
          B <- pair_now[[2]]

          map_dfr(
            split_bones,
            function(dd) {

              robust_pairwise_one_bone(
                dd,
                group_A = A,
                group_B = B,

                seed =
                  SEED +
                  100000L +
                  pair_index *
                  1000L,

                calculate_cliff =
                  measure_name ==
                  "abundance"
              ) %>%
                mutate(
                  task =
                    task_name,

                  measure =
                    measure_name,

                  representation =
                    first(
                      dd$representation
                    ),

                  bone =
                    first(
                      dd$bone
                    ),

                  contrast =
                    paste0(
                      B,
                      " - ",
                      A
                    ),

                  .before = 1
                )
            }
          )
        }
      )

      pairwise_parts[[pair_i]] <-
        pairwise_here

      pair_i <- pair_i + 1L
    }
  }

  list(
    group_sizes =
      group_sizes,

    descriptive =
      bind_rows(
        desc_parts
      ),

    omnibus =
      bind_rows(
        omnibus_parts
      ),

    pairwise =
      bind_rows(
        pairwise_parts
      )
  )
}


# ------------------------------------------------------------------------------
# 16. RUN ALL TASKS
# ------------------------------------------------------------------------------

results <- imap(
  task_list,
  analyse_task
)

all_group_sizes <- map_dfr(
  results,
  "group_sizes"
)

all_descriptive <- map_dfr(
  results,
  "descriptive"
)

all_omnibus <- map_dfr(
  results,
  "omnibus"
)

all_pairwise <- map_dfr(
  results,
  "pairwise"
)


# ------------------------------------------------------------------------------
# 17. FDR CORRECTION
# ------------------------------------------------------------------------------

# Omnibus FDR across bones within each task x representation x outcome.
all_omnibus <- all_omnibus %>%
  group_by(
    task,
    representation,
    measure
  ) %>%
  mutate(
    CR2_q_BH =
      p.adjust(
        CR2_p,
        method = "BH"
      ),

    permutation_q_BH =
      p.adjust(
        permutation_p,
        method = "BH"
      )
  ) %>%
  ungroup() %>%
  mutate(
    significant_CR2_q05 =
      !is.na(
        CR2_q_BH
      ) &
      CR2_q_BH <
      FDR_ALPHA,

    significant_permutation_q05 =
      !is.na(
        permutation_q_BH
      ) &
      permutation_q_BH <
      FDR_ALPHA
  )


# Pairwise FDR:
# 1) within each named contrast across bones
# 2) across every pairwise bone test in the task/representation/measure
all_pairwise <- all_pairwise %>%
  group_by(
    task,
    representation,
    measure,
    contrast
  ) %>%
  mutate(
    CR2_q_BH_within_contrast =
      p.adjust(
        CR2_p,
        method = "BH"
      ),

    permutation_q_BH_within_contrast =
      p.adjust(
        permutation_p,
        method = "BH"
      )
  ) %>%
  ungroup() %>%
  group_by(
    task,
    representation,
    measure
  ) %>%
  mutate(
    CR2_q_BH_all_pairwise =
      p.adjust(
        CR2_p,
        method = "BH"
      ),

    permutation_q_BH_all_pairwise =
      p.adjust(
        permutation_p,
        method = "BH"
      )
  ) %>%
  ungroup() %>%
  mutate(
    higher_group = case_when(
      estimate_B_minus_A > 0 ~
        group_B,

      estimate_B_minus_A < 0 ~
        group_A,

      TRUE ~
        "equal"
    ),

    significant_CR2_q05 =
      !is.na(
        CR2_q_BH_within_contrast
      ) &
      CR2_q_BH_within_contrast <
      FDR_ALPHA,

    significant_permutation_q05 =
      !is.na(
        permutation_q_BH_within_contrast
      ) &
      permutation_q_BH_within_contrast <
      FDR_ALPHA
  )


# ------------------------------------------------------------------------------
# 18. DIRECT "WHICH GROUP HAS MOST OF WHICH BONE?" TABLE
# ------------------------------------------------------------------------------

max_group_summary <- all_descriptive %>%
  group_by(
    task,
    representation,
    measure,
    bone
  ) %>%
  arrange(
    desc(mean),
    .by_group = TRUE
  ) %>%
  slice_head(
    n = 1
  ) %>%
  ungroup() %>%
  transmute(
    task,
    representation,
    measure,
    bone,

    group_with_highest_mean =
      as.character(
        analysis_group
      ),

    highest_mean =
      mean,

    median_in_that_group =
      median,

    n_unique_sites =
      n_unique_sites
  )


# ------------------------------------------------------------------------------
# 19. SIGNIFICANT RESULT SHORTLISTS
# ------------------------------------------------------------------------------

significant_omnibus <- all_omnibus %>%
  filter(
    significant_CR2_q05
  ) %>%
  arrange(
    task,
    representation,
    measure,
    CR2_q_BH
  )


significant_pairwise <- all_pairwise %>%
  filter(
    significant_CR2_q05
  ) %>%
  arrange(
    task,
    representation,
    measure,
    contrast,
    CR2_q_BH_within_contrast,
    desc(
      abs(
        estimate_B_minus_A
      )
    )
  )


# Strongest directional bone differences for manuscript inspection.
top_pairwise <- all_pairwise %>%
  group_by(
    task,
    representation,
    measure,
    contrast
  ) %>%
  arrange(
    CR2_q_BH_within_contrast,
    desc(
      abs(
        estimate_B_minus_A
      )
    ),
    .by_group = TRUE
  ) %>%
  slice_head(
    n = 10
  ) %>%
  ungroup()


# ------------------------------------------------------------------------------
# 19B. INTERPRETATION-READY DIRECTIONAL TABLES
# ------------------------------------------------------------------------------

# Direct answer to:
# "Which skeletal parts are more represented in which group?"
#
# Only CR2/FDR-significant pairwise differences are retained.
# Pairwise estimate = mean(group_B) - mean(group_A).
# Positive estimate -> higher in group_B.
# Negative estimate -> higher in group_A.
#
# For presence, +0.20 means approximately 20 percentage points higher
# occurrence in group_B.

interpretation_ready <- significant_pairwise %>%
  transmute(
    task,
    representation,
    measure,
    bone,
    contrast,
    group_A,
    group_B,
    higher_group,
    mean_A,
    mean_B,
    median_A,
    median_B,
    difference_B_minus_A = estimate_B_minus_A,
    cliffs_delta_B_vs_A,
    CR2_p,
    CR2_q_BH_within_contrast,
    permutation_p,
    permutation_q_BH_within_contrast
  ) %>%
  arrange(
    task,
    representation,
    measure,
    contrast,
    CR2_q_BH_within_contrast,
    desc(abs(difference_B_minus_A))
  )

interpretation_abundance_only <- interpretation_ready %>%
  filter(
    measure == "abundance"
  )

interpretation_presence_only <- interpretation_ready %>%
  filter(
    measure == "presence"
  )


# ------------------------------------------------------------------------------
# 20. OUTPUT TABLES
# ------------------------------------------------------------------------------

write_csv(
  all_group_sizes,
  file.path(
    OUT_DIR,
    "02_group_sample_sizes.csv"
  )
)

write_csv(
  all_descriptive,
  file.path(
    OUT_DIR,
    "03_bone_descriptive_by_group.csv"
  )
)

write_csv(
  max_group_summary,
  file.path(
    OUT_DIR,
    "04_WHICH_GROUP_HAS_MOST_OF_EACH_BONE.csv"
  )
)

write_csv(
  all_omnibus,
  file.path(
    OUT_DIR,
    "05_bone_omnibus_CR2_permutation_FDR.csv"
  )
)

write_csv(
  all_pairwise,
  file.path(
    OUT_DIR,
    "06_bone_pairwise_CR2_permutation_effectsize_FDR.csv"
  )
)

write_csv(
  significant_omnibus,
  file.path(
    OUT_DIR,
    "07_SIGNIFICANT_omnibus_q05.csv"
  )
)

write_csv(
  significant_pairwise,
  file.path(
    OUT_DIR,
    "08_SIGNIFICANT_pairwise_q05.csv"
  )
)

write_csv(
  top_pairwise,
  file.path(
    OUT_DIR,
    "09_TOP10_BONES_each_pairwise_contrast.csv"
  )
)


write_csv(
  interpretation_ready,
  file.path(
    OUT_DIR,
    "10_SIGNIFICANT_DIRECTIONAL_BONE_DIFFERENCES.csv"
  )
)

write_csv(
  interpretation_abundance_only,
  file.path(
    OUT_DIR,
    "10A_SIGNIFICANT_ABUNDANCE_DIFFERENCES.csv"
  )
)

write_csv(
  interpretation_presence_only,
  file.path(
    OUT_DIR,
    "10B_SIGNIFICANT_PRESENCE_DIFFERENCES.csv"
  )
)


# ------------------------------------------------------------------------------
# 21. EXTRA AUDITS
# ------------------------------------------------------------------------------

# Counts in supplied C and G assignment file.
CG_counts <- bind_rows(

  assignments %>%
    count(
      C_group,
      C_description,
      name = "n_records"
    ) %>%
    transmute(
      scheme = "C",
      group = C_group,
      description =
        C_description,
      n_records
    ),

  assignments %>%
    count(
      G_group,
      G_description,
      name = "n_records"
    ) %>%
    transmute(
      scheme = "G",
      group = G_group,
      description =
        G_description,
      n_records
    )
) %>%
  arrange(
    scheme,
    group
  )

write_csv(
  CG_counts,
  file.path(
    OUT_DIR,
    "11_CG_assignment_counts.csv"
  )
)


write_csv(
  assignments %>%
    arrange(
      C_group,
      G_group,
      site_name
    ),
  file.path(
    OUT_DIR,
    "11_SITE_C1_C5_G0_G5_ASSIGNMENTS_USED.csv"
  )
)


# Sites occupying more than one C or G group.
multi_C <- assignments %>%
  distinct(
    site_name,
    C_group
  ) %>%
  count(
    site_name,
    name =
      "n_C_groups"
  ) %>%
  filter(
    n_C_groups > 1
  )

multi_G <- assignments %>%
  distinct(
    site_name,
    G_group
  ) %>%
  count(
    site_name,
    name =
      "n_G_groups"
  ) %>%
  filter(
    n_G_groups > 1
  )

write_csv(
  multi_C,
  file.path(
    OUT_DIR,
    "11_sites_in_multiple_C_groups.csv"
  )
)

write_csv(
  multi_G,
  file.path(
    OUT_DIR,
    "11_sites_in_multiple_G_groups.csv"
  )
)


# ------------------------------------------------------------------------------
# 22. METHODS / INTERPRETATION README
# ------------------------------------------------------------------------------

methods_text <- c(

  "SKELETAL-PART GROUP COMPARISON ANALYSIS",

  "",

  "Research aim:",
  paste0(
    "Identify which skeletal parts are more or less represented across ",
    "archaeological classes and C/G groups."
  ),

  "",

  "Analyses:",
  "1. Four-class: Funerary Context / Cannibalism / Carnivore / Geological transport",
  "2. Funerary Context vs Cannibalism",
  "3. F vs NF",
  "4. C1-C5",
  "5. G0-G5",

  "",

  "Representations:",
  "- %MNAU: how strongly each anatomical part is represented.",
  "- ReMNAU: relative anatomical representation/composition.",

  "",

  "Preprocessing:",
  "- No imputation.",
  "- No scaling.",
  "- Absence is expected to be encoded as zero.",
  "- Exact bilateral indeterminate triplets are redistributed before analysis.",
  "- Bilateral left/right values are averaged to one bone-level value.",

  "",

  "Inference:",
  paste0(
    "- Formal tests use CR2 site-clustered robust covariance to account for ",
    "repeated assemblages from the same parent site."
  ),
  paste0(
    "- Multi-group analyses first use an omnibus group test for each bone, ",
    "followed by pairwise contrasts."
  ),
  paste0(
    "- Benjamini-Hochberg FDR correction is applied across bones."
  ),
  paste0(
    "- Where every site has one group label, site-level label permutation ",
    "p-values are also calculated as a nonparametric confirmation."
  ),
  paste0(
    "- Naive permutations are not used for C/G tasks when one parent site ",
    "occupies more than one group."
  ),

  "",

  "Direction:",
  paste0(
    "Pairwise estimate = mean(group_B) - mean(group_A). ",
    "Positive values mean greater representation in group_B."
  ),
  paste0(
    "For presence results, +0.20 is approximately a 20-percentage-point ",
    "higher occurrence in group_B."
  ),

  "",

  "Effect size:",
  paste0(
    "Cliff's delta is reported for abundance contrasts. Positive delta means ",
    "group_B tends to have higher values than group_A."
  ),

  "",

  "Important C1-C5 caveat:",
  paste0(
    "C groups were defined using C + Heip, both of which derive from skeletal ",
    "representation. Bone differences among C1-C5 therefore characterize the ",
    "clusters and should not be treated as independent confirmatory evidence ",
    "for the existence of those same clusters."
  ),

  "",

  "Main files:",
  "03_bone_descriptive_by_group.csv",
  "04_WHICH_GROUP_HAS_MOST_OF_EACH_BONE.csv",
  "05_bone_omnibus_CR2_permutation_FDR.csv",
  "06_bone_pairwise_CR2_permutation_effectsize_FDR.csv",
  "07_SIGNIFICANT_omnibus_q05.csv",
  "08_SIGNIFICANT_pairwise_q05.csv",
  "09_TOP10_BONES_each_pairwise_contrast.csv",
  "10_SIGNIFICANT_DIRECTIONAL_BONE_DIFFERENCES.csv",
  "10A_SIGNIFICANT_ABUNDANCE_DIFFERENCES.csv",
  "10B_SIGNIFICANT_PRESENCE_DIFFERENCES.csv"
)

writeLines(
  methods_text,
  file.path(
    OUT_DIR,
    "METHODS_AND_INTERPRETATION.txt"
  )
)


# ------------------------------------------------------------------------------
# 23. CONSOLE SUMMARY
# ------------------------------------------------------------------------------

cat(
  "\n============================================================\n"
)

cat(
  "FINISHED\n"
)

cat(
  "============================================================\n"
)

cat(
  "\nC groups supplied:\n"
)

print(
  assignments %>%
    count(
      C_group,
      C_description
    ) %>%
    arrange(
      C_group
    )
)

cat(
  "\nG groups supplied:\n"
)

print(
  assignments %>%
    count(
      G_group,
      G_description
    ) %>%
    arrange(
      G_group
    )
)

cat(
  "\nNumber of FDR-significant omnibus bone tests (CR2 q < 0.05):\n"
)

print(
  significant_omnibus %>%
    count(
      task,
      representation,
      measure
    )
)

cat(
  "\nNumber of FDR-significant pairwise bone tests (CR2 q < 0.05):\n"
)

print(
  significant_pairwise %>%
    count(
      task,
      representation,
      measure
    )
)

cat(
  "\nOutput directory: ",
  OUT_DIR,
  "\n",
  sep = ""
)

cat(
  "\nStart interpretation with:\n",
  "  04_WHICH_GROUP_HAS_MOST_OF_EACH_BONE.csv\n",
  "  07_SIGNIFICANT_omnibus_q05.csv\n",
  "  08_SIGNIFICANT_pairwise_q05.csv\n",
  "  10A_SIGNIFICANT_ABUNDANCE_DIFFERENCES.csv\n",
  "  10B_SIGNIFICANT_PRESENCE_DIFFERENCES.csv\n",
  sep = ""
)
