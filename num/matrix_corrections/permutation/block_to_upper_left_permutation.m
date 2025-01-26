function P = block_to_upper_left_permutation(A, perm_i, perm_j)
    if perm_i == perm_j
        P = permutation(A, 1, perm_i, 1, perm_i); 
    else
        P = permutation(A, 1, perm_i, 2, perm_j);
    end
end