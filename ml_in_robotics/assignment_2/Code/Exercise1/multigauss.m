function [ output_mvnpdf ] = multigauss( data, mu, sigma )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for m=1:length(data)
    abc = -0.5 * (data(m,:) - mu) * inv(sigma) * (data(m,:) - mu)';
    output_mvnpdf(m) = 1/(sqrt(2*pi)*sqrt(det(sigma))) * expm(abc);
end

end

