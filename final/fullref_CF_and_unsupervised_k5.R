
# ==============================================================================
# FULL-REFERENCE ADDENDUM
# 1) Cannibalism vs Funerary Context: 7 feature spaces x 4 classifiers
# 2) Full-reference unsupervised analysis with data-selected k AND fixed k=5
# 3) Unknown projection into the fixed-k=5 solutions
#
# Input:
#   sum_data_indet_adjusted_analysis_data.csv
#
# Packages:
#   tidyverse, rsample, ranger, kernlab, kknn, nnet, pROC, cluster, ggrepel
# ==============================================================================

library(tidyverse)
library(rsample)
library(ranger)
library(kernlab)
library(kknn)
library(nnet)
library(pROC)
library(cluster)
library(ggrepel)

set.seed(42)

INPUT_FILE <- "sum_data_indet_adjusted_analysis_data.csv"
OUT_DIR <- "fullref_CF_unsupervised_R_outputs"
dir.create(OUT_DIR,showWarnings=FALSE,recursive=TRUE)

d <- readr::read_csv(INPUT_FILE,show_col_types=FALSE)

class4_fun <- function(x) {
  case_when(
    x=="Funerary Context" ~ "Funerary",
    x=="Cannibalism" ~ "Cannibalism",
    x %in% c(
      "Carnivore","Carnivore Scavenge (in situ)",
      "Carnivore den(transport)"
    ) ~ "Carnivore-related",
    x=="Geological transport" ~ "Geological transport",
    TRUE ~ NA_character_
  )
}

d <- d %>%
  mutate(
    class4=class4_fun(taphonomic_context),
    binary_label=case_when(
      class4=="Funerary" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    )
  )

reference <- d %>% filter(!is.na(class4))
unknown <- d %>% filter(taphonomic_context %in% c("Unknown","Unkown"))

# ------------------------------------------------------------------------------
# Feature spaces
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

informative <- function(data,vars) {
  vars[vapply(vars,function(v) {
    z <- data[[v]]
    sum(!is.na(z))>1 && dplyr::n_distinct(z,na.rm=TRUE)>1
  },logical(1))]
}

prop_cols <- informative(reference,prop_cols)
rem_cols <- informative(reference,rem_cols)
eng_cols <- informative(reference,eng_cols)

feature_sets <- list(
  `C only`=c("C_adjusted"),
  `Evenness only`=c("Evenness_adjusted"),
  `C + evenness`=c("C_adjusted","Evenness_adjusted"),
  `%MNAU`=prop_cols,
  ReMNAU=rem_cols,
  Engineered=eng_cols,
  Combined=c(prop_cols,rem_cols,eng_cols)
)

# ------------------------------------------------------------------------------
# Preprocessing
# ------------------------------------------------------------------------------

prep <- function(train,newdata,vars) {
  med <- map_dbl(vars,~median(train[[.x]],na.rm=TRUE))
  names(med) <- vars

  impute <- function(dat) {
    x <- dat %>% select(all_of(vars)) %>% as.data.frame()
    for(v in vars) x[[v]][is.na(x[[v]])] <- med[[v]]
    as.matrix(x)
  }

  xtr0 <- impute(train)
  xnew0 <- impute(newdata)
  mu <- colMeans(xtr0)
  sdv <- apply(xtr0,2,sd)
  sdv[is.na(sdv)|sdv==0] <- 1

  std <- function(x) sweep(sweep(x,2,mu,"-"),2,sdv,"/")
  list(
    Xtrain=std(xtr0),
    Xnew=std(xnew0),
    original_train=xtr0,
    original_new=xnew0
  )
}

# ------------------------------------------------------------------------------
# Four classifiers
# ------------------------------------------------------------------------------

obs_weights <- function(y) {
  tab <- table(y)
  as.numeric((length(y)/(length(tab)*tab))[as.character(y)])
}

class_weights <- function(y) {
  tab <- table(y)
  x <- length(y)/(length(tab)*tab)
  as.numeric(x) %>% set_names(names(x))
}

