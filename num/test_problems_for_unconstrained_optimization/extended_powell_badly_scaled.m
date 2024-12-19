function F = extended_powell_badly_scaled(x)
    % EXTENDED_POWELL_BADLY_SCALED Extended Powell badly scaled function
    % evaluation (alpha=1e4, beta=1, gamma=1+1e-4)
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value
    
    % Badly scaling parameters
    alpha   = 1e4;
    beta    = 1;
    gamma   = 1 + 1e-4;
    
    % Function evaluation
    F = extended_powell(x, alpha, beta, gamma);
end