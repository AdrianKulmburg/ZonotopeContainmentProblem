% 

% This script executes all functions that are necessary to generate the 5
% plots.
% The .mat files, containing all the data which should be reproducible, are
% also included, therefore the functions generating this data are commented
% out, since they take an inordinate amount of time to be executed, i.e.,
% about 5 full days just for the runtime computations, and about one week
% for the loss-computations, on an intel with 12 cores.

% Runtime computations
%check_ZCP_O_NP;
%clear;
%ZC_m1_vs_ZC_O;
%clear;
%ZC_m2_vs_ZC_O;
%clear;
%ZC_n_vs_ZC_O;
%clear;

% Loss computations
%measure_loss([2 3 4 5 6], 'loss_2_6.mat');
%clear;
%measure_loss([7], 'loss_7.mat');
%clear;
%measure_loss([8], 'loss_8.mat');
%clear;
%measure_loss([9], 'loss_9.mat');
%clear;
%measure_loss([10], 'loss_10.mat');
%clear;
%measure_loss([11], 'loss_11.mat');
%clear;
%measure_loss([12], 'loss_12.mat');
%clear;
%measure_loss([13], 'loss_13.mat');
%clear;
%measure_loss([14], 'loss_14.mat');
%clear;
%measure_loss([15], 'loss_15.mat');
%clear;

% Now, for drawing the actual graphs:
drawing_ZCP_O_NP;
clear;
drawing_m1;
clear;
drawing_m2;
clear;
drawing_n;
clear;

drawing_losses.m;
clear;