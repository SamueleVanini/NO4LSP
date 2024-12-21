function Bk = levenberg_marquardt_correction(Hk, lambda)
    
    if isvector(lambda)
        % If lambda is float, then gradientf was passed instead of fixed lambda
        min_eig = eigs(Hk, 1, 'smallestreal'); % Compute smallest eigenvalue
        lambda = max(min_eig, norm(lambda)); % Regularization term
    end
    
    Bk = Hk + lambda * eye(size(Hk));
end