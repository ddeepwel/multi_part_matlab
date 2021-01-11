function [] = plot_particle_positions_xy(style)
% plot particle positions and colour by time
% styles are:
%       'init'      - use initial particle positions
%       'regular'   - assume that the particles are equispaced (or close to it)

par = read_params();

if nargin == 0
    style = 'init';
end


% search for particle files
particle_files = dir('mobile_*.dat');
Np = length(particle_files);

% read particle files
p = cell(1, Np);
for mm = 1:Np
    fname = sprintf('mobile_%d', mm-1);
    p{mm} = check_read_dat(fname);
end

% make plot
figure(65)
clf
hold on

time = p{1}.time;
Nt = length(time);
colormap(parula(Nt))
cmap = colormap(parula(Nt));
for mm = 1:Np
    x = p{mm}.x;
    y = p{mm}.y;
    col = p{mm}.time;
    scatter(x,y,[],col,'fill','SizeData',8)
end

% add horizontal bands at intervals of 5 time units
%for ts = 0:5:time(end)
%    ind = nearest_index(time, ts);
%    cmap_ind = round(ts/time(end) * (Nt-1) + 1);
%    plot([p{1}.x(ind) p{2}.x(ind)],[p{1}.y(ind) p{2}.y(ind)], 'Color', cmap(cmap_ind,:))
%end

% find particle spacing
for mm = 1:Np
    xp(mm) = p{mm}.x(1);
end
xp_mean = round(mean(diff(xp)));
xp_reg = (par.xmin + xp_mean/2):xp_mean:(par.xmax + xp_mean/2);

% add vertical lines of initial particle positions
for mm = 1:Np
    switch style
        case 'init'
            plot([1 1]*p{mm}.x(1), [par.ymax par.ymin],'k','color',[0 0 0 0.3])
        case 'regular'
            plot([1 1]*xp_reg(mm), [par.ymax par.ymin],'k','color',[0 0 0 0.3])
    end
end
plot(xlim, [0 0],'k','color',[0 0 0 0.3])

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

figure(66)
clf
hold on

for mm = 1:Np
    x = p{mm}.x;
    y = p{mm}.y;
    col = p{mm}.time;
    switch style
        case 'init'
            xdraw = x - x(1);
        case 'regular'
            xdraw = x-xp_reg(mm);
    end
    scatter(xdraw,y,[],col,'fill','SizeData',8)
    text(xdraw(round(Nt*3/4)), y(round(Nt*3/4)), num2str(mm))
end

switch style
    case 'init'
        xlabel('$(x-x_0)/D_p$')
    case 'regular'
        xlabel('$(x-x_{reg})/D_p$')
end
ylabel('$y/D_p$')
grid on
cbar = colorbar;
cbar.Label.String = '$t/\tau$';


figure_defaults()

cd('figures')
%print_figure('particle_positions_centred','format','jpeg')
cd('..')
