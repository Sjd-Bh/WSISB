
########################################################################
library(randomForest)
require(caTools)
########################################################################
########################### weighted RF ################################
RandomForestW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  randomForestFit <- randomForest(y ~ . , data , weights = w)
  return( randomForestFit)
}
########################################################################
######################### unweighted RF ################################
RandomForest <- function(x,y){
  data <- data.frame(cbind(x,y))
  randomForestFit <- randomForest(y ~ . , data = data)
  return( randomForestFit)
}
########################################################################
########################### prediction #################################
RFPrediction <- function(modelFit,Xtest){
  p1 = predict(modelFit,Xtest,type = "prob")
  prob = p1[,2]
  p2 = predict(modelFit,Xtest)
  return(list(Yhat = p2,
              responseProb = prob))
}

########################################################################

