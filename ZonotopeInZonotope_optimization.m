function isIn = ZonotopeInZonotope_optimization(c1, G1, c2, G2)

    tol = 1e-10;
    
    
    
    m2 = size(G2, 2);
    norm_Z1 = @(p) norm_Z(p, G1);
    
    f = @(beta) -norm_Z1(G2 * beta + c2 - c1);
    
    options = optimoptions('fmincon', 'Display', 'none', 'OutputFcn', @outfun);
    
    x0 = zeros([m2 1]);
    if f(x0) > -tol
        % The two centers are too close to each other, resulting in an
        % error
        [g_max, i_g_max] = max(max(abs(G2)));
        x0(i_g_max) = 1;
    end
    
    [x, fval] = fmincon(f, x0, [], [], [], [], -ones([m2 1]), ones([m2 1]), [], options);
    
    m = -fval;
    if m > 1 + tol
        isIn = false;
    else
        isIn = true;
    end
    
    
end

function stop = outfun(x, optimValues, state)
    stop = false;
    tol = 1e-12;
    
    f = optimValues.fval;
    
    if abs(f) > 1 + tol;
        stop = true;
    end
    
end

       