rm(list = ls())

#library(rhdf5)

#supertiles <- h5read("/mnt/montazeri/data_from_authors/TCGA_slic_100.h5","X")
save_folder = "/home/montazeri/results/data/"

repetition=5
for (i in 1:repetition) {
  TrainTestIdx = TrainTestIdxProducer(10514)
  save(TrainTestIdx,file = paste0(save_folder,"split",i,".RData"))
}
