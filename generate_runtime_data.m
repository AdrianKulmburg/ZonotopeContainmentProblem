function generate_runtime_data(job)
% Auxilliary function meant to choose which data has to be generated. This
% file only exists to make the repository less crowded.
switch job
    case 'all'
        generate_m1();
        generate_m2();
        generate_n();
        generate_o_st();
    case 'm1'
        generate_m1();
    case 'm2'
        generate_m2();
    case 'n'
        generate_n();
    case 'o_st'
        generate_o_st();
    otherwise
        error("Wrong input string. Should be one of the following: 'all', 'm1', 'm2', 'n' or 'o_st'.");
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now come the functions that actually generate the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generates the data for opt_venum_st__fixed_n_m1.pdf
function generate_m1()

% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing venum, opt and st
methods = {'venum', 'opt', 'st'};
n_methods = size(methods, 2);

% For each Z2_cycle, a different Z2 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z1_smaller 'smaller' zonotopes, and Z1_equal zonotopes of equal diameter
% than Z2, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_smaller = 10;
Z1_equal = 10;
Z2_cycles = 5;

% Parameters setting the dimensionality of the zonotopes
n = 5;
m1 = 10;

m2_range = n:5:200;
size_m2_range = size(m2_range, 2);

% We will store the entire data in two data sets, corresponding to all the
% results for the 'smaller' and the 'larger/equal' zonotopes Z1.
% This gives AxBxCxD-arrays, where A is the number of the main
% loop-iteration present in this file, B is the number of the method used,
% and C and D give the result of the corresponding zonotope-pair.
runtimes_smaller = zeros([size_m2_range n_methods Z1_smaller Z2_cycles]);
runtimes_equal = zeros([size_m2_range n_methods Z1_equal Z2_cycles]);

% We also store the discrepancies, i.e., the error of each method w.r.t.
% the standard, which is by definition always the first method given in the
% variable 'methods'.
discrepancies_smaller = zeros([size_m2_range n_methods Z1_smaller Z2_cycles]);
discrepancies_equal = zeros([size_m2_range n_methods Z1_equal Z2_cycles]);
% Note that for the first method, the discrepancy instead gives the correct
% solution that this first method found, instead of the error w.r.t.
% itself, which would have been meaningless.

% However, in order to make the plotting easier, we also store special
% variables needed for the plots, i.e., the maximal runtime in each case,
% the mean runtime as well as the standard deviation.
venum_max_runtimes_smaller = zeros([size_m2_range 1]);
opt_max_runtimes_smaller = zeros([size_m2_range 1]);
st_max_runtimes_smaller = zeros([size_m2_range 1]);

venum_max_runtimes_equal = zeros([size_m2_range 1]);
opt_max_runtimes_equal = zeros([size_m2_range 1]);
st_max_runtimes_equal = zeros([size_m2_range 1]);

venum_mean_runtimes = zeros([size_m2_range 1]);
opt_mean_runtimes = zeros([size_m2_range 1]);
st_mean_runtimes = zeros([size_m2_range 1]);

venum_std_runtimes = zeros([size_m2_range 1]);
opt_std_runtimes = zeros([size_m2_range 1]);
st_std_runtimes = zeros([size_m2_range 1]);


% Also, we store the total number of errors for each method. For the first
% method, this equates to the number of pairs for which containment did
% hold.
venum_total_discrepancies_smaller = zeros([size_m2_range 1]);
opt_total_discrepancies_smaller = zeros([size_m2_range 1]);
st_total_discrepancies_smaller = zeros([size_m2_range 1]);

