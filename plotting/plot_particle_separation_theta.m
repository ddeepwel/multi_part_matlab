function p_h = plot_particle_separation_theta(sep,p1,p2,save_plot)
% plot the particle separation for multiple cases with different
% orientation angles

if nargin == 1
    p1 = 0;
    p2 = 1;
    save_plot = false;
    multi_plot = false;
elseif nargin == 3
    save_plot = false;
    multi_plot = false;
elseif nargin == 4
    multi_plot = false;
end
sep_str = sprintf('s%d',sep);

direcs = {[sep_str,'_th0'],...
    [sep_str,'_th22.5'],...
    [sep_str,'_th45'],...
    [sep_str,'_th67.5'],...
    [sep_str,'_th90']};
theta = [0 22.5 45 67.5 90];

figure(63)
clf
hold on

cd([direcs{1}])
for mm = 1:length(direcs)
    cd(['../',direcs{mm}])

    p_h(mm) = plot_particle_separation(p1,p2,false,true);
end

legend(p_h,'$\theta=0^\circ$','$\theta=22.5^\circ$','$\theta=45^\circ$','$\theta=67.5^\circ$','$\theta=90^\circ$')


figure_defaults();

cd('..')
check_make_dir('figures')
cd('figures')
fname = sprintf('particle_separation_theta_s%d',sep);
print_figure(fname,'format','pdf')
cd('..')
