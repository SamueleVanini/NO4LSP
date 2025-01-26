% filepath: /c:/Users/carli/Desktop/Data Science and Engineering/04 Numerical Optimization for Large Scale Problems and Stochastic Optimization/Final project/NO4LSP/num/matrix_corrections/test_matrix_bp_criteria.m
close all; clear; clc;

% Define a symmetric matrix
A = [1, 2, 7, 2;
     2, 2, 1, 3;
     7, 1, 3, 3;
     2, 3, 3, 8];

% Call the function
E = bunch_parlett_criteria(A);

% Display the result
disp('Selected pivot block E:');
disp(E);