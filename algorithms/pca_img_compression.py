# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
from PIL import Image
from scipy import misc

img = misc.imread('YOUR_IMG_FILE.png',False, 'L')

# function that computes pca
def get_principal_components(comp, DATA):
    U,S,V = np.linalg.svd(DATA)
    S = np.diag(S)
    #S = np.diag(S[1:comp])
    #V = np.transpose(V[:,1:comp])
    #print U[1:comp,:].shape, S[:,1:comp].shape, V[1:comp,:].shape
    Uk = U[:,:comp]
    proj = Uk.dot(np.transpose(Uk))
    return proj.dot(U).dot(S).dot(V)
    #return U[:, :comp].dot(S[:comp,:comp]).dot(V[:comp, :])

pat = get_principal_components(40,img)
misc.imshow(pat)


