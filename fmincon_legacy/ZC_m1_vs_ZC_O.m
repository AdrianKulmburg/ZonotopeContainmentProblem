% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing ZC^O, ZC^{m1} and ST
methods = {@ZonotopeInZonotope_optimization, @ZonotopeInZonotope_vertexEnumeration, @ZonotopeInZonotope_st};

% This variable will allow us to check in which case ZC^O is false
total_discrepancies = 0;

% For each Z1_cycle, a different Z1 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z2_smaller 'smaller' zonotopes, and Z2_equal zonotopes of equal diameter
% than Z1, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_cycles = 5;
Z2_smaller = 10;
Z2_equal = 10;

% Parameters setting the dimensionality of the zonotopes
n = 5;
m1 = 10;

m2_range = n:5:200;

size_m2_range = size(m2_range, 2);

% Pre-allocating the space to store all the data from the computations
opt_point_data = {};
ver_point_data = {};
st_point_data = {};
for i_m2 = 1:size_m2_range
    % corresponds to the minimum, mean, maximum, and then all the
    % data-points
    opt_point_data{i_m2} = {NaN, NaN, NaN, zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)]), zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)])};
    ver_point_data{i_m2} = {NaN, NaN, NaN, zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)]), zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)])};
    st_point_data{i_m2} = {NaN, NaN, NaN, zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)]), zeros([1 Z1_cycles*(Z2_smaller+Z2_equal)])};
end

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
for i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2);
    disp(m2)

    full_data = main_operation(n, m2, m1, methods, Z1_cycles, Z2_smaller, Z2_equal);
    
    opt_times_smaller = full_data{1}{1};
    opt_times_equal = full_data{3}{1};
    opt_times_total = [opt_times_smaller opt_times_equal];
    
    opt_mean = mean2(opt_times_total);
    opt_max = max(max(opt_times_total));
    opt_min = min(min(opt_times_total));
    
    opt_points_y = reshape(opt_times_total, 1, []);
    opt_points_x = ones(size(opt_points_y)) .* m2;
    
    opt_point_data{i_m2}{1} = opt_min;
    opt_point_data{i_m2}{2} = opt_mean;
    opt_point_data{i_m2}{3} = opt_max;
    opt_point_data{i_m2}{4} = opt_points_x;
    opt_point_data{i_m2}{5} = opt_points_y;
    total_discrepancies = total_discrepancies + sum(sum(full_data{2}{1})) + sum(sum(full_data{4}{1}));
    
    ver_times_smaller = full_data{1}{2};
    ver_times_equal = full_data{3}{2};
    ver_times_total = [ver_times_smaller ver_times_equal];
    
    ver_mean = mean2(ver_times_total);
    ver_max = max(max(ver_times_total));
    ver_min = min(min(ver_times_total));
    
    ver_points_y = reshape(ver_times_total, 1, []);
    ver_points_x = ones(size(ver_points_y)) .* m2;
    
    ver_point_data{i_m2}{1} = ver_min;
    ver_point_data{i_m2}{2} = ver_mean;
    ver_point_data{i_m2}{3} = ver_max;
    ver_point_data{i_m2}{4} = ver_points_x;
    ver_point_data{i_m2}{5} = ver_points_y;
    
    st_times_smaller = full_data{1}{3};
    st_times_equal = full_data{3}{3};
    st_times_total = [st_times_smaller st_times_equal];

    st_mean = mean2(st_times_total);
    st_max = max(max(st_times_total));
    st_min = min(min(st_times_total));

    st_points_y = reshape(st_times_total, 1, []);
    st_points_x = ones(size(st_points_y)) .* m2;

    st_point_data{i_m2}{1} = st_min;
    st_point_data{i_m2}{2} = st_mean;
    st_point_data{i_m2}{3} = st_max;
    st_point_data{i_m2}{4} = st_points_x;
    st_point_data{i_m2}{5} = st_points_y;
end

% Saving the whole data for later use
save('ZC_m1_vs_ZC_O.mat')