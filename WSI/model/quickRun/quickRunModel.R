rm(list = ls())
##########################################
source("model/required/requiredFunction.R")

load("model/quickRun/data/samples_TCGA_GBM.RData")
load("model/quickRun/data/gsva_TCGA_GBM.RData")
y <- t(gsva)
supertiles <- samples_TCGA_GBM

#load("supertile.RData")
#load("y.RData")
#y <- gsva
#supertiles <- supertile
#save_folder = "../results/data/"
#saveFolder = "../lassoModel/"

save_folder = "../results/data/"
saveFolder = "../results/lassoModel/"


dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
dir.create(saveFolder, recursive = TRUE, showWarnings = FALSE)


repetition = 5
numOfSamples = dim(supertiles)[3]
for (i in 1:repetition) {
  print(i)
  ### TrainTest_index
  TrainTestIdx = TrainTestIdxProducer(numOfSamples)
  save(TrainTestIdx,file = paste0(save_folder,"split",i,".RData"))
  fname = paste0(saveFolder,"split",i,".RData")
  
  if(!file.exists(fname)){
    ### train_test splitting and lasso model
    supertilePred <- list()
    for (j in 1:dim(supertiles)[2]){
      print(j)
      x <- t(supertiles[,j,])
      Xtrain <- x[TrainTestIdx$nTrain,]
      Ytrain <- y[TrainTestIdx$nTrain,]
      Xtest <- x[TrainTestIdx$nTest,]
      modelFit <- lassoLR(Xtrain,Ytrain)
      pred <- predict(modelFit,as.matrix(Xtest))
      supertilePred[[j]] <- pred
    }
    M <- do.call(cbind, supertilePred)
    M <- array(M, dim=c(dim(supertilePred[[1]]), length(supertilePred)))
    WSIpred <- apply(M, c(1, 2), mean, na.rm = TRUE)
    save(WSIpred,file = fname)
  }
}
#####################################################