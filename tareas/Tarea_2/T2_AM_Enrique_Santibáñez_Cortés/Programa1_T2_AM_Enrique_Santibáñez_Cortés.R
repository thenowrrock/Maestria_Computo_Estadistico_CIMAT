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
  return(matriz)
}
## Operaciones elementales.
# Validación de la posición ingresada.
validacion_posicion <- function(n){ # El paramatreo es el número de renglones.
  num <- readline() # Solicitamos la posición de un renglón, validando que tiene que ser un número menor o igual a n.
  h <- 1
  while(h!="listo"){
    while(is.na(tryCatch(as.integer(num)))){
      cat("La posición del renglón ingresado debe ser un entero menor o igual a",n,".","Intenta de nuevo.")
      num <- readline()
      }
    if(as.integer(num)<=n){
      h <- "listo"
    }
    else{
      cat("La posición del renglón ingresado debe ser un entero menor o igual a",n,".","Intenta de nuevo.")
      num<-validacion_posicion(n)
    }
  }
  return(as.integer(num))
}

# Operaciones elementales Tipo I.
tipo_i <- function(matriz){ # El parámetro es más actualizada.
  n <- nrow(matriz)
  cat("Ingresa la posición del primer renglón a intercambiar:")
  i <- validacion_posicion(n)
  cat("Ingresa la posición del segundo renglón a intercambiar:")
  j <- validacion_posicion(n)
  
  # Creamos los vectores canonicos:
  e_j <- matrix(0,n)
  e_j[j,1] <- 1
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  
  # Definomos la matriz elemental de tipo III:.
  E_ij <- diag(1, n)-(e_j-e_i)%*%(t((e_j-e_i)))
  
  # Actualizamos la matriz con los datos solicitados.
  matriz <- E_ij%*%matriz
  matriz
}

# Operaciones elementales Tipo II.
tipo_ii <- function(matriz){ # El parámetro es más actualizada.
  n <- nrow(matriz) 
  cat("Ingresa la posición del renglón al cual se le multiplicará un escalar.") # Solicitamos el renglón y escalar a los cuales se le aplicará la 
  i <- validacion_posicion(n)                                                   # operación elemental.
  cat("Ingresa el escalar (diferente de cero) que multiplicará al renglón", i,".")
  alpha <- readline()
  h <-1
  while(h!=0){
    while(is.na(tryCatch(as.numeric(alpha)))){ # Validamos que el escalar sea di
      cat("El escalar debe ser un número diferente de cero. Intenta de nuevo.")
      alpha <- readline()
    }
    if(as.numeric(alpha)!=0){
      h=0
      alpha <- as.numeric(alpha)
    } 
    else {
      alpha<-"as"
    }
  }
  
  # Creamos los vectores canonicos:
  e_i <- matrix(0,n)
  e_i[i,1] <- 1 
  print(alpha)
  # Definomos la matriz elemental de tipo III:.
  E_i_alpha <- diag(1, n)+(alpha-1)*e_i%*%t(e_i)
  matriz <- E_i_alpha%*%matriz
  matriz
}
## Tipo III.
tipo_iii <- function(matriz){
  n <- nrow(matriz)
  h <- 1
  while(h!=0){
    cat("Ingresa la posición del vector al cual se le sumará el múltiplo escalar de otro renglón.")
    j <- validacion_posicion(n)
    
    cat("Ingresa la posición del renglón que se multiplicará por escalar.")
    i <- validacion_posicion(n)
    if(i==j){
      cat("Los renglones tienen que ser distintos. Intenta de nuevo.\n")
    }
    else{
      h=0
    }
  }
  
  cat("Ingresa el escalar.")
  alpha <- readline()
  while(is.na(tryCatch(as.numeric(alpha)))){
    cat("El escalar debe ser un número. Intenta de nuevo.")
    alpha <- readline()
  }
  alpha <- as.numeric(alpha)
  
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
  cat("Selecciona una operación elemental por renglones que se le aplicará a la matriz ingresada.\n")
  cat("Ingresa:
1 para intercambiar dos renglones de la matriz (Tipo I).
2 para multiplica un renglón por un escalar distinto de cero (Tipo II).
3 para reemplazar un renglón por la suma de ese renglón con el múltiplo escalar otro renglón (Tipo III).")
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
    cat("La matriz no esta en su forma escalonada. Sigue realizando operaciones elementales.\n")
    operacion_elemental(matriz)
  }
  else{
    cat("Has llegado a obtener la matriz ingresada en la forma escalonada, la cual es:\n")
    matriz
  }
}

escalodada_dinamica <- function(){
  tamano <- lectura() # Solicitamos el tamaño de la matriz.
  matriz <- datos_matrix(tamano[1], tamano[2]) # Solicitamos la matriz.
  operacion_elemental(matriz) # Operaciones elementales.
}

escalodada_dinamica()

