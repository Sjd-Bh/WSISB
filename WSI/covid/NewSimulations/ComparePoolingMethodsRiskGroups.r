rm(list=ls())
# source("code/pooling/poolingFunctions/simplePooling.R")
# source("code/pooling/poolingFunctions/poolingBasedOnLogisticRegProb.R")
# 
#
# source("code/pooling/poolingFunctions/PoolingBasedOnDataClustering.R")

source("code/pooling/requiredTestNumBasedOnPooling/testNumberOfPooling.R")
source("code/pooling/requiredTestNumBasedOnPooling/testNumOnPoolDataFun.R")
source("code/pooling/poolingOnData/poolingOnDataFunction.R")
source("code/pooling/poolingFunctions/requiredPoolingFun.R")
source("code/pooling/poolingFunctions/simplePooling.R")
source("code/Simulation/constantSettings_dataGeneration/simple/constantSetting.R")
source("code/Simulation/generateSimulationData/simpleSimulateDataMulticategorial.R")
source("code/pooling/poolingFunctions/poolingBasedOnLogisticRegProb2.R")
source("code/pooling/poolingFunctions/poolingBasedOnLogisticRegProb3.R")
source("code/pooling/poolingFunctions/DorfPooling.r")
source("code/DataClassification/classificationModelFunctions/LogisticModel.R")
source("code/DataClassification/classificationModelFunctions/ClassificationFunctions.r")

runPoolingMethod <- function(train, test, poolFnName, Ntrain, Ntest, ... ) {
  poolingFn = get(poolFnName)
  
  poolingList = poolingFn(train$x, train$y, test$x, ...)
  testNum = computeTestNum(poolingList, test$y)
  testNum
}

simulateTestingDataMulti <- function(Ntrain, Ntest, pRiskVec, pPosVec, nFeatures) {

  settingList <- list(pPosVec= pPosVec,
                      pRiskVec = pRiskVec,
                      probsList = probListIndep(nFeatures, Min=0.6,Max=0.9),
                      UnifProb=unifProb(Min=0.1,Max=0.3),
                      numFeatures=nFeatures, 
                      numTotalFeatures=sum(nFeatures)+2)
  
  trainData = simulateDataMulticategorial(Ntrain, settingList)
  testData = simulateDataMulticategorial(Ntest, settingList)
  list(trainData=trainData, testData=testData)
}


runModelsMulti <- function(maxRep, N, Ntest, pRiskVec, pPosVec, nFeatures) {
  probMethod = "LR"
  perf = matrix(NA, maxRep, 6)
  colnames(perf) = c("Ntrain", "riskNr", "SP", "IP2", "TOD", "PSOD")
  perf = data.frame(perf)
  perf$Ntrain = N
  perf$riskNr = length(nFeatures)

  for( i in 1:maxRep) {
    print(i)
    sData <- simulateTestingDataMulti(Ntrain=perf$Ntrain[i], Ntest, pRiskVec, pPosVec, nFeatures)
    p1 = runPoolingMethod(sData$trainData, sData$testData, "simplePooling", Ntrain, Ntest)
    p2 = runPoolingMethod(sData$trainData, sData$testData, "poolingBasedOnLogisticProb3", Ntrain, Ntest, probMethod=probMethod )
    p3 = runPoolingMethod(sData$trainData, sData$testData, "DorfPooling", Ntrain, Ntest ,method="TOD", probMethod=probMethod )
    p4 = runPoolingMethod(sData$trainData, sData$testData, "DorfPooling", Ntrain, Ntest ,method="PSOD", probMethod=probMethod )
    
    
    perf[i, c("SP", "IP2", "TOD", "PSOD") ] = c(p1, p2, p3, p4)
  }
  perf
}

# Goal of this script: generate figures 
# 1) perf against N with fixed baseline prevalence 0.01 and h/l ratio 10
# 2) perf against prevalence with fixed N=30k and h/l ratio 10
# 3) perf against high/low prevalence ratio with fixed N = 30k and baseline prevalence 0.01

# step 1: 

set.seed(10)

hl_pos_ratio = 10
low_prev = 0.02
Ntrain = 100000
Ntest  = 10000
pRiskVec = c(0.7,0.3)
nFeatures <- c(rep(4, 1),rep(4,1))


perfRisks = NULL

maxRep = 10

# different risk groups
for(nrRisk in 2:8) {
  nFeatures <- rep(2, nrRisk)
  pRiskVec = rep(1/nrRisk, nrRisk)
  pPosVec = 0.2 * exp(seq(0, -nrRisk+1))
  pPosVec = 0.1* pPosVec/mean(pPosVec)

  tmp = runModelsMulti(maxRep = maxRep, N=Ntrain, Ntest=Ntest, pRiskVec=pRiskVec, pPosVec=pPosVec, nFeatures=nFeatures)    
  if(is.null(perfRisks)) {
      perfRisks = tmp
  } else{
    perfRisks = rbind(perfRisks, tmp)
  }
}


