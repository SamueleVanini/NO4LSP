function Bk = minimal_eigenvalue_correction(Hk, toleig)
    % Function to apply minimal eigenvalue correction while preserving sparsity

    if nargin < 2 || isempty(toleig) % Set default value for toleig
        toleig = 1e-8;
    end

    if ~issymmetric(Hk) % Check if the matrix is symmetric
        error('Matrix is not symmetric');
    end

    % Compute the smallest eigenvalue
    min_eig = eigs(Hk, 1, 'smallestabs', 'IsSymmetricDefinite', false, 'tol', 1e-8, 'MaxIterations', 500); 

    % Compute the correction term
    tauk = max(0, toleig - min_eig); 

    % Add correction while preserving sparsity
    Bk = Hk + tauk * speye(size(Hk)); 
end
