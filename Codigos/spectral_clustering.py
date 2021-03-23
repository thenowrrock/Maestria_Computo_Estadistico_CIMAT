#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  5 10:48:32 2020

@author: victor
"""

import pandas as pd
import numpy as np
from scipy.spatial.distance import euclidean, pdist, squareform
from scipy import linalg
from sklearn import cluster, datasets, preprocessing
from sklearn.neighbors import NearestNeighbors
from numpy import pi

def get_dataset(dataset = 'blobs', ndata = 30):
    if dataset == 'blobs':
        X, y = datasets.make_blobs(n_samples=ndata, centers = 3, n_features=2, cluster_std=.5, random_state=0)
        custom_palette = ["red", "green", "blue"]
        k = 3
    
    elif dataset == 'dona':
        X, y = datasets.make_circles(n_samples=ndata, factor=0.4, noise=0.05, random_state=0)
        custom_palette = ["red", "blue"]
        k = 2

    elif dataset == 'moons':
        X, y = datasets.make_moons(n_samples=n_data, noise=0.05)
        custom_palette = ["red", "blue"]
        k = 2
    elif dataset == 'spirals':
        np.random.seed(42)
        theta = np.sqrt(np.random.rand(ndata))*3*pi
        r_a = 4*theta + pi
        data_a = np.array([np.cos(theta)*r_a, np.sin(theta)*r_a]).T
        x_a = data_a + np.random.randn(ndata,2)        
        r_b = -4*theta - pi
        data_b = np.array([np.cos(theta)*r_b, np.sin(theta)*r_b]).T
        x_b = data_b + np.random.randn(ndata,2)
               
        X = np.append(x_a, x_b, axis=0)
        y = np.append(np.zeros((ndata,1), dtype=np.int),np.ones((ndata,1), dtype=np.int))
        custom_palette = ["red", "blue"]
        k = 2
        
    return X, y, custom_palette, k


def similarity_func(u, v, sigma=1):
    return np.exp(-(euclidean(u,v)*euclidean(u,v))/(2*sigma*sigma))

def graph(X,k=3, mutual=False):
    nbrs = NearestNeighbors(n_neighbors=k, algorithm='ball_tree').fit(X)
    indices = nbrs.kneighbors(X,return_distance=False)
    #indices

    if mutual:
        indx = indices[:,1:]
        knn_graph = np.full([X.shape[0],X.shape[0]],0)
        for i in range(indx.shape[0]):
            indi = indx[i,]
            for j in indi:
                mutual = sum(indx[j,]==i)
                if mutual>0:
                    knn_graph[i,j] = 1

    else:
        temp = nbrs.kneighbors_graph(X).toarray()
        knn_graph = temp+temp.T
        knn_graph[knn_graph>1] = 1
        
    #knn_graph = nbrs.kneighbors_graph(X).toarray()    
    #x_arcs, y_arcs = np.where(knn_graph>0)
    return indices, knn_graph


def adjacency_matrix(X, knn_graph, sigma=1, use_gauss = True):
    # matriz de similaridad con distancia Gaussiana
    #dists = pdist(X, similarity_func)
    if use_gauss:
        dists = pdist(X, lambda u, v: np.exp(-(euclidean(u,v)*euclidean(u,v))/(2*sigma**2)))
    else:
        dists = pdist(X, 'euclidean')
        
    sim_matrix = pd.DataFrame(squareform(dists))
    # matriz de adyacencias segun los vertices conectados
    adj_matrix = np.array(sim_matrix * knn_graph)
    adj_matrix = adj_matrix + np.eye(adj_matrix.shape[0])
    return adj_matrix

def laplacian(W,flag = 'rw'):
    # matriz de grados
    d = np.sum(W,axis=1)
    D = np.diag(d)
    if flag == 'L':
        L = D-W
    elif flag == 'sym':
        Dnorm = np.diag(1./np.sqrt(d))
        L = np.eye(Dnorm.shape[0]) - np.dot(np.dot(Dnorm,W),Dnorm)
    elif flag == 'rw':
        Dnorm = np.diag(1./d)
        L = np.eye(Dnorm.shape[0]) - np.dot(Dnorm,W)
    return L, D

def eigen_Lap(L, km = 2, flag = 'rw'):
    #vals, vecs = np.linalg.eig(L) #np
    vals, vecs = linalg.eig(L) #scipy
    vals = np.real(vals)
    vecs = np.real(vecs)
    # la descomposicion hecha con numpy o sckipy no da los eigenvalores ordenados,
    # entonces, los ordenamos de forma descendente    
    idx = vals.argsort()
    eigvals = vals[idx]
    eigvecs = vecs[:,idx]
    
    # obtiene los k vectores propios para k-means
    # es decir, el espacio de caracteristicas    
    if flag == 'sym':
        t_k = eigvecs[:,:km]
        eigvecs_k = preprocessing.normalize(t_k,norm='l2') # vectores normalizados
    else:
        eigvecs_k = eigvecs[:,:km]


    return eigvals, eigvecs, eigvecs_k

