generateJointFeatures <- function(p) {
  input_features = list()
  for(i in 1:p) {
    input_features[[i]]  = c(0, 1)
  }
  expand <- expand.grid(input_features)
  expand_features <- as.matrix(expand)
  return(expand_features)
}

###########################################################

probListIndep <- function(numFeatures, Min, Max){
  probsList = list()
  for(r in 1:length(numFeatures)) {
    joint_features = generateJointFeatures(numFeatures[r])
    nr_joint_cases = 2^(numFeatures[r])
    probs <- runif(numFeatures[r],min = Min,max=Max)
    
    probsList[[r]] = apply(joint_features, 1, function(x) { 
      prod((probs^x)) * prod((1-probs)^(1-x))
      })
  }
  return(probsList)
}
#################################################
unifProb <- function(Min,Max){
  unif_prob <- runif(1,min = Min,max=Max)
  return(unif_prob)
}

#################### constantSetting #####################

constantSetting <- function(n,pPos,pRisk){
  constatntSetList <- list()
  for (i in 1:n) {
    
    nFeatures <- c(rep(4,i),rep(4,i))
    settingList <- list(pPosVec= pPos[[i]],
                        pRiskVec = pRisk[[i]],
                        probsList = probListIndep(nFeatures, Min=0.6,Max=0.9),
                        UnifProb=unifProb(Min=0.1,Max=0.3),
                        numFeatures=nFeatures, 
                        numTotalFeatures=sum(nFeatures)+2)
    
    constatntSetList[[i]] = settingList
  }
  return(constatntSetList)
}