function P = row_permutation(A, i, ii)
    
    if i < 1 || i > size(A, 1)
        error('Invalid row permutation index');
    end

    if ii < 1 || ii > size(A, 1)
        error('Invalid row permutation index');
    end

    [m, ~] = size(A);
    P = eye(m);

    temp = P(i, :);
    P(i, :) = P(ii, :);
    P(ii, :) = temp;
end