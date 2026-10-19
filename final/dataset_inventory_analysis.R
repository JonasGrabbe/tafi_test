
# ==============================================================================
# Taphonomic database inventory: SUM vs IND
# Reproduces the inventory tables and main plots from the raw CSV files.
# Requires: tidyverse, scales
# Optional: broom (only for tidy glm output; base fallback is included)
# ==============================================================================

library(tidyverse)
library(scales)

SUM_FILE <- "final/tapho_db_sum.csv"
IND_FILE <- "final/tapho_db_ind.csv"
OUT_DIR <- "inventory_R_outputs"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

sum_df <- readr::read_csv(SUM_FILE, show_col_types = FALSE)
ind_df <- readr::read_csv(IND_FILE, show_col_types = FALSE)

# ------------------------------------------------------------------------------
# 1. Normalization helpers.
# Keep original columns; create *_norm / grouped columns separately.
# ------------------------------------------------------------------------------

norm_taph <- function(x) {
  x0 <- str_trim(x)
  xl <- str_to_lower(x0)
  case_when(
    is.na(x) ~ NA_character_,
    xl %in% c("unknown", "unkown") ~ "Unknown",
    str_detect(xl, "sepul") ~ "Sepulchral caves",
    xl == "funerary context" ~ "Funerary",
    xl == "cannibalism" ~ "Cannibalism",
    str_detect(xl, "carnivore") ~ "Carnivore-related",
    xl == "geological transport" ~ "Geological transport",
    str_detect(xl, "disarticulated") ~ "Disarticulated occupation",
    TRUE ~ x0
  )
}

norm_gender <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) ~ NA_character_,
    xl %in% c("indet", "indert", "indett") ~ "Indeterminate",
    xl %in% c("female", "femal") ~ "Female",
    xl == "male" ~ "Male",
    xl == "mixed" ~ "Mixed",
    TRUE ~ str_trim(x)
  )
}

norm_age <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) ~ NA_character_,
    xl %in% c("adult", "adults", "adult 15yrs +") ~ "Adult",
    xl %in% c("juvenil", "juvenile") ~ "Juvenile",
    xl %in% c("subadult", "subadults") ~ "Subadult",
    xl %in% c("infant", "infantile") ~ "Infant",
    xl == "indet" ~ "Indeterminate",
    xl == "mixed" ~ "Mixed",
    str_detect(xl, "n_juv") ~ "Mixed juvenile/subadult",
    TRUE ~ str_trim(x)
  )
}

norm_discovery <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) ~ NA_character_,
    xl %in% c("formal excavation", "formal excavations", "formal") ~ "Formal excavation",
    xl == "casual" ~ "Casual",
    xl == "quarry" ~ "Quarry",
    str_starts(xl, "quarry; formal excavation") ~ "Quarry + formal excavation",
    TRUE ~ str_trim(x)
  )
}

norm_fun_subtype <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) ~ NA_character_,
    xl == "inhumation single" ~ "Single inhumation",
    str_starts(xl, "inhumation single; inhumation multiple") ~ "Single + multiple",
    xl == "inhumation multiple" ~ "Multiple inhumation",
    xl == "inhumation single; collective burial" ~ "Single + collective",
    str_starts(xl, "collective burial") & str_detect(xl, "secondary") ~ "Collective-secondary",
    str_starts(xl, "collective burial") ~ "Collective burial",
    xl == "cremation" ~ "Cremation",
    xl == "funerary caching" ~ "Funerary caching",
    xl == "possible burial" ~ "Possible burial",
    xl == "no inhumation" ~ "No inhumation",
    str_detect(xl, "carnivore den") ~ "Carnivore den",
    str_detect(xl, "carnivore scavenge") ~ "Carnivore scavenge",
    TRUE ~ str_trim(x)
  )
}

