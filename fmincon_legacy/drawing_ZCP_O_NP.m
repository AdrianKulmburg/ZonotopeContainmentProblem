% This script plots the graph obtained by combining the results from
% check_ZCP_O_NP

% Colors palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;


clf;
subplot(2, 1, 1); % graph for the worst case
hold on
subplot(2, 1, 2); % graph for the mean and standard deviation
hold on

load('check_ZCP_O_NP.mat')

for i_n = 1:size_n_range
    n = n_range(i_n);
       
    worst_case = opt_point_data{i_n}{3};
    
    subplot(2, 1, 1);
    u1 = plot(n, worst_case, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = opt_point_data{i_n}{2};
    all_points = opt_point_data{i_n}{5};
    sigma = std(all_points);
    
    d1 = errorbar(n, mean, sigma, sigma, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
end

for i_n = 1:size_n_range
    n = n_range(i_n);
    if n>cutoff
        continue
    end       
    worst_case = st_point_data{i_n}{3};
    
    subplot(2, 1, 1);
    u2 = plot(n, worst_case, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = st_point_data{i_n}{2};
    all_points = st_point_data{i_n}{5};
    sigma = std(all_points);
    
    d2 = errorbar(n, mean, sigma, sigma, 'o', 'color', RPTH_red, 'MarkerSize', 4);
end

subplot(2, 1, 1);
hold off
title('Worst-case runtime of \verb|ZC|$^{\verb|O|}$ and \verb|ST| for $m_1 = m_2 = 2n$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylims_max = ylim;
xlim([4 135])
lgd = legend([u1 u2], {'\verb|ZC|$^{\verb|O|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

subplot(2, 1, 2);
hold off
title('Mean runtime of \verb|ZC|$^{\verb|O|}$ and \verb|ST| for $m_1 = m_2 = 2n$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylim(ylims_max);
xlim([4 135])
lgd = legend([d1 d2], {'\verb|ZC|$^{\verb|O|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('ZC_O_NP.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);