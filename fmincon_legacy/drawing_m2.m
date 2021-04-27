% This script plots the graph obtained by combining the results from
% ZC_m2_vs_ZC_O

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

load('ZC_m2_vs_ZC_O.mat')
for i_n = 1:size_n_range
    n = n_range(i_n);
    
    % First, plotting the results from ZC^O
    worst_case = opt_point_data{i_n}{3};
    
    subplot(2, 1, 1);
    u1 = plot(n, worst_case, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = opt_point_data{i_n}{2};
    all_points = opt_point_data{i_n}{5};
    sigma = std(all_points);
    
    d1 = errorbar(n, mean, sigma, sigma, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    % Next, plotting the results from ZC^{m2}
    
    worst_case = poly_point_data{i_n}{3};
    
    subplot(2, 1, 1);
    u2 = plot(n, worst_case, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5);
    
    subplot(2, 1, 2);
       
    mean = poly_point_data{i_n}{2};
    all_points = poly_point_data{i_n}{5};
    sigma = std(all_points);
    
    d2 = errorbar(n, mean, sigma, sigma, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5);
    
    % Finally, plotting the results from ST
    
    worst_case = st_point_data{i_n}{3};
    
    subplot(2, 1, 1);
    u3 = plot(n, worst_case, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = st_point_data{i_n}{2};
    all_points = st_point_data{i_n}{5};
    sigma = std(all_points);
    
    d3 = errorbar(n, mean, sigma, sigma, 'o', 'color', RPTH_red, 'MarkerSize', 4);
end

subplot(2, 1, 1);
hold off
title('Worst-case runtime of \verb|ZC|$^{\verb|O|}$, \verb|ZC|$^{\verb|m|_2}$, and \verb|ST| for $m_2 = 17, m_1 = 10$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([u1 u2 u3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|m|_2}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northeast');
lgd.FontSize = 9;
ylims_max = ylim;

subplot(2, 1, 2);
hold off
title('Mean runtime of \verb|ZC|$^{\verb|O|}$, \verb|ZC|$^{\verb|m|_2}$, and \verb|ST| for $m_2 = 17, m_1 = 10$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylim(ylims_max);
lgd = legend([d1 d2 d3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|m|_2}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northeast');
lgd.FontSize = 9;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('m2.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);