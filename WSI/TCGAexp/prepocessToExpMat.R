##################################################################
            # preprocess TCGA expression data 
              # 1. convert row data to exp matrix
              # 2. convert ensemble ID to gene symbole
##################################################################
rm(list = ls())

base_folder = "../InputData/"
save_folder = "../TCGAexpMat/"

dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)

## Library
library(SummarizedExperiment)
library(RTCGAToolbox)
library(EnsDb.Hsapiens.v79)

## id for direction
#projects = getGDCprojects()
#cancerID <- intersect(projects$tumor, getFirehoseDatasets())
cancerID <- c("ACC","UCEC")

## exp matrix production
for(i in 1:length(cancerID)){
  
  exprFile = paste0(base_folder, cancerID[i],"_E.RData")
  saveFile = paste0(save_folder, cancerID[i],"_eMat.RData")
  
  load(exprFile)
  exp = assay(data)
  geneIDs1 <- ensembldb::select(EnsDb.Hsapiens.v79,
                                keys= row.names(exp),
                                keytype = "GENEID", columns = c("SYMBOL","GENEID"))
  rownames(exp) <- geneIDs1[,1]
  
  save(exp,file=saveFile)
  
}
#######################################################