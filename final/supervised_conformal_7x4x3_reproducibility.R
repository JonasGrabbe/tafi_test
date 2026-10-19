
# ==============================================================================
# SPR supervised + conformal analysis
# 7 feature spaces x 4 classifiers x 3 tasks
# 5 runs x 3-fold grouped CV
# Strict held-out labelled challenge/test panel
# 90% cross-fitted Mondrian conformal prediction
# 5-run class-balanced bootstrap stress test
# Sima de los Huesos C x evenness conformal progression plots
#
# Input:
#   sum_data_indet_adjusted_analysis_data.csv
#
# Packages:
#   tidyverse, rsample, ranger, kernlab, kknn, nnet, pROC, ggrepel
#
# NOTE:
# R and scikit-learn use different probability-calibration implementations,
# especially for SVM, so small numerical differences are expected. The
# resampling, feature spaces, class balancing, conformal logic, and statistics
# mirror the Python analysis.
# ==============================================================================

library(tidyverse)
library(rsample)
library(ranger)
library(kernlab)
library(kknn)
library(nnet)
library(pROC)
library(ggrepel)

set.seed(42)

INPUT_FILE <- "sum_data_indet_adjusted_analysis_data.csv"
OUT_DIR <- "supervised_conformal_R_outputs"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

d <- readr::read_csv(INPUT_FILE, show_col_types = FALSE)

# ------------------------------------------------------------------------------
# 1. Labels
# ------------------------------------------------------------------------------

