function P = permutation(A, i, ii, j, jj)

    if nargin ~= 3 && nargin ~= 5
        error('Invalid number of arguments');
    end

    if i < 1 || i > size(A, 1)
        error('Invalid row permutation index');
    end

    if ii < 1 || ii > size(A, 1)
        error('Invalid row permutation index');
    end

    if j < 1 || j > size(A, 2)
        error('Invalid column permutation index');
    end

    if jj < 1 || jj > size(A, 2)
        error('Invalid column permutation index');
    end

    if i == j && ii == jj
        P = eye(size(A));
        P([i, ii], :) = P([ii, i], :);
        return;
    end

    Pi = row_permutation(A, i, ii);
    Pj = column_permutation(A, j, jj);

    P = Pj * Pi;
end