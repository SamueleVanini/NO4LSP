%% Initialization
% Clear the workspace and command window
clc; clear; close all;

% Parameters
rho = 0.5;        % Backtracking reduction factor
c1 = 1e-4;        % Armijo condition parameter
tolgrad = 1e-6;   % Gradient tolerance for stopping
toleig = 1e-6;    % Tolerance for eigenvalue check
btmax = 50;       % Maximum backtracking steps
kmax = 1000;      % Maximum iterations

% Starting points
x0_1 = [1.2; 1.2];
x0_2 = [-1.2; 1];

%% Define Rosenbrock Function, Gradient, and Hessian

% Add path to functions
addpath('test_problems_for_unconstrained_optimization\'); 

% Function
f = @(x) rosenbrock(x);

% Gradient
gradf = @(x) rosenbrock_grad(x);

% Hessian
Hessf = @(x) rosenbrock_hess(x);

%% Test the Modified Newton's Method - Starting Point 1
fprintf('Test with starting point x0 = [%f, %f]\n', x0_1);

[xk1, fk1, gradfk_norm1, k1, xseq1, btseq1] = ...
    modifiedNM(x0_1, f, gradf, Hessf, ...
    kmax, tolgrad, c1, rho, btmax, 'spectral', toleig);

%% Display results
fprintf('Final Point: [%f, %f]\n', xk1(1), xk1(2));
fprintf('Function Value: %e\n', fk1);
fprintf('Gradient Norm: %e\n', gradfk_norm1);
fprintf('Iterations: %d\n', k1);
fprintf('\n');

%% Test the Modified Newton's Method - Starting Point 2
fprintf('Test with starting point x0 = [%f, %f]\n', x0_2);

[xk2, fk2, gradfk_norm2, k2, xseq2, btseq2] = ...
    modifiedNM(x0_2, f, gradf, Hessf, ...
    kmax, tolgrad, c1, rho, btmax, 'eye', toleig);

% Display results
fprintf('Final Point: [%f, %f]\n', xk2(1), xk2(2));
fprintf('Function Value: %e\n', fk2);
fprintf('Gradient Norm: %e\n', gradfk_norm2);
fprintf('Iterations: %d\n', k2);
fprintf('\n');

%% Surface Plot and Contour Lines
figure;

% Generate grid for plotting
x1_vals = -2:0.1:2;
x2_vals = -1:0.1:3;
[X1, X2] = meshgrid(x1_vals, x2_vals);
F_vals = arrayfun(@(x1, x2) f([x1; x2]), X1, X2);

% Surface plot
subplot(1, 2, 1);
surf(X1, X2, F_vals, 'EdgeColor', 'none');
hold on;
plot3(xseq1(1, :), xseq1(2, :), arrayfun(@(i) f(xseq1(:, i)), 1:size(xseq1, 2)), ...
      '-rx', 'LineWidth', 2);
plot3(xseq2(1, :), xseq2(2, :), arrayfun(@(i) f(xseq2(:, i)), 1:size(xseq2, 2)), ...
      '-bx', 'LineWidth', 2);
title('Surface Plot with Iterates');
xlabel('x_1'); ylabel('x_2'); zlabel('f(x)');
legend({'Function surface', 'Starting Point 1', 'Starting Point 2'}, 'Location', 'NorthEast');
grid on; view(45, 30);

% Contour plot
subplot(1, 2, 2);
contour(X1, X2, F_vals, 20, 'LineWidth', 1.5);
hold on;
plot(xseq1(1, :), xseq1(2, :), '-rx', 'LineWidth', 2);
plot(xseq2(1, :), xseq2(2, :), '-bx', 'LineWidth', 2);
title('Contour Plot with Iterates');
xlabel('x_1'); ylabel('x_2');
legend({'Function contour lines', 'Starting Point 1', 'Starting Point 2'}, 'Location', 'NorthEast');
grid on;

%% Bar Plot for Backtracking Steps
figure;

% Define the number of iterations
iterations1 = 1:length(btseq1);
iterations2 = 1:length(btseq2);

% Create a grouped bar plot
bar_data = zeros(2, max(length(btseq1), length(btseq2))); % Preallocate
bar_data(1, 1:length(btseq1)) = btseq1; % First group
bar_data(2, 1:length(btseq2)) = btseq2; % Second group

bar(bar_data', 'grouped'); % Transpose for grouped display

% Add labels and title
title('Backtracking Steps per Iteration');
xlabel('Iteration');
ylabel('Number of Backtracking Loops');
legend({'Starting Point 1', 'Starting Point 2'}, 'Location', 'NorthEast');
grid on;

%% Plot the Iterates
figure;

% Plot for starting point 1
subplot(1, 2, 1);
plot(xseq1(1, :), xseq1(2, :), '--x', 'LineWidth', 1.5);
title('Modified Newton - Start [1.2, 1.2]');
xlabel('x_1'); ylabel('x_2');
grid on;

% Plot for starting point 2
subplot(1, 2, 2);
plot(xseq2(1, :), xseq2(2, :), '--x', 'LineWidth', 1.5);
title('Modified Newton - Start [-1.2, 1]');
xlabel('x_1'); ylabel('x_2');
grid on;

%% End
fprintf('Test Completed!\n');
