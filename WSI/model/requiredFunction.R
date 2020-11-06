library(glmnet)

lassoLR <- function(x,y){
  x <- as.matrix(x)
  y <- as.matrix(y)
  lambda <- 10^seq(3, -3, length.out = 1000)
  inner_CV_for_lambda <- cv.glmnet(x, y, 
                                   alpha = 1, 
                                   lambda = lambda ,
                                   family= "mgaussian")
  
  best_lam <- inner_CV_for_lambda$lambda.min 
  modelFit <- glmnet(x, y, alpha = 1, lambda = best_lam, family="mgaussian")
  
  # y_prediction <- predict(logisticLASSO_R, s = best_lam, newx = test_x , type="class")
  return(modelFit)
}

####

lassoLRpred <- function(modelFit,Xtest){
  Xtest <- as.matrix(Xtest)
  pred <- predict.glmnet(modelFit, Xtest)
  return(pred)
}
#####
TrainTestIdxProducer <- function(NumOfSamples){
  n = round(NumOfSamples/2)
  nTrain = sample(1:NumOfSamples,n)
  nTest = setdiff(1:NumOfSamples,nTrain)
  
  return(list(nTrain = nTrain,
              nTest = nTest))
}
