function [Bk] = modified_ldl_correction(Hk, beta, delta)

    % Set default values for beta and delta
    if nargin < 2 || isempty(beta)
        beta = 0.1;
    end
    if nargin < 3 || isempty(delta)
        delta = 1e-6;
    end

    % Add the path to the modLDL function
    addpath(fullfile(pwd, 'matrix_corrections/modLDL'));

    % Perform the modified LDL decomposition
    [L, D] = modLDL(Hk, beta, delta);
    % Recreate the corrected matrix
    Bk = L * D * L';

    if issparse(Hk) % Preserve sparsity
        Bk = sparse(Bk);
    end
end