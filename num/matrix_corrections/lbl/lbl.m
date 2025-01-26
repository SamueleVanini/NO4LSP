function [L, B, P, E] = lbl(A)
    % SYMMETRIC INDEFINITE FACTORIZATION
    % The factorization is of the form PAP' = LBL', 
    % where L is a unit lower triangular matrix, B is a block
    % diagonal matrix with blocks of dimension 1 or 2, and P is a permutation
    % matrix.
    %
    % Input:
    % A - a symmetric matrix
    %
    % Output:
    % L - a unit lower triangular matrix
    % B - a block diagonal matrix
    % P - a permutation matrix
    % E - a block diagonal matrix with blocks of dimension 1 or 2
    %  

    if isscalar(A)
        % If the matrix is 1x1, return the trivial factorization
        L = 1;
        B = A;
        P = 1;
        E = A;
        return;
    end

    % Check if input is a matrix
    if ~ismatrix(A)
        error('Input must be a matrix');
    end

    % Check if matrix is symmetric
    if ~ishermitian(A)
        error('Matrix is not symmetric');
    end

    addpath(fullfile(pwd, 'matrix_corrections/lbl'));

    % Extract the E block according to the Bunch-Parlett criteria
    [E, perm_i, perm_j] = bunch_parlett_criteria(A);

    addpath(fullfile(pwd, 'matrix_corrections/permutations'));

    % Compute the permutation that will move the largest block on the top left
    P = block_to_upper_left_permutation(A, perm_i, perm_j);

    % Perform block factorization on the rearranged matrix
    [L, B, C, H] = block_factorization(P * A * P', E);
    % Perform the LBL factorization
    S = H - C * inv(E) * C'; % Schur complement % TODO avoid inv

    % Perform the LBL factorization on the Schur complement, recursively
    [~, ~, Ps, Es] = lbl(S);
    % Implant the new E block into the factorization
    % Results of lbl(S) provided E of the bottom-right (n-1)x(n-1) or (n-2)x(n-2) submatrix, according to the Bunch-Parlett criteria
    E = blkdiag(E, Es);
    B = E;
    
    % Implant the new P block into the factorization
    % Results of lbl(S) provided Ps of the bottom-right (n-1)x(n-1) or (n-2)x(n-2) submatrix, according to the Bunch-Parlett criteria
    Ps = blkdiag(eye(size(E, 1) - size(Es, 1)), Ps);
    P = P * Ps;
    
    L = P * L;
end