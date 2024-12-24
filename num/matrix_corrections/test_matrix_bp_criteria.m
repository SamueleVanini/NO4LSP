% Define a symmetric matrix
A = [4, 2, 1;
     2, 6, 3;
     1, 3, 5];

% Set growth threshold
growth_threshold = 1.5;

% Call the function
E = bunch_parlett_criteria(A);

% Display the result
disp('Selected pivot block E:');
disp(E);
