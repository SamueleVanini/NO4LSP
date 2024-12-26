function HessF = chained_rosenbrock_hess(x)
    % CHAINED_ROSENBROCK_HESS Hessian of the Chained Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)
    
    % Dimension of input vector
    n = length(x);
    
    % Initialize the diagonals vector
    main_diag = 200*ones(n, 1);
    off_diag = zeros(n - 1, 1);

    for i = 1:n-1
        main_diag(i) = 1200*x(i)^2 - 400*x(i+1) + 202;
        off_diag(i) = -400*x(i);
    end

    Bin = [[off_diag; 0], main_diag, [0; off_diag]];
    HessF = spdiags(Bin, [-1 0 1], n, n);
end
