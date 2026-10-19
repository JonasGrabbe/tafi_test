# Supervised 7 x 4 x 3 benchmark with class-conditional conformal prediction
# ======================================================================
# Mirrors the executed Python analysis conceptually in R.
# Input: tapho_db_ind_preprocessed_v3_corrected.csv
#
# Packages:
# install.packages(c(
#   "tidyverse", "rsample", "ranger", "e1071", "kknn", "nnet", "pROC"
# ))
#
# NOTE: stochastic implementations differ between scikit-learn and R engines;
# probabilities will not be bit-for-bit identical. The design, feature spaces,
# tasks, balancing, metrics, and conformal logic are reproduced.

library(tidyverse)
library(rsample)
library(ranger)
library(e1071)
library(kknn)
library(nnet)
library(pROC)

set.seed(20260907)
input_path <- "tapho_db_ind.csv"
out_dir <- "supervised_7x4x3_R_outputs_02"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

d <- read_csv(input_path, show_col_types = FALSE)

fit_contexts <- c(
  "Funerary Context", "Cannibalism", "Carnivore",
  "Carnivore den(transport)", "Carnivore Scavenge (in situ)",
  "Geological transport"
)
unknown_contexts <- c("Unknown", "Unkown")
testing_contexts <- c("Cuevas Sepulcrales", "Sepulchral Cave")

broad_context <- function(x) {
  case_when(
    x == "Funerary Context" ~ "Funerary",
    x == "Cannibalism" ~ "Cannibalism",
    str_starts(x, "Carnivore") ~ "Carnivore",
    x == "Geological transport" ~ "Geological transport",
    x %in% unknown_contexts ~ "Unknown",
    x %in% testing_contexts ~ "Sepulchral/target",
    TRUE ~ x
  )
}

# ----------------------------------------------------------------------
# 1. Laterality redistribution
# ----------------------------------------------------------------------
for (prefix in c("ProportionalRep_MNIbased_", "ReMNAU_")) {
  for (part in c("clavicle", "scapula", "humerus", "radius", "ulna")) {
    ind <- paste0(prefix, part, "_indet")
    rr  <- paste0(prefix, part, "_right")
    ll  <- paste0(prefix, part, "_left")
    v <- replace_na(d[[ind]], 0)
    d[[rr]] <- replace_na(d[[rr]], 0) + v/2
    d[[ll]] <- replace_na(d[[ll]], 0) + v/2
    d[[ind]] <- 0
  }
}

pct_all <- names(d)[str_starts(names(d), "ProportionalRep_MNIbased_")]
d <- d |> mutate(across(all_of(pct_all), ~ pmin(1, pmax(0, replace_na(.x, 0)))))

parts <- c(
  "cranium", "hyoid", "vertebrae", "thorax_indet", "sternum", "ribs",
  "shoulder_indet", "clavicle_right", "clavicle_left", "scapula_right",
  "scapula_left", "arms_indet", "humerus_right", "humerus_left",
  "radius_right", "radius_left", "ulna_right", "ulna_left", "hands",
  "pelvic", "legs", "foot"
)
pct_cols <- paste0("ProportionalRep_MNIbased_", parts)
rem_cols <- paste0("ReMNAU_", parts)
engineered_cols <- names(d)[90:117]  # R indexing; Python columns 89:116
value_cols <- unique(c(
  pct_cols, rem_cols, engineered_cols,
  "Mean_part_abundance", "mnau_heip_evenness"
))

# ----------------------------------------------------------------------
# 2. One vector per parent site
# ----------------------------------------------------------------------
site <- d |>
  group_by(site_id) |>
  group_modify(~ {
    g <- .x
    if (first(g$count_type)) {
      vals <- g |> slice(1) |> select(all_of(value_cols))
      inventory_mode <- "summed assemblage"
    } else {
      vals <- g |>
        summarise(across(all_of(value_cols), ~ mean(.x, na.rm = TRUE)))
      inventory_mode <- "mean subdivisions"
    }
    tibble(
      site_name = first(g$site_name),
      taphonomic_context = first(g$taphonomic_context),
      inventory_mode = inventory_mode
    ) |> bind_cols(vals)
  }) |>
  ungroup() |>
  mutate(broad_context = broad_context(taphonomic_context))

