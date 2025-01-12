function gradF = extended_rosenbrock_grad(x)
    % EXTENDED_ROSENBROCK_GRAD Gradient of the Extended Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   gradF : n-dimensional gradient vector
    
    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Gradient of the Extended Rosenbrock function.');
    end
    
    % Preallocate gradient vector
    gradF = zeros(n, 1);
    
    % Compute the gradient in pairs
    for i = 1:2:n-1
        
        % Gradient w.r.t. x_i (odd index)
        k = i; % always odd
        gradF(k) = 200*x(k)^3 - 200*x(k)*x(k+1) + x(k) - 1;
        
        % Gradient w.r.t. x_{i+1} (even index)
        k = i+1; % always even
        gradF(k) = 100*(x(k) - x(k-1)^2);
    end
end