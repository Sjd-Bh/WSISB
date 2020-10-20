library(gprofiler2)
###########################################################
gprofileR <- function(geneNames){
  ## a vector of gene names (e.g. "Klf4")
  gp = gost(geneNames, organism =  "hsapiens")
  pathways =  gp$result
}
