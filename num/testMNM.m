%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Add path to functions (if necessary)
% addpath('functions_directory'); 

% Parameters
rho = 0.5;        % Backtracking reduction factor
c1 = 1e-4;        % Armijo condition parameter
tolgrad = 1e-6;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 1000;      % Maximum iterations

% Starting points
x0_1 = [-1.2; -1.2];
x0_2 = [-1.2; 1];

%% Define Rosenbrock Function, Gradient, and Hessian
% Function
f = @(x) rosenbrock(x);

% Gradient
gradf = @(x) rosenbrock_grad(x);

% Hessian
Hessf = @(x) rosenbrock_hess(x);

%% Test the Modified Newton's Method - Starting Point 1
fprintf('Test with starting point x0 = %f\n', x0_1);

[xk1, fk1, gradfk_norm1, k1, xseq1, btseq1] = ...
    modifiedNM(x0_1, f, gradf, Hessf, ...
    toleig, kmax, tolgrad, c1, rho, btmax);

% Display results
fprintf('Final Point: [%f, %f]\n', xk1(1), xk1(2));
fprintf('Function Value: %e\n', fk1);
fprintf('Gradient Norm: %e\n', gradfk_norm1);
fprintf('Iterations: %d\n', k1);

%% Test the Modified Newton's Method - Starting Point 2
fprintf('Test with starting point x0 = %f\n', x0_2);

[xk2, fk2, gradfk_norm2, k2, xseq2, btseq2] = ...
    modifiedNM(x0_2, f, gradf, Hessf, ...
    toleig, kmax, tolgrad, c1, rho, btmax);

% Display results
fprintf('Final Point: [%f, %f]\n', xk2(1), xk2(2));
fprintf('Function Value: %e\n', fk2);
fprintf('Gradient Norm: %e\n', gradfk_norm2);
fprintf('Iterations: %d\n', k2);

%% Plot the Iterates
% Combine the two sequences for plotting
figure;

% Plot for starting point 1
subplot(1, 2, 1);
plot(xseq1(1, :), xseq1(2, :), '--x', 'LineWidth', 1.5);
title('Modified Newton - Start [-1.2, -1.2]');
xlabel('x_1'); ylabel('x_2');
grid on;

% Plot for starting point 2
subplot(1, 2, 2);
plot(xseq2(1, :), xseq2(2, :), '--x', 'LineWidth', 1.5);
title('Modified Newton - Start [-1.2, 1]');
xlabel('x_1'); ylabel('x_2');
grid on;

%% End
fprintf('\nTest Completed!\n');
