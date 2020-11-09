###########################################################
               ## K means clustering ##
###########################################################
rm(list = ls())

##  distance calculating function
####like eulidean dist



## kmeans algorithm:
#1. select k points as centroids (randomely or guided)
#### may be select centroids one by one according to max distance from previous centroids

#2. computing point distances from centroids / assign all the points to the closest centroids

#3. recompute the centroids of newly formed clusters

#4. repeat 2,3

###############################################
set.seed(12345)
objFun <- function(param,data){
  Xc = sample(1:nrow(data), 1)
  dis = c()
  for (i in 1:nrow(data)) {
    d=0
    for (j in 1:ncol(data)) {
      Dj = (param[j]^2)*((as.numeric(data[i,j])-as.numeric(data[Xc,j]))^2)
      d = sum(d+Dj)
    }
    dis = c(dis,d)
  }
  m <- which(dis==max(dis))
  return(c(m[1],Xc))
}
################################################
load("../../data1.RData")
train <- trainData[[1]]
data <- train$x

optim(par = runif(10), objFun,data =data)
################################################
k <- kmeans(data, 2, iter.max = 10, nstart = 1)

##choose centroids
##optimize weights
##use cen and w for clustering
## convergence of centroids to where they have oposite labeles
