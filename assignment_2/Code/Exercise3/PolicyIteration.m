clc, clear all;

%% reward matrix
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

%% Policy Iteration
% state transition matrix
% row: state, column: action
delta = zeros(16,4);
delta(:,1) = [2 1 4 3 6 5  8 7 10 9 12 11 14 13 16 15]';
delta(:,2) = [4:-1:1,8:-1:5,12:-1:9,16:-1:13]';
delta(:,3) = [5:8,1:4,13:16,9:12]';
delta(:,4) = [13:16,9:12,5:8,1:4]';
% gamma < 1
gamma = 0.75;
policy = ceil(rand(16,1)*4);
c=0;
converged = 99;
while converged ~= 0
    for state=1:16
        % create system of linear equations as of defined in the symbolic math
        % toolbox
        V = sym('x',[16,1]);
        r(state) = V(state) - gamma*V(delta(state,policy(state))) == rew(state,policy(state));
    end
    solution = solve(r,V);
    val=zeros(size(V));
    for m=1:size(val,1)
        eval(sprintf('val(%d) = double(solution.x%d);',m,m));
    end
    
    % set new policy
    prior_policy = policy;
    for state = 1:16
        expValues = zeros(4,1);
        for action = 1:4
            expValues(action) = rew(state,action)+gamma*val(delta(state,action));
        end
        [~, policy(state)] = max(expValues);
    end
    
    converged = sum(abs(prior_policy-policy));
    c = c+1;
    display(sprintf('Counter is at: %d', c));
end


%% Walk policy iteration
startState = 3;
[  outputstate ] = WalkPolicyIteration(startState,policy,delta);
walkshow(outputstate');
