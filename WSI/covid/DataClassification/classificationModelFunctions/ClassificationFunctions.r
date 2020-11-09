source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/Boosting.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/KNN.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/naiveBayes.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/RandomForest.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/SVM.R")
source("/home/montazeri/Bahonar/WSISB/WSI/covid/DataClassification/classificationModelFunctions/LogisticModel.R")

trainProbModel <- function(x, y, probMethod) {
  
  fnNames = c("logisticRegModel",  "naiveBayesClassifier", "RandomForest", "Boosting", "SVM")
  names(fnNames) = c("LR", "NB", "RF", "BO", "SV")
  
  probFn = get(fnNames[probMethod])
  probFn(x, y)
}

predictProbModel <- function(fit, Xtest, probMethod) {
  predFnNames = c("logisticRegPrediction",  "naiveBayesPrediction", "RFPrediction",
                  "BoostingPrediction", "svmPrediction")
  names(predFnNames) = c("LR", "NB", "RF", "BO", "SV")
  
  predFn = get(predFnNames[probMethod])
  predFn(fit, Xtest)
}


trainProbModelW <- function(x, y, probMethod) {
  
  fnNames = c("logisticRegModelW",  "naiveBayesClassifierW", "RandomForestW", "BoostingW", "SVMWeighted")
  names(fnNames) = c("LR", "NB", "RF", "BO", "SV")
  
  probFn = get(fnNames[probMethod])
  probFn(x, as.numeric(as.character(y)))
}
