TCGAstageGrade <- function(sampleIDs){
  ##sampleIDs: a vector of the interest sample ids from TCGA (e.g."TCGA-xw-zz-01A")
  tumorStage <- c()
  tumorGrade <- c()
  for (i in 1:length(sampleIDs)) {
    sampleInf <- colDataPrepare(sampleIDs[i])
    grade <- sampleInf$tumor_grade
    stage <- sampleInf$tumor_stage
    
    tumorStage <- c(tumorStage,stage)
    tumorGrade <- c(tumorGrade,grade)
  }
  
  StGr <- cbind(tumorStage,tumorGrade)
}