prep_meta <- function(d) {
  d %>%
    mutate(
      taph_group = norm_taph(taphonomic_context),
      gender_norm = norm_gender(gender),
      age_norm = norm_age(age_category),
      discovery_norm = norm_discovery(discovery_context),
      geological_period_norm = str_trim(geological_period),
      geological_period_norm = na_if(geological_period_norm, ""),
      cultural_period_norm = str_trim(cultural_period),
      cultural_period_norm = if_else(
        cultural_period_norm == "Middle Paleolithi",
        "Middle Paleolithic", cultural_period_norm
      ),
      funerary_subtype_norm = norm_fun_subtype(funerary_context),
      date_mid_cal_bp = (as.numeric(start_date_cal_bp) + as.numeric(end_date_cal_bp))/2
    )
}

sum_df <- prep_meta(sum_df)
ind_df <- prep_meta(ind_df)
ind_sub <- ind_df %>% filter(count_type == FALSE)

# ------------------------------------------------------------------------------
# 2. Database sizes and overlaps
# ------------------------------------------------------------------------------

overview <- tibble(
  metric = c(
    "SUM rows", "SUM unique site_name",
    "IND rows", "IND count_type TRUE", "IND count_type FALSE",
    "IND unique site_name", "IND subdivision unique site_name",
    "SUM MNI median", "SUM MNI Q1", "SUM MNI Q3", "SUM MNI maximum"
  ),
  value = c(
    nrow(sum_df), n_distinct(sum_df$site_name),
    nrow(ind_df), sum(ind_df$count_type == TRUE, na.rm=TRUE),
    sum(ind_df$count_type == FALSE, na.rm=TRUE),
    n_distinct(ind_df$site_name), n_distinct(ind_sub$site_name),
    median(sum_df$mni, na.rm=TRUE),
    quantile(sum_df$mni, .25, na.rm=TRUE),
    quantile(sum_df$mni, .75, na.rm=TRUE),
    max(sum_df$mni, na.rm=TRUE)
  )
)
write_csv(overview, file.path(OUT_DIR, "dataset_overview.csv"))

sum_dups <- sum_df %>%
  count(site_name, name="rows") %>%
  filter(rows > 1)
write_csv(sum_dups, file.path(OUT_DIR, "duplicate_SUM_site_names.csv"))

# ------------------------------------------------------------------------------
# 3. Taphonomic group inventory
# ------------------------------------------------------------------------------

taph_inventory <- sum_df %>%
  count(taph_group, name="sum_rows") %>%
  mutate(percent = 100 * sum_rows / sum(sum_rows)) %>%
  arrange(desc(sum_rows))
write_csv(taph_inventory, file.path(OUT_DIR, "taphonomic_group_inventory.csv"))

# SUM vs subdivision composition plot
comp_plot <- bind_rows(
  sum_df %>% count(taph_group) %>% mutate(dataset="SUM", pct=100*n/nrow(sum_df)),
  ind_sub %>% count(taph_group) %>% mutate(dataset="IND subdivisions", pct=100*n/nrow(ind_sub))
)

p <- ggplot(comp_plot, aes(taph_group, pct, fill=dataset)) +
  geom_col(position="dodge") +
  labs(x=NULL, y="Percent of rows",
       title="Taphonomic composition: aggregate vs subdivision datasets") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=35, hjust=1))
ggsave(file.path(OUT_DIR, "sum_vs_ind_taphonomic_composition.png"), p, width=11, height=6.5, dpi=300)

# ------------------------------------------------------------------------------
# 4. MNI distributions
# ------------------------------------------------------------------------------

mni_group <- sum_df %>%
  group_by(taph_group) %>%
  summarise(
    n=sum(!is.na(mni)),
    median_MNI=median(mni, na.rm=TRUE),
    Q1_MNI=quantile(mni,.25,na.rm=TRUE),
    Q3_MNI=quantile(mni,.75,na.rm=TRUE),
    mean_MNI=mean(mni,na.rm=TRUE),
    max_MNI=max(mni,na.rm=TRUE),
    .groups="drop"
  )
