function [ loglikelihood ] = compute_likelihood( A,B,pi, M,N,T,REPS, Set )
%% compute likelihood w/ the Forward Procedure

likelihood = 0;
alpha = [];
for t=1:T
    % 1.) Initialization
    for i=1:N
        alpha(1,i) = pi(i) * B(Set(t,1),i);
    end
    % 2.) Induction
    for obs=2:REPS
        alpha(obs,1:N) = 0;
        for j=1:N
            for i=1:N
                alpha(obs,j) = alpha(obs-1,j)*A(i,j) + alpha(obs,j);
            end
            alpha(obs,j) = alpha(obs,j) * B(Set(t,obs),j);
        end
    end
    % 3.) Termination
    prob(t) = sum(alpha(REPS,:));
    loglikelihood(t) = log(prob(t));
end

end

