
mi=c(13,13,13)
xi=c(6,6,6)
ni=c(74,72,51)

producto=NULL
for(t in 74:200){
for(j in 1:3){
producto[t]<-(1/(choose(t,ni[j])))*(choose(mi[j],xi[j])*choose(t-mi[j],ni[j]-xi[j]))
producto[t]<-producto[t]*producto[t]
}
}

plot(producto)

which(producto==max(producto,na.rm = TRUE))

##La verosimilitud se maximiza en 110




likelihood<-function(t,ni,xi,mi){
 
}

like<-likelihood(tvec,ni,xi,mi)

plot(likelihood)


prod()