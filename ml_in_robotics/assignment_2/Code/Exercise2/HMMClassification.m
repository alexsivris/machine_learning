clear all, clc, close all;
load('A.txt');
load('B.txt');
load('pi.txt');
load('A_Test_Binned.txt');
load('A_Train_Binned.txt');

M=8; 
N=12; % States
T=60; % sequence
REPS = 10;

%% compute likelihood for Test
likelihood_test = compute_likelihood(A,B,pi,M,N,T,REPS,A_Test_Binned);
likelihood_train = compute_likelihood(A,B,pi,M,N,T,REPS,A_Train_Binned);

%% classify test set
classified_test = zeros(size(likelihood_test));
ctr=0;
for i=1:size(likelihood_test,2)
    if (likelihood_test(1,i) > -120)
        % it's a train
        classified_test(1,i) = 1;
        ctr = ctr+1;
    end
end
display(sprintf('%d train sequences and %d test sequences', ctr, 60-ctr));

%% classify train set
classified_train = zeros(size(likelihood_train));
for i=1:size(likelihood_train,2)
    if (likelihood_train(1,i) > -120)
        % it's a train
        classified_train(1,i) = 1;
    end
end