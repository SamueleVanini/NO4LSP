function Bk = nearest_PD_correction(Hk, toleig)

    [V, D] = eig(Hk); % Compute eigendecomposition
    D(D < toleig) = toleig; % Replace negative eigenvalues with threshold
    Bk = V * D * V'; % Reconstruct positive definite matrix
end