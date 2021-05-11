# Test de Hotelling para una sola muestra
library(ICSNP) 
library (mvtnorm)

# Datos de dos variables dependientes
Y1 = c(-2,-4,-6,-3,-7,-2,-1,-8,-6,-9)
Y2 = c(3,4,9,3,5,4,2,4,2,8)
Y12 = data.frame(Y1,Y2)
names(Y12) = c("DV1","DV2")
Y12

# Estadisticos descriptivos
cor(Y12); cov(Y12)
mean(Y12$DV1); sd(Y12$DV1)
mean(Y12$DV2); sd(Y12$DV2)

## Visualizacion de los datos
library(psych)
error.bars(Y12, ylab="Medias grupales",xlab="Variables dependientes",
           ylim=c(-10,10), eyes=FALSE)

# Test de Hotelling para medias igual a 0
muH0 <- c(0, 0)
HotellingsT2(Y12, mu=muH0)

prueba3 <- HotellingsT2(Y12, mu=muH0)

#####################
## Test de Hotelling para dos muestras
####################
library(ICSNP) 
library (mvtnorm)

# Usaremos datos del libro James Steven (5th Edition) P. 148
# con las variables independientes Roger vs Adler
# Asignar informacion a los vectores

roger = matrix(c(1,3,2,3,7,2),3,2)
adler = matrix(c(4,6,6,5,5,4,6,8,8,10,10,6),6,2)

# Imprimimos las variables por grupo
## la primera variable corresponde a efectividad del tratamiento
## la segunda a satisfaccion con el tratamiento

roger
adler

# Creamos una variable indicadora y la declaramos como factor

grp = matrix(c(1,1,1,2,2,2,2,2,2),9,1)
factor(grp)
grp

# Combinar las dos matrices de variables independientes

Y12 = data.frame(rbind(roger,adler))
names(Y12) = c("Y1","Y2")
attach(Y12)
Y12

# Eliminamos la notacion cientifica
options(scipen=999)

# Imprimimos los estadisticos descriptivos
cor(Y12) 
mean(Y1); sd(Y1)
mean(Y2); sd(Y2)

# Graficar las medias de las variables independientes
library(gplots)

group = data.frame(grp)
Y123 = data.frame(group,Y12)

par(mfrow = c(2, 1))

plotmeans(Y1 ~ grp,data=Y123,ylim=c(0,10),xlab="Grupos",legends=c("Roger","Adler"),main = "Efectividad",connect=FALSE,mean.labels=TRUE,col=NULL,p=1.0)
plotmeans(Y2 ~ grp,data=Y123,ylim=c(0,10),xlab="Grupos",legends=c("Roger","Adler"),main = "Satisfaccion",connect=FALSE,mean.labels=TRUE,col=NULL,p=1.0)

# Test de Barlett para la igualdad de matrices de covarianaza
# Calcular las matrices de covarianza para cada grupo
p = 2
n1 = 3
n2 = 6
s1 = var(roger)
s2 = var(adler)

#  Calcular el estimado de la matriz de covarianza combinada
s = ((n1-1)*s1+(n2-1)*s2)/(n1+n2-2) 

# Calcular los valores propios para cada matriz de covarianza
es = eigen(s)
es1= eigen(s1)
es2 = eigen(s2)

M = (n1+n2-2)*log(prod(es$values))
M = M-(n1-1)*log(prod(es1$values)) - (n2-1)*log(prod(es2$values))
CI = 1-((2*p*p+3*p-1)/(6*(p+1)))*((1/(n1-1)) + (1/(n2-1))-(1/(n1+n2-2)))
B = CI*M
df = p*(p+1)/2
pval = 1-pchisq(B,df)

cat("Test de Barlett = ",B," df = ",df," p-value = ",pval,fill=T)


## Test de BoxM para la igualdad de varianzas
boxM(Y12,grp)

# Funcion HotellingsT2 
# Correr las estadisticas T2

Y12 = rbind(roger,adler)
HotellingsT2(roger,adler)

HotellingsT2(Y12 ~ grp)

######################################################## 
# T2 de Hotelling robusto con salida del vector de medias 
########################################################


