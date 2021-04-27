function res = ZonotopeInZonotope_vertexEnumeration_full(c1, G1, c2, G2)
    % Vertex enumeration
    tol = 1e-12;

    V = [G2 c2-c1];
    
    norm_Z1 = @(p) norm_Z(p, G1);
    
    res = max_SV(V, norm_Z1);
    
    
    
    
end


function res = max_SV(V, norm)
    tol = 1e-10;
    mu_dim = size(V, 2);
    res = 0;
    M = dec2bin(0:2^mu_dim-1)-'0';
    M = 2*(M - 0.5);
    mu = [];
    
    for m = M'
        r = norm(S_V(V, m'));
        if r > res
            res = r;
            mu = m;
        end
    end
end

function s = S_V(V, mu)
    l = size(V, 2);
    s = 0;
    for i = 1:l
        s = s + mu(i) * V(:,i);
    end
end