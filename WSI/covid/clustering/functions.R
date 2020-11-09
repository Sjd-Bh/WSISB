
source("/home/montazeri/Bahonar/WSISB/WSI/covid/pooling/poolingFunctions/requiredPoolingFun.R")
#####################################################
euclideanDist <- function(x,y){
  Dist = 0
  for (i in 1:length(x)) {
    d <- (x[i]-y[i])^2
    Dist <- Dist + d
  }
  return(sqrt(Dist))
}
#####################################################
kmeansClustering <- function(X,cen){
  Centroid = cen
  for (z in 1:100) {
    
    distMat <- c()
    for (i in 1:nrow(Centroid)) {
      d = apply(X,1,function(x){euclideanDist(x,Centroid[i,])})
      distMat <- rbind(distMat,d)
    }
    Group <- apply(distMat,2, which.min)
    G1 <- X[which(Group==1),]
    G2 <- X[which(Group==2),]
    
    cen1 <- apply(G1, 2, mean)
    cen2 <- apply(G2, 2, mean)
    Centroid = rbind(cen1,cen2)
  }
  
  return(list(group = Group,
              centroid = Centroid))
  
}
#####################################################
objFun <- function(w,X,Y){
  
  c = centroids(w,X,Y)
  cen = c$cen
  xW = c$xW
  
  Kmeans <- kmeansClustering(xW,cen)
  y1 = Y[which(Kmeans$group == 1)]
  y2 = Y[which(Kmeans$group == 2)]
  
  p1 = sum(y1==1)/length(y1)
  p2 = sum(y2==1)/length(y2)
  
  s1 <- computeSizeOfPool(p1)
  s2 <- computeSizeOfPool(p2)
  
  test1 = 1/s1 + (1 - (1-p1)^s1)
  test2 = 1/s2 + (1 - (1-p2)^s2)
  
  m <- poolVecProducer(s1,length(y1))$NumOfPool
  n <- poolVecProducer(s2,length(y2))$NumOfPool
  
  sum((m*test1) + (n*test2))
    
}
#################################################
centroids <- function(w,X,Y){
  Y <- as.numeric(Y)
  X = apply(X, 2, as.numeric)
  xW <- matrix(NA,nrow(X),ncol(X))
  cen1ind <- sample(1:nrow(X),1)
  for (i in 1:length(w)) {
    xW[,i] = w[i]*X[,i]
  }
  cen1 <- xW[cen1ind ,]
  cen2idx <- which(Y!=Y[cen1ind])
  
  cenDist <- apply(xW[cen2idx,],1, function(x){euclideanDist(x,cen1)})
  cen2ind <- which.max(cenDist)
  cen2 <- xW[cen2ind ,]
  cen = rbind(cen1,cen2)
  return(list(cen=cen,
              xW=xW))
}
#################################################
clusterPooling <- function(Xtrain,Ytrain,Xtest){
  
  w0 <- runif(1:ncol(Xtrain))
  opt <- optim(par = w0,objFun,X=Xtrain,Y=Ytrain)
  w <- opt$par
  firstCen <- centroids(w,Xtrain,Ytrain)
  cluster <- kmeansClustering(firstCen$xW,firstCen$cen)
  
  y1 = Ytrain[which(cluster$group == 1)]
  y2 = Ytrain[which(cluster$group == 2)]
  
  p1 = sum(y1==2)/length(y1)
  p2 = sum(y2==2)/length(y2)
  
  s1 <- computeSizeOfPool(p1)
  s2 <- computeSizeOfPool(p2)
  
  Xtest = apply(Xtest, 2, as.numeric)
  xWtest <- matrix(NA,nrow(Xtest),ncol(Xtest))
  for (i in 1:length(w)) {
    xWtest[,i] = w[i]*Xtest[,i]
  }
  testCluster <- kmeansClustering(xWtest,firstCen$cen)
  
  Test1 <- which(testCluster$group == 1)
  Test2 <- which(testCluster$group == 2)
 
  m <- poolVecProducer(s1,length(Test1))
  n <- poolVecProducer(s2,length(Test2))
  pool = apend(m,n)
}


#################################################
#set.seed(1234)
#load("clustering/data1.RData")
#Xtrain <- trainData[[1]]$x
#Ytrain <- trainData[[1]]$y
#Xtest <- testData[[1]]$x
#Ytest <- testData[[1]]$y

#w0 <- runif(1:ncol(X))
#opt <- optim(par = w0,objFun,X=X,Y=Y)
#w <- opt$par

################################################


