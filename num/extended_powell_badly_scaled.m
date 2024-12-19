function F = extended_powell_badly_scaled(x)
    % EXTENDED_POWELL_BADLY_SCALED Extended Powell badly scaled function evaluation
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   F : scalar function value
    
    % Badly scaling parameters
    alpha   = 10000;
    beta    = 1;
    gamma   = 1.0001;
    
    % Function evaluation
    F = extended_powell(x, alpha, beta, gamma);
end