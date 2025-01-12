clear
clc
close all

%% Load points

load('starting_points/100000-dim_Prob82.mat');

n = size(all_x, 2); % dimension of the problem

%% Initialization
% -- Functions --
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

% -- Other variables --
max_iter = 2500;
tollerance = 1e-8;

% backtracking
c1 = 1e-4;
rho = .6;
max_backtrack = 50;

% preconditioning
do_precon = false;

% approximation
h = 1e-12;
specific = true;

total_failure = 0;

%% all_x
n_points = 11;
for i = 1:n_points
    fprintf("x_%d\n", i);
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, x_seq, ...
        backtrack_seq, pcg_seq] = ...
        truncatedNM(f, gradF, hessF, all_x(:, i), max_iter, tollerance, c1, ...
        rho, max_backtrack, do_precon, h, specific);
    
    if failure 
        disp(flag);
        total_failure = total_failure + 1;
    end
    % disp(['Starting point: x = ', mat2str(all_x(:, i))]);
    % disp(['Solution found: x_found = ', mat2str(x_found)]);
    disp(['Function value: f(x_found) = ', num2str(f_x)]);
    disp(['Norm of the gradient: ', num2str(norm_grad_f_x)]);
    disp(['Done after ', num2str(iteration), '/', num2str(max_iter), ...
        ' iterations']);
    
    if do_precon 
        disp('Applied preconditioning');
    end
    disp('---------------------------------------');
end

fprintf("Total number of failure: %d\n", total_failure);