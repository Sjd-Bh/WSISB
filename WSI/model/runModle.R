for (i in 1:repetition) {
  TrainTest = TrainTestProducer(x,y)
  save(TrainTest,file = "")
}

TrainTestProducer <- function(x,y){
  n = nrow(x)
  nTrain = sample(1:2*n,n)
  nTest = setdiff(1:2*n,nTrain)
  
  return(list(xTrain = x[nTrain,],
              yTrain = y[nTrain,],
              xTest = x[nTest,],
              yTest = y[nTest,]))
}