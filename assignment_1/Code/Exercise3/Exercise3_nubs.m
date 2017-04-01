function output = Exercise3_nubs( init_cluster,gesture ,k_max )
%EXERCISE_B Summary of this function goes here
%   Detailed explanation goes here
cluster_x = init_cluster;

%transform 3d array to 2d
gesture_x_2D = [];
p=1;
for m=1:60
    for n=1:10
        gesture_x_2D(p,1:3) = gesture(m,n,1:3);
        p = p + 1;
    end
end

v = [0.08 0.05 0.02];

% format: Row x Col x Class#
classes(1:600,1:3,:) = 0;
classes(1:600,1:3,1)=gesture_x_2D;
distortion(1:k_max,1) = 0;

% init centroid
total_elements = nnz(classes(:,:,1))/3;
centroid(1,1:3,1) = 1/total_elements * sum(classes(:,:,1));

for k=1:k_max
    %calcuate distortions
    for m=1:size(classes,3)
        total_elements = nnz(classes(:,:,m))/3;
        distortion(m,1) = 0;
        for n=1:total_elements
            distortion(m,1) = distortion(m,1) + ...
                1/total_elements * sqrt(sum((classes(n,1:3,m)-centroid(1,1:3,m)).^2));
        end
    end
    
    %target class with maximum distortion
    [target_idx,~] = find(distortion == max(distortion));
    target_elements = nnz(classes(:,:,target_idx))/3;
    
    %new centroids
    temp_cent_a = centroid(1,1:3,target_idx) + v;
    temp_cent_b = centroid(1,1:3,target_idx) - v;
    
    %temporary classes
    %calculate distances of all points (rows) in the target class to centroids a
    %and b (cols)
    distances_to_centroids=[];
    temp_class_a(1:target_elements,1:3)=0;
    temp_class_b(1:target_elements,1:3)=0;
    for p=1:target_elements
        distances_to_centroid_a = sqrt(sum( (classes(p,:,target_idx) - temp_cent_a).^2));
        distances_to_centroid_b = sqrt(sum( (classes(p,:,target_idx) - temp_cent_b).^2));
        
        if (distances_to_centroid_a > distances_to_centroid_b)
            %assign to class b
            temp_class_b(p,1:3) = classes(p,:,target_idx);
        else
            %assign to class a
            temp_class_a(p,1:3) = classes(p,:,target_idx);
        end
    end
    
    %re-align temp classes before storing them back
    mark_nz = all(temp_class_a,2); %mark all nonzero elements
    [tmp_idx,~] = find(mark_nz);
    temp_class_a = temp_class_a(tmp_idx,1:3);
    
    mark_nz = all(temp_class_b,2); %mark all nonzero elements
    [tmp_idx,~] = find(mark_nz);
    temp_class_b = temp_class_b(tmp_idx,1:3);
    
    %assign new classes
    classes(1:600,1:3,target_idx) = 0;
    classes(1:600,1:3,k+1) = 0;
    classes(1:size(temp_class_a,1),1:3,target_idx) = temp_class_a;
    classes(1:size(temp_class_b,1),1:3,k+1) = temp_class_b;
    
    %calculate new centroids
    centroid(1,1:3,target_idx) = ...
        1/size(temp_class_a,1) * sum(classes(:,1:3,target_idx));
    centroid(1,1:3,k+1) = ...
        1/size(temp_class_b,1) * sum(classes(:,1:3,k+1));
end


%display results
figure;
for cluster=1:size(classes,3)
    hold on;
    switch (cluster)
        case 1
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'bo');
        case 2
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'ko');
        case 3
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'ro');
        case 4
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'go');
        case 5
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'mo');
        case 6
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'yo');
        case 7
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'co');
        otherwise
            scatter3(classes(:,1,cluster),classes(:,2,cluster),classes(:,3,cluster),'o');
    end
    
end



end

