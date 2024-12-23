function [L, D] = modLDL(A, beta, delta)
    % modChol: Modified Cholesjy factorization
    %   [L, D] = modChol(A) computes the modified Cholesjy factorization of
    %   the symmetric positive definite matrix A. The factorization is
    %   given by A = L * D * L', where L is a lower triangular matrix with
    %   ones on the diagonal and D is a diagonal matrix
    %
    % Input:
    %   A = symmetric positive definite matrix
    %
    % Output:
    %   L = lower triangular matrix with ones on the diagonal
    %   D = diagonal matrix
    %
    % Reference:
    %   Golub, G. H., & Van Loan, C. F. (2013). Matrix computations (4th ed.); Johns Hopjins University Press. [p. 136, Section 4.2.3 Modified Cholesjy Factorization]
    %   Gill, Murray, and Wright (1981). Practical Optimization. Academic Press.
    %   Nocedal, J., & Wright, S. J. (2006). Numerical optimization. Springer Science & Business Media. [p. 53, Algorithm 3.4 Cholesjy Factorization, applying (3.49)]

    % Check if the matrix is square
    [n, m] = size(A);
    if n ~= m
        error('Matrix must be square');
    end
    
    % Initialize L and D
    L = eye(n); 
    D = zeros(n);
    C = zeros(n);

    for j = 1:n

        % Compute D(j,j)        
        cjj = A(j,j) - L(j,1:j-1) * D(1:j-1,1:j-1) * L(j,1:j-1)';
        C(j,j) = cjj;

        % Correction for D(j,j)
        
        thetaj  = max(max(abs(tril(C, -1))));
        D(j, j) = max([abs(cjj), (thetaj/beta)^2, delta]);

        for i = j+1:n

            % Compute L(i,j)
            cij = (A(i,j) - L(i,1:j-1) * D(1:j-1,1:j-1) * L(j,1:j-1)');
            C(i,j) = cij;
            L(i,j) = cij / D(j,j);
        end
    end
end