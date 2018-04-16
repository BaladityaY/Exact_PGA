function [v] = logmap_SO(p, x)


%   logmap_sphere maps x on sphere to the tangent space T_{p}M.
%
%   v = logmap_sphere(p, x)
%
%   p and x are unit vectors (points on the unit sphere).
%   v is a tangent vector in T_{p}M.


if norm(p - x) < 1e-10
    v = zeros(size(p));
    return;
end

v = logm(reshape(p, sqrt(length(p)), sqrt(length(p)))'*reshape(x, sqrt(length(p)), sqrt(length(p))));
v = reshape(v,sqrt(length(p))*sqrt(length(p)),1);

end

