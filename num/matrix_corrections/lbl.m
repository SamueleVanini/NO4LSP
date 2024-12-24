function [L, B] = lbl(A)

    % Check if matrix is symmetric
    if ~ishermitian(A)
        error('Matrix is not symmetric');
    end

    % Extract the E block according to the Bunch-Parlett criteria
    [E, perm_i, perm_j] = bunch_parlett_criteria(A);
    
    % Compute the permutation that will move the largest block on the top left
    P = block_to_upper_left_permutation(perm_i, perm_j);

    % Perform block factorization on the rearranged matrix
    [L, B] = block_factorization(P * A * P', E);
    
    % Apply the permutation to L and B
    L = P' * L * P;
    B = P' * B * P;

end