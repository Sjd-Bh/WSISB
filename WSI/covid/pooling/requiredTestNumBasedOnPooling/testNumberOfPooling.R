#################################################

computeTestNum <- function(PoolList,Ytest){
  
  Ytest = ifelse(Ytest==1, 1, 0)
  poolVector <- PoolList$poolVec
  NumOfPool <- PoolList$NumOfPool
  
  ind <- which(Ytest==1)
  testNumOfPosPool = 0
  if(length(ind) > 0) {
    posPool <- poolVector[ind]
    posPool <- unique(posPool)
    
    testNumOfPosPool <- 0
    for (i in 1:length(posPool)) {
      testNumOfPosPool <- testNumOfPosPool + sum( poolVector == posPool[i] )
    }
  }
  
  testNum <- NumOfPool + testNumOfPosPool
  
  # return(c(NumOfPool, testNumOfPosPool, length(ind), testNum))
  return(testNum)
}
######################################################
