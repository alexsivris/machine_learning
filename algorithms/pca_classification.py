#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 19:46:41 2017

@author: alex
"""
import os
import numpy as np
from scipy import misc
import scipy as sci
import matplotlib.pyplot as plt
from sklearn import neighbors
import numpy.matlib
from random import randint


## Function that returns the first N singular vectors of matrix T
def get_singular_vectors(T, N=20):
    U,S,Vt = np.linalg.svd(T)
    S=np.diag(S)
    print U.shape, S.shape, Vt.shape, T.shape
    
    # reproject to 2500 dimensions for visualization
    
    plt.subplot(5,1,1)
    img = np.reshape(U[:,0],(50,50))
    plt.imshow(img,cmap='gray')
    plt.subplot(5,1,2)
    img = np.reshape(U[:,1],(50,50))
    plt.imshow(img,cmap='gray')
    plt.subplot(5,1,3)
    img = np.reshape(U[:,2],(50,50))
    plt.imshow(img,cmap='gray')
    plt.subplot(5,1,4)
    img = np.reshape(U[:,3],(50,50))
    plt.imshow(img,cmap='gray')
    plt.subplot(5,1,5)
    img = np.reshape(U[:,4],(50,50))
    plt.imshow(img,cmap='gray')
    plt.show()    
    return U[:,:N]



def get_error_rate(T, S, T_labels, S_labels, U, k):
    # train projection matrix
    P = U[:,:k].T#dot(U[:,:k].T)  # 
    
    # build faces from eigenfaces
    proj_t_faces = P.dot(S) #S.dot(training_singular_vectors[:,:k])#
    proj_tr_faces = P.dot(T) #T.dot(training_singular_vectors[:,:k])#

    idx = np.asarray(range(proj_tr_faces.shape[1]))
    error_classif = 0
    for i in range(proj_t_faces.shape[1]):
        dist = np.zeros(70)
        for j in range(proj_tr_faces.shape[1]):
            dist[j] = np.linalg.norm(proj_tr_faces[:,j]-proj_t_faces[:,i],ord=None,axis=0)
       
        dist_sorted = np.array([dist, idx]).T
        dist_sorted = dist_sorted[dist_sorted[:,0].argsort()]
        pred_label = np.array([T_labels[int(dist_sorted[0,1])], \
                                                       T_labels[int(dist_sorted[1,1])], \
                                                       T_labels[int(dist_sorted[2,1])]])
        # 3-NN: vote for a winner
        winner = pred_label[0]
        for w in range(pred_label.shape[0]):
            if (np.count_nonzero(pred_label == pred_label[w]) == 2):
                winner = w
                break
            
       # winner = np.round(np.mean(pred_label))
        #winner = pred_label[randint(0, 2)]
       # winner = pred_label[0]
        
        # wrong classification?
        if (S_labels[i] != winner):
            error_classif = error_classif + 1
            
    error_rate = float(error_classif)/float(S.shape[1])
    error_classif = 0
    #print error_rate
    return error_rate

    
#%% Load training data 
path = './yaleBfaces/subset0'
img_list = os.listdir(path)  

T = np.zeros((2500,len(img_list)))
T_labels = np.zeros(len(img_list))
for i, name in enumerate(img_list):
    T[:,i] = misc.imread(path + '/' + name).reshape(-1)
    T_labels[i] = int(name[6:8])

U = get_singular_vectors(T)


#%% Load test data into a dictionary S
S = {}
S_labels = {}
for i in np.arange(4)+1:
    path = './yaleBfaces/subset%i'%i
    img_names = os.listdir(path)
    S['subset%i'%i] = np.zeros((2500,1))
    S_labels['subset%i'%i] = np.array([])
    temp = np.zeros((50*50,len(img_names)))
    for j,name in enumerate(img_names):
        temp[:,j] = sci.misc.imread(path+ '/' + name).reshape(-1)
        S_labels['subset%i'%i] = np.append(S_labels['subset%i'%i],int(name[6:8]))
    S['subset%i'%i] = np.concatenate((S['subset%i'%i],temp),axis=1)
    S['subset%i'%i] = S['subset%i'%i][:,1:]


# %% preprocessing (centering) of data
T_mean = np.repeat(np.mean(T, axis=0).reshape(1,70),2500,axis = 0)
T_std = np.repeat(np.std(T, axis=0).reshape(1,70),2500,axis = 0)
T = (T - T_mean)/T_std
    
T_generic = np.mean(T, axis = 1)
T = T - np.repeat(T_generic.reshape(2500,1), T.shape[1], axis=1)
#
for i in np.arange(4)+1:
    S_mean = np.repeat(np.mean(S['subset%i'%i], axis=0).reshape(1,S['subset%i'%i].shape[1]),2500,axis = 0)
    S_std = np.repeat(np.std(S['subset%i'%i], axis=0).reshape(1,S['subset%i'%i].shape[1]),2500,axis = 0)
    S['subset%i'%i] = (S['subset%i'%i]-S_mean)/S_std 
    S['subset%i'%i] = S['subset%i'%i] - np.repeat(T_generic.reshape(2500,1), S['subset%i'%i].shape[1], axis=1) 
    
    
#%% get error rates for the first 20 PCs and plot them
Accumulated_error = {}
for i in np.arange(4)+1:
    Accumulated_error['subset%i' % i] = np.zeros(20)
    for k in range(20):
        Accumulated_error['subset%i' % i][k] = get_error_rate(T, S['subset%i' % i], T_labels, S_labels['subset%i' % i], U, k)   
        
    plt.plot(np.asarray(range(20)),Accumulated_error['subset%i' % i],label='subset%i' % i)
    plt.xlabel('k')
    plt.ylabel('error rate in %')
    plt.legend()
    
