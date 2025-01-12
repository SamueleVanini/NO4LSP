function HessF = problem_82_hess(x)
%PROBLEM_82_HESS Hessian of the Problem 82 function
% Input:
%   x : n-dimensional vector
% Output:
%   HessF : (n x n) Hessian matrix (tri-diagonal)

n = length(x);
cos_x = cos(x);
sin_x_2 = sin(x).^2;

main_diag = ones(n, 1);
off_diag = -sin(x(1:n-1));

for i = 1:n-1
    main_diag(i) = 1 - cos_x(i)*(cos_x(i) + x(i+1) - 1) + sin_x_2(i);
end

Bin = [[off_diag; 0], main_diag, [0; off_diag]];
HessF = spdiags(Bin, [-1 0 1], n, n);
end