clear;
clc;
close all;

%% Add folders
addpath('test_problems_for_unconstrained_optimization\');
addpath("starting_points\");

%% Variables Initialization
% Function + starting points
load('Ext_Powell.mat');

% Outer loop
max_iterations = 2000;
tollerance = 1e-5;

% Backtracking
max_back_iterations = 50;
c1 = 1e-3;
rho = .6;

% PCG preconditioning
do_precondintioning = false;

% Hessian approximation
h_approximation = 1e-12;
specific_approx = false;

%% Choose points to analyze
point = 1;

% Stats
tot_success = 3*length(point);

%% Apply methods
%% Dimension 1000
for i = point
    x_0 = x_1000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, pcg_sequence] = ...
    truncatedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Order of convergence
    if iteration > 1
        rate_convergence(iteration, min_1000, x_sequence, i);
    end

    % Stats
    tot_success = tot_success - failure;

    % Pausing
    % pause;
    % close all;
    fprintf("\n\n");
end

%% Dimension 10000
for i = point
    x_0 = x_10000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, pcg_sequence] = ...
    truncatedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Order of convergence
    if iteration > 1
        rate_convergence(iteration, min_10000, x_sequence, i);
    end

    % Stats
    tot_success = tot_success - failure;

    % Pausing
    % pause;
    % close all;
    fprintf("\n\n");
end

%% Dimension 100000
for i = point
    x_0 = x_100000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, pcg_sequence] = ...
    truncatedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Order of convergence
    if iteration > 1
        rate_convergence(iteration, min_100000, x_sequence, i);
    end

    % Stats
    tot_success = tot_success - failure;

    % Pausing
    % pause;
    % close all;
    fprintf("\n\n");
end

fprintf("Successful run: %d/%d\n", tot_success, 3*length(point));

function print_output(flag, sol, f_x, norm_grad, iters, max_iters, time)
    fprintf("FLAG: %s\n", flag);
    fprintf("SOLUTION FOUND = "); print_summary(sol);
    fprintf("FUNCTION VALUE = %.3g\n" ,f_x);
    fprintf("NORM OF THE GRADIENT = %.3g\n", norm_grad);
    fprintf("ITERATIONS PERFORMED: %d/%d\n", iters, max_iters);
    fprintf("EXECUTION TIME: %f s\n", time);
end

function rate_convergence(iterations, actual_minimum, sequence, i)
    error = vecnorm(sequence - actual_minimum);

    sup_linear = zeros(1, iterations);
    quadratic = zeros(1, iterations);

    for err = 1:iterations
        sup_linear(err) = error(err + 1)/error(err);
        quadratic(err) = error(err + 1)/(error(err)^2);
    end

    % Ratio Plots
    figure('Name', ['x_', num2str(i), ' (Dim = ', ...
        num2str(length(actual_minimum)), '): Order of convergence'], ...
        'NumberTitle','off');
    tiledlayout(1, 2);

    nexttile
    title('Linear/Superlinear convergence');
    plot(1:iterations, sup_linear, '-r', ...
        1:iterations, zeros(1, iterations), '.-b');

    nexttile
    title('Quadratic convergence');
    plot(1:iterations, quadratic, '-r');
end

function print_summary(vector)
    fprintf("[");
    fprintf(" %.3f ", vector(1:4));
    fprintf("...");
    fprintf(" %.3f ", vector(end-3:end));
    fprintf("]\n");
end