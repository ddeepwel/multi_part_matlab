function [] = plot_particle_snapshot(ts,fnum)
% plot the particle positions at time ts

if nargin == 1
    fnum = 55;
end

[time,xyz_p,uvw_p] = particle_position;
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    x_p(:,nn+1) = xyz_p(:,1);
    y_p(:,nn+1) = xyz_p(:,2);
end

t_ind = nearest_index(time,ts);

figure(fnum)
clf

viscircles([x_p(t_ind,:)' y_p(t_ind,:)'], ones(Np,1)*0.5);

axis image
xlabel('$x/D_p$')
ylabel('$y/D_p$')
ttl = sprintf('$t/\\tau=%.3g$',time(t_ind));
title(ttl)

figure_defaults()
