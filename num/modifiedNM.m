    function [xk, fk, gradfk_norm, k, failure, flag, xseq, btseq, corrseq, fseq, gradnormseq] = ...
        modifiedNM(...
        f, gradf, Hessf, x0, kmax, tolgrad, ...
        c1, rho, btmax, precond, h, specific_approx, hess_approx, correction_technique, varargin)
    % Modified Newton's Method with various Hessian correction techniques
    %
    % The function expects the following correction parameters to be passed via varargin:
    %
    % For 'spectral' correction (recomended):
    %   - toleig: tolerance for the correction
    %
    % For 'thresh' correction:
    %   - toleig: tolerance for the correction
    %
    % For 'diag' correction:
    %   - toleig: tolerance for the correction
    %   - maxit:  maximum iterations allowed for the correction
    %
    % For 'modLDL' correction:
    %   - toleig: tolerance for the correction
    
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

        % If no precodition is required, ignore it
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
        if gradfk_norm < tolgrad
            flag = sprintf('Satysfied the tollerance in %d iteration', k);
        else
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