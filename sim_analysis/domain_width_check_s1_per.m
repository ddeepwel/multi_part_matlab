% check the domain width for a single settling particle
% for a periodic row of particle with s/D_p = 1


base = '/scratch/ddeepwel/multi_part/row/Frinf/domain_width/s1_periodic/';
dirs = {...
        'Lz10',...
        'Lz20',...
        'Lz40',...
        'Lz80',...
       };
leg = {...
    '$L_z/D_p = 10$',...
    '$L_z/D_p = 20$',...
    '$L_z/D_p = 40$',...
    '$L_z/D_p = 80$',...
    };

figure(62)
clf
hold on

for nn = 1:length(dirs)
    try
        cd([base,dirs{nn}])
    catch
        disp(['directory ',leg{nn},' not found'])
        continue
    end

    % use particle velocity as comparison diagnostic
    [time,yp,vel] = particle_settling();

    plot(time,-vel)
end

xlabel('$t/\tau$')
ylabel('$w_p/w_s$')

legend(leg)
figure_defaults();

cd('../figures')
print_figure('domain_test','format','pdf');
cd('..')
