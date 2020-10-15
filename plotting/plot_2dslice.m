% Plot a 2D cross-section of 3D field

% options
field = '/p';
plane = 'z';
val = 0;
outputs = 0;

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

    %ind = nearest_index(gd.yc, val);
    ind = nearest_index(gd.zc, val);
    data2d = squeeze(data(:,:,ind));
    vf2d   = squeeze(  vf(:,:,ind));
    %data2d = squeeze(data(:,ind,:));
    %vf2d   = squeeze(  vf(:,ind,:));

    figure(84)
    clf
    %pcolor(gd.xc, gd.zc, data2d'.*(1-vf2d'))
    pcolor(gd.xc, gd.yc, data2d');%.*(1-vf'))
    shading flat
    colorbar
    %caxis([-1 1]*max(abs(data2d(:))));
    caxis auto
    colormap(cmocean('balance'))

    title(sprintf('%s, $y$ = %5.3g, $t_i$ = %d, $t$ = %5.3g',field,gd.yc(ind),ii,time))
    figure_defaults()
    drawnow
end
