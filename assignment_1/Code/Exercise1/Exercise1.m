function par = Exercise1(k_max)
load('Data.mat');
d=1:20000;
%use block 1:4000 for testing; the rest for training
n = d;
segment_length = 20000/k_max;
block=[];
for idx=1:k_max
    block(idx,:) = segment_length*(idx-1)+1:segment_length*(idx-1)+segment_length;
end

% block = [1:4000; %1
%     4001:8000;  %2
%     8001:12000; %3
%     12001:16000;    %4
%     16001:20000];   %5
xy_errors = [];
theta_errors = [];
for k=1:k_max
    for p1=1:6
        for p2=1:6
            %use all blocks but block k for traiing
            n(block(k,:)) = [];
            ob = LSR(Input,Output, n, p1,p2);
            %param train with x
            a1 = ob.TrainingX();
            %param train with y
            a2 = ob.TrainingY();
            %use block k for testing
            xy_error = ob.PositionErrorXY(a1,a2,block(k,:));
            xy_errors = [xy_errors [xy_error;p1]];
            %param train with theta
            a3 = ob.TrainingTheta();
            %use block k for testing
            theta_error = ob.OrientationError(a3,block(k,:));
            theta_errors = [theta_errors [theta_error;p2]];
            ob = [];
            n = d;
        end
    end
end

% find optimum p1
total_xy_errors = [];

for p=1:6
    total_xy_errors(p,:) = xy_errors(1,2+6*(p-1):36:k_max*36+6*(p-1));
end
for p=1:6
    average_xy_errors(p,1) = 1/size(total_xy_errors,2) * sum(total_xy_errors(p,:));
end
optP1Err = min(average_xy_errors);
[optValP1,~] = find(average_xy_errors == min(average_xy_errors));

% find optimum p2
total_theta_errors = [];
for p=1:6
    total_theta_errors(p,:) = theta_errors(1,2+6*(p-1):36:k_max*36+6*(p-1));
end
for p=1:6
    average_theta_errors(p,1) = 1/size(total_theta_errors,2) * sum(total_theta_errors(p,:));
end
optP2Err = min(average_theta_errors);
[optValP2,~] = find(average_theta_errors == min(average_theta_errors));

% store learned values
par{1} = a1;
par{2} = a2;
par{3} = a3;
save('params','par');
Simulate_robot(0.5, -0.03);
end
