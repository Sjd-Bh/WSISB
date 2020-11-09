###########################################################################
rm(list = ls())
source("code/modelingOnData/errorRates.R")


baseFolder1 = "../../BalnceResults/"
ResultsFolderNames = list.files(baseFolder1, full.names = TRUE)
shortFileNames = list.files(baseFolder1)
dir.create("../../BalanceDataForPlotting")
dir.create("../../BalanceDataForPlotting/errorData/")
errorPath = "../../BalanceDataForPlotting/errorData/"

errorRates(ResultsFolderNames, shortFileNames, errorPath)
#################################################
rm(list = ls())

load("../../BalanceDataForPlotting/errorData/errorData.RData")


df <- errorData[,-ncol(errorData)]
df <- as.data.frame(sapply(df, as.numeric))
labels <- errorData[,ncol(errorData)]
df <- cbind(labels,df)

base_folder = "../../plotBalanceSetting/boxplot/"
dir.create(path = base_folder,showWarnings = F,recursive = T)
pdf(paste0(base_folder, "boxplot.pdf"), 7, 5)
boxplot(df[,-1], boxfill = NA,border = NA)
boxplot(df[df$labels=="stepForward_logisticR", -1], xaxt = "n", add = TRUE, boxfill="Red", 
        boxwex=0.12, at = 1:ncol(df[,-1]) - 0.2)
boxplot(df[df$labels=="logisticRegression", -1], xaxt = "n", add = TRUE, boxfill="blue", 
        boxwex=0.12, at = 1:ncol(df[,-1]) )
boxplot(df[df$labels=="naiveBayesClassifier", -1], xaxt = "n", add = TRUE, boxfill="green", 
        boxwex=0.12, at = 1:ncol(df[,-1]) + 0.15)
dev.off()
#######################################################################