venum_total_discrepancies_equal = zeros([size_m2_range 1]);
opt_total_discrepancies_equal = zeros([size_m2_range 1]);
st_total_discrepancies_equal = zeros([size_m2_range 1]);

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
% using the predetermined rng chosen at the beginning of this document.
% This gets lost when using parallel programming.
for i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2);
    disp(m2)

    data = compare_methods(n, m1, m2, methods, Z1_smaller, Z1_equal, Z2_cycles);
    
    % Storing the bulk of the data
    runtimes_smaller(i_m2,:,:,:) = data{1};
    runtimes_equal(i_m2,:,:,:) = data{2};
    discrepancies_smaller(i_m2,:,:,:) = data{3};
    discrepancies_equal(i_m2,:,:,:) = data{4};
    
    % Storing the interesting data for the plots separately
    venum_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,1,:,:)));
    opt_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,2,:,:)));
    st_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,3,:,:)));

    venum_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,1,:,:)));
    opt_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,2,:,:)));
    st_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,3,:,:)));
    
    venum_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,1,:,:)]);
    opt_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,2,:,:)]);
    st_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,3,:,:)]);
    
    venum_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,1,:,:)]);
    opt_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,2,:,:)]);
    st_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,3,:,:)]);
    
    % Finally, store the discrepancy data that might be of interest to
    % overview the overall corectness of the algorithms
    venum_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,1,:,:)));
    opt_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,2,:,:)));
    st_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,3,:,:)));
    
    venum_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,1,:,:)));
    opt_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,2,:,:)));
    st_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,3,:,:)));
end

% Saving the whole data for later use
save('data/runtimes/opt_venum_st__fixed_n_m1.mat')
end

%% Generates the data for opt_polymax_st__fixed_m1_m2.pdf
function generate_m2()
% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing polymax, opt and st
methods = {'polymax', 'opt', 'st'};
n_methods = size(methods, 2);

% For each Z2_cycle, a different Z2 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z1_smaller 'smaller' zonotopes, and Z1_equal zonotopes of equal diameter
% than Z2, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_smaller = 10;
Z1_equal = 10;
Z2_cycles = 5;

% Parameters setting the dimensionality of the zonotopes
m1 = 10;
m2 = 17;

n_range = 3:m2;

size_n_range = size(n_range, 2);

% We will store the entire data in two data sets, corresponding to all the
% results for the 'smaller' and the 'larger/equal' zonotopes Z1.
% This gives AxBxCxD-arrays, where A is the number of the main
% loop-iteration present in this file, B is the number of the method used,
% and C and D give the result of the corresponding zonotope-pair.
runtimes_smaller = zeros([size_n_range n_methods Z1_smaller Z2_cycles]);
runtimes_equal = zeros([size_n_range n_methods Z1_equal Z2_cycles]);

% We also store the discrepancies, i.e., the error of each method w.r.t.
% the standard, which is by definition always the first method given in the
% variable 'methods'.
discrepancies_smaller = zeros([size_n_range n_methods Z1_smaller Z2_cycles]);
discrepancies_equal = zeros([size_n_range n_methods Z1_equal Z2_cycles]);
% Note that for the first method, the discrepancy instead gives the correct
% solution that this first method found, instead of the error w.r.t.
% itself, which would have been meaningless.

% However, in order to make the plotting easier, we also store special
% variables needed for the plots, i.e., the maximal runtime in each case,
% the mean runtime as well as the standard deviation.
polymax_max_runtimes_smaller = zeros([size_n_range 1]);
opt_max_runtimes_smaller = zeros([size_n_range 1]);
st_max_runtimes_smaller = zeros([size_n_range 1]);

polymax_max_runtimes_equal = zeros([size_n_range 1]);
opt_max_runtimes_equal = zeros([size_n_range 1]);
st_max_runtimes_equal = zeros([size_n_range 1]);

polymax_mean_runtimes = zeros([size_n_range 1]);
opt_mean_runtimes = zeros([size_n_range 1]);
st_mean_runtimes = zeros([size_n_range 1]);

polymax_std_runtimes = zeros([size_n_range 1]);
opt_std_runtimes = zeros([size_n_range 1]);
st_std_runtimes = zeros([size_n_range 1]);

% Also, we store the total number of errors for each method. For the first
% method, this equates to the number of pairs for which containment did
% hold.
polymax_total_discrepancies_smaller = zeros([size_n_range 1]);
opt_total_discrepancies_smaller = zeros([size_n_range 1]);
st_total_discrepancies_smaller = zeros([size_n_range 1]);

