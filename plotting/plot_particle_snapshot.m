function [] = plot_particle_snapshot(tc,fnum)
% plot the particle positions at time ts

if nargin == 1
    fnum = 55;
end

[t_snapshot, xyz_p] = particle_snapshot(tc);

[Np,~] = size(xyz_p);

figure(fnum)
clf

%viscircles(xyz_p(:,1:2), ones(Np,1)*0.5);
viscircles(xyz_p(:,[1, 2]), ones(Np,1)*0.5);

axis image
xlabel('$x/D_p$')
ylabel('$y/D_p$')
ttl = sprintf('$t/\\tau=%.3g$',t_snapshot);
title(ttl)

figure_defaults()
