clear
clc
close all

%% Variables initializaiton
load rosenbrock.mat

x1 = [1.2; 1.2];
x2 = [-1.2; 1];

max_iter = 5000;
tollerance = 1e-8;
c1 = 1e-4;
rho = .7;
max_backtrack = 50;
do_precon = false;

% Apply Truncated Newthon Method
%% x1
x_init = x1;
[x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
    x_seq, backtrack_seq, pcg_seq] = ...
    truncatedNM(ros_f, ros_grad, ros_hess, x_init, max_iter, ...
    tollerance, c1, rho, max_backtrack, do_precon);

%% Save results
save test_results/x1_results.mat x_init x_found f_x norm_grad_f_x ...
    iteration failure flag x_seq backtrack_seq pcg_seq max_iter

%% x2
x_init = x2;
[x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
    x_seq, backtrack_seq, pcg_seq] = ...
    truncatedNM(ros_f, ros_grad, ros_hess, x_init, max_iter, ...
    tollerance, c1, rho, max_backtrack, do_precon);

%% Save results
save test_results/x2_results.mat x_init x_found f_x norm_grad_f_x ...
    iteration failure flag x_seq backtrack_seq pcg_seq max_iter