####
#! Author: Alexandros Sivris
####


import time
import numpy as np
import matplotlib.pyplot as plt

def sample_box(dim,sample_size):
    A = np.random.uniform(-1,1,(dim,sample_size))
    min_angles = np.zeros((1,sample_size))
    for n in range(sample_size):
        V1 = np.ones(A.shape)
        for m in range(dim):
            V1[m,:] *= A[m,n]
        TMPROD = V1 * A
        dot_prod = np.sum(TMPROD,0)
        denom = np.sqrt(np.sum(V1*V1,0)) * np.sqrt(np.sum(A*A,0))

        #delete angle with same vector
        dot_prod = np.delete(dot_prod,n,None)
        denom = np.delete(denom,n,None)
        try:
            angle = dot_prod / denom
        except ZeroDivisionError as e:
            print "Run-time error ", e
        angle = np.arccos(angle).transpose()*180/np.pi
        
        min_angles[0,n] = np.amin(angle)
    avg_min_angle = np.average(min_angles)
    return avg_min_angle

#%% calculate average min. angle
t = time.time()
samples = 100
dim=100
avg_min_angles = np.zeros((1,dim))
ama = sample_box(dim,samples)
for m in range(dim):
    avg_min_angles[0,m] = sample_box(m+1,samples)

#%% plot dimension vs average min. angle
x = np.linspace(1,dim,dim)
plt.plot(x,np.transpose(avg_min_angles))
plt.xlabel("dimension")
plt.ylabel("average min. angle")
plt.title("Curse of Dimensionality - %d samples" % (samples))
plt.grid()
plt.show()

    
elapsed = time.time() - t
print "Time elapsed: ", elapsed
