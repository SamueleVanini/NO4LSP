function grad_f = grad_approx(f, x_bar, h, f_xbar, specific)
%GRAD_APPROX - approximate gradient of f using forward finite diff
% Input:
%   f - function handle
%   x_bar - point in which to approximate the gradient
%       row vector
%   f_xbar - f(x_bar) usually already computed
%       scalar
%   h - level of approximation
%       scalar
% Output:
%   grad_f - gradient of f in x_bar

n = length(x_bar);

grad_f = zeros(n, 1);

for i = 1:n
    he_i = zeros(n, 1);
    if specific
        he_i(i) = h*abs(x_bar(i));
    else
        he_i(i) = h;
    end
    

    grad_f(i) = (f(x_bar + he_i) - f_xbar)/h;
end

end