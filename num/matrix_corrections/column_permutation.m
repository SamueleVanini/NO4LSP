function P = column_permutation(A, j, jj)
    
    if j < 1 || j > size(A, 2)
        error('Invalid column permutation index');
    end

    if jj < 1 || jj > size(A, 2)
        error('Invalid column permutation index');
    end

    [~, n] = size(A);
    P = eye(n);

    temp = P(:, j);
    P(:, j) = P(:, jj);
    P(:, jj) = temp;
end