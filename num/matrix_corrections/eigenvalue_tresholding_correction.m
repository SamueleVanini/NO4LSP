function Bk = eigenvalue_tresholding_correction(Hk, toleig)
    
    if nargin < 2 % Set default value for toleig
        toleig = 1e-8;
    end

    if ~ishermitian(Hk) % Check if matrix is symmetric
        error('Matrix is not symmetric');
    end

    [V, D] = eig(Hk); % Compute eigendecomposition
    D(D < toleig) = toleig; % Replace negative eigenvalues with threshold
    Bk = V * D * V'; % Reconstruct positive definite matrix
end