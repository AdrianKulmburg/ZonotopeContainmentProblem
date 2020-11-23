methods = {@ZonotopeInZonotope_optimization, @ZonotopeInZonotope_polyhedral, @ZonotopeInZonotope_original};

Z1_cycles = 5;
Z2_smaller = 10;
Z2_equal = 10;

n = 5;
m1 = 10;

m2_range = n:30;
total_times_max_opt = m2_range .* 0;
total_times_min_opt = m2_range .* 0;
total_times_mean_opt = m2_range .* 0;

total_times_max_poly = m2_range .* 0;
total_times_min_poly = m2_range .* 0;
total_times_mean_poly = m2_range .* 0;

total_times_max_or = m2_range .* 0;
total_times_min_or = m2_range .* 0;
total_times_mean_or = m2_range .* 0;

size_m2_range = size(m2_range, 2);

parfor i_m2 = 1:size_m2_range
    m2 = m2_range(i_m2)
    disp(m2)

    [mean_times, min_times, max_times, discrepancies] = main_operation(n, m2, m1, methods, Z1_cycles, Z2_smaller, Z2_equal);
    
    total_discrepancies(i_m2) = discrepancies;
    
    total_times_max_opt(i_m2) = max_times(1);
    total_times_min_opt(i_m2) = min_times(1);
    total_times_mean_opt(i_m2) = mean_times(1);
    
    total_times_max_poly(i_m2) = max_times(2);
    total_times_min_poly(i_m2) = min_times(2);
    total_times_mean_poly(i_m2) = mean_times(2);
    
    total_times_max_or(i_m2) = max_times(3);
    total_times_min_or(i_m2) = min_times(3);
    total_times_mean_or(i_m2) = mean_times(3);
end

x = [m2_range, fliplr(m2_range)];

inBetween_opt = [total_times_max_opt, fliplr(total_times_min_opt)];
fill(x, inBetween_opt, 'r', 'EdgeColor', 'r', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p1 = plot(m2_range, total_times_mean_opt, 'ro-');
hold on
inBetween_poly = [total_times_max_poly, fliplr(total_times_min_poly)];
fill(x, inBetween_poly, 'b', 'EdgeColor', 'b', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p2 = plot(m2_range, total_times_mean_poly, 'bx-');

inBetween_or = [total_times_max_or, fliplr(total_times_min_or)];
fill(x, inBetween_or, 'k', 'EdgeColor', 'k', 'FaceAlpha', 0.2, 'EdgeAlpha', 0.2);
p3 = plot(m2_range, total_times_mean_or, 'kx-');
hold off

title('Runtime of $ZC^O$ versus $ZC^n$ for fixed $n = 5$ and $m_1 = 10$.', 'Interpreter', 'latex')
xlabel('$m_2$', 'Interpreter', 'latex')
ylabel('Runtime, in [s]', 'Interpreter', 'latex')
legend([p1 p2 p3], {'$ZC^O$', '$ZC^n$', '$ST$'}, 'Interpreter', 'latex', 'Location', 'northwest')
%saveas(gcf, 'n.pdf')
export_fig('n.pdf', '-pdf', '-transparent');