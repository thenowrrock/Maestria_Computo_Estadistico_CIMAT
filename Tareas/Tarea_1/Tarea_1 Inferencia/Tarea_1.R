# Ejercicio 1.
pbinom(q=2, size=12, prob = 0.1)

pbinom(q=1, size=6, prob=0.11087)
6*0.11087

# Ejercicio 4. 
# a) Función para graficar la función de distribución acumulada y de masa de la distribu-
# ción uniforme.

grafica_pdf_and_cdf_uniforme <- function(n){
  x <- seq(1:n)
  f_x <- rep(1/n,n) 
  F_x <- cumsum(f_x)
  plot(x, f_x, main="PDF Unifrome Discreta", type="h")
  plot.ecdf(x,  main="CDF Unifrome Discreta")
}
grafica_pdf_and_cdf_uniforme(10)

# c) Simulación 
set.seed(13)
muestra <- sample(10,10000, replace = TRUE)
table(muestra)
mean(muestra)
var(muestra)

plot(table(muestra))


# Ejercicio 5.
# a) Sea 1 si cae sol y 0 si cae aguila, entonces podemos 

experimento_moneda <- sample(2, 10, replace=TRUE)
for i in muestras_modenas
for 
# b) 



# c) 


# Ejercicio 6.
# 


# Ejercicio 9.

pbinom(q=seq(0,10), size=10, prob = 0.25)






