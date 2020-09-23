% compare the stratification to the background
% useful for understanding the entrainment value
% ie: int (rho_bar - rho) phi_f dV


ii = 81/3;
%ii = 18/6;

true_background = true;

gd = read_grid();
par = read_params();
ymin = par.ymin;
ymax = par.ymax;
fieldname = 'c0';

% get stratification with particles
[rho, vf, time] = read_variable_3d(fieldname, ii);
[Nx,Ny,Nz] = size(rho);
disp(['time = ',num2str(time)])

if true_background
    % get background strat (0 particles)
    direc0 = '/scratch/ddeepwel/bsuther/multi_part/row/test_Np0_s2_Fr1';
    %direc0 = '../0prt';
    orig_dir = cd(direc0);
    [rho0, vf0, time0] = read_variable_3d(fieldname, ii);
    disp(['time0 = ',num2str(time0)])
    cd(orig_dir)
    rho_bg_vec = rho0(1,:,1);
else
    % get background strat from far field
    rho_bg_vec = rho(1,:,1);
end

rho_bg = repmat(rho_bg_vec,[Nx,1,Nz]);

zi = round(Nz/2);

figure(57)
clf

subplot(1,3,1)
pcolor(gd.xc, gd.yc, squeeze(rho(:,:,zi).*(1-vf(:,:,zi)))')
shading flat
caxis([-ymax -ymin])

subplot(1,3,2)
pcolor(gd.xc, gd.yc, squeeze(rho_bg(:,:,zi))')
shading flat
caxis([-ymax -ymin])

ax3 = subplot(1,3,3);
pcolor(gd.xc, gd.yc, squeeze((rho_bg(:,:,zi) - rho(:,:,zi)).*(1-vf(:,:,zi)))')
shading flat
caxis([-1 1])

colormap(cmocean('tempo'))
colormap(ax3, cmocean('balance'))