fit_model <- function(model_name,X,y) {
  y <- factor(y)
  dat <- as.data.frame(X)
  dat$.y <- y

  if(model_name=="Logistic regression") {
    m <- nnet::multinom(
      .y~.,data=dat,weights=obs_weights(y),
      decay=1,trace=FALSE,maxit=2000,MaxNWts=100000
    )
    return(list(type="lr",model=m,classes=levels(y)))
  }

  if(model_name=="Random forest") {
    m <- ranger::ranger(
      .y~.,data=dat,probability=TRUE,
      num.trees=80,min.node.size=3,
      mtry=max(1,floor(sqrt(ncol(X)))),
      class.weights=class_weights(y),seed=42
    )
    return(list(type="rf",model=m,classes=levels(y)))
  }

  if(model_name=="RBF SVM") {
    m <- kernlab::ksvm(
      x=X,y=y,type="C-svc",kernel="rbfdot",
      kpar=list(sigma=1/max(1,ncol(X))),
      C=1,class.weights=class_weights(y),
      prob.model=TRUE,scaled=FALSE
    )
    return(list(type="svm",model=m,classes=levels(y)))
  }

  if(model_name=="KNN") {
    return(list(type="knn",X=X,y=y,classes=levels(y)))
  }
}

predict_model <- function(obj,Xnew) {
  classes <- obj$classes

  if(obj$type=="lr") {
    p <- predict(obj$model,newdata=as.data.frame(Xnew),type="probs")
    if(is.null(dim(p))) {
      p <- cbind(1-p,p)
      colnames(p) <- classes
    }
  } else if(obj$type=="rf") {
    p <- predict(obj$model,data=as.data.frame(Xnew))$predictions
  } else if(obj$type=="svm") {
    p <- predict(obj$model,Xnew,type="probabilities")
  } else {
    tr <- as.data.frame(obj$X)
    tr$.y <- obj$y
    te <- as.data.frame(Xnew)
    kn <- kknn::kknn(.y~.,train=tr,test=te,k=7,kernel="inv")
    p <- predict(kn, type = "prob") #p <- fitted(kn)
  }

  p <- as.matrix(p)
  if(is.null(colnames(p))) colnames(p) <- classes
  out <- matrix(0,nrow(p),length(classes),dimnames=list(NULL,classes))
  keep <- intersect(classes,colnames(p))
  out[,keep] <- p[,keep,drop=FALSE]
  out/rowSums(out)
}

# ==============================================================================
# PART I. Cannibalism vs Funerary Context
# ==============================================================================

cf <- reference %>% filter(class4 %in% c("Cannibalism","Funerary"))
models <- c("Logistic regression","Random forest","RBF SVM","KNN")
classes <- c("Cannibalism","Funerary")

metric_rows <- list()
ii <- 1

for(run in 1:5) {
  set.seed(131000+run)
  folds <- rsample::group_vfold_cv(
    cf,group=site_name,v=3,strata=class4
  )

  for(fold_i in seq_len(nrow(folds))) {
    tr <- analysis(folds$splits[[fold_i]])
    te <- assessment(folds$splits[[fold_i]])

    for(model_name in models) {
      for(space in names(feature_sets)) {
        pp <- prep(tr,te,feature_sets[[space]])
        m <- fit_model(model_name,pp$Xtrain,tr$class4)
        pr <- predict_model(m,pp$Xnew)[,classes,drop=FALSE]
        pred <- classes[max.col(pr,ties.method="first")]

        sens <- sum(te$class4=="Funerary" & pred=="Funerary")/
                sum(te$class4=="Funerary")
        spec <- sum(te$class4=="Cannibalism" & pred=="Cannibalism")/
                sum(te$class4=="Cannibalism")
        precision <- sum(te$class4=="Funerary" & pred=="Funerary")/
                     max(1,sum(pred=="Funerary"))
        yy <- as.integer(te$class4=="Funerary")
        auc <- as.numeric(pROC::auc(
          pROC::roc(yy,pr[,"Funerary"],quiet=TRUE,direction="<")
        ))

        metric_rows[[ii]] <- tibble(
          Run=run,Fold=fold_i,Model=model_name,Feature_space=space,
          Balanced_accuracy=(sens+spec)/2,
          ROC_AUC=auc,
          Precision=precision,
          Recall=sens,
          Brier=mean((pr[,"Funerary"]-yy)^2)
        )
        ii <- ii+1
      }
    }
  }
}

