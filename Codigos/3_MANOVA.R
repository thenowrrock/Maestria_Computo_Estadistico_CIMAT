library(psych)

# Datos from Stevens(2009, p. 215)

stevens = matrix(c(1, 1, 13, 14,1, 1, 11, 15,1, 2, 23, 27,1, 2, 25, 29,1, 3, 32, 31,1, 3, 35, 37,
                      2, 1, 45, 47,2, 1, 55, 58,2, 1, 65, 63,2, 2, 75, 78,2, 2, 65, 66,2, 2, 87, 85,3, 1, 88, 85,3, 1, 91, 93,
                     3, 1, 24, 25,3, 1, 65, 68,3, 2, 43, 41,3, 2, 54, 53,3, 2, 65, 68,3, 2, 76, 74), ncol = 4, 
                    byrow=TRUE)
colnames(stevens) = paste("V",1:4,sep="")
rownames(stevens) = paste("S",1:20,sep="")
stevens 	

## medicion de la correlacion
ICC(stevens[,3:4])

options(scipen=999)
cor.test(stevens[,3],stevens[,4])

## Normalidad acerca de los datos
library(nortest)			    
depvar = data.frame(stevens[,3:4])	   
names(depvar) = c("ach1","ach2")	    
attach(depvar)			    

ad.test(ach1)		# Anderson-Darling
cvm.test(ach1)	# Cramer-von Mises
lillie.test(ach1)	# Kolmogorov-Smirnov
pearson.test(ach1)	# Pearson chi-cuadrado
sf.test(ach1)		# Shapiro-Francia

ad.test(ach2)		# Anderson-Darling
cvm.test(ach2)	# Cramer-von Mises
lillie.test(ach2)	# Kolmogorov-Smirnov
pearson.test(ach2)	# Pearson chi-cuadrado
sf.test(ach2)		# Shapiro-Francia

## Multivariada
library(mvnormtest)				
depvar = data.frame(stevens[,3:4])	    	
stevensT = t(depvar)			
shapiro.test(stevensT)			

## verificacion de la matriz de covarianzas
method1 = stevens[1:6,3:4]		
method2 = stevens[7:12,3:4] 	
method3 = stevens[13:20,3:4]	
method1
method2
method3

method1cov =  cov(method1)		
method1cov
det(method1cov)				

method2cov =  cov(method2)	
method2cov
det(method2cov)				

method3cov =  cov(method3)		
method3cov
det(method3cov)				

## Verificacion de la igualdad de covarianzas
library(biotools)			
options (scipen = 999) 		
factor(stevens[,1])			
boxM(stevens[,3:4], stevens[,1])	 

## Test MANOVA
library(MASS)
library(car)
library(psych)

## Seleccion de la variable de grupo, la primera es metodo
grp = factor(stevens[,1])			
Y = (stevens[,3:4])			            
fit = manova(Y~grp)

summary(fit,test="Wilks")
summary(fit,test="Pillai")
summary(fit,test="Hotelling-Lawley")
summary(fit,test="Roy")

## Ejemplo MANOVA Interaccciones
stevens = matrix(c(1, 1, 13, 14,1, 1, 11, 15,1, 1, 23, 27,1, 2, 25, 29,1, 2, 32, 31,1, 2, 35, 37,
                      2, 1, 45, 47,2, 1, 55, 58,2, 1, 65, 63,2, 2, 75, 78,2, 2, 65, 66,2, 2, 87, 85,3, 1, 88, 85,3, 1, 91, 93,
                      3, 1, 24, 25,3, 1, 65, 68,3, 2, 43, 41,3, 2, 54, 53,3, 2, 65, 68,3, 2, 76, 74), ncol = 4, 
                    byrow=TRUE)
stevens = data.frame(stevens)
names(stevens)=c("method","class","ach1","ach2")
stevens

fit  = manova(cbind(ach1,ach2) ~ method + class + method*class, data=stevens)
summary(fit, test="Wilks")

fit.model1  = manova(cbind(ach1,ach2) ~ method + class + method*class, data=stevens)
summary(fit.model1, test="Wilks")

fit.model2  = manova(cbind(ach1,ach2) ~ class + method + method*class, data=stevens)
summary(fit.model2, test="Wilks")

anova(fit.model1, fit.model2)

## Comparacion entre disenios Tipo II y Tipo III
library (car)
out = lm(cbind(ach1,ach2)~ method + class + method*class -1, data = stevens)
Manova(out,multivariate=TRUE,type = c("II"),test="Wilks")
Manova(out,multivariate=TRUE,type = c("III"),test="Wilks")

## Ejemplo 2


# Paquetes

library(MASS); library(car); library(pastecs)

# Crear vector de grupo y de datos

Group = gl(3,10,labels=c("CBT","BT","NT"))
Actions = c(5,5,4,4,5,3,7,6,6,4,4,4,1,1,4,6,5,5,2,5,4,5,5,4,6,4,7,4,6,5)
Thoughts = c(14,11,16,13,12,14,12,15,16,11,14,15,13,14,15,19,13,18,14,17,13,15,14,14,13,20,13,16,14,18)

# Organizar los datos
OCD = data.frame(Group, Actions, Thoughts)
OCD

# Estadisticos descriptivos por variable independiente 

by(OCD$Actions, OCD$Group, stat.desc, basic=FALSE)
by(OCD$Thoughts, OCD$Group, stat.desc, basic=FALSE)

# MANOVA
outcome = cbind(OCD$Actions,OCD$Thoughts)
model = manova(outcome ~ Group, data = OCD)

# Salida MANOVA 
options(scipen=999)
summary(model,intercept = TRUE)
summary(model,intercept = TRUE, test = 'Wilks')
summary(model,intercept = TRUE, test = 'Hotelling')
summary(model,intercept = TRUE, test = 'Roy')
