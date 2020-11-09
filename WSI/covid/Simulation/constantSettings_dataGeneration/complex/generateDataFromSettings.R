rm(list=ls())

source("code/Simulation/constantSettings_dataGeneration/complex/constantSettings.R")
source("code/Simulation/generateSimulationData/simulateDataMulticategorial.R")
##########################################################
## save setting 
pPos <- list(c(0.01,0.1),c(0.005,0.02,0.08,0.15), c(0.005,0.01,0.02,0.03,0.05,0.15))
pRisk <- list(c(0.7,0.3),c(0.4,0.2,0.1,0.1), rep(1/6, 6))

Folder <- "../../simulationSetting/complex"
dir.create(Folder, recursive = TRUE, showWarnings = FALSE)
set.seed(10)
constantSettings <- constantSetting(3,pPos,pRisk, 20)

for (i in 1:length(constantSettings)) {
  constantSet <- constantSettings[[i]]
  class(constantSet) <- "simsetting"
  save(constantSet, file = paste0("../../simulationSetting/complex/simulationSetting", i, ".RData"))
}

###########################################################
filename <- "../../simulationSetting/complex"
Files <- list.files(filename,full.names = TRUE)

## data generation
baseFolder <- "../../generatedData/complexSettings"
dir.create(baseFolder, recursive = TRUE, showWarnings = FALSE)

set.seed(10)

for (i in 1:length(Files)) {
  load(Files[i])
  if(class(constantSet)=="simsetting"){
    trainData <- dataGeneration(10,10000,constantSet)
    testData <- dataGeneration(10,10000,constantSet)
    save(trainData, testData, file = paste0("../../generatedData/complexSettings/data", i, ".RData"))
  }
}

###########################################################
