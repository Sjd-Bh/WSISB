rm(list = ls())
##########################################
source("/home/montazeri/Bahonar/WSISB/WSI/model/requiredFunction.R")

library(rhdf5)
supertiles <- h5read("/home/montazeri/mnt_server/data_from_authors/TCGA_slic_100.h5","X")
load("/home/montazeri/Bahonar/results/GSVA_DA_PA/gsva.RData")
y <- t(gsa)

#load("supertile.RData")
#load("y.RData")
#y <- gsva
#supertiles <- supertile
#save_folder = "../results/data/"
#saveFolder = "../lassoModel/"

save_folder = "/home/montazeri/results/data/"
saveFolder = "/home/montazeri/results/lassoModel/"


dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
dir.create(saveFolder, recursive = TRUE, showWarnings = FALSE)


repetition = 5
numOfSamples = dim(supertiles)[3]
for (i in 1:repetition) {
  
  ### TrainTest_index
  TrainTestIdx = TrainTestIdxProducer(numOfSamples)
  save(TrainTestIdx,file = paste0(save_folder,"split",i,".RData"))
  fname = paste0(saveFolder,"split",i,".RData")
  
  if(!file.exists(fname)){
    ### train_test splitting and lasso model
    print(i)
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