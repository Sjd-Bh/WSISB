
poolingBasedOnLogisticProb <- function(Xtrain,Ytrain,Xtest, thr=0.15, maxPoolSize=20){
  
  modelFit = logisticRegModel(Xtrain,Ytrain)
  
  ## determination posPrevalence & poolSize
  trainLogisticPred = logisticRegPrediction(modelFit,Xtrain)
  trainPredProb = trainLogisticPred$responseProb
  
  ids = order(trainPredProb, decreasing = TRUE)
  trainSortProb = trainPredProb[ids]
  Ytrain = Ytrain[ids]
  treshold = thr
  
  highRiskL = round(treshold*length(trainSortProb))
  YtrainHigh = Ytrain[1:highRiskL]
  prevalenceHigh <- sum(YtrainHigh==1)/length(YtrainHigh)
  nH <- computeSizeOfPool(prevalenceHigh)
  if(nH > maxPoolSize)
    nH= maxPoolSize
  
  lowRiskL <- length(trainPredProb)-highRiskL
  YtrainLow = Ytrain[(highRiskL+1):length(Ytrain)]
  prevalenceLow = sum(YtrainLow==1)/length(YtrainLow)
  nL <- computeSizeOfPool(prevalenceLow)
  if(nL > maxPoolSize)
    nL= maxPoolSize
  
  tresholdProb = trainSortProb[highRiskL]
  
  ##pooling on testData
  logisticPred = logisticRegPrediction(modelFit,Xtest)
  predictedProb = logisticPred$responseProb
  
  ids = order(predictedProb, decreasing = TRUE)
  
  sortProb = predictedProb[ids]

  high = which(sortProb >= tresholdProb)
  highL = length(high)
  pVec1 = poolVecProducer(nH, highL)
  
  low = which(sortProb < tresholdProb)
  lowL = length(low)       
  pVec2 <- poolVecProducer(nL,lowL)
  
  pool = apend(pVec1,pVec2)
  
  return(list(poolVec= pool$pool,
              NumOfPool=pool$NumOfPool,
              idx=as.numeric(names(sortProb)), 
              probs = sortProb))
}