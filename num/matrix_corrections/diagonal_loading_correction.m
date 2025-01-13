function Bk = diagonal_loading_correction(Hk, gamma, toleig, maxit)
    
    % Set default values for toleig and maxit
    if nargin < 2 || isempty(gamma)
        gamma = 1 + 1e-4;
    end
    
    if nargin < 3 || isempty(toleig)
        toleig = 1e-8;
    end
    
    if nargin < 4 || isempty(maxit)
        maxit = 500;
    end

    n = size(Hk); % Size of the problem

    t = 0;
    tauk = 0; % Start with no correction
    while t < maxit
        try
            % Check positive definiteness using Cholesky
            Bk = Hk + tauk * speye(n);
            ichol(Bk); % Attempt Cholesky decomposition
            break; % If successful, matrix is positive definite
        catch
            tauk = max(gamma * tauk, toleig); % Increase correction by gamma factor
        end
        t = t + 1;
    end
end