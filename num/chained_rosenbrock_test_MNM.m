%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Add path to functions
addpath('test_problems_for_unconstrained_optimization\'); 

% Parameters
rho = 0.7;        % Backtracking reduction factor
c1 = 1e-2;        % Armijo condition parameter
tolgrad = 1e-12;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 5000;      % Maximum iterations

% Problem size
n = 1e3; % 4, 5

% Starting points
x_bar = [-1.2; 1];
x0 = repmat(x_bar, n / size(x_bar, 1), 1);

%% Define Rosenbrock Function, Gradient, and Hessian
% Function
f = @(x) chained_rosenbrock(x);

% Gradient
gradf = @(x) chained_rosenbrock_grad(x);

% Hessian
Hessf = @(x) chained_rosenbrock_hess(x);

%% Test the Modified Newton's Method - Starting Point x_bar
fprintf('Test Modified Newton Method on Chained Rosenbrock, n = %d\n', n);

[xk1, fk1, gradfk_norm1, k1, xseq1, btseq1] = ...
    modifiedNM(x0, f, gradf, Hessf, ...
    kmax, tolgrad, c1, rho, btmax, 'spectral', toleig);

% Display results
fprintf('Final Point: [');
fprintf('%f ', xk1(1:end-1));  % Print all elements except the last one
fprintf('%f]\n', xk1(end));     % Print the last element and close the bracket
fprintf('Function Value: %e\n', fk1);
fprintf('Gradient Norm: %e\n', gradfk_norm1);
fprintf('Iterations: %d\n', k1);
fprintf('\n');

%% End
fprintf('Test Completed!\n');
