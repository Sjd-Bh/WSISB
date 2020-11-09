source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/pooling-dorf-org.r")
DorfPooling <- function(Xtrain, Ytrain, Xtest, maxPoolSize=20, method, probMethod){
  
  # fit = logisticRegModel(Xtrain, Ytrain)
  # predicted = logisticRegPrediction(fit, as.data.frame(Xtest))
  fit = trainProbModel(Xtrain, Ytrain, probMethod) 
  predicted = predictProbModel(fit, as.data.frame(Xtest))

  probs = predicted$responseProb
  res = opt.info.dorf(prob=probs, se = 1, sp = 1, method =method, max.pool=maxPoolSize, threshold=NULL)
  poolNumbers = unname(res$summary[ , 1])

  
  
  return(list(poolVec= poolNumbers,
       NumOfPool=length(unique(poolNumbers)),
       idx=1:length(poolNumbers)) )
}
##########################################
