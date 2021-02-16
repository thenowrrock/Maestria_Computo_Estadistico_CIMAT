## Author:       Wolfgang Haerdle 20091001
##

## Graficas de caja

## Variable 6
x    = read.table('Documentos/Maestría/Estadistica_multivariada/Datos/bank2.dat.txt')
m1 = mean(x[1:100,6])
m2 = mean(x[101:200,6])

a <- boxplot(x[1:100,6], x[101:200,6], axes=FALSE, frame=TRUE)
axis(side=1, at=seq(1,2),label=c('GENUINO','FALSIFICADO') )
axis(side=2, at=seq(130,150,.5), label=seq(130,150,.5))
title('Billetes Suizos')
lines(c(0.6, 1.4),c(m1, m1),lty="dotted",lwd= 1.2, col="red")
lines(c(1.6, 2.4), c(m2, m2),lty = "dotted",lwd = 1.2,col="red")



## Variable 1
m1 = mean(x[1:100, 1])
m2 = mean(x[101:200, 1])

b <- boxplot(x[1:100, 1], x[101:200, 1], axes = FALSE, frame = TRUE)
axis(side = 1, at = seq(1, 2), label = c('GENUINO','FALSIFICADO'))
axis(side = 2, at = seq(200, 250, .5), label = seq(200, 250, .5))
title('Billetes Suizos')
lines(c(0.6, 1.4), c(m1, m1),lty = "dotted",lwd = 0.8, col="red")
lines(c(1.6, 2.4), c(m2, m2),lty = "dotted",lwd = 0.8, col="red")

## Histogramas
x = x[101:200,6];

origin = 137.75;

# Como  el origen es mejor que el minimo, los histogramas incluyen todos los valores
y1 = seq(137.75,141.05,0.1)
y2 = seq(137.75,141.05,0.2)
y3 = seq(137.75,141.05,0.3)
y4 = seq(137.75,141.05,0.4)

par(mfrow=c(2,2))

hist(x,y1, ylab="Diagonal", xlab="h = 0.1", xlim=c(137.5,141), ylim=c(0,10.5), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,10,2),labels=seq(0,10,2))

hist(x,y3, ylab="Diagonal", xlab="h = 0.3", xlim=c(137.5,141), ylim=c(0,31.5), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,30,5),labels=seq(0,30,5))

hist(x,y2, ylab="Diagonal", xlab="h = 0.2", xlim=c(137.5,141), ylim=c(0,21), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,20,5),labels=seq(0,20,5))

hist(x,y4, ylab="Diagonal", xlab="h = 0.4", xlim=c(137.5,141), ylim=c(0,42), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,40,10),labels=seq(0,40,10))


## Histogramas con diferentes inicios y mismo tamanio de intervalo
x = read.table('bank2.dat');
x = x[101:200,6];

origin1 = 137.65;
origin2 = 137.75;
origin3 = 137.85;
origin4 = 137.95;

y1 = seq(origin1, 141.05,0.4)
y2 = seq(origin2, 141.05,0.4)
y3 = seq(origin3-0.4, 141.05,0.4) # origin>min(x)
y4 = seq(origin4-0.4, 141.05,0.4) # origin>min(x)

par(mfrow=c(2,2))
hist(x,y1, ylab="Diagonal", xlab="x_0 = 137.65", xlim=c(137.5,141), ylim=c(0,42), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,40,20),labels=seq(0,40,20))

hist(x,y3, ylab="Diagonal", xlab="x_0 = 137.85", xlim=c(137.5,141), ylim=c(0,42), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,40,20),labels=seq(0,40,20))

hist(x,y2, ylab="Diagonal", xlab="x_0 = 137.75", xlim=c(137.5,141), ylim=c(0,42), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,40,20),labels=seq(0,40,20))

hist(x,y4, ylab="Diagonal", xlab="x_0 = 137.95", xlim=c(137.5,141), ylim=c(0,42), main="Billetes Suizos", axes=FALSE)
axis(side=1, at=seq(138,141), labels=seq(138,141))
axis(side=2, at=seq(0,40,20),labels=seq(0,40,20))

## Histogramas con promedio y recorridos
x = read.table('bank2.dat');
x = x[,6];             #Only consider the diagonal

