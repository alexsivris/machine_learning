classdef my_kmeans
    %MY_KMEANS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        epsilon = 10^-6;
        total_distortion = 0;
        total_distortion_previous = 0;
        total_distortion_difference = Inf;
        cluster_x; 
        gesture_x_2D = [];
        clustered_data_points = [];
        distances_to_x = [];
        min_idx=[];
        total_clusters=7;
    end
    
    methods
        % constructor
        function obj = my_kmeans(init_cluster, data_points,num_clusters)
            obj.total_clusters = num_clusters;
            obj.cluster_x = init_cluster;
            p=1;
            for m=1:60
                for n=1:10
                    obj.gesture_x_2D(p,1:3) = data_points(m,n,1:3);
                    p = p + 1;
                end
            end
            a = kmeans_algo(obj);
            draw_points(obj,a);
        end
        
        
    end
    methods (Access = private)
        % run algorithm
        function dp = kmeans_algo(obj)
            while (obj.total_distortion_difference>obj.epsilon)
                obj.distances_to_x = [];
                obj.min_idx=[]; % save indices of points of gestures_x_2D
                for a=1:length(obj.gesture_x_2D)
                    for cluster=1:obj.total_clusters
                        obj.distances_to_x(a,cluster) = ((obj.gesture_x_2D(a,1) - obj.cluster_x(cluster,1))^2 + ...
                            (obj.gesture_x_2D(a,2) - obj.cluster_x(cluster,2))^2 + ...
                            (obj.gesture_x_2D(a,3) - obj.cluster_x(cluster,3))^2)^0.5;
                    end
                end
                
                min_dist = min(obj.distances_to_x,[],2);
                
                %label data points based on min. dist.
                for b = 1:length(obj.distances_to_x)
                    [~,c] = find(obj.distances_to_x == min_dist(b,1));
                    obj.min_idx(b,1) = c(1);
                    % display(sprintf('Point (%.2f, %.2f, %.2f) belongs to cluster %d', ...
                    %    points_x(b,1),points_x(b,2),points_x(b,3), c(1) ));
                end
                all_points= [];
                
                for cluster=1:obj.total_clusters
                    cluster_length = length(find(obj.min_idx==cluster));
                    idc = find(obj.min_idx==cluster);
                    
                    all_points = obj.gesture_x_2D(idc,1:3);
                    if (cluster_length)
                        obj.cluster_x(cluster,1) = 1/cluster_length * sum(all_points(:,1));
                        obj.cluster_x(cluster,2) = 1/cluster_length * sum(all_points(:,2));
                        obj.cluster_x(cluster,3) = 1/cluster_length * sum(all_points(:,3));
                    end
                end
                obj.cluster_x = obj.cluster_x(1:obj.total_clusters,1:3);
                
                obj.total_distortion_previous = obj.total_distortion;
                obj.total_distortion=0;
                for cluster=1:obj.total_clusters
                    idc = find(obj.min_idx==cluster);
                    all_points = obj.gesture_x_2D(idc,1:3);
                    
                    for p=1:length(all_points)
                        obj.total_distortion = obj.total_distortion + ...
                            sum((all_points(p,:)-obj.cluster_x(cluster,:)).^2).^(0.5);
                    end
                end
                
                obj.total_distortion_difference = abs(obj.total_distortion - obj.total_distortion_previous);
                
            end
            dp = obj.min_idx;
            
        end
        
        function pp = draw_points(obj,a)
            figure;
            
            for cluster=1:obj.total_clusters
                idc = find(a==cluster);
                
                all_points = obj.gesture_x_2D(idc,1:3);
                hold on;
                switch (cluster)
                    case 1
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'bo');
                    case 2
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'ko');
                    case 3
                       
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'ro');
                    case 4
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'go');
                    case 5
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'mo');
                    case 6
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'yo');
                    case 7
                      
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'co');
                    otherwise
                        
                        scatter3(all_points(:,1),all_points(:,2),all_points(:,3),'o');
                end
                
            end
            
            
        end
    end
end

