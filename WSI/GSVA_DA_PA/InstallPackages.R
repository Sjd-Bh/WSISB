if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("EnsDb.Hsapiens.v79")
####

if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install("TCGAbiolinks")
####
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("BioinformaticsFMRP/TCGAbiolinksGUI.data")
BiocManager::install("BioinformaticsFMRP/TCGAbiolinks")
####

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("edgeR")
#####
install.packages("gprofiler2")
#####
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GSVA")
#####
install.packages("tidyverse")
install.packages("data.table")
install.packages("readr")
#####
install.packages("BiocManager")
BiocManager::install("rhdf5")
#####
install.packages("msigdbr")
######
pack <- c("curl","httr","RCurl","GenomeInfoDb","BiocFileCache","GenomicRanges","SummarizedExperiment",
          "XML","BiocFileCache", "xml2","biomaRt","Rhtslib","Rsamtools","GenomicAlignments","rtracklayer",
          "GenomicFeatures","AnnotationFilter","rtracklayer","ensembldb")
BiocManager::install(pack)