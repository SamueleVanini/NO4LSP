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
load('Ext_Rosenbrock.mat');

% Outer loop
max_iterations = 5000;
tollerance = 1e-4;

% Backtracking
max_back_iterations = 50;
c1 = 1e-4;
rho = .5;

% PCG preconditioning
do_precondintioning = false;

% Hessian approximation
h_approximation = 1e-12;
specific_approx = false;

hess_approx = false;
if hess_approx
    hess_f = [];
end

%  *** Correction tuning ***
% Problem 82:
% - 'minima': 1e-2<, 1e-1, 1 with success runs 0, 3, 33 (converges to 0).
% - 'diag':   1e-8
%
% Extended Rosenbrock:
% - 'minima': 1e-4<, 350, 400 with success runs 3, 8, 23 (converges to 0).
% - 'diag':   1e-8
% - NOTES:
%   - At 350, 3 standard + 5 points from n=1e3 converge.
%   - At 375, everything works for n=1e3, but only for some n=1e4. Unknown for n=1e5 (too long).
%   - Long runtime for some points (x_6, x_7, x_9, x_10, x_11) at 375.
%
% Extended Powell:
% - 'minima': 1e-8< with success runs 3 (converges to 0).
% - 'diag':   1e-8

correction_method = 'minima'; % Use one among 'minima', 'diag'
correction_parameters = 1e-8;

fprintf("*** USING CORRECTION METHOD: %s WITH TOLLERANCE %.1e *** \n\n", correction_method, correction_parameters);

%% Choose points to analyze and plots to display

% Set which point you want to analyze
% 
%       1 --> Default starting point (improved convergence)
% [2, 11] --> correspondent to the 10 points randomly generated
% 
% Multiple points can be run, just by setting variable 
% 'point' as a list that ranges between integers
%   e.g. 1:4    will run the default point + first 3 randomly generated
%        2:4    will run all point (defualt + the 10 randomly generated)l run first 3 randomly generated
%        1:11   wil
point = 1:2;

% Stats
tot_success = 3*length(point);

% Plots to display
plot_rate_convergence       = false;
plot_matrix_corrections     = true;
plot_function_convergence   = false;
plot_gradient_convergence   = false;

%% Dimension 1000 (1e3)

for i = point
    x_0 = x_1000(:, i);

    fprintf("PROBLEM DIMENSION: %.1e\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, corr_sequence, fseq, gradnormseq] = ...
    modifiedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx, correction_method, correction_parameters);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Plot order of convergence, corrections, function value, and gradient convergence
    if iteration > 1
        if plot_rate_convergence == true
            rate_convergence(iteration, min_1000, x_sequence, i);
        end
        if plot_matrix_corrections == true
            matrix_corrections(corr_sequence, length(x_0));
        end
        if plot_function_convergence == true
            function_convergence(fseq, length(x_0));
        end
        if plot_gradient_convergence == true
            gradient_convergence(gradnormseq, length(x_0));
        end
    end

    % Stats
    tot_success = tot_success - failure;

    fprintf("\n\n");
end

%% Dimension 10000 (1e4)

for i = point
    x_0 = x_10000(:, i);

    fprintf("PROBLEM DIMENSION: %.1e\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, corr_sequence, fseq, gradnormseq] = ...
    modifiedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx, correction_method, correction_parameters);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Plot order of convergence, corrections, function value, and gradient convergence
    if iteration > 1
        if plot_rate_convergence == true
            rate_convergence(iteration, min_10000, x_sequence, i);
        end
        if plot_matrix_corrections == true
            matrix_corrections(corr_sequence, length(x_0));
        end
        if plot_function_convergence == true
            function_convergence(fseq, length(x_0));
        end
        if plot_gradient_convergence == true
            gradient_convergence(gradnormseq, length(x_0));
        end
    end

    % Stats
    tot_success = tot_success - failure;

    fprintf("\n\n");
end

%% Dimension 100000 (1e5)

