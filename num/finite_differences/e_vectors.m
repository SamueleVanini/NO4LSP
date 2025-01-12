function [e1, e2, e3] = e_vectors(n, h)
%E_VECTORS Create perturbation vectors

e1 = zeros(n, 1);
e2 = zeros(n, 1);
e3 = zeros(n, 1);

e1(1:3:n) = h(1:3:n);
e2(2:3:n) = h(2:3:n);
e3(3:3:n) = h(3:3:n);
end