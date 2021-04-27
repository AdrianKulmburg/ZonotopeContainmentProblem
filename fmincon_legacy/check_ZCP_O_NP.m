% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing ZC^O and ST
methods = {@ZonotopeInZonotope_optimization, @ZonotopeInZonotope_st};

% Above n > 40, ST takes an overwhelming amount of time, so we just stop
% computing it past that point
cutoff = 40;

% For each Z1_cycle, a different Z1 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z2_smaller 'smaller' zonotopes, and Z2_equal zonotopes of equal diameter
% than Z1, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_cycles = 5;
Z2_smaller = 10;
Z2_equal = 10;

% Parameters setting the dimensionality of the zonotopes
n_range = 5:130;
m1_range = n_range.*2;
m2_range = n_range.*2;

cutoff_n_limit = find(n_range >= cutoff);

size_n_range = size(n_range, 2);

% Pre-allocating the space to store all the data from the computations
opt_point_data = {};
st_point_data = {};
for i_n = 1:size_n_range
    % corresponds to the minimum, mean, maximum, and then all the
    % data-points
    opt_point_data{i_n} = {NaN, NaN, NaN, zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)]), zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)])};
    if n_range(i_n) <= cutoff
        st_point_data{i_n} = {NaN, NaN, NaN, zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)]), zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)])};
    end
end

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
for i_n = 1:size_n_range
    n = n_range(i_n);
    m1 = m1_range(i_n);
    m2 = m2_range(i_n);
    disp(n)
    
    methods_final = methods;
    if n > cutoff
        methods_final = {@ZonotopeInZonotope_optimization};
    end

    full_data = main_operation(n, m2, m1, methods_final, Z1_cycles, Z2_smaller, Z2_equal);
    
    opt_times_smaller = full_data{1}{1};
    opt_times_equal = full_data{3}{1};
    opt_times_total = [opt_times_smaller opt_times_equal];
    
    opt_mean = mean2(opt_times_total);
    opt_max = max(max(opt_times_total));
    opt_min = min(min(opt_times_total));
    
    opt_points_y = reshape(opt_times_total, 1, []);
    opt_points_x = ones(size(opt_points_y)) .* n;
    
    opt_point_data{i_n}{1} = opt_min;
    opt_point_data{i_n}{2} = opt_mean;
    opt_point_data{i_n}{3} = opt_max;
    opt_point_data{i_n}{4} = opt_points_x;
    opt_point_data{i_n}{5} = opt_points_y;
    
    if n <= cutoff
        st_times_smaller = full_data{1}{2};
        st_times_equal = full_data{3}{2};
        st_times_total = [st_times_smaller st_times_equal];
        
        st_mean = mean2(st_times_total);
        st_max = max(max(st_times_total));
        st_min = min(min(st_times_total));
        
        st_points_y = reshape(st_times_total, 1, []);
        st_points_x = ones(size(st_points_y)) .* n;
        
        st_point_data{i_n}{1} = st_min;
        st_point_data{i_n}{2} = st_mean;
        st_point_data{i_n}{3} = st_max;
        st_point_data{i_n}{4} = st_points_x;
        st_point_data{i_n}{5} = st_points_y;
    end
end

% Saving the whole data for later use
save('check_ZCP_O_NP.mat')