write_csv(mni_group, file.path(OUT_DIR, "MNI_by_taphonomic_group.csv"))

p <- ggplot(sum_df, aes(taph_group, mni)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(x=NULL, y="MNI (log scale)", title="MNI distribution by taphonomic group") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=35,hjust=1))
ggsave(file.path(OUT_DIR, "MNI_by_taphonomic_group.png"), p, width=11, height=6.5, dpi=300)

# ------------------------------------------------------------------------------
# 5. Subinventory availability and MNI dependence
# ------------------------------------------------------------------------------

sub_count <- ind_sub %>% count(site_name, name="subinventory_n")

site_inventory <- sum_df %>%
  group_by(site_name) %>%
  summarise(
    taph_group=first(taph_group),
    mni=max(mni,na.rm=TRUE),
    .groups="drop"
  ) %>%
  left_join(sub_count, by="site_name") %>%
  mutate(
    subinventory_n=replace_na(subinventory_n,0L),
    has_subinventory=subinventory_n>0
  )

sub_rate <- site_inventory %>%
  group_by(taph_group) %>%
  summarise(
    sites=n(),
    sites_with_subinventory=sum(has_subinventory),
    subinventory_percent=100*mean(has_subinventory),
    median_MNI=median(mni,na.rm=TRUE),
    max_subrecords=max(subinventory_n),
    .groups="drop"
  )
write_csv(sub_rate, file.path(OUT_DIR, "subinventory_by_taphonomic_group.csv"))

ref_sites <- site_inventory %>%
  mutate(binary_ref = case_when(
    taph_group=="Funerary" ~ "F",
    taph_group %in% c("Cannibalism","Carnivore-related","Geological transport",
                      "Disarticulated occupation") ~ "NF",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(binary_ref))

ft <- table(ref_sites$binary_ref, ref_sites$has_subinventory)
writeLines(capture.output(fisher.test(ft)),
           file.path(OUT_DIR, "F_vs_NF_subinventory_fisher.txt"))

# Size-adjusted logistic model.
# log2(MNI+1): OR corresponds to a one-unit increase in this transform.
sub_glm <- glm(
  has_subinventory ~ I(binary_ref=="F") + log2(mni+1),
  family=binomial(), data=ref_sites
)
glm_tab <- as.data.frame(summary(sub_glm)$coefficients) %>%
  rownames_to_column("term") %>%
  as_tibble() %>%
  rename(coef=Estimate, SE=`Std. Error`, z=`z value`, p=`Pr(>|z|)`) %>%
  mutate(
    OR=exp(coef),
    CI_low=exp(coef-1.96*SE),
    CI_high=exp(coef+1.96*SE)
  )
write_csv(glm_tab, file.path(OUT_DIR, "subinventory_logistic_model.csv"))

p <- ggplot(sub_rate, aes(reorder(taph_group,subinventory_percent),subinventory_percent)) +
  geom_col() + coord_flip() +
  labs(x=NULL,y="Sites with subdivision inventory (%)",
       title="Availability of individual/subinventory records") +
  theme_bw()
ggsave(file.path(OUT_DIR, "subinventory_availability.png"),p,width=9,height=6,dpi=300)

p <- ggplot(filter(site_inventory,subinventory_n>0),
            aes(mni,subinventory_n,shape=taph_group)) +
  geom_point(size=2.5,alpha=.8) +
  geom_abline(slope=1,intercept=0,linetype=2) +
  labs(x="SUM MNI",y="Number of subdivision rows",
       title="Subdivision inventory size versus site MNI") +
  theme_bw()
ggsave(file.path(OUT_DIR, "subrecords_vs_MNI.png"),p,width=9,height=6.5,dpi=300)

# ------------------------------------------------------------------------------
# 6. Funerary subtypes
# ------------------------------------------------------------------------------

fun <- sum_df %>% filter(taph_group=="Funerary")

fun_sub <- fun %>%
  group_by(funerary_subtype_norm) %>%
  summarise(
    rows=n(),
    median_MNI=median(mni,na.rm=TRUE),
    Q1_MNI=quantile(mni,.25,na.rm=TRUE),
    Q3_MNI=quantile(mni,.75,na.rm=TRUE),
    max_MNI=max(mni,na.rm=TRUE),
    .groups="drop"
  ) %>%
  mutate(percent_F=100*rows/nrow(fun))
write_csv(fun_sub,file.path(OUT_DIR,"funerary_subtype_inventory.csv"))

p <- ggplot(fun, aes(fct_infreq(funerary_subtype_norm))) +
  geom_bar() +
  labs(x=NULL,y="SUM rows",title="Funerary-context subtype inventory") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=40,hjust=1))