library(rrcov)
T2.test(Y12 ~ grp)

# Metodo alternativo usando las dos matrices

HotellingsT2(roger,  adler, mu=NULL, test="f")

#  Calcular el valor F para la prueba T2 de Hotelling 
# Tamanio de muestras, numero de variables dependientes y valor T

n1 = 3
n2 = 6
p = 2
T = 3

# calculo de los grados de libertad para numerador y denominador

df1 = p
df2 = n1 + n2 - p -1

# Calcular el valor de F y el valor p

Fval =  (df2/df1) * T
pval =  round(1-pf(Fval,df1,df2),digits=3)

# Imprimir  T, F, df1, df2, and p-valor

cat("T = ",T,"F =",Fval,"df1 =",df1,"df2 =",df2," p-valor=",pval,fill=FALSE,"\n")

# T de Hotelling para muestra dependiente
library(ICSNP) 
library (mvtnorm)

# Introducimos datos para los dos variables dependientes (Pre y Post)
# y los dos grupos  (boys y girls)

Y1g1 = PreBoy  = c(12,16,18,12,10)
Y2g1= PostBoy = c(14,16,18,10,12)
Y1g2= PreGirl = c(5,2,7,4,15)
Y2g2= PostGirl = c(8,2,16,10,14)
mydata = data.frame(PreBoy,PostBoy,PreGirl,PostGirl)
attach(mydata)
mydata

# Calculo de los estadisticos descriptivos para las variables dependientes en cada grupo 

mean(PreBoy);sd(PreBoy)
mean(PostBoy);sd(PostBoy)
mean(PreGirl);sd(PreGirl)
mean(PostGirl);sd(PostGirl)

#  Enfoque 1 -Diferencias en los puntajes 

diffBoy = PostBoy - PreBoy
diffGirl = PostGirl - PreGirl

mean(diffBoy);sd(diffBoy)
mean(diffGirl);sd(diffGirl)

# Grafica de las medias de las diferencias
library(psych)

# Ponemos la diferencias en los puntajes en la dataframe
# Imprimos la diferencia
YDiff = data.frame(diffBoy,diffGirl)
YDiff

error.bars(YDiff,bar=FALSE,ylab="Mean Difference",xlab="Groups",ylim=c(-10,10),eyes=FALSE)

# Calculamos el T2 en la diferencia de los puntajes para hombres 
muH0 = c(0)
HotellingsT2(diffBoy, mu=muH0)

# Calculamos el T2 en la diferencia de puntajes para mujeres 
muH0 = c(0)
HotellingsT2(diffGirl, mu=muH0)

# Enfoque 2- Calculamos las diferencias para todo el conjunto de datos 

g = 2  # Numero de grupos
N = 5  # Numero de sujetos por grupo

Group = matrix(rep(1:g, each=N))
Pre=c(PreBoy,PreGirl)
Post=c(PostBoy,PostGirl)
YDiff   = data.frame(Pre,Post,Group)
names(YDiff) = c("Pre","Post","Grupo")
factor(Group) 
YDiff

# Estadisticos Descriptivos
mean(Pre)
mean(Post)

# Crear una matriz de diferencia de puntuaciones para todos los estudiantes
# Imprimir las diferencias 
# Calcular la diferencia promedio 

Diff = cbind(Post-Pre)
Diff
mean(Diff)

# Calcular el T2 para diferencia en todos los estudiantes 
muH0 = c(0)
HotellingsT2(Diff, mu=muH0)

#####################################################
# Forma Alternativa
######################################################

N = 5  # Numero de sujetos
P = 2  # Numero de variables dependientes

Ydf   = data.frame(id=factor(rep(1:N,times=P)),
                   Y1=c(Y1g1,Y1g2),
                   Y2=c(Y2g1,Y2g2),
                   IV=factor(rep(1:P, each=N),labels = c("g1","g2")))

dfDiff = aggregate(cbind(Y1,Y2) ~ id,data = Ydf,FUN = diff)
YDiff2 = data.matrix(dfDiff[,-1])
YDiff2

muH0 = c(0, 0)
HotellingsT2(YDiff2, mu=muH0)

