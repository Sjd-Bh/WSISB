
#################################################
backgroundMatGeneration <- function(N,numFeature,UnifProb){
  backGdata <- c()
  for (i in 1:numFeature) {
    x <- rbinom(N,1,UnifProb)
    backGdata <- cbind(backGdata,x)
  }
  colnames(backGdata) <- paste("x",1:ncol(backGdata),sep = "")
  return(backGdata) 
}
################################################

generateJointFeatures <- function(p) {
  input_features = list()
  for(i in 1:p) {
    input_features[[i]]  = c(0, 1)
  }
  expand <- expand.grid(input_features)
  expand_features <- as.matrix(expand)
  return(expand_features)
}

#################################################

generateSubmat <- function(nPerG, numF, probs){
  joint_features = generateJointFeatures(numF)
  nr_joint_cases = nrow(joint_features)
  
  indG = sample(x=nr_joint_cases,nPerG , prob=probs, replace = TRUE)
  
  subMat <- joint_features[indG,]
  return(subMat)
}

#########################################################

simulateDataMulticategorial <- function(N, settingList){
  
  pPosVec <- settingList$pPosVec
  pRiskVec <- settingList$pRiskVec
  probsList <- settingList$probsList
  UnifProb <- settingList$UnifProb
  numFeatures <- settingList$numFeatures
  numFeature <- settingList$numTotalFeatures
  
  nrOfRiskGroups = length(numFeatures)
  
  backM <- backgroundMatGeneration(N,numFeature,UnifProb)
  nPerGroup  = as.vector(rmultinom(1, N, prob=pRiskVec))
  
  
  RiskGroup <- c()
  yResponse <- c()
  previous_nG <- 0
  previous_nC <- 0
  for(r in 1:nrOfRiskGroups) {
    
    startRow = 1+previous_nG
    rowInds = startRow:(startRow+nPerGroup[r]-1)
    startCol = 1+previous_nC
    colInds = startCol:(startCol+numFeatures[r]-1)#######
    previous_nG <- startRow+nPerGroup[r]-1
    previous_nC <- startCol+numFeatures[r]-1#######
    
    backM[rowInds, colInds] = generateSubmat(nPerGroup[r], numFeatures[r], probsList[[r]])
    
    names(pRiskVec) <- 1:length(pRiskVec)
    Risk <- rep(names(pRiskVec)[r],nPerGroup[r])
    RiskGroup <- c(RiskGroup,Risk)
    
    pos <- sample(c(1,0), size=nPerGroup[r], prob = c(pPosVec[r],1-pPosVec[r]),replace = T)
    yResponse <- c(yResponse,pos)   ## pos_neg response
    
  }
  ###yResponse  = ifelse(yResponse==1, 1, 0)
  ###backM = apply(backM, 2, as.numeric)
  data <- cbind(backM, yResponse ,RiskGroup)
  
  # shuffle data
  shuffle_rows <- sample(nrow(data),nrow(data))
  predata <- data[shuffle_rows,]
  simulateData <- data.frame(predata)
  return(list(y=simulateData$yResponse,
              Group=simulateData$RiskGroup,
              x=simulateData[,-c(ncol(predata),(ncol(predata)-1))]))
}

############################################################
###################### dataGeneration ######################

dataGeneration <- function(numGenData,N, settingList){
  generatedData <- list()
  for (i in 1:numGenData) {
    generatedData[[i]] <- simulateDataMulticategorial(N, settingList)
  }
  return(generatedData)
}
