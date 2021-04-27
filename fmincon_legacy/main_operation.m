% This script contains the main operation to check the different
% implementations, that is to say that it measures the time needed be every
% algorithm for each zonotope-pair that is to be tested.

function full_data = main_operation(n, m1, m2, methods, Z1_cycles, Z2_smaller, Z2_equal)

    n_methods = size(methods, 2);
    
    times_smaller = {};
    times_equal = {};
    discrepancies_smaller = {};
    discrepancies_equal = {};
    
    % Pre-allocating the space needed for the results
    for i = 1:n_methods
        times_smaller{i} = zeros([Z1_cycles Z2_smaller]); % So Z1 dictates the rows, Z2 the columns
        times_equal{i} = zeros([Z1_cycles Z2_smaller]);
        
        discrepancies_smaller{i} = zeros([Z1_cycles Z2_smaller]);
        discrepancies_equal{i} = zeros([Z1_cycles Z2_smaller]);
    end
        
    for z1 = 1:Z1_cycles
        
        G1 = rand([n m1]) - 0.5;
        g1 = max(sum(abs(G1), 2));
        G1 = G1 ./ g1;
        
        % Ideally, Z1 should be non-degenerate; if it is not, we just keep
        % searching for a Z1 that is.
        while rank(G1) ~= n
            G1 = rand([n m1]) - 0.5;
            g1 = max(sum(abs(G1), 2));
            G1 = G1 ./ g1;
        end
        
        c1 = zeros([n 1]);
        
        
        % Now computing the smaller Z2 zonotopes
        for z2 = 1:Z2_smaller
            G2 = (rand([n m2])-0.5);
            g2 = max(sum(abs(G2), 2));
            G2 = G2 ./ (g2*10);
            
            c2 = 2*(rand([n 1]) - 0.5);
            
           
            
            [times, results] = compute_methods(c1, G1, c2, G2, methods);
            
            standard = results(1);
            
            for i = 1:n_methods
                times_smaller{i}(z1,z2) = times(i);
                if standard ~= results(i)
                    discrepancies_smaller{i}(z1,z2) = 1;
                end
            end
        end
        
        
        
        % Now computing the larger Z2 zonotopes
        for z2 = 1:Z2_equal
            G2 = (rand([n m2])-0.5);
            g2 = max(sum(abs(G2), 2));
            G2 = G2 ./ g2;
            
            c2 = zeros([n 1]);
            
            [times, results] = compute_methods(c1, G1, c2, G2, methods);
            
            standard = results(1);
            
            for i = 1:n_methods
                times_equal{i}(z1,z2) = times(i);
                if standard ~= results(i)
                    discrepancies_equal{i}(z1,z2) = 1;
                end
            end
        end
    end
    
    full_data = {times_smaller, discrepancies_smaller, times_equal, discrepancies_equal};

end


function [times, results] = compute_methods(c1, G1, c2, G2, methods)
    times = zeros(size(methods));
    results = zeros(size(methods));
    
    n_methods = size(methods, 2);
    
    for i = 1:n_methods
        tic;
        results(i) = methods{i}(c1, G1, c2, G2);
        times(i) = toc;
    end
end
    
    