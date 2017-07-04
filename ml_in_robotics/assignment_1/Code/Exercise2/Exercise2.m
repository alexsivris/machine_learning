function [d_plot,d_opt, d_class_error, conf_mat] = Exercise2(d_max)
% ATTENTION: This implementation turns out to be pretty slow. I'm sorry for
% that and hope that you have the patience to wait for the script to have
% finished (took 115.440342 sec.) on my i5 PC.

tic;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
%PCA
[images_rows,images_cols] = size(images);
meanData = mean(images,2) * ones(1,images_cols);
img = images - meanData; % 1
cov_img = cov(img'); % 2
[V,D] = eig(cov_img); % 3

[sortedValues,sortIndex] = sort(D(:),'descend'); % 4
class_range = [];
for d=1:d_max
    maxIndex = sortIndex(1:d);
    %find right d
    [a, b] = ind2sub(size(D),maxIndex);
    U = V(:,b);
    low_dim_data = U' * img; % 5
    % low_dim_data = U * U' * img; % 5
    % imshow(reshape( low_dim_data(:,14)+ mean(img,2),28,28));
    
    
    %% test
    images_test = loadMNISTImages('t10k-images.idx3-ubyte');
    labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');
    [test_rows,test_cols] = size(images_test);
    %subtract mean
    images_test = images_test - mean(images,2)*ones(1,test_cols);
    
    proj_test =  U' * images_test;
    
    ldd_mean = {};
    ldd_cov = {};
    priors = [];
    likelihood = [];
    
    
    m=1:length(proj_test);
    for n = 0:9
        idx = find(labels==n);
        im2 = low_dim_data(:,idx);
        %     ldd_mean{n+1} = mean(im2,2);
        %     ldd_cov{n+1} = cov(im2');
        priors = [priors length(idx)/length(labels)];
        likelihood(n+1,m) = mvnpdf(proj_test(:,m)',mean(im2,2)',cov(im2'));
    end
    
    % associate input to highest likelihood value
    test_output = [];
    for m=1:length(proj_test)
        [r1,c1] = find(likelihood == max(likelihood(:,m)));
        test_output(m,1)=r1-1; % subtract 1 because labels go from 0 to 9
    end
    % check how good the result is
    difference = abs(test_output-labels_test);
    [k,~] = find(difference);
    %display(sprintf('With %d Features, there is a %.2f%% classification error!',d,length(k)/length(images_test)*100));
    class_range(1,d) = length(k)/length(images_test)*100;
end
[~, optimal_d] = find(class_range == min(class_range));
d_plot = class_range;
d_opt = optimal_d;
d_class_error = min(class_range);
conf_mat = confusionmat(labels_test, test_output);
toc;
figure;
plot(1:d_max,d_plot);
xlabel('value for d');
ylabel('classification error');
grid on;
% ----------------------------------------------------------------------
% the optimal value for d is either 48 or 49 (same classification error, 
% which is 3.6200, as can be seen in class_range(1,48)/class_range(1,49)
end
