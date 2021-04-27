% This script plots the graph obtained by combining the results from
% ZC_m1_vs_ZC_O

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

load('ZC_m1_vs_ZC_O.mat')
for i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2);
    
    % First, plotting the results from ZC^O
    worst_case = opt_point_data{i_m2}{3};
    
    subplot(2, 1, 1);
    u1 = plot(m2, worst_case, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = opt_point_data{i_m2}{2};
    all_points = opt_point_data{i_m2}{5};
    sigma = std(all_points);
    
    d1 = errorbar(m2, mean, sigma, sigma, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    % Next, plotting the results from ZC^{m1}
    
    worst_case = ver_point_data{i_m2}{3};
    
    subplot(2, 1, 1);
    u2 = plot(m2, worst_case, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5);
    
    subplot(2, 1, 2);
       
    mean = ver_point_data{i_m2}{2};
    all_points = ver_point_data{i_m2}{5};
    sigma = std(all_points);
    
    d2 = errorbar(m2, mean, sigma, sigma, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5);
    
    % Finally, plotting the results from ST
    
    worst_case = st_point_data{i_m2}{3};
    
    subplot(2, 1, 1);
    u3 = plot(m2, worst_case, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
       
    mean = st_point_data{i_m2}{2};
    all_points = st_point_data{i_m2}{5};
    sigma = std(all_points);
    
    d3 = errorbar(m2, mean, sigma, sigma, 'o', 'color', RPTH_red, 'MarkerSize', 4);
end

subplot(2, 1, 1);
hold off
title('Worst-case runtime of \verb|ZC|$^{\verb|O|}$, \verb|ZC|$^{\verb|m|_1}$, and \verb|ST| for $n = 5, m_1 = 10$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylims_max = ylim;
lgd = legend([u1 u2 u3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|m|_1}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

subplot(2, 1, 2);
hold off
title('Mean runtime of \verb|ZC|$^{\verb|O|}$, \verb|ZC|$^{\verb|m|_1}$, and \verb|ST| for $n = 5, m_1 = 10$.', 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylim(ylims_max);
lgd = legend([d1 d2 d3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|m|_1}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 9;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('m1.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);