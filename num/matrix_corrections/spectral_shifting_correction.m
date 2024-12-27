function Bk = spectral_shifting_correction(Hk, toleig, preservesparsity)
    
    if nargin < 2 || isempty(toleig) % Set default value for toleig
        toleig = 1e-8;
    end

    if nargin < 3 % Set default value for preservesparsity
        preservesparsity = true;
    end

    if ~ishermitian(Hk) % Check if matrix is symmetric
        error('Matrix is not symmetric');
    end

    min_eig = eigs(Hk, 1, 'smallestreal'); % Compute smallest eigenvalue
    tauk = max(0, toleig - min_eig); % Compute correction
    Bk = Hk + tauk * eye(size(Hk)); %  Add correction

    if issparse(Hk) && preservesparsity == true % Preserve sparsity
        Bk = sparse(Bk);
    end
end