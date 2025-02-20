function F = extended_powell(x)
    % EXTENDED_POWELL Extended Powell function evaluation
    % Input:
    %   x     : n-dimensional vector (n must be even)
    % Output:
    %   F : scalar function value

    % Badly scaling parameter
    alpha   = 1e4;
    beta    = 1;
    gamma   = 1 + 1e-4;

    % Dimension of input vector
    n = length(x);
    
    % Ensure input dimension is even
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Powel function.');
    end
    
    % Initialize function value
    F = 0;
    
    % Compute the function value
    for i = 1:2:n-1 % Compute entries at k=i and k=i+1 at the same time
        
        % k = i (odd)
        k = i;
        f_odd = alpha * x(k) * x(k+1) - beta;

        % k = i + 1 (even)
        k = i+1;
        f_even = exp(-x(k - 1)) + exp(-x(k)) - gamma;
        
        % Accumulate the result
        F = F + f_odd^2 + f_even^2;
    end
    
    % Divide by two
    F = 0.5 * F;
end