ggsave(file.path(OUT_DIR,"funerary_subtype_counts.png"),p,width=10,height=6,dpi=300)

p <- ggplot(fun, aes(funerary_subtype_norm,mni)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(x=NULL,y="MNI (log scale)",title="MNI by funerary subtype") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=40,hjust=1))
ggsave(file.path(OUT_DIR,"MNI_by_funerary_subtype.png"),p,width=11,height=6.5,dpi=300)

# ------------------------------------------------------------------------------
# 7. Gender and age metadata
# ------------------------------------------------------------------------------

gender_compare <- bind_rows(
  sum_df %>% count(gender_norm) %>% mutate(dataset="SUM",pct=100*n/sum(n)),
  ind_sub %>% count(gender_norm) %>% mutate(dataset="IND subdivisions",pct=100*n/sum(n))
)
write_csv(gender_compare,file.path(OUT_DIR,"gender_SUM_vs_IND.csv"))

p <- ggplot(gender_compare,aes(gender_norm,pct,fill=dataset)) +
  geom_col(position="dodge") +
  labs(x=NULL,y="Percent of records",title="Gender metadata: SUM vs subdivision records") +
  theme_bw()
ggsave(file.path(OUT_DIR,"gender_SUM_vs_IND.png"),p,width=9,height=6,dpi=300)

age_compare <- bind_rows(
  sum_df %>% count(age_norm) %>% mutate(dataset="SUM",pct=100*n/sum(n)),
  ind_sub %>% count(age_norm) %>% mutate(dataset="IND subdivisions",pct=100*n/sum(n))
)
write_csv(age_compare,file.path(OUT_DIR,"age_SUM_vs_IND.csv"))

p <- ggplot(age_compare,aes(age_norm,pct,fill=dataset)) +
  geom_col(position="dodge") +
  labs(x=NULL,y="Percent of records",title="Age metadata: SUM vs subdivision records") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=35,hjust=1))
ggsave(file.path(OUT_DIR,"age_SUM_vs_IND.png"),p,width=10,height=6,dpi=300)

# ------------------------------------------------------------------------------
# 8. Chronology and taxonomic/geographic composition
# ------------------------------------------------------------------------------

p <- ggplot(sum_df,aes(geological_period_norm,fill=taph_group)) +
  geom_bar() +
  labs(x=NULL,y="SUM rows",title="Geological-period composition by taphonomic group") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=30,hjust=1))
ggsave(file.path(OUT_DIR,"geological_period_by_group.png"),p,width=11,height=6.5,dpi=300)

p <- ggplot(filter(sum_df,!is.na(date_mid_cal_bp),date_mid_cal_bp>0),
            aes(taph_group,date_mid_cal_bp)) +
  geom_boxplot() +
  scale_y_log10(labels=comma) +
  labs(x=NULL,y="Midpoint age (cal BP; log scale)",
       title="Chronological distribution by taphonomic group") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=35,hjust=1))
ggsave(file.path(OUT_DIR,"chronology_midpoint_by_group.png"),p,width=11,height=6.5,dpi=300)

species <- sum_df %>%
  mutate(hominin_species_norm = recode(
    hominin_species,
    "Homo sapiens"="H. sapiens",
    "Homo neanderthalensis"="H. neanderthalensis"
  )) %>%
  count(hominin_species_norm,sort=TRUE)
