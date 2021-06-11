import numpy as np
import matplotlib.pyplot as plt


def circle(r, c, n):
    epsilon = np.random.random(n) / 30
    x = np.linspace(start=c[0] - r, stop=c[0] + r, num=1000)
    x = np.random.choice(x, n)
    y_1 = np.sqrt(r ** 2 - ((x - c[0]) ** 2)) + c[1]
    y_2 = -np.sqrt(r ** 2 - ((x - c[0]) ** 2)) + c[1]

    x = np.concatenate([x + epsilon, x + epsilon])
    y = np.concatenate([y_1 + epsilon, y_2 + epsilon])
    return np.array([x, y])


def polynomial_kenerl(X, c, d) -> np.array:
    """
        Compute the polynomial kernel between two matrices X and Y::
            K(x, y) = (<x, y> + c)^p
        for each pair of rows x in X and y in Y.

        Args:
            X - (n, d) NumPy array (n datapoints each with d features)
            c - a coefficient to trade off high-order and low-order terms (scalar)
            d - the degree of the polynomial kernel

        Returns:
            kernel_matrix - (n, m) Numpy array containing the kernel matrix
    """
    return np.dot(X, X.T + c) ** d


def guassian_kernel(X, alpha) -> np.array:
    """
        Compute the Gaussian RBF kernel between two matrices X and Y::
            K(x, y) = exp(-gamma ||x-y||^2)
        for each pair of rows x in X and y in Y.

        Args:
            X - (n, d) NumPy array (n datapoints each with d features)
            alpha - the alpha parameter of gaussian function (scalar)

        Returns:
            kernel_matrix - (n, n) Numpy array containing the kernel matrix
    """
    norms_1 = (X ** 2).sum(axis=1)
    norms_2 = (X ** 2).sum(axis=1)
    dists = np.abs(norms_1.reshape(-1, 1) + norms_2 - 2 * np.dot(X, X.T))
    # dists = np.dot(X-X, X-X.T)
    return np.exp(-dists / (2 * (alpha ** 2)))


def kernel_kmeans(A, K_matrix, k, t, t_max, pi_0):
    n = A.shape[0]
    p = A.shape[1]
    dist = np.ones([k, n])

    for i in range(k):  # calculate the mean of cluster
        elms = pi_0 == i
        first_term = np.diag(K_matrix)
        denom = len(elms)
        second_term = 2 * np.dot(K_matrix, elms) / denom
        third_term = np.sum(K_matrix[elms][:, elms]) / denom ** 2
        dist[i] = first_term - second_term + third_term
    pi_t = np.argmin(dist, axis=0)
    t += 1
    if np.sum(pi_t != pi_0) > 0 | t < t_max:
        return kernel_kmeans(A, K_matrix, k, t, t_max, pi_t)
    else:
        print("Converge in iterations", t)
        return pi_t
