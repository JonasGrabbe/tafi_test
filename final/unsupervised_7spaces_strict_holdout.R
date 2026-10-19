
# ==============================================================================
# Unsupervised SPR analysis: 7 feature spaces
# Strict reference clustering + Unknown and labelled-test projection
#
# Inputs:
#   sum_data_indet_adjusted_analysis_data.csv
#
# Required packages:
#   tidyverse, cluster, vegan, ggrepel
#
# IMPORTANT:
# - K-means is fit WITHOUT labels.
# - Archaeological labels are used only AFTER clustering for interpretation/tests.
# - Previously designated labelled challenge/test sites are excluded from fitting.
# - Unknown/Unkown rows are projection only.
# - Median imputation and z-standardization are estimated on the fit sample only.
# - For >2-dimensional spaces, clustering uses the FULL standardized matrix;
#   PCA is visualization only.
# - 95% ellipses below are CONFIDENCE ellipses for cluster centroids, not 95%
#   coverage ellipses for observations.
# ==============================================================================

library(tidyverse)
library(cluster)
library(vegan)
library(ggrepel)

set.seed(42)

INPUT_FILE <- "sum_data_indet_adjusted_analysis_data.csv"
OUT_DIR <- "unsupervised_R_outputs"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

d <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

# ------------------------------------------------------------------------------
# 1. Labels and strict holdout definition
# ------------------------------------------------------------------------------

