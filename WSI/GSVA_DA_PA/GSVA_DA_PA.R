rm(list = ls())
#!/usr/bin/env Rscript

source("GSVA_DA_PA/requiredFunctions.R")
source("GSVA_DA_PA/geneSetFromMsigDB.R")
load("../data/countTable.RData")
load("../mSigDB/C6.RData")

##################################################
### gene set analysis
gsa <- GSA(seqData,m_list,"gsva")

##Save
save_folder = "../results/GSVA_DA_PA/"
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)
save(gsa,file = "../results/GSVA_DA_PA/gsva.RData")

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
save(DA,file = "../GSVA_DA_PA/DA.RData")

###################################################################
#### pathway analysis
gp <- gprofileR(DA)
save(gp,file = "../results/GSVA_DA_PA/gp.RData")

###################################################################