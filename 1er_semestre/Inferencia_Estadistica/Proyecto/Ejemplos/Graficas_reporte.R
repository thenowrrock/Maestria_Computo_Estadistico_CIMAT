library(tidyverse)
library(ggdark)

m <- 20
i <- 1:m
alpha <- 0.05
datos <- data.frame(x=rep(i,4),
                    Metodologia = c(rep("Bonferonni", m),
                                    rep("BH", m),
                                    rep("Sidak", m),
                                    rep("Holm", m)),
                    valor = c(rep(alpha/m,m), 
                              i*alpha/m,
                              rep(1-(1-alpha)^{1/m},m),
                              alpha/(m-i+1)))


ggplot(data = datos, aes(x=x, y =valor, group=Metodologia))+
  geom_line(aes(linetype=Metodologia, color=Metodologia), size=1)+
  labs(title="Comparación de Umbrales", y= "Valor del Umbral",
       x="Hipótesis Ordenadas por p-valor", color = "Metodología")+
  scale_y_continuous(label = scales::dollar) +
  dark_theme_dark(base_family = "Fira Sans Condensed Light", base_size = 14)+
  theme(plot.title = element_text(family = "Fira Sans Condensed"),
        plot.background = element_rect(fill = "grey10"),
        panel.background = element_blank(),
        panel.grid.major = element_line(color = "grey30", size = 0.2),
        panel.grid.minor = element_line(color = "grey30", size = 0.2),
        legend.background = element_blank(),
        axis.ticks = element_blank(),
        legend.key = element_blank(),
        legend.position = c(0.2, 0.87))+
  scale_linetype(guide = FALSE)
  
  



