
########################################################################
library(e1071)
########################################################################
########################### weighted NB ################################
naiveBayesClassifierW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  naiveBayesWFit <- naiveBayes(y ~ . , data=data, weight = w)
  return( naiveBayesWFit)
}

########################################################################
########################### unweighted NB ##############################
naiveBayesClassifier <- function(x,y){
  
  data <- data.frame(cbind(x,y))
  
  NaiveBayesModel = naiveBayes(y~., data=data)
  return(NaiveBayesModel)
}
########################################################################
########################### prediction #################################
naiveBayesPrediction <- function(modelFit,Xtest){
  p1 = predict(modelFit,Xtest,"raw")
  prob = p1[,2]
  p2 = predict(modelFit,Xtest)
  return(list(Yhat = p2,
              responseProb = prob))
}

########################################################################
 
