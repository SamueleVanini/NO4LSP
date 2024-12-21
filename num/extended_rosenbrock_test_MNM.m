%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Add path to functions
addpath('test_problems_for_unconstrained_optimization\'); 

% Parameters
rho = 0.7;        % Backtracking reduction factor
c1 = 1e-2;        % Armijo condition parameter
tolgrad = 1e-6;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 5000;      % Maximum iterations

% Problem size
n = 1e3; % 4, 5

% Starting point
x_bar = [-1.2; 1];
x0 = repmat(x_bar, n / size(x_bar, 1), 1);

%% Define Rosenbrock Function, Gradient, and Hessian
% Function
f = @(x) extended_rosenbrock(x);

% Gradient
gradf = @(x) extended_rosenbrock_grad(x);

% Hessian
Hessf = @(x) extended_rosenbrock_hess(x);

%% Test the Modified Newton's Method - Starting Point x_bar
fprintf('Test Modified Newton Method on Extended Rosenbrock, n = %d\n', n);

[xk1, fk1, gradfk_norm1, k1, xseq1, btseq1] = ...
    modifiedNM(x0, f, gradf, Hessf, ...
    kmax, tolgrad, c1, rho, btmax, 'spectral', toleig);

%% Display results
fprintf('Final Point: [');
fprintf('%f ', xk1(1:end-1));  % Print all elements except the last one
fprintf('%f]\n', xk1(end));     % Print the last element and close the bracket
fprintf('Function Value: %e\n', fk1);
fprintf('Gradient Norm: %e\n', gradfk_norm1);
fprintf('Iterations: %d\n', k1);
fprintf('\n');

%% Prepare data for plotting
f_vals = arrayfun(@(i) f(xseq1(:, i)), 1:size(xseq1, 2));  % Function values at each step
grad_norms = arrayfun(@(i) norm(gradf(xseq1(:, i))), 1:size(xseq1, 2));  % Gradient norms
eigenvals = arrayfun(@(i) eigs(Hessf(xseq1(:, i)), 1, 'smallestreal'), 1:size(xseq1, 2));  % Smallest eigenvalues of Hessians

%% Graphical Displays
% 1. Plot function value convergence
figure;
semilogy(1:k1+1, f_vals, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Function Value (log scale)');
title('Convergence of Function Value');
grid on;

% 2. Plot gradient norm convergence
figure;
semilogy(1:k1+1, grad_norms, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Gradient Norm (log scale)');
title('Convergence of Gradient Norm');
grid on;

% 3. Plot eigenvalues of Hessian at key iterations
figure;
semilogy(1:k1+1, eigenvals, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Eigenvalue');
title('Single Eigenvalue of Hessian Across Iterations');
grid on;

% 4. Trajectory projection (if n > 3, project onto the first 3 components)
if n > 3
    traj = xseq1(1:3, :);  % First 3 components
    figure;
    plot3(traj(1, :), traj(2, :), traj(3, :), '-o');
    xlabel('x_1');
    ylabel('x_2');
    zlabel('x_3');
    title('Projected Trajectory (First 3 Components)');
    grid on;
else
    % 2D projection
    traj = xseq1(1:2, :);  % First 2 components
    figure;
    plot(traj(1, :), traj(2, :), '-o');
    xlabel('x_1');
    ylabel('x_2');
    title('Trajectory (2D)');
    grid on;
end

%% End
fprintf('Test Completed!\n');
