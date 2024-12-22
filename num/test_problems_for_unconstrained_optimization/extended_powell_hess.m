function HessF = extended_powell_hess(x, alpha, beta, gamma)
    % EXTENDED_POWELL_HESS Hessian of the Extended Powell function
    % Input:
    %   x     : n-dimensional vector (n must be even)
    %   alpha : Scaling factor for the odd term (scalar)
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)

    % Dimension of input vector
    n = length(x);
    
    % Ensure input dimension is even (useless, but provided for coherence)
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Powel function.');
    end
    
    % Initialize the gradient vector
    HessF = zeros(n, n);

    % Compute the gradient
    for i = 1:2:n-1
                
        % Diagonal elements
        HessF(i, i)     = (alpha*x(i+1))^2 + 2*exp(-2*x(i)) + exp(-x(i))*(exp(-x(i+1))-gamma); % Odd (i)
        HessF(i+1, i+1) = (alpha*x(i))^2 + 2*exp(-2*x(i+1)) + exp(-x(i+1))*(exp(-x(i))-gamma); % Even (i+1)
        
        % Off-diagonal elements (symm. tri-diagonal) Note: temp is off-diag of i, off-diag of i+1 is 0
        temp = 2*alpha^2*x(i)*x(i+1) - alpha*beta + exp(-x(i))*exp(-x(i+1));
        HessF(i+1, i) = temp;
        HessF(i, i+1) = temp;
    end
end
