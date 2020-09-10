---
fontsize: 11pt
geometry: "left=2cm,right=2cm,top=2cm,bottom=2cm"
documentclass: article
output:
    pdf_document:
        includes:
            in_header: mystyles.sty
---
\begin{table}[ht]
\centering
\begin{tabular}{c}
\textbf{Maestría en Computo Estadístico}\\
\textbf{Inferencia Estadística} \\
\textbf{Tarea 2}\\
\today \\
\emph{Enrique Santibáñez Cortés}\\
Repositorio de Git: \href{https://github.com/Enriquesec/Inferencia_Estad-stica/tree/master/Tareas/Tarea_2}{Tarea 2, IE}.
\end{tabular}
\end{table}

4. El siguiente conjuntos de datos contiene mediciones del diámetro de un agave, medido en decímetros, en distintas localizaciones no cercanas.

a) Escriba una función en R que calcule la función de distribución empírica para un conjunto de datos dado D. La función debe tomar como parámetros al valor $x$ donde se evalúa y al conjunto de datos $D$. Utilizando esta función grafique la función de distribución empírica asociada al conjunto de datos de agave. Ponga atención a los puntos de discontinuidad. ¿Qué observa? Nota: Escriba la función mediante el algoritmo descrito en las notas de la clase; para este ejercicio no vale usar la funciones implementadas en R que hacen lo
pedido.

b) Usando la desigualdad de Dvoretzky-Kiefer-Wolfowitz, escriba una función en R que calcule y grafique una región de confianza para la función de distribución empírica. La función debe tomar como parámetros al conjunto de datos que se usan para contruir la función de distribución empírica.



d ) Escriba una función en R que determine el gráfico de probabilidad normal. La función debe tomar como parámetro al conjunto de datos. ¿Qué observa? Nota: La misma del inciso a).
e) ¿Los datos anteriores se distribuyen normalmente? Argumente.

5. En este ejercicio repasará la estimación de densidades.



8. En este ejercicio se comprobará que tan buena es la aproximación dada por las reglas empíricas para algunas de las distribuciones estudiadas en la clase. Considerese las distribuciones $Unif(a = −3, b = 3)$, $Normal(0, 1)$, $Exponencial(2)$, $Gamma(\alpha= 2, \beta = 1)$, $Gamma(\alpha=3, \beta= 1)$, $Beta(\alpha= 2, \beta= 2)$, $Weibull(\alpha= 4, \beta= 1)$ y Lognormal$(\mu = 3, \sigma = 2)$.
a) Para cada una de las distribuciones anteriores, haga una tabla que muestre las probabilidades contenidas en los intervalos $(\mu − k\sigma, \mu + k\sigma)$, para $k = 1, 2, 3$. Utilice las fórmulas de las medias y varianzas contenidas en las notas para determinar $\mu$ y $\sigma$ en cada caso. Puede usar R para determinar las probabilidades pedidas.




