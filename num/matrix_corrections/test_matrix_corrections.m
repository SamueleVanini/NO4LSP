% Clear the workspace and command window
clc; clear; close all;

H = [1 -2; -2 1]; % Example non-positive definite matrix
toleig = 1e-6; % Tolerance for eigenvalues
beta = 0.1; % Regularization parameter for modified LDL decomposition
delta = 1e-6; % Regularization parameter for modified LDL decomposition

Bk_diag = diagonal_loading_correction(H, toleig);
Bk_tresh = eigenvalue_tresholding_correction(H, toleig);
Bk_spectral = spectral_shifting_correction(H, toleig);
Bk_modLDL = modified_ldl_correction(H, beta, delta);

% Display the corrected matrices and their difference norms
disp('Original H:');
disp(H);
fprintf('Is H Positive Definite? %s\n', is_positive_definite(H));
fprintf('\n\n');

disp('Diagonal Loading Correction:');
display_and_check(H, Bk_diag);
fprintf('\n\n');

disp('Nearest Positive Definite Correction:');
display_and_check(H, Bk_tresh);
fprintf('\n\n');

disp('Spectral Shifting Correction:');
display_and_check(H, Bk_spectral);
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