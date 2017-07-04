# Machine Learning #

Various machine learning approaches are implemented for the "Machine Learning for robotics" lecture of TUM. The implementation was done in MATLAB.

# Contents #
## Python ##
* **pca_classification.py**: classification of faces from Yale Faces dataset
* **curse_of_dimensionality.py**: illustration of what happens to the angle enclosed by two vectors as their dimension increases. The resulting plot shows that as the dimension grows the average minimum angle converges to approximately 90 degrees, which in turn means that algorithms like e.g. k-nearest neighbors are not useful if the dimension is too high.
* **kernel_pca.py**: using a Gaussian kernel in the kappa() function
* **pca_img_compression.py**: basically just removing higher order principal components and re-project

## TUM Machine Learning in Robotics Course 2016 (EI7419)##
* /assignment_1
	*  /Exercise1: Estimate velocity motion model of a mobile robot through linear regression
	*  /Exercise2: Handwritten digits classification using Bayesian classifier
	*  /Exercise3: Human motion clustering
	
* /assignment_2
	*  /Exercise1: Learning dataset using Gaussian mixture model
	*  /Exercise2: Human gesture recognition using hidden Markov model
	*  /Exercise3: Learning gait pattern for humanoid robot using Reinforcement Learning
	
# Contributors #

*  Alexandros Sivris