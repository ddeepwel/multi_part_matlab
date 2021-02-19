function [] = plot_particle_positions(style)
% PLOT_PARTICLE_POSITIONS  plot particle positions over time as they settle
%
% Inputes:
%   'style' - can be either:
%       'init'      - use initial particle positions
%       'regular'   - assume that the particles are equispaced (or close to it)

% set default input argument
if nargin == 0
    style = 'init';
end

% number of particle
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    x_p(:,nn+1) = xyz_p(:,1);
    y_p(:,nn+1) = xyz_p(:,2);
end

% load parameters
Nt = length(time);
par = read_params();

% setup figure
figure(65)
clf
hold on
colormap(parula(Nt))
cmap = colormap(parula(Nt));

for mm = 1:Np
    scatter(x_p(:,mm), y_p(:,mm), [], time, 'fill', 'SizeData',8)
end

% add horizontal bands at intervals of 5 time units
%for ts = 0:5:time(end)
%    ind = nearest_index(time, ts);
%    cmap_ind = round(ts/time(end) * (Nt-1) + 1);
%    plot([p{1}.x(ind) p{2}.x(ind)],[p{1}.y(ind) p{2}.y(ind)], 'Color', cmap(cmap_ind,:))
%end

% add vertical lines of initial particle positions
for mm = 1:Np
    switch style
        case 'init'
            plot([1 1]*x_p(1,mm), [par.ymax par.ymin],'k','color',[0 0 0 0.3])
        case 'regular'
            % find average particle spacing
            xp_mean = round(mean(diff(x_p(1,:))));
            % create array of the spacing
            xp_reg = (par.xmin + xp_mean/2):xp_mean:(par.xmax + xp_mean/2);

            plot([1 1]*xp_reg(mm), [par.ymax par.ymin],'k','color',[0 0 0 0.3])
    end
end
plot(xlim, [0 0],'k','color',[0 0 0 0.3])

% add figure details
cbar = colorbar;
cbar.Label.String = '$t/\tau$';
xlabel('$x/D_p$')
ylabel('$y/D_p$')
title('particle position')
axis([par.xmin, par.xmax par.ymin par.ymax])

figure_defaults()

% save figure
check_make_dir('figures')
cd('figures')
print_figure('particle_positions','format','pdf','size',[6 4])
cd('..')


%%%%% 2nd Figure %%%%%
% plot particle tracks after collapsing initial position onto
% the same location

% figure(66)
% clf
% hold on
% 
% for mm = 1:Np
%     x = x_p(:,mm);
%     y = y_p(:,mm);
%     switch style
%         case 'init'
%             xdraw = x - x(1);
%         case 'regular'
%             xdraw = x-xp_reg(mm);
%     end
%     scatter(xdraw, y, [], time, 'fill', 'SizeData',8)
%     text(xdraw(round(Nt*3/4)), y(round(Nt*3/4)), num2str(mm))
% end
% 
% switch style
%     case 'init'
%         xlabel('$(x-x_0)/D_p$')
%     case 'regular'
%         xlabel('$(x-x_{reg})/D_p$')
% end
% ylabel('$y/D_p$')
% grid on
% cbar = colorbar;
% cbar.Label.String = '$t/\tau$';
% 
% 
% figure_defaults()
% 
% cd('figures')
% %print_figure('particle_positions_centred','format','jpeg')
% cd('..')
