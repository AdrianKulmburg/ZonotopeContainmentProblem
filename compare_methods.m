% This script contains the main operation to check the different
% implementations, that is to say that it measures the time needed be every
% algorithm for each zonotope-pair that is to be tested.

function data = compare_methods(n, m1, m2, methods, Z1_smaller, Z1_equal, Z2_cycles)

    n_methods = size(methods, 2);
    
    % We want to store the runtimes...
    runtimes_smaller = zeros([n_methods Z1_smaller Z2_cycles]); 
    runtimes_equal = zeros([n_methods Z1_equal Z2_cycles]);
    
    % ... and the potential errors of each method. The correct method is
    % always defined to be the first one, i.e., the results of the other
    % methods will be compared to those of the first one, which we refer to
    % 'standard' in the rest of this code.
    discrepancies_smaller = zeros([n_methods Z1_smaller Z2_cycles]);
    discrepancies_equal = zeros([n_methods Z1_equal Z2_cycles]);
        
    for z2 = 1:Z2_cycles
        
        % Generate and normalize a random generator-matrix for Z2
        G2 = 2.*(rand([n m2]) - 0.5);
        g2 = max(sum(abs(G2), 2));
        G2 = G2 ./ g2;
        
        % Ideally, Z2 should be non-degenerate; if it is not, we just keep
        % searching for a Z1 that is.
        while rank(G2) ~= n
            G2 = 2.*(rand([n m2]) - 0.5);
            g2 = max(sum(abs(G2), 2));
            G2 = G2 ./ g2;
        end
        
        % The center of Z2 is always the origin
        c2 = zeros([n 1]);
        Z2 = zonotope(c2, G2);
        
        % Now computing the smaller Z1 zonotopes
        for z1 = 1:Z1_smaller
            % The rank of G1 does not matter at much, so it does not need
            % to be checked
            G1 = 2.*(rand([n m1])-0.5);
            g1 = max(sum(abs(G1), 2));
            G1 = G1 ./ (g1*10);
            
            c1 = 0.2*(rand([n 1]) - 0.5);
            Z1 = zonotope(c1, G1);
            
           
            % Run the different methods on this zonotope-pair
            [times, results] = compute_methods(Z1, Z2, methods);
            
            % The first method is the standard
            standard = results(1);
            discrepancies_smaller(1,z1,z2) = standard; % We store the
            % correct result instead of the discrepancy for the first
            % method, so that we can track what was the solution
            
            for i = 1:n_methods
                runtimes_smaller(i,z1,z2) = times(i);
                if standard ~= results(i) % If there has been an error for 
                                          % method i, report it
                    discrepancies_smaller(i,z1,z2) = 1;
                end
            end
        end  
        
        % Now computing the larger Z1 zonotopes
        for z1 = 1:Z1_equal
            G1 = 2.*(rand([n m1])-0.5);
            g1 = max(sum(abs(G1), 2));
            G1 = G1 ./ g1;
            
            c1 = zeros([n 1]);
            Z1 = zonotope(c1, G1);
            
            [times, results] = compute_methods(Z1, Z2, methods);
            
            standard = results(1);
            discrepancies_smaller(1,z1,z2) = standard;
            
            for i = 1:n_methods
                runtimes_equal(i,z1,z2) = times(i);
                if standard ~= results(i)
                    discrepancies_equal(i,z1,z2) = 1;
                end
            end
        end
    end
    
    data = {runtimes_smaller, runtimes_equal, discrepancies_smaller, discrepancies_equal};

end


function [runtimes, results] = compute_methods(Z1, Z2, methods)
    runtimes = zeros(size(methods));
    results = zeros(size(methods));
    
    n_methods = size(methods, 2);
    
    for i = 1:n_methods
        tic;
        results(i) = zonotopeContainment(Z2, Z1, methods{i}, 0, 500);
        runtimes(i) = toc;
    end
end
    
    