polymax_total_discrepancies_equal = zeros([size_n_range 1]);
opt_total_discrepancies_equal = zeros([size_n_range 1]);
st_total_discrepancies_equal = zeros([size_n_range 1]);

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
% using the predetermined rng chosen at the beginning of this document.
% This gets lost when using parallel programming.
for i_n = 1:size_n_range
    n = n_range(i_n);
    disp(n)

    data = compare_methods(n, m1, m2, methods, Z1_smaller, Z1_equal, Z2_cycles);
    
    % Storing the bulk of the data
    runtimes_smaller(i_n,:,:,:) = data{1};
    runtimes_equal(i_n,:,:,:) = data{2};
    discrepancies_smaller(i_n,:,:,:) = data{3};
    discrepancies_equal(i_n,:,:,:) = data{4};
    
    % Storing the interesting data for the plots separately
    polymax_max_runtimes_smaller(i_n) = max(max(runtimes_smaller(i_n,1,:,:)));
    opt_max_runtimes_smaller(i_n) = max(max(runtimes_smaller(i_n,2,:,:)));
    st_max_runtimes_smaller(i_n) = max(max(runtimes_smaller(i_n,3,:,:)));

    polymax_max_runtimes_equal(i_n) = max(max(runtimes_equal(i_n,1,:,:)));
    opt_max_runtimes_equal(i_n) = max(max(runtimes_equal(i_n,2,:,:)));
    st_max_runtimes_equal(i_n) = max(max(runtimes_equal(i_n,3,:,:)));
    
    polymax_mean_runtimes(i_n) = mean2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,1,:,:)]);
    opt_mean_runtimes(i_n) = mean2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,2,:,:)]);
    st_mean_runtimes(i_n) = mean2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,3,:,:)]);
    
    polymax_std_runtimes(i_n) = std2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,1,:,:)]);
    opt_std_runtimes(i_n) = std2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,2,:,:)]);
    st_std_runtimes(i_n) = std2([runtimes_smaller(i_n,1,:,:);runtimes_equal(i_n,3,:,:)]);
    
    
    % Finally, store the discrepancy data that might be of interest to
    % overview the overall corectness of the algorithms
    polymax_total_discrepancies_smaller(i_n) = sum(sum(discrepancies_smaller(i_n,1,:,:)));
    opt_total_discrepancies_smaller(i_n) = sum(sum(discrepancies_smaller(i_n,2,:,:)));
    st_total_discrepancies_smaller(i_n) = sum(sum(discrepancies_smaller(i_n,3,:,:)));
    
    polymax_total_discrepancies_equal(i_n) = sum(sum(discrepancies_equal(i_n,1,:,:)));
    opt_total_discrepancies_equal(i_n) = sum(sum(discrepancies_equal(i_n,2,:,:)));
    st_total_discrepancies_equal(i_n) = sum(sum(discrepancies_equal(i_n,3,:,:)));
end

% Saving the whole data for later use
save('data/runtimes/opt_polymax_st__fixed_m1_m2.mat')
end

%% Generates the data for opt_polymax_st__fixed_n_m1.pdf
function generate_n()
% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing polymax, opt and st
methods = {'polymax', 'opt', 'st'};

n_methods = size(methods,2);

% For each Z2_cycle, a different Z2 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z1_smaller 'smaller' zonotopes, and Z1_equal zonotopes of equal diameter
% than Z2, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_smaller = 10;
Z1_equal = 10;
Z2_cycles = 5;

% Parameters setting the dimensionality of the zonotopes
n = 5;
m1 = 10;

m2_range = n:30;

size_m2_range = size(m2_range, 2);

% We will store the entire data in two data sets, corresponding to all the
% results for the 'smaller' and the 'larger/equal' zonotopes Z1.
% This gives AxBxCxD-arrays, where A is the number of the main
% loop-iteration present in this file, B is the number of the method used,
% and C and D give the result of the corresponding zonotope-pair.
runtimes_smaller = zeros([size_m2_range n_methods Z1_smaller Z2_cycles]);
runtimes_equal = zeros([size_m2_range n_methods Z1_equal Z2_cycles]);

% We also store the discrepancies, i.e., the error of each method w.r.t.
% the standard, which is by definition always the first method given in the
% variable 'methods'.
discrepancies_smaller = zeros([size_m2_range n_methods Z1_smaller Z2_cycles]);
discrepancies_equal = zeros([size_m2_range n_methods Z1_equal Z2_cycles]);
% Note that for the first method, the discrepancy instead gives the correct
% solution that this first method found, instead of the error w.r.t.
% itself, which would have been meaningless.

