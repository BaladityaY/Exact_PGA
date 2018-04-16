function [q] = expmap_Stiefel(x, v, n, p)


%   expmap_sphere maps the tangent vector v in T_{p}M to x on the unit
%   sphere.
%
%   x = expmap_sphere(p, v)
%
%   p and x are unit vectors (points on the unit sphere).
%   v is a tangent vector in T_{p}M.


if norm(v) < 1e-10
    q = x;
    return;
end

q = (eye(n)+reshape(v,n,n))*inv(eye(n)-reshape(v,n,n))*reshape(x,n,p);
q=reshape(q,n*p,1);
end

