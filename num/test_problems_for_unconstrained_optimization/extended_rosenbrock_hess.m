function HessF = extended_rosenbrock_hess(x)
    % EXTENDED_ROSENBROCK_HESS Hessian of the Extended Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symm. tri-diagonal)

    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Hessian of the Extended Rosenbrock function.');
    end
    
    % Initialize the diagonals vectors
    main_diag = 100*ones(n, 1); % Note: Half of main diagonal entries them are 100 by defintion (see later)
    off_diag = zeros(n - 1, 1); % Note: Half of off-diagonal entries are 0 by definition (see later)
    
    for i = 1:2:n-1

        k = i; % (odd)
        main_diag(k) = 600*x(k)^2 - 200*x(k+1) + 1;
        off_diag(k) = -200*x(k);

        % Values for k=i+1 are already set before loop starts
        % k = i+1; % (even)
        % main_diag(k) = 100;
        % off_diag(k)  = 0;
    end

    % Build a sparse matrix
    Bin = [[off_diag; 0], main_diag, [0; off_diag]];
    HessF = spdiags(Bin, [-1 0 1], n, n);    
end