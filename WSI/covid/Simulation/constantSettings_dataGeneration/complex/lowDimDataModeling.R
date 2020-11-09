rm(list=ls())

source("code/model/LogisticModel.R")
source("code/model/ForwardLogisticModel.R")
source("code/model/naiveBayes.R")
source("code/model/mix2.r")
####################################################


learnModel <- function(modelFun,fileNames,dirNamesSet){
  for (z in 1:length(modelFun)) {
    model = get(modelFun[z])
    dirN = paste0("../../simpleResults/",modelFun[z],"/")
    dir.create(dirN)
    
    for(i in 1:length(fileNames)) {
      
      load(fileNames[i])
      load(dirNamesSet[i])
      DirN = paste0(dirN, "Setting",i)
      dir.create(DirN)
      path = paste(DirN,"/learnedData",sep = "")
      
      for (j in 1:length(trainData)) {
        train <- trainData[[j]]
        test <- testData[[j]]
        
        x <- train$x
        y <- train$y
        colnames(x) <- paste("V", 1:ncol(x), sep = "")
        
        Xtest <- test$x
        Ytest <- test$y
        output <- model(x, y, Xtest)
        
        save( output, Ytest,  file = paste0(path, j, ".RData"))
      }
    }
  }
}
##################################################################

modelFun <- c("logisticRegression","stepForward_logisticR","naiveBayesClassifier","mixtureModel")


baseFolder = "../../generatedSimpleData/"
fileNames = list.files(baseFolder, full.names = TRUE)

dirSetting = "../../simpleSimulationSetting/"
dirNamesSet = list.files(dirSetting,full.names = TRUE)

dir.create("../../simpleResults")

learnModel(modelFun,fileNames,dirNamesSet)
#################################################################