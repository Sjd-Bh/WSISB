############################################################

SVMWeighted <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  SVMmodel <- svm(y ~ ., data , weights = w,probability = TRUE)
  return(SVMmodel)
}
#############################################################
SVM <- function(x,y){
  
  data <- data.frame(cbind(x,y))
  SVMmodel <- svm(y ~ ., data ,probability = TRUE)
  return(SVMmodel)
}
############################################################
svmPrediction <- function(modelFit,Xtest){
  p1 = predict(modelFit,Xtest, probability=TRUE)
  prob = attr(p1, "probabilities")[,2]
  p2 = predict(modelFit,Xtest)
  return(list(Yhat = p2,
              responseProb = prob))
}
############################################################
