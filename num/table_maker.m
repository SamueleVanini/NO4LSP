close all;
clear;
clc;

warning('off', 'all');

addpath('test_problems_for_unconstrained_optimization\');
addpath("starting_points\");

% Function
func_name = 'Problem_82';

func_file = sprintf("%s.mat", func_name);
load(func_file);

% Outer loop
max_iterations = 1000;
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

point = 1:11;
caption = 'ciaone';
label = 'salvino';

disp("\begin{table}");
disp("\centering");
disp("\resizebox{\linewidth}{!}{");
disp("\begin{tabular}{|l|l|l|l|l|l|l|l|l|l|l|l|l|} \cline{2-13}");
disp("\multicolumn{1}{l|}{} & \multicolumn{3}{l|}{Function Value} & \multicolumn{3}{l|}{Norm of Gradient} & \multicolumn{3}{l|}{Iterations} & \multicolumn{3}{l|}{Execution Time (seconds)} \\ \cline{2-13}");
disp("\multicolumn{1}{l|}{} & $10^3$ & $10^4$ & $10^5$ & $10^3$ & $10^4$ & $10^5$ & $10^3$ & $10^4$ & $10^5$ & $10^3$ & $10^4$ & $10^5$ \\ \hline");

for i = point
    x_3 = x_1000(:, i);
    x_4 = x_10000(:, i);
    x_5 = x_100000(:, i);

    fprintf("$x_{%d}$ ", i-1);

    tic;
    [x_found_3, f_3, ng_3, k_3, fail_3, flag_3, ...
        x_sequence_3, backtrack_sequence_3, pcg_sequence_3] = ...
    truncatedNM(f, grad_f, hess_f, x_3, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    et_3 = toc;

    tic;
    [x_found_4, f_4, ng_4, k_4, fail_4, flag_4, ...
        x_sequence_4, backtrack_sequence_4, pcg_sequence_4] = ...
    truncatedNM(f, grad_f, hess_f, x_4, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    et_4 = toc;

    tic;
    [x_found_5, f_5, ng_5, k_5, fail_5, flag_5, ...
        x_sequence_5, backtrack_sequence_5, pcg_sequence_5] = ...
    truncatedNM(f, grad_f, hess_f, x_5, max_iterations, ...
        tollerance, c1, rho, max_back_iterations, do_precondintioning, ...
        h_approximation, specific_approx, hess_approx);
    et_5 = toc;

    fprintf("& %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & %d & %d & %d & %.3g & %.3g & %.3g \\\\", ...
        f_3, f_4, f_5, ng_3, ng_4, ng_5, k_3, k_4, k_5, et_3, et_4, et_5);
    fprintf("\\hline\n");
end

fprintf("\\end{tabular}\n}\n\\caption{%s}\n\\label{table: %s}\n\\end{table}\n", caption, label);