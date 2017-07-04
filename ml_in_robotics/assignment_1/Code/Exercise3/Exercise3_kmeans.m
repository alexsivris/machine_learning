function [ output_args ] = Exercise3_kmeans( motion_data, init_cluster, num_clusters )
% Note: the algorithm implementation is inside the my_kmeans.m class file

objkmeans = my_kmeans(init_cluster, motion_data, num_clusters);
output_args = objkmeans;
end

