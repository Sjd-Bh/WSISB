rm(list = ls())

##################################################
library("data.table")
library("readr")
##################################################

allData <- fread("../all_transcriptomes.csv", showProgress = FALSE)
