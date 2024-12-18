function f = rosenbrock(x)
    % ROSENBROCK Function definition
    % Input:
    %   x : 2-dimensional vector [x1; x2]
    % Output:
    %   f : function value at x
    
    x1 = x(1);
    x2 = x(2);
    f = 100*(x2 - x1^2)^2 + (1 - x1)^2;
end
