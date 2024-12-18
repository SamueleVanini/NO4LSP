function HessF = chained_rosenbrock_hess(x)
    % CHAINED_ROSENBROCK_HESS Hessian of the Chained Rosenbrock function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   HessF : (n x n) Hessian matrix (tri-diagonal)

    n = length(x);
    HessF = zeros(n, n);

    % Diagonal elements (i = j)
    for i = 1:n
        if i == n
            HessF(i, i) = 200;
        else
            HessF(i, i) = 1200 * x(i)^2 - 400 * x(i+1) + 2;
        end
    end

    % Sub-diagonal elements (i ~= j, |i - j| <= 1)
    for i = 1:n-1
        HessF(i, i+1) = -400 * x(i);
        HessF(i+1, i) = -400 * x(i);
    end
end
