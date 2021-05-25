function draw_runtimes(job)
switch job
    case 'all'
        draw_m1();
        draw_m2();
        draw_n();
        draw_o_st();
    case 'm1'
        draw_m1();
    case 'm2'
        draw_m2();
    case 'n'
        draw_n();
    case 'o_st'
        draw_o_st();
    otherwise
        error("Wrong input string. Should be one of the following: 'all', 'm1', 'm2', 'n', 'o_st'.");
end
end

%% Draw the plot for opt_venum_st__fixed_n_m1.pdf
function draw_m1()
% This script plots the graph obtained by combining the results from
% opt_venum_st__fixed_n_m1

load('data/runtimes/opt_venum_st__fixed_n_m1.mat');

% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

clf;
subplot(2, 1, 1); % graph for group 1
hold on
subplot(2, 1, 2); % graph for group 2
hold on

% First, plotting the results from opt
subplot(2, 1, 1);
u1 = plot(m2_range, opt_max_runtimes_smaller, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

subplot(2, 1, 2);
d1 =  plot(m2_range, opt_max_runtimes_equal, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

    
% Next, plotting the results from venum
subplot(2, 1, 1);
u2 = plot(m2_range, venum_max_runtimes_smaller, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);

subplot(2, 1, 2);
d2 = plot(m2_range, venum_max_runtimes_equal, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);
    
% Finally, plotting the results from st
subplot(2, 1, 1);
u3 = plot(m2_range, st_max_runtimes_smaller, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 2);
d3 = plot(m2_range, st_max_runtimes_equal, 'o', 'color', RPTH_red, 'MarkerSize', 4);


subplot(2, 1, 1);
hold off
title({['Worst-case runtime for group 1, with $n = ',num2str(n),', m_1 = ', num2str(m1), '$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
%ylim([0 60])
lgd = legend([u1 u2 u3], {'\verb|opt|', '\verb|venum|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest', 'Orientation', 'horizontal');
lgd.FontSize = 13;

subplot(2, 1, 2);
hold off
title({['Worst-case runtime for group 2, with $n = ',num2str(n),', m_1 = ',num2str(m1),'$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
ylim([0 7])
lgd = legend([d1 d2 d3], {'\verb|opt|', '\verb|venum|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest', 'Orientation', 'horizontal');
lgd.FontSize = 13;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('figures/opt_venum_st__fixed_n_m1.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'figures/opt_venum_st__fixed_n_m1.pdf', 'Resolution', 600);
close all;
end

%% Draw the plot for opt_polymax_st__fixed_m1_m2.pdf
function draw_m2()
% This script plots the graph obtained by combining the results from
% opt_polymax_st__fixed_m1_m2

load('data/runtimes/opt_polymax_st__fixed_m1_m2.mat')

% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

clf;
subplot(2, 1, 1); % graph for group 1
hold on
subplot(2, 1, 2); % graph for group 2
hold on

% First, plotting the results from opt
subplot(2, 1, 1);
u1 = plot(n_range, opt_max_runtimes_smaller, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

subplot(2, 1, 2);
d1 =  plot(n_range, opt_max_runtimes_equal, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

    
% Next, plotting the results from polymax
subplot(2, 1, 1);
u2 = plot(n_range, polymax_max_runtimes_smaller, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);

subplot(2, 1, 2);
d2 = plot(n_range, polymax_max_runtimes_equal, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);
    
% Finally, plotting the results from st
subplot(2, 1, 1);
u3 = plot(n_range, st_max_runtimes_smaller, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 2);
d3 = plot(n_range, st_max_runtimes_equal, 'o', 'color', RPTH_red, 'MarkerSize', 4);


subplot(2, 1, 1);
hold off
title({['Worst-case runtime for group 1, with $m_1 = ',num2str(m1),', m_2 = ',num2str(m2),'$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([u1 u2 u3], {'\verb|opt|', '\verb|polymax|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northeast');
lgd.FontSize = 13;

subplot(2, 1, 2);
hold off
title({['Worst-case runtime for group 2, with $m_1 = ',num2str(m1),', m_2 = ',num2str(m2),'$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([d1 d2 d3], {'\verb|opt|', '\verb|polymax|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northeast');
lgd.FontSize = 13;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('figures/opt_polymax_st__fixed_m1_m2.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'figures/opt_polymax__st__fixed_m1_m2.pdf', 'Resolution', 600);
close all;
end

%% Draw the plot for opt_polymax_st__fixed_n_m1.pdf
function draw_n()
% This script plots the graph obtained by combining the results from
% opt_polymax_st__fixed_n_m1

load('data/runtimes/opt_polymax_st__fixed_n_m1.mat')

% Color palette for people with colorblindness. See
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

% First, plotting the results from opt
subplot(2, 1, 1);
u1 = plot(m2_range, opt_max_runtimes_smaller, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

subplot(2, 1, 2);
d1 =  plot(m2_range, opt_max_runtimes_equal, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

    
% Next, plotting the results from polymax
subplot(2, 1, 1);
u2 = plot(m2_range, polymax_max_runtimes_smaller, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);

subplot(2, 1, 2);
d2 = plot(m2_range, polymax_max_runtimes_equal, 'p', 'color', RPTH_yellow, 'MarkerFaceColor', RPTH_yellow, 'MarkerSize', 5, 'MarkerEdgeColor', RPTH_yellow-0.1);
    
% Finally, plotting the results from st
subplot(2, 1, 1);
u3 = plot(m2_range, st_max_runtimes_smaller, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 2);
d3 = plot(m2_range, st_max_runtimes_equal, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 1);
hold off
title({['Worst-case runtime for group 1, with $n = ',num2str(n),', m_1 = ',num2str(m1),'$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([u1 u2 u3], {'\verb|opt|', '\verb|polymax|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'west');
lgd.FontSize = 13;
lgd.Position(2) = 0.62;

subplot(2, 1, 2);
hold off
title({['Worst-case runtime for group 2, with $n = ',num2str(n),', m_1 = ',num2str(m1),'$.']}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$m_2$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([d1 d2 d3], {'\verb|opt|', '\verb|polymax|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 13;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('figures/opt_polymax_st__fixed_n_m1.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'figures/opt_polymax_st__fixed_n_m1.pdf', 'Resolution', 600);
close all;
end

%% Draw the plot for opt_st.pdf
function draw_o_st()
% This script plots the graph obtained by combining the results from
% check_ZCP_O_NP

% Color palette for people with colorblindness. See
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

load('data/runtimes/opt_st.mat')

% First, plotting the results from opt
subplot(2, 1, 1);
u1 = plot(n_range, opt_max_runtimes_smaller, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);

subplot(2, 1, 2);
d1 =  plot(n_range, opt_max_runtimes_equal, 's', 'color', RPTH_blue, 'MarkerFaceColor', RPTH_blue, 'MarkerSize', 4);
    
% Finally, plotting the results from st
subplot(2, 1, 1);
u2 = plot(n_range, st_max_runtimes_smaller, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 2);
d2 = plot(n_range, st_max_runtimes_equal, 'o', 'color', RPTH_red, 'MarkerSize', 4);

subplot(2, 1, 1);
hold off
title({'Worst-case runtime for group 1, with $m_1 = m_2 = 2n$.'}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([u1 u2], {'\verb|opt|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 13;

subplot(2, 1, 2);
hold off
title({'Worst-case runtime for group 2, with $m_1 = m_2 = 2n$.'}, 'Interpreter', 'latex', 'FontSize', 13)
xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 13)
ylabel('Runtime, in [s]', 'Interpreter', 'latex', 'FontSize', 13)
lgd = legend([d1 d2], {'\verb|opt|', '\verb|st|'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 13;

% export_fig gives less padding, but has to be downloaded separatly:
% https://github.com/altmany/export_fig
export_fig('figures/opt_st.pdf', '-pdf', '-transparent');
% The next method is quite similar and works with only Matlab being
% installed
%exportgraphics(gcf, 'figures/opt_st.pdf', 'Resolution', 600);
close all;
end