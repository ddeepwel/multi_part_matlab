function p_h = plot_particle_separation(save_plot, multi_plot)
% plot separation between multiple particles

if nargin == 0
    save_plot = true;
    multi_plot = false;
elseif nargin == 1
    multi_plot = false;
end

par = read_params();
xmax = par.xmax;
xmin = par.xmin;
Lx = xmax - xmin;

% search for particle files
particle_files = dir('mobile_*.dat');
Np = length(particle_files);

figure(64)
if ~multi_plot
    clf
end
hold on

for mm = 1:Np
    % find separation between different particles
    % need to handle periodicity differently
    if mm == Np
        [time, sep, sep_vel] = particle_separation(mm-1, 0);
        sep = Lx - sep;
    else
        [time, sep, sep_vel] = particle_separation(mm-1, mm);
    end

    % find number of outputs of first particle
    if mm == 1
        Nt = length(time);
        Dmat = FiniteDiff(time,1,2,true,false);
    end
    sep_stacked(mm,:) = sep(1:Nt);

    % check if reached bottom and don't plot after this
    hit_bottom = reached_bottom();
    if hit_bottom
        [tb, ti] = reach_bottom_time;
        inds = 1:ti;
    else
        inds = 1:length(time);
    end

    subplot(2,1,1)
    hold on
    plot(time(inds), sep(inds)-1) % assuming D_p = 1
    if hit_bottom
        plot(time(ti),sep(ti)-1,'kx')
    end

    if mm == Np
        leg_lab{mm} = sprintf('$%d - %d$',mm,1);
    else
        leg_lab{mm} = sprintf('$%d - %d$',mm,mm+1);
    end
    text(time(round(Nt/2)), sep(round(Nt/2))-1, leg_lab{mm});

    subplot(2,1,2)
    hold on
    vel = Dmat(1:Nt,1:Nt) * sep(1:Nt);
    plot(time(1:Nt), vel)
    text(time(round(Nt/2)), vel(round(Nt/2)), leg_lab{mm});
end

xlabel('$t/\tau$')
ylabel('derivative of $s$')
%yl = ylim();
%ylim([0 yl(2)])
grid on
%legend(leg_lab)

subplot(2,1,1)
grid on
ylabel('$s/D_p$')
title('particle separation')

figure_defaults()

if save_plot
    check_make_dir('figures')
    cd('figures')
    %print_figure('particle_separation','format','pdf','size',[6 4])
    cd('..')
end


%%%%% 2nd plot %%%%%

% mean particle separation
xp_mean = round(mean(sep_stacked(:,1)));

figure(70)
clf
area(time(1:Nt),(sep_stacked'-1));%/(xp_mean-1))
xlabel('$t/\tau$')
ylabel('$s/s_0$')

figure_defaults()
