function current_maximum = MVS_polyhedral(Lambda, V)
    % Computes the longest vector sum w.r.t. the polyhedral norm, as
    % described in
    % A. E. Baburin and A. V. Pyatkin "Polynomial Algorithms for Solving
    % the Vector Sum Problem", 2005
    tol = 1e-10; % The tolerance is to avoid numerical errors
    c = @(p) max([0 max(Lambda * p)]);

    M = sign(Lambda * V);

    n = size(M, 1);
    
    current_maximum = 0;
    
    for i = 1:n
        mu = M(i,:);
        maximum = c(S_V(V, mu));
        if maximum > current_maximum
            current_maximum = maximum;
        end
    end
end

function s = S_V(V, mu)
    % Computes the vector sum of vectors given by the columns of V, i.e.,
    % S_V = V(:,1) * mu(1) + ... + V(:,end) * mu(end) 
    l = size(V, 2);
    s = 0;
    for i = 1:l
        s = s + mu(i) * V(:,i);
    end
end