ref <- site |> filter(taphonomic_context %in% fit_contexts)
unknown <- site |> filter(taphonomic_context %in% unknown_contexts)
testing <- site |> filter(taphonomic_context %in% testing_contexts)

stopifnot(nrow(ref) == 103, nrow(unknown) == 23, nrow(testing) == 25)

# ----------------------------------------------------------------------
# 3. Feature spaces
# ----------------------------------------------------------------------
space_data <- function(space_name, ref, unknown, testing) {
  if (space_name == "Mean abundance C") {
    cols <- "Mean_part_abundance"
    return(list(ref=ref, unknown=unknown, testing=testing, cols=cols))
  }
  if (space_name == "Evenness") {
    cols <- "mnau_heip_evenness"
    return(list(
      ref=ref |> filter(if_all(all_of(cols), is.finite)),
      unknown=unknown |> filter(if_all(all_of(cols), is.finite)),
      testing=testing |> filter(if_all(all_of(cols), is.finite)), cols=cols))
  }
  if (space_name == "C + Evenness") {
    cols <- c("Mean_part_abundance", "mnau_heip_evenness")
    return(list(
      ref=ref |> filter(if_all(all_of(cols), is.finite)),
      unknown=unknown |> filter(if_all(all_of(cols), is.finite)),
      testing=testing |> filter(if_all(all_of(cols), is.finite)), cols=cols))
  }
  if (space_name == "Adjusted %MNAU") {
    return(list(ref=ref, unknown=unknown, testing=testing, cols=pct_cols))
  }
  if (space_name == "Hellinger ReMNAU") {
    transform_one <- function(x) {
      m <- as.matrix(x[, rem_cols])
      rs <- rowSums(m, na.rm=TRUE)
      keep <- rs > 0
      p <- m[keep,,drop=FALSE] / rs[keep]
      h <- sqrt(p)
      x2 <- x[keep,,drop=FALSE]
      h <- as_tibble(h); names(h) <- paste0("H_", parts)
      bind_cols(x2 |> select(-all_of(rem_cols)), h)
    }
    rr <- transform_one(ref); uu <- transform_one(unknown); tt <- transform_one(testing)
    return(list(ref=rr, unknown=uu, testing=tt, cols=paste0("H_", parts)))
  }
  if (space_name == "Engineered") {
    return(list(ref=ref, unknown=unknown, testing=testing, cols=engineered_cols))
  }
  if (space_name == "Combined") {
    return(list(ref=ref, unknown=unknown, testing=testing, cols=c(pct_cols, engineered_cols)))
  }
  stop("Unknown feature space")
}

spaces <- c(
  "Mean abundance C", "Evenness", "C + Evenness", "Adjusted %MNAU",
  "Hellinger ReMNAU", "Engineered", "Combined"
)
models <- c("Logistic regression", "Random forest", "RBF SVM", "KNN")
tasks <- c("Binary F vs NF", "Four-class context", "Non-funerary 3-class")
alpha <- 0.10

# ----------------------------------------------------------------------
# 4. Tasks
# ----------------------------------------------------------------------
make_task <- function(task_name, dat) {
  if (task_name == "Binary F vs NF") {
    out <- dat |> mutate(outcome = factor(if_else(broad_context=="Funerary", "Funerary", "Non-funerary"),
                                         levels=c("Non-funerary","Funerary")))
    return(out)
  }
  if (task_name == "Four-class context") {
    out <- dat |> mutate(outcome = factor(broad_context,
      levels=c("Cannibalism","Carnivore","Funerary","Geological transport")))
    return(out)
  }
  dat |>
    filter(broad_context %in% c("Cannibalism","Carnivore","Geological transport")) |>
    mutate(outcome=factor(broad_context,
      levels=c("Cannibalism","Carnivore","Geological transport")))
}

