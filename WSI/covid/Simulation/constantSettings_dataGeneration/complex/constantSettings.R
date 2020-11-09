##########################################################
#################################################
probList <- function(numFeatures){
  probsList = list()
  for(r in 1:length(numFeatures)) {
    nr_joint_cases = 2^(numFeatures[r])
    probs = abs(rnorm(nr_joint_cases)) 
    probsList[[r]] = probs /sum(probs) 
  }
  return(probsList)
}
#################################################
unifProb <- function(Min,Max){
  unif_prob <- runif(1,min = Min,max=Max)
  return(unif_prob)
}

#################### constantSetting #####################

constantSetting <- function(n,pPos,pRisk, numTotalFeatures){
  constatntSetList <- list()
  for (i in 1:n) {
    g <- i*2
    nFeatures <- rep(3,g)
    settingList <- list(pPosVec= pPos[[i]],
                        pRiskVec = pRisk[[i]],
                        probsList = probList(nFeatures),
                        UnifProb=unifProb(Min=0.1,Max=0.9),
                        numFeatures=nFeatures, 
                        numTotalFeatures=numTotalFeatures)
    
    constatntSetList[[i]] = settingList
  }
  return(constatntSetList)
}






