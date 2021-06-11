import numpy as np

"""
Este conjunto de funciones sirve para realizar una regresion multivariada multiple con regularizacion. Ademas de que se
considera la estimacion de la matriz de covarianzas para estimar los parametros B:
                                                        Y = XB+E.
Referencias.
Estas funciones estan basadas de los siguientes articulos cientificos.
Adam J. Rothman, Elizaveta Levina, and Ji Zhu. Sparse multivariate regression with covariance estimation.Journalof 
Computational and Graphical Statistics, 19(4):947–962, 2010.   doi:10.1198/jcgs.2010.09188.   
URLhttps://doi.org/10.1198/jcgs.2010.09188. PMID: 24963268
Jerome Friedman, Trevor Hastie, and Robert Tibshirani. Sparse inverse covariance estimation with the graphical
lasso. Biostatistics, 9(3):432–441, July 2008. ISSN 1465-4644, 1468-4357. doi:10.1093/biostatistics/kxm045. URL
http://biostatistics.oxfordjournals.org/content/9/3/432.
"""


def mrce(X, Y, lambda_1, lambda_2, epsilon, max_iter=200):
    """
    Esta funcion el algoritmo de MRCE, estima los parametros B considerando la estimacion de Omega (la matriz de
    covarianzas.
    Arg:
    :param X: matriz de datos de tamano n x p.
    :param Y: matriz de variables respuesta de tamano n x q.
    :param lambda_1: parametro de regularizacion para la matriz covarianza
    :param lambda_2: parametro de regularizacion para la matriz de estimadores
    :param epsilon: tolerancia de convergencia
    :param max_iter: numero maximo de iteraciones.
    Returns:
    B_t_new: estimadores de la matriz B.
    """
    # initialize B and Gamma (matrix cov)
    B_t = np.zeros([X.shape[1], Y.shape[1]])
    Gamma_t = graphic_lasso(X, Y, B_t, lambda_1)

    # calculamos el estimador de rigde.
    Beta_ridge = np.abs(np.linalg.pinv(X.T @ X + lambda_2 * np.identity(X.shape[1])) @ (X.T @ Y))

    # calculamos la primera iteracion de B.
    B_t_new = coordinate_descent(X, Y, B_t, Gamma_t, lambda_2)

    # inizialimos el contador de iteraciones
    k = 0

    # algoritmo MCRE
    while (np.linalg.norm(B_t_new - B_t) > (epsilon * np.sum(Beta_ridge))) & (k < max_iter):
        k += 1
        B_t = np.copy(B_t_new)

        # estimamos las matrices B y Gamma.
        B_t_new = coordinate_descent(X, Y, B_t, Gamma_t, lambda_2)
        Gamma_t = graphic_lasso(X, Y, B_t_new, lambda_1)
    return B_t_new


def submatriz_i(X, i):
    """
    Esta funcion realiza crea la submatriz dado por la eliminacion de la fila y columna i de la matriz X. Tambien
    retorna el elemento X[i,i] y el vector de la fila i eliminada.
    Arg:
    :param X: matriz de datos de tamano n x p.
    :param i: columna y fila a eliminar.
    :return
    Returns:
    :W, w, w2: submatriz i, vector fila i elimanada, X[i,i]
    """
    n = X.shape[1]
    W = X[np.arange(n) != i, :][:, np.arange(n) != i]
    w = X[i, np.arange(n) != i]
    w2 = X[i, i]
    return W, w, w2


def soft_threshold_operator(x, t, lim_sup=0):
    """
    Funcion soft_threshold sign(x)*max([(|x|-t),lim_sup]
    """
    return np.sign(x) * np.max([lim_sup, np.abs(x) - t])


