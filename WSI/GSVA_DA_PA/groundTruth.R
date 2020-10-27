rm(list = ls())
#!/usr/bin/env Rscript

source("GSVA_DA_PA/InstallPackages.R")
source("GSVA_DA_PA/requiredFunctions.R")

#### libraries
library(data.table)
library(readr)
##################################################################
#### read RNAseq data
allData <- fread("../all_transcriptomes.csv", showProgress = FALSE)

## prepare count table
seqData <- as.matrix(allData[,1:30839])
ensID <- sapply(strsplit(colnames(seqData[]),".",fixed=TRUE), "[", 1)
colnames(seqData) <- EnsToGene(ensID)
rownames(seqData) <- as.vector(as.matrix(allData[,"Sample.ID"]))
seqData <- t(seqData)
save_folder = "../data/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(seqData,file = "../data/countTable.RData")

##################################################################
#### differential expression analysis
##groups
samples <- allData[,"Sample.ID"]
StGr <- TCGAstageGrade(sampleIDs)
errStages <- which(StGr[,1]=="not reported")
groups <- StGr[-errStages]

##edited data
TCGAdata <- seqData[,-errStages]

##edger
diffExpGenes <- DEG(TCGAdata,groups)

##Save
save_folder = "../results/groundTruth/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(diffExpGenes,file = "../results/groundTruth/DEG.RData")

###################################################################
#### pathway analysis
gp <- gprofileR(diffExpGenes)
save(gp,file = "../results/groundTruth/gprofiler.RData")
