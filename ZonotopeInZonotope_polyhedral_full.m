function maximum = ZonotopeInZonotope_polyhedral_full(c1, G1, c2, G2)
    % Polyhedral approach
    % @@@ Change what follows ASAP! @@@
    tol = 1e-12;
    % Ok, so again, the option argument should be put in the varargin
    % thingy, to check if the algorithm should run fully (check all the
    % minimizers etc), or if it should stop whenever it has been found that
    % containment is impossible or guaranteed.
    
    n = size(G1, 1);
    
    Z1 = halfspace(zonotope(zeros([n 1]), G1));
    Lambda = Z1.halfspace.H;
    d = Z1.halfspace.K;
    
    Lambda = Lambda ./ d;
    
    maximum = MVS_polyhedral_full(Lambda, [G2 c2-c1]);
    
    
    
    
end

       