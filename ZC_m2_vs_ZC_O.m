methods = {@ZonotopeInZonotope_optimization, @ZonotopeInZonotope_polyhedral, @ZonotopeInZonotope_original};

Z1_cycles = 5;
Z2_smaller = 10;
Z2_equal = 10;

m2 = 17;
m1 = 10;

n_range = 3:m2;

total_times_max_opt = n_range .* 0;
total_times_min_opt = n_range .* 0;
total_times_mean_opt = n_range .* 0;

total_times_max_poly = n_range .* 0;
total_times_min_poly = n_range .* 0;
total_times_mean_poly = n_range .* 0;

total_times_max_or = n_range .* 0;
total_times_min_or = n_range .* 0;
total_times_mean_or = n_range .* 0;

size_n_range = size(n_range, 2);

parfor i_n = 1:size_n_range
    n = n_range(i_n);
    disp(n)

    [mean_times, min_times, max_times, discrepancies] = main_operation(n, m2, m1, methods, Z1_cycles, Z2_smaller, Z2_equal);
    total_discrepancies(i_n) = discrepancies;
    
    total_times_max_opt(i_n) = max_times(1);
    total_times_min_opt(i_n) = min_times(1);
    total_times_mean_opt(i_n) = mean_times(1);
    
    total_times_max_poly(i_n) = max_times(2);
    total_times_min_poly(i_n) = min_times(2);
    total_times_mean_poly(i_n) = mean_times(2);
    
    total_times_max_or(i_n) = max_times(3);
    total_times_min_or(i_n) = min_times(3);
    total_times_mean_or(i_n) = mean_times(3);
    
end

x = [n_range, fliplr(n_range)];

inBetween_opt = [total_times_max_opt, fliplr(total_times_min_opt)];
fill(x, inBetween_opt, 'r', 'EdgeColor', 'r', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p1 = plot(n_range, total_times_mean_opt, 'ro-');
hold on
inBetween_poly = [total_times_max_poly, fliplr(total_times_min_poly)];
fill(x, inBetween_poly, 'b', 'EdgeColor', 'b', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p2 = plot(n_range, total_times_mean_poly, 'bx-');

inBetween_or = [total_times_max_or, fliplr(total_times_min_or)];
fill(x, inBetween_or, 'k', 'EdgeColor', 'k', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p3 = plot(n_range, total_times_mean_or, 'kx-');
hold off

title('Runtime of $ZC^O$ versus $ZC^{m_2}$ for fixed $m_2 = 17$ and $m_1 = 10$.', 'Interpreter', 'latex')
xlabel('$n$', 'Interpreter', 'latex')
ylabel('Runtime, in [s]', 'Interpreter', 'latex')
legend([p1 p2 p3], {'$ZC^O$', '$ZC^{m_2}$', '$ST$'}, 'Interpreter', 'latex', 'Location', 'northeast')
%saveas(gcf, 'm2.pdf')
export_fig('m2.pdf', '-pdf', '-transparent');