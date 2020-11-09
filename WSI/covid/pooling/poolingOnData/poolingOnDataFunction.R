############################################################################

poolingOnData <- function(dataPath,savePath,poolFun){
  
  dataFolder = list.files(dataPath, full.names = TRUE)
  shortDataFolder = list.files(dataPath)
  
  for (z in 1:length(poolFun)) {
    pooling = get(poolFun[z])
    
    for (q in 1:length(dataFolder)) {
      dPath = dataFolder[q]
      dPathFolder =list.files(dPath, full.names = TRUE)
      
      
      for (r in 1:length(dPathFolder)) {
        sPath = paste0(savePath,shortDataFolder[q],"/","setting",r,"/",poolFun[z])
        dir.create(path = sPath,showWarnings = F,recursive = T)
        load(dPathFolder[r])
        
        for (i in 1:length(trainData)) {
          train = trainData[[i]]
          test = testData[[i]]
          
          Xtrain = train$x
          Ytrain = train$y
          Xtest = test$x
          
          poolingList = pooling(Xtrain,Ytrain,Xtest)
          save(poolingList,file = paste0(sPath,"/","data",i,".RData"))
        }
      }
    }
  } 
}
###########################################################################