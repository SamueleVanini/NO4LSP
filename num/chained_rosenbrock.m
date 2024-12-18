function F = chained_rosenbrock(x)
    % CHAINED_ROSENBROCK Function definition
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value
    
    % Dimension of input vector
    n = length(x);
    
    % Initialize function value
    F = 0;         
    
    % Compute the function
    for i = 2:n
        F = F + 100 * (x(i-1)^2 - x(i)^2)^2 + (x(i-1) - 1)^2;
    end
end
