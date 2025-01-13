function gradF = problem_82_grad(x)
    %PROBLEM_82_GRAD Gradient of the Problem 82 function
    % Input:
    %   x : n-dimensional vector
    % Output:
    %   gradF : n-dimensional gradient vector

    n = length(x);
    cos_x = cos(x);
    sin_x = sin(x);

    gradF = zeros(n, 1);
    gradF(1) = x(1) - sin_x(1)*(cos_x(1) + x(2) - 1);
    
    for i = 2:n-1
        gradF(i) = cos_x(i-1) + x(i) - 1 - sin_x(i)*(cos_x(i) + x(i+1) - 1);
    end
    
    gradF(n) = cos_x(n-1) + x(n) - 1;
end