n = length(x);         # Numero de observaciones
step = c(2,8,4,16);    # Definir el sumero de corrimientos

t0 = NULL
tf = NULL

for (l in 1:4) {

        ## l <- 1
        h = 0.4;
        t0 = h*(floor(min(x)/h)+0.5); #Min
        tf = h*(floor(max(x)/h)-0.5); #Max

        m = step[l];
        delta = h/m;

        nbin = floor((max(x)-min(x))/delta);
        binedge = seq(min(x),max(x),delta); # Establecer el numero de intervalos del histograma

        ## ex=x[x<=142.2]
        ## vk = plot(apply(x,1,sort),type="l")

        vk = hist(x,binedge,plot=FALSE)$counts; #Contar el numero de elementos en cada intervalo
        fhat = c(rep(0,m-1),vk,rep(0,m-1));

        kern = function(s) 1-abs(s);
        ind = (1-m):(m-1);
        den = sum(kern(ind/m));
        wm = m*(kern(ind/m))/den;

        fhatk=matrix(0,0,n+1);

        for (k in 1:nbin){
                ind = k:(2*m+k-2);
                fhatk[k] = sum(wm*fhat[ind]);
        }

        fhatk = fhatk/(n*h);
        binedge=c(rep(0,1),binedge);
        fhatk=c(rep(0,1),fhatk,rep(0,2));

        ## Graficar los diferentes histogramas
        split.screen(c(2,2))
        screen(l)
        plot(binedge,fhatk, type="s",ylim=c(0, 0.5), xlim=c(137.1, 142.9),main= 'Billetes Suizos', xlab=paste(step[l],' Corrimiento'), ylab='Diagonal', axes=FALSE, frame=TRUE)
        axis(side=1, at=seq(138,142),labels=seq(138,142))
        axis(side=2,at=seq(0,0.4,0.1),labels=seq(0,0.4,0.1))
}

## Estimacion de densidades

library(KernSmooth)

x = read.table('bank2.dat');
x1 = x[1:100,6];
x2 = x[101:200,6];

fh1 = bkde(x1, kernel="biweight")  #Calculo de la densidad por el kernel
fh2 = bkde(x2, kernel="biweight")  #Calculo de la densidad por el kernel
fh3 <- bkde(x[,6], kernel="biweight")

plot(fh3,type="l", lwd=2,xlab="FALSIFICADO / GENUINO",ylab="Estimados de la densidad para las diagonales", col="black", main="Billetes suizos", xlim=c(137,143), ylim=c(0,0.85))


plot(fh1,type="l", lwd=2,xlab="FALSIFICADO / GENUINO",ylab="Estimados de la densidad para las diagonales", col="black", main="Billetes suizos", xlim=c(137,143), ylim=c(0,0.85))
lines(fh2, lty="dotted", lwd=2, col="red3")

## Estimacion de las densidades de las variables X5 y X6
xx = read.table("bank2.dat")

d  = bkde2D(xx[, 5:6], bandwidth = 1.06*c(sd(xx[, 5]), sd(xx[, 6]))* 200^(-1/5))
contour(d$x1, d$x2, d$fhat, xlim = c(8.5, 12.5), ylim = c(137.5, 143), col = c("blue", "black", "yellow", "cyan", "red", "magenta", "green", "blue", "black"), lwd=3, cex.axis = 1)

## Visualizacion de las densidades X4, X5, X6
library(misc3d)
xx = read.table("bank2.dat")
d   = kde3d(xx[, 4], xx[, 5], xx[, 6], n = 15)
contour3d(d$d, level = c(max(d$d[10,10,])*.02, max(d$d[10,10,])*.5, max(d$d[10,10,])*1.3), fill = c(FALSE, FALSE, TRUE), col.mesh = c("green","red","blue") , engine = "standard", screen=list(z=210,x=-40,y=-295), scale=TRUE)


## Graficos de dispersion
## Variables 5,6
x = read.table('bank2.dat');

x56 = x[,5:6];
x1 = rep(1,100)
x2 = rep(2,100)
xx = cbind(x56,c(x1,x2))

