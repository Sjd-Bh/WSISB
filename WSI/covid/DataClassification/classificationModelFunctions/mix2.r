
#####################################################
#####################################################
library(flexmix)

mixtureModel <- function(x,y,Xtest){
  
  x = apply(x, 2, as.numeric)
  data <- data.frame(cbind(x,y))
  ll = -Inf 
  best=NA
  for(i in 1:50){
    m = flexmix(formula = y ~ ., data=data, model=FLXMCmvbinary(),k = 2, control=list(minprior = 0.0, tolerance = 1e-15))
    if(m@logLik > ll) {
      best = m
      ll = m@logLik
      print(best)
      
    }
  }
  return(best)
}

#########################################################

