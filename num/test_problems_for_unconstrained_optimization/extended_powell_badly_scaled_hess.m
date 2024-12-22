function HessF = extended_powell_badly_scaled_hess(x)
    % EXTENDED_POWELL_BADLY_SCALED_HESS Hessian of the Extended Powell
    % badly scaled function (alpha=1e4)
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symmetric tri-diagonal)
    
    % Badly scaling parameter
    alpha   = 1e4;
    beta    = 1;
    gamma   = 1 + 1e-4;
    
    % Gradient evaluation
    HessF = extended_powell_hess(x, alpha, beta, gamma);
end
