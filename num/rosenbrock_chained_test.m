%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Add path to functions
addpath('test_problems_for_unconstrained_optimization\'); 

% Parameters
rho = 0.5;        % Backtracking reduction factor
c1 = 1e-4;        % Armijo condition parameter
tolgrad = 1e-6;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 1000;      % Maximum iterations

% Problem size 
n = 1e3; % 4, 5
pattern = [-1.2, 1];
n = n / size(pattern, 2);

% Starting points
x_bar = repmat(pattern, 1, n);

%% Define Rosenbrock Function, Gradient, and Hessian
% Function
f = @(x) chained_rosenbrock(x);

% Gradient
gradf = @(x) chained_rosenbrock_grad(x);

% Hessian
Hessf = @(x) chained_rosenbrock_hess(x);

%% Test the Modified Newton's Method - Starting Point x_bar
fprintf('Test Modified with starting point x_bar\n');

[xk1, fk1, gradfk_norm1, k1, xseq1, btseq1] = ...
    modifiedNM(x_bar, f, gradf, Hessf, ...
    toleig, kmax, tolgrad, c1, rho, btmax);

% Display results
fprintf('Function Value: %e\n', fk1);
fprintf('Gradient Norm: %e\n', gradfk_norm1);
fprintf('Iterations: %d\n', k1);
fprintf('\n');

%% End
fprintf('Test Completed!\n');
