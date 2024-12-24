function [E] = bunch_parlett_criteria(A, growth_threshold)

    if nargin < 2
        growth_threshold = .5;
    end

    if ~ishermitian(A)
        error('Matrix must be Hermitian');
    end
    
     % Find the largest diagonal element magnitude (dia)
     [dia, dia_index] = max(abs(diag(A)));
    
     % Find the largest offd-diagonal element magnitude (offd)
     [offd, linear_index] = max(abs(triu(A, 1)), [], 'all');
     [i, j] = ind2sub(size(A), linear_index); % Convert linear index to subscripts
 
     % Decide on the pivot block
     if dia / offd <= growth_threshold
         % Select the diagonal element as a 1x1 pivot block
         E = A(dia_index, dia_index);
     else
         % Select the 2x2 submatrix as the pivot block
         E = A([i, j], [i, j]);
     end
end