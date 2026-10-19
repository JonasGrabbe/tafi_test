source("tapho_loader_new.R")

library(readxl)

level_test <- c(
  1, 1, 1, 3, 1, 3, 2, 5, 4, 3, 2
)

sjapl <- read_excel(
  dataset_path,
  sheet = "San Juan ante Portam Latinam "
)

meta <- meta_set(FALSE)

for (j in 2:ncol(sjapl)) {

  specimen_name <- names(sjapl)[j]

  cat(
    "\n----------------------------------------\n",
    "Testing specimen: ", specimen_name, "\n",
    sep = ""
  )

  tryCatch(

    {

      tapho.load(
        data = sjapl[, c(1, j)],
        target_levels = level_test,
        indet = FALSE,
        indet_method = "dist",
        fragments_per_bone = 3,
        meta = meta
      )

      cat("PASS\n")
    },

    error = function(e) {

      cat(
        "\nFAILED SPECIMEN: ",
        specimen_name,
        "\n\n",
        conditionMessage(e),
        "\n",
        sep = ""
      )

      stop(e)
    }
  )
}