    function [xk, fk, gradfk_norm, k, failure, flag, xseq, btseq, corrseq, fseq, gradnormseq] = ...
        modifiedNM(...
        f, gradf, Hessf, x0, kmax, tolgrad, ...
        c1, rho, btmax, precond, h, specific_approx, hess_approx, correction_technique, varargin)
    %   MODIFIEDNM Modified Newton's Method with Hessian Correction Techniques
    %
    %   This function solves unconstrained optimization problems using
    %   modified Newton's method with various Hessian correction
    %   techniques to handle non-positive definite Hessians.
    %
    %   Syntax:
    %   [xk, fk, gradfk_norm, k, failure, flag, xseq, btseq, corrseq, fseq, gradnormseq] = ...
    %       modifiedNM(f, gradf, Hessf, x0, kmax, tolgrad, ...
    %       c1, rho, btmax, precond, h, specific_approx, hess_approx, correction_technique, varargin)
    %
    %   Input Parameters:
    %       - f                  : Function handle for the objective function.
    %       - gradf              : Function handle for the gradient of the objective function.
    %       - Hessf              : Function handle for the Hessian of the objective function (or empty for approximation).
    %       - x0                 : Initial guess for the solution.
    %       - kmax               : Maximum number of iterations.
    %       - tolgrad            : Tolerance for the norm of the gradient.
    %       - c1                 : Armijo condition parameter (0 < c1 < 1).
    %       - rho                : Backtracking step reduction factor (0 < rho < 1).
    %       - btmax              : Maximum number of backtracking steps.
    %       - precond            : Boolean indicating whether to use preconditioning.
    %       - h                  : Step size for numerical Hessian approximation (if needed).
    %       - specific_approx    : Boolean indicating usage of gradient of f for exact Hessian approximation.
    %       - hess_approx        : Function handle for Hessian approximation (ignored if Hessf is not empty).
    %       - correction_technique : String specifying the correction method among {'spectral', 'thresh', 'diag', 'modLDL'}.
    %       - varargin           : Additional parameters for the chosen correction technique.
    %
    %   Correction Parameters:
    %       - 'spectral': Tolerance for spectral shifting ('toleig').
    %       - 'thresh'  : Tolerance for eigenvalue thresholding ('toleig').
    %       - 'diag'    : Tolerance and maximum iterations ('toleig', 'maxit').
    %       - 'modLDL'  : Tolerance for modified LDL decomposition ('toleig').
    %
    %   Output Parameters:
    %       - xk                 : Final solution vector.
    %       - fk                 : Objective function value at the solution.
    %       - gradfk_norm        : Norm of the gradient at the solution.
    %       - k                  : Total number of iterations performed.
    %       - failure            : Boolean indicating whether the method failed.
    %       - flag               : Message describing the termination condition.
    %       - xseq               : Sequence of solution vectors across iterations.
    %       - btseq              : Sequence of backtracking step counts.
    %       - corrseq            : Sequence of corrections applied to the Hessian.
    %       - fseq               : Sequence of objective function values across iterations.
    %       - gradnormseq        : Sequence of gradient norms across iterations.
    %
    %
    %   Notes:
    %       - If Hessf is empty, numerical approximation of the Hessian is used.
    %       - Correction techniques preserve sparsity when applied.
    
    % Parse additional parameters from varargin
    correction_params = varargin;

    % Import all various matrix corrections
    addpath(fullfile(pwd, 'matrix_corrections/'));

    % Define function handle for correction, based on the user choice
    switch correction_technique
        case 'spectral'
            correction = @(X) spectral_shifting_correction(X, correction_params{:});
        case 'thresh'
            correction = @(X) eigenvalue_thresholding_correction(X, correction_params{:});
        case 'diag'
            correction = @(X) diagonal_loading_correction(X, correction_params{:});
        case 'modLDL'
            correction = @(X) modified_ldl_correction(X, correction_params{:});
        otherwise
            error('Unknown correction technique: %s', correction_technique);
    end

    % Function handle for the armijo condition
    farmijo = @(fk, alpha, c1_gradfk_pk) ...
        fk + alpha * c1_gradfk_pk;

    % Solution sequence tracking variable initialization
    xseq = zeros(length(x0), kmax);
    btseq = zeros(1, kmax);
    corrseq = zeros(1, kmax);
    fseq = zeros(1, kmax);
    gradnormseq = zeros(1, kmax);

    % Failure traickig variables initialization
    flag = '';
    failure = false;

    % Starting values initialization
    k = 0;
    xk = x0;
    fk = f(xk);
    gradfk = gradf(xk);
    gradfk_norm = norm(gradfk);

    fseq(1) = fk;
    gradnormseq(1) = gradfk_norm;

    % Check whetere to use hessian approximation or not
    if isempty(Hessf)
        % If specific_approx = true, the function will exploit the exact gradient of f
        Hessf = @(x) hess_approx(x, h, specific_approx, gradf, gradfk);
    end
    
    % Stop when stopping criteria is met
    while k < kmax && gradfk_norm >= tolgrad

        % Compute Hessian (sparse)
        Hk = Hessf(xk);

        try
            Bk = Hk;
            R = ichol(Bk); % Attempt (incomplete) Cholesky factorization, if not P.D. error will raise
        catch
            % If it fails again then Bk is not P.D.
            Bk = correction(Hk); % Correct Bk using the choosen approach (will preserve sparsity)
            try 
                R = ichol(Bk); % Retry Cholesky, if still not P.D. error will raise
            catch
                failure = true;
                flag = 'Corrected matrix Bk is not S.P.D.';
                break;
            end
        end

        % If no precodition is required, ignore it (overwrite the cholesky factorization with empty matrix)
        if ~precond
            R = [];
        end

        % Continue with the common Newton method with backtracking
        [pk, ~, ~, ~, ~] = pcg(Bk, -gradfk, [], [], R, R');

        % Reset the value of alpha
        alpha = 1;

        % Compute the candidate new xk
        xnew = xk + alpha * pk;

        % Compute the value of f in the candidate new xk
        fnew = f(xnew);

        % Backtracking auxiliar variables
        c1_gradfk_pk = c1 * gradfk' * pk;
        bt = 0;
        
        % Backtracking strategy
        while bt < btmax && fnew > farmijo(fk, alpha, c1_gradfk_pk)
            % Reduce the value of alpha
            alpha = rho * alpha;
            
            % Update xnew and fnew w.r.t. the reduced alpha
            xnew = xk + alpha * pk;
            fnew = f(xnew);

            % Increase the counter by one
            bt = bt + 1;
        end
        
        % If backtracking met stopping criteria raise an error
        if bt == btmax && fnew > farmijo(fk, alpha, c1_gradfk_pk)
            flag = sprintf([...
                'Failure: Could not satisfy Armijo. ' ...
                'Details: ' ...
                '  Iteration: %d, ' ...
                '  New function value (fnew): %e, ' ...
                '  Armijo condition value: %e, ' ...
                '  Step length (alpha): %e' ...
                ], ...
                k, fnew, farmijo(fk, alpha, c1_gradfk_pk), alpha);
            failure = true;
            break;
        end

        % Update xk, fk, gradfk_norm
        xk = xnew;
        fk = fnew;
        gradfk = gradf(xk);
        gradfk_norm = norm(gradfk);

        % Increase the step by one
        k = k + 1;

        % Store current xk in xseq
        xseq(:, k) = xk;
        % Store bt iterations in btseq
        btseq(k) = bt;
        % Store the correction applied
        corrseq(k) = norm(Hk - Bk, 'fro');

        % Store function value
        fseq(k) = fk;
        % Store gradient norm value 
        gradnormseq(k) = gradfk_norm;
    end

    % Flag output
    if ~failure
        if gradfk_norm < tolgrad % Newton method converged
            flag = sprintf('Satysfied the tollerance in %d iteration', k);
        else % Newton method did not converge
            flag = sprintf(['Failure: mnm did %d iteration but did not converge. ' ...
                'Norm of the gradient = %.3g'], k, gradfk_norm);
            failure = true;
        end
    end

    % "Cut" xseq and btseq to the correct size
    xseq = xseq(:, 1:k);
    btseq = btseq(1:k);

    % "Add" x0 at the beginning of xseq (otherwise the first el. is x1)
    xseq = [x0, xseq];

    end