write_csv(species,file.path(OUT_DIR,"hominin_species_counts.csv"))

p <- ggplot(species,aes(reorder(hominin_species_norm,n),n)) +
  geom_col() + coord_flip() +
  labs(x=NULL,y="SUM rows",title="Hominin taxonomic composition") +
  theme_bw()
ggsave(file.path(OUT_DIR,"hominin_species_counts.png"),p,width=9,height=6,dpi=300)


# Cultural period distribution
cultural_order <- c(
  "Lower Paleolithic","Middle Paleolithic","Upper Paleolithic","Mesolithic",
  "Neolithic","Chalcolithic","Bronze Age","Late Bronze Age"
)
p <- sum_df %>%
  filter(!is.na(cultural_period_norm)) %>%
  mutate(cultural_period_norm=factor(cultural_period_norm,levels=cultural_order)) %>%
  ggplot(aes(cultural_period_norm,fill=taph_group)) +
  geom_bar() +
  labs(x=NULL,y="SUM rows",title="Cultural-period composition by taphonomic group") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=30,hjust=1))
ggsave(file.path(OUT_DIR,"cultural_period_by_group.png"),p,width=11,height=6.5,dpi=300)

# Region and country distributions
region_counts <- sum_df %>% count(region,sort=TRUE)
write_csv(region_counts,file.path(OUT_DIR,"region_counts.csv"))
p <- ggplot(region_counts,aes(reorder(region,n),n)) +
  geom_col() + coord_flip() +
  labs(x=NULL,y="SUM rows",title="Geographic-region composition") +
  theme_bw()
ggsave(file.path(OUT_DIR,"region_counts.png"),p,width=9,height=6.5,dpi=300)

country_counts <- sum_df %>% count(country,sort=TRUE)
write_csv(country_counts,file.path(OUT_DIR,"country_counts.csv"))
p <- country_counts %>%
  slice_head(n=15) %>%
  ggplot(aes(reorder(country,n),n)) +
  geom_col() + coord_flip() +
  labs(x=NULL,y="SUM rows",title="Most represented countries / territorial labels") +
  theme_bw()
ggsave(file.path(OUT_DIR,"country_counts_top15.png"),p,width=9,height=6.5,dpi=300)

# Field-population / completeness plot.
# Note: some fields are conditionally applicable, so absence is not always an error.
metadata_fields <- c(
  "layer_name","cultural_period","culture_period_2","start_date_cal_bp","end_date_cal_bp",
  "karstic_system","open_air_site","mni","age_category","gender","funerary_context",
  "discovery_context","degree_of_excavation","hominin_species"
)
metadata_completeness <- map_dfr(metadata_fields,function(v) {
  tibble(
    field=v,
    SUM=100*mean(!is.na(sum_df[[v]])),
    `IND subdivisions`=100*mean(!is.na(ind_sub[[v]]))
  )
}) %>%
  pivot_longer(-field,names_to="dataset",values_to="percent_nonmissing")
write_csv(metadata_completeness,file.path(OUT_DIR,"metadata_completeness.csv"))

p <- ggplot(metadata_completeness,
            aes(field,percent_nonmissing,fill=dataset)) +
  geom_col(position="dodge") +
  labs(x=NULL,y="Non-missing records (%)",title="Metadata field population") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=45,hjust=1))
ggsave(file.path(OUT_DIR,"metadata_completeness.png"),p,width=12,height=6.5,dpi=300)

# ------------------------------------------------------------------------------
# 9. Metadata quality audits
# ------------------------------------------------------------------------------

# Invalid/suspicious MIS values
mis_num <- suppressWarnings(as.numeric(sum_df$mis_stage))
mis_suspicious <- sum_df %>%
  mutate(mis_numeric=mis_num) %>%
  filter(!is.na(mis_numeric),mis_numeric>100) %>%
  select(site_name,mis_stage,geological_period,cultural_period,
         start_date_cal_bp,end_date_cal_bp)
