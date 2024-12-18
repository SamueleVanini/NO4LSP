function F = extended_rosenbrock(x)
    % EXTENDED_ROSENBROCK Function definition
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value
    
    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    % TODO correct?
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Rosenbrock function.');
    end

    % Initialize function value
    F = 0;
    
    % Compute function value
    for i = 1:2:n-1
        % Compute the two terms of the Rosenbrock function
        term1 = 10 * (x(i)^2 - x(i+1))^2;  % First term
        term2 = (x(i) - 1)^2;              % Second term
        
        % Accumulate the result
        F = F + term1 + term2;
    end
    
    % Divide by two
    F = 0.5 * F;
end
