function [x_found, f_x, norm_grad_f_x, iteration, failure] = ...
    truncatedNM(f, grad_f, hess_f, x_initial, max_iteration, ...
    tollerance, c1, rho, max_backtrack, do_pcg_precond)
%TRUNCATEDNM Truncated Newton Method, for minimazing a scalar function
%   Detailed explanation goes here

% -- Initialization --
x_k = x_initial;
f_xk = f(x_k);
grad_f_xk = grad_f(x_k);
norm_grad_f_xk = norm(grad_f_xk);

% -- PCG fixed parameters --
precond = []; % default value
pcg_tol = 1e-7;
pcg_maxit = 50;

i = 0;
failure = false;

while i < max_iteration && ...      % iteration
        norm_grad_f_xk >= tollerance % stopping condition
    
    % -- Compute descent direction --
    % Compute the preconditioning matrix for pcg
    A = hess_f(x_k);
    if do_pcg_precond
        precond = ichol(sparse(A));
    end

    % Using -grad_f(xk) as starting point will guarantee that pcg will
    % return a descent direction, even if pcg fails
    [desc_dir, ~, ~, ~, ~] = ...
        pcg(A, -grad_f_xk, pcg_tol, pcg_maxit, precond, precond', -grad_f_xk);

    % -- Backtracking --
    alpha = 1; % this ensure quadratic convergence in the long run

    x_new = x_k + alpha*desc_dir;
    f_new = f(x_new);
    
    b = 0;
    while b < max_backtrack && ...
            f_new > f_xk + alpha*c1*grad_f_xk'*desc_dir % Armijo
        % Reduce alpha
        alpha = alpha * rho;

        % Re-compute
        x_new = x_k + alpha*desc_dir;
        f_new = f(x_new);
        b = b + 1;
    end

    % Check for backtracking failure
    if b >= max_backtrack && ...
        f_new > f_xk + alpha*c1*grad_f_xk'*desc_dir
        failure = true;
        break
    end

    % -- Update --
    x_k = x_new;
    f_xk = f_new;
    grad_f_xk = grad_f(x_k);
    norm_grad_f_xk = norm(grad_f_xk);

    i = i + 1;
end

% -- Final result --
x_found = x_k;
f_x = f_xk;
norm_grad_f_x = norm_grad_f_xk;
iteration = i;

end