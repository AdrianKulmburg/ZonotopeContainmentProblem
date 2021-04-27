function r = norm_Z(p, G)
    % Computes the zonotope-norm of a point p, w.r.t. the zonotope given by
    % the generator matrix G
    n = size(G, 1);
    [isIn, r, r_sols] = pointInZonotope(p, zeros([n 1]), G);
end