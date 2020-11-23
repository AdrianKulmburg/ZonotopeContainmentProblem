function [isIn, r, r_sols] = pointInZonotope(p, c, G)
    % Vanilla pointInZonotope method.
    
    % Not an expert in default parameters yet, that's why for now I don't
    % put it into the function definition itself:
    tol = 1e-10;
    % @@@ Should be changed ASAP!!! Change also in the MP version! @@@
    
    n = size(G, 1);
    m = size(G, 2);
    
    f = [1;zeros([m 1])];
    
    Aeq = [zeros([n 1]) G];
    beq = p - c;
    
    Aineq1 = [-ones([m 1]) eye(m)];
    Aineq2 = [-ones([m 1]) -eye(m)];
    
    Aineq = [Aineq1; Aineq2];
    bineq = zeros([2*m 1]);
    
    options = optimoptions('linprog', 'Display', 'none');
    
    x = linprog(f, Aineq, bineq, Aeq, beq, [], [], options);
    
    r_sols = x(2:m+1);
    r = x(1);
    isIn = r <= 1 + tol;
end    