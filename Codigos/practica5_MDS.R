# Practica 5. Aplicacion de modelos de escalamiento multidimensional
library("MASS")
#library("alr3")
library("stats") #esta libreria incluye la funcion que realiza el MDS cl?sico
#library("scatterplot3d")
library("smacof") #Libreria incluye las funciones que realizan el MDS de minimos cuadrados usando SMACOF

#source("/OTRAS ACTIVIDADES ROD/curso_INEGI_AGS_MULTIVARIADO/analisis_factores/functions_imp.r")

######################################################################################

#se leen los datos de similaridades entre naciones. 

prox_nations <- read.csv("DATOS_NACIONES.csv", header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE, na.strings = "NA")

#nombre de las naciones
nombres <- names(prox_nations)



#Nota: como los datos representan similaridades, debemos transformarlas a disimilaridades.
#primero identificamos el valor maximo en las similaridades, entonces las similaridades
#las transformamos a disimilaridades como disi=(max(sim)+1)-sim
maximo <- max(prox_nations)+1
disim_nations <- maximo-prox_nations

#sin embargo los elementos de la diagonal de la matriz de disimilaridades(disim_nations)
#son distintos de cero, todos
#son iguales al maximo de la similaridades. Entonces los elementos diagonales de la matriz de disimilaridades los
#convertimos en ceros
disim_nations <- disim_nations- diag(maximo,length(disim_nations),length(disim_nations))

# Se aplica el modelo cl?sico de MDS (coordenadas principales)

#funci?n que realiza el mds clasico
resul_mds_clas<-cmdscale(disim_nations, k = 2, eig = TRUE, add = FALSE, x.ret = FALSE)

#k es la dimension de la solucion
#eig: indica si los valores propios se regresan
#add: cuando  se a?ade una constante aditiva para convertir las disimilaridades
#en distancias euclideas
#x.ret indica si la matriz de doble centrado (B) se regresa

#Nota: si no se especifica la dimension, por default se da la soluci?n en dos dimensiones


# se extrae la configuracion solucion X
config_nations<-resul_mds_clas$points

#se a?aden los nombres de las naciones a la configuracion solucion X
dimnames(config_nations)[[1]]<-nombres

#se grafica la configuracion solucion obtenida mediante mds clasico

plot(config_nations[,1],config_nations[,2],main="configuracion solucion mediante mds clasico",ylim=range(config_nations[,1]),
     xlab="dim 1",ylab="dim 2",type="n",lwd=2)
text(config_nations[,1],config_nations[,2],
     labels=abbreviate(row.names(config_nations),minlength=8),cex=0.6,lwd=2)

# se obtiene la proporcion de la varianza total explicada por las dos dimensiones
resul_mds_clas$GOF

#con 2 dim se explica el 50 o 60% de la variabilidad total de los datos



########################################################################
# Se aplica el modelo de minimos cuadrados utilizando el algoritmo SMACOF
#resul_mds_mc <- smacofSym(disim_nations, ndim=2,weightmat = NULL, init = "torgerson",
#                           verbose = TRUE, relax = FALSE, itmax = 1000, eps = 1e-06) 

resul_mds_mc <- smacofSym(disim_nations, ndim=2,type = "ratio", init = "torgerson", itmax = 1000, eps = 1e-06) 

#ndim: indica la dimensionalidad de la soluci?n considerada
#type:indica el tipo de transformaci?n que vamos a usar para convertir las disimilaridades
#a disparidades
#init: indica la configuracion inicial que se eligira, por lo general se elige la
#solucion clasica (coordenadas principales), tambien llamada de Torgeson
#itmax: numero de iteraciones en el algoritmo smacof
#eps: el criterio de convergencia (para parar el algoritmo)

#se grafica la configuracion solucion obtenida mediante smacof,  incluyendo los nombres de los paises

config_nations_mc<-resul_mds_mc$conf

plot(config_nations_mc[,1],config_nations_mc[,2],main="configuracion solucion mediante smacof",ylim=range(config_nations_mc[,1]),
     xlab="Dim 1",ylab="Dim 2",type="n",lwd=2)
text(config_nations_mc[,1],config_nations_mc[,2],
     labels=abbreviate(nombres,minlength=8),cex=0.6,lwd=2)


#se obtienen los diagrama de shepard, para evaluar la calidad de la soluci?n y la calidad
# de la transformaci?n 


#primero obtenemos el diagrama de Shepard para evaluar la calidad de la soluci?n graficando
#las disparidades vs las distancias ajustadas
#plot(resul_mds_mc,main = "Diagrama de Shepard", plot.type = "Shepard")
plot(resul_mds_mc,main = "Grafica de las disparidades vs las distancias ajustadas", plot.type = "resplot")
#plot(yy,zz,main ="Grafica de las disparidades vs las distancias ajustadas", xlab="Disparidades",ylab="Distancias")


