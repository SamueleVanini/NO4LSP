function gradF = extended_powell_grad(x, alpha, beta, gamma)
    % EXTENDED_POWELL_GRAD Gradient of the Extended Powell function
    % Input:
    %   x     : n-dimensional vector (n must be even)
    %   alpha : Scaling factor for the odd term (scalar)
    % Output:
    %   gradF : n-dimensional gradient vector

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
        gradF(i)   =  alpha^2*x(i)*x(i+1)^2 - alpha*beta*x(i+1) - exp(-2*x(i)) - exp(-x(i))*exp(-x(i+1)) + gamma*exp(-x(i));
    
        % Even indices
        gradF(i+1) = alpha^2*x(i+1)*x(i)^2 - alpha*beta*x(i) - exp(-2*x(i+1)) - exp(-x(i+1))*exp(-x(i)) + gamma*exp(-x(i+1));
    end
end
