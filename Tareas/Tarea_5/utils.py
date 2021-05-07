import numpy as np
import pandas as pd

import matplotlib.pyplot as plt 
import seaborn as sns

from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn import metrics
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis

semilla = 19970808

def metrics_error(y, predict):
    confusion_matrix = metrics.confusion_matrix(y, predict)
    fig, axs = plt.subplots(figsize=(10,10))
    print(sns.heatmap(confusion_matrix, annot=False, cmap="coolwarm", xticklabels = True, yticklabels = True))
    return print(metrics.classification_report(y, predict))



def clasification_baseline(X_train, y_train, X_test, y_test):
    y_train_dummies = pd.get_dummies(y_train)
    n, k = y_train_dummies.shape
    (n_test, ) = y_test.shape
    
    clasification_train = np.zeros((n, k)) 
    clasification = np.zeros((n_test, k)) 
    reg = LinearRegression(n_jobs=-1)
    for i in range(k):
        print(i)
        reg.fit(X_train, y_train_dummies[i])
        clasification_train[:,i] = reg.predict(X_train)
        clasification[:,i] = reg.predict(X_test)
    
    print("----------Errors train------------------")
    y_predict = np.argmax(clasification_train, axis=1)
    metrics_error(y_train, y_predict)           
        
    print("----------Errors test------------------")
    y_predict = np.argmax(clasification, axis=1)
    metrics_error(y_test, y_predict)
    
    return y_predict

def LDA_clasification(X_train, y_train, X_test, y_test):
    lda = LinearDiscriminantAnalysis(solver="svd", store_covariance=True)
    lda.fit(X_train, y_train)
    
    print("----------Errors train------------------")
    y_predict = lda.predict(X_train)
    metrics_error(y_train, y_predict)

    print("----------Errors test------------------")
    y_predict = lda.predict(X_test)
    metrics_error(y_test, y_predict)
    
    return y_predict

def QDA_clasification(X_train, y_train, X_test, y_test):
    qda = QuadraticDiscriminantAnalysis(store_covariance=True)
    qda.fit(X_train, y_train)

    print("----------Errors train------------------")
    y_predict = qda.predict(X_train)
    metrics_error(y_train, y_predict)
    
    print("----------Errors test------------------")
    y_predict = qda.predict(X_test)
    metrics_error(y_test, y_predict)
    
    return y_predict


def log_regression_clasification(X_train, y_train, X_test, y_test):
    log_reg = LogisticRegression(solver='sag', max_iter=100, random_state=semilla,
multi_class="multinomial", n_jobs=-1)
    log_reg.fit(X_train, y_train)
    
    print("----------Errors train------------------")
    y_predict_m = log_reg.predict(X_train)
    metrics_error(y_train, y_predict_m)    
    
    print("----------Errors test------------------")
    y_predict_m = log_reg.predict(X_test)
    metrics_error(y_test, y_predict_m)
    
    
    log_reg = LogisticRegression(solver='sag', max_iter=100, random_state=semilla,
multi_class="ovr", n_jobs=-1)
    log_reg.fit(X_train, y_train)
    
    print("----------Errors train------------------")
    y_predict_ovr = log_reg.predict(X_train)
    metrics_error(y_train, y_predict_ovr)

    print("----------Errors test------------------")
    y_predict_ovr = log_reg.predict(X_test)
    metrics_error(y_test, y_predict_ovr)
    return y_predict_m, y_predict_ovr
    
    
    
    