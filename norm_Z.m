function r = norm_Z(p, G)
    n = size(G, 1);
    [isIn, r, r_sols] = pointInZonotope(p, zeros([n 1]), G);
end