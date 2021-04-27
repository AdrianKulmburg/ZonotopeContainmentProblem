% 

% This script executes all functions that are necessary to generate the 4
% plots.
% The .mat files, containing all the data which should be reproducible, are
% also included, therefore the functions generating this data are commented
% out, since they take an inordinate amount of time to be executed, i.e.,
% about 5 full days.
% check_ZCP_O_NP_5_100;
% check_ZCP_O_NP_100_130;
ZC_m1_vs_ZC_O;
ZC_m2_vs_ZC_O;
ZC_n_vs_ZC_O;

% Now, for drawing the actual graphs:
drawing_ZCP_O_NP;
clear;
drawing_m1;
clear;
drawing_m2;
clear;
drawing_n;
clear;