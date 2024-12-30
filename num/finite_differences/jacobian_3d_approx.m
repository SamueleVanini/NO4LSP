function Jac = jacobian_3d_approx(F, x_bar, h, F_x_bar, specific)
%JACOBIAN_3D_APPROX Approximation of the Jacobian of F
%   Input:
%       F - vector function
%           function handle
%       x_bar - point in where to compute the jacobian
%           row vector
%       h - level of approximation
%           scalar
%       F_x_bar - function evaluation in x_bar, precomputed
%           row vector
%       specific - implement a specific approximation based on x_bar
%           logical value
%
%   Output
%       Jac - approximation of the jacobian
%           sparse matrix

n = length(x_bar);

if specific
    h = h*abs(x_bar);
else
    h = h*ones(1, n);
end

[e1, e2, e3] = e_vectors(n, h);

% delta = @(e) F(x_bar + e) - F_x_bar;
approx = @(e) (F(x_bar + e) - F_x_bar)./h;
eval = [approx(e1), approx(e2), approx(e3)];

main_diag = zeros(n, 1);
off_diag = zeros(n - 1, 1); % ensuring symmetry

main_diag(1) = eval(1, 1);
for i = 2:n
    col = mod(i-1, 3) + 1;

    main_diag(i) = eval(i, col);
    off_diag(i-1) = eval(i-1, col);
end

Bin = [[off_diag; 0], main_diag, [0; off_diag]];
Jac = spdiags(Bin, [-1 0 1], n, n);
end