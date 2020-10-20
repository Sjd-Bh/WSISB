
library("edgeR")
#####################################################

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
#####################################################################