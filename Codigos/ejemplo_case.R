
n <- nrow(Z)

Z <- t(matrix(c(65, 71, 72, 77, 77, 73, 68, 78, 81, 76, 73, 87), nrow = 2))
ones <- matrix(rep(1,6), 6)

Z <- cbind(ones, Z)
Z


Y <- t(matrix(c(63,67, 70, 70, 72, 70, 75, 72, 89, 88, 76, 77),nrow=2))

beta_1 <- solve(t(Z)%*%Z)%*%t(Z)%*%Y[,1]
beta_1

beta_2 <- solve(t(Z)%*%Z)%*%t(Z)%*%Y[,2]
beta_2


beta <- cbind(beta_1, beta_2)
beta

Y_hat <- Z%*%beta
Y_hat

epsilon <- Y- Y_hat
epsilon


sigma <- t(epsilon)%*%epsilon/n
sigma

E <- n*sigma
E


## Para sigma 1
Z1 <- t(matrix(c(65, 71, 72, 77, 77, 73, 68, 78, 81, 76, 73, 87), nrow = 2))
Z1[,1] <- 0
ones <- matrix(rep(1,6), 6)

Z1 <- cbind(ones, Z1)
Z1 <- Z1[,c(1,3)]
beta_1 <- solve(t(Z1)%*%Z1)%*%t(Z1)%*%Y[,1]
beta_1

beta_2 <- solve(t(Z1)%*%Z1)%*%t(Z1)%*%Y[,2]
beta_2

beta <- cbind(beta_1, beta_2)
beta

Y_hat <- Z1%*%beta
Y_hat

epsilon <- Y- Y_hat
epsilon


sigma1 <- t(epsilon)%*%epsilon/n
sigma1

H <- n*(sigma1-sigma)
H


## Para sigma 2 
Z1 <- t(matrix(c(65, 71, 72, 77, 77, 73, 68, 78, 81, 76, 73, 87), nrow = 2))
Z1[,2] <- 0
ones <- matrix(rep(1,6), 6)

Z1 <- cbind(ones, Z1)
Z1 <- Z1[,1:2]
beta_1 <- solve(t(Z1)%*%Z1)%*%t(Z1)%*%Y[,1]
beta_1

beta_2 <- solve(t(Z1)%*%Z1)%*%t(Z1)%*%Y[,2]
beta_2

beta <- cbind(beta_1, beta_2)
beta

Y_hat <- Z1%*%beta
Y_hat

epsilon <- Y- Y_hat
epsilon


sigma1 <- t(epsilon)%*%epsilon/n
sigma1

H <- n*(sigma1-sigma)
H


