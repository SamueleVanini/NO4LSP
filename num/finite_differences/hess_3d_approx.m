function hess_f = hess_3d_approx(f, x_bar, h, f_xbar)
%HESS_3D_APPROX - Approximation of the Hessian of f
%   Based on function evaluation
%   Only for tri-diagonal hessian

n = length(x_bar);
he = @(i) h*(double(1:n == i)');

main_diag = zeros(n, 1);
off_diag = zeros(n - 1, 1);

% hess(1, 1)
main_diag(1) = (f(x_bar + 2*he(1)) - 2*f(x_bar + he(1)) + f_xbar)/(h^2);

for i = 2:n
    j = i - 1;

    he_i = he(i);
    he_j = he(j);

    main_diag(i) = (f(x_bar + 2*he_i) - 2*f(x_bar + he_i) + f_xbar)/(h^2);
    off_diag(j) = (f(x_bar + he_i + he_j) - f(x_bar + he_i) - f(x_bar + he_j) + f_xbar)/(h^2);
end

Bin = [[off_diag; 0], main_diag, [0; off_diag]];
hess_f = spdiags(Bin, [-1 0 1], n, n);
end