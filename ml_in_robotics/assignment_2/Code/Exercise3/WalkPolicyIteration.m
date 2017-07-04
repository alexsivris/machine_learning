function [  outputstate ] = WalkPolicyIteration(startState,policy,delta)
% Note: Execute PolicyIteration script before (it calls this function in
% the end).
outputstate = zeros(16,1);
outputstate(1) = startState;
for m= 2:16
    outputstate(m) = delta(outputstate(m-1),policy(outputstate(m-1)));
end

end