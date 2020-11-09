########################################################################
library(kknn)
########################################################################
########################### weighted knn ###############################
KNNModelW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  KNNModelFit <- train.kknn(y ~ ., data, kmax = 15, 
                            kernel = c("triangular", "rectangular", "epanechnikov", "optimal"),
                            distance = 1)
  return( KNNModelFit)
}
########################################################################
######################### unweighted knn  ##############################
library(class)
KNNModel <- function(x,y){
  data <- data.frame(cbind(x,y))
  KNNModelFit <- train.knn(y ~ ., data)
  return( KNNModelFit)
}
########################################################################
########################### prediction #################################
KNNPrediction <- function(modelFit,Xtest){
  p1 = predict(modelFit, Xtest , type = "prob")
  prob = p1[,2]
  p2 = predict(modelFit,Xtest)
  return(list(Yhat = p2,
              responseProb = prob))
}

########################################################################
