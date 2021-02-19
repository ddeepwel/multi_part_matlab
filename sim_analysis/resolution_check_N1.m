% compare the settling speed for different resolutions
% for N1 particle


base = '/scratch/ddeepwel/multi_part/row/Fr2/resolution/';
%base = '/scratch/ddeepwel/multi_part/row/Frinf/resolution/';

switch base
    case '/scratch/ddeepwel/multi_part/row/Frinf/resolution/'
        dirs = {'dx16',...
            'dx24',... % for Frinf
            'dx32'};%,...
        %'dx64'};
        leg = {'$\Delta x / D_p = 1/16$',...
            '$\Delta x / D_p = 1/24$',... % for Frinf
            '$\Delta x / D_p = 1/32$'};%,...
        %'$\Delta x / D_p = 1/64$'};
    case '/scratch/ddeepwel/multi_part/row/Fr2/resolution/'
        dirs = {'dx16',...
            'dx32'};%,...
        %'dx64'};
        leg = {'$\Delta x / D_p = 1/16$',...
            '$\Delta x / D_p = 1/32$'};%,...
        %'$\Delta x / D_p = 1/64$'};
end

% setup figure
figure(77)
clf
hold on

% loop through cases
for nn = 1:length(dirs)
    cd([base,dirs{nn}])

    % use particle velocity as comparison diagnostic
    [time, xyz_p, uvw_p] = particle_settling();
    vel = uvw_p(:,2);
    plot(time, -vel)
end

% labels, and legend
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
