function HessF = chained_rosenbrock_hess(x)
    % CHAINED_ROSENBROCK_HESS Hessian of the Chained Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)
    
    % Dimension of input vector
    n = length(x);
    
    % Preallocate Hessian matrix
    HessF = zeros(n, n);

    % Diagonal elements (i = j), i = n excluded
    for i = 1:n-1
        HessF(i, i) = 1200 * x(i)^2 - 400 * x(i+1) + 202;
    end
    
    % Diagonal (n, n) element 
    HessF(n, n) = 200;

    % Off-diagonal elements (symm. tri-diagonal)
    for i = 1:n-1
        % Precompute useful terms
        temp = -400 * x(i);
        
        % Insert in diagonals
        HessF(i, i+1) = temp;
        HessF(i+1, i) = temp;
    end
end
