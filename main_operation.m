function [mean_times, min_times, max_times, discrepancies] = main_operation(n, m1, m2, methods, Z1_cycles, Z2_smaller, Z2_equal)

    n_methods = size(methods, 2);
    max_times = zeros(size(methods));
    min_times = zeros(size(methods)) + inf;
    total_times = zeros(size(methods));
    discrepancies = 0;
    
    for z1 = 1:Z1_cycles
        
        G1 = rand([n m1]) - 0.5;
        g1 = max(sum(abs(G1), 2));
        G1 = G1 ./ g1;
        
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
            discrepancy_found = false;
            
            for i = 1:n_methods
                max_times(i) = max(max_times(i), times(i));
                min_times(i) = min(min_times(i), times(i));
                total_times(i) = total_times(i) + times(i);
                if standard ~= results(i) && not(discrepancy_found)
                    discrepancy_found = true;
                    discrepancies = discrepancies + 1;
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
            discrepancy_found = false;
            
            for i = 1:n_methods
                max_times(i) = max(max_times(i), times(i));
                min_times(i) = min(min_times(i), times(i));
                total_times(i) = total_times(i) + times(i);
                if standard ~= results(i) && not(discrepancy_found)
                    discrepancy_found = true;
                    discrepancies = discrepancies + 1;
                end
            end
            
        end
    end
    
    mean_times = total_times./(Z1_cycles * (Z2_smaller + Z2_equal));

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
    
    