plot(xx[,1],xx[,2], pch=c(xx[,3]), col=c(xx[,3]),frame=TRUE, axes=FALSE, ylab="", xlab="", ylim=c(137.5,142.5),xlim=c(7,13))
axis(side=1, at=seq(7,13,1), labels=seq(7,13,1))
axis(side=2, at=seq(138,142,1), labels=seq(138,142,1))
title("Billetes Suizos")

## Variables 456
x = read.table("bank2.dat")
x456 = x[,4:6]
x1 = rep(1,100)
x2 = rep(2,100)
xx = c(x1,x2)

require(lattice)

cloud(x456[,3]~x456[,2]*x456[,1],pch=c(xx), col=c(xx), ticktype="detailed",
	main=expression(paste("Billetes Suizos")),
	screen=list(z=-90,x=-90, y=45),
	scales=list(arrows=FALSE,col="black",distance=1,tick.number=c(4,4,5),cex=.7,
		z=list(labels=round(seq(138,142,length=6))),
		x=list(labels=round(seq(7,14,length=6))),
		y=list(labels=round(seq(7,12,length=6)))
		),

	xlab=list(expression(paste("Marco inferior interno  (X4)")),rot=-10,cex=1.2),
	ylab=list("Marco superior externo  (X5)",rot=10,cex=1.2),
	zlab=list("Diagonal (X6)", rot=90,cex=1.1))

## Graficas tipo draft
data=read.table("bank2.dat")
x = data

i=2
op = par(mfrow=c(4, 4), cex=.2)
while(i<6) {
        i = i+1
        j = 2
        while(j<6) {
                j = j+1

                if(i==j){
                        plot(i, type="n", axes=FALSE, xlab="", ylab="", main=i, cex.main=5)}

                if(i<j){
                        xx = cbind(x[,i],x[,j],c(rep(0,100),rep(1,100)))
                        zz = bkde2D(xx[,-3], 0.4)
                        contour(zz$x1, zz$x2, zz$fhat, nlevels=12, col=rainbow(20), drawlabels=FALSE, xlab="X", ylab="Y")}

                if(i>j){
                        yy = cbind(x[,i],x[,j],c(rep(0,100),rep(1,100)))
                        plot(yy[,-3], pch=as.numeric(yy[,3]), xlab="X", ylab="Y", cex=3, col="blue")}
        }}
par(op)

## Verificacion de las caras de Chernov
library(aplpack)
x = read.table("bank2.dat")
xx = x[91:110,]

ncolors=15

faces(xx, nrow = 4,face.type=1,scale=TRUE, col.nose = rainbow(ncolors), col.eyes = rainbow(ncolors,
         start = 0.6, end = 0.85), col.hair = terrain.colors(ncolors),
     col.face = heat.colors(ncolors), col.lips = rainbow(ncolors,
         start = 0, end = 1), col.ears = rainbow(ncolors, start = 0,
                                                 end = 0.8), plot.faces = TRUE)

x = read.table("bank2.dat")

x1 = x[1:50,]
ncolors=15

faces(x1,face.type=1,scale=TRUE, col.nose = rainbow(ncolors), col.eyes = rainbow(ncolors,
         start = 0.6, end = 0.85), col.hair = terrain.colors(ncolors),
     col.face = heat.colors(ncolors), col.lips = rainbow(ncolors,
         start = 0, end = 1), col.ears = rainbow(ncolors, start = 0,
         end = 0.8), plot.faces = TRUE,nrow.plot = 5, ncol.plot = 10,main="Observaciones 1 a 50")


dev.new()
x2 = x[51:100,]
faces(x2,face.type=1,scale=TRUE, col.nose = rainbow(ncolors), col.eyes = rainbow(ncolors,
         start = 0.6, end = 0.85), col.hair = terrain.colors(ncolors),
     col.face = heat.colors(ncolors), col.lips = rainbow(ncolors,
         start = 0, end = 1), col.ears = rainbow(ncolors, start = 0,
         end = 0.8), plot.faces = TRUE,nrow.plot = 5, ncol.plot = 10, main="Observaciones 51 a 100")