def coordinate_descent(X, Y, B_t, Gamma_t, lambda_2, epsilon=1e-5):
    """
    Estimamos los parametros B considerando un punto fijo para la matriz de covarianza B, optimizamos la funcion
    objetivo (3-4) del reporte.
    Args:
    :param X: matriz de datos de tamaño n x p.
    :param Y: matriz de variables respuesta de tamaño n x q.
    :param B_t: estimador de betas en el paso m-1.
    :param Gamma_t: estimador de gamma en el paso m-1.
    :param lambda_2: parametro de regularizacion para la matriz de estimadores.
    :param epsilon: tolerancia de convergenia.
    Return:
    B_t_new: matriz de estimadores para el paso m.
    """
    # datos del problema
    n, p = X.shape
    Beta_ridge = np.abs(np.linalg.pinv(X.T @ X + lambda_2 * np.identity(X.shape[1])) @ (X.T @ Y))

    # matrices auxiliares
    S = X.T @ X
    H = X.T @ Y @ Gamma_t

    # copiamos los estimadores de m-1 a la matriz B_t a estimar en el paso m.
    B_t_new = np.copy(B_t)
    B_t = B_t_new

    # calculamos los estimadores para cada B[r_c].
    for r in range(B_t.shape[0]):
        for c in range(B_t.shape[1]):
            mu = 0
            for j in range(B_t.shape[0]):
                for k in range(B_t.shape[1]):
                    # calculamos el factor de expansion
                    mu += B_t[j, k] * S[r, j] * Gamma_t[k, c]
            # estimamos B[r,c].
            B_t_new[r, c] = soft_threshold_operator(B_t[r, c] + (H[r, c] - mu) / (S[r, r] * Gamma_t[c, c]),
                                                    n * lambda_2 / (S[r, r] * Gamma_t[c, c]), 0)

    # calculamos los estimadores para cada B[r_c] y paramos hasta que la diferencias son pequeñas.
    while np.linalg.norm(B_t_new - B_t) > (epsilon * np.sum(Beta_ridge)):
        B_t = B_t_new
        for r in range(B_t.shape[0]):
            for c in range(B_t.shape[1]):
                mu = 0
                for j in range(B_t.shape[0]):
                    for k in range(B_t.shape[1]):
                        # calculamos el factor de expansion
                        mu += B_t[j, k] * S[r, j] * Gamma_t[k, c]
                # estimamos B[r,c].
                B_t_new[r, c] = soft_threshold_operator(B_t[r, c] + (H[r, c] - mu) / (S[r, r] * Gamma_t[c, c]),
                                                        n * lambda_2 / (S[r, r] * Gamma_t[c, c]), 0)
    return B_t_new


def graphic_lasso(X, Y, B, lambda_1, tol_sigma=1e-7, tol_beta=1e-7, max_iter=100):
    """
    Esta funcion se encarga de estimar la matriz de covarianza (Omega) fijando la matriz B. Es decir, utiliza el
    algoritmo de LASSO grafico.
    Args:
    :param X: matriz de datos de tamano n x p.
    :param Y: matriz de variables respuesta de tamano n x q.
    :param B: estimador de betas en el paso m-1.
    :param lambda_1: parametro de regularizacion para la matriz covarianza
    :param tol_sigma: tolerancia de convergencia para sigma.
    :param tol_beta: tolerancia de convergencia para los betas.
    :param max_iter: numero maximo de iteraciones
    Return:
    inversa(S_inversa): matriz de covarianzas estimada.
    """
    # datos del problema.
    n, p = (Y - X @ B).shape

    # matriz de covarianzas de los errores.
    S = (Y - X @ B).T @ (Y - X @ B) / n

    # inversa de la matriz de covarianzas de los erroes.
    Sigma = np.linalg.pinv(S)
    Sigma_pre = np.zeros(Sigma.shape)
    Sigma_inv = np.copy(Sigma)

    # si no existe parametro de regularizacion retorna la matiz de covarianzas de los errores
    if lambda_1 == 0:
        return S
    else:
        # inicializamos un contador
        count = 0

        # algoritmo de lasso grafico.
        while np.linalg.norm(Sigma - Sigma_pre) >= tol_sigma:
            Sigma_pre = np.copy(Sigma)
            for i in range(p):

                # recortamos las matrices a estimar.
                W, w, w2 = submatriz_i(Sigma_inv, i)
                _, s, s_ii = submatriz_i(S, i)

                # calculamos beta de nuestros datos.
                beta = np.linalg.inv(W) @ w

                # inicializamos la matriz a estimar.
                beta_prev = np.zeros((p - 1, 1))

                # estimamos beta con gradiente descendie coordinado.
                while np.linalg.norm(beta - beta_prev) >= tol_beta:
                    beta_prev = np.copy(beta)
                    for j in range(p - 1):
                        # eliminamos la fila j de nuestra matriz W y beta
                        W_k = W[j, np.arange(p - 1) != j][:, np.newaxis]
                        beta_k = beta[np.arange(p - 1) != j]

                        # estimamos beta[j] considerando los demas betas
                        beta[j] = soft_threshold_operator(s[j] - W_k.T @ beta_k, lambda_1) / W[j, j]

                # actualizamos beta y calculamos la inversa de la matriz de covarianzas de los errores.
                w = W @ beta
                w2 = s_ii + lambda_1
                Sigma_inv[i, np.arange(p) != i] = w.T
                Sigma_inv[np.arange(p) != i, i] = w.T
                Sigma_inv[i, i] = w2

            # criterio de convergencia considerando el numero de iteraciones.
            count += 1
            if count >= max_iter:
                return np.linalg.pinv(Sigma_inv)
        return np.linalg.pinv(Sigma_inv)


