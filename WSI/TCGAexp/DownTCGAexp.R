########################################################
          #TCGA gene expression download#
########################################################
rm(list=ls())

#Sys.setenv("TAR" = "internal")

base_folder = "../InputData/"
### Change directory
dir.create(base_folder, recursive = TRUE, showWarnings = FALSE)

## Libraries
library(TCGAbiolinks)
library(RTCGAToolbox)


## Download Data
projects = getGDCprojects()
id <- intersect(projects$tumor, getFirehoseDatasets())



for(i in 1:length(id)){
  
  #workflow.type = "HTSeq - FPKM"
  workflow.type = "HTSeq - FPKM-UQ"
  
  expr_file = paste0(base_folder, id[i],"_E.RData")
  if(!file.exists(expr_file)) {
    ### Gene Expression 
    query <- GDCquery(project = paste0("TCGA-",id[i]),
                      data.category = "Transcriptome Profiling",
                      data.type = "Gene Expression Quantification",
                      workflow.type = workflow.type, 
                      experimental.strategy = "RNA-Seq")
    GDCdownload(query, method = "api", files.per.chunk = 50)
    data <- GDCprepare(query)
    save(data, file = expr_file)
  }
}

##########################################################



