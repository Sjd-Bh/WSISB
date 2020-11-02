rm(list = ls())
#!/usr/bin/env Rscript

source("/home/montazeri/WSISB/WSI/GSVA_DA_PA/requiredFunctions.R")
load("/home/montazeri/results/mSigDB/mSigDB/C6.RData")
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


### gene set analysis
gsa <- GSA(seqData,m_list,"gsva")

##Save
save_folder = "/home/montazeri/results/GSVA_DA_PA/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(gsa,file = "/home/montazeri/results/GSVA_DA_PA/gsva.RData")