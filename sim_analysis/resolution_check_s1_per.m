% compare the settling speed for different resolutions
% for s1_periodic cases

% directory
base = '/scratch/ddeepwel/multi_part/row/Frinf/resolution/s1_periodic/';
% cases
dirs = {'dx16',...
        'dx32',...
        'dx64'};
% legend label
leg = {'$\Delta x / D_p = 1/16$',...
       '$\Delta x / D_p = 1/32$',...
       '$\Delta x / D_p = 1/64$',...
    };

% setup figure
figure(77)
clf
hold on

% loop through cases
for nn = 1:length(dirs)
    cd([base,dirs{nn}])

    % use particle velocity as comparison diagnostic
    [time, y_p, vel] = particle_settling();
    plot(time, -vel)
end

% labels and legend
xlabel('$t/\tau$')
ylabel('$w_p/w_s$')
legend(leg)
legend('location','southeast')
legend('boxoff')

figure_defaults()

% print figure
check_make_dir('../figures')
cd('../figures')
print_figure('resolution','format','pdf','size',[6 4])
cd('..')
