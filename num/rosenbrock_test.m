clear
clc

%% Variables initializaiton
load rosenbrock.mat

% starting points
x = [1.2 -1.2; 1.2 1];

max_iter = 5000;
tollerance = 1e-8;
c1 = 1e-4;
rho = .7;
max_backtrack = 50;
do_precon = true;

%% Apply Truncated Newthon Method
for i = 1
    x_initial = x(:, i);    
    [x_found, f_x, norm_grad_f_x, iteration, failure, flag, ...
        x_seq, backtrack_seq, pcg_seq] = ...
        truncatedNM(ros_f, ros_grad, ros_hess, x_initial, ...
        max_iter, tollerance, c1, rho, max_backtrack, do_precon);

    %% Display results
    if failure
        disp(flag);
    end
    
    disp(['Starting point: x = ', mat2str(x_initial)]);
    disp(['Solution found: x_found = ', mat2str(x_found)]);
    disp(['Function value: f(x_found) = ', num2str(f_x)]);
    disp(['Norm of the gradient: ', num2str(norm_grad_f_x)]);
    disp(['Done after ', num2str(iteration), '/', num2str(max_iter), ...
        ' iterations']);

    disp(' ');

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

    % -- 3D plot --
    disp('3D plot');

    disp('------------------------'); 
end