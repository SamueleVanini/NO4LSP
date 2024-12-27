function HessF = extended_rosenbrock_hess(x)
    % EXTENDED_ROSENBROCK_HESS Hessian of the Extended Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (symm. tri-diagonal)

    % Dimension of input vector
    n = length(x);
    
    % Check that input dimension is even
    if mod(n, 2) ~= 0
        error('Input dimension n must be even for the Hessian of the Extended Rosenbrock function.');
    end
    
    % Initialize the diagonals vector
    main_diag = 100*ones(n, 1); % half of them are already 100
    off_diag = zeros(n - 1, 1); % half of them are already 0
    
    for i = 1:2:n-1
        k = i; % odd
        main_diag(k) = 600*x(k)^2 - 200*x(k+1) + 1;
        off_diag(k) = -200*x(k);

    % -- Already set, by definition --
        % k = i+1; % even
        % main_diag(k) = 100;
        % off_diag(k) = 0;
    end

    Bin = [[off_diag; 0], main_diag, [0; off_diag]];
    HessF = spdiags(Bin, [-1 0 1], n, n);    
end

% function HessF = extended_rosenbrock_hess(x)
%     % EXTENDED_ROSENBROCK_HESS Hessian of the Extended Rosenbrock function
%     % Input:
%     %   x : n-dimensional vector
%     % Output:
%     %   HessF : (n x n) Hessian matrix (symm. tri-diagonal)

%     % Dimension of input vector
%     n = length(x);
    
%     % Check that input dimension is even
%     if mod(n, 2) ~= 0
%         error('Input dimension n must be even for the Hessian of the Extended Rosenbrock function.');
%     end
    
%     % Preallocate Hessian matrix
%     HessF = zeros(n, n);
    
%     % Diagonal elements (i = j)
%     for i = 1:2:n-1
        
%         % Diagonal element HessF(i, i) (odd index)
%         HessF(i, i) = 600 * x(i)^2 - 200 * x(i+1) + 1;
        
%         % Diagonal element HessF(i+1, i+1) (even index)
%         HessF(i+1, i+1) = 100;
%     end
    
%     % Off-diagonal elements (symm. tri-diagonal)
%     for i = 1:n-1
%         temp = -200 * x(i);
%         HessF(i, i+1) = temp;
%         HessF(i+1, i) = temp;
%     end
    
% end
