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

##########GSVA
##script is based on TCGAbiolinks data downloads


##########edgeR
##exp data
TCGAdata <- t(allData[,1:30839])

##groups
samples <- allData[,Sample.ID]
StGr <- TCGAstageGrade(sampleIDs)
errStages <- which(StGr[,1]=="not reported")
groups <- StGr[-errStages]

##edited data
TCGAdata <- TCGAdata[,-errStages]

##edger
diffExpGenes <- DEG(TCGAdata,groups)

#####gprofiler
gp <- gprofileR()

##################################################
