function [] = plot_diagnostics
% plot PARTIES diagnostics

diagnos = check_read_dat('diagnostics');

iter   = diagnos.iter;
time   = diagnos.time;
max_c0 = diagnos.max_c0;
min_c0 = diagnos.min_c0;


figure(20)
clf
hold on

% plot the extrema of the density field
plot(time, max_c0-1)
plot(time, abs(min_c0))
xlabel('$t/\tau$')
legend('max $c_0-1$','$|$min $c_0|$')
legend('boxoff')

% print figure
figure_defaults()
check_make_dir('figures')
cd('figures')
print_figure('diagnos_c0','format','pdf','size',[6 4])
cd('..')
