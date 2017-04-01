close all, clc, clear all;
load('gesture_dataset.mat');

%% exercise 3a.)
Exercise3_kmeans(gesture_x, init_cluster_x, 6);
Exercise3_kmeans(gesture_o, init_cluster_o, 6);
Exercise3_kmeans(gesture_l, init_cluster_l, 6);

%% exercise 3b.)
Exercise3_nubs(init_cluster_x, gesture_x, 7);
Exercise3_nubs(init_cluster_o, gesture_o, 7);
Exercise3_nubs(init_cluster_l, gesture_l, 7);