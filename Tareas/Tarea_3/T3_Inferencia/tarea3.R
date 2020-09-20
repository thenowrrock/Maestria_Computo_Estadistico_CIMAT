#ejercicio 2b------------------
#la siguiente función calcula si p cae en Cn
# usando la desigualdad de Hoeffding

#retorna 1 si está dentro del intervalo, 0 e.o.c
set.seed(100)
cobertura_n = function(n){
  alpha = 0.05 #1-alpha = nivel de confianza
  p = 0.4
  cont = 0
  pn = mean(rbinom(n, 1, prob = 0.4))
  epsilon_n = sqrt((1/(2*n)*log(2/alpha)))
  
  lim_inf = pn - epsilon_n
  lim_sup = pn + epsilon_n
  
  cont = 0
  if( lim_inf < p & p <lim_sup ){
    cont = cont + 1
  }
  #retornamos la cantidad de veces que p está dentro del
  #intervalo de confianza y el error epsilon
  return(c(cont,epsilon_n)) 
}

#Número de variables Bernoulli que sumaremos
valores_n = c(10, 50, 100, 250, 500, 1000, 2500, 5000, 10000)
coberturas = numeric(length(valores_n))
longitudes = numeric(length(valores_n))
N = 10000 #número de veces que repetiremos el experimento

#calculamos la cobertura para cada n en valores_n
#repitiendo el experimento N veces
library(magrittr)

for (i in 1:length(valores_n)) {
  #coberturas[i] = table(replicate(N, cobertura_n(valores_n[i])[1]))[[2]]/N
  
   coberturas[i] = cobertura_n(valores_n[i])[1] %>% #calculamos la cobertura para cada n
     replicate(N,.) %>% # repetimos N veces
     table(.)[[2]] / N# calculamos la frecuencia con la que p está en Cn
    
  
  #La longitud del intervalo es 2 veces epsilon
  longitudes[i] = 2*cobertura_n(valores_n[i])[2]
}


ICS = data.frame(valores_n, coberturas, longitudes)
library(ggplot2)
ggplot(data = coberturas_df) + aes(x = valores_n,y = coberturas) +
  geom_line()

