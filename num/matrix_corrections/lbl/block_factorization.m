function [L, B, C, H] = block_factorization(A, E)
    
    % Check if the input matrix is square
    [m, n] = size(A);
    if m ~= n
        error('Input matrix must be square');
    end
    
    % Extract the size of the block E
    [p, q] = size(E);
    if p ~= q
        error('Block E must be square.');
    end
    
    % Verify that E is part of A
    if ~isequal(A(1:p, 1:p), E)
        error('Block E must match the top-left block of A.');
    end

    C = A(p+1:end, 1:p);
    H = A(p+1:end, p+1:end);

    % TODO: Optimize inverse computation
    L11 = eye(p);
    L12 = zeros(p, m-p);
    L21 = C * inv(E);
    L22 = eye(m-p);
    L = [L11, L12; L21, L22];
    
    C11 = E;
    C12 = zeros(p, m-p);
    C21 = zeros(m-p, p);
    C22 = H - C * inv(E) * C'; % Schur complement
    B = [C11, C12; C21, C22];
end