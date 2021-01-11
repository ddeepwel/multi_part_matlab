% compare the settling speed for different resolution 
% for s1_periodic cases

pID = 6;

base = '/scratch/ddeepwel/multi_part/row/Frinf/resolution/N11_s1_y02_periodic/';
dirs = {'dx16',...
        'dx32'};%,...
        %'dx64'};
leg = {'$\Delta x / D_p = 1/16$',...
       '$\Delta x / D_p = 1/32$'};%,...
       %'$\Delta x / D_p = 1/64$'};

figure(77)
clf
subplot(2,1,1)
hold on

for nn = 1:length(dirs)
    cd([base,dirs{nn}])

    % use particle velocity as comparison diagnostic
    [time, y_p, vel] = particle_settling(pID-1);
    plot(time, -vel)
end

xlabel('$t/\tau$')
ylabel('$w_p/w_s$')
title(['particle ',int2str(pID)])

legend(leg)
legend('location','southeast')
legend('boxoff')

xl = xlim();

%%%%%% 2nd subplot 
% plot the average difference between resolution cases
subplot(2,1,2)
hold on

[~, Np] = particle_initial_positions;
[time0, ~, ~] = particle_settling(pID); % get a default time
for nn = 1:length(dirs)
    cd([base,dirs{nn}])
    for mm = 1:Np
        [time, y_p, vel] = particle_settling(mm-1);
        vel_interp = interp1(time, vel, time0, 'linear');
        vel_mat(:,mm,nn) = vel_interp;
    end
end

vel_avg = squeeze(mean(vel_mat,2));

plot(time0, -vel_avg)
title('average over particles')

xlabel('$t/\tau$')
ylabel('$w_p/w_s$')
xlim(xl)



figure_defaults()

check_make_dir('../figures')
cd('../figures')
print_figure('resolution','format','pdf','size',[6 4])
cd('..')
