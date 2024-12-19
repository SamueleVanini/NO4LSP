function g = rosenbrock_grad(x)
    % ROSENBROCK_GRAD Gradient of the Rosenbrock function
    % Input:
    %   x : 2-dimensional vector [x1; x2]
    % Output:
    %   g : gradient vector [g1; g2]
    
    x1 = x(1);
    x2 = x(2);
    
    g1 = -400*x1*(x2 - x1^2) - 2*(1 - x1);
    g2 = 200*(x2 - x1^2);
    
    g = [g1; g2];
end
