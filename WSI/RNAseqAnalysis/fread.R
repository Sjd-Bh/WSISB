rm(list = ls())

##################################################
library("data.table")
library("readr")
##################################################

allData <- fread("../all_transcriptomes.csv", showProgress = FALSE)
TCGA_slic_100.h5

#if (!requireNamespace("BiocManager", quietly = TRUE))
  #install.packages("BiocManager")
#BiocManager::install(version = "3.11")

#install.packages('hdf5r')
#library(hdf5r)

install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)
h5ls("TCGA_slic_100.h5")
mydata <- h5read("TCGA_slic_100.h5","X")

str(mydata)