class4_fun <- function(x) {
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

d <- d %>%
  mutate(
    class4 = class4_fun(taphonomic_context),
    binary = case_when(
      class4 == "Funerary" ~ "F",
      !is.na(class4) ~ "NF",
      TRUE ~ NA_character_
    )
  )

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

eligible <- d %>% filter(!is.na(class4))
reference <- eligible %>% filter(!site_name %in% test_names)
labelled_test <- eligible %>%
  filter(site_name %in% test_names) %>%
  mutate(
    test_panel = case_when(
      site_name %in% historical & site_name %in% early ~ "Both panels",
      site_name %in% historical ~ "Historical challenge",
      site_name %in% early ~ "Early-human holdout"
    )
  )
unknown <- d %>% filter(taphonomic_context %in% c("Unknown","Unkown"))

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
    sum(!is.na(z)) > 1 && dplyr::n_distinct(z,na.rm=TRUE) > 1
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

task_defs <- list(
  `F vs NF`=list(
    filter=function(x) x %>% filter(!is.na(class4)),
    label="binary",
    classes=c("NF","F")
  ),
  `Four-class`=list(
    filter=function(x) x %>% filter(!is.na(class4)),
    label="class4",
    classes=c("Cannibalism","Carnivore-related","Funerary","Geological transport")
  ),
  `NF three-class`=list(
    filter=function(x) x %>%
      filter(class4 %in% c("Cannibalism","Carnivore-related","Geological transport")),
    label="class4",
    classes=c("Cannibalism","Carnivore-related","Geological transport")
  )
)

models <- c("Logistic regression","Random forest","RBF SVM","KNN")

# ------------------------------------------------------------------------------
# 3. Preprocessing
# ------------------------------------------------------------------------------

prep_fit <- function(train,newdata,vars) {
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
  sdv[is.na(sdv) | sdv==0] <- 1

  std <- function(x) sweep(sweep(x,2,mu,"-"),2,sdv,"/")

  list(
    Xtrain=std(xtr0),
    Xnew=std(xnew0),
    original_train=xtr0,
    original_new=xnew0
  )
}

class_weights <- function(y) {
  tab <- table(y)
  w <- length(y)/(length(tab)*tab)
  as.numeric(w[as.character(y)])
}

named_class_weights <- function(y) {
  tab <- table(y)
  as.list(length(y)/(length(tab)*tab)) %>%
    set_names(names(tab))
}

# ------------------------------------------------------------------------------
# 4. Model wrappers
# ------------------------------------------------------------------------------

fit_classifier <- function(model_name,X,y,balanced=TRUE) {
  y <- factor(y)
  dat <- as.data.frame(X)
  dat$.y <- y

  obs_w <- if(balanced) class_weights(y) else rep(1,length(y))
  cw <- if(balanced) unlist(named_class_weights(y)) else NULL

  if(model_name=="Logistic regression") {
    # nnet::multinom uses an L2-like weight decay. Decay=1 is the closest
    # simple analogue to the fixed C=1 regularized logistic model.
    mod <- nnet::multinom(
      .y ~ ., data=dat, weights=obs_w, decay=1,
      trace=FALSE, MaxNWts=100000, maxit=2000
    )
    return(list(type="lr",model=mod,classes=levels(y)))
  }

  if(model_name=="Random forest") {
    mod <- ranger::ranger(
      .y ~ ., data=dat, probability=TRUE,
      num.trees=40, min.node.size=3,
      mtry=max(1,floor(sqrt(ncol(X)))),
      class.weights=cw,
      seed=42
    )
    return(list(type="rf",model=mod,classes=levels(y)))
  }

  if(model_name=="RBF SVM") {
    sigma <- 1/max(1,ncol(X))
    mod <- kernlab::ksvm(
      x=X, y=y, type="C-svc",
      kernel="rbfdot", kpar=list(sigma=sigma), C=1,
      class.weights=cw, prob.model=TRUE, scaled=FALSE
    )
    return(list(type="svm",model=mod,classes=levels(y)))
  }

  if(model_name=="KNN") {
    return(list(
      type="knn", X=X, y=y, classes=levels(y)
    ))
  }

  stop("Unknown model")
}

predict_classifier <- function(obj,Xnew) {
  classes <- obj$classes

  if(obj$type=="lr") {
    pr <- predict(obj$model,newdata=as.data.frame(Xnew),type="probs")
    if(is.null(dim(pr))) {
      # binary multinom may return one probability; reconstruct
      pr <- cbind(1-pr,pr)
      colnames(pr) <- classes
    }
  } else if(obj$type=="rf") {
    pr <- predict(obj$model,data=as.data.frame(Xnew))$predictions
  } else if(obj$type=="svm") {
    pr <- predict(obj$model,Xnew,type="probabilities")
  } else if(obj$type=="knn") {
    tr <- as.data.frame(obj$X); tr$.y <- obj$y
    te <- as.data.frame(Xnew)
    kn <- kknn::kknn(.y ~ .,train=tr,test=te,k=7,kernel="inv")
    pr <- fitted(kn)
  }

  pr <- as.matrix(pr)
  if(is.null(colnames(pr))) colnames(pr) <- classes

  out <- matrix(0,nrow=nrow(pr),ncol=length(classes),
                dimnames=list(NULL,classes))
  keep <- intersect(colnames(pr),classes)
  out[,keep] <- pr[,keep,drop=FALSE]
  rs <- rowSums(out)
  rs[rs==0] <- 1
  out/rs
}

# ------------------------------------------------------------------------------
# 5. Metrics
# ------------------------------------------------------------------------------

macro_metrics <- function(truth,pred,prob,classes) {
  truth <- as.character(truth)
  pred <- as.character(pred)

  recalls <- map_dbl(classes,function(c) {
    tp <- sum(truth==c & pred==c)
    fn <- sum(truth==c & pred!=c)
    if(tp+fn==0) return(NA_real_)
    tp/(tp+fn)
  })

  precisions <- map_dbl(classes,function(c) {
    tp <- sum(truth==c & pred==c)
    fp <- sum(truth!=c & pred==c)
    if(tp+fp==0) return(0)
    tp/(tp+fp)
  })

  aucs <- map_dbl(seq_along(classes),function(j) {
    c <- classes[j]
    yy <- as.integer(truth==c)
    if(length(unique(yy))<2) return(NA_real_)
    as.numeric(pROC::auc(pROC::roc(yy,prob[,j],quiet=TRUE,direction="<")))
  })

  Y <- outer(truth,classes,"==")*1
  brier <- mean(rowSums((prob-Y)^2))

  tibble(
    Balanced_accuracy=mean(recalls,na.rm=TRUE),
    ROC_AUC=if(all(is.na(aucs))) NA_real_ else mean(aucs,na.rm=TRUE),
    Precision=mean(precisions,na.rm=TRUE),
    Recall=mean(recalls,na.rm=TRUE),
    Brier=brier
  )
}

binary_metrics <- function(truth,pred,pF) {
  y <- as.integer(truth=="F")
  sensitivity <- sum(truth=="F" & pred=="F")/sum(truth=="F")
  specificity <- sum(truth=="NF" & pred=="NF")/sum(truth=="NF")
  precision <- sum(truth=="F" & pred=="F")/max(1,sum(pred=="F"))
  auc <- as.numeric(pROC::auc(pROC::roc(y,pF,quiet=TRUE,direction="<")))
  tibble(
    Balanced_accuracy=(sensitivity+specificity)/2,
    ROC_AUC=auc,
    Precision=precision,
    Recall=sensitivity,
    Brier=mean((pF-y)^2)
  )
}

evaluate_probs <- function(truth,prob,classes) {
  pred <- classes[max.col(prob,ties.method="first")]
  if(identical(classes,c("NF","F"))) {
    binary_metrics(truth,pred,prob[,"F"])
  } else {
    macro_metrics(truth,pred,prob,classes)
  }
}

# ------------------------------------------------------------------------------
# 6. 5 runs x 3-fold grouped CV
# ------------------------------------------------------------------------------

cv_rows <- list()
counter <- 1

for(task_name in names(task_defs)) {
  td <- task_defs[[task_name]]
  base <- td$filter(reference)
  label_col <- td$label
  classes <- td$classes

  for(run in 1:5) {
    set.seed(70000 + match(task_name,names(task_defs))*100 + run)

    folds <- rsample::group_vfold_cv(
      base, group=site_name, v=3,
      strata=all_of(label_col)
    )

    for(fold_i in seq_len(nrow(folds))) {
      tr <- analysis(folds$splits[[fold_i]])
      te <- assessment(folds$splits[[fold_i]])

      for(model_name in models) {
        for(space in names(feature_sets)) {
          vars <- feature_sets[[space]]
          pp <- prep_fit(tr,te,vars)

          mod <- fit_classifier(
            model_name,pp$Xtrain,tr[[label_col]],balanced=TRUE
          )
          prob <- predict_classifier(mod,pp$Xnew)

          # align columns
          aligned <- matrix(0,nrow(prob),length(classes),
                            dimnames=list(NULL,classes))
          aligned[,intersect(classes,colnames(prob))] <-
            prob[,intersect(classes,colnames(prob)),drop=FALSE]

          met <- evaluate_probs(te[[label_col]],aligned,classes)

          cv_rows[[counter]] <- bind_cols(
            tibble(
              Task=task_name,Run=run,Fold=fold_i,
              Model=model_name,Feature_space=space
            ),
            met
          )
          counter <- counter+1
        }
      }
    }
  }
}

cv_metrics <- bind_rows(cv_rows)

cv_summary <- cv_metrics %>%
  group_by(Task,Model,Feature_space) %>%
  summarise(
    across(
      c(Balanced_accuracy,ROC_AUC,Precision,Recall,Brier),
      list(mean=~mean(.x,na.rm=TRUE),sd=~sd(.x,na.rm=TRUE))
    ),
    .groups="drop"
  )

write_csv(cv_metrics,file.path(OUT_DIR,"groupedCV_fold_metrics.csv"))
write_csv(cv_summary,file.path(OUT_DIR,"groupedCV_performance.csv"))

# ------------------------------------------------------------------------------
# 7. Cross-fitted Mondrian conformal prediction
# ------------------------------------------------------------------------------

qhat <- function(scores,alpha=.10) {
  scores <- sort(scores)
  n <- length(scores)
  if(n==0) return(1)
  k <- ceiling((n+1)*(1-alpha))
  if(k>n) return(1)
  scores[k]
}

conformal_cal <- list()
conformal_unknown <- list()
conformal_test <- list()
threshold_rows <- list()
cc <- 1; cu <- 1; ct <- 1; cq <- 1

for(task_name in names(task_defs)) {
  td <- task_defs[[task_name]]
  base <- td$filter(reference)
  label_col <- td$label
  classes <- td$classes

  test_task <- if(task_name=="NF three-class") {
    td$filter(labelled_test)
  } else {
    labelled_test
  }

  for(run in 1:5) {
    set.seed(80000 + match(task_name,names(task_defs))*100 + run)
    folds <- rsample::group_vfold_cv(
      base, group=site_name, v=3,
      strata=all_of(label_col)
    )

    for(model_name in models) {
      for(space in names(feature_sets)) {
        vars <- feature_sets[[space]]
        oof <- matrix(NA_real_,nrow(base),length(classes),
                      dimnames=list(NULL,classes))

        # Cross-fitted probabilities.
        # Match assessment rows by a temporary unique row id.
        base2 <- base %>% mutate(.rowid=row_number())

        folds2 <- rsample::group_vfold_cv(
          base2, group=site_name, v=3,
          strata=all_of(label_col)
        )

        for(fold_i in seq_len(nrow(folds2))) {
          tr <- analysis(folds2$splits[[fold_i]])
          te <- assessment(folds2$splits[[fold_i]])

          pp <- prep_fit(tr,te,vars)
          mod <- fit_classifier(
            model_name,pp$Xtrain,tr[[label_col]],balanced=TRUE
          )
          pr <- predict_classifier(mod,pp$Xnew)

          aligned <- matrix(0,nrow(pr),length(classes),
                            dimnames=list(NULL,classes))
          aligned[,intersect(classes,colnames(pr))] <-
            pr[,intersect(classes,colnames(pr)),drop=FALSE]

          oof[te$.rowid,] <- aligned
        }

        qs <- map_dbl(classes,function(c) {
          j <- match(c,classes)
          ix <- base2[[label_col]]==c
          qhat(1-oof[ix,j],alpha=.10)
        })
        names(qs) <- classes

        for(c in classes) {
          threshold_rows[[cq]] <- tibble(
            Task=task_name,Run=run,Model=model_name,Feature_space=space,
            Class=c,Calibration_n=sum(base2[[label_col]]==c),
            qhat=qs[c],Min_probability_for_inclusion=1-qs[c]
          )
          cq <- cq+1
        }

        # Cross-fit calibration-set diagnostics
        for(i in seq_len(nrow(base2))) {
          inc <- classes[(1-oof[i,]) <= qs]
          conformal_cal[[cc]] <- tibble(
            Task=task_name,Run=run,Model=model_name,Feature_space=space,
            site_name=base2$site_name[i],
            True_label=base2[[label_col]][i],
            Set=paste0("{",paste(inc,collapse=","),"}"),
            Set_size=length(inc),
            Covered=base2[[label_col]][i] %in% inc
          )
          cc <- cc+1
        }

        # Fit on all reference
        ppu <- prep_fit(base,unknown,vars)
        mod_full <- fit_classifier(
          model_name,ppu$Xtrain,base[[label_col]],balanced=TRUE
        )
        pru <- predict_classifier(mod_full,ppu$Xnew)

        au <- matrix(0,nrow(pru),length(classes),dimnames=list(NULL,classes))
        au[,intersect(classes,colnames(pru))] <-
          pru[,intersect(classes,colnames(pru)),drop=FALSE]

        for(i in seq_len(nrow(unknown))) {
          inc <- classes[(1-au[i,]) <= qs]
          z <- tibble(
            Task=task_name,Run=run,Model=model_name,Feature_space=space,
            site_name=unknown$site_name[i],
            Set=paste0("{",paste(inc,collapse=","),"}"),
            Set_size=length(inc)
          )
          for(j in seq_along(classes)) z[[paste0("P_",classes[j])]] <- au[i,j]
          conformal_unknown[[cu]] <- z
          cu <- cu+1
        }

        # Held-out labelled tests
        ppt <- prep_fit(base,test_task,vars)
        prt <- predict_classifier(mod_full,ppt$Xnew)
        at <- matrix(0,nrow(prt),length(classes),dimnames=list(NULL,classes))
        at[,intersect(classes,colnames(prt))] <-
          prt[,intersect(classes,colnames(prt)),drop=FALSE]

        for(i in seq_len(nrow(test_task))) {
          inc <- classes[(1-at[i,]) <= qs]
          z <- tibble(
            Task=task_name,Run=run,Model=model_name,Feature_space=space,
            site_name=test_task$site_name[i],
            layer_name=test_task$layer_name[i],
            True_label=test_task[[label_col]][i],
            Set=paste0("{",paste(inc,collapse=","),"}"),
            Set_size=length(inc),
            Covered=test_task[[label_col]][i] %in% inc
          )
          for(j in seq_along(classes)) z[[paste0("P_",classes[j])]] <- at[i,j]
          conformal_test[[ct]] <- z
          ct <- ct+1
        }
      }
    }
  }
}

conformal_cal <- bind_rows(conformal_cal)
conformal_unknown <- bind_rows(conformal_unknown)
conformal_test <- bind_rows(conformal_test)
conformal_thresholds <- bind_rows(threshold_rows)

write_csv(conformal_cal,file.path(OUT_DIR,"conformal_crossfit_records.csv"))
write_csv(conformal_unknown,file.path(OUT_DIR,"conformal_unknown_5runs.csv"))
write_csv(conformal_test,file.path(OUT_DIR,"conformal_labelled_test_5runs.csv"))
write_csv(conformal_thresholds,file.path(OUT_DIR,"conformal_thresholds_5runs.csv"))

conformal_summary <- conformal_cal %>%
  group_by(Task,Model,Feature_space) %>%
  summarise(
    Crossfit_coverage=mean(Covered),
    Singleton_rate=mean(Set_size==1),
    Mean_set_size=mean(Set_size),
    .groups="drop"
  )
write_csv(conformal_summary,file.path(OUT_DIR,"conformal_crossfit_summary.csv"))

test_conformal_summary <- conformal_test %>%
  group_by(Task,Model,Feature_space) %>%
  summarise(
    Test_coverage=mean(Covered),
    Test_singleton_rate=mean(Set_size==1),
    Test_mean_set_size=mean(Set_size),
    .groups="drop"
  )
write_csv(test_conformal_summary,
          file.path(OUT_DIR,"conformal_labelled_test_summary.csv"))

# ------------------------------------------------------------------------------
# 8. Five-run class-balanced bootstrap labelled-test stress test
# ------------------------------------------------------------------------------

balanced_bootstrap <- function(data,label_col,classes,seed) {
  set.seed(seed)
  counts <- map_int(classes,~sum(data[[label_col]]==.x))
  target <- round(mean(counts))
  bind_rows(map(classes,function(c) {
    z <- data %>% filter(.data[[label_col]]==c)
    z[sample(seq_len(nrow(z)),size=target,replace=TRUE),,drop=FALSE]
  })) %>% slice_sample(prop=1)
}

balanced_test_rows <- list()
bb <- 1

for(task_name in names(task_defs)) {
  td <- task_defs[[task_name]]
  base <- td$filter(reference)
  classes <- td$classes
  label_col <- td$label
  test_task <- if(task_name=="NF three-class") td$filter(labelled_test) else labelled_test

  for(run in 1:5) {
    train <- balanced_bootstrap(
      base,label_col,classes,
      seed=90000 + match(task_name,names(task_defs))*100 + run
    )

    for(model_name in models) {
      for(space in names(feature_sets)) {
        vars <- feature_sets[[space]]
        pp <- prep_fit(train,test_task,vars)
        mod <- fit_classifier(
          model_name,pp$Xtrain,train[[label_col]],
          balanced=FALSE
        )
        pr <- predict_classifier(mod,pp$Xnew)

        aligned <- matrix(0,nrow(pr),length(classes),
                          dimnames=list(NULL,classes))
        aligned[,intersect(classes,colnames(pr))] <-
          pr[,intersect(classes,colnames(pr)),drop=FALSE]

        pred <- classes[max.col(aligned,ties.method="first")]

        for(i in seq_len(nrow(test_task))) {
          z <- tibble(
            Task=task_name,Run=run,Model=model_name,Feature_space=space,
            site_name=test_task$site_name[i],
            layer_name=test_task$layer_name[i],
            True_label=test_task[[label_col]][i],
            Pred_label=pred[i]
          )
          for(j in seq_along(classes)) z[[paste0("P_",classes[j])]] <- aligned[i,j]
          balanced_test_rows[[bb]] <- z
          bb <- bb+1
        }
      }
    }
  }
}

balanced_test <- bind_rows(balanced_test_rows)
write_csv(balanced_test,
          file.path(OUT_DIR,"labelled_test_balanced_bootstrap_5runs_predictions.csv"))

# Binary site stability
binary_stability <- balanced_test %>%
  filter(Task=="F vs NF") %>%
  mutate(Correct=Pred_label==True_label) %>%
  group_by(site_name,layer_name,True_label) %>%
  summarise(
    Results=n(),
    Correct_rate=mean(Correct),
    F_prediction_rate=mean(Pred_label=="F"),
    Median_P_F=median(P_F),
    P_F_10=quantile(P_F,.10),
    P_F_90=quantile(P_F,.90),
    .groups="drop"
  )
write_csv(binary_stability,
          file.path(OUT_DIR,"labelled_test_binary_site_stability.csv"))

# ------------------------------------------------------------------------------
# 9. Sima de los Huesos conformal progression in C x evenness
# ------------------------------------------------------------------------------

sima_order <- c(
  "Sima de los Huesos 89","Sima de los Huesos 90",
  "Sima de los Huesos 95","Sima de los Huesos 15",
  "Sima de los Huesos 24","Sima de los Huesos PNAS"
)

sima <- unknown %>%
  filter(site_name %in% sima_order) %>%
  mutate(order=match(site_name,sima_order)) %>%
  arrange(order)

for(model_name in models) {

  th <- conformal_thresholds %>%
    filter(Task=="F vs NF",
           Model==model_name,
           Feature_space=="C + evenness") %>%
    group_by(Class) %>%
    summarise(q=median(qhat),.groups="drop")

  qNF <- th$q[th$Class=="NF"]
  qF <- th$q[th$Class=="F"]

  vars <- c("C_adjusted","Evenness_adjusted")

  xmin <- max(0,min(c(reference$C_adjusted,sima$C_adjusted),na.rm=TRUE)-.04)
  xmax <- min(1,max(c(reference$C_adjusted,sima$C_adjusted),na.rm=TRUE)+.06)
  ymin <- max(0,min(c(reference$Evenness_adjusted,sima$Evenness_adjusted),na.rm=TRUE)-.06)
  ymax <- min(1,max(c(reference$Evenness_adjusted,sima$Evenness_adjusted),na.rm=TRUE)+.06)

  grid <- expand_grid(
    C_adjusted=seq(xmin,xmax,length.out=300),
    Evenness_adjusted=seq(ymin,ymax,length.out=300)
  )

  ppg <- prep_fit(reference,grid,vars)
  mod <- fit_classifier(
    model_name,ppg$Xtrain,reference$binary,
    balanced=TRUE
  )
  pg <- predict_classifier(mod,ppg$Xnew)
  pF <- pg[,"F"]

  grid <- grid %>%
    mutate(
      pF=pF,
      NF_in=pF<=qNF,
      F_in=pF>=(1-qF),
      Set=case_when(
        NF_in & F_in ~ "{NF,F}",
        NF_in ~ "{NF}",
        F_in ~ "{F}",
        TRUE ~ "{}"
      )
    )

  # spline is a visual connection in publication/dataset shorthand order,
  # not archaeological chronology.
  tt <- seq_len(nrow(sima))
  sx <- spline(tt,sima$C_adjusted,n=250,method="natural")
  sy <- spline(tt,sima$Evenness_adjusted,n=250,method="natural")
  spline_df <- tibble(C_adjusted=sx$y,Evenness_adjusted=sy$y)

  gp <- ggplot() +
    geom_raster(
      data=grid,
      aes(C_adjusted,Evenness_adjusted,fill=Set),
      alpha=.24
    ) +
    geom_point(
      data=reference,
      aes(C_adjusted,Evenness_adjusted,shape=binary),
      alpha=.30,size=2
    ) +
    geom_path(
      data=spline_df,
      aes(C_adjusted,Evenness_adjusted),
      linewidth=1.1
    ) +
    geom_point(
      data=sima,
      aes(C_adjusted,Evenness_adjusted),
      shape=4,size=3
    ) +
    ggrepel::geom_text_repel(
      data=sima,
      aes(C_adjusted,Evenness_adjusted,
          label=str_remove(site_name,"Sima de los Huesos ")),
      size=3
    ) +
    labs(
      x="Mean skeletal-part abundance C",
      y="Anatomical evenness",
      title=paste0(model_name,": 90% Mondrian conformal map"),
      subtitle=paste0(
        "Sima spline order: 89 → 90 → 95 → 15 → 24 → PNAS; ",
        "F included at P(F)≥",round(1-qF,3),
        ", NF included at P(F)≤",round(qNF,3)
      )
    ) +
    theme_bw()

  ggsave(
    file.path(
      OUT_DIR,
      paste0("conformal_sima_progression_",make.names(model_name),".png")
    ),
    gp,width=10.5,height=7.5,dpi=300
  )
}

message("Finished. Outputs written to: ",OUT_DIR)
