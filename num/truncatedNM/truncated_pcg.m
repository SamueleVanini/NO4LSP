function [x_found, iteration] = ...
    truncated_pcg(A, b, x_initial, max_iteration, tollerance)
%TRUNCATED_PCG Summary of this function goes here
%   Detailed explanation goes here

% Initialization
x_iter = x_initial;
r = b - A*x_iter;
d = r;

i = 0;

% Stopping criteria: Relative Residual
norm_b = norm(b);
rel_res = norm(r) / norm_b;

% loop
while i < max_iteration && ...
        rel_res > tollerance

    z = A * d;

    alpha = (d' * r) / (d' * z);

    % Next approximation
    x_iter = x_iter + alpha * d;

    % Preparation for next step
    r = b - A*x_iter;
    beta = - (r' * z) / (d' * z);
    d = r + beta*z;

    rel_res = norm(r) / norm(b);
    i = i + 1;
end

iteration = i;
x_found = x_iter;

end