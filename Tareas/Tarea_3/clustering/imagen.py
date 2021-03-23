import glob
from sklearn.decomposition import PCA
import PIL.ImageStat as stat
from PIL import Image
from kernels import *

path_fruits = glob.glob("../data_fruits_tarea/*.jpg")

mean_fruits = np.zeros([1300, 3])
for i in range(len(path_fruits)):
    im = Image.open(path_fruits[i])
    s = stat.Stat(im)
    mean_fruits[i] = s.mean


# PCA and Kernel PCA kernel Gaussino
pca = PCA(n_components=2)
pca_mean_fruits = pca.fit_transform(mean_fruits)
plt.scatter(pca_mean_fruits[:, 0], pca_mean_fruits[:, 1])
plt.title("Scatter plot of 1st and 2nd PCs", size=18)
plt.xlabel("PC 1",size=14)
plt.ylabel("PC 2",size=14)
plt.axis("equal")
plt.show()

for alpha in np.linspace(0.1, 0.2, 1):
    guass_mean_fruits = guassian_kernel(mean_fruits, alpha)
    pca_gauss = PCA(n_components=2)
    pca_gauss_mean_fruits = pca_gauss.fit_transform(guass_mean_fruits)
    plt.scatter(pca_gauss_mean_fruits[:, 0], pca_gauss_mean_fruits[:, 1])
    plt.title("Scatter plot of 1st and 2nd PCs", size=18)
    plt.xlabel("PC 1",size=14)
    plt.ylabel("PC 2",size=14)
    plt.axis("equal")
    plt.show()

from sklearn.cluster import KMeans
kmeans = KMeans(n_clusters=8)
y = kmeans.fit_predict(pca_mean_fruits)
plt.scatter(pca_mean_fruits[:,0],pca_mean_fruits[:,1], c=y)
plt.title("KMeans Clustering, PCA Plot",size=18)
plt.xlabel("PC 1",size=14)
plt.ylabel("PC 2",size=14)
plt.axis("equal")
plt.show()