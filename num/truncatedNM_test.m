clear
clc
close all

%% Set Function
addpath("test_problems_for_unconstrained_optimization\");
addpath("finite_differences\");

% f = @extended_powell;
% gradF = @extended_powell_grad;
% hessF = @extended_powell_hess;

% f = @extended_rosenbrock;
% gradF = @extended_rosenbrock_grad;
% hessF = @extended_rosenbrock_hess;

f = @problem_82;
gradF = @problem_82_grad;
% hessF = @problem_82_hess;

hessF = [];

%% Variables Initialization
% TNM
x_init = [.5; .5];    % change here
max_iter = 1000;
tollerance = 1e-8;

% backtracking
c1 = 1e-4;
rho = .5;
max_backtrack = 100;

% preconditioning
do_precon = false;

% hessian approximation
h = 1e-12;
specific = true;

%% Apply TNM
[x_found, f_x, norm_grad_f_x, iteration, failure, flag, x_seq, ...
    backtrack_seq, pcg_seq] = ...
truncatedNM(f, gradF, hessF, x_init, max_iter, tollerance, c1, ...
    rho, max_backtrack, do_precon, h, specific);

%% Save results
file_name = "x0_prob82_approx-12_specific.mat";  % change here

complete_name = sprintf("test_results/%s", file_name);
save(complete_name, "x_init", "x_found", "f_x", "norm_grad_f_x", ...
    "iteration", "failure", "flag", "x_seq", "backtrack_seq", ...
    "pcg_seq", "max_iter", "do_precon")