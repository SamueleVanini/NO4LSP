function HessF = extended_powell_hess(x)
    % EXTENDED_POWELL_HESS Hessian of the Extended Powell function
    % Input:
    %   x     : n-dimensional vector (n must be even)
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)
    
    % Badly scaling parameter
    alpha   = 1e4;
    beta    = 1;
    gamma   = 1 + 1e-4;

    % Dimension of input vector
    n = length(x);
    
    % Ensure input dimension is even (useless, but provided for coherence)
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Extended Powel function.');
    end
    
    % Initialize the gradient vector
    main_diag = zeros(n, 1);
    off_diag = zeros(n - 1, 1);

    % Compute the gradient
    for i = 1:2:n-1
        k = i;
        % diagonal
        main_diag(k) = (alpha*x(k+1))^2 + 2*exp(-2*x(k)) + exp(-x(k))*(exp(-x(k+1)) - gamma);
        off_diag(k) = 2*x(k)*x(k+1)*alpha^2 - alpha + exp(-x(k) - x(k+1));

        k = i+1;
        main_diag(k) = (alpha*x(k - 1))^2 + 2*exp(-2*x(k)) + exp(-x(k))*(exp(-x(k-1)) - gamma);
        % off_diag(k) = 0
    end
    
    Bin = [[off_diag; 0], main_diag, [0; off_diag]];
    HessF = spdiags(Bin, [-1 0 1], n, n);
end
