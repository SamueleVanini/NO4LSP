% Clear the workspace and command window
clc; clear; close all;

H = [1 -2; -2 1]; % Example non-positive definite matrix

toleig = 1e-6; % Tolerance for eigenvalues

gamma = []; % Scaling factor for diagonal loading 

beta = 0.1; % Regularization parameter for modified LDL decomposition
delta = 1e-6; % Regularization parameter for modified LDL decomposition

Bk_spectral = minimal_eigenvalue_correction(H, toleig);
Bk_tresh = diagonalization_correction(H, toleig);
Bk_diag = diagonal_loading_correction(H, gamma, toleig);
Bk_modLDL = modified_ldl_correction(H, beta, delta);

% Display the corrected matrices and their difference norms
disp('Original H:');
disp(H);
fprintf('Is H Positive Definite? %s\n', is_positive_definite(H));
fprintf('\n\n');

disp('Minimal Eigenvalue Correction:');
display_and_check(H, Bk_spectral);
fprintf('\n\n');

disp('Diagonalization Correction:');
display_and_check(H, Bk_tresh);
fprintf('\n\n');

disp('Diagonal Loading Correction:');
display_and_check(H, Bk_diag);
fprintf('\n\n');

disp('Modified LDL Correction:');
display_and_check(H, Bk_modLDL);
fprintf('\n\n');

function display_and_check(H, Bk)
    disp(Bk);
    disp(['Norm of Difference: ', num2str(norm(Bk - H, 'fro'))]);
    fprintf('Is Bk Positive Definite? %s\n', is_positive_definite(Bk));
    fprintf('\n\n');
end

function isPD = is_positive_definite(A)
    try
        chol(A);
        isPD = 'true';
    catch
        isPD = 'false';
    end
end