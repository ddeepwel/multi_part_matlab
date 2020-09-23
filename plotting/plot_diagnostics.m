% plot PARTIES diagnostics

%diagnos = table2struct(readtable('diagnostics.dat'), 'ToScalar', true);
diagnos = check_read_dat('diagnostics');

iter   = diagnos.iter;
time   = diagnos.time;
max_c0 = diagnos.max_c0;
min_c0 = diagnos.min_c0;


figure(20)
clf
hold on

%subplot(2,1,1)
plot(time, max_c0-1)
plot(time, abs(min_c0))
xlabel('$t/\tau$')
legend('max $c_0-1$','$|$min $c_0|$')
legend('boxoff')

figure_defaults()
check_make_dir('figures')
cd('figures')
print_figure('diagnos_c0','format','pdf','size',[6 4])
cd('..')
