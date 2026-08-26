source("mulitilevel_tapho_db.R")

system.time({
  tb <- build_multilevel_tapho_features(
    excel_path = "hspa.xlsx",
    position_max = c(5, 1, 1, 3, 4, 3, 3, 5, 4, 3, 5),
    levels = 1:5
  )
})

source("rfe_randomforest_taphonomy.R")
source("pca_funerary_surface_color.R")

focus_sites <- c(
  "Kleine Feldhofer Grotte", "Bilzingsleben", "Weimar-Ehringsdorf",
  "Scladina Cave", "Engis / Schmerling Cave", "Trou de la Naulette",
  "Bolomor Cave", "Cova de les Malladetes (Barx, Valencia, Spain)",
  "Cova del Parpalló (Parpalló Cave)", "Saint-Césaire",
  "Steinheim an der Murr", "Ochoz 1, Ochoz 2", "Peștera Muierii",
  "Sima de los Huesos 89",
  "Sima de los Huesos 90",
  "Sima de los Huesos 95",
  "Sima de los Huesos 16",
  "Sima de los Huesos 26"
)

res <- run_rfe(
  tb,
  task_name = "fc_vs_rest",
  unknown_sites = focus_sites,
  group_col = "site_id",
  use_smote = TRUE,
  over_ratio = 1
)

res$unknown_all_features$table
res$unknown_all_features$mean_acc
res$fold_assignment
