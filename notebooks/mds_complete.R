library("stats")

vuelos <- read.csv("../../../../Proyecto_Estadistica/data/processed/ciudades_complete_distance.csv")
nombres <- vuelos$ciudad


vuelos_dist <- vuelos[,1:40]

nombres<- names(vuelos_dist)
k <- 1
for (i in nombres){
  nombres[k] <- i[1:8]
  k = k+1
}

resul_mds_clas<-cmdscale(vuelos_dist, k = 2, eig = TRUE, add = FALSE, x.ret = FALSE)


config_nations<-resul_mds_clas$points

#se a?aden los nombres de las naciones a la configuracion solucion X
dimnames(config_nations)[[1]]<-nombres

#se grafica la configuracion solucion obtenida mediante mds clasico

plot(config_nations[,1],config_nations[,2],main="configuracion solucion mediante mds clasico",
     xlab="dim 1",ylab="dim 2",type="n",lwd=2)
text(config_nations[,1],config_nations[,2],
     labels=abbreviate(row.names(config_nations),minlength=15),cex=0.8,lwd=2)


  plot(config_nations[,1],config_nations[,2],main="configuracion solucion mediante mds clasico",ylim=range(config_nations[,1]),
     xlab="dim 1",ylab="dim 2",type="n",lwd=2)
text(config_nations[,1],config_nations[,2],
     labels=abbreviate(row.names(config_nations),minlength=15),cex=0.6,lwd=2)


resul_mds_clas$GOF

