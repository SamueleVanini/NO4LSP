function all_x = create_points(seed, x_0)
%CREATE_POINTS Creates 10 random points
%   10 new starting points randomly generated with uniform
% distribution in a hyper-cube centered at x_0

rng(seed);

n_points = 10;
n = length(x_0);

all_x = 2*rand(n, n_points) - 1; % -1 <-> 1 range
all_x = all_x + x_0; % x_0 - 1 <-> x_0 + 1 range

end

