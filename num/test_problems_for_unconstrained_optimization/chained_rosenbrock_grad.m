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

    % First component (i = 1)
    gradF(1) = 400 * x(1) * (x(1)^2 - x(2)) + 2 * (x(1) - 1);

    % Middle components (2 <= i <= n-1)
    for i = 2:n-1
        gradF(i) = -200 * (x(i-1)^2 - x(i)) + 400 * x(i) * (x(i)^2 - x(i+1)) + 2 * (x(i) - 1);
    end

    % Last component (i = n)
    gradF(n) = -200 * (x(n-1)^2 - x(n));
end
