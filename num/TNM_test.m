close all; clear; clc;

%% Add folders

addpath('test_problems_for_unconstrained_optimization\');
addpath("starting_points\");

%% Variables Initialization and tuning

% *** Function + starting points ***
% Choose among:
%   'Problem_82.mat'
%   'Ext_Rosenbrock.mat'
%   'Ext_Powell.mat'
% % %
load('Problem_82.mat');

% Outer loop
max_iterations = 5000;
tollerance = 1e-6;

% Backtracking
max_back_iterations = 50;
c1 = 1e-4;
rho = .5;

% PCG preconditioning
do_precondintioning = false;    

% Hessian approximation
h_approximation = 1e-12;
specific_approx = false;

do_hess_approx = false;
if do_hess_approx
    hess_f = [];
end

%% Choose points to analyze and plots to display

% Set which point you want to analyze
%
%       1 --> Default starting point (improved convergence)
% [2, 11] --> correspondent to the 10 points randomly generated
%
% Multiple points can be run, just by setting variable
%  'point' as a list that ranges between integers
%   e.g. 1:4 will run the default point + first 3 randomly generated
%       2:4 will run first 3 randomly generated
%       1:11 will run all point (defualt + the 10 randomly generated)
point = 1:4;

% Stats
tot_success = 3*length(point);

% Plots to display
plot_rate_convergence = false;

%% Dimension 1000
for i = point
    x_0 = x_1000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
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
        if plot_rate_convergence
            rate_convergence(iteration, min_1000, x_sequence, i);
        end
    end

    % Stats
    tot_success = tot_success - failure;

    fprintf("\n\n");
end

%% Dimension 10000
for i = point
    x_0 = x_10000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
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
        if plot_rate_convergence
            rate_convergence(iteration, min_10000, x_sequence, i);
        end
    end

    % Stats
    tot_success = tot_success - failure;

    fprintf("\n\n");
end

%% Dimension 100000
for i = point
    x_0 = x_100000(:, i);

    fprintf("PROBLEM DIMENSION: %d\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
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
        if plot_rate_convergence
            rate_convergence(iteration, min_100000, x_sequence, i);
        end
    end

    % Stats
    tot_success = tot_success - failure;

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

function print_summary(vector)
    fprintf("[");
    fprintf(" %.3f ", vector(1:4));
    fprintf("...");
    fprintf(" %.3f ", vector(end-3:end));
    fprintf("]\n");
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