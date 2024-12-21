% Clear the workspace and command window
clc; clear; close all;

H = [1 -2; -2 1]; % Example non-positive definite matrix
toleig = 1e-6; % Tolerance for eigenvalues
delta=1e-6;
lambda = 1.5;

Bk_diag = diagonal_loading_correction(H, toleig, 50000);
Bk_nearest = nearest_PD_correction(H, toleig);
Bk_spectral = spectral_shifting_correction(H, toleig);
Bk_lm = levenberg_marquardt_correction(H, lambda);

% Display the corrected matrices and their difference norms
disp('Original H:');
disp(H);
fprintf('Is H Positive Definite? %s\n', is_positive_definite(H));
fprintf('\n\n');

disp('Diagonal Loading Correction:');
display_and_check(H, Bk_diag);
fprintf('\n\n');

disp('Nearest Positive Definite Correction:');
display_and_check(H, Bk_nearest);
fprintf('\n\n');

disp('Spectral Shifting Correction:');
display_and_check(H, Bk_spectral);

disp('Levenberg-Marquardt Correction:');
display_and_check(H, Bk_lm);

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