'1. Programe una función en r que reciba de entrada por parte del usuario el tamaño de una matriz y las entradas de la misma en orden de izquierda a derecha, 
de arriba a abajo. Luego, debe ir preguntando que operación elemental debe hacerse, y una vez que el usuario indique precisamente cuál, diciendo exactamente
que renglones y números estarán involucrados, debe mostrarle al usuario la matriz resultante.  Cuando el usuario llegue a una forma escalonada, deberá decir-
le al usuario, mostrarle la matriz final y terminar el programa. Usted debe especificar al usuario cómo y en que orden debe introducir los valores y hacer 
las validaciones correspondientes.'

# Función para solicitar el tamaño de la matriz.
lectura <- function(){
  cat("Bienvenido.
Ingresa el tamaño de la matriz a ingresa.
Ingresa el número de renglones de la matriz (n):")
  n <- as.integer(readline())
  cat("Ingresa el número de columnas (m):")
  m <- as.integer(readline())
  cat("El tamaño de la matriz es: ",n,"x",m,".")
  tamano <- c(n,m)
  return(tamano)
}

# Función para ingresar los datos de la matriz.
datos_matrix <- function(n,m){
  matriz <- matrix(0, nrow=n, ncol=m)
  for (i in (1:n)){
    for (j in (1:m)){
      cat("Ingresa el elemento en la posición (",i,",",j,"):") 
      matriz[i,j] <- as.numeric(readline())
    }
  }
  cat("La matriz ingresada es:")
  print(matriz)
  matriz
}
# Operaciones elementales.
## Tipo I.
tipo_i <- function(matriz){
  cat("Ingresa la posición del primer renglón a intercambiar:")
  i <- as.integer(readline())
  cat("Ingresa la posición del segundo renglón a intercambiar: ")
  j <- as.integer(readline())
  aux <- matriz[i,]
  matriz[i,] <- matriz[j,]
  matriz[j,] <- aux
  matriz
}
## Tipo II.
tipo_ii <- function(matriz){
  cat("Ingresa el renglón al cual se le multiplicará por un escalar.")
  i <- as.integer(readline())
  cat("Ingresa el escalar (diferente de cero) que multiplicará al renglón", i,".")
  alpha <- as.numeric(readline())
  matriz[i,] <- alpha*matriz[i,]
  matriz
}
## Tipo III.
tipo_iii <- function(matriz){
  cat("Ingresa al vector al cual se le sumará el otro vector")
  i <- as.integer(readline())
  cat("Ingresa el segundo renglón.")
  j <- as.integer(readline()) 
  cat("Ingresa el escalar.")
  alpha <- as.numeric(readline())
  matriz[i,] <- matriz[i,]+alpha*matriz[j,]
  matriz
}

validacion_escalonada <- function(matriz){
  n <- nrow(matriz)
  for (i in 2:n){
    for (j in 1:(i-1)){
      if (matriz[i,j]!=0){
        return(0)
      }
    }
  }
  return(1)
}

operacion_elemental <- function(matriz){
  cat("Selecciona una operación elemental por renglones que se le aplicará a la matriz ingresada.
1. Tipo I: intercambiar dos renglones de la matriz.
2. Tipo II: multiplica un renglón por un escalar distinto de cero
3. Tipo III: reemplazar un renglón por la suma de ese renglón con el múltiplo escalar otro renglón")
  operacion_ingresada <- as.integer(readline())  
  if (operacion_ingresada==1){
    matriz <- tipo_i(matriz)
  }
  else if (operacion_ingresada==2){
    matriz <- tipo_ii(matriz)
  }
  else if (operacion_ingresada==3){
    matriz <- tipo_iii(matriz)
  }
  else{
    cat("Número ingresado.")
  }
  cat("La nueva matriz es:")
  print(matriz)
  
  salir <- validacion_escalonada(matriz)
  if (salir==0){
    operacion_elemental(matriz)
  }
  else{
    cat("La matriz escalodana por renglones es:")
    matriz
  }
}

escalodada_dinamica <- function(){
  tamano <- lectura()
  matriz <- datos_matrix(tamano[1], tamano[2])
  operacion_elemental(matriz)
}

'2. Programe una función en r que reciba de entrada una matriz y que realice la eliminación de Gauss y regrese la matriz escalonada por renglones. Es decir, 
a diferencia del problema 1 no debe haber intervención del usuario más que en la captura de la matriz.'
tipo_iii_automatica <- function(matriz, j, i){
  alpha <- -matriz[j,i]/matriz[i,i]
  matriz[j,] <- matriz[j,]+alpha*matriz[i,]
  matriz
}

eliminacion_gauss <- function(matriz){
  n <- nrow(matriz)
  for (i in 1:(n-1)){
    for (j in (i+1):n){
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
  tamano <- lectura()
  matriz <- datos_matrix(tamano[1], tamano[2])
  eliminacion_gauss(matriz)
}


'En ninguno de los dos programas se pueden usar comandos o librerías de r que resuelvan directamente el problema. Si puede usar librerías que mejoren la captu-
ra de datos o la presentación del programa.'