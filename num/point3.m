%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Add path to functions
addpath('test_problems_for_unconstrained_optimization\');

% Set the random seed to the minimum student ID
student_ids = [318684, 337728, 338137];
rng(min(student_ids)); % Set the random seed

% Parameters
rho = 0.5;        % Backtracking reduction factor
c1 = 1e-4;        % Armijo condition parameter
tolgrad = 1e-6;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 1000;      % Maximum iterations

% Dimensions to study
dims = [1e3, 1e4, 1e5];

%% Define Rosenbrock Function, Gradient, and Hessian
% Function
f = @(x) rosenbrock(x);

% Gradient
gradf = @(x) rosenbrock_grad(x);

% Hessian
Hessf = @(x) rosenbrock_hess(x);

%% Study the problem for specified dimensions
for n = dims
    fprintf('Analyzing dimension n = %d\n', n);
    
    % TODO: Recomended starting point
    
    % TODO Generate 10 random starting points

    % Analyze each starting point
    for i = 1:n % TODO for each starting point
        
        % TODO pick x0

        % Run Modified Newton's Method
        [xk, fk, gradfk_norm, k, xseq, btseq] = ...
            modifiedNM(x0, f, gradf, Hessf, ...
            toleig, kmax, tolgrad, c1, rho, btmax);

        % Log results
        fprintf('Final Point: [%f, %f]\n', xk1(1), xk1(2));
        fprintf('Function Value: %e\n', fk1);
        fprintf('Gradient Norm: %e\n', gradfk_norm1);
        fprintf('Iterations: %d\n', k1);
        fprintf('\n');

        % Store results (e.g., in a structure for later analysis)
        results(i).n = n;
        results(i).starting_point = x0;
        results(i).x_final = xk;
        results(i).f_final = fk;
        results(i).iterations = k;
        results(i).backtracking = btseq;
    end
end

fprintf('Analysis Complete.\n');