# ----------------------------------------------------------------------
# 5. Fold preprocessing and balancing
# ----------------------------------------------------------------------
preprocess_fold <- function(train, others, cols) {
  xtr <- as.matrix(train[,cols,drop=FALSE])
  med <- apply(xtr,2,function(x) median(x[is.finite(x)],na.rm=TRUE))
  keep <- is.finite(med)
  xtr <- xtr[,keep,drop=FALSE]; med <- med[keep]
  fill <- function(M) {
    M <- as.matrix(M[,cols,drop=FALSE])[,keep,drop=FALSE]
    for (j in seq_len(ncol(M))) M[!is.finite(M[,j]),j] <- med[j]
    M
  }
  xtr <- fill(train)
  xo <- map(others, fill)
  s <- apply(xtr,2,sd); keep2 <- is.finite(s) & s > 1e-12
  xtr <- xtr[,keep2,drop=FALSE]; xo <- map(xo, ~ .x[,keep2,drop=FALSE])
  mu <- colMeans(xtr); ss <- apply(xtr,2,sd)
  scale_one <- function(M) sweep(sweep(M,2,mu,"-"),2,ss,"/")
  list(train=scale_one(xtr), others=map(xo,scale_one))
}

upsample_equal <- function(X, y, seed=1) {
  set.seed(seed)
  yy <- factor(y)
  nmax <- max(table(yy))
  idx <- map(levels(yy), function(cl) {
    ii <- which(yy==cl)
    sample(ii,nmax,replace=TRUE)
  }) |> unlist()
  idx <- sample(idx)
  list(X=X[idx,,drop=FALSE], y=droplevels(yy[idx]))
}

# ----------------------------------------------------------------------
# 6. Four model engines
# ----------------------------------------------------------------------
fit_predict_model <- function(model_name, Xtrain, ytrain, Xnew, seed=1) {
  tr <- as.data.frame(Xtrain); tr$y <- ytrain
  te <- as.data.frame(Xnew)
  lev <- levels(ytrain)

  if (model_name == "Logistic regression") {
    set.seed(seed)
    mod <- nnet::multinom(y ~ ., data=tr, trace=FALSE, MaxNWts=20000)
    p <- predict(mod,newdata=te,type="probs")
    if (length(lev)==2 && is.vector(p)) p <- cbind(1-p,p)
    p <- as.matrix(p)
    colnames(p) <- lev
    return(p)
  }

  if (model_name == "Random forest") {
    set.seed(seed)
    mod <- ranger::ranger(y ~ ., data=tr, probability=TRUE,
                          num.trees=80, mtry=max(1,floor(sqrt(ncol(Xtrain)))),
                          min.node.size=2, seed=seed)
    p <- predict(mod,data=te)$predictions
    return(p[,lev,drop=FALSE])
  }

  if (model_name == "RBF SVM") {
    set.seed(seed)
    mod <- e1071::svm(y ~ ., data=tr, kernel="radial", cost=1,
                      gamma=1/max(1,ncol(Xtrain)), probability=TRUE,
                      scale=FALSE)
    pred <- predict(mod,newdata=te,probability=TRUE)
    p <- attr(pred,"probabilities")
    return(p[,lev,drop=FALSE])
  }

  # KNN: kknn returns class probabilities for classification.
  k <- max(3,min(7,nrow(Xtrain)-1))
  f <- as.formula("y ~ .")
  kn <- kknn::kknn(f, train=tr, test=te, k=k, distance=2, kernel="inv")
  p <- as.matrix(kn$prob)
  return(p[,lev,drop=FALSE])
}