#se obtiene el diagrama de shepard, para evaluar la calidad de la transformacion, graficando
#las disimilaridades vs las disparidades

xx<-(as.vector(resul_mds_mc$delta))
yy<-(as.vector(resul_mds_mc$dhat))
#zz<-(as.vector(resul_mds_mc$confdist))

plot(xx,yy,main ="Grafica de las disimilaridades vs las disparidades", xlab="Disimilaridades",ylab="Disparidades")


#Conclusiones
#El grafico muestra la oposicion que existia entre paises desarrollados y subdesarrollados y paises occidentales y comunistas
#en los a?os 70, reflejando la situaci?n socio politica de los paises en esa epoca

#la dim 1 se puede interpretar como una dimension de alineacion pol?tica o regimen politico (comunistas y capitalistas)
#la dim 2 se puede interpretar como una dimension de desarrollo econ?mico(paises desarrollados y subdesarrollados)

#Nota: si la configuracion  es rotada y trasladada, las distancias entre los paisess no cambiaran, por tanto se dice que
#las soluciones de MDS son invariantes antes rotaciones y traslaciones. Por tanto las configuraciones se pueden rotar para
#obtener una solucion mas facil de interpretar.




###Aplicaci?n de modelos de unfolding

#se leen los datos de preferencias

pref_desayunos<- read.csv("datos_desayunos.csv", header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE, na.strings = "NA")

#nombre de los tipos de desayunos
nombres<- names(pref_desayunos)
  
# Se aplica el modelo de unfolding para representar los estudiantes y los tipos de desayuno
#usando el algoritmo smacof

#funci?n que realiza unfolding utilizando el algoritmo SMACOF
resul_unfold_desayunos<-smacofRect(pref_desayunos, ndim= 2,type = "ordinal",conditionality="row",itmax = 10000, eps = 1e-06) 

#delta: la matriz de preferencias originales
#ndim: indica la dimensionalidad de la soluci?n considerada
#type:indica el tipo de transformaci?n que vamos a usar para convertir las disimilaridades
#a disparidades

#conditionality: La manera de aplicar la transformaci?n. Se tienen dos opciones:
#  1. aplicar la misma transformacion a la matriz completa (sin condiciones)
#  2. aplicar una transformacion para cada renglon de manera separada (condicionada por renglones)

#se grafican la solucion para los individuos (estudiantes)
#plot(resul_unfold_desayunos$conf.row)

#se grafican la solucion para los objetos(tipos de desayunos)
#plot(resul_unfold_desayunos$conf.col)


#se grafican las configuraciones soluciones para los individuos(estudiantes)
#y para los objetos (tipos de desayunos) obtenida mediante unfolding con el algoritmo SMACOF


plot(resul_unfold_desayunos,main="configuracion conjunta de los estudiantes y tipo de desayuno",
     xlab="Dim 1",ylab="Dim 2",type="n",lwd=2)


# se realiza un diagnostico para evaluar la calidad de la soluci?n y la calidad de la transformacion

xx<-(as.vector(resul_unfold_desayunos$obsdiss))
yy<-(as.vector(resul_unfold_desayunos$dhat))
zz<-(as.vector(resul_unfold_desayunos$confdist))

#se obtiene el diagrama de shepard, para evaluar la calidad de la soluci?n, graficando
#las disparidades vs las distancias euclidianas ajustadas

plot(yy,zz,main ="Grafica de las disparidades vs las distancias euclidianas", xlab="Disparidades",ylab="Distancias euclideas")
#plot(resul_unfold_desayunos,plot.type="Shepard")

#se obtiene el diagrama de shepard, para evaluar la calidad de la transformacion, graficando
#las disimilaridades vs las disparidades

plot(xx,yy,main ="Grafica de las disimilaridades vs las disparidades", xlab="Disimilaridades",ylab="Disparidades")

#interpretacion de la configuracion

#el eje horizontal (dim1) parece discriminar entre panes suaves y panes duro (tostadas), con
#desayunos mas suaves a medida que se mueven a la izquierda del eje 1

#el eje vertical (dim2) no tiene una clara interpretaci?n, aunque tal vez discrimina basado en la
#conveniencia, entre desayunos mas formales que se ubican en la parte inferior del eje y los
#desayunos mas informales que aparecen en la parte superior o en el medio
 
#tambien se observan varios grupos de desayunos. Por ejemplo las donas glaseadas, las donas
#con jalea y pastel danes forman un grupo de desayunos suaves y algo informales.
#Las magdalenas,tostada de canela y los bollos forman un grupo de desayunos mas formales 
#y duros.
#Las otras tostadas y panes duros forman un grupo de desayunos duros y algo informales