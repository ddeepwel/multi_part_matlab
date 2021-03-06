% plot the settling velocity of an individual isolated particle
% for various domain widths 
  
% select directory
%base = '/scratch/ddeepwel/multi_part/row/Frinf/';
base = [pwd,'/'];
% select cases
dirs = {'Lx05',...
        'Lx10',...
        'Lx20',...
        ...%'Lx30',...
        'Lx40',...
        'Lx80',...
       };
% legend labels
leg = {'$L_x/D_p = 5$',...
    '$L_x/D_p = 10$',...
    '$L_x/D_p = 20$',...
    ...%'$L_x/D_p = 30$',...
    '$L_x/D_p = 40$',...
    '$L_x/D_p = 80$',...
    };

% setup figure
figure(62)
clf

for nn = 1:length(dirs)
    try
        cd([base,dirs{nn}])
    catch
        disp(['directory ',leg{nn},' not found'])
        continue
    end

    % use particle velocity as comparison diagnostic
    plot_particle_settling();
end

% add legend and make pretty
legend(leg)
figure_defaults();

cd('../figures')
print_figure('domain_test','format','pdf');
cd('..')
