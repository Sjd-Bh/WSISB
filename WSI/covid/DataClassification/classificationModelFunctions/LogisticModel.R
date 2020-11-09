################################################################################
######################## logistic regression model #############################

logisticRegModel <- function(x,y){
  
  data <- data.frame(cbind(x,y))

  logisticModelFit <- glm(y ~ . , data , family = binomial )
  return(logisticModelFit)
}

logisticRegModelW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  logisticModelFit <- glm(y ~ . , data , family = binomial, weights = w )
  return(logisticModelFit)
}



#############################################################

logisticRegPrediction <- function(modelFit,Xtest){
  
  #colnames(Xtest) <- paste("V", 1:ncol(Xtest), sep = "")
  responseProb <- predict.glm(modelFit, Xtest, type = "response")
  Yprediction <- ifelse(responseProb > 0.5, 1, 0)
  
  return(list(Yhat = as.numeric(Yprediction),
              responseProb = responseProb))
  
}
#############################################################
logisticModelError <- function(Xtrain,Ytrain,Xtest,Ytest){
  
  predicted <- logisticRegression(Xtrain,Ytrain,Xtest)
  predicted <- as.vector(predicted)
  error <- sum(predicted != y_test)/length(predicted)
  
  return(Error)
}