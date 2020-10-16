function p_h = plot_particle_angle(p1, p2, save_plot, multi_plot)
% plot separation between two particles

if nargin == 0
    p1 = 0;
    p2 = 1;
    save_plot = false;
    multi_plot = false;
elseif nargin == 2
    save_plot = false;
    multi_plot = false;
elseif nargin == 3
    multi_plot = false;
end

[time, theta] = particle_angle(p1, p2);

% check if reached bottom and don't plot after this
hit_bottom = reached_bottom();
if hit_bottom
    [tb, ti] = reach_bottom_time;
    inds = 1:ti;
else
    inds = 1:length(time);
end

figure(61)
if ~multi_plot
    clf
end

hold on
plot(time(inds), theta(inds))
if hit_bottom
    plot(time(ti),theta(ti),'kx')
end

xlabel('$t/\tau$')
ylabel('$\theta$ ($^\circ$)')
%yl = ylim();
%ylim([0 yl(2)])
grid on
figure_defaults()

if save_plot
    check_make_dir('figures')
    cd('figures')
    print_figure('particle_angle','format','pdf','size',[6 4])
    cd('..')
end