% However, in order to make the plotting easier, we also store special
% variables needed for the plots, i.e., the maximal runtime in each case,
% the mean runtime as well as the standard deviation.
polymax_max_runtimes_smaller = zeros([size_m2_range 1]);
opt_max_runtimes_smaller = zeros([size_m2_range 1]);
st_max_runtimes_smaller = zeros([size_m2_range 1]);

polymax_max_runtimes_equal = zeros([size_m2_range 1]);
opt_max_runtimes_equal = zeros([size_m2_range 1]);
st_max_runtimes_equal = zeros([size_m2_range 1]);

polymax_mean_runtimes = zeros([size_m2_range 1]);
opt_mean_runtimes = zeros([size_m2_range 1]);
st_mean_runtimes = zeros([size_m2_range 1]);

polymax_std_runtimes = zeros([size_m2_range 1]);
opt_std_runtimes = zeros([size_m2_range 1]);
st_std_runtimes = zeros([size_m2_range 1]);

% Also, we store the total number of errors for each method. For the first
% method, this equates to the number of pairs for which containment did
% hold.
polymax_total_discrepancies_smaller = zeros([size_m2_range 1]);
opt_total_discrepancies_smaller = zeros([size_m2_range 1]);
st_total_discrepancies_smaller = zeros([size_m2_range 1]);

polymax_total_discrepancies_equal = zeros([size_m2_range 1]);
opt_total_discrepancies_equal = zeros([size_m2_range 1]);
st_total_discrepancies_equal = zeros([size_m2_range 1]);

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
% using the predetermined rng chosen at the beginning of this document.
% This gets lost when using parallel programming.
for i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2);
    disp(m2)

    data = compare_methods(n, m1, m2, methods, Z1_smaller, Z1_equal, Z2_cycles);
    
    % Storing the bulk of the data
    runtimes_smaller(i_m2,:,:,:) = data{1};
    runtimes_equal(i_m2,:,:,:) = data{2};
    discrepancies_smaller(i_m2,:,:,:) = data{3};
    discrepancies_equal(i_m2,:,:,:) = data{4};
    
    % Storing the interesting data for the plots separately
    polymax_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,1,:,:)));
    opt_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,2,:,:)));
    st_max_runtimes_smaller(i_m2) = max(max(runtimes_smaller(i_m2,3,:,:)));

    polymax_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,1,:,:)));
    opt_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,2,:,:)));
    st_max_runtimes_equal(i_m2) = max(max(runtimes_equal(i_m2,3,:,:)));
    
    polymax_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,1,:,:)]);
    opt_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,2,:,:)]);
    st_mean_runtimes(i_m2) = mean2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,3,:,:)]);
    
    polymax_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,1,:,:)]);
    opt_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,2,:,:)]);
    st_std_runtimes(i_m2) = std2([runtimes_smaller(i_m2,1,:,:);runtimes_equal(i_m2,3,:,:)]);
    
    % Finally, store the discrepancy data that might be of interest to
    % overview the overall corectness of the algorithms
    polymax_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,1,:,:)));
    opt_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,2,:,:)));
    st_total_discrepancies_smaller(i_m2) = sum(sum(discrepancies_smaller(i_m2,3,:,:)));
    
    polymax_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,1,:,:)));
    opt_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,2,:,:)));
    st_total_discrepancies_equal(i_m2) = sum(sum(discrepancies_equal(i_m2,3,:,:)));
end

% Saving the whole data for later use
save('data/runtimes/opt_polymax_st__fixed_n_m1.mat')
end

%% Generates the data for opt_st.pdf
function generate_o_st()
% Setting RNG for the sake of reproducibility
rng(123456);

% We are testing ZC^O and ST
methods = {'opt', 'st'};
n_methods = size(methods,2);


% For each Z2_cycle, a different Z2 will be generated; for each of these,
% the algorithms will be applied on a pair (Z1, Z2), where there are
% Z1_smaller 'smaller' zonotopes, and Z1_equal zonotopes of equal diameter
% than Z2, meaning that in the end, per data point Z1_cycles * (Z2_smaller
% + Z2_equal) zonotope-pairs will be checked
Z1_smaller = 10;
Z1_equal = 10;
Z2_cycles = 5;

