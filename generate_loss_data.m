function generate_loss_data(n_range, name)
% Computes the loss of the containment problem for over 10000 zonotope-
% pairs. Since this takes an enourmous amount of time, even for a single
% dimension-iteration (i.e. one value of n_range), generate_loss_data is
% not setup to launch all the tests directly.

% Setting RNG for the sake of reproducibility
rng(123456);

iterations = 10000;

% Generate Input. This could take a while, but it allows us to then use
% parallel computing for the solutions.
disp('Now generating input...')
input = generate_input(n_range, iterations);
disp('Finished.')

% Now solving the containment problems
losses = main_step(n_range, iterations, input);
save(['data/losses/',name], 'losses');
disp('Ended all computations.')   

end

function input = generate_input(n_range, iterations)
    % Generates the zonotope pairs that will be solved later. This is done
    % separately, so as to make it possible to both be reproducible and
    % solvable in parallel later on
    n_size = size(n_range, 2);
    
    % The number of generator of Z1, Z2 is n+upper_adaptive_limit
    upper_adaptive_limit = 5;
    
    input = cell(n_size);
    for i = 1:n_size
        n = n_range(i);
        iter = cell(iterations);
        for j = 1:iterations
            % Random number of generators
            m1 = randi([n n+upper_adaptive_limit]);
            m2 = randi([n n+upper_adaptive_limit]);
            
            % Now generating the zonotopes
            % First, the 'inner' zonotope Z1
            c1 = zeros([n 1]);
     
            G1 = 2.*rand([n m1]) - 1; % Uniform sampling between -1 and 1
            
            % The, the 'outer' zonotope Z2
            c2 = zeros([n 1]);
            
            G2 = 2.*rand([n m2]) - 1; % Uniform sampling between -1 and 1

            % Ideally, Z2 should be non-degenerate; if it is not, we just 
            % keep searching for a Z2 that is.
            while rank(G2) ~= n
                G2 = 2.*rand([n m2]) - 1;
            end
            
            % Saving the data
            Z1 = zonotope(c1, G1);
            Z2 = zonotope(c2, G2);
            
            iter{j} = {Z1, Z2};
        end
        input{i} = iter;
    end
end
            
            

function losses = main_step(n_range, iterations, input)
    % Compute all zonotope containments
    n_size = size(n_range, 2);
    
    losses = zeros([n_size iterations 2]);

    for i = 1:n_size
        iter = input{i};
        parfor j = 1:iterations
            disp([num2str(i), ' - ', num2str(j)])
            
            data = iter{j};
            Z1 = data{1};
            Z2 = data{2};
            
            [L_st, L_opt] = loss(Z1, Z2);
            losses(i, j, :) = [L_st L_opt];
        end
    end
end

function [L_st, L_opt] = loss(Z1, Z2)
% Computes the loss for the 'opt' and 'approx' algorithms

% In theory, computing the loss should be done as follows:
% lambda_st = 1/zonotopeContainment_full(Z2, Z1, 'st');
% lambda_ver = 1/zonotopeContainment_full(Z2, Z1, 'polymax');
% lambda_opt = 1/zonotopeContainment_full(Z2, Z1, 'opt',500);
% 
% L_st = abs((lambda_ver - lambda_st)/lambda_ver);
% L_opt = abs((lambda_ver - lambda_opt)/lambda_ver);

% One can also do it this way, which leads to smaller floating point
% errors:
res_st = zonotopeContainment_full(Z2, Z1,'st');
res_exact = zonotopeContainment_full(Z2, Z1,'polymax');
res_opt = zonotopeContainment_full(Z2, Z1,'opt',500);

L_st = abs(1 - res_exact/res_st);
L_opt = abs(1 - res_exact/res_opt);
end
    
