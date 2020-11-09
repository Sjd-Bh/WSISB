rm(list=ls())
# source("code/pooling/poolingFunctions/simplePooling.R")
# source("code/pooling/poolingFunctions/poolingBasedOnLogisticRegProb.R")
# 
#
# source("code/pooling/poolingFunctions/PoolingBasedOnDataClustering.R")

source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/requiredTestNumBasedOnPooling/testNumberOfPooling.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/requiredTestNumBasedOnPooling/testNumOnPoolDataFun.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingOnData/poolingOnDataFunction.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/requiredPoolingFun.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/simplePooling.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/Simulation/constantSettings_dataGeneration/simple/constantSetting.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/Simulation/generateSimulationData/simpleSimulateDataMulticategorial.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/poolingBasedOnLogisticRegProb2.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/poolingBasedOnLogisticRegProb3.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/DorfPooling.r")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/LogisticModel.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/ClassificationFunctions.r")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/clustering/functions.R")


runPoolingMethod <- function(train, test, poolFnName, Ntrain, Ntest, ... ) {
  poolingFn = get(poolFnName)
  
  poolingList = poolingFn(train$x, as.numeric(as.character(train$y)), test$x,...)
  testNum = computeTestNum(poolingList, test$y)
  testNum
}

simulateTestingData<- function(Ntrain, Ntest, low_prev, hl_pos_ratio, pRiskVec, nFeatures) {
  high_prev = hl_pos_ratio * low_prev
  pPosVec = c(low_prev, high_prev)

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


runModels <- function(maxRep, N, preval, ratio, Ntest, pRiskVec, nFeatures, probMethod) {
  perf = matrix(NA, maxRep, 8)
  colnames(perf) = c("Ntrain", "preval", "ratio", "HP", "LrIPW", "TOD", "PSOD","CP")
  perf = data.frame(perf)
  perf$Ntrain = N
  perf$preval = preval
  perf$ratio = ratio
  
  for( i in 1:maxRep) {
    print(i)
    sData <- simulateTestingData(Ntrain=perf$Ntrain[i], Ntest, low_prev=perf$preval[i], 
                                 hl_pos_ratio=perf$ratio[i], pRiskVec, nFeatures)
    p1 = runPoolingMethod(sData$trainData, sData$testData, "simplePooling", Ntrain, Ntest)
    p2 = runPoolingMethod(sData$trainData, sData$testData, "poolingBasedOnLogisticProb3", Ntrain, Ntest, probMethod=probMethod )
    p3 = runPoolingMethod(sData$trainData, sData$testData, "DorfPooling", Ntrain, Ntest ,method="TOD", probMethod=probMethod )
    p4 = runPoolingMethod(sData$trainData, sData$testData, "DorfPooling", Ntrain, Ntest ,method="PSOD", probMethod=probMethod )
    p5= runPoolingMethod(sData$trainData, sData$testData, "clusterPooling", Ntrain, Ntest)
    perf[i, c("HP", "LrIPW", "TOD", "PSOD","CP") ] = c(p1, p2, p3, p4,p5)
  }
  perf
}

plotPerf <- function(df, xCol, y_low, y_high, xlab, ylab, legend=TRUE) {
  df$V = V_list = df[, xCol]
  loessSP <- loess(HP ~ V, data=df, span=0.25) # 25% smoothing span
  loessIP2 <- loess(LrIPW ~ V, data=df, span=0.25) # 25% smoothing span
  loessTOD <- loess(TOD ~ V, data=df, span=0.25) # 25% smoothing span
  loessPSOD <- loess(PSOD ~ V, data=df, span=0.25) # 25% smoothing span
  loessCP <- loess(CP ~ V, data=df, span=0.25) # 25% smoothing span
  
  smoothedSP <- predict(loessSP, V_list) 
  smoothedIP2 <- predict(loessIP2, V_list) 
  smoothedTOD <- predict(loessTOD, V_list)
  smoothedPSOD <- predict(loessPSOD, V_list)
  smoothedCP <- predict(loessCP, V_list)
  
  # plot(economics$uempmed, x=economics$date, type="l", main="Loess Smoothing and Prediction", xlab="Date", ylab="Unemployment (Median)")
  
  plot(smoothedSP, x=V_list, col="red", ylim = c(y_low, y_high), type='l', lwd=2, xlab=xlab, ylab=ylab)
  lines(smoothedIP2, x=V_list, col="green", lwd=2)
  lines(smoothedTOD, x=V_list, col="blue", lwd=2)
  lines(smoothedPSOD, x=V_list, col="orange", lwd=2)
  lines(smoothedCP, x=V_list, col="pink", lwd=2)
  if(legend)
  legend("topleft", lwd=2, c("HP","LrIPW","TOD", "PSOD","CP"), col=c("red", "green", "blue", "orange","pink"), cex=0.8)
}


# Goal of this script: generate figures 
# 1) perf against N with fixed baseline prevalence 0.01 and h/l ratio 10
# 2) perf against prevalence with fixed N=30k and h/l ratio 10
# 3) perf against high/low prevalence ratio with fixed N = 30k and baseline prevalence 0.01

# step 1: 

set.seed(10)
probMethod = "LR"
hl_pos_ratio = 10
low_prev = 0.02
Ntrain = 10000
Ntest  = 10000
pRiskVec = c(0.7,0.3)
nFeatures <- c(rep(4, 1),rep(4,1))

maxRep = 1000
All_N = 300:30000
N_List = sort(sample(All_N, maxRep))
perfN =  runModels(maxRep = maxRep, N=N_List, preval=low_prev, ratio=hl_pos_ratio, Ntest=Ntest, pRiskVec=pRiskVec, nFeatures=nFeatures, probMethod = probMethod)

#df = data.frame(perfN)
#plotPerf(df, xCol="Ntrain", 4500, 6000, xlab="N", ylab="#Tests per individual")

# prevalence
prev_all = seq(0.001, 0.05, length.out = 1000)
prev_List = sort(sample(prev_all, maxRep))
perfPrev =  runModels(maxRep = maxRep, N=Ntrain, preval=prev_List, ratio=hl_pos_ratio, Ntest=Ntest, pRiskVec=pRiskVec, nFeatures=nFeatures)

#df = data.frame(perfPrev)
#plotPerf(df, xCol="preval", 1000, 9000, xlab="prevalence of low-risk group", ylab="#Tests per individual")


# ratio

ratio_all = seq(1, 30, length.out = 1000)
ratio_List = sort(sample(ratio_all, maxRep))
perfRatio =  runModels(maxRep = maxRep, N=Ntrain, preval=low_prev, ratio=ratio_List, Ntest=Ntest, pRiskVec=pRiskVec, nFeatures=nFeatures)

#df = data.frame(perfRatio)
#plotPerf(df, xCol="ratio", 1000, 9000, xlab="prevalence ratio of high/low groups", ylab="#Tests per individual" )

dir.create("/home/montazeri/Bahonar/results/CV/", showWarnings = FALSE, recursive = TRUE)
save(perfN, perfPrev, perfRatio, file="/home/montazeri/Bahonar/results/CV/perfs.RData" )
