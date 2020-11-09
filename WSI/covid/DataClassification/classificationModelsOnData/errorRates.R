########################################################################
errorRates <- function(ResultsFolderNames, shortFileNames, errorPath){
  
  modelError = c()
  errorTable = c() 
  for (i in 1:length(ResultsFolderNames)) {
    baseFolder = ResultsFolderNames[i]
    fileNames = list.files(baseFolder, full.names = TRUE)
    
    errorRate = c()
    for (j in 1:length(fileNames)) {
      
      BaseFolder = fileNames[j]
      FileNames = list.files(BaseFolder, full.names = TRUE)
      
      Error <- c()
      for (z in 1:length(FileNames)) {
        load(FileNames[z])
        Yhat = output$Yhat
        Yhat = as.vector(Yhat)
        
        error <- sum(Yhat != Ytest)/length(Yhat)
        Error <- c(Error, error)
      }
      errorRate = cbind(errorRate , Error)
    }
    labeles = rep(paste0(shortFileNames[i]))
    modelError = cbind(errorRate,labeles)
    errorTable = rbind(errorTable,modelError)
  }
  errorData = data.frame(errorTable)
  colnames(errorData) <- c(paste0("setting",1:(ncol(errorData)-1)),"labels")
  save(errorData, file = paste0(errorPath,"errorData.RData"))
}
#######################################################################






