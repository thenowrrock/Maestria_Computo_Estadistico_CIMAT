### CIMAT, Monterrey.
### Inferencia Estadística: Segundo examen parcial.
### Enrique Santibáñez Cortés

# Ejercicio 6.
# Esta función generá una muestra aleatoria con distribución 
# Normal(mu, sigma^2)

muestra_normal_mu_sigma <- function(n, mu, sigma_2){
  # n : Debe de ser un entero positivo.
  # mu: un número real.
  # sigma_2: un número positivo.  
  u1 <- runif(n, 0, 1) # Generamos números aleatorias de una distribución Uniforme
  u2 <- runif(n, 0, 1) # Generamos números aleatorias de una distribución Uniforme
  muestra_aleatoria <- sqrt(-2*log(u1))*sin(2*pi*u2) # Transformación ocupando el Teorema de Box-Muller.
  sqrt(sigma_2)*muestra_aleatoria+mu
}

# Ejemplo, genermos una muestra aleatoria de tamaño 1000 de una distribución
# Normal(2, 4)

muestra_normal_2_4 <- muestra_normal_mu_sigma(1000, 2, 4)

hist(muestra_normal_2_4, main = "Histograma de una muestra normal")


