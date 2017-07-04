clc, clear all, close all;

%% reward matrix (as in policy iteration)
rew = zeros(16,4);
% have to lift leg up before moving
rew(1,:) = [0 -1 0 -1];
rew(2,:) = [0 0 -1 -1];
rew(3,:) = [0 0 -1 -1];
rew(4,:) = [-1 -1 0 -1];

rew(5,:) = [-1 -1 -1 0];
% rew(6,:) = [-1 1 1 -1];
% rew(7,:) = [1 -1 1 -1];
rew(8,:) = [0 1 0 0];

rew(9,:) = [-1 -1 0 -1];
% rew(10,:) = [-1 1 -1 -1];
% rew(11,:) = [1 -1 -1 -1];
rew(12,:) = [0 1 0 -1];

rew(13,:) = [0 -1 0 -1];
rew(14,:) = [-1 0 0 1];
rew(15,:) = [-1 -1 0 1];
rew(16,:) = [0 -1 0 -1];

% state transition matrix
% row: state, column: action
delta = zeros(16,4);
delta(:,1) = [2 1 4 3 6 5  8 7 10 9 12 11 14 13 16 15]';
delta(:,2) = [4:-1:1,8:-1:5,12:-1:9,16:-1:13]';
delta(:,3) = [5:8,1:4,13:16,9:12]';
delta(:,4) = [13:16,9:12,5:8,1:4]';


%% Q-Learning
Q = zeros(16,4); 
eps = 0.01;
initstate = 12;
gamma = 0.99;
alpha = 0.1;

% just for checking how many steps are necessary
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 10000 );
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 30000 );
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 50000 );
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 70000 );
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 90000 );
[ initstate, Q, delta, rew ] = QLearning( delta, rew, Q, eps, initstate, gamma, alpha, 100000 );

%% testing with greedy
[ state_vec ] = test_greedy( initstate, Q, delta, rew);