% Parameters setting the dimensionality of the zonotopes
n_range = 2:40;
m1_range = n_range.*2;
m2_range = n_range.*2;

size_n_range = size(n_range, 2);

% We will store the entire data in two data sets, corresponding to all the
% results for the 'smaller' and the 'larger/equal' zonotopes Z1.
% This gives AxBxCxD-arrays, where A is the number of the main
% loop-iteration present in this file, B is the number of the method used,
% and C and D give the result of the corresponding zonotope-pair.
runtimes_smaller = zeros([size_n_range n_methods Z1_smaller Z2_cycles]);
runtimes_equal = zeros([size_n_range n_methods Z1_equal Z2_cycles]);

% We also store the discrepancies, i.e., the error of each method w.r.t.
% the standard, which is by definition always the first method given in the
% variable 'methods'.
discrepancies_smaller = zeros([size_n_range n_methods Z1_smaller Z2_cycles]);
discrepancies_equal = zeros([size_n_range n_methods Z1_equal Z2_cycles]);
% Note that for the first method, the discrepancy instead gives the correct
% solution that this first method found, instead of the error w.r.t.
% itself, which would have been meaningless.

% However, in order to make the plotting easier, we also store special
% variables needed for the plots, i.e., the maximal runtime in each case,
% the mean runtime as well as the standard deviation.
opt_max_runtimes_smaller = zeros([size_n_range 1]);
st_max_runtimes_smaller = zeros([size_n_range 1]);

opt_max_runtimes_equal = zeros([size_n_range 1]);
st_max_runtimes_equal = zeros([size_n_range 1]);

% Also, we store the total number of errors for each method. For the first
% method, this equates to the number of pairs for which containment did
% hold.
opt_total_discrepancies_smaller = zeros([size_n_range 1]);
st_total_discrepancies_smaller = zeros([size_n_range 1]);

opt_total_discrepancies_equal = zeros([size_n_range 1]);
st_total_discrepancies_equal = zeros([size_n_range 1]);

% This loop applies all the algorithms on the zonotopes pairs. It is
% possible to change the for-loop by a parfor-loop, but the result will
% then not be reproducible anymore, as the zonotopes are chosen at random
% using the predetermined rng chosen at the beginning of this document.
% This gets lost when using parallel programming.
for i_n = 1:size_n_range
    n = n_range(i_n);
    m1 = m1_range(i_n);
    m2 = m2_range(i_n);
    disp(n)
    
    data = compare_methods(n, m1, m2, methods, Z1_smaller, Z1_equal, Z2_cycles);
    
    % Storing the bulk of the data
    runtimes_smaller(i_n,:,:,:) = data{1};
    runtimes_equal(i_n,:,:,:) = data{2};
    discrepancies_smaller(i_n,:,:,:) = data{3};
    discrepancies_equal(i_n,:,:,:) = data{4};
    
    % Storing the interesting data for the plots separately
    opt_max_runtimes_smaller(i_n) = max(max(runtimes_smaller(i_n,1,:,:)));
    st_max_runtimes_smaller(i_n) = max(max(runtimes_smaller(i_n,2,:,:)));

    opt_max_runtimes_equal(i_n) = max(max(runtimes_equal(i_n,1,:,:)));
    st_max_runtimes_equal(i_n) = max(max(runtimes_equal(i_n,2,:,:)));
    
    % Finally, store the discrepancy data that might be of interest to
    % overview the overall corectness of the algorithms
    opt_total_discrepancies_smaller(i_n) = sum(sum(discrepancies_smaller(i_n,1,:,:)));
    st_total_discrepancies_smaller(i_n) = sum(sum(discrepancies_smaller(i_n,2,:,:)));

    opt_total_discrepancies_equal(i_n) = sum(sum(discrepancies_equal(i_n,1,:,:)));
    st_total_discrepancies_equal(i_n) = sum(sum(discrepancies_equal(i_n,2,:,:)));
end

% Saving the whole data for later use
save('data/runtimes/opt_st.mat')
end