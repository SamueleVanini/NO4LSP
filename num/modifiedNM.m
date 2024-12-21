function [xk, fk, gradfk_norm, k, xseq, btseq] = ...
    modifiedNM(x0, f, gradf, Hessf, ...
    toleig, kmax, tolgrad, c1, rho, btmax)

% Function handle for the armijo condition
farmijo = @(fk, alpha, c1_gradfk_pk) ...
    fk + alpha * c1_gradfk_pk;

% Initializations
xseq = zeros(length(x0), kmax);
btseq = zeros(1, kmax);

xk = x0;
fk = f(xk);
gradfk = gradf(xk);
k = 0;
gradfk_norm = norm(gradfk);

while k < kmax && gradfk_norm >= tolgrad
    
    % Define Bk
    Bk = Hessf(xk);

    % Check that Bk is sufficiently P.D. (eig() or Cholesky fact chol())
    smallest_eig_k = eigs(Bk, 1, 'smallestreal'); % TODO choose the method for P.D. check
    if smallest_eig_k < toleig
        % apply Ek = tauk * I as in noted ()
        tauk = max(0, toleig - smallest_eig_k);
        Ek = tauk * eye(size(Bk));
        Bk = Bk + Ek; % TODO try different hessian corrections
    end
    
    % Continue with the common newton method with backtracking
    [pk, ~, ~, ~, ~] = pcg(Bk, -gradfk);
    
    % Reset the value of alpha
    alpha = 1;
    
    % Compute the candidate new xk
    xnew = xk + alpha * pk;
    
    % Compute the value of f in the candidate new xk
    fnew = f(xnew);
    
    c1_gradfk_pk = c1 * gradfk' * pk;
    bt = 0;
    % Backtracking strategy: 
    % 2nd condition is the Armijo condition not satisfied
    while bt < btmax && fnew > farmijo(fk, alpha, c1_gradfk_pk)
        % Reduce the value of alpha
        alpha = rho * alpha;
        % Update xnew and fnew w.r.t. the reduced alpha
        xnew = xk + alpha * pk;
        fnew = f(xnew);
        
        % Increase the counter by one
        bt = bt + 1;
    end
    if bt == btmax && fnew > farmijo(fk, alpha, c1_gradfk_pk)
        error(['Could not find a good step length during backtracking.\n' ...
               'Details:\n' ...
               '  Iteration: %d\n' ...
               '  Current function value (fk): %e\n' ...
               '  New function value (fnew): %e\n' ...
               '  Armijo condition value: %e\n' ...
               '  Step length (alpha): %e\n' ...
               '  Gradient dot product (c1_gradfk_pk): %e\n' ...
               '  Backtracking steps: %d\n'], ...
               k, fk, fnew, farmijo(fk, alpha, c1_gradfk_pk), alpha, c1_gradfk_pk, bt);
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
end

% "Cut" xseq and btseq to the correct size
xseq = xseq(:, 1:k);
btseq = btseq(1:k);

% "Add" x0 at the beginning of xseq (otherwise the first el. is x1)
xseq = [x0, xseq];

end