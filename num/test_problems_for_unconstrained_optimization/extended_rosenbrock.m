function F = extended_rosenbrock(x)
    % EXTENDED_ROSENBROCK Extended Rosenbrock function evaluation
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value
    
    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Rosenbrock function.');
    end

    % Initialize function value
    F = 0;
    
    % Compute function value
    for i = 1:2:n-1
        % Compute the two terms of the Rosenbrock function
        f_odd = 10 * (x(i)^2 - x(i+1));
        f_even = (x(i) - 1);
        
        % Accumulate the result
        F = F + f_odd^2 + f_even^2;
    end
    
    % Divide by two
    F = 0.5 * F;
end
