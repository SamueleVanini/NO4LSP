function [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
    x_sequence, backtrack_sequence, pcg_sequence] = ...
    truncatedNM(f, grad_f, hess_f, x_initial, max_iteration, ...
    tollerance, c1, rho, max_backtrack, do_pcg_precond)
%TRUNCATEDNM - Find a minima of a function f - Truncated Newton Method
%
%   Syntax
%       [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
%           x_sequence, backtrack_sequence, pcg_sequence] =
%       truncatedNM(f, grad_f, hess_f, x_initial, max_iteration, ...
%           tollerance, c1, rho, max_backtrack, do_pcg_precond)
%   
%   Input:
%       f - Describe the function to minimaze
%           function handle
%       grad_f - Compute the gradient of f
%           function handle
%       hess_f - Compute the hessian of f
%           function handle
%       x_initial - Starting point for TNM
%           column vector
%       max_iteration - Maximum number iterations that TNM can perform
%           positive scalar integer
%       tollerance - Tollerance for stopping criteria (absolute residual)
%           positive scalar
%       c1 - Parameter for Armijo condition
%           positive scalar
%       rho - Parameter for Armijo condition
%           positive scalar
%       max_backtrack Maximum iterations for backtracking
%           positive scalar integer
%       do_pcg_precond - Indicates if apply preconditioning to Hessian;
%           boolean
%
%   Output:
%       x_found - Solution found by TNM
%           column vector;       
%       f_x - Function value at x_found
%           positive scalar
%       norm_grad_f_x - Norm of the gradient (if failure == false, should be 0)
%           positive scalar
%       iteration - Number of iteration performed
%           positive scalar integer
%       failure - Indicates if a failure happend
%           boolean
%       flag - TNM output description
%           string
%       x_sequence - Value of x computed at each iteration
%           matrix
%       backtrack_sequence - Number of iteration for backtrack at each outer iteration
%           row vector
%       pcg_sequence - pcg performance at each iteration (iteration, flag, preconditioning type)
%           matrix

%% -- Initialization --
% Starting point
x_k = x_initial;
f_xk = f(x_k);
grad_f_xk = grad_f(x_k);
norm_grad_f_xk = norm(grad_f_xk);

% x_k, pcg and backtracking sequences
x_sequence = zeros(length(x_initial), max_iteration);
pcg_sequence = zeros(3, max_iteration); % [iteration + flag + precond] saved at each iteration
backtrack_sequence = zeros(max_iteration);

% PCG fixed parameters
precond = []; % default value
pcg_tol = 1e-6;
pcg_maxit = 50;

% Iteration variables
i = 0;
failure = false;

%% -- Loop --
while i < max_iteration && ...          % iteration
        norm_grad_f_xk >= tollerance    % stopping condition
    
    %% -- Computing descent direction --
    % Compute the preconditioning matrix for pcg
    A = hess_f(x_k);
    precond_type = -1; % no preconditioning
    if do_pcg_precond
        try
            % ichol is more stable and usually a better option
            precond = ichol(sparse(A));
            precond_type = 1; % ichol
        catch ME
            % A is not SPD matrix, using ilu preconditioning
            precond = ilu(sparse(A));
            precond_type = 2; % ilu
        end
    end

    % Using -grad_f(xk) as starting point will guarantee that pcg will
    % return a descent direction, even if matrix A is not SPD
    [desc_dir, pcg_flag, res, pcg_iter, ~] = ...
        pcg(A, -grad_f_xk, pcg_tol, pcg_maxit, precond, precond', -grad_f_xk);
    
    % Check for pcg failure
    if pcg_flag == 1
        failure = 1;
        flag = sprintf("Failure: pcg did %d iteration but did not converge." + ...
            " resrel = %.3g", pcg_iter, res);
        break
    end

    %% -- Backtracking --
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
        flag = 'Failure: Could not satisfy Armijo';
        break
    end

    %% -- Update --
    x_k = x_new;
    f_xk = f_new;
    grad_f_xk = grad_f(x_k);
    norm_grad_f_xk = norm(grad_f_xk);

    i = i + 1;

    x_sequence(:, i) = x_k;
    backtrack_sequence(i) = b;
    pcg_sequence(:, i) = [pcg_iter; pcg_flag; precond_type];
end

%% -- Save result --
% Final solution
x_found = x_k;
f_x = f_xk;
norm_grad_f_x = norm_grad_f_xk;
iteration = i;

% Resize sequence variables
x_sequence = [x_initial, x_sequence(:, 1:iteration)];
backtrack_sequence = backtrack_sequence(1:iteration);
pcg_sequence = pcg_sequence(:, 1:iteration);

% Flag output
if ~failure
    if norm_grad_f_x < tollerance
        flag = sprintf('Satysfied the tollerance in %d iteration', iteration);
    else
        flag = sprintf(['Failure: tnm did %d iteration but did not converge. ' ...
            'Norm of the gradient = %.3g'], iteration, norm_grad_f_x);
        failure = true;
    end
end

end