cf_metrics <- bind_rows(metric_rows)
cf_performance <- cf_metrics %>%
  group_by(Model,Feature_space) %>%
  summarise(
    across(
      c(Balanced_accuracy,ROC_AUC,Precision,Recall,Brier),
      list(mean=mean,sd=sd)
    ),
    .groups="drop"
  )

write_csv(cf_metrics,file.path(OUT_DIR,"CF_fold_metrics.csv"))
write_csv(cf_performance,file.path(OUT_DIR,"CF_performance.csv"))

# ------------------------------------------------------------------------------
# 90% Mondrian conformal projection of Unknowns onto the C-vs-F contrast
# ------------------------------------------------------------------------------

qhat <- function(scores,alpha=.10) {
  scores <- sort(scores)
  n <- length(scores)
  k <- ceiling((n+1)*(1-alpha))
  if(k>n) return(1)
  scores[k]
}

unknown_cf <- list()
threshold_cf <- list()
jj <- 1; qq <- 1

cf <- cf %>% mutate(.rowid=row_number())

for(run in 1:5) {
  set.seed(132000+run)
  folds <- rsample::group_vfold_cv(
    cf,group=site_name,v=3,strata=class4
  )

  for(model_name in models) {
    for(space in names(feature_sets)) {
      vars <- feature_sets[[space]]
      oof <- matrix(NA_real_,nrow(cf),2,dimnames=list(NULL,classes))

      for(fold_i in seq_len(nrow(folds))) {
        tr <- analysis(folds$splits[[fold_i]])
        te <- assessment(folds$splits[[fold_i]])
        pp <- prep(tr,te,vars)
        m <- fit_model(model_name,pp$Xtrain,tr$class4)
        pr <- predict_model(m,pp$Xnew)[,classes,drop=FALSE]
        oof[te$.rowid,] <- pr
      }

      qC <- qhat(1-oof[cf$class4=="Cannibalism","Cannibalism"],.10)
      qF <- qhat(1-oof[cf$class4=="Funerary","Funerary"],.10)

      threshold_cf[[qq]] <- tibble(
        Run=run,Model=model_name,Feature_space=space,
        qCannibalism=qC,qFunerary=qF,
        Min_P_Cannibalism=1-qC,
        Min_P_Funerary=1-qF
      )
      qq <- qq+1

      pp <- prep(cf,unknown,vars)
      mf <- fit_model(model_name,pp$Xtrain,cf$class4)
      pu <- predict_model(mf,pp$Xnew)[,classes,drop=FALSE]

      for(i in seq_len(nrow(unknown))) {
        incC <- pu[i,"Cannibalism"] >= 1-qC
        incF <- pu[i,"Funerary"] >= 1-qF
        set <- case_when(
          incC & incF ~ "{Cannibalism,Funerary}",
          incC ~ "{Cannibalism}",
          incF ~ "{Funerary}",
          TRUE ~ "{}"
        )

        unknown_cf[[jj]] <- tibble(
          Run=run,Model=model_name,Feature_space=space,
          site_name=unknown$site_name[i],
          Set=set,
          P_Cannibalism=pu[i,"Cannibalism"],
          P_Funerary=pu[i,"Funerary"]
        )
        jj <- jj+1
      }
    }
  }
}

write_csv(bind_rows(unknown_cf),file.path(OUT_DIR,"CF_unknown_5runs.csv"))
write_csv(bind_rows(threshold_cf),file.path(OUT_DIR,"CF_thresholds.csv"))

# ==============================================================================
# PART II. Full-reference unsupervised clustering
# ==============================================================================

# Labels are never used to fit k-means. They are used only afterward for
# interpretation and cluster-label agreement.

