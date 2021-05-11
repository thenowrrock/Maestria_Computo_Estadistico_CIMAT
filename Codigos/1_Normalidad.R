#  Verificacion de Normalidad

## Uso de paquetes y data sets
library(mvnormtest)			
data(attitude)				

## Revision de librerias y paquetes
library()			
data()			
attach(attitude)		
head (attitude, n=10)		

## Test de Shapiro wilks
## Test multivariado
mydata = t(attitude)			
mshapiro.test(mydata)		

## Test Univariado
apply(attitude,2,shapiro.test)


## Test multivariado de normalidad de Jarque-Bera
library(normtest)			
jb.norm.test(attitude)		

## Estadisticos y pruebas por variable
library(normwhn.test)			 	
normality.test1(attitude)			

# Diferentes tests de normalidad por variable	
library(nortest)			

## Utilizando la variable de rating 			 
ad.test(rating)		# Anderson-Darling
cvm.test(rating)		# Cramer-von Mises
lillie.test(rating)		# Kolmogorov-Smirnov
pearson.test(rating)		# Pearson chi-cuadrada
sf.test(rating)		# Shapiro-Francia


## Evaluacion de la matriz
micor = cor(attitude)      
det(micor)		        

micov = cov(attitude)	 
det(micov)		        	

#Conversion de la matriz de varianzas a correlaciones
mimatrix = cov2cor(micov)	
mimatrix				

micor	

## Comparaciones entre grupos
group = rep(c("boy","girl"),c(15,15))          
newdata= data.frame(attitude,group)           
head(newdata,n=10)                            

options (scipen = 999)  
boys = newdata[1:15,]	
boycov = cov(boys[,-8])	
det(boycov)			

girls = newdata[16:30,]	
girlcov = cov(girls[,-8])	
det(girlcov)			

## usando un paquete para el calculo de covarianzas y correlaciones
library(psych)				
describeBy(newdata, group = group)	
prueba = describeBy(newdata, group = group)

prueba[[1]]$mean
prueba[[2]]$mean

prueba[["girl"]]$mean
prueba[["boy"]]$mean

prueba$girl$mean

prueba

cov.list = lapply(unique(newdata$group),function(x) cov(newdata[newdata$group==x,-8]))	

cov.list[1]
cov.list[2]

## Correlaciones
boys = newdata[1:15,]    		
boycov = cov(boys[,-8])		  
boycor = cov2cor(boycov)	
boycor		

girls = newdata[16:30,]		
girlcov = cov(girls[,-8])	
girlcor = cov2cor(girlcov)	
girlcor				

## Test de BoxM para verificar la igualdad de covaianzas

## Ejemplo base
library(biotools)			
data(iris)				
factor(iris[,5])	
boxM(iris[, -5], iris[, 5])		


## Ejemplo con datos anteriores
data(newdata)		
factor(group) 			
prueba2 = boxM(newdata[,-8],newdata[,8])

prueba2$cov$boy
str(prueba2)

prueba2$p.value

prueba2$statistic

