rm(list = ls())

source("code/pooling/requiredTestNumBasedOnPooling/testNumberOfPooling.R")
source("code/pooling/requiredTestNumBasedOnPooling/testNumOnPoolDataFun.R")
#######################################################
DataFolder = "../../generatedData/"
poolFolder="../../poolingData/"
savePath = "../../requiredTestNum/"

testNumNeededOnPoolData(poolFolder,DataFolder,savePath)
##############################################################
