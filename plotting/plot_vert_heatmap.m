function [] = plot_vert_heatmap(tc,fnum)
% plot a heatmap of where particles are located

if nargin == 1
    fnum = 95;
end

[t_snapshot, xyz_p] = particle_snapshot(tc);

[Np,~] = size(xyz_p);
x_p = xyz_p(:,1);
y_p = xyz_p(:,2);
z_p = xyz_p(:,3);

par = read_params();
Lx = par.xmax - par.xmin;
Ly = par.ymax - par.ymin;
Lz = par.zmax - par.zmin;

dx = Lx / par.NXM;
dz = Lz / par.NZM;
xx = linspace(par.xmin, par.xmax-dx, par.NXM)';
zz = linspace(par.zmin, par.zmax-dz, par.NZM);
R = 0.5; % radius of particle

figure(fnum)
clf

part_map = zeros(par.NXM, par.NZM);
for nn = 1:Np
    part_loc = (R^2 - (xx - x_p(nn)).^2 - (zz - z_p(nn)).^2) / R^2;
    part_loc(part_loc<0) = 0;
    part_map = part_map + part_loc;
end

pcolor(xx, zz, part_map')

axis image
axis([par.xmin par.xmax par.zmin par.zmax])
xlabel('$x/D_p$')
ylabel('$z/D_p$')
ttl = sprintf('$t/\\tau=%.3g$',t_snapshot);
title(ttl)

cb = colorbar;
%caxis([ymin ymax]);

figure_defaults()
shading flat
