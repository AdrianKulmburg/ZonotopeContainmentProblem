% This script plots the graph obtained by combining the results from
% ZC_n_vs_ZC_O

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

load('ZC_n_vs_ZC_O.mat')
for i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2);
    
    % First, plotting the results from ZC^O
    full_data = opt_point_data{i_m2}{5};
    s = size(full_data,2);
    smaller = full_data(1:s/2);
    equal = full_data(s/2+1:end);
    
    worst_case_smaller = max(smaller);
    worst_case_equal = max(equal);
    
    subplot(2, 1, 1);
    u1 = plot(m2, worst_case_smaller, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
    
    d1 =  plot(m2, worst_case_equal, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
    % Next, plotting the results from ZC^{m1}
    
    full_data = poly_point_data{i_m2}{5};
    s = size(full_data,2);
    smaller = full_data(1:s/2);
    equal = full_data(s/2+1:end);
    
    worst_case_smaller = max(smaller);
    worst_case_equal = max(equal);
    
    subplot(2, 1, 1);
    u2 = plot(m2, worst_case_smaller, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);
    
    subplot(2, 1, 2);
    
    d2 = plot(m2, worst_case_equal, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);
    
    % Finally, plotting the results from ST
    
    full_data = st_point_data{i_m2}{5};
    s = size(full_data,2);
    smaller = full_data(1:s/2);
    equal = full_data(s/2+1:end);
    
    worst_case_smaller = max(smaller);
    worst_case_equal = max(equal);
    
    subplot(2, 1, 1);
    u3 = plot(m2, worst_case_smaller, 'o', 'color', RPTH_red, 'MarkerSize', 4);
    
    subplot(2, 1, 2);
    
    d3 = plot(m2, worst_case_equal, 'o', 'color', RPTH_red, 'MarkerSize', 4);
end

subplot(2, 1, 1);
hold off
title({'Worst-case runtime for group 1, with $n = 5, m_1 = 10$.'}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([u1 u2 u3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|n|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'west');
lgd.FontSize = 13;
lgd.Position(2) = 0.63;

subplot(2, 1, 2);
hold off
title({'Worst-case runtime for group 2, with $n = 5, m_1 = 10$.'}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([d1 d2 d3], {'\verb|ZC|$^{\verb|O|}$', '\verb|ZC|$^{\verb|n|}$', '\verb|ST|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 13;


% fig_sub1 = subplot(2, 1, 1);
% fig_sub2 = subplot(2, 1, 2);
% pause(1);
% fig_sub1.Position(3) = 0.74;
% pause(1);
% fig_sub2.Position(3) = 0.74;
% lgd.Position(1) = 0.8688;
% lgd.Position(2) = 0.462;
% set(lgd, 'color', 'none');
% set(lgd, 'EdgeColor', 'white');
% annotation('textbox', [0.898, 0.465, 0.095, 0.12], 'EdgeColor', 'black')

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('n.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'ZC_O_NP.pdf', 'Resolution', 600);