dev.new()
x3 = x[101:150,]
 faces(x3,face.type=1,scale=TRUE, col.nose = rainbow(ncolors), col.eyes = rainbow(ncolors,
         start = 0.6, end = 0.85), col.hair = terrain.colors(ncolors),
     col.face = heat.colors(ncolors), col.lips = rainbow(ncolors,
         start = 0, end = 1), col.ears = rainbow(ncolors, start = 0,
         end = 0.8), plot.faces = TRUE,nrow.plot = 5, ncol.plot = 10,main="Observaciones 101 a 150")

dev.new()
 x4 = x[151:200,]
faces(x4,face.type=1,scale=TRUE, col.nose = rainbow(ncolors), col.eyes = rainbow(ncolors,
         start = 0.6, end = 0.85), col.hair = terrain.colors(ncolors),
     col.face = heat.colors(ncolors), col.lips = rainbow(ncolors,
         start = 0, end = 1), col.ears = rainbow(ncolors, start = 0,
                                                 end = 0.8), plot.faces = TRUE,nrow.plot = 5, ncol.plot = 10, main="Observaciones 151 a 200")

## Curvas de Andrews
library(tourr)
data = read.table("bank2.dat")

x = data[96:105, ]
y = NULL
i = 1

while(i <= 6) {
        z = (x[, i] - min(x[, i])) / (max(x[, i]) - min(x[, i])) # Escalamiento a cero
        y = cbind(y, z)
        i = i + 1
}

Type = c(rep(1, 5), rep(2, 5))
f = as.integer(Type)
grid = seq(0, 2 * pi, length = 1000)

plot(grid, andrews(y[1, ])(grid), type = "l", lwd = 1.5, main = "Curvas de Andrews (Informacion de billetes)",
     axes = FALSE, frame = TRUE, ylim = c(-0.3, 0.5), ylab = "", xlab = "")
for (i in 2:5) {
        lines(grid, andrews(y[i, ])(grid), col = "black", lwd = 1.5)
}
for (i in 6:10) {
        lines(grid, andrews(y[i, ])(grid), col = "red3", lwd = 1.5, lty = "dotted")
}
axis(side = 2, at = seq(-.5, .5, .25), labels = seq(-.5, .5, .25))
axis(side = 1, at = seq(0, 7, 1), labels = seq(0, 7, 1))

## Cambiando el orden de las curvas de Andrews
data = read.table("bank2.dat")

    x = data[96:105,]
    y = NULL
    i = 1

    while(i <= 6) {
            z = (x[,i]-min(x[,i]))/(max(x[,i])-min(x[,i]))
            y = cbind(y,z)
            i = i+1
    }

y = y[,ncol(y):1]

Type = c(rep(1,5), rep(2,5))
f = as.integer(Type)
grid <- seq(0, 2*pi, length = 1000)

plot(grid, andrews(y[1,])(grid), type = "l", lwd=1.5,main="Curvas de Andrews (Informacion de billetes)", axes=FALSE,frame=TRUE, ylim=c(-0.3,0.5), ylab="",xlab="")
for (i in 2:5){
lines(grid, andrews(y[i,])(grid), col="black",lwd=1.5)
}
for (i in 6:10){
	lines(grid, andrews(y[i,])(grid), col="red3",lwd=1.5,lty="dotted")
	}
axis(side=2, at=seq(-.5,.5,.25), labels=seq(-.5,.5,.25))
axis(side=1, at=seq(0,7,1), labels=seq(0,7,1))

## Graficas de coordenadas paralelas
library(MASS)

data = read.table("bank2.dat")
x = data[96:105,]
     ir = rbind(x[,,1], x[,,2], x[,,3], x[,,4], x[,,4], x[,,6])
parcoord(log(ir)[, c(1, 2, 3, 4, 5, 6)], lwd =2,
              col = c(1,1,1,1,1,2,2,2,2,2), lty=c(rep(1,5),rep(4,5)),
              main="Grafica de coordenadas paralelas (Datos de billetes)", frame=TRUE, ablines=FALSE)
axis(side=2, at=seq(0,1,0.2), labels=seq(0,1,0.2))

## Graficas con ggplot
library(GGally)
data = read.table("bank2.dat")
data <- cbind(data, GRUPO=c(rep("GENUINO",100),rep("FALSIFICADO",100)))
ggpairs(data=data, columns=1:6, ggplot2::aes(colour=GRUPO),title="BILLETES SUIZOS")