# ----------------------------------------------------------------------
# 7. Metrics
# ----------------------------------------------------------------------
macro_precision <- function(y,pred) {
  lev <- levels(y)
  mean(map_dbl(lev,function(cl) {
    tp <- sum(y==cl & pred==cl); fp <- sum(y!=cl & pred==cl)
    if ((tp+fp)==0) 0 else tp/(tp+fp)
  }))
}
macro_recall <- function(y,pred) {
  lev <- levels(y)
  mean(map_dbl(lev,function(cl) {
    tp <- sum(y==cl & pred==cl); fn <- sum(y==cl & pred!=cl)
    if ((tp+fn)==0) 0 else tp/(tp+fn)
  }))
}
macro_auc_ovr <- function(y,p) {
  lev <- levels(y)
  mean(map_dbl(seq_along(lev),function(j) {
    yy <- as.integer(y==lev[j])
    as.numeric(pROC::auc(pROC::roc(yy,p[,j],quiet=TRUE,direction="<")))
  }))
}
calc_metrics <- function(y,p) {
  lev <- levels(y)
  pred <- factor(lev[max.col(p,ties.method="first")],levels=lev)
  ba <- macro_recall(y,pred)
  pr <- macro_precision(y,pred)
  rc <- macro_recall(y,pred)
  if (length(lev)==2) {
    j <- match("Funerary",lev)
    auc <- as.numeric(pROC::auc(pROC::roc(as.integer(y=="Funerary"),p[,j],quiet=TRUE,direction="<")))
    brier <- mean((as.integer(y=="Funerary")-p[,j])^2)
    # precision/recall with Funerary as positive to match Python output
    tp <- sum(y=="Funerary" & pred=="Funerary")
    fp <- sum(y!="Funerary" & pred=="Funerary")
    fn <- sum(y=="Funerary" & pred!="Funerary")
    pr <- ifelse(tp+fp==0,0,tp/(tp+fp)); rc <- tp/(tp+fn)
  } else {
    auc <- macro_auc_ovr(y,p)
    onehot <- sapply(lev,function(cl) as.integer(y==cl))
    brier <- mean(rowSums((p-onehot)^2))
  }
  tibble(balanced_accuracy=ba,roc_auc=auc,precision=pr,recall=rc,brier=brier)
}

# ----------------------------------------------------------------------
# 8. Mondrian/class-conditional cross-conformal p-values
# ----------------------------------------------------------------------
conformal_pvalues <- function(oof_prob, y, target_prob) {
  lev <- levels(y)
  out <- matrix(NA_real_,nrow(target_prob),length(lev),dimnames=list(NULL,lev))
  for (j in seq_along(lev)) {
    scores <- 1-oof_prob[y==lev[j],j]
    snew <- 1-target_prob[,j]
    out[,j] <- map_dbl(snew,~ (1+sum(scores >= .x))/(length(scores)+1))
  }
  out
}

loo_conformal_summary <- function(oof_prob,y,alpha=.10) {
  lev <- levels(y)
  sizes <- covered <- singleton <- empty <- numeric(length(y))
  score_list <- map(seq_along(lev), ~1-oof_prob[y==lev[.x],.x]); names(score_list)<-lev
  for (i in seq_along(y)) {
    inc <- logical(length(lev))
    for (j in seq_along(lev)) {
      sc <- score_list[[lev[j]]]
      s <- 1-oof_prob[i,j]
      if (y[i]==lev[j]) {
        own <- 1-oof_prob[i,j]
        sc <- sc[-which.min(abs(sc-own))]
      }
      pv <- (1+sum(sc>=s))/(length(sc)+1)
      inc[j] <- pv>alpha
    }
    sizes[i] <- sum(inc); covered[i] <- inc[match(y[i],lev)]
    singleton[i] <- sizes[i]==1; empty[i] <- sizes[i]==0
  }
  tibble(
    loo_empirical_coverage=mean(covered),
    mean_set_size=mean(sizes), singleton_rate=mean(singleton), empty_rate=mean(empty)
  )
}

