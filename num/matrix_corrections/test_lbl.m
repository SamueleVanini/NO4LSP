clc; clear; close all;

%! TODO Also try LDL matlab factorization, it should apply the bunch kaufman criteria 

tol = 1e-8;

% Define matrices
matrixList = {
    [4, 1, 2; 1, 3, 0; 2, 0, 1], ...
    [4, 1, 2, 3; 1, 3, 0, 1; 2, 0, 1, 2; 3, 1, 2, 4], ...
    eye(4), ...
    diag([1, 2, 3, 4]), ...
};

% Run tests
for i = 1:length(matrixList)
    test(matrixList{i}, tol, i);
end

% Test function
function test(A, tol, test_num)
    [L, B, P, ~] = lbl(A);
    PAPt = P * A * P';
    LBLt = L * B * L';
    if norm(PAPt - LBLt, 'fro') < tol
        fprintf('Test %d passed\n', test_num);
    else
        fprintf('Test %d failed\n', test_num);
    end
    fprintf('P * A * P'':\n');
    disp(PAPt);
    fprintf('L * B * L'':\n');
    disp((LBLt));
end
