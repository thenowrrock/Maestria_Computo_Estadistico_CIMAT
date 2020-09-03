## Funciones modulares.
# Función para solicitar el tamaño de la matriz.
validacion_integer <- function(){
  
}


lectura <- function(){
  cat("Bienvenido.
Ingresa el tamaño de la matriz a ingresa.
Ingresa el número de renglones (n):")
  n <- readline()
  while(is.na(tryCatch(as.integer(n)))){
    cat("El número de renglones ingresado debe ser un entero. Intenta de nuevo.")
    n <- readline()
  }
  n <- as.integer(n)
  cat("Ingresa el número de columnas (m):")
  m <- readline()
  while(is.na(tryCatch(as.integer(m)))){
    cat("El número de renglones ingresado debe ser un entero. Intenta de nuevo.")
    m <- readline()
  }
  m <- as.integer(m)
  cat("El tamaño de la matriz es:",n,"x",m,".\n")
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
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
  cat("La matriz ingresada es:\n")
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
  n <- nrow(matriz)
  
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij <- diag(1, n)-(e_j-e_i)%*%(t((e_j-e_i)))
  matriz <- E_ij%*%matriz
  matriz
}
## Tipo II.
tipo_ii <- function(matriz){
  cat("Ingresa el renglón al cual se le multiplicará por un escalar.")
  i <- as.integer(readline())
  cat("Ingresa el escalar (diferente de cero) que multiplicará al renglón", i,".")
  alpha <- as.numeric(readline())
  n <- nrow(matriz)
  
  # Creamos los vectores canonicos:
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_i_alpha <- diag(1, n)+(alpha-1)*e_i%*%t(e_i)
  matriz <- E_i_alpha%*%matriz
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
  n <- nrow(matriz)
  
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij_alpha <- diag(1, n)+alpha*e_j%*%t(e_i)
  matriz <- E_ij_alpha%*%matriz
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
  cat("La nueva matriz es:\n")
  print(matriz)
  
  salir <- validacion_escalonada(matriz)
  if (salir==0){
    operacion_elemental(matriz)
  }
  else{
    cat("La matriz escalodana por renglones es:\n")
    matriz
  }
}

escalodada_dinamica <- function(){
  tamano <- lectura() # Solicitamos el tamaño de la matriz.
  matriz <- datos_matrix(tamano[1], tamano[2]) # Solicitamos la matriz.
  operacion_elemental(matriz)
}

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