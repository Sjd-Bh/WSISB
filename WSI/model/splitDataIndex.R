rm(list = ls())

source("/home/montazeri/WSISB/WSI/model/requiredFunction.R")

#library(rhdf5)

#supertiles <- h5read("/mnt/montazeri/data_from_authors/TCGA_slic_100.h5","X")
set.seed(12345)
save_folder = "/home/montazeri/results/data/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)

repetition=5
for (i in 1:repetition) {
  TrainTestIdx = TrainTestIdxProducer(10)
  save(TrainTestIdx,file = paste("model/","l",i,".RData"))
}
