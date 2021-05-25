% This script executes all functions that are necessary to generate the 5
% plots.
% The .mat files, containing all the data which should be reproducible, are
% also included, therefore the functions generating this data are commented
% out, since they take an inordinate amount of time to be executed, i.e.,
% about 5 full days just for the runtime computations on an average laptop,
% and about one week for the loss-computations on a CPU with 12 cores.

% Runtime computations
%generate_runtime_data('all');

% Loss computations
% Do NOT uncomment and launch all the next few lines. Beyond the fact that
% the total runtime is gigantic, for some reason in between the functions
% the memory is not freed, which quickly leads to memory overloads. Even
% trying stuff like 'clear' or 'pack' did not help here, therefore the only
% method that seems to work is to restart matlab entirely.
%generate_loss_data([2 3 4 5 6], 'loss_2_6.mat');
%generate_loss_data(7, 'loss_7.mat');
%generate_loss_data(8, 'loss_8.mat');
%generate_loss_data(9, 'loss_9.mat');
%generate_loss_data(10, 'loss_10.mat');
%generate_loss_data(11, 'loss_11.mat');
%generate_loss_data(12, 'loss_12.mat');
%generate_loss_data(13, 'loss_13.mat');
%generate_loss_data(14, 'loss_14.mat');
%generate_loss_data(15, 'loss_15.mat');

% Now, for drawing the actual graphs:
%draw_runtimes('all');

%draw_losses();
