clear all, clc, close all;
load('dataGMM.mat');
k=4; % 4 components of the GMM

%% a.) init GMM with kmeans
tem = Data';
idx = kmeans(tem,k);
gmm_mu= zeros(1,2,k);
gmm_sigma= zeros(2,2,k);
gmm_pi=zeros(1,k);
for m = 1:k
    gmm_pi(m) = size(find(idx==m),1)/size(idx,1);
    gmm_sigma(:,:,m) = cov(tem(idx==m,:));
    gmm_mu(:,:,m) = mean(tem(idx==m,:));
end

%% Condition to stop EM algorithm
loglikelihood = 0;
diff_likelihood = 500; % just to step into loop
while(diff_likelihood > 0.01)
    %% b.) E-Step
    resp=[];
    for m=1:k
        zaehler = (gmm_pi(m) * multigauss(tem, gmm_mu(:,:,m), gmm_sigma(:,:,m)));
        nenner = 0;
        for n=1:k
            nenner = nenner + gmm_pi(n) * multigauss(tem, gmm_mu(:,:,n), gmm_sigma(:,:,n));
        end
        resp(:,m) = zaehler ./ nenner;
    end
    

    %% M-Step
    n=size(tem,1);
    for m=1:k;
        nk = sum(resp(:,m));
        
        % new pi
        gmm_pi(m) = nk/n;
        % new mu
        gmm_mu(:,1,m) = 1/nk * sum( resp(:,m)' * tem(:,1) );
        gmm_mu(:,2,m) = 1/nk * sum( resp(:,m)' * tem(:,2) );
        % new sigma
        tmp_sigma = zeros(2,2);
        for n=1:size(resp,1)
%             tmp_sigma = tmp_sigma + resp(n,m)' * ((bsxfun(@minus, tem,gmm_mu(:,:,m)))' * (bsxfun(@minus, tem,gmm_mu(:,:,m))) );
            tmp_sigma = tmp_sigma + resp(n,m)*(tem(n,:)-gmm_mu(:,:,m))'*(tem(n,:)-gmm_mu(:,:,m));
        end
        gmm_sigma(:,:,m) = 1/nk * tmp_sigma;
    end
    %% evaluate log-likelihood
    n=size(tem,1);
    previous_loglikelihood = loglikelihood;
    loglikelihood = 0;
    for q=1:n
        
        inner_likelihood = 0;
        for p=1:k
            inner_likelihood = inner_likelihood + gmm_pi(p)* multigauss(tem(q,:)',gmm_mu(:,:,p), gmm_sigma(:,:,p));
        end
        loglikelihood = loglikelihood + log(inner_likelihood);
        
    end
    
    diff_likelihood = abs(previous_loglikelihood-loglikelihood);
end
