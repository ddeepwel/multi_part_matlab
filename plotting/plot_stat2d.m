function [data, vf, xvar, yvar, xy_p] = plot_stat2d(group, field, t_index, varargin);
% Plot a 2D statistic

if nargin == 7
    fnum  = varargin{1};
    clim  = varargin{2};
    style = varargin{3};
    doplot = varargin{4};
elseif nargin == 6
    fnum  = varargin{1};
    clim  = varargin{2};
    style = varargin{3};
    doplot = true;
elseif nargin == 5
    fnum  = varargin{1};
    clim  = varargin{2};
    style = 'pcolor';
    doplot = true;
elseif nargin ==4;
    fnum = varargin{1};
    clim = 'auto';
    style = 'pcolor';
    doplot = true;
else
    fnum = 95;
    style = 'pcolor';
    clim = 'auto';
    doplot = true;
end

% load grid
filename_2d = sprintf('Data2d_%d.h5',t_index(1));
gd = read_grid(filename_2d);
par = read_params();

% select grid variables and labels
% shift grid so that ticks show up nicely
dx = gd.x(2) - gd.x(1);
dy = gd.y(2) - gd.y(1);
dz = gd.z(2) - gd.z(1);
if strcmp(group(1:2), 'xy')
    xvar = gd.x - dx/2;
    yvar = gd.y - dy/2;
    xlab = '$x/D_p$';
    ylab = '$y/D_p$';
elseif strcmp(group(1:2), 'xz') || strcmp(group, 'integral_y')
    xvar = gd.x - dx/2;
    yvar = gd.z - dz/2;
    xlab = '$x/D_p$';
    ylab = '$z/D_p$';
end
if strcmp(field, 'c0') || strcmp(field, 'c1')
    cmap = cmocean('tempo');
elseif strcmp(field, 'KE_h')
    cmap = cmocean('-ice');
else
    cmap = cmocean('balance');
end

fieldname = ['/',group,'/',field];

% loop over output indices
for ii = t_index
    % load data
    filename_2d = sprintf('Data2d_%d.h5',ii);
    if strcmp(group(1:2), 'xy')
        % get data at z=0 as avg of data a half grid cell off on either side
        data1 = h5read(filename_2d, ['/xy1/',field]);
        data2 = h5read(filename_2d, ['/xy2/',field]);
        data = (data1 + data2)/2;

        vf1 = h5read(filename_2d, ['/xy1/vf']);
        vf2 = h5read(filename_2d, ['/xy2/vf']);
        vf = (vf1 + vf2)/2;

        xsec1 = h5read(filename_2d, '/xy1/z');
        xsec2 = h5read(filename_2d, '/xy2/z');
        xsec = (xsec1 + xsec2)/2;
        seclab = sprintf('$z/D_p=%2.0f$', xsec);
    elseif strcmp(field, 'KE_h')
        u = h5read(filename_2d, ['/',group,'/u']);
        w = h5read(filename_2d, ['/',group,'/w']);
        data = 0.5 * (u.^2 + w.^2);

        % volume fraction
        vf = h5read(filename_2d, ['/',group,'/vf']);

        xsec = h5read(filename_2d, ['/',group,'/y']);
        seclab = sprintf('$y/D_p=%2.0f$', xsec);
    else
        data = h5read(filename_2d, fieldname);
        if strcmp(group, 'integral_y')
            vf = 0;
            seclab = '$\int dy$';
        else
            xsec = h5read(filename_2d, ['/',group,'/y']);
            seclab = sprintf('$y/D_p=%2.0f$', xsec);
            % volume fraction
            vf = h5read(filename_2d, ['/',group,'/vf']);
        end
    end
    if strcmp(field, 'c1')
        data = 1-data;
    end
    time = h5read(filename_2d, '/time');

    % make figure
    if doplot
        figure(fnum)
        clf
        hold on
        switch style
            case 'pcolor'
                pcolor(xvar, yvar, data'.*(1-vf'))
            case 'contourf'
                contourf(xvar, yvar, data'.*(1-vf'),51)
            case 'contour'
                contour(xvar, yvar, data'.*(1-vf'),10)
        end
        shading flat
        %contour(xvar, yvar, data'.*(1-vf'), [1 1]*0.5)
        %contour(xvar, yvar, data'.*(1-vf'), 20)

        % add particle positions
        if ~strcmp(group, 'integral_y')
            if strncmp(group(1:2), 'xy',2)
                particle_files = dir('mobile_*.dat');
                N_files = length(particle_files);
                p = cell(1, N_files);
                for mm = 1:N_files
                    fname = sprintf('mobile_%d', mm-1);
                    p{mm} = check_read_dat(fname);
                    x = p{mm}.x;
                    y = p{mm}.y;
                    ind = nearest_index(p{1}.time, time);
                    xy_p(mm,:) = [x(ind) y(ind)];
                    viscircles(xy_p(mm,:), 0.5, 'Color', [0 0 0], 'LineWidth', 1);
                end
            else
                % contours do not seem to work very well
                %warning('off','MATLAB:contour:ConstantData')
                %contour(xvar, yvar, (1-vf'),[1 1])
                %warning('on','MATLAB:contour:ConstantData')
            end
        end

        colorbar
        xlabel(xlab)
        ylabel(ylab)
        if strcmp(field,'c0') || strcmp(field,'c1')
            caxis([min(data(:)) max(data(:))])
        elseif ischar(clim)
            caxis([-1 1]*max(abs(data(:))));
        else
            caxis(clim)
        end
        colormap(cmap)

        %title(sprintf('$%s$, $t_n$ = %d, $t$ = %2.2g',strrep(field, '_', ' '), ii,time))
        if strcmp(field, 'c_curve_diag')
            field = '\textrm{c curvature}';
        end
        if par.output_time_interval_2d < 1
            ttl = sprintf('$%s$, $t/\\tau$ = %4.2f, %s',field, time, seclab);
        else
            ttl = sprintf('$%s$, $t/\\tau$ = %2.2f, %s',field, time, seclab);
        end
        title(ttl, 'Interpreter','Latex');
        figure_defaults()
    else
        xy_p = [0 0];
        % this is incorrect, but I don't want to program it in right now
    end
end
