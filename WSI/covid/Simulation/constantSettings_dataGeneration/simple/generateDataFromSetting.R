rm(list=ls())

source("code/Simulation/constantSettings_dataGeneration/simple/constantSetting.R")
source("code/Simulation/generateSimulationData/simpleSimulateDataMulticategorial.R")
##########################################################
## save setting 
pPos <- list(c(0.01,0.2),c(0.005,0.02,0.08,0.15), c(0.005,0.01,0.02,0.03,0.05,0.15))
pRisk <- list(c(0.7,0.3),c(0.7,0.2,0.1,0.1), c(0.7, rep(0.3/5, 5)))

Folder <- "../../simulationSetting/simple"
dir.create(Folder, recursive = TRUE, showWarnings = FALSE)

set.seed(10)
constantSettings <- constantSetting(3,pPos,pRisk)

for (i in 1:length(constantSettings)) {
  constantSet <- constantSettings[[i]]
  class(constantSet) <- "simsetting"
  save(constantSet, file = paste0("../../SimulationSetting/simple/simulationSetting", i, ".RData"))
}

###########################################################

filename <- "../../SimulationSetting/simple"
Files <- list.files(filename,full.names = TRUE)



## data generation

baseFolder <- "../../generatedData/simpleSettings"
dir.create(baseFolder, recursive = TRUE, showWarnings = FALSE)

set.seed(10)

for (i in 1:length(Files)) {
  load(Files[i])
  if(class(constantSet)=="simsetting"){
    trainData <- dataGeneration(1,1000000,constantSet)
    testData <- dataGeneration(1 ,1000000,constantSet)
    save(trainData, testData, file = paste0("../../generatedData/simpleSettings/data", i, ".RData"))
  }
}

###########################################################
