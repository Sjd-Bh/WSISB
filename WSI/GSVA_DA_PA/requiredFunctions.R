#!/usr/bin/env Rscript

## Libraries
library(EnsDb.Hsapiens.v79)
#library(TCGAbiolinks)
library(edgeR)
library(gprofiler2)
library(GSVA)

###################################################
## ensemble ID to gene symbole ##

EnsToGene <- function(ensID) {
  geneNames <- ensembldb::select(EnsDb.Hsapiens.v79,
                                 keys= ensID,
                                 keytype = "GENEID", columns = c("SYMBOL","GENEID"))
  return(geneNames[,1])
}

###################################################
## identify stage & grade of TCGA samples

TCGAstageGrade <- function(sampleIDs){
  ##sampleIDs: a vector of the interest sample ids from TCGA (e.g."TCGA-xw-zz-01A")
  tumorStage <- c()
  tumorGrade <- c()
  for (i in 1:length(sampleIDs)) {
    sampleInf <- colDataPrepare(sampleIDs[i])
    grade <- sampleInf$tumor_grade
    stage <- sampleInf$tumor_stage
    
    tumorStage <- c(tumorStage,stage)
    tumorGrade <- c(tumorGrade,grade)
  }
  
  StGr <- cbind(tumorStage,tumorGrade)
}

####################################################
## gene set analysis

GSA <- function(exp,geneSet, method){
  gsa <- gsva(exp,geneSet, min.sz=10, max.sz=500, verbose=FALSE,
              parallel.sz=1,method=method)
  return(gsa)
}

####################################################
## Differential analysis ##

DEG <- function(TCGAdata,groups){
  ##TCGAdata: cols=samples , rows=genes
  ##groups: sth like stages, grades or molecular subtypes
  
  group = factor(groups)
  design = model.matrix(~ group)
  
  dge = DGEList(counts=TCGAdata,
                group = group)
  #samples=colData(tcga_data),
  #genes=as.data.frame(rowData(tcga_data)))
  
  # Normalization (TMM followed by voom)
  dge = calcNormFactors(dge)
  v = voom(dge, design, plot=TRUE)
  
  # Fit model to data given design
  fit = lmFit(v, design)
  fit = eBayes(fit)
  
  # Show top genes
  topGenes = topTable(fit, coef=ncol(design), number=100, sort.by="p")
}

####################################################
## pathway analysis ##

gprofileR <- function(charVec){
  ## character vectors can consist of mixed types of gene IDs,
  ## SNP IDs, chromosomal intervals or term IDs
  gp = gost(charVec, organism =  "hsapiens")
  pathways =  gp$result
}

####################################################