class4 <- function(x) {
  case_when(
    x == "Funerary Context" ~ "Funerary",
    x == "Cannibalism" ~ "Cannibalism",
    x %in% c("Carnivore",
             "Carnivore Scavenge (in situ)",
             "Carnivore den(transport)") ~ "Carnivore-related",
    x == "Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

norm_fun_subtype <- function(x) {
  xl <- str_to_lower(str_trim(x))
  case_when(
    is.na(x) ~ "Missing",
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
    TRUE ~ str_trim(x)
  )
}

historical <- c(
  "La Chapelle-aux-Saints","La Ferrassie","Regourdou","Roc de Marsal",
  "Shanidar Cave","Krapina","La Quina","Moula-Guercy","Grotta Guattari",
  "Mladeč Caves","Cro-Magnon I","Brno II","Teshik-Tash Cave",
  "Cueva de los Torrejones","Crow Creek","Goat’s Hole (Paviland Cave)"
)

early <- c(
  "El Sidrón J1","Mancos 5MT-10010 Feature 3","Yellow Jacket 5MT-3",
  "Qafzeh Cave","Tabun Cave (Mugharet et-Tabun)","Mugharet es-Skhul",
  "Grotte de Fontbrégoua","Cova Gran de Santa Linya","Sima de las Palomas",
  "Kebara Cave","La Ferrassie"
)

test_names <- union(historical, early)

d <- d %>%
  mutate(
    class4 = class4(taphonomic_context),
    binary_label = case_when(
      class4 == "Funerary" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    ),
    funerary_subtype_norm = norm_fun_subtype(funerary_context)
  )

eligible <- d %>% filter(!is.na(class4))
fit <- eligible %>% filter(!site_name %in% test_names)
test <- eligible %>%
  filter(site_name %in% test_names) %>%
  mutate(
    test_panel = case_when(
      site_name %in% historical & site_name %in% early ~ "Both panels",
      site_name %in% historical ~ "Historical challenge",
      site_name %in% early ~ "Early-human holdout"
    )
  )
unknown <- d %>% filter(taphonomic_context %in% c("Unknown","Unkown"))

partition <- tibble(
  dataset = c("Eligible known (all)","Unsupervised fit",
              "Held-out labelled test","Unknown projection"),
  rows = c(nrow(eligible),nrow(fit),nrow(test),nrow(unknown)),
  unique_sites = c(n_distinct(eligible$site_name),n_distinct(fit$site_name),
                   n_distinct(test$site_name),n_distinct(unknown$site_name))
)
write_csv(partition,file.path(OUT_DIR,"sample_partition.csv"))

# ------------------------------------------------------------------------------
# 2. Feature spaces
# ------------------------------------------------------------------------------

prop_cols <- names(d)[str_starts(names(d),"ProportionalRep_MNIbased_")]
prop_cols <- setdiff(prop_cols,c(
  "ProportionalRep_MNIbased_clavicle_indet",
  "ProportionalRep_MNIbased_scapula_indet",
  "ProportionalRep_MNIbased_humerus_indet",
  "ProportionalRep_MNIbased_radius_indet",
  "ProportionalRep_MNIbased_ulna_indet"
))

rem_cols <- names(d)[str_starts(names(d),"ReMNAU_adjusted_")]

eng_cols <- c(
  "mnau_proximal_appendicular_mean","mnau_lower_appendicular_mean",
  "mnau_distal_appendicular_mean","mnau_appendicular_mean",
  "mnau_postcranial_total_mean","mnau_top2_share_mcnaughton",
  "mnau_upper_appendicular_mean","low_density_survival_index",
  "mnau_vertebrae_to_thorax_ratio","all_sections_dominance",
  "mnau_lower_upper_appendicular_diff","mnau_heip_evenness",
  "mnau_girdle_appendicular_logratio","postcranial_continuity_hm",
  "mnau_girdle_to_appendicular_ratio","mnau_gini",
  "density_representation_r2","mnau_cv","mnau_girdle_appendicular_diff",
  "mnau_full_axial_mean","mnau_arms","dominance_gap_all",
  "mnau_girdle_share_of_appendicular","section_completeness_025_all",
  "whole_body_continuity_hm","density_representation_slope",
  "mnau_limb_shaft_proxy_mean","density_residual_sd"
)
eng_cols <- intersect(eng_cols,names(d))

informative <- function(data, vars) {
  vars[vapply(vars,function(v) {
    z <- data[[v]]
    sum(!is.na(z)) > 1 && n_distinct(z,na.rm=TRUE) > 1
  },logical(1))]
}

prop_cols <- informative(fit,prop_cols)
rem_cols <- informative(fit,rem_cols)
eng_cols <- informative(fit,eng_cols)

feature_sets <- list(
  `C only` = c("C_adjusted"),
  `Evenness only` = c("Evenness_adjusted"),
  `C + evenness` = c("C_adjusted","Evenness_adjusted"),
  `%MNAU` = prop_cols,
  ReMNAU = rem_cols,
  Engineered = eng_cols,
  Combined = c(prop_cols,rem_cols,eng_cols)
)

# ------------------------------------------------------------------------------
# 3. Preprocessing helpers
# ------------------------------------------------------------------------------

fit_preprocess <- function(train,newdata,vars) {
  med <- map_dbl(vars,~median(train[[.x]],na.rm=TRUE))
  names(med) <- vars

  impute_matrix <- function(dat) {
    x <- as.data.frame(dat[,vars,drop=FALSE])
    for(v in vars) x[[v]][is.na(x[[v]])] <- med[[v]]
    as.matrix(x)
  }

  xtr0 <- impute_matrix(train)
  mu <- colMeans(xtr0)
  sdv <- apply(xtr0,2,sd)
  sdv[sdv==0 | is.na(sdv)] <- 1

  standardize <- function(x) sweep(sweep(x,2,mu,"-"),2,sdv,"/")

  list(
    X_train = standardize(xtr0),
    X_new = standardize(impute_matrix(newdata)),
    X_train_original = xtr0,
    X_new_original = impute_matrix(newdata),
    medians=med,means=mu,sds=sdv
  )
}

elbow_distance <- function(k,inertia) {
  xn <- (k-min(k))/(max(k)-min(k))
  yn <- (inertia-min(inertia))/(max(inertia)-min(inertia))
  p1 <- c(xn[1],yn[1]); p2 <- c(xn[length(xn)],yn[length(yn)])
  line <- p2-p1
  distance <- map_dbl(seq_along(xn),function(i) {
    p <- c(xn[i],yn[i])
    abs(line[1]*(p[2]-p1[2])-line[2]*(p[1]-p1[1]))/sqrt(sum(line^2))
  })
  inner <- 2:(length(k)-1)
  k[inner[which.max(distance[inner])]]
}

# ------------------------------------------------------------------------------
# 4. Statistical helpers
# ------------------------------------------------------------------------------

choose2 <- function(n) n*(n-1)/2

ARI <- function(a,b) {
  tab <- table(a,b)
  sum_comb <- sum(choose2(tab))
  row_comb <- sum(choose2(rowSums(tab)))
  col_comb <- sum(choose2(colSums(tab)))
  total_comb <- choose2(sum(tab))
  expected <- row_comb*col_comb/total_comb
  max_index <- .5*(row_comb+col_comb)
  if(max_index==expected) return(0)
  (sum_comb-expected)/(max_index-expected)
}

NMI <- function(a,b) {
  tab <- table(a,b)
  pxy <- tab/sum(tab)
  px <- rowSums(pxy); py <- colSums(pxy)
  nz <- which(pxy>0,arr.ind=TRUE)
  mi <- sum(pxy[nz]*log(pxy[nz]/(px[nz[,1]]*py[nz[,2]])))
  hx <- -sum(px[px>0]*log(px[px>0]))
  hy <- -sum(py[py>0]*log(py[py>0]))
  if(hx==0 || hy==0) return(0)
  mi/sqrt(hx*hy)
}

purity <- function(labels,clusters) {
  tab <- table(clusters,labels)
  sum(apply(tab,1,max))/sum(tab)
}

cramers_v <- function(labels,clusters) {
  tab <- table(clusters,labels)
  tst <- suppressWarnings(chisq.test(tab,correct=FALSE))
  n <- sum(tab)
  v <- sqrt(as.numeric(tst$statistic)/n/min(nrow(tab)-1,ncol(tab)-1))
  c(V=v,p=tst$p.value)
}

ari_perm <- function(labels,clusters,B=1999,seed=1) {
  set.seed(seed)
  obs <- ARI(labels,clusters)
  null <- replicate(B,ARI(sample(labels),clusters))
  c(ARI=obs,p=(1+sum(null>=obs))/(B+1))
}

cliffs_delta <- function(x,y) {
  # equivalent to P(X>Y)-P(X<Y)
  mean(outer(x,y,">")) - mean(outer(x,y,"<"))
}

distance_percentile <- function(reference,x) {
  100*mean(reference<=x)
}

# 95% CONFIDENCE ellipse for a 2D centroid
ellipse_ci <- function(x,y,level=.95,n=200) {
  xy <- cbind(x,y)
  xy <- xy[complete.cases(xy),,drop=FALSE]
  if(nrow(xy)<3) return(NULL)
  mu <- colMeans(xy)
  S <- cov(xy)/nrow(xy)
  ev <- eigen(S,symmetric=TRUE)
  radii <- sqrt(qchisq(level,df=2)*pmax(ev$values,0))
  theta <- seq(0,2*pi,length.out=n)
  unit <- rbind(cos(theta),sin(theta))
  ell <- t(ev$vectors %*% diag(radii) %*% unit)
  tibble(x=ell[,1]+mu[1],y=ell[,2]+mu[2])
}

# ------------------------------------------------------------------------------
# 5. Storage
# ------------------------------------------------------------------------------

diag_all <- list()
assoc_all <- list()
profile_all <- list()
corr_all <- list()
permanova_all <- list()
fit_all <- list()
unknown_all <- list()
test_all <- list()
bin_tabs <- list()
class_tabs <- list()
fun_tabs <- list()

# ------------------------------------------------------------------------------
# 6. Main loop
# ------------------------------------------------------------------------------

for(space in names(feature_sets)) {

  vars <- feature_sets[[space]]
  tr <- fit_preprocess(fit,fit,vars)
  Xu <- fit_preprocess(fit,unknown,vars)$X_new
  Xt <- fit_preprocess(fit,test,vars)$X_new
  X <- tr$X_train
  p <- ncol(X)

  # ---- Elbow + silhouette ----
  kvals <- 1:min(8,nrow(X)-1)
  inertia <- map_dbl(kvals,function(k) {
    kmeans(X,centers=k,nstart=100,iter.max=100)$tot.withinss
  })

  silhouettes <- rep(NA_real_,length(kvals))
  for(i in seq_along(kvals)) {
    k <- kvals[i]
    if(k>=2) {
      km0 <- kmeans(X,centers=k,nstart=100,iter.max=100)
      silhouettes[i] <- mean(cluster::silhouette(km0$cluster,dist(X))[,3])
    }
  }

  elbow_k <- elbow_distance(kvals,inertia)
  sil_k <- kvals[which.max(replace_na(silhouettes,-Inf))]
  max_sil <- max(silhouettes,na.rm=TRUE)
  sil_at_elbow <- silhouettes[match(elbow_k,kvals)]

  if(elbow_k>=2 && !is.na(sil_at_elbow) && sil_at_elbow>=max_sil-.02) {
    chosen_k <- elbow_k
    rule <- "Elbow; silhouette within 0.02 of max"
  } else {
    chosen_k <- sil_k
    rule <- "Maximum silhouette"
  }

  diag <- tibble(
    Feature_space=space,k=kvals,Inertia=inertia,Silhouette=silhouettes,
    Elbow_k=elbow_k,Silhouette_best_k=sil_k,Chosen_k=chosen_k,Rule=rule
  )
  diag_all[[space]] <- diag

  dp <- diag %>%
    mutate(Relative_inertia=Inertia/first(Inertia)) %>%
    select(k,Relative_inertia,Silhouette) %>%
    pivot_longer(-k,names_to="metric",values_to="value")

  gp <- ggplot(dp,aes(k,value,linetype=metric,shape=metric)) +
    geom_line(na.rm=TRUE) + geom_point(na.rm=TRUE) +
    geom_vline(xintercept=chosen_k,linetype=2) +
    labs(x="k",y="Relative inertia / silhouette",
         title=paste0(space,": elbow and silhouette")) +
    theme_bw()
  ggsave(file.path(OUT_DIR,paste0("k_",make.names(space),".png")),
         gp,width=8.2,height=5.6,dpi=300)

  # ---- Final k-means ----
  set.seed(42)
  km <- kmeans(X,centers=chosen_k,nstart=200,iter.max=100)
  cl <- km$cluster

  # Projection onto fixed centers
  nearest_center <- function(Xnew,centers) {
    apply(Xnew,1,function(z) which.min(rowSums(sweep(centers,2,z,"-")^2)))
  }
  clu <- nearest_center(Xu,km$centers)
  clt <- nearest_center(Xt,km$centers)

  dfit <- sqrt(rowSums((X-km$centers[cl,])^2))
  dunk <- sqrt(rowSums((Xu-km$centers[clu,])^2))
  dtest <- sqrt(rowSums((Xt-km$centers[clt,])^2))

  # ---- PCA: correlations for every space; display only if p>2 ----
  pc <- prcomp(X,center=FALSE,scale.=FALSE)
  Zf <- predict(pc,X)
  Zu <- predict(pc,Xu)
  Zt <- predict(pc,Xt)

  rC <- cor.test(Zf[,1],fit$C_adjusted)
  okE <- complete.cases(Zf[,1],fit$Evenness_adjusted)
  rE <- cor.test(Zf[okE,1],fit$Evenness_adjusted[okE])
  corr_all[[space]] <- tibble(
    Feature_space=space,n_features=p,
    PC1_variance=summary(pc)$importance[2,1],
    PC2_variance=ifelse(p>=2,summary(pc)$importance[2,2],NA_real_),
    r_PC1_C=unname(rC$estimate),p_PC1_C=rC$p.value,
    r_PC1_evenness=unname(rE$estimate),p_PC1_evenness=rE$p.value
  )

  # ---- Cluster profiles ----
  tmp <- fit %>%
    mutate(Cluster=cl,distance=dfit)

  prof <- tmp %>%
    group_by(Cluster) %>%
    summarise(
      n=n(),
      F_percent=100*mean(binary_label=="F"),
      Dominant_class4=names(sort(table(class4),decreasing=TRUE))[1],
      Dominant_class4_percent=100*max(table(class4))/n(),
      Funerary_n=sum(class4=="Funerary"),
      Cannibalism_n=sum(class4=="Cannibalism"),
      Carnivore_n=sum(class4=="Carnivore-related"),
      Geological_transport_n=sum(class4=="Geological transport"),
      Median_C=median(C_adjusted,na.rm=TRUE),
      Median_evenness=median(Evenness_adjusted,na.rm=TRUE),
      Median_distance=median(distance),
      .groups="drop"
    ) %>%
    mutate(Feature_space=space,.before=1)
  profile_all[[space]] <- prof

  # ---- Label association: binary and 4-class ----
  for(level in c("F vs NF","Four-class")) {
    labs <- if(level=="F vs NF") fit$binary_label else fit$class4
    ar <- ari_perm(labs,cl,B=1999,seed=100)
    cv <- cramers_v(labs,cl)
    assoc_all[[paste(space,level)]] <- tibble(
      Feature_space=space,Label_level=level,k=chosen_k,
      ARI=ar["ARI"],ARI_perm_p=ar["p"],
      NMI=NMI(labs,cl),Purity=purity(labs,cl),
      Cramers_V=cv["V"],Chi_square_p=cv["p"]
    )

    # PERMANOVA and dispersion on actual archaeological labels
    dd <- dist(X)
    dat <- tibble(label=factor(labs))
    ad <- vegan::adonis2(dd ~ label,data=dat,permutations=1999)
    bd <- vegan::betadisper(dd,dat$label)
    bp <- vegan::permutest(bd,permutations=999)

    permanova_all[[paste(space,level)]] <- tibble(
      Feature_space=space,Label_level=level,
      Pseudo_F=ad$F[1],R2=ad$R2[1],PERMANOVA_p=ad$`Pr(>F)`[1],
      Dispersion_F=bp$tab$F[1],Dispersion_p=bp$tab$`Pr(>F)`[1]
    )
  }

  bin_tabs[[space]] <- as.data.frame.matrix(table(Cluster=cl,fit$binary_label)) %>%
    rownames_to_column("Cluster") %>% mutate(Feature_space=space)
  class_tabs[[space]] <- as.data.frame.matrix(table(Cluster=cl,fit$class4)) %>%
    rownames_to_column("Cluster") %>% mutate(Feature_space=space)

  # ---- Non-funerary only: Cannibalism/Carnivore/Geological ----
  nf <- fit$class4!="Funerary"
  nflabs <- fit$class4[nf]
  nfcl <- cl[nf]
  ar <- ari_perm(nflabs,nfcl,B=1999,seed=101)
  cv <- cramers_v(nflabs,nfcl)

  ddnf <- dist(X[nf,,drop=FALSE])
  nfd <- tibble(label=factor(nflabs))
  adnf <- vegan::adonis2(ddnf ~ label,data=nfd,permutations=1999)
  bdnf <- vegan::betadisper(ddnf,nfd$label)
  bpnf <- vegan::permutest(bdnf,permutations=999)

  assoc_all[[paste(space,"NF three-class")]] <- tibble(
    Feature_space=space,Label_level="NF three-class",k=chosen_k,
    ARI=ar["ARI"],ARI_perm_p=ar["p"],
    NMI=NMI(nflabs,nfcl),Purity=purity(nflabs,nfcl),
    Cramers_V=cv["V"],Chi_square_p=cv["p"],
    NF_PERMANOVA_F=adnf$F[1],NF_R2=adnf$R2[1],
    NF_PERMANOVA_p=adnf$`Pr(>F)`[1],
    NF_Dispersion_F=bpnf$tab$F[1],NF_Dispersion_p=bpnf$tab$`Pr(>F)`[1]
  )

  # ---- Funerary subtype association ----
  fm <- fit$class4=="Funerary"
  fsub <- fit$funerary_subtype_norm[fm]
  fcl <- cl[fm]
  ar <- ari_perm(fsub,fcl,B=1999,seed=102)
  cv <- suppressWarnings(cramers_v(fsub,fcl))
  assoc_all[[paste(space,"Funerary subtype")]] <- tibble(
    Feature_space=space,Label_level="Funerary subtypes",k=chosen_k,
    ARI=ar["ARI"],ARI_perm_p=ar["p"],
    NMI=NMI(fsub,fcl),Purity=purity(fsub,fcl),
    Cramers_V=cv["V"],Chi_square_p=cv["p"]
  )
  fun_tabs[[space]] <- as.data.frame.matrix(table(Cluster=fcl,fsub)) %>%
    rownames_to_column("Cluster") %>% mutate(Feature_space=space)

  # ---- Projection tables ----
  profile_lookup <- prof %>% select(Cluster,F_percent,Dominant_class4)

  fit_out <- fit %>%
    transmute(
      Feature_space=space,site_name,class4,binary_label,
      funerary_subtype=funerary_subtype_norm,Cluster=cl,
      Distance_to_centroid=dfit,
      PC1=Zf[,1],PC2=if(ncol(Zf)>=2) Zf[,2] else NA_real_
    ) %>%
    left_join(profile_lookup,by="Cluster") %>%
    rename(Cluster_F_percent=F_percent,
           Cluster_dominant_class4=Dominant_class4) %>%
    group_by(Cluster) %>%
    mutate(Distance_percentile_within_cluster=
             100*map_dbl(Distance_to_centroid,~mean(Distance_to_centroid<=.x))) %>%
    ungroup()
  fit_all[[space]] <- fit_out

  unknown_out <- unknown %>%
    transmute(
      Feature_space=space,site_name,Cluster=clu,
      Distance_to_centroid=dunk,
      PC1=Zu[,1],PC2=if(ncol(Zu)>=2) Zu[,2] else NA_real_
    ) %>%
    left_join(profile_lookup,by="Cluster") %>%
    rename(Cluster_F_percent=F_percent,
           Cluster_dominant_class4=Dominant_class4)

  # reference distance percentile by assigned cluster
  unknown_out$Distance_percentile_vs_training_cluster <- map2_dbl(
    unknown_out$Cluster,unknown_out$Distance_to_centroid,
    ~100*mean(dfit[cl==.x]<=.y)
  )
  unknown_all[[space]] <- unknown_out

  test_out <- test %>%
    transmute(
      Feature_space=space,site_name,layer_name,test_panel,
      True_class4=class4,True_binary=binary_label,Cluster=clt,
      Distance_to_centroid=dtest,
      PC1=Zt[,1],PC2=if(ncol(Zt)>=2) Zt[,2] else NA_real_
    ) %>%
    left_join(profile_lookup,by="Cluster") %>%
    rename(Cluster_F_percent=F_percent,
           Cluster_dominant_class4=Dominant_class4) %>%
    mutate(
      Binary_cluster_prediction=if_else(Cluster_F_percent>=50,"F","NF"),
      Binary_match=Binary_cluster_prediction==True_binary,
      Class4_match=Cluster_dominant_class4==True_class4
    )
  test_out$Distance_percentile_vs_training_cluster <- map2_dbl(
    test_out$Cluster,test_out$Distance_to_centroid,
    ~100*mean(dfit[cl==.x]<=.y)
  )
  test_all[[space]] <- test_out

  # --------------------------------------------------------------------------
  # Visualization
  # --------------------------------------------------------------------------

  if(p==1) {
    vf <- tibble(x=tr$X_train_original[,1],
                 y=seq(-.07,.07,length.out=nrow(fit)),
                 Cluster=factor(cl),class4=fit$class4)

    gp <- ggplot(vf,aes(x,y,group=Cluster)) +
      geom_point(aes(shape=class4,fill=Cluster),size=2.4) +
      labs(x=vars[1],y="Jitter (visual only)",
           title=paste0(space,": k-means reference solution, k=",chosen_k)) +
      theme_bw()
  } else if(p==2 && space=="C + evenness") {
    vf <- tibble(x=tr$X_train_original[,1],
                 y=tr$X_train_original[,2],
                 Cluster=factor(cl),class4=fit$class4)
    ell <- map_dfr(sort(unique(cl)),function(z) {
      q <- vf %>% filter(Cluster==z)
      e <- ellipse_ci(q$x,q$y)
      if(is.null(e)) return(tibble())
      mutate(e,Cluster=factor(z))
    })
    gp <- ggplot(vf,aes(x,y)) +
      geom_point(aes(shape=class4,fill=Cluster),size=2.5) +
      geom_path(data=ell,aes(x,y,group=Cluster),inherit.aes=FALSE) +
      labs(x="Mean abundance C",y="Evenness",
           title=paste0(space,": k-means reference solution, k=",chosen_k),
           subtitle="95% confidence ellipses for cluster centroids") +
      theme_bw()
  } else {
    vf <- tibble(x=Zf[,1],y=Zf[,2],
                 Cluster=factor(cl),class4=fit$class4)
    ell <- map_dfr(sort(unique(cl)),function(z) {
      q <- vf %>% filter(Cluster==z)
      e <- ellipse_ci(q$x,q$y)
      if(is.null(e)) return(tibble())
      mutate(e,Cluster=factor(z))
    })
    gp <- ggplot(vf,aes(x,y)) +
      geom_point(aes(shape=class4,fill=Cluster),size=2.5) +
      geom_path(data=ell,aes(x,y,group=Cluster),inherit.aes=FALSE) +
      labs(
        x=paste0("PC1 (",round(100*summary(pc)$importance[2,1],1),"%)"),
        y=paste0("PC2 (",round(100*summary(pc)$importance[2,2],1),"%)"),
        title=paste0(space,": k-means reference solution, k=",chosen_k),
        subtitle="PCA display only; k-means used full standardized feature space"
      ) +
      theme_bw()
  }

  ggsave(file.path(OUT_DIR,paste0("clusters_",make.names(space),".png")),
         gp,width=10.2,height=7.2,dpi=300)

  # Unknown and labelled-test plots for p>=2; use PCA where needed
  if(p==1) {
    uf <- tibble(x=fit_preprocess(fit,unknown,vars)$X_new_original[,1],
                 y=0,site_name=unknown$site_name)
    tf <- tibble(x=fit_preprocess(fit,test,vars)$X_new_original[,1],
                 y=0,site_name=test$site_name,class4=test$class4)
    ref1 <- tibble(x=tr$X_train_original[,1],
                   y=seq(-.05,.05,length.out=nrow(fit)))

    gpu <- ggplot() +
      geom_point(data=ref1,aes(x,y),alpha=.25) +
      geom_point(data=uf,aes(x,y),shape=4,size=2.8) +
      ggrepel::geom_text_repel(data=uf,aes(x,y,label=site_name),size=2.5) +
      labs(x=vars[1],y="Jitter (visual only)",
           title=paste0(space,": Unknown projection")) +
      theme_bw()

    gpt <- ggplot() +
      geom_point(data=ref1,aes(x,y),alpha=.25) +
      geom_point(data=tf,aes(x,y,shape=class4),size=2.8) +
      ggrepel::geom_text_repel(data=tf,aes(x,y,label=site_name),size=2.3) +
      labs(x=vars[1],y="Jitter (visual only)",
           title=paste0(space,": held-out labelled test projection")) +
      theme_bw()
  } else {
    if(p==2 && space=="C + evenness") {
      ref2 <- tibble(x=tr$X_train_original[,1],y=tr$X_train_original[,2],
                     Cluster=factor(cl))
      uorig <- fit_preprocess(fit,unknown,vars)$X_new_original
      torig <- fit_preprocess(fit,test,vars)$X_new_original
      uf <- tibble(x=uorig[,1],y=uorig[,2],site_name=unknown$site_name)
      tf <- tibble(x=torig[,1],y=torig[,2],site_name=test$site_name,class4=test$class4)
      xl <- "Mean abundance C"; yl <- "Evenness"
    } else {
      ref2 <- tibble(x=Zf[,1],y=Zf[,2],Cluster=factor(cl))
      uf <- tibble(x=Zu[,1],y=Zu[,2],site_name=unknown$site_name)
      tf <- tibble(x=Zt[,1],y=Zt[,2],site_name=test$site_name,class4=test$class4)
      xl <- paste0("PC1 (",round(100*summary(pc)$importance[2,1],1),"%)")
      yl <- paste0("PC2 (",round(100*summary(pc)$importance[2,2],1),"%)")
    }

    ell <- map_dfr(sort(unique(cl)),function(z) {
      q <- ref2 %>% filter(Cluster==z)
      e <- ellipse_ci(q$x,q$y)
      if(is.null(e)) return(tibble())
      mutate(e,Cluster=factor(z))
    })

    gpu <- ggplot() +
      geom_point(data=ref2,aes(x,y,fill=Cluster),alpha=.25) +
      geom_path(data=ell,aes(x,y,group=Cluster)) +
      geom_point(data=uf,aes(x,y),shape=4,size=2.8) +
      ggrepel::geom_text_repel(data=uf,aes(x,y,label=site_name),size=2.3) +
      labs(x=xl,y=yl,title=paste0(space,": Unknown projection")) +
      theme_bw()

    gpt <- ggplot() +
      geom_point(data=ref2,aes(x,y,fill=Cluster),alpha=.25) +
      geom_path(data=ell,aes(x,y,group=Cluster)) +
      geom_point(data=tf,aes(x,y,shape=class4),size=2.8) +
      ggrepel::geom_text_repel(data=tf,aes(x,y,label=site_name),size=2.2) +
      labs(x=xl,y=yl,title=paste0(space,": held-out labelled test projection")) +
      theme_bw()
  }

  ggsave(file.path(OUT_DIR,paste0("unknown_",make.names(space),".png")),
         gpu,width=11,height=7.4,dpi=300)
  ggsave(file.path(OUT_DIR,paste0("test_",make.names(space),".png")),
         gpt,width=11.5,height=7.7,dpi=300)
}

# ------------------------------------------------------------------------------
# 7. Consolidate and save
# ------------------------------------------------------------------------------

diagnostics <- bind_rows(diag_all)
associations <- bind_rows(assoc_all)
profiles <- bind_rows(profile_all)
pca_correlations <- bind_rows(corr_all)
permanova_results <- bind_rows(permanova_all)
fit_assignments <- bind_rows(fit_all)
unknown_assignments <- bind_rows(unknown_all)
test_assignments <- bind_rows(test_all)
binary_contingencies <- bind_rows(bin_tabs)
fourclass_contingencies <- bind_rows(class_tabs)
funerary_subtype_contingencies <- bind_rows(fun_tabs)

k_summary <- diagnostics %>%
  group_by(Feature_space) %>%
  summarise(
    Elbow_k=first(Elbow_k),
    Silhouette_best_k=first(Silhouette_best_k),
    Chosen_k=first(Chosen_k),
    Rule=first(Rule),
    Max_silhouette=max(Silhouette,na.rm=TRUE),
    .groups="drop"
  ) %>%
  left_join(pca_correlations,by="Feature_space")

unknown_consensus <- unknown_assignments %>%
  mutate(F_enriched=Cluster_F_percent>=50) %>%
  group_by(site_name) %>%
  summarise(
    Feature_spaces=n_distinct(Feature_space),
    F_enriched_spaces=sum(F_enriched),
    NF_enriched_spaces=Feature_spaces-F_enriched_spaces,
    Median_cluster_F_percent=median(Cluster_F_percent),
    Median_distance_percentile=median(Distance_percentile_vs_training_cluster),
    Max_distance_percentile=max(Distance_percentile_vs_training_cluster),
    .groups="drop"
  )

test_consensus <- test_assignments %>%
  group_by(site_name,layer_name,test_panel,True_class4,True_binary) %>%
  summarise(
    Feature_spaces=n_distinct(Feature_space),
    Binary_matches=sum(Binary_match),
    Class4_matches=sum(Class4_match),
    Median_cluster_F_percent=median(Cluster_F_percent),
    Median_distance_percentile=median(Distance_percentile_vs_training_cluster),
    Max_distance_percentile=max(Distance_percentile_vs_training_cluster),
    .groups="drop"
  )

test_performance <- test_assignments %>%
  group_by(Feature_space) %>%
  summarise(
    n=n(),
    Binary_concordance=mean(Binary_match),
    Fourclass_concordance=mean(Class4_match),
    Median_distance_percentile=median(Distance_percentile_vs_training_cluster),
    .groups="drop"
  )

funerary_descriptives <- fit %>%
  filter(class4=="Funerary") %>%
  group_by(funerary_subtype_norm) %>%
  summarise(
    n=n(),
    Median_C=median(C_adjusted),
    Q1_C=quantile(C_adjusted,.25),
    Q3_C=quantile(C_adjusted,.75),
    Median_evenness=median(Evenness_adjusted,na.rm=TRUE),
    Q1_evenness=quantile(Evenness_adjusted,.25,na.rm=TRUE),
    Q3_evenness=quantile(Evenness_adjusted,.75,na.rm=TRUE),
    .groups="drop"
  )

# Overall Kruskal and pairwise Wilcoxon + Cliff delta for C and E
kw <- map_dfr(c("C_adjusted","Evenness_adjusted"),function(v) {
  tst <- kruskal.test(fit[[v]] ~ fit$class4)
  tibble(Variable=v,Kruskal_H=unname(tst$statistic),p=tst$p.value)
})

classes <- c("Funerary","Cannibalism","Carnivore-related","Geological transport")
pairwise <- map_dfr(c("C_adjusted","Evenness_adjusted"),function(v) {
  combn(classes,2,simplify=FALSE) %>%
    map_dfr(function(pair) {
      x <- fit %>% filter(class4==pair[1]) %>% pull(all_of(v)) %>% na.omit()
      y <- fit %>% filter(class4==pair[2]) %>% pull(all_of(v)) %>% na.omit()
      wt <- wilcox.test(x,y,exact=FALSE)
      tibble(
        Variable=v,Group1=pair[1],Group2=pair[2],
        Median1=median(x),Median2=median(y),
        Cliffs_delta=cliffs_delta(x,y),
        p_raw=wt$p.value
      )
    })
}) %>%
  mutate(p_BH=p.adjust(p_raw,method="BH"))

write_csv(diagnostics,file.path(OUT_DIR,"k_diagnostics.csv"))
write_csv(k_summary,file.path(OUT_DIR,"k_summary.csv"))
write_csv(associations,file.path(OUT_DIR,"cluster_label_statistics.csv"))
write_csv(profiles,file.path(OUT_DIR,"cluster_profiles.csv"))
write_csv(pca_correlations,file.path(OUT_DIR,"pca_correlations.csv"))
write_csv(permanova_results,file.path(OUT_DIR,"permanova_dispersion.csv"))
write_csv(binary_contingencies,file.path(OUT_DIR,"binary_contingencies.csv"))
write_csv(fourclass_contingencies,file.path(OUT_DIR,"fourclass_contingencies.csv"))
write_csv(funerary_subtype_contingencies,file.path(OUT_DIR,"funerary_subtype_contingencies.csv"))
write_csv(fit_assignments,file.path(OUT_DIR,"fit_assignments.csv"))
write_csv(unknown_assignments,file.path(OUT_DIR,"unknown_assignments.csv"))
write_csv(unknown_consensus,file.path(OUT_DIR,"unknown_consensus.csv"))
write_csv(test_assignments,file.path(OUT_DIR,"test_assignments.csv"))
write_csv(test_consensus,file.path(OUT_DIR,"test_consensus.csv"))
write_csv(test_performance,file.path(OUT_DIR,"test_concordance_by_feature_space.csv"))
write_csv(funerary_descriptives,file.path(OUT_DIR,"funerary_subtype_descriptives.csv"))
write_csv(kw,file.path(OUT_DIR,"C_evenness_kruskal.csv"))
write_csv(pairwise,file.path(OUT_DIR,"C_evenness_pairwise_BH.csv"))

message("Finished. Outputs are in: ",OUT_DIR)