for i = point
    x_0 = x_100000(:, i);

    fprintf("PROBLEM DIMENSION: %.1e\n", length(x_0));
    fprintf("x_%d = ", i-1); print_summary(x_0);
    
    tic;
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_sequence, backtrack_sequence, corr_sequence, fseq, gradnormseq] = ...
    modifiedNM(f, grad_f, hess_f, x_0, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx, correction_method, correction_parameters);
    execution_time = toc;
    
    % Output
    print_output(flag, x_found, f_x, norm_grad_f_x, iteration, ...
        max_iterations, execution_time);

    % Plot order of convergence, corrections, function value, and gradient convergence
    if iteration > 1
        if plot_rate_convergence == true
            rate_convergence(iteration, min_100000, x_sequence, i);
        end
        if plot_matrix_corrections == true
            matrix_corrections(corr_sequence, length(x_0));
        end
        if plot_function_convergence == true
            function_convergence(fseq, length(x_0));
        end
        if plot_gradient_convergence == true
            gradient_convergence(gradnormseq, length(x_0));
        end
    end

    % Stats
    tot_success = tot_success - failure;

    fprintf("\n\n");
end

%% Print count of successful runs

fprintf("Successful run: %d/%d\n", tot_success, 3*length(point));

%% Plotting and Analysis Functions

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
    % Compute errors
    error = vecnorm(sequence - actual_minimum);

    % Initialize convergence metrics
    sup_linear = zeros(1, iterations);
    quadratic = zeros(1, iterations);

    % Calculate rates
    for err = 1:iterations
        sup_linear(err) = error(err + 1)/error(err);
        quadratic(err) = error(err + 1)/(error(err)^2);
    end

    % Create tiled layout and plots
    figure('Name', ['x_', num2str(i), ' (Dim = ', ...
        num2str(length(actual_minimum)), '): Order of convergence'], ...
        'NumberTitle', 'off');
    t = tiledlayout(1, 2); % Define tiled layout

    % Plot Linear/Superlinear Convergence
    ax1 = nexttile;
    plot(1:iterations, sup_linear, '-r');
    title(ax1, 'Linear/Superlinear Convergence'); % Assign title to the correct axis
    xlabel(ax1, 'Iteration');
    ylabel(ax1, 'Rate');

    % Plot Quadratic Convergence
    ax2 = nexttile;
    plot(1:iterations, quadratic, '-r');
    title(ax2, 'Quadratic Convergence'); % Assign title to the correct axis
    xlabel(ax2, 'Iteration');
    ylabel(ax2, 'Rate');

    % Add a global title for the tiled layout
    sgtitle(t, ['Convergence Analysis: x_', num2str(i)]);
end


function matrix_corrections(correction_sequence, prob_size)
    figure('Name', sprintf('Matrix Corrections Applied, n = %1.e', prob_size), 'NumberTitle', 'off');
    if length(find(correction_sequence ~= 0)) >= 100
        scatter(find(correction_sequence ~= 0), correction_sequence(correction_sequence ~= 0), 'filled', 'LineWidth', 1.5);
    else
        stem(find(correction_sequence ~= 0), correction_sequence(correction_sequence ~= 0), 'filled', 'LineWidth', 1.5);
    end
    xlabel('Iteration');
    ylabel('Correction Value');
    title(sprintf('Matrix Corrections Applied, n = %1.e', prob_size));
    grid on;
end

function function_convergence(function_values, prob_size)
    figure('Name', sprintf('Function Value Convergence, n = %1.e', prob_size), 'NumberTitle', 'off');
    semilogy(1:length(function_values), function_values, 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Function Value');
    title(sprintf('Function Value Convergence, n = %1.e', prob_size));
    grid on;
end

function gradient_convergence(gradient_norms, prob_size)
    figure('Name', sprintf('Gradient Norm Convergence, n = %1.e', prob_size), 'NumberTitle', 'off');
    semilogy(1:length(gradient_norms), gradient_norms, 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Gradient Norm (log scale)');
    title(sprintf('Gradient Norm Convergence, n = %1.e', prob_size));
    grid on;
end