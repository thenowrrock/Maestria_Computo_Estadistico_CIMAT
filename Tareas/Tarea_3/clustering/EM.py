from scipy.stats import multivariate_normal
import numpy as np


def classification(X, mu, sigma, weight):
    k = len(weight)
    n = X.shape[0]
    X_pdf = np.zeros([k, n])
    for i in range(k):
        mu_k = mu[i]
        sigma_k = sigma[i]
        X_pdf[i] = weight[i] * multivariate_normal(mu_k, sigma_k).pdf(X)

    gamma = X_pdf / X_pdf.sum(axis=0)
    return np.argmax(gamma, axis=0)


def step_E(X, mu, sigma, weight):
    k = len(weight)
    n = X.shape[0]
    X_pdf = np.zeros([k, n])
    for i in range(k):
        mu_k = mu[i]
        sigma_k = sigma[i]
        X_pdf[i] = weight[i] * multivariate_normal(mu_k, sigma_k).pdf(X)
    return X_pdf


def step_M(X, X_pdf, mu, sigma, weight, t):
    k = len(weight)
    n = X.shape[0]
    verosimilitud = 0
    gamma = X_pdf / X_pdf.sum(axis=0)
    for i in range(k):
        sum_gamma_k = np.sum(gamma[i])
        weight[i] = sum_gamma_k / n

        mu[i] = np.sum(np.multiply(X.T, gamma[i]).T, axis=0) / sum_gamma_k

        sigma[i] = np.dot((X - mu[i]).T, np.multiply((X - mu[i]).T, gamma[i]).T) / sum_gamma_k
        verosimilitud += np.sum(np.log(weight[i] * np.sum(X_pdf[i])))
    return mu, sigma, weight, verosimilitud


def EM_algoritmo(X, mu, sigma, weight, t, t_max, epsilon, k, verosimilitud):
    n = X.shape[1]
    n_samples = X.shape[0]
    if t == 0:
        weight = np.repeat(1 / k, k)
        index = np.random.choice(np.linspace(0, n_samples, n_samples + 1), k, False)
        index = [int(i) for i in index]
        mu = X[index]
        sigma = np.full([k, n, n], np.cov(X, rowvar=False))

    X_pdf = step_E(X, mu, sigma, weight)
    mu, sigma, weight, verosimilitud_new = step_M(X, X_pdf, mu, sigma, weight, t)
    if (np.abs(verosimilitud_new - verosimilitud) > epsilon) & (t < t_max):
        t += 1
        return EM_algoritmo(X, mu, sigma, weight, t, t_max, epsilon, k, verosimilitud_new)
    else:
        print("Converge in iterations", t)
        return mu, sigma, weight, verosimilitud
