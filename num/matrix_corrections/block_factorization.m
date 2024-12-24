function [L, D] = block_factorization(A, E)
    %BLOCK_FACTORIZATION Perform block factorization on matrix A
    %   [L, D] = BLOCK_FACTORIZATION(A) returns the block lower triangular matrix L
    %   and the block diagonal matrix D such that A = L * D * L'.

    % Check if the input matrix is square
    [m, n] = size(A);
    if m ~= n
        error('Input matrix must be square');
    end

    % Initialize L and D
    L = eye(n);
    D = zeros(n);

    % Perform block factorization
    for k = 1:n
        % Compute the diagonal block
        D(k, k) = A(k, k) - L(k, 1:k-1) * D(1:k-1, 1:k-1) * L(k, 1:k-1)';
        
        % Compute the off-diagonal blocks
        for i = k+1:n
            L(i, k) = (A(i, k) - L(i, 1:k-1) * D(1:k-1, 1:k-1) * L(k, 1:k-1)') / D(k, k);
        end
    end
end