rm(list = ls())
#!/usr/bin/env Rscript

#source("/home/montazeri/WSISB/WSI/GSVA_DA_PA/InstallPackages.R")
source("/home/montazeri/WSISB/WSI/GSVA_DA_PA/requiredFunctions.R")

#### libraries
library(data.table)
library(readr)
##################################################################
#### read RNAseq data
fname <-  "/mnt/montazeri/data_from_authors/all_transcriptomes.csv"
allData <- fread(fname, showProgress = FALSE)

## prepare count table
seqData <- as.matrix(allData[,1:30839])
ensID <- sapply(strsplit(colnames(seqData[]),".",fixed=TRUE), "[", 1)
colnames(seqData) <- EnsToGene(ensID)
rownames(seqData) <- as.vector(as.matrix(allData[,"Sample.ID"]))
seqData <- t(seqData)

save_folder = "/home/montazeri/results/data"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(seqData,file = "/home/montazeri/results/data/countTable.RData")

##################################################################
#### differential expression analysis
##groups
samples <- allData[,"Sample.ID"]
StGr <- TCGAstageGrade(as.vector(as.matrix((samples))))
errStages <- which(StGr[,1]=="not reported")
groups <- as.vecor(as.matrix(StGr[-errStages]))

##edited data
TCGAdata <- seqData[,-errStages]

##edger
diffExpGenes <- DEG(TCGAdata,groups)

##Save
#save_folder = "/home/montazeri/results/groundTruth/"
#dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
#save(diffExpGenes,file = "/home/montazeri/results/groundTruth/DEG.RData")

###################################################################
#### pathway analysis
gp <- gprofileR(diffExpGenes)
save(gp,file = "/home/montazeri/results/groundTruth/gprofiler.RData")