elbow_distance <- function(k,inertia) {
  xn <- (k-min(k))/(max(k)-min(k))
  yn <- (inertia-min(inertia))/(max(inertia)-min(inertia))
  p1 <- c(xn[1],yn[1])
  p2 <- c(xn[length(xn)],yn[length(yn)])
  line <- p2-p1
  dd <- map_dbl(seq_along(k),function(i) {
    p <- c(xn[i],yn[i])
    abs(line[1]*(p[2]-p1[2])-line[2]*(p[1]-p1[1]))/
      sqrt(sum(line^2))
  })
  inner <- 2:(length(k)-1)
  k[inner[which.max(dd[inner])]]
}

choose2 <- function(n) n*(n-1)/2
ARI <- function(a,b) {
  tab <- table(a,b)
  sc <- sum(choose2(tab))
  rc <- sum(choose2(rowSums(tab)))
  cc <- sum(choose2(colSums(tab)))
  tc <- choose2(sum(tab))
  ex <- rc*cc/tc
  mx <- .5*(rc+cc)
  if(mx==ex) return(0)
  (sc-ex)/(mx-ex)
}

NMI <- function(a,b) {
  tab <- table(a,b)
  pxy <- tab/sum(tab)
  px <- rowSums(pxy)
  py <- colSums(pxy)
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

ellipse_ci <- function(x,y,level=.95,n=200) {
  xy <- cbind(x,y)
  if(nrow(xy)<3) return(NULL)
  mu <- colMeans(xy)
  S <- cov(xy)/nrow(xy)
  ev <- eigen(S,symmetric=TRUE)
  radii <- sqrt(qchisq(level,2)*pmax(ev$values,0))
  theta <- seq(0,2*pi,length.out=n)
  unit <- rbind(cos(theta),sin(theta))
  ell <- t(ev$vectors %*% diag(radii) %*% unit)
  tibble(x=ell[,1]+mu[1],y=ell[,2]+mu[2])
}

diag_rows <- list()
compare_rows <- list()
profile_rows <- list()
unknown_rows <- list()
aa <- 1; bb <- 1; ppn <- 1; uu <- 1

for(space in names(feature_sets)) {
  vars <- feature_sets[[space]]
  pr <- prep(reference,unknown,vars)
  X <- pr$Xtrain
  Xu <- pr$Xnew

  kvals <- 1:8
  inertia <- map_dbl(kvals,function(k) {
    set.seed(42)
    kmeans(X,k,nstart=100,iter.max=100)$tot.withinss
  })

  sil <- rep(NA_real_,length(kvals))
  for(i in seq_along(kvals)) {
    k <- kvals[i]
    if(k>=2) {
      set.seed(42)
      km0 <- kmeans(X,k,nstart=100,iter.max=100)
      sil[i] <- mean(cluster::silhouette(km0$cluster,dist(X))[,3])
    }
  }

  ek <- elbow_distance(kvals,inertia)
  sk <- kvals[which.max(replace_na(sil,-Inf))]
  if(!is.na(sil[match(ek,kvals)]) &&
     sil[match(ek,kvals)] >= max(sil,na.rm=TRUE)-.02) {
    selected <- ek
  } else {
    selected <- sk
  }

  diag_rows[[aa]] <- tibble(
    Feature_space=space,
    Elbow_k=ek,Silhouette_best_k=sk,Selected_k=selected,
    Selected_silhouette=sil[match(selected,kvals)],
    k5_silhouette=sil[match(5,kvals)]
  )
  aa <- aa+1

  for(sol in c("Selected","Fixed k=5")) {
    k <- if(sol=="Selected") selected else 5
    set.seed(42)
    km <- kmeans(X,k,nstart=200,iter.max=100)
    cl <- km$cluster

    compare_rows[[bb]] <- tibble(
      Feature_space=space,Solution=sol,k=k,
      Silhouette=mean(cluster::silhouette(cl,dist(X))[,3]),
      ARI_FNF=ARI(reference$binary_label,cl),
      ARI_four=ARI(reference$class4,cl),
      NMI_FNF=NMI(reference$binary_label,cl),
      NMI_four=NMI(reference$class4,cl),
      Purity_FNF=purity(reference$binary_label,cl),
      Purity_four=purity(reference$class4,cl)
    )
    bb <- bb+1

    if(sol=="Fixed k=5") {
      for(c in 1:5) {
        z <- reference[cl==c,]
        profile_rows[[ppn]] <- tibble(
          Feature_space=space,Cluster=c,n=nrow(z),
          F_percent=100*mean(z$binary_label=="F"),
          Funerary_n=sum(z$class4=="Funerary"),
          Cannibalism_n=sum(z$class4=="Cannibalism"),
          Carnivore_n=sum(z$class4=="Carnivore-related"),
          Geological_transport_n=sum(z$class4=="Geological transport"),
          Median_C=median(z$C_adjusted),
          Median_evenness=median(z$Evenness_adjusted,na.rm=TRUE)
        )
        ppn <- ppn+1
      }

      # Assign Unknowns to nearest k-means center.
      assigned <- apply(Xu,1,function(z) {
        which.min(rowSums((km$centers-z)^2))
      })

      for(i in seq_len(nrow(unknown))) {
        c <- assigned[i]
        z <- reference[cl==c,]
        unknown_rows[[uu]] <- tibble(
          Feature_space=space,
          site_name=unknown$site_name[i],
          Cluster=c,
          Cluster_F_percent=100*mean(z$binary_label=="F")
        )
        uu <- uu+1
      }

      # Visualization:
      # 1D spaces use 95% centroid CI bars.
      # C+evenness uses direct coordinates.
      # Higher-dimensional spaces use PCA2 only for display.
      if(ncol(X)==1) {
        plot_df <- tibble(
          x=pr$original_train[,1],
          Cluster=factor(cl),
          jitter=seq(-.08,.08,length.out=nrow(reference))
        )
        gp <- ggplot(plot_df,aes(x,jitter,fill=Cluster)) +
          geom_point() +
          labs(
            x=vars[1],y="Jitter (visual only)",
            title=paste0(space,": full-reference fixed k=5")
          ) +
          theme_bw()
      } else {
        if(length(vars)==2 && space=="C + evenness") {
          coords <- pr$original_train
          xl <- "Mean abundance C"
          yl <- "Evenness"
        } else {
          pc <- prcomp(X,center=FALSE,scale.=FALSE,rank.=2)
          coords <- pc$x[,1:2]
          xl <- paste0(
            "PC1 (",
            round(100*summary(pc)$importance[2,1],1),"%)"
          )
          yl <- paste0(
            "PC2 (",
            round(100*summary(pc)$importance[2,2],1),"%)"
          )
        }

        plot_df <- tibble(
          x=coords[,1],y=coords[,2],
          Cluster=factor(cl),class4=reference$class4
        )

        ell <- map_dfr(levels(plot_df$Cluster),function(c) {
          z <- plot_df %>% filter(Cluster==c)
          e <- ellipse_ci(z$x,z$y)
          if(is.null(e)) return(tibble())
          mutate(e,Cluster=c)
        })

        gp <- ggplot(plot_df,aes(x,y)) +
          geom_point(aes(fill=Cluster,shape=class4),size=2.4) +
          geom_path(
            data=ell,
            aes(x,y,group=Cluster),
            inherit.aes=FALSE
          ) +
          labs(
            x=xl,y=yl,
            title=paste0(space,": full-reference fixed k=5"),
            subtitle="95% confidence ellipses for cluster centroids"
          ) +
          theme_bw()
      }

      ggsave(
        file.path(
          OUT_DIR,
          paste0("fixed_k5_",make.names(space),".png")
        ),
        gp,width=10.4,height=7.3,dpi=300
      )
    }
  }
}

write_csv(bind_rows(diag_rows),file.path(OUT_DIR,"k_summary.csv"))
write_csv(bind_rows(compare_rows),file.path(OUT_DIR,"selected_vs_k5.csv"))
write_csv(bind_rows(profile_rows),file.path(OUT_DIR,"k5_cluster_profiles.csv"))
write_csv(bind_rows(unknown_rows),file.path(OUT_DIR,"k5_unknown_assignments.csv"))

message("Finished: ",OUT_DIR)
