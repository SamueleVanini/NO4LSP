clear;
clc;

seed = min([318684, 337728, 338137]);
problem_dim = [1e3 1e4 1e5];

%% Rosenbrock
% Problem dimension -> n = 2
x_2 = [1.2, 1.2; -1.2, 1]';
minimum = [1; 1];

f = @rosenbrock;
grad_f = @rosenbrock_grad;
hess_f = @rosenbrock_hess;

save('Rosenbrock.mat', "x_2", "f", "grad_f", "hess_f", "minimum");

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
min_1000 = ones(1000, 1);

% Problem dimension -> 10000
x_0 = repmat(x_0, 10, 1);
x_10000 = [x_0, create_points(seed, x_0)];
min_10000 = ones(10000, 1);

% Problem dimension -> 100000
x_0 = repmat(x_0, 10, 1);
x_100000 = [x_0, create_points(seed, x_0)];
min_100000 = ones(100000, 1);

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f",...
    "hess_approx", "min_1000", "min_10000", "min_100000");

%% Extended Powell
file_name = 'Ext_Powell.mat';

f = @extended_powell;
grad_f = @extended_powell_grad;
hess_f = @extended_powell_hess;
hess_approx = @extended_powell_hess_approx;

x_0 = [0; 1];
minimum = [1.09815933e-5; 9.106146738]; % f(min) = 2.3e-21; norm of grad = 6.2e-6

% Problem dimension -> 1000
x_0 = repmat(x_0, 500, 1);
min_1000 = repmat(minimum, 500, 1);
x_1000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 10000
x_0 = repmat(x_0, 10, 1);
min_10000 = repmat(minimum, 5000, 1);
x_10000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 100000
x_0 = repmat(x_0, 10, 1);
min_100000 = repmat(minimum, 50000, 1);
x_100000 = [x_0, create_points(seed, x_0)];

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f",...
    "hess_approx", "min_1000", "min_10000", "min_100000");

%% Problem 82
file_name = 'Problem_82.mat';

f = @problem_82;
grad_f = @problem_82_grad;
hess_f = @problem_82_hess;
hess_approx = @problem_82_hess_approx;

% Problem dimension -> 1000
x_0 = .5*ones(1000, 1);
min_1000 = zeros(1000, 1);
x_1000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 10000
x_0 = .5*ones(10000, 1);
min_10000 = zeros(10000, 1);
x_10000 = [x_0, create_points(seed, x_0)];

% Problem dimension -> 100000
x_0 = .5*ones(100000, 1);
min_100000 = zeros(100000, 1);
x_100000 = [x_0, create_points(seed, x_0)];

save(file_name, "x_1000", "x_10000", "x_100000", "f", "grad_f", "hess_f",...
    "hess_approx", "min_1000", "min_10000", "min_100000");