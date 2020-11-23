function current_maximum = MVS_polyhedral(Lambda, V)
    tol = 1e-10;
    c = @(p) max([0 max(Lambda * p)]);

    M = sign(Lambda * V);

    n = size(M, 1);
    
    current_maximum = 0;
    
    for i = 1:n
        mu = M(i,:);
        maximum = c(S_V(V, mu));
        if maximum > current_maximum
            current_maximum = maximum;
            if maximum > 1 - tol
                return
            end
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