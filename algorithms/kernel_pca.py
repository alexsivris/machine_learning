# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 09:10:20 2017

@author: alex
"""

import numpy as np
from scipy import misc
import glob

# load mnist
data_path_main = './data/mnist_train/'

# imported numbers
imp_numbers = [0, 1, 2]

num_folders = ['d' + str(n) for n in imp_numbers]

print('Loading MNIST numbers {}'.format(', '.join(str(i) for i in imp_numbers)))

image_list = []

n_class_samples = 500

for num in num_folders:
    class_counter = 0
    for filename in glob.glob(data_path_main + num + '/*.png'):
        if class_counter < n_class_samples:
            im = misc.imread(filename)
            image_list.append(np.double(im).ravel()/255.)
            class_counter += 1

X_mnist = np.array(image_list).T

y_1 = np.array([[1,0,0]]*n_class_samples)
y_2 = np.array([[0,1,0]]*n_class_samples)
y_3 = np.array([[0,0,1]]*n_class_samples)

C = np.concatenate((y_1,y_2,y_3), axis=0)
C = C.T
yy = np.vstack((np.vstack((y_1,y_2)), y_3)).T
#%%
X_mean = np.mean(X_mnist,axis=0)
X_mean = np.repeat(X_mean,X_mnist.shape[0],axis=0)
X_mean = np.reshape(X_mean,X_mnist.shape)
X_mnist = X_mnist - X_mean

#%% 
k=2
U,Sigma,Vt = np.linalg.svd(X_mnist)
Sigma = np.diag(Sigma)
U_k = U[:,:k]

X_proj = Sigma[:k,:k].dot(Vt[:k,:])

import matplotlib.pyplot as plt

plt.scatter(X_proj[0,:].T,X_proj[1,:].T,c=C.T,marker='o')

#%%
def kgram(X, kappa):
    p, N_X = X.shape
    K_gram = np.zeros((N_X,N_X))
    columns = np.repeat(X[:,0:1],X.shape[1], axis = 1)
    columns = np.reshape(columns,X.shape)
    for row in range(N_X):
        YY = np.outer(X[:,row], np.ones(N_X - row))
        K_gram[row, row:] = kappa(X[:,row:], YY)
    
    return K_gram + np.tril(K_gram.T, k=-1)

def kappa(X,Y): 
    # Gaussian Kernel
    sigma = 5
    k_row = np.exp(- np.sum((X-Y)**2, axis = 0) / (2*sigma**2))
    return k_row
     #return (np.sum(x*y)+c)**d



def kpca(X_train, kappa, k):
    K = kgram(X_train, kappa)
    H = np.identity(K.shape[0]) - 1/K.shape[0] * np.ones((K.shape[1],K.shape[1]))
    K = H.dot(K).dot(H)
    w,V = np.linalg.eig(K)
    Vt = V.T
    Sigma = np.diag(np.sqrt(w))
    S = Sigma[:k,:k].dot(Vt[:k,:])
    return S

#%%
k=3
S = kpca(X_mnist, kappa, k)

#%% visualization
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
fig = plt.figure()
ax = fig.add_subplot(111)
colos = 'rgb'
#for i in range(X_proj.shape[1]):
ax = fig.add_subplot(111, projection='3d')
for s in range(S.shape[1]):
    ax.scatter(S[0,s],S[1,s],S[2,s], c=C[:,s].T, marker='o')
