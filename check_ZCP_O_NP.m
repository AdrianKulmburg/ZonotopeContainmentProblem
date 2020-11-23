methods = {@ZonotopeInZonotope_optimization, @ZonotopeInZonotope_original};

Z1_cycles = 5;
Z2_smaller = 10;
Z2_equal = 10;

n_range = 5:200;
m1_range = n_range.*2;
m2_range = n_range.*2;

total_times_max_opt = n_range .* 0;
total_times_min_opt = n_range .* 0;
total_times_mean_opt = n_range .* 0;

total_times_max_or = n_range .* 0;
total_times_min_or = n_range .* 0;
total_times_mean_or = n_range .* 0;

size_n_range = size(n_range, 2);

parfor i_n = 1:size_n_range
    n = n_range(i_n);
    m1 = m1_range(i_n);
    m2 = m2_range(i_n);
    disp(n)

    [mean_times, min_times, max_times, discrepancies] = main_operation(n, m2, m1, methods, Z1_cycles, Z2_smaller, Z2_equal);
    total_discrepancies(i_n) = discrepancies;
    
    total_times_max_opt(i_n) = max_times(1);
    total_times_min_opt(i_n) = min_times(1);
    total_times_mean_opt(i_n) = mean_times(1);
    
    total_times_max_or(i_n) = max_times(2);
    total_times_min_or(i_n) = min_times(2);
    total_times_mean_or(i_n) = mean_times(2);
end

x = [n_range, fliplr(n_range)];

inBetween_opt = [total_times_max_opt, fliplr(total_times_min_opt)];
fill(x, inBetween_opt, 'r', 'EdgeColor', 'r', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p1 = plot(n_range, total_times_mean_opt, 'ro-');
hold on

inBetween_or = [total_times_max_or, fliplr(total_times_min_or)];
fill(x, inBetween_or, 'k', 'EdgeColor', 'k', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p2 = plot(n_range, total_times_mean_or, 'k+-');
hold off

title('Runtime of $ZC^O$ for $m_1 = m_2 = 2n$.', 'Interpreter', 'latex')
xlabel('$n$', 'Interpreter', 'latex')
ylabel('Runtime, in [s]', 'Interpreter', 'latex')
legend([p1 p2], {'$ZC^O$', '$ST$'}, 'Interpreter', 'latex', 'Location', 'northwest')

%saveas(gcf, 'ZCP_O_NP.pdf')
%export_fig('ZC_O_NP.pdf', '-pdf', '-transparent');