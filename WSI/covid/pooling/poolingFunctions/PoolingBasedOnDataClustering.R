######################
computeZ <- function(beta, X) {
  apply(X, 1, function(x) { plogis(sum(beta*x) ) })
}

obj_function <- function(beta, X, Y) {
  Z = computeZ(beta, X)
  
  p0 = sum((1-Z) * Y)/sum(1-Z)
  p1 = sum(Z * Y)/sum(Z)
  
  s0 <- computeSizeOfPool(p0)
  s1 <- computeSizeOfPool(p1)
  
  eTest0 = 1/s0 + (1 - (1-p0)^s0)
  eTest1 = 1/s1 + (1 - (1-p1)^s1)
  
  sum((1-Z) * eTest0 + Z * eTest1)
}
##########################
computeGroups <- function(beta, X) {
  Z = computeZ(beta, X)
  ifelse(Z < 0.5, 1, 2)
}
#########################

learnModel <- function(X, Y) {
  beta0 = runif(ncol(X), -1, 1)
  res = optim(beta0, obj_function, X=X, Y=Y)
  
  beta = res$par
  
  groups = computeGroups(beta, X)
  poolSize1 = computeSizeOfPool(mean(Y[groups==1]))
  poolSize2 = computeSizeOfPool(mean(Y[groups==2]))
  
  list(beta=beta, poolSize1=poolSize1, poolSize2=poolSize2)
}

########################################
PoolingBasedOnClustering <- function(Xtrain, Ytrain, Xtest){
  
  Xtrain = apply(Xtrain, 2, as.numeric)
  Ytrain = ifelse(Ytrain==1, 1, 0)
  Xtest = apply(Xtest, 2, as.numeric)
  
  model = learnModel(Xtrain, Ytrain)
  
  groups = computeGroups(model$beta, Xtest)
  
  pVec1 = pVec2 = NULL
  if(sum(groups==1) > 0) {
    pVec1 = poolVecProducer(model$poolSize1, sum(groups==1))  
  }
  
  if(sum(groups==2) > 0) {
    pVec2 = poolVecProducer(model$poolSize2, sum(groups==2))
  }

  idx = c(which(groups==1), which(groups==2))
  pool <- apend(pVec1,pVec2)  
  
  poolNrs = rep(NA, length(idx))
  poolNrs[idx] = pool$pool
  
  return(list(poolVec= poolNrs,
              NumOfPool= pool$NumOfPool))
}
##########################################
