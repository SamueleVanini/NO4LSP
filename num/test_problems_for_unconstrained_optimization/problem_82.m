function F = problem_82(x)
%PROBLEM_82 Problem 82 function evaluation
% Input:
%   x : n-dimensional vector
% Output:
%   F : scalar function value

n = length(x);
cos_x = cos(x);

% first term
F = x(1)^2; 
for i = 2:n
    F = F + (cos_x(i-1) + x(i) - 1)^2;
end

F = .5*F;
end