########################################
computeSizeOfPool <- function(prevalence) {
  expectedNrOfTest <- function(n, p) {
    q = 1 - p
    1/n  + (1-q^n)
  }
  
  n = 1:32  # possible pool sizes. Max pool size: 32
  idx = which.min(expectedNrOfTest(n, prevalence))
  n[idx]
}
#########################################
poolVecProducer <- function(poolSize, obsNum){
  if(obsNum == 0 ) {
    return(list(pool=c(),NumOfPool=0))
  }
  n <- floor(obsNum/poolSize)
  m <- obsNum-(n*poolSize)
  v1 <- rep(1:n,each=poolSize)
  v2 <- rep(n+1,each=m)
  pool <- c(v1,v2)
  
  if(n == 0) {
    pool <- v2
  }
  
  if(m == 0){
    NumOfPool <- n
  }else{
    NumOfPool <- n+1
  }
  if(length(pool) != obsNum) {
    #exit("error")
    return("error")
  }
    
  return(list(pool=pool,NumOfPool=NumOfPool))
}
################################################
apend <- function(pVec1, pVec2) {

  if(is.null(pVec1)) {
    poolRes = pVec2
  } else if(is.null(pVec2)){
    poolRes = pVec1
  } else{
    pool = c(pVec1$pool, pVec2$pool + pVec1$NumOfPool)
    NumOfPool = pVec1$NumOfPool + pVec2$NumOfPool
    poolRes = list(pool=pool,NumOfPool=NumOfPool)
  }
  return(poolRes)
}

###############################################