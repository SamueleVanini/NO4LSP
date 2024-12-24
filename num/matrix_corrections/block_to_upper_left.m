function P = block_to_upper_left(A, perm_i, perm_j)
    
    P = permutation(A, 1, perm_i, 2, perm_j);
end