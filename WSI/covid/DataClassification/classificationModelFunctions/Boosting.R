
########################################################################
library(adabag)
########################################################################
########################### weighted RF ################################
BoostingW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  BoostingFit <- boosting(y ~ . , data , weights = w,boos=TRUE,
                          coeflearn = 'Zhu',mfinal = 3,control=rpart.control(maxdepth=10))
  return(BoostingFit)
}
########################################################################
######################### unweighted RF ################################
Boosting <- function(x,y){
  data <- data.frame(cbind(x,y))
  BoostingtFit <- boosting(y ~ . , data = data,boos=TRUE,
                           coeflearn = 'Zhu',mfinal = 3,control=rpart.control(maxdepth=10))
  return(BoostingtFit)
}
########################################################################
########################### prediction #################################
BoostingPrediction <- function(modelFit,Xtest){
  p1 = predict(modelFit,Xtest,class = "prob")
  prob = p1$prob[,2]
  p2 = p1$class
  return(list(Yhat = p2,
              responseProb = prob))
}

########################################################################