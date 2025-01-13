function [Bk] = inertia_correction(Hk, toleig)
    
    if nargin < 2 || isempty(toleig)
        toleig = 1e-8;
    end

    if ~issymmetric(Hk) % Check if matrix is symmetric
        error('Matrix is not symmetric');
    end

    % Check if the matrix is square
    n = size(Hk, 1);

    % Compute LBL decomposition
    [L, B, P] = lbl(Hk); % Compute LBL decomposition
    
    % Compute eigenvalues and eigenvectors
    [V, D] = eigs(B);

    % Compute tau vector
    tau = zeros(n);
    for i = 1:n
        lambda = D(i, i);
        eigerr = toleig - lambda;
        if abs(eigerr) < toleig
            tau(i) = eigerr;
        end
    end

    % Compute F matrix for correction
    F = V * diag(tau) * V';

    % Compute corrected matrix
    Bk = P' * (L * (B + F) * L') * P;

    if issparse(Hk) % Preserve sparsity
        Bk = sparse(Bk);
    end
end