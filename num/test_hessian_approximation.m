clc
clear
close all

%% Setup
% 500 random points
rng(0);
n_points = 500;
n = 1000;

x = rand(n, n_points);

h = 1e-12;
fprintf("Dimension of the problem: %d\n", n);

% Function
% fprintf("-- Extended Powell\n\n");
% grad_f = @extended_powell_grad;
% hess_f = @extended_powell_hess;

% fprintf("-- Extended Rosenbrock\n\n");
% grad_f = @extended_rosenbrock_grad;
% hess_f = @extended_rosenbrock_hess;

fprintf("-- Problem 82\n\n");
grad_f = @problem_82_grad;
hess_f = @problem_82_hess;

%% Exact hessian
exact_hessian = zeros(1, n_points);
for i = 1:n_points
    tic;
    hess_f(x(:, i));
    exact_hessian(i) = toc;
end

fprintf("---- Exact Hessian average time (%d points): %f s\n", n_points,  mean(exact_hessian));

%% Jacobian Approximation (Exact gradient)
approx_hessian = zeros(1, n_points);
for i = 1:n_points
    tic;
    F_x = grad_f(x(:, i));
    jacobian_3d_approx(grad_f, x(:, i), h, F_x, false);
    approx_hessian(i) =  toc;
end

fprintf("---- Approximated (h = %g) Hessian average time (%d points): %f s\n", h, n_points, mean(approx_hessian));

%% Specific Jacobian Approximation
spec_approx_hessian = zeros(1, n_points);
for i = 1:n_points
    tic;
    F_x = grad_f(x(:, i));
    jacobian_3d_approx(grad_f, x(:, i), h, F_x, true);
    spec_approx_hessian(i) =  toc;
end

fprintf("---- Specific Approximated (h = %g) Hessian average time (%d points): %f s\n", h, n_points, mean(spec_approx_hessian));

%% Plot
figure();
avg_time1 = mean(exact_hessian);
avg_time2 = mean(approx_hessian);
avg_time3 = mean(spec_approx_hessian);

x_axes = 1:n_points; 

% Plot the execution times
plot(x_axes, exact_hessian, '-', x_axes, approx_hessian, '-', x_axes, spec_approx_hessian, '-'); 
hold on;

% Plot the average execution time lines for each function
plot(x_axes, avg_time1 * ones(n_points, 1), '--', 'LineWidth', .5);
plot(x_axes, avg_time2 * ones(n_points, 1), '--', 'LineWidth', .5);  
plot(x_axes, avg_time3 * ones(n_points, 1), '--', 'LineWidth', .5);  

% Add labels and legend
xlabel('Execution Number');
ylabel('Execution Time (seconds)');
legend('Exact Hessian', 'Approximated Hessian', 'Specific Approximated Hessian', 'Avg Exact', 'Avg Approximated', 'Avg Specific Approximated');
title('Execution Time');

grid on;
box on;