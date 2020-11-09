rm(list=ls())
source("code/modelingOnData/errorRates.R")
##################################################

baseFolder1 = "../../modelResults/"
ResultsFolderNames = list.files(baseFolder1, full.names = TRUE)
shortFileNames = list.files(baseFolder1)
dir.create("../../DataForPlotting")
dir.create("../../DataForPlotting/errorData/")
errorPath = "../../DataForPlotting/errorData/"

errorRates(ResultsFolderNames, shortFileNames, errorPath)
#################################################






