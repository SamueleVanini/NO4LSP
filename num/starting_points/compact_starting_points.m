clear
clc

seed = min([318684, 337728, 338137]);
problem_dim = [1e3 1e4 1e5];

%% Rosenbrock
% Problem dimension -> n = 2
x_2 = [1.2, 1.2; -1.2, 1]';

f = @rosenbrock;
grad_f = @rosenbrock_grad;
hess_f = @rosenbrock_hess;

save('Rosenbrock.mat', "x_2", "f", "grad_f", "hess_f");

%% Extended Rosenbrock
file_name = 'Ext_Rosenbrock.mat';

f = @extended_rosenbrock;
grad_f = @extended_rosenbrock_grad;
hess_f = @extended_rosenbrock_hess;
hess_approx = @extended_rosenbrock_hess_approx;

x_0 = [-1.2; 1];

% Problem dimension -> 1000
x_0 = repmat(x_0, 500, 1);
x_1000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 10000
x_0 = repmat(x_0, 10, 1);
x_10000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 100000
x_0 = repmat(x_0, 10, 1);
x_100000 = [x_0, create_points(seed, x_0)];

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f", "hess_approx");

%% Extended Powell
file_name = 'Ext_Powell.mat';

f = @extended_powell;
grad_f = @extended_powell_grad;
hess_f = @extended_powell_hess;
hess_approx = @extended_powell_hess_approx;

x_0 = [0; 1];

% Problem dimension -> 1000
x_0 = repmat(x_0, 500, 1);
x_1000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 10000
x_0 = repmat(x_0, 10, 1);
x_10000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 100000
x_0 = repmat(x_0, 10, 1);
x_100000 = [x_0, create_points(seed, x_0)];

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f", "hess_approx");

%% Extended Powell
file_name = 'Problem_82.mat';

f = @problem_82;
grad_f = @problem_82_grad;
hess_f = @problem_82_hess;
hess_approx = @problem_82_hess_approx;

% Problem dimension -> 1000
x_0 = .5*ones(1000, 1);
x_1000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 10000
x_0 = .5*ones(10000, 1);
x_10000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 100000
x_0 = .5*ones(100000, 1);
x_100000 = [x_0, create_points(seed, x_0)];

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f", "hess_approx");