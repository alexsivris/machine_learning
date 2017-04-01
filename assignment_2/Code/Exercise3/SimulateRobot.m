function [ newstate, reward ] = SimulateRobot( state, action, delta, rew )
%return new state from delta matrix
newstate = delta(state,action);

% and get reward
reward = rew(state,action);
end

