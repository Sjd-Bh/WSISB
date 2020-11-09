rm(list = ls())
source("code/simulation/simulateDataMulticategorial.R")
###########################################################
probList <- function(numFeatures){
  probsList = list()
  for(r in 1:length(numFeatures)) {
    nr_joint_cases = 2^(numFeatures[r])
    probs = abs(rnorm(nr_joint_cases)) 
    probsList[[r]] = probs /sum(probs) 
  }
  return(probsList)
}
#################################################
unifProb <- function(){
  unif_prob <- runif(1,min = 0.1,max=0.9)
  return(unif_prob)
}
#################### constantSetting #####################

constantSetting <- function(n,pPos,pRisk, numTotalFeatures){
  g <- n*2
  nFeatures <- rep(1,g)
  settingList <- list(pPosVec= pPos,
                        pRiskVec = pRisk,
                        probsList = probList(nFeatures),
                        UnifProb=unifProb(),
                        numFeatures=nFeatures, 
                        numTotalFeatures=numTotalFeatures)
    
  return(settingList)
}
############################################################

pPos <- c(0.4,0.45)
pRisk <- c(0.7,0.3)

dir.create("../../simpleSimulationSetting/", recursive = TRUE, showWarnings = FALSE)
set.seed(10)
constantSettings <- constantSetting(1,pPos,pRisk, 3)
save(constantSettings,file = "../../simpleSimulationSetting/setting.RData")
####################################################################################
###################################################################################
filename <- "../../simpleSimulationSetting/"
Files <- list.files(filename,full.names = TRUE)



## data generation

dir.create("../../generatedSimpleData", recursive = TRUE, showWarnings = FALSE)

set.seed(10)
load(Files)
trainData <- dataGeneration(10,1000,constantSettings)
testData <- dataGeneration(10,1000,constantSettings)
save(trainData, testData, file = paste0("../../generatedSimpleData/data.RData"))

  
