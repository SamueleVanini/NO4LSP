function gradF = extended_powell_badly_scaled_grad(x)
    % EXTENDED_POWELL_BADLY_SCALED_GRAD Gradient of the Extended Powell
    % badly scaled function (alpha=1e4)
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   gradF : n-dimensional gradient vector
   
    % Badly scaling parameter
    alpha   = 1e4;
    
    % Gradient evaluation
    gradF = extended_powell_grad(x, alpha);
end