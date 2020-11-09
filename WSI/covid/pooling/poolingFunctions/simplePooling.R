########################################
simplePooling <- function(Xtrain,Ytrain,Xtest){
  
  L <- nrow(Xtest)
  prevalence <- sum(Ytrain==1)/nrow(Xtrain)
  
  poolSize <- computeSizeOfPool(prevalence)
  pool <- poolVecProducer(poolSize,L)
  return(list(poolVec=pool$pool,NumOfPool=pool$NumOfPool,idx=1:L))
}
########################################
