function HessF = extended_powell_hess(x, alpha)
    % EXTENDED_POWELL_HESS Hessian of the Extended Powell function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)

    % Dimension of input vector
    n = length(x);
    
    % Ensure input dimension is even
    % TODO corret? Here it is usless theoretically, but implemented in grad
    % and fun eval
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Powel function.');
    end
    
    % Initialize the gradient vector
    HessF = zeros(n, n);

    % Compute the gradient
    for i = 1:n
    
        % Diagonal elemtns
        HessF(i, i) = 0.5 * ext(-x(i));
    
        % Off-diagonal elements (symm. tri-diagonal)
        temp = 0.5 * alpha;
        HessF(i, i+1) = temp;
        HessF(i, i+1) = temp;
    end
end
