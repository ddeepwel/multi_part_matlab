function p_h = plot_particle_separation_x(p1, p2, save_plot, multi_plot)
% plot horizontal separation between two particles

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

[time, sep, sep_vel] = particle_separation_x(p1, p2);
disp('negative separation means trailing particle is above leading particle')

% check if reached bottom and don't plot after this
hit_bottom = reached_bottom();
if hit_bottom
    [tb, ti] = reach_bottom_time;
    inds = 1:ti;
else
    inds = 1:length(time);
end

figure(53)
if ~multi_plot
    clf
end

subplot(2,1,1)
hold on
plot(time(inds), sep(inds)-1) % assuming D_p = 1
if hit_bottom
    plot(time(ti),sep(ti)-1,'kx')
end

%xlabel('$t$')
ylabel('$s_x/D_p$')
title('horizontal particle separation')
%yl = ylim();
%ylim([0 yl(2)])
grid on

subplot(2,1,2)
hold on
p_h = plot(time(inds),sep_vel(inds));
if hit_bottom
    plot(time(ti),sep_vel(ti),'kx')
end

xlabel('$t/\tau$')
ylabel('$u_{x,sep}/w_s$')
title('separation velocity')
grid on

figure_defaults()

if save_plot
    check_make_dir('figures')
    cd('figures')
    print_figure('particle_separation','format','pdf','size',[6 4])
    cd('..')
end
