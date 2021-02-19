% Plot a 2D cross-section of 3D field

% options
field = '/v';
plane = 'x';
val = 0;
outputs = 5;

% setup
fieldname = ['/',field];
last_out = last_output('Data');

%filename = sprintf('Data_%d.h5',0);
%data0 = h5read(filename, fieldname);
%gd = read_grid(filename);
%ind = nearest_index(gd.zc,0);
%data2d0 = squeeze(data0(:,:,ind));

for ii = outputs
    % load data
    filename = sprintf('Data_%d.h5',ii);
    data = h5read(filename, fieldname);
    vf = h5read(filename, '/vfc');
    time = h5read(filename, '/time');

    % load grid
    gd = read_grid(filename);

    switch plane
        case 'x'
            ind = nearest_index(gd.xc, val);
            xsec = gd.xc(ind);
            data2d = squeeze(data(ind,:,:));
            vf2d   = squeeze(  vf(ind,:,:));
        case 'y'
            ind = nearest_index(gd.yc, val);
            xsec = gd.yc(ind);
            data2d = squeeze(data(:,:,ind));
            vf2d   = squeeze(  vf(:,:,ind));
        case 'z'
            ind = nearest_index(gd.zc, val);
            xsec = gd.zc(ind);
            data2d = squeeze(data(:,ind,:));
            vf2d   = squeeze(  vf(:,ind,:));
    end

    figure(84)
    clf
    switch plane
        case 'x'
            pcolor(gd.zc, gd.yc, data2d.*(1-vf2d))
        case 'y'
            pcolor(gd.xc, gd.zc, data2d'.*(1-vf2d'))
        case 'z'
            pcolor(gd.xc, gd.yc, data2d'.*(1-vf2d'))
    end
    shading flat
    colorbar
    %caxis([-1 1]*max(abs(data2d(:))));
    caxis auto
    colormap(cmocean('balance'))

    title(sprintf('%s, $%s$ = %5.3g, $t_i$ = %d, $t$ = %5.3g',field,plane,xsec,ii,time))
    figure_defaults()
    drawnow
end
