
findThr <- function(probs) {
  sProbs = probs
  candThrs = seq(0.1, 0.50, length.out = 100)
  
  varOpt = Inf
  for(thr in candThrs) {
    inds_high = 1:round(thr*length(sProbs))
    high = sProbs[inds_high]
    low = sProbs[-inds_high]
    
    varN = sum( (low - mean(low))^2 ) + sum((high - mean(high))^2)
    # varN = sd( low) + sd(high)
    if(varN < varOpt) {
      varOpt = varN
      thrOpt = thr
    }
  }
  thrOpt
}
# #
# # #
# train = sData$trainData
# test = sData$testData
# 
# Xtrain = train$x
# Ytrain = train$y
# 
# # iiTest = 1:100 # sort(sample(nrow(test$x), Ntest))
# Xtest = test$x
# Ytest = test$y
# 
# maxPoolSize=20
# # 

poolingBasedOnLogisticProb2 <- function(Xtrain,Ytrain,Xtest,  maxPoolSize=20){
  
  modelFit = logisticRegModel(Xtrain,Ytrain)
  
  ## determination posPrevalence & poolSize
  trainLogisticPred = logisticRegPrediction(modelFit,Xtrain)
  trainPredProb = trainLogisticPred$responseProb
  
  ids = order(trainPredProb, decreasing = TRUE)
  trainSortProb = trainPredProb[ids]
  Ytrain = Ytrain[ids]
  treshold = findThr(trainSortProb)
  print(treshold)
  
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
  
  poolNrs = rep(NA, length(predictedProb))
  
  high = which(predictedProb >= tresholdProb)
  highL = length(high)
  pVec1 = poolVecProducer(nH, highL)
  
  low = which(predictedProb < tresholdProb)
  lowL = length(low)       
  pVec2 <- poolVecProducer(nL,lowL)
  
  pool = apend(pVec1,pVec2)

  poolNrs = rep(NA, length(predictedProb))
  poolNrs[ids] = pool$pool
  
  return(list(poolVec= poolNrs,
              NumOfPool= pool$NumOfPool))
}