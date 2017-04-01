function [ state_vec ] = test_greedy( initstate, Q, delta, rew)

ctr = 1;
state = initstate;
state_vec = zeros(16,1);
while(ctr < 17)
    [~, a] = max(Q(state,:));
    [s_next,r] = SimulateRobot(state,a,delta,rew);
    state_vec(ctr) = state;
    state= s_next;
    ctr = ctr+1;
end

end

