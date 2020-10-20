rm(list = ls())

source("RNAseqAnalysis/InstallPackages.R")
source("RNAseqAnalysis/edgeR.R")
source("RNAseqAnalysis/gprofileR.R")
source("RNAseqAnalysis/TCGAstageGrade.R")
source("RNAseqAnalysis/GSVA.R")
##################################################
library("data.table")
library("readr")
##################################################

allData <- fread("../all_transcriptomes.csv", showProgress = FALSE)

#####GSVA
##script is based on TCGAbiolinks data downloads


##edgeR



##gprofiler




##################################################
samples <- allData[,Sample.ID]
StGr <- TCGAstageGrade(sampleIDs)



##################################################
length(which(StGr[,1]=="not reported"))
