rm(list = ls())

##################################################
library("data.table")
library("readr")
##################################################

allData <- fread("../../../mnt_server/data_from_authors/all_transcriptomes.csv", showProgress = FALSE)
