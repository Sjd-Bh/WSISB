rm(list=ls())

source("code/constantSettings_dataGeneration/constantSettings.R")
source("code/simulation/simulateDataMulticategorial.R")
##########################################################
## save setting 
pPos <- list(rep(0.4,2),rep(0.45,4), rep(0.45,6))
pRisk <- list(c(0.7,0.3),c(0.4,0.2,0.1,0.1), rep(1/6, 6))

dir.create("../../balancesetting/", recursive = TRUE, showWarnings = FALSE)
set.seed(10)
constantSettings <- constantSetting(3,pPos,pRisk, 20)

for (i in 1:length(constantSettings)) {
  constantSet <- constantSettings[[i]]
  class(constantSet) <- "simsetting"
  save(constantSet, file = paste0("../../BalanceSetting/simulationSetting", i, ".RData"))
}

###########################################################
rm(list=ls())

source("code/simulation/simulateDataMulticategorial.R")
filename <- "../../balancesetting/"
Files <- list.files(filename,full.names = TRUE)

## data generation

dir.create("../../generatedBalanceData", recursive = TRUE, showWarnings = FALSE)

set.seed(10)

for (i in 1:length(Files)) {
  load(Files[i])
  if(class(constantSet)=="simsetting"){
    trainData <- dataGeneration(10,1000,constantSet)
    testData <- dataGeneration(10,1000,constantSet)
    save(trainData, testData, file = paste0("../../generatedBalanceData/data", i, ".RData"))
  }
}
##################################################################








