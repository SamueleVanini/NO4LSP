clear
clc

seed = min([318684, 337728, 338137]);
problem_dim = [1e3 1e4 1e5];

%% Chained Rosenbrock
for n = problem_dim
    x_0 = repmat([-1.2; 1], floor(n/2), 1);

    all_x = create_points(seed, x_0);

    file_name = sprintf("%d-dim_ChainRos.mat", n);
    save(file_name, "x_0", "all_x");
end

%% Extended Rosenbrock
for n = problem_dim
    x_0 = repmat([-1.2; 1], floor(n/2), 1);

    all_x = create_points(seed, x_0);

    file_name = sprintf("%d-dim_ExtRos.mat", n);
    save(file_name, "x_0", "all_x");
end

%% Extended Powell
for n = problem_dim
    x_0 = repmat([0; 1], floor(n/2), 1);

    all_x = create_points(seed, x_0);

    file_name = sprintf("%d-dim_ExtPow.mat", n);
    save(file_name, "x_0", "all_x");
end