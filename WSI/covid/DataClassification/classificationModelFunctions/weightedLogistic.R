

###################################################
logisticRegModelW <- function(x,y){
  n_pos = sum(y==1)
  n_neg = sum(y==0)
  w = ifelse(y==1, 1/n_pos, 1/n_neg)
  data <- data.frame(cbind(x,y))
  
  logisticModelFit <- glm(y ~ . , data , family = binomial, weights = w )
  return(logisticModelFit)
}