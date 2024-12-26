clear
clc
close all

%% Set Function
addpath("test_problems_for_unconstrained_optimization\");
f = @chained_rosenbrock;
gradF = @chained_rosenbrock_grad;
hessF = @chained_rosenbrock_hess;

% f = @extended_powell_badly_scaled;
% gradF = @extended_powell_badly_scaled_grad;
% hessF = @extended_powell_badly_scaled_hess;

% f = @extended_rosenbrock;
% gradF = @extended_rosenbrock_grad;
% hessF = @extended_rosenbrock_hess;

%% Variables Initialization
% TNM
x_init = [-1.2; 1];    % change here
max_iter = 1000;
tollerance = 1e-8;

% backtracking
c1 = 1e-3;
rho = .6;
max_backtrack = 50;

% preconditioning
do_precon = false;

%% Apply TNM
[x_found, f_x, norm_grad_f_x, iteration, failure, flag, x_seq, ...
    backtrack_seq, pcg_seq] = ...
    truncatedNM(f, gradF, hessF, x_init, max_iter, tollerance, c1, ...
    rho, max_backtrack, do_precon);

%% Save results
file_name = "x0_chainrosbrock.mat";  % change here

complete_name = sprintf("test_results/%s", file_name);
save(complete_name, "x_init", "x_found", "f_x", "norm_grad_f_x", ...
    "iteration", "failure", "flag", "x_seq", "backtrack_seq", ...
    "pcg_seq", "max_iter", "do_precon")