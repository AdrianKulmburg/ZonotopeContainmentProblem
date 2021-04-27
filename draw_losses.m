

clf;
subplot(2, 1, 1);
hold on
subplot(2, 1, 2);
hold on

[u1, u2, d1, d2] = plot_part([2 3 4 5 6], 'loss_2_6.mat');
[u1, u2, d1, d2] = plot_part([7], 'loss_7.mat');
[u1, u2, d1, d2] = plot_part([8], 'loss_8.mat');
[u1, u2, d1, d2] = plot_part([9], 'loss_9.mat');
[u1, u2, d1, d2] = plot_part([10], 'loss_10.mat');
[u1, u2, d1, d2] = plot_part([11], 'loss_11.mat');
[u1, u2, d1, d2] = plot_part([12], 'loss_12.mat');
[u1, u2, d1, d2] = plot_part([13], 'loss_13.mat');
[u1, u2, d1, d2] = plot_part([14], 'loss_14.mat');
[u1, u2, d1, d2] = plot_part([15], 'loss_15.mat');


subplot(2, 1, 1);
hold off
title('Worst-case loss', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('loss', 'Interpreter', 'latex', 'FontSize', 13)
ylim([0 inf])
xlim([2 15])
lgd = legend([u1 u2], {'\verb|ZC|$^{\verb|O|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

subplot(2, 1, 2);
hold off
title('Mean loss', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('loss', 'Interpreter', 'latex', 'FontSize', 13)
ylim([0 inf])
xlim([2 15])
lgd = legend([d1 d2], {'\verb|ZC|$^{\verb|O|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('loss.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);


function [u1, u2, d1, d2] = plot_part(n_range_actual, name)
% Colors palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;
load(name);
iterations = 10000;
n_range = n_range_actual;

for i_n = 1:size(n_range,2)
    n = n_range(i_n);
    iter = losses{i_n};
    st_iter = zeros([1 iterations]);
    opt_iter = zeros([1 iterations]);
    
    for j = 1:iterations
        res = iter{j};
        st_iter(j) = res(1);
        opt_iter(j) = res(2);
    end
    
    
    
    % Finally, plotting the results from ST
    
    worst_case = max(st_iter);
    
    subplot(2, 1, 1);
    u2 = plot(n, worst_case, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean =sum(st_iter)/iterations;
    sigma = std(st_iter);
    d2 = errorbar(n, mean, sigma, sigma, 'o', 'color', RPTH_red, 'MarkerSize', 8, 'CapSize', 10, 'LineWidth', 2);
    drawnow;
    d2.MarkerHandle.LineWidth = 1;
    
    worst_case = max(opt_iter);
    
    subplot(2, 1, 1);
    u1 = plot(n, worst_case, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean =sum(opt_iter)/iterations;
    sigma = std(opt_iter);
    
    d1 = errorbar(n, mean, sigma, sigma, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize',6);
end
end