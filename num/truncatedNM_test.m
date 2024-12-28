clear
clc
close all

%% Set Function
addpath("test_problems_for_unconstrained_optimization\");
% f = @extended_powell_badly_scaled;
% gradF = @extended_powell_badly_scaled_grad;
% hessF = @extended_powell_badly_scaled_hess;

% f = @extended_rosenbrock;
% gradF = @extended_rosenbrock_grad;
% hessF = @extended_rosenbrock_hess;

f = @problem_82;
gradF = @problem_82_grad;
hessF = @problem_82_hess;

%% Variables Initialization
% TNM
x_init = [0.5; 0.5];    % change here
max_iter = 1000;
tollerance = 1e-8;

% backtracking
c1 = 1e-4;
rho = .7;
max_backtrack = 100;

% preconditioning
do_precon = false;

%% Apply TNM
[x_found, f_x, norm_grad_f_x, iteration, failure, flag, x_seq, ...
    backtrack_seq, pcg_seq] = ...
    truncatedNM(f, gradF, hessF, x_init, max_iter, tollerance, c1, ...
    rho, max_backtrack, do_precon);

%% Save results
file_name = "x0_prob82.mat";  % change here

complete_name = sprintf("test_results/%s", file_name);
save(complete_name, "x_init", "x_found", "f_x", "norm_grad_f_x", ...
    "iteration", "failure", "flag", "x_seq", "backtrack_seq", ...
    "pcg_seq", "max_iter", "do_precon")