write_csv(mis_suspicious,file.path(OUT_DIR,"MIS_suspicious_values.csv"))

# Chronological range ordering
date_order_issues <- sum_df %>%
  filter(!is.na(start_date_cal_bp),!is.na(end_date_cal_bp),
         start_date_cal_bp < end_date_cal_bp) %>%
  select(site_name,start_date_cal_bp,end_date_cal_bp,
         geological_period,cultural_period)
write_csv(date_order_issues,file.path(OUT_DIR,"date_order_issues.csv"))

# Subdivision rows are not always single individuals.
sub_MNI_gt1 <- ind_sub %>%
  filter(mni>1) %>%
  select(site_name,ind_name,individual_id,mni,age_category,gender,
         taphonomic_context,funerary_context)
write_csv(sub_MNI_gt1,file.path(OUT_DIR,"subdivision_rows_MNI_gt1.csv"))

# ------------------------------------------------------------------------------
# 10. Major skeletal-section presence
# ------------------------------------------------------------------------------

section_vars <- list(
  Cranium=c("ProportionalRep_MNIbased_cranium"),
  Axial=c(
    "ProportionalRep_MNIbased_hyoid","ProportionalRep_MNIbased_vertebrae",
    "ProportionalRep_MNIbased_thorax_indet","ProportionalRep_MNIbased_sternum",
    "ProportionalRep_MNIbased_ribs"),
  `Shoulder girdle`=c(
    "ProportionalRep_MNIbased_shoulder_indet",
    "ProportionalRep_MNIbased_clavicle_indet",
    "ProportionalRep_MNIbased_clavicle_right",
    "ProportionalRep_MNIbased_clavicle_left",
    "ProportionalRep_MNIbased_scapula_indet",
    "ProportionalRep_MNIbased_scapula_right",
    "ProportionalRep_MNIbased_scapula_left"),
  `Upper arm`=c(
    "ProportionalRep_MNIbased_arms_indet",
    "ProportionalRep_MNIbased_humerus_indet",
    "ProportionalRep_MNIbased_humerus_right",
    "ProportionalRep_MNIbased_humerus_left"),
  Forearm=c(
    "ProportionalRep_MNIbased_radius_indet",
    "ProportionalRep_MNIbased_radius_right",
    "ProportionalRep_MNIbased_radius_left",
    "ProportionalRep_MNIbased_ulna_indet",
    "ProportionalRep_MNIbased_ulna_right",
    "ProportionalRep_MNIbased_ulna_left"),
  Hands=c("ProportionalRep_MNIbased_hands"),
  `Pelvis/legs`=c("ProportionalRep_MNIbased_pelvic","ProportionalRep_MNIbased_legs"),
  Feet=c("ProportionalRep_MNIbased_foot")
)

section_presence <- map_dfr(names(section_vars),function(sec) {
  vars <- intersect(section_vars[[sec]],names(sum_df))
  present <- sum_df %>%
    select(all_of(vars)) %>%
    mutate(across(everything(),~replace_na(as.numeric(.x),0))) %>%
    transmute(present=if_any(everything(),~.x>0)) %>%
    pull(present)
  tibble(taph_group=sum_df$taph_group,section=sec,present=present)
}) %>%
  group_by(taph_group,section) %>%
  summarise(percent_present=100*mean(present),.groups="drop")

write_csv(section_presence,file.path(OUT_DIR,"skeletal_section_presence.csv"))

p <- ggplot(section_presence,aes(section,taph_group,fill=percent_present)) +
  geom_tile() +
  geom_text(aes(label=round(percent_present)),size=3) +
  labs(x=NULL,y=NULL,fill="% present",
       title="Major skeletal-section presence by taphonomic group") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=35,hjust=1))
ggsave(file.path(OUT_DIR,"skeletal_section_presence.png"),p,width=10,height=6.5,dpi=300)

message("Inventory complete. Outputs written to: ", OUT_DIR)
