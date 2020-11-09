##########################################################
testNumNeededOnPoolData <- function(poolFolder,DataFolder,savePath){
  poolFileNames = list.files(poolFolder, full.names = TRUE)
  DataFileNames = list.files(DataFolder, full.names = TRUE)
  shortPoolFolder = list.files(poolFolder)
  
  for (q in 1:length(poolFileNames)) {
    data = DataFileNames[q]
    dataFiles = list.files(data, full.names = TRUE)
    setting = poolFileNames[q]
    settingFolder = list.files(setting, full.names = TRUE)
    sPath = paste0(savePath,shortPoolFolder[q])
    dir.create(path = sPath,showWarnings = F,recursive = T)
    
    testNumMat = c()
    for (r in 1:length(settingFolder)) {
      settingNum = settingFolder[r]
      settingfolder = list.files(settingNum, full.names = TRUE)
      load(dataFiles[r])
      
      
      testNumVector = c()
      for (z in 1:length(settingfolder)) {
        pooling = settingfolder[z]
        poolingFolder = list.files(pooling, full.names = TRUE)
        
        labeles = c()
        testNumVec = c()
        for (i in 1:length(poolingFolder)) {
          load(poolingFolder[i])
          test = testData[[i]]
          Ytest = test$y
          testNum = computeTestNum(poolingList,Ytest)
          testNumVec = c(testNumVec,testNum)
        }
        testNumVector = c(testNumVector,testNumVec)
      }
      testNumMat = cbind(testNumMat,testNumVector)
    }
    shortFolder = list.files(settingNum)
    labeles = rep(shortFolder,each=length(poolingFolder))
    testNumMatrix = cbind(testNumMat,labeles)
    colnames(testNumMatrix) = c("setting1","setting2","setting3","labeles")
    save(testNumMatrix,file = paste0(sPath,"/","TestNumberComputation.RData") )
  }
}
#######################################################################