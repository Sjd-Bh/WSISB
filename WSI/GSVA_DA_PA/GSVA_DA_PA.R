rm(list = ls())
#!/usr/bin/env Rscript

source("/home/montazeri/WSISB/WSI/GSVA_DA_PA/requiredFunctions.R")
source("/home/montazeri/WSISB/WSI/GSVA_DA_PA/geneSetFromMsigDB.R")
load("/home/montazeri/results/data/countTable.RData")
load("/home/montazeri/results/mSigDB/mSigDB/C6.RData")

##################################################
### gene set analysis
gsa <- GSA(seqData,m_list,"gsva")

##Save
save_folder = "/home/montazeri/results/GSVA_DA_PA/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(gsa,file = "/home/montazeri/results/GSVA_DA_PA/gsva.RData")

##################################################################
#### differential analysis
##groups
samples <- colnames(seqData)
StGr <- TCGAstageGrade(sampleIDs)
errStages <- which(StGr[,1]=="not reported")
groups <- StGr[-errStages]

##edited data
GSVAdata <- gsa[,-errStages]

##edger
DA <- DEG(GSVAdata,groups)

##Save
save(DA,file = "/home/montazeri/GSVA_DA_PA/DA.RData")

###################################################################
#### pathway analysis
gp <- gprofileR(DA)
save(gp,file = "/home/montazeri/results/GSVA_DA_PA/gp.RData")

###################################################################