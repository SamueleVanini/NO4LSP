function Hess = extended_powell_hess_approx(x_bar, h, specific, gradF, gradF_xbar)
    %EXTENDED_POWELL_HESS_APPROX Approximation of the Jacobian of the Extended
    %Powell function
    %   For specific tri-diagonal jacobian
    %
    %   Input:
    %       x_bar - point in where to compute the jacobian
    %           row vector
    %       h - level of approximation
    %           scalar
    %       specific - implement a specific approximation based on x_bar
    %           logical value
    %       gradF - gradient of the Powell function
    %           function handle
    %       gradF_xbar - gradient at x_bar
    %           row vector
    %
    %   Output
    %       Hess - approximation of the Hessian
    %           sparse matrix (tri-diagonal)

    % Problem dimension
    n = length(x_bar);

    % Gradient at x_bar
    if isempty(gradF_xbar)
        gradF_xbar = gradF(x_bar);
    end

    % Approximation step for each component of x
    if specific
        h_vec = h*abs(x_bar);
    else
        h_vec = h*ones(n, 1);
    end

    % Perturbation vectors
    e1 = zeros(n, 1);
    e2 = zeros(n, 1);

    e1(1:2:n) = h_vec(1:2:n);
    e2(2:2:n) = h_vec(2:2:n);

    % Compute Hessian component
    approx = @(e) (gradF(x_bar + e) - gradF_xbar)./h_vec;
    eval = [approx(e1), approx(e2)];

    % Compute Hessian indices
    row_idx = (2:n)';
    col_idx = mod(row_idx - 1, 2) + 1;
    
    % Build Hessian
    main_diag = [eval(1, 1); eval(sub2ind(size(eval), row_idx, col_idx))];
    off_diag = eval(sub2ind(size(eval), row_idx - 1, col_idx));

    % Set to 0 all even elements of off_diag
    off_diag(2:2:n-1) = 0;

    % Build a sparse matrix
    Bin = [[off_diag; 0], main_diag, [0; off_diag]];
    Hess = spdiags(Bin, [-1 0 1], n, n);
end