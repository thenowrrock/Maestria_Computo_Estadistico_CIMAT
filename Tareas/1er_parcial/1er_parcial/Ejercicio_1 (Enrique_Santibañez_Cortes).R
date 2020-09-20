### Enrique Santibanez Cortes
### 1er Examen
### Inferencia Estadística
### MCE, CIMAT.

uni<- runif(1000,0,1)
weibull <- sqrt(-log(1-uni)/2)

hist(weibull)

kernel_gaussian <- function(x,x_i,h){
  dnorm((x-x_i)/h)
}
kde <- function(x, h, kernel, D){
  f_hat <- 0
  n <- length(D)
  for (i in 1:n){
    if (kernel=="gaussian"){
      f_hat <- f_hat + kernel_gaussian(x, D[i], h)
    }
    else{
      print("Kernel incorrecto")
      break()
    }
  }
  f_hat/(n*h)
}

x<-seq(0,2,0.001)

kde(x,0.2, "gaussian", weibull)

plot(weibull,kde(weibull,0.2, "gaussian", weibull))

