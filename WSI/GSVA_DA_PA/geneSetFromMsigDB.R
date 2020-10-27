#######################################################################
            # gene set Download from MsigDB #
#######################################################################
rm(list=ls())

save_folder = "../mSigDB/"

### Change directory
dir.create(save_folder, recursive = TRUE, showWarnings = FALSE)

##libraries
library(msigdbr)

##categories
##geneSet <- c("H","C6")
geneSet <- "C6"

# download gene sets from each category
for (i in 1:length(geneSet)) {
  
  mSigDB_file = paste0(save_folder, geneSet[i],".RData")
  
  msigDB <- msigdbr(species = "Homo sapiens", category = geneSet[i])
  m_list = msigDB %>% split(x = .$gene_symbol, f = .$gs_name)
  #m_t2g = msigDB %>% dplyr::select(gs_name, gene_symbol) %>% as.data.frame()
  
  save(m_list,file = mSigDB_file)
}
#########################################################################