# ----------------------------------------------------------------------
# 9. Five balanced outer folds
# ----------------------------------------------------------------------
performance_folds <- list(); performance_pooled <- list(); target_predictions <- list(); conformal_ref <- list()
kk <- 1; pp <- 1; tt <- 1; cc <- 1

for (space_name in spaces) {
  sp <- space_data(space_name,ref,unknown,testing)
  for (task_name in tasks) {
    ref_task <- make_task(task_name,sp$ref)
    # Unknown/testing are not assigned true outcomes; they only need predictors.
    folds <- vfold_cv(ref_task,v=5,strata=outcome)

    for (model_name in models) {
      lev <- levels(ref_task$outcome)
      oof <- matrix(NA_real_,nrow(ref_task),length(lev),dimnames=list(NULL,lev))
      u_fold <- vector("list",5); t_fold <- vector("list",5)

      for (fold_i in seq_len(5)) {
        split <- folds$splits[[fold_i]]
        tr <- analysis(split); va <- assessment(split)
        va_idx <- as.integer(rownames(va))
        # rsample rownames are not guaranteed to equal source indices; recover by site_id.
        va_idx <- match(va$site_id,ref_task$site_id)

        pr <- preprocess_fold(tr,list(va,sp$unknown,sp$testing),sp$cols)
        bal <- upsample_equal(pr$train,tr$outcome,seed=10000+fold_i)
        p_val <- fit_predict_model(model_name,bal$X,bal$y,pr$others[[1]],seed=9000+fold_i)
        p_unk <- fit_predict_model(model_name,bal$X,bal$y,pr$others[[2]],seed=9000+fold_i)
        p_tst <- fit_predict_model(model_name,bal$X,bal$y,pr$others[[3]],seed=9000+fold_i)
        # align columns
        p_val <- p_val[,lev,drop=FALSE]; p_unk <- p_unk[,lev,drop=FALSE]; p_tst <- p_tst[,lev,drop=FALSE]
        oof[va_idx,] <- p_val; u_fold[[fold_i]] <- p_unk; t_fold[[fold_i]] <- p_tst

        met <- calc_metrics(va$outcome,p_val)
        performance_folds[[kk]] <- bind_cols(
          tibble(feature_space=space_name,model=model_name,task=task_name,run=fold_i,n_test=nrow(va)),met)
        kk <- kk+1
      }

      met_pool <- calc_metrics(ref_task$outcome,oof)
      performance_pooled[[pp]] <- bind_cols(
        tibble(feature_space=space_name,model=model_name,task=task_name,n_reference=nrow(ref_task)),met_pool)
      pp <- pp+1

      cs <- loo_conformal_summary(oof,ref_task$outcome,alpha)
      conformal_ref[[cc]] <- bind_cols(tibble(feature_space=space_name,model=model_name,task=task_name,alpha=alpha),cs)
      cc <- cc+1

      # Five target prediction runs, one from each outer-fold model.
      for (fold_i in seq_len(5)) {
        for (kind in c("Unknown","Sepulchral-labelled testing")) {
          meta <- if (kind=="Unknown") sp$unknown else sp$testing
          pro <- if (kind=="Unknown") u_fold[[fold_i]] else t_fold[[fold_i]]
          cp <- conformal_pvalues(oof,ref_task$outcome,pro)
          for (i in seq_len(nrow(meta))) {
            inc <- cp[i,] > alpha
            row <- tibble(
              feature_space=space_name, model=model_name, task=task_name, run=fold_i,
              target_type=kind, site_id=meta$site_id[i], site_name=meta$site_name[i],
              top_class=lev[which.max(pro[i,])], top_probability=max(pro[i,]),
              prediction_set=paste(lev[inc],collapse="|"), set_size=sum(inc)
            )
            for (j in seq_along(lev)) {
              key <- str_replace_all(lev[j],"[ -]","_")
              row[[paste0("prob_",key)]] <- pro[i,j]
              row[[paste0("conformal_p_",key)]] <- cp[i,j]
              row[[paste0("include_",key)]] <- inc[j]
            }
            target_predictions[[tt]] <- row; tt <- tt+1
          }
        }
      }
    }
  }
}

