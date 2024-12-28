clear
clc
close all

file = 'x0_prob82.mat';
load(file);

%% Set functions
addpath("..\test_problems_for_unconstrained_optimization\");
% f = @extended_powell;
% gradF = @extended_powell;
% hessF = @extended_powell;

% f = @extended_rosenbrock;
% gradF = @extended_rosenbrock_grad;
% hessF = @extended_rosenbrock_hess;

f = @problem_82;
gradF = @problem_82_grad;
hessF = @problem_82_hess;

%% Display results
if failure 
    disp(flag);
end

disp(['Starting point: x = ', mat2str(x_init)]);
disp(['Solution found: x_found = ', mat2str(x_found)]);
disp(['Function value: f(x_found) = ', num2str(f_x)]);
disp(['Norm of the gradient: ', num2str(norm_grad_f_x)]);
disp(['Done after ', num2str(iteration), '/', num2str(max_iter), ...
    ' iterations']);

if do_precon 
    disp('Applied preconditioning');
end

%% Plot results
% -- Contour line --
disp('Contour line');

x_dim = [min(x_seq(1, :)) - 1, max(x_seq(1, :)) + 1];
y_dim = [min(x_seq(2, :)) - 1, max(x_seq(2, :)) + 1];

[X, Y] = meshgrid(linspace(x_dim(1), x_dim(2), 1000), ...
    linspace(y_dim(1), y_dim(2), 1000));
Z = zeros(1000000, 1);
for i = 1:1000000
    Z(i) = f([X(i); Y(i)]);
end
Z = reshape(Z, size(X));

contour_fig = figure();
contour(X, Y, Z);
hold on
plot(x_seq(1, 1), x_seq(2, 1), 'ro');
if size(x_seq, 2) > 1
    plot(x_seq(1, 1:2), x_seq(2, 1:2), 'r--');
    plot(x_seq(1, 2:end), x_seq(2, 2:end), 'r--x');
end
hold off

% -- Surface plot --
disp('Surface plot');

surf_fig = figure();
surf(X, Y, Z, 'EdgeColor', 'none');

hold on
plot3(x_seq(1, 1), x_seq(2, 1), f(x_seq(:, 1)), 'ro');
if size(x_seq, 2) > 1
    line = [f(x_seq(:, 1)), f(x_seq(:, 2))];
    plot3(x_seq(1, 1:2), x_seq(2, 1:2), line, 'r--');

    other_points = zeros(1, size(x_seq, 2) - 1);
    for i = 1:size(x_seq, 2) - 1
        other_points(i) = f(x_seq(:, i + 1));
    end
    plot3(x_seq(1, 2:end), x_seq(2, 2:end), other_points, 'r--x');
end
hold off