"""
Este conjunto de funciones sirve para realizar una regresion multivariada multiple con regularizacion. No se toma en 
cuenta la matriz de covarianzas.
                                                        Y = XB+E.
Referencias:
Se construyeron basadas en los siguientes articulos cientificos.
Jie Peng, Ji Zhu, Anna Bergamaschi, Wonshik Han, Dong-Young Noh, Jonathan R. Pollack, and Pei Wang. Regularized
multivariate regression for identifying master predictors with application to integrative genomics study of breast
cancer. The Annals of Applied Statistics, 4(1):53 – 77, 2010. doi:10.1214/09-AOAS271. URL https://doi.org/
10.1214/09-AOAS271.
Adam J. Rothman, Peter J. Bickel, Elizaveta Levina, and Ji Zhu. Sparse permutation invariant covariance estimation.
Electronic Journal of Statistics, 2(none), Jan 2008. ISSN 1935-7524. doi:10.1214/08-ejs176. URL http://dx.doi.
org/10.1214/08-EJS176.
"""


def remMap(matrizX, matrizY, l_1, l_2, tmax):
    """
    Esta funcion implementa el algoritmo remap considerando lambda2 diferente de cero.
    Args:
    :param matrizX: matriz de datos de tamano n x p.
    :param matrizY: matriz de variables respuesta de tamano n x q.
    :param l_1: parametro de regularizacion lambda_1
    :param l_2: parametro de regularizacion lambda_2
    :param tmax: numero maximo de iteraciones
    Return:
    beta_0_pq: estimadores de la matriz B.
    """

    # inicializamos los parametros
    X = matrizX
    Y = matrizY

    # datos del problema
    n, p = X.shape
    n, q = Y.shape
    beta_0_pq = np.zeros((p, q))

    # para cada iteracion especificada
    for t in range(tmax):
        # para cada parametro
        for j in range(p):
            for k in range(q):
                ultimobeta = beta_0_pq
                aux2 = ultimobeta[:, k]
                aux2[j] = 0
                actualizar = np.dot(X[:, j], (Y[:, k] - X @ aux2)) / np.dot(X[:, j], X[:, j])
                beta_0_pq[j, k] = (np.sign(actualizar)) * max(abs(actualizar) - l_1, 0)
                # Esta es la diferencia cuando lambda2 diferente de 0
                # una nueva actualización de los parametros
                # ya calculados pero que se puede hacer en la
                # misma iteración.
                if np.sqrt(np.sum(beta_0_pq[j, :] ** 2)) < 0.001:
                    beta_0_pq[j, k] = 0
                else:
                    beta_lasso_p0 = np.sqrt((np.sum(beta_0_pq[j, :] ** 2)))
                    actualizar2 = (1 - (l_2 / ((beta_lasso_p0))))
                    beta_0_pq[j, k] = max(actualizar2, 0) * beta_0_pq[j, k]
    return beta_0_pq


