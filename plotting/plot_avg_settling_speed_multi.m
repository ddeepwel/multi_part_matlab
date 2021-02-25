function plot_avg_settling_speed_multi
% plot the average settling speed for various cases with similar particle
% separation distance

base = '/Volumes/GoogleDrive/Shared drives/multi_part/numerics/row/Frinf/';
cases = {'N11_s1_periodic_pert/data',...
         'N16_s1_periodic_pert/data',...
         'N22_s1_periodic_pert/data',...
    };
leg_lab = {'$N_p=11$',...
           '$N_p=16$',...
           '$N_p=22$',...
    };

figure(63)
clf
hold on
for mm = 1:length(cases)
    cd([base,cases{mm}])
    [time, avg_speed] = avg_settling_speed;
    plot(time, -avg_speed)
end

cd([base,'N1_s1_periodic/data'])
[time, yp, vp] = particle_settling;
plot(time, -vp, 'k')
leg_lab{length(leg_lab)+1} = 'equi-spaced';


xlabel('$t/\tau$')
ylabel('$w_{avg}/w_s$')
legend(leg_lab)

figure_defaults()