performance_folds <- bind_rows(performance_folds)
performance_pooled <- bind_rows(performance_pooled)
target_predictions <- bind_rows(target_predictions)
conformal_ref <- bind_rows(conformal_ref)

write_csv(performance_folds,file.path(out_dir,"performance_five_folds.csv"))
write_csv(performance_pooled,file.path(out_dir,"performance_pooled_oof.csv"))
write_csv(target_predictions,file.path(out_dir,"target_predictions_5runs.csv"))
write_csv(conformal_ref,file.path(out_dir,"conformal_reference_summary.csv"))

# ----------------------------------------------------------------------
# 10. Summary tables and plots
# ----------------------------------------------------------------------
perf_summary <- performance_folds |>
  group_by(feature_space,model,task) |>
  summarise(across(c(balanced_accuracy,roc_auc,precision,recall,brier),
                   list(fold_mean=mean,fold_sd=sd)),.groups="drop") |>
  left_join(performance_pooled,by=c("feature_space","model","task"))
write_csv(perf_summary,file.path(out_dir,"performance_summary.csv"))

binary_targets <- target_predictions |> filter(task=="Binary F vs NF")
unknown_consensus <- binary_targets |>
  filter(target_type=="Unknown") |>
  group_by(site_id,site_name) |>
  summarise(
    n_pipeline_runs=n(), mean_P_F=mean(prob_Funerary,na.rm=TRUE),
    median_P_F=median(prob_Funerary,na.rm=TRUE),
    predicted_F_pct=100*mean(top_class=="Funerary"),
    conformal_include_F_pct=100*mean(include_Funerary,na.rm=TRUE),
    conformal_include_NF_pct=100*mean(include_Non_funerary,na.rm=TRUE),
    conformal_exclusive_F_pct=100*mean(include_Funerary & !include_Non_funerary,na.rm=TRUE),
    conformal_exclusive_NF_pct=100*mean(include_Non_funerary & !include_Funerary,na.rm=TRUE),
    conformal_ambiguous_both_pct=100*mean(include_Funerary & include_Non_funerary,na.rm=TRUE),
    .groups="drop"
  )
write_csv(unknown_consensus,file.path(out_dir,"unknown_binary_consensus.csv"))

# Sima trajectory
sima_order <- c("Sima de los Huesos 89","Sima de los Huesos 90","Sima de los Huesos 95","Sima de los Huesos 15","Sima de los Huesos 24")
sima <- unknown_consensus |>
  filter(site_name %in% sima_order) |>
  mutate(stage=factor(site_name,levels=sima_order)) |>
  arrange(stage)
write_csv(sima,file.path(out_dir,"sima_progression_binary_conformal.csv"))

p1 <- sima |>
  select(stage,conformal_include_F_pct,conformal_include_NF_pct) |>
  pivot_longer(-stage,names_to="series",values_to="pct") |>
  ggplot(aes(x=as.numeric(stage),y=pct,linetype=series,group=series)) +
  geom_point() + geom_smooth(method="loess",se=FALSE,span=.9) +
  scale_x_continuous(breaks=1:5,labels=c("1989","1990","1995","2015","2024")) +
  coord_cartesian(ylim=c(0,100)) +
  labs(x="Sima recovery sequence",y="90% conformal inclusion (%)",
       title="Sima de los Huesos conformal progression") + theme_minimal()
ggsave(file.path(out_dir,"sima_conformal_inclusion_spline_R.png"),p1,width=9.2,height=5.7,dpi=300)

message("R reproduction complete.")
