rm(list = ls())

load("code/DataClassification/classificationModelFunctions/data1.RData")
######################################################
source("code/DataClassification/classificationModelFunctions/Boosting.R")
source("code/DataClassification/classificationModelFunctions/KNN.R")
source("code/DataClassification/classificationModelFunctions/naiveBayes.R")
source("code/DataClassification/classificationModelFunctions/RandomForest.R")
source("code/DataClassification/classificationModelFunctions/SVM.R")
source("code/DataClassification/classificationModelFunctions/LogisticModel.R")
source("code/DataClassification/classificationModelFunctions/ClassificationFunctions.r")
######################################################

computeProbabilities <- function(x, y, Xtest, probMethod) {
  if(probMethod == "LR") {
    fit = logisticRegModel(x, y)
    predicted = logisticRegPrediction(fit, Xtest)
  }

  if(probMethod == "NB") {
    fit <- naiveBayesClassifier(x,y)
    predicted <- naiveBayesPrediction(fit, Xtest)
  }
  
  if(probMethod == "RF") {
    RFModel <- RandomForest(x,y)
    predicted <- RFPrediction(RFModel,Xtest)
  }
  
  if(probMethod == "BO") {
    Boost <- Boosting(x,y)
    predicted <- BoostingPrediction(Boost,Xtest)
  }
  
  if(probMethod == "SV") {
    SVMmodel <- SVM(x,y)
    SVMPred <- svmPrediction(SVMmodel,Xtest)
  }
  
  predicted
}


x = trainData[[1]]$x
y = trainData[[1]]$y
Xtest = testData[[1]]$x
#######################################################
naiveModel <- naiveBayesClassifier(x,y)
naiveModelW <- naiveBayesClassifierW(x,y)

naivePred <- naiveBayesPrediction(naiveModel,Xtest)
naivePredW <- naiveBayesPrediction(naiveModelW,Xtest)
naivePredW$responseProb == naivePred$responseProb
#######################################################

RFModel <- RandomForest(x,y)
RFModelW <- RandomForestW(x,y)
RFPred <- RFPrediction(RFModel,Xtest)
RFpredW <- RFPrediction(RFModelW,Xtest)

RFPred$responseProb == RFpredW$responseProb

sum(RFPred$responseProb>0.1)
sum(RFpredW$responseProb>0.1)
#######################################################

Boost <- Boosting(x,y)
BoostW <- BoostingW(x,y)
BoostPred <- BoostingPrediction(Boost,Xtest)
BoostpredW <- BoostingPrediction(BoostW,Xtest)

sum(BoostPred$responseProb>0.5)
sum(BoostpredW$responseProb>0.5)

#######################################################
SVMmodel <- SVM(x,y)
SVMw <- SVMWeighted(x,y)

SVMPred <- svmPrediction(SVMmodel,Xtest)
SVMWPred <- svmPrediction(SVMw,Xtest)

sum(SVMPred$responseProb>0.1)
sum(SVMWPred$responseProb>0.1)

#######################################################



#######################################################
LRmodel <- trainProbModel(x, y, "LR")
LRmodelW <- trainProbModelW(x, y, "LR")

LrPred <- predictProbModel(LRmodel,Xtest, "LR")
LrPredW <- predictProbModel(LRmodelW,Xtest, "LR")

table(LrPred$Yhat)
table(LrPredW$Yhat)
#######################################################


#######################################################
m = "NB"
model <- trainProbModel(x, y, m)
modelW <- trainProbModelW(x, y, m)

pred <- predictProbModel(model,Xtest, m)
predW <- predictProbModel(modelW,Xtest, m)

sum(pred$responseProb > 0.5)
sum(predW$responseProb > 0.5)

all(pred$responseProb == predW$responseProb)

table(y)
table(pred$Yhat)
table(predW$Yhat)

