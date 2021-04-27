function res = ZonotopeInZonotope_optimization_full(c1, G1, c2, G2)
    % Optimization approach
    tol = 1e-12;
    
    
    
    m2 = size(G2, 2);
    norm_Z1 = @(p) norm_Z(p, G1);
    
    f = @(beta) -norm_Z1(G2 * beta' + c2 - c1);
    
    %options = optimoptions('fmincon', 'Display', 'none', 'ConstraintTolerance', 1e-12, 'OptimalityTolerance', 1e-12);
    
%     x0 = zeros([m2 1]);
%     if f(x0) > -tol
%         % The two centers are too close to each other, resulting in an
%         % error
%         [g_max, i_g_max] = max(max(abs(G2)));
%         x0(i_g_max) = 1;
%     end
    
%     [x, fval] = fmincon(f, x0, [], [], [], [], -ones([m2 1]), ones([m2 1]), [], options);
%    
    options = optimoptions('surrogateopt', 'Display', 'none', 'PlotFcn', [], 'MaxFunctionEvaluations', 500);
    
    [x, fval] = surrogateopt(f, -ones([m2 1])', ones([m2 1])', ones([m2 1])', options);
    res = -fval;
    
    
end


       
