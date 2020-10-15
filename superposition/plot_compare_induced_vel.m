function plot_compare_induced_vel(particle_ID)
% plot the induced flow for a particle

if nargin == 0
    particle_ID = 0;
end

direcs = {'s1_th90','../s2_th90','../s3_th90'};

for mm = 1:length(direcs)
    cd(direcs{mm})
    [t,ui,vi,wi,tf_min] = induced_vel(particle_ID);

    inds = 1:nearest_index(t,tf_min)-1;
    t = t(inds);
    ui = ui(inds);
    vi = vi(inds);
    wi = wi(inds);

    figure(46)
    if mm == 1
        clf
        hold on
    end
    plot(t,ui)
    ylabel('$u_{induced}$')
    xlabel('$t/\tau$')
    grid on
    if mm == length(direcs)
        legend('$s/D_p=1$','$s/D_p=2$','$s/D_p=3$')
        figure_defaults()
    end

    figure(47)
    if mm == 1
        clf
        hold on
    end
    plot(t,vi)
    ylabel('$v_{induced}$')
    xlabel('$t/\tau$')
    grid on
    if mm == length(direcs)
        legend('$s/D_p=1$','$s/D_p=2$','$s/D_p=3$')
        figure_defaults()
    end

    figure(48)
    if mm == 1
        clf
        hold on
    end
    plot(t,wi)
    ylabel('$w_{induced}$')
    xlabel('$t/\tau$')
    grid on
    if mm == length(direcs)
        legend('$s/D_p=1$','$s/D_p=2$','$s/D_p=3$')
        figure_defaults()
    end
end


