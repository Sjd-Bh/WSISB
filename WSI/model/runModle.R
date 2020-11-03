rm(list = ls())
##########################################
source("/home/montazeri/WSISB/WSI/model/requiredFunction.R")

library(rhdf5)
supertiles <- h5read("/mnt/montazeri/data_from_authors/TCGA_slic_100.h5","X")
load("/home/montazeri/results/GSVA_DA_PA/gsva.RData")
y <- t(gsa)

save_folder = "/home/montazeri/results/data/"
saveFolder = "/home/montazeri/results/lassoModel/"

dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
dir.create(saveFolder, recursive = TRUE, showWarnings = FALSE)


repetition = 5
numOfSamples = 10514

for (i in 1:repetition) {
  
  ### TrainTest_index
  TrainTestIdx = TrainTestIdxProducer(numOfSamples)
  save(TrainTestIdx,file = paste0(save_folder,"split",i,".RData"))
  fname = paste0(saveFolder,"split",i,".RData")
  
  if(!file.exists(fname)){
    ### train_test splitting and lasso model
    supertilePred <- list()
    for (j in 1:100){
      x <- t(supertiles[,j,])
      Xtrain <- x[TrainTestIdx$nTrain,]
      Ytrain <- y[TrainTestIdx$nTrain,]
      Xtest <- x[TrainTestIdx$nTest,]
      modelFit <- lassoLR(Xtrain,Ytrain)
      pred <- lassoLRpred(modelFit,Xtest)
      supertilePred[[j]] <- pred
    }
    M <- do.call(cbind, supertilePred)
    M <- array(M, dim=c(dim(supertilePred[[1]]), length(supertilePred)))
    WSIpred <- apply(M, c(1, 2), mean, na.rm = TRUE)
    save(WSIpred,file = fname)
  }
}

#####################################################