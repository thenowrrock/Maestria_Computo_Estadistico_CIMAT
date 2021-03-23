from imagen import *
from EM import *


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # Algoritmo EM

    # Kernel K-means
    np.random.seed(199708)
    n_samples = 1500
    noisy_circles, y = datasets.make_circles(n_samples=n_samples, factor=.5,
                                             noise=.05)
    noisy_moons, y = datasets.make_moons(n_samples=n_samples, noise=.05)
    blobs, y = datasets.make_blobs(n_samples=n_samples, random_state=8)
    no_structure, y = np.random.rand(n_samples, 2), None

    # no structure
    k = 2
    K_matrix = polynomial_kenerl(no_structure, 10 / 3, 2)
    pi_ajust = kernel_kmeans(no_structure, K_matrix, k, 0, 100, 0)
    plt.scatter(no_structure.T[0], no_structure.T[1], c=pi_ajust)
    plt.title("Conglomerado Final")
    plt.show()

    # circle
    k = 2
    K_matrix = polynomial_kenerl(noisy_circles, 0.5, 2)
    pi_ajust = kernel_kmeans(noisy_circles, K_matrix, k, 0, 100, 0)
    plt.scatter(noisy_circles.T[0], noisy_circles.T[1], c=pi_ajust)
    plt.title("Conglomerado Final" + str(0.5))
    plt.show()

    # blobs
    k = 3
    K_matrix = polynomial_kenerl(blobs, 1, 3)
    pi_ajust = kernel_kmeans(blobs, K_matrix, k, 0, 100, 0)
    plt.scatter(blobs.T[0], blobs.T[1], c=pi_ajust)
    plt.title("Conglomerado Final")
    plt.show()

    k = 2
    np.random.seed(19970808)
    K_matrix = polynomial_kenerl(noisy_moons, 0.5, 3)
    # K_matrix = guassian_kernel(noisy_moons, alpha)
    pi_ajust = kernel_kmeans(noisy_moons, K_matrix, k, 0, 100, 0)
    plt.scatter(noisy_moons.T[0], noisy_moons.T[1], c=pi_ajust)
    plt.title("Conglomerado Final" + str(0.5))
    plt.show()