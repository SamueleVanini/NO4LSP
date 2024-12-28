function gradF = extended_powell_grad(x)
    % EXTENDED_POWELL_GRAD Gradient of the Extended Powell function
    % Input:
    %   x     : n-dimensional vector (n must be even)
    % Output:
    %   gradF : n-dimensional gradient vector

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
    
    % Initialize the gradient vector
    gradF = zeros(n, 1);

    % Compute the gradient
    for i = 1:2:n-1
    
        % Odd indices
        k = i;
        gradF(k)   =  alpha^2*x(k)*x(k+1)^2 - alpha*beta*x(k+1) - exp(-2*x(k)) - exp(-x(k))*exp(-x(k+1)) + gamma*exp(-x(k));
    
        % Even indices
        k = i+1;
        gradF(k) = alpha^2*x(k)*x(k-1)^2 - alpha*beta*x(k-1) - exp(-2*x(k)) - exp(-x(k))*exp(-x(k-1)) + gamma*exp(-x(k));
    end
end
