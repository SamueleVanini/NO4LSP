function HessF = extended_rosenbrock_hess(x)
    % EXTENDED_ROSENBROCK_HESS Hessian of the Extended Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (tri-diagonal)

    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    % TODO correct?
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Rosenbrock function.');
    end
    
    % Preallocate Hessian matrix
    HessF = zeros(n, n);
    
    % Compute the Hessian
    for i = 1:2:n-1
        
        % Diagonal element HessF(i, i) (odd index)
        HessF(i, i) = 1200 * x(i)^2 - 400 * x(i+1) + 2;
        
        % Diagonal element HessF(i+1, i+1) (even index)
        HessF(i+1, i+1) = 200;
    end
    
    % Off-diagonal elements (symmetric)
    for i = 1:n-1
        temp = -400 * x(i);
        HessF(i, i+1) = temp;
        HessF(i+1, i) = temp;
    end
    
end
