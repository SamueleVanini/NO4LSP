function [E] = bunch_parlett_criteria(A, growth_threshold)
    
    if nargin < 2
        growth_threshold = 100;
    end

    if ~ishermitian(A)
        error('Matrix must be Hermitian');
    end
    
    [diag, i] = max(diag(A));
    [offd, j] = max(max(abs(A - diag(diag(A))));
    
    % Decide on the pivot block
    if diag / offd <= growth_threshold
        % Select the diagonal element as a 1x1 pivot block
        E = A(i, i);
    else
        % Select the 2x2 submatrix as the pivot block
        E = A([i, j], [i, j]);
    end
end