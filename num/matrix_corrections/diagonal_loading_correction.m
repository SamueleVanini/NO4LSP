function Bk = diagonal_loading_correction(Hk, toleig, maxit)
    
    % Set default values for toleig and maxit
    if nargin < 2 || isempty(toleig)
        toleig = 1e-8;
    end
    if nargin < 3 || isempty(maxit)
        maxit = 500;
    end

    t = 0;
    tauk = 0; % Start with no correction
    while t < maxit
        try
            % Check positive definiteness using Cholesky
            chol(Hk + tauk * eye(size(Hk))); % Attempt Cholesky decomposition
            break; % If successful, matrix is positive definite
        catch
            tauk = max(2 * tauk, toleig); % Increase correction factor linearly
        end
        t = t + 1;
    end

    % Apply the final corrected Bk
    Bk = Hk + tauk * eye(size(Hk));

    if issparse(Hk) % Preserve sparsity
        Bk = sparse(Bk);
    end
end