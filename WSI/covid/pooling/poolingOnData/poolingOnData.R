rm(list = ls())

source("code/pooling/poolingFunctions/requiredPoolingFun.R")
source("code/pooling/poolingFunctions/simplePooling.R")
source("code/pooling/poolingFunctions/poolingBasedOnLogisticRegProb.R")
source("code/DataClassification/classificationModelFunctions/LogisticModel.R")
source("code/pooling/poolingFunctions/PoolingBasedOnDataClustering.R")
source("code/pooling/poolingOnData/poolingOnDataFunction.R")

##################################################################
set.seed(10)
dataPath = "../../generatedData/"
savePath = "../../poolingData/"
poolFun <- c("simplePooling","poolingBasedOnLogisticProb","PoolingBasedOnClustering")

poolingOnData(dataPath,savePath,poolFun)
#################################################################
