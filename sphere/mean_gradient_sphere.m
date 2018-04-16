function [mean_grad] = mean_gradient_sphere(t, theta, xj)

%   ...Dimension... %
N = length(t);

%   ...Initialization...    %
mean_grad = 0;
idx = xj + 1 : N;

%   ...Check if 'mean_grad' is zero...  %
if (t(xj) == 0) || (sum(abs(theta([xj, idx]))) == 0) || (prod(1 - t(idx)) == 0)
    return;
end

%   ...Compute gradient of the mean w.r.t. the j-th point...    %
mean_grad = 1;
if xj ~= 1
    mean_grad = sin(t(xj) * theta(xj))/ sin(theta(xj));
end
mean_grad = mean_grad * prod(sin((1 - t(idx)) .* theta(idx))./ sin(theta(idx)));

end

