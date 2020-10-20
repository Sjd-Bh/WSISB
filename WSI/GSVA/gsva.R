###############################################################################
        # ssGSEA & GSVA on TCGA exp data and chosen msigdb gene sets #
###############################################################################
rm(list=ls())

## which folder
exp_folder = "../TCGAexpMat/"
gSet_folder = "../mSigDB/"
save_folder = "../geneSetEnrich/"

##create direction
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)

###### library
library(GSVA)

######input files
expFile =list.files(exp_folder, full.names = TRUE)
gs = list.files(gSet_folder, full.names = TRUE)

expNam <- list.files(exp_folder)
gsNam <- list.files(gSet_folder)

###### methods
method = c("gsva","ssgsea")


for(i in 1:length(method)){
    saveFolder = paste0(save_folder,method[i],"/")
    dir.create(saveFolder, recursive = TRUE, showWarnings = FALSE)
  
    for (j in 1:length(expFile)) {
        for (z in 1:length(gs)) {
             
            ### input exp & geneSet data
            load(expFile[j])
            load(gs[z])
            savePath <- paste0(saveFolder,
                               strsplit(expNam[j],"_")[[1]][1],
                               "_",gsNam[z])
            
            ### gene set analysis
            gsa <- gsva(exp,m_list, min.sz=10, max.sz=500, verbose=FALSE,
                         parallel.sz=1,method = method[i])
            save(gsa,file = savePath)
        }
    }
}
###########################################################