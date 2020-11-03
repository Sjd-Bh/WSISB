

rm(list = ls())

library(rhdf5)

supertiles <- h5read("/mnt/montazeri/data_from_authors/TCGA_slic_100.h5","X")
save_folder = "/home/montazeri/results/lassoModel/"

for (j in 1:100) {
  x = c()
  for (i in 1:10514) {
    x = rbind(x, as.vector(as.matrix(supertiles[,j,i])))
  }
  #save(x,file = paste0(save_folder,"x",j,".RData"))
  for (z in 1:repetition) {
    TrainTest = TrainTestProducer(x,y)
    save(TrainTest,file = "")
    
    
  }
}

######

for (i in 1:repetition) {
  TrainTest = TrainTestProducer(x,y)
  save(TrainTest,file = "")
}
####

for (j in 1:100) {
  x = c()
  for (i in 1:10514) {
    x = rbind(x, as.vector(as.matrix(supertiles[,j,i])))
  }
  #save(x,file = paste0(save_folder,"x",j,".RData"))
  TrainTest = TrainTestProducer(x,y)
  save(TrainTest,file = paste0(save_folder,"split"))
}


