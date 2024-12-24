function [E, i, j] = bunch_parlett_criteria(A, growth_threshold)

    if nargin < 2
        growth_threshold = .5;
    end

    if ~ishermitian(A)
        error('Matrix must be Hermitian');
    end
    
     % Find the largest diagonal element magnitude (dia)
     [dia, dia_index] = max(abs(diag(A)));
    
     % Find the largest offd-diagonal element magnitude (offd)
     [offd, offd_linear_index] = max(abs(triu(A, 1)), [], 'all');
     [offd_index_i, offd_index_j] = ind2sub(size(A), offd_linear_index); % Convert linear index to subscripts
 
     %? TODO: what does it mean to the ratio to be acceptabe, < or > ? 
     % Decide on the pivot block
     if dia / offd >= growth_threshold
         % Select the diagonal element as a 1x1 pivot block
         i = dia_index;
         j = dia_index;
         E = A(i, j);
     else
         % Select the 2x2 submatrix as the pivot block
         i = offd_index_i;
         j = offd_index_j;
         E = A([i, j], [i, j]);
     end
end