
#Ruta de datos correspondiente
setwd("d:/AdministracionProyectos/2018/Estadisticamultivariada/Laboratorio/Regression/Data/Data/")

production <- read.table("production.txt",header=TRUE)
attach(production)

## Grafica exploratoria
par(mfrow=c(1,1))
plot(production$RunSize, production$RunTime,xlab="Run Size", ylab="Run Time")

## Modelo Simple
m1 <- lm(RunTime~RunSize )
summary(m1)

## Linea de modelo con datos originales
plot(production$RunSize,production$RunTime,xlab="Run Size", ylab="Run Time")
abline(lsfit(production$RunSize,production$RunTime))


## Intervalos de confianza al 95% de los parametros
round(confint(m1,level=0.95),3)

## Intervalos de confianza y de prediccion
predict(m1,newdata=data.frame(RunSize=c(50,100,150,200,250,300,350)),interval="confidence",level=0.95)
predict(m1,newdata=data.frame(RunSize=c(50,100,150,200,250,300,350)),interval="prediction",level=0.95)

## Prueba anova para una regresion
anova(m1)


detach(production)

## Evaluacion de una regresion
anscombe <- read.table("anscombe.txt",header=TRUE)
attach(anc
scombe)

## Visualizacion de los elementos y una regresion simple
par(mfrow=c(2,2))
plot(x1,y1,xlim=c(4,20),ylim=c(3,14),main="Conjunto 1")
abline(lsfit(x1,y1))
plot(x2,y2,xlim=c(4,20),ylim=c(3,14),main="Conjunto 2")
abline(lsfit(x2,y2))
plot(x3,y3,xlim=c(4,20),ylim=c(3,14),main="Conjunto 3")
abline(lsfit(x3,y3))
plot(x4,y4,xlim=c(4,20),ylim=c(3,14),main="Conjunto 4")
abline(lsfit(x4,y4))

## Parametros de la regresion para los elementos
m1 <- lm(y1~x1)
summary(m1)
m2 <- lm(y2~x2)
summary(m2)
m3 <- lm(y3~x3)
summary(m3)
m4 <- lm(y4~x4)
summary(m4)

## Comparacion de los residuales para cada conjunto de datos
par(mfrow=c(2,2))
plot(x1,m1$residuals,ylab="Residuales",xlim=c(4,20),ylim=c(-3.5,3.5),main="Conjunto 1")
plot(x2,m2$residuals,ylab="Residuales",xlim=c(4,20),ylim=c(-3.5,3.5),main="Conjunto 2")
plot(x3,m3$residuals,ylab="Residuales",xlim=c(4,20),ylim=c(-3.5,3.5),main="Conjunto 3")
plot(x4,m4$residuals,ylab="Residuales",xlim=c(4,20),ylim=c(-3.5,3.5),main="Conjunto 4")

## Graficos basicos para verificacion de regresion
production <- read.table("production.txt",header=TRUE)
attach(production)

m1 <- lm(RunTime~RunSize)
par(mfrow=c(2,2))
plot(m1)

## Verificacion del efecto de outliers en una regresion
bonds <- read.table("bonds.txt",header=TRUE)
attach(bonds)

## Grafica exploratoria
par(mfrow=c(1,1))
plot(CouponRate,BidPrice,xlab="Tasa Bono (%)", ylab="Precio subasta ($)",ylim=c(85,120),xlim=c(2,14))
abline(lsfit(CouponRate,BidPrice))

## Regresion Inicial
m1 <- lm(BidPrice~CouponRate)
summary(m1)

## Intercalos de confianza al 95%
round(confint(m1,level=0.95),3)

#Table 3.4 on page 62
leverage1 <- hatvalues(m1)
StanRes1 <- rstandard(m1)
residual1 <- m1$residuals
cbind(Case,CouponRate,BidPrice,round(leverage1,3),round(residual1,3),round(StanRes1,3))

## Grafica de residuales estandarizados
plot(CouponRate,StanRes1,xlab="Tasa Bono (%)", ylab="Residuales estandarizados",xlim=c(2,14))
abline(h=2,lty=2)
abline(h=-2,lty=2)
identify(CouponRate,StanRes1,Case)


## Regresion sin los puntos atipicos
m2 <- update(m1, subset=(1:35)[-c(4,13,35)])
summary(m2)

## Grafica de la regresion sin los puntos atipicos
plot(CouponRate[-c(4,13,35)],BidPrice[-c(4,13,35)],xlab="Tasa Bono (%)", ylab="Bid Price ($)",ylim=c(85,120),xlim=c(2,14),main="Regular Bonds")
abline(m2)

## Residuales estandarizados sin los puntos atipicos
StanRes2 <- rstandard(m2)
plot(CouponRate[-c(4,13,35)],StanRes2,xlab="Tasa Bono (%)", ylab="Residuales estandarizados",xlim=c(2,14),main="Bonos regulares")
abline(h=2,lty=2)
abline(h=-2,lty=2)

## Uso de la distancia de Cook en el modelo con dotos los datos
cd1 <- cooks.distance(m1)
plot(CouponRate,cd1,xlab="Tasa Bono (%)", ylab="Distancia de Cook")
abline(h=4/(35-2),lty=2)
identify(CouponRate,cd1,Case)

## Ejemplo del uso de transformacion para
## controlar la varianza

cleaning <- read.table("cleaning.txt",header=TRUE)
attach(cleaning)

## Grafica exploratoria
par(mfrow=c(1,1))
plot(Crews,Rooms,xlab="Tamanio Equipo",ylab="Numero de cuartos limpiados")
abline(lsfit(Crews,Rooms))

## Regresion inicial
m1 <- lm(Rooms~Crews)
summary(m1)
predict(m1,newdata=data.frame(Crews=c(4,16)),interval="prediction",level=0.95)

## Verificacion de los residuales estandarizados
StanRes1 <- rstandard(m1)
plot(Crews,StanRes1,xlab="Tamanio Equipo", ylab="Residuales estandarizados")

## Uso de una transformacion
sabs <- sqrt(abs(StanRes1))
plot(Crews,sabs,xlab="Tamanio Equipo", ylab="Raiz cuadrada(|Residuales estandarizados|)")
abline(lsfit(Crews,sabs))

## Analisis de residuales
par(mfrow=c(2,2))
plot(m1)

## Analisis de la desviacion estandar
sqrt(tapply(Rooms,Crews,var))
sds <- c(3.000000,4.966555,4.690416,6.642665,7.927123,7.28991,12.000463)
xx <- c(2,4,6,8,10,12,16)
par(mfrow=c(1,1))
plot(xx,sds,xlab="Tamanio Equipo", ylab="Desviación estandar(Cuartos limpiados)")
abline(lsfit(xx,sds))

## Modelacion con transformacion de potencia
sqrtcrews <- sqrt(Crews)
sqrtrooms <- sqrt(Rooms)
m2 <- lm(sqrtrooms~sqrtcrews)
summary(m2)
predict(m2,newdata=data.frame(sqrtcrews=c(2,4)),interval="prediction",level=0.95)

## Graficos de los datos y residuales con la transformacion
par(mfrow=c(1,2))
plot(sqrt(Crews),sqrt(Rooms),xlab="Raiz cuadrada(Tamanio Equipo)",ylab="Raiz cuadrada(Numero de cuartos limpiados)")
abline(lsfit(sqrt(Crews),sqrt(Rooms)))
StanRes2 <- rstandard(m2)
plot(sqrtcrews,StanRes2,xlab="Raiz cuadrada(Tamanio Equipo)", ylab="Residuales estandarizados")

par(mfrow=c(2,2))
plot(m2)
