rm(list = ls())
source("code/LogisticModel.R")
source("code/simulateDataMulticategorial.R")

######################################################
################## Example 1 #########################

## 3 Risk goup
numFeatures = c(2,5,4)
settingList <- list(pPosVec= c(0.15, 0.05, 0.1),
                    pRiskVec = c(0.1,0.3,0.6),
                    probs_list = probList(numFeatures),
                    UnifProb=unifProb(Min=0.1,Max=0.9))

N =10000 
TrainSimulation <- simulateDataMulticategorial(N,numFeatures, settingList)

y <- TrainSimulation$y
x <- TrainSimulation$x
colnames(x) <- paste("V", 1:ncol(x), sep = "")

TestSimulation <- simulateDataMulticategorial(1000,numFeatures, settingList)
test_x <- data.frame(TestSimulation$x)

predicted <- logisticRegression(x,y,test_x)
LogisicPrediction <- as.vector(predicted)

#######################################################













 



