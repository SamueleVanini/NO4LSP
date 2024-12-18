function gradF = chained_rosenbrock_grad(x)
    % CHAINED_ROSENBROCK_GRAD Gradient of the Chained Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   gradF : n-dimensional gradient vector
    
    % Dimension of input vector
    n = length(x);
    
    % Preallocate function value
    gradF = zeros(n, 1);

    % First component (j = 1)
    gradF(1) = 400 * x(1) * (x(1)^2 - x(2)) + 2 * (x(1) - 1);

    % Middle components (2 <= j <= n-1)
    for j = 2:n-1
        gradF(j) = -200 * (x(j-1)^2 - x(j)) + 400 * x(j) * (x(j)^2 - x(j+1)) + 2 * (x(j) - 1);
    end

    % Last component (j = n)
    gradF(n) = -200 * (x(n-1)^2 - x(n));
end
