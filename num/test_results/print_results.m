clear
clc
close all

file = 'x1_results.mat';
% file = 'x2_results.mat';

load('rosenbrock.mat');
load(file);

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

%% Plot results
% -- Contour line --
disp('Contour line');

x_dim = [min(x_seq(1, :)) - 1, max(x_seq(1, :)) + 1];
y_dim = [min(x_seq(2, :)) - 1, max(x_seq(2, :)) + 1];

[X, Y] = meshgrid(linspace(x_dim(1), x_dim(2), 1000), ...
    linspace(y_dim(1), y_dim(2), 1000));
Z = reshape(ros_f([X(:),Y(:)]'),size(X));

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
plot3(x_seq(1, 1), x_seq(2, 1), ros_f(x_seq(:, 1)), 'ro');
if size(x_seq, 2) > 1
    plot3(x_seq(1, 1:2), x_seq(2, 1:2), ros_f(x_seq(:, 1:2)), 'r--');
    plot3(x_seq(1, 2:end), x_seq(2, 2:end), ros_f(x_seq(:, 2:end)), 'r--x');
end
hold off