### Funciones modulares.
# Función para solicitar el tamaño de la matriz.
lectura <- function(){
  cat("Bienvenido.
Ingresa el tamaño de la matriz cuadrada a ingresar:")
  n <- readline() # Solicitamos el número de renglones validando que se un entero positivo.
  while(is.na(tryCatch(as.integer(n)))){
    cat("El número de renglones ingresado debe ser un entero. Intenta de nuevo.")
    n <- readline()
  }
  n <- as.integer(n)
  return(n)
}

# Función para ingresar los datos de la matriz.
datos_matrix <- function(n){ # Los parametros es el tamaño de la matriz. 
  matriz <- matrix(0, nrow=n, ncol=n)
  for (i in (1:n)){
    for (j in (1:n)){
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
  matriz
}

# Función para validar si una matriz esta en su forma escalodana. 
validacion_escalonada_reducida <- function(matriz){ # Comprobamos que los elementos abajo de la diagonal deben de ser ceros.
  n <- nrow(matriz)
  m <- ncol(matriz)
  if(n==1){
    return(0)
  }
  
  for (i in 2:n){
    for (j in 1:(i-1)){
      if (matriz[i,j]!=0){
        return(0)
      }
    }
  }
  return(1)
}
## Operaciones elementales.
# Operaciones elementales Tipo III.
tipo_iii_automatica <- function(matriz, j, i, L){
  n <- nrow(matriz)
  alpha <- -matriz[j,i]/matriz[i,i]
  
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij_alpha <- diag(1, n)+alpha*e_j%*%t(e_i)
  E_ij_alpha_L <- diag(1, n)+(-alpha)*e_j%*%t(e_i)
  L <- L%*%E_ij_alpha_L
  
  # Actualizamos la matriz con los datos ingresados.
  matriz <- E_ij_alpha%*%matriz
  list(matriz=matriz,L=L)
}


# Función que itera en todos las renglones para ir convirtiendo el primer elemento en cero.
eliminacion_gaussiana <- function(matriz){
  n <- nrow(matriz)
  i <- 1
  L <- diag(1,n)
  while(i<n){
    for(j in min(c(n,i+1)):n){
      zero <- 0
      while(zero!=1){
          if (matriz[i,i]==0){ # Si el pivote es cero, lo intercambiamos con un renglon que no
            cat("La matriz no tiene descomposición LU.\n")
            cat("Debido a que no existen n pivotes, y lo que implica que no exista U.\n")
            cat("La última modificación de la matriz en donde se observa que no hay un pivote es:\n")
            print(matriz)
            stop()
        }
        else{
          zero<-1
        }
      }
      matriz <- tipo_iii_automatica(matriz, j, i, L)
      L <- matriz$L
      matriz <- matriz$matriz
    }
    i <- i+1
  }
  salir <- validacion_escalonada_reducida(matriz) # Validamos si la matriz nueva ya se encuentra en su forma escalonada,
  if (salir==0){                        # si no se encuentra, itera al siguiente renglón.
    eliminacion_gaussiana(matriz)
  }
  else{
    if(matriz[n,n]==0){
      cat("La matriz no tiene descomposición LU.\n")
      cat("Debido a que no existen n pivotes, y lo que implica que no exista U.\n")
      cat("La última modificación de la matriz en donde se observa que no hay un pivote es:\n")
      print(matriz)
      stop()
    }
    else{
    cat("La matriz ingresada tiene descomposición LU, donde la matriz U es:\n")
    print(matriz)
    cat("Y la matriz L, es:\n")
    return(L)
    }
  }
}

descomposicion_LU <- function(){
  n <- lectura() # Solicitamos el tamaño de la matriz.
  matriz <- datos_matrix(n) # Solicitamos la matriz.
  eliminacion_gaussiana(matriz) # Eliminación Gauss.
}

