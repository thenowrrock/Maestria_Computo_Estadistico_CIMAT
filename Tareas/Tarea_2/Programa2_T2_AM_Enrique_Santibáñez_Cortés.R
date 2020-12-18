### Funciones modulares.
# Función para solicitar el tamaño de la matriz.
lectura <- function(){
  cat("Bienvenido.
Ingresa el tamaño de la matriz a ingresa.
Ingresa el número de renglones (n):")
  n <- readline() # Solicitamos el número de renglones validando que se un entero positivo.
  while(is.na(tryCatch(as.integer(n)))){
    cat("El número de renglones ingresado debe ser un entero. Intenta de nuevo.")
    n <- readline()
  }
  n <- as.integer(n)
  
  cat("Ingresa el número de columnas (m):")
  m <- readline() # Solicitamos el número de columnas validando que se un entero positivo.
  while(is.na(tryCatch(as.integer(m)))){
    cat("El número de columnas ingresado debe ser un entero. Intenta de nuevo.")
    m <- readline()
  }
  m <- as.integer(m)
  cat("El tamaño de la matriz es:",n,"x",m,".\n") # Imprimimos el tamaño de la matriz.
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
  tamano <- c(n,m)
  tamano
}

# Función para ingresar los datos de la matriz.
datos_matrix <- function(n,m){ # Los parametros es el tamaño de la matriz. 
  matriz <- matrix(0, nrow=n, ncol=m)
  for (i in (1:n)){
    for (j in (1:m)){
      cat("Ingresa el elemento en la posición (",i,",",j,"):") 
      num <- readline() # Solicitamos la entrada de la matriz, validando que sea un número. 
      while(is.na(tryCatch(as.numeric(num)))){
        cat("El valor ingresado no es valido. Intenta de nuevo, ingresa el elemento en la posición (",i,",",j,"):")
        num <- readline()
      }
      matriz[i,j] <- as.numeric(num)
    }
  }
  cat("La matriz ingresada es:\n") # Imprimimos la matriz ingresada.
  print(matriz)
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
  cat("------------------------------------------------------------------------\n")
  if(n==1){
    cat("La matriz ingresada ya esta en su forma escalonda.\n")
    print(matriz)
    stop()
  }
  
  if(m==1){
    new_matriz <- matrix(0,nrow = n,ncol=1)
    new_matriz[1,1] <-matriz[1,1]
    cat("La matriz escalodana por renglones es:\n")
    print(new_matriz)
    stop()
    }
  
  for (i in 2:n){
    for (j in 1:(i-1)){
      if (matriz[i,j]!=0){
        return(matriz)
      }
    }
  }
  cat("La matriz ingresada ya esta en su forma escalonda.\n")
  print(matriz)
  stop()
}
## Operaciones elementales.
# Operaciones elementales Tipo III.
tipo_iii_automatica <- function(matriz, j, i){
  n <- nrow(matriz)
  alpha <- -matriz[j,i]/matriz[i,i]
  
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij_alpha <- diag(1, n)+alpha*e_j%*%t(e_i)
  
  # Actualizamos la matriz con los datos ingresados.
  matriz <- E_ij_alpha%*%matriz
  matriz
}

# Operaciones elementales Tipo III.
tipo_i_automatica <- function(matriz, j, i){
  n <- nrow(matriz)
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij <- diag(1, n)-(e_j-e_i)%*%(t((e_j-e_i)))
  
  # Actualizamos la matriz con los datos ingresados.
  matriz <- E_ij%*%matriz
  matriz
}

# Función que itera en todos las renglones para ir convirtiendo el primer elemento en cero.
eliminacion_gauss <- function(matriz){
  n <- nrow(matriz)
  i <- 1
  while(i<n){
    for (j in (i+1):n){
      zero <- 0
      aux <- j
      while(zero!=1){
        if (matriz[i,i]==0){ # Si el pivote es cero, lo intercambiamos con un renglon que no
          matriz<-tipo_i_automatica(matriz,i,aux) # que no se cero.
          aux <- aux+1
          if (validacion_escalonada(matriz)==1){
            cat("La matriz escalodana por renglones es:\n")
            return(matriz)
          }
          if (aux>n){
            if(i<(n-1)){
              i<-i+1
            } else {
              zero <- 1
            }
          }
        }
        else{
          zero<-1
        }
      }
      matriz <- tipo_iii_automatica(matriz, j, i)
    }
    i <- i+1
  }
  salir <- validacion_escalonada(matriz) # Validamos si la matriz nueva ya se encuentra en su forma escalonada,
  if (salir==0){                        # si no se encuentra, itera al siguiente renglón.
    eliminacion_gauss(matriz)
  }
  else{
    cat("La matriz escalodana por renglones es:\n")
    return(matriz)
  }
}

escalonada <- function(){
  tamano <- lectura() # Solicitamos el tamaño de la matriz.
  matriz <- datos_matrix(tamano[1], tamano[2]) # Solicitamos la matriz.
  eliminacion_gauss(matriz) # Eliminación Gauss.
}

escalonada()
