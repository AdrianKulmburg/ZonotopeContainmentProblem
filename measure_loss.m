function measure_loss(n_range, name)

% Setting RNG for the sake of reproducibility
rng(123456);

iterations = 10000;

% Generate Input. This could take a while, but it allows us to then use
% parallel computing for the solutions.
disp('Now generating input...')
input = generate_input(n_range, iterations);
disp('Finished.')
losses = main_step(n_range, iterations, input);
save(name);
disp('Ended all computations.')    
end

function input = generate_input(n_range, iterations)
    n_size = size(n_range, 2);
    
    upper_adaptive_limit = 5;
    
    input = {};
    
    for i = 1:n_size
        n = n_range(i);
        iter = {};
        for j = 1:iterations
            % Random number of generators
            m1 = randi([n n+upper_adaptive_limit]);
            m2 = randi([n n+upper_adaptive_limit]);
            
            % Now generating the zonotopes
            % The 'outer' zonotope is centred at the origin
            c1 = zeros([n 1]);
            
            G1 = 2.*rand([n m1]) - 1; % Uniform sampling between -1 and 1

            % Ideally, Z1 should be non-degenerate; if it is not, we just keep
            % searching for a Z1 that is.
            while rank(G1) ~= n
                G1 = 2.*rand([n m1]) - 1;
            end
            
            % Now, for the second zonotope
            c2 = zeros([n 1]);
     
            G2 = 2.*rand([n m2]) - 1; % Uniform sampling between -1 and 1
            
            % Saving the data
            data{1} = c1;
            data{2} = G1;
            data{3} = c2;
            data{4} = G2;
            iter{j} = data;
        end
        input{i} = iter;
    end
end
            
            

function losses = main_step(n_range, iterations, input)
    n_size = size(n_range, 2);
    
    losses = {};
    
    % Preallocating
    for i = 1:n_size
        losses_iter = {};
        for j = 1:iterations
            losses_iter{j} = 0;
        end
        losses{i} = losses_iter;
    end

    for i = 1:n_size
        iter = input{i};
        
        losses_iter = {};
        st_loss = [];
        opt_loss = [];
        parfor j = 1:iterations
            disp([num2str(i), ' - ', num2str(j)])
            data = iter{j};
            c1 = data{1};
            G1 = data{2};
            c2 = data{3};
            G2 = data{4};
            [L_st, L_opt] = loss(c1, G1, c2, G2);
            losses_iter{j} = [L_st L_opt];
            %st_loss = [st_loss L_st];
            %opt_loss = [opt_loss L_opt];
            
            %st_res = [num2str(mean(st_loss)*1000), '+-',num2str(std(st_loss)*1000)];
            %opt_res = [num2str(mean(opt_loss)*1000), '+-',num2str(std(opt_loss)*1000)];
            %disp([num2str(n_range(i)), ' - ', num2str(j), ' now has ST: ', st_res, ' and OPT: ', opt_res])
        end
        losses{i} = losses_iter;
    end
end
    
