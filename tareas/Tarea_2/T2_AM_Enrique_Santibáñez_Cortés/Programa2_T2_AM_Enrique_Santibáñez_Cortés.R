'2. Programe una función en r que reciba de entrada una matriz y que realice la eliminación de Gauss y regrese la matriz escalonada por renglones. Es decir, 
a diferencia del problema 1 no debe haber intervención del usuario más que en la captura de la matriz.'
tipo_iii_automatica <- function(matriz, j, i){
  alpha <- -matriz[j,i]/matriz[i,i]
  matriz[j,] <- matriz[j,]+alpha*matriz[i,]
  matriz
}

tipo_i <- function(matriz, j, i){
  aux <- matriz[i,]
  matriz[i,] <- matriz[j,]
  matriz[j,] <- aux
  matriz
}
eliminacion_gauss <- function(matriz){
  n <- nrow(matriz)
  for (i in 1:(n-1)){
    for (j in (i+1):n){
      zero <-0
      while(zero!=1){
        if (matriz[i,i]=0){
          matriz<-tipo_i(matriz,i,j)  
        }
        
      }
      matriz <- tipo_iii_automatica(matriz, j, i)
      print(matriz)
    }
  }
  salir <- validacion_escalonada(matriz)
  if (salir==0){
    eliminacion_gauss(matriz)
  }
  else{
    cat("La matriz escalodana por renglones es:")
    print(matriz)
  }
}

escalonada <- function(){
  tamano <- lectura() # Solicitamos el tamaño de la matriz.
  matriz <- datos_matrix(tamano[1], tamano[2]) # Solicitamos la matriz.
  eliminacion_gauss(matriz)
}


'En ninguno de los dos programas se pueden usar comandos o librerías de r que resuelvan directamente el problema. Si puede usar librerías que mejoren la captu-
ra de datos o la presentación del programa.'