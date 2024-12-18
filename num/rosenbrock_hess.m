function H = rosenbrock_hess(x)
    % ROSENBROCK_HESS Hessian of the Rosenbrock function
    % Input:
    %   x : 2-dimensional vector [x1; x2]
    % Output:
    %   H : Hessian matrix (2x2)
    
    x1 = x(1);
    x2 = x(2);
    
    H11 = 1200*x1^2 - 400*x2 + 2;
    H12 = -400*x1;
    H21 = -400*x1;
    H22 = 200;
    
    H = [H11, H12; H21, H22];
end
