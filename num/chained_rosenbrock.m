function F = chained_rosenbrock(x)
    % CHAINED_ROSENBROCK Function definition
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value

    n = length(x);
    F = 0;
    for i = 2:n
        F = F + 100 * (x(i-1)^2 - x(i)^2)^2 + (x(i-1) - 1)^2;
    end
end
