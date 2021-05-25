function draw_losses()

clf;
subplot(2, 1, 1);
hold on
subplot(2, 1, 2);
hold on

plot_part(2, 'data/losses/loss_2.mat');
plot_part(3, 'data/losses/loss_3.mat');
plot_part(4, 'data/losses/loss_4.mat');
plot_part(5, 'data/losses/loss_5.mat');
plot_part(6, 'data/losses/loss_6.mat');
plot_part(7, 'data/losses/loss_7.mat');
plot_part(8, 'data/losses/loss_8.mat');
plot_part(9, 'data/losses/loss_9.mat');
plot_part(10, 'data/losses/loss_10.mat');
plot_part(11, 'data/losses/loss_11.mat');
plot_part(12, 'data/losses/loss_12.mat');
plot_part(13, 'data/losses/loss_13.mat');
plot_part(14, 'data/losses/loss_14.mat');
[u1, u2, d1, d2] = plot_part(15, 'data/losses/loss_15.mat');


subplot(2, 1, 1);
hold off
title('Worst-case loss', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('loss', 'Interpreter', 'latex', 'FontSize', 13)
ylim([0 inf])
xlim([2 15])
lgd = legend([u1 u2], {'\verb|opt|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

subplot(2, 1, 2);
hold off
title('Mean loss', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('loss', 'Interpreter', 'latex', 'FontSize', 13)
ylim([0 inf])
xlim([2 15])
lgd = legend([d1 d2], {'\verb|opt|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('figures/loss.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);

close all;
end


function [u1, u2, d1, d2] = plot_part(n_range, name)
% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

load(name, 'losses');

iterations = 10000;

for i_n = 1:size(n_range,2)
    n = n_range(i_n);
    iter = reshape(losses(i_n,:,:), [iterations 2]);
    st_iter = iter(:,1);
    opt_iter = iter(:,2);
    
    
    % Plotting the results from st
    
    worst_case = max(st_iter);
    
    subplot(2, 1, 1);
    u2 = plot(n, worst_case, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean =sum(st_iter)/iterations;
    sigma = std(st_iter);
    d2 = errorbar(n, mean, sigma, sigma, 'o', 'color', RPTH_red, 'MarkerSize', 8, 'CapSize', 10, 'LineWidth', 2);
    drawnow;
    d2.MarkerHandle.LineWidth = 1;
    
    % Plotting the results from opt
    
    worst_case = max(opt_iter);
    
    subplot(2, 1, 1);
    u1 = plot(n, worst_case, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean =sum(opt_iter)/iterations;
    sigma = std(opt_iter);
    
    d1 = errorbar(n, mean, sigma, sigma, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize',6);
end
end