def remMap_l1(matrizX, matrizY, l_1, tmax):
    """
    Esta funcion implementa el algoritmo remap considerando lambda2 igual a cero.
    Args:
    :param matrizX: matriz de datos de tamano n x p.
    :param matrizY: matriz de variables respuesta de tamano n x q.
    :param l_1: parametro de regularizacion lambda_1
    :param tmax: numero maximo de iteraciones
    Return:
    beta_0_pq: estimadores de la matriz B.
    """
    # inicializamos los parametros
    X = matrizX
    Y = matrizY

    # datos del problema
    n, p = X.shape
    n, q = Y.shape
    beta_0_pq = np.zeros((p, q))

    # para cada iteracion
    for t in range(tmax):
        # recorrer cada beta p,q
        for j in range(p):
            for k in range(q):
                ultimobeta = beta_0_pq
                aux2 = ultimobeta[:, k]
                aux2[j] = 0
                # Aqui calculamos el residual
                # utilizado en el algoritmo descenso coordinado
                actualizar = np.dot(X[:, j], (Y[:, k] - X @ aux2)) / np.dot(X[:, j], X[:, j])
                beta_0_pq[j, k] = (np.sign(actualizar)) * max(abs(actualizar) - l_1, 0)
    # Si quisieramos calcular tambien el intercepto se calcula como la media de y
    return beta_0_pq


def graficar_coeficientes_y_rmse(model, tipo):
    """
    Esta funcion grafica los valares de las estimacioens de los parametros de un modelo de regresión lineal, con 
    regularizacion. Ademas calcula el error cuadrativo medio del modelo.
    
    Args.
    :param model: modelo a probar. 
    :param tipo: nombre del modelo probado
    
    Return.
    rmse: error cuadratico medio del modelo introducido. 
    """
    # creamos un dataframe con los coeficientes
    df_coeficientes = pd.DataFrame({'predictor': X_train.columns, 'coef': model.coef_})
    
    # graficamos los coeficientes
    fig, ax = plt.subplots(figsize=(13, 4.5))
    ax.stem(df_coeficientes.predictor, df_coeficientes.coef, markerfmt=' ')
    plt.xticks(rotation=90, ha='right', size=10)
    ax.set_xlabel('variable')
    ax.set_ylabel('coeficientes')
    ax.set_title('Coeficientes del modelo de {}'.format(tipo))
    
    # predecimos utilizando el conjunto de prueba y calculamos el error cuadratico medio
    predicciones = model.predict(X=X_test)
    rmse = mean_squared_error(y_true=y_test, y_pred=predicciones, squared=False)

    print(f"El error (rmse) de test es: {rmse}")
    return rmse


def graficar_rmse_evolucion(modelo, tipo):
    # modelo.mse_path_ almacena el mse de cv para cada valor de alpha. Tiene
    if tipo=="LASSO":
        mse_cv = modelo.mse_path_.mean(axis=1)
        mse_sd = modelo.mse_path_.std(axis=1)
        alphas = modelo.alphas_
    else:
        mse_cv = modelo.cv_values_.reshape((-1, 200)).mean(axis=0)
        mse_sd = modelo.cv_values_.reshape((-1, 200)).std(axis=0)
        alphas = modelo.alphas
        
    # se aplica la raíz cuadrada para pasar de mse a rmse
    rmse_cv = np.sqrt(mse_cv)
    rmse_sd = np.sqrt(mse_sd)
    # se identifica el óptimo
    min_rmse     = np.min(rmse_cv)
    sd_min_rmse  = rmse_sd[np.argmin(rmse_cv)]
    optimo       = alphas[np.argmin(rmse_cv)]

    # gráfico de los errores de cv
    fig, ax = plt.subplots(figsize=(12, 4.84))
    ax.plot(alphas, rmse_cv)
    ax.fill_between(alphas, rmse_cv + rmse_sd, rmse_cv - rmse_sd, alpha=0.2)
    ax.axvline(x=optimo, c="gray", linestyle='--', label='óptimo')
    ax.set_xscale('log')
    ax.set_title('Evolución del error CV en función de la regularización {}'.format(tipo))
    ax.set_xlabel('alpha')
    ax.set_ylabel('RMSE')
    plt.legend()