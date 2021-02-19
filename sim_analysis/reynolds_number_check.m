% compare the settling speed for different Reynolds numbers
% for a particle pair with s=2


base = '/scratch/ddeepwel/multi_part/row/Frinf/Re_N2/';
dirs = {'Re1_16',...
        'Re1_8',...
        'Re1_4',...
        'Re1_2',...
        'Re1',...
    };
leg = {'$Re = 1/16$',...
       '$Re = 1/8$',...
       '$Re = 1/4$',...
       '$Re = 1/2$',...
       '$Re = 1$',...
    };

figure(72)
clf
hold on

for nn = 1:length(dirs)
    cd([base,dirs{nn}])

    % use particle velocity as comparison diagnostic
    [time, xyz_p, uvw_p] = particle_settling();
    vel = uvw_p(:,2);
    plot(time, -vel)
end

xlabel('$t/\tau$')
ylabel('$w_p/w_s$')
legend(leg)
legend('location','southeast')
legend('boxoff')

figure_defaults()

check_make_dir('../figures')
cd('../figures')
print_figure('reynolds_N2','format','pdf','size',[6 4])
cd('..')
