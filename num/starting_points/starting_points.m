clear
clc

seed = min([318684, 337728, 338137]);
problem_dim = [1e3 1e4 1e5];

%% Extended Rosenbrock
for n = problem_dim
    x_0 = repmat([-1.2; 1], floor(n/2), 1);

    all_x = [x_0, create_points(seed, x_0)];

    file_name = sprintf("%d-dim_ExtRos.mat", n);
    save(file_name, "all_x");
end

%% Extended Powell
for n = problem_dim
    x_0 = repmat([0; 1], floor(n/2), 1);

    all_x = [x_0, create_points(seed, x_0)];

    file_name = sprintf("%d-dim_ExtPow.mat", n);
    save(file_name, "all_x");
end

%% Problem 82
for n = problem_dim
    x_0 = 0.5*ones(n, 1);

    all_x = [x_0, create_points(seed, x_0)];

    file_name = sprintf("%d-dim_Prob82.mat", n);
    save(file_name, "all_x");
end