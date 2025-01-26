function Bk = diagonalization_correction(Hk, toleig)
    % Function to apply diagonalization correction while preserving sparsity

    if nargin < 2 || isempty(toleig) % Set default value for toleig
        toleig = 1e-8;
    end

    if ~issymmetric(Hk) % Check if the matrix is symmetric
        error('Matrix is not symmetric');
    end

    n = size(Hk, 1);

    % Compute eigendecomposition (use eigs() - rather than eig() - with size of Hk since we need *all* eigenvalues, note: eig() with sparse matrices can't return eigenvectors)
    [V, D] = eigs(Hk, n, 'largestabs', 'IsSymmetricDefinite', false, 'tol', 1e-8, 'MaxIterations', 500);

    % Threshold eigenvalues
    D = spdiags(max(diag(D), toleig), 0, n, n); % Ensure eigenvalues are >= toleig and enforce sparsity (eigs() do not preserve sparsity)
    V = sparse(V); % Enforce sparsity on V (eigs() do not preserve sparsity)

    % Reconstruct the matrix
    Bk = V * D * V';
end