function [time, yy, local_frac] = vol_frac_hor_avg()
% calculate the horizontal average of the local volume fraction

par = read_params();
Lx = par.xmax - par.xmin;
Ly = par.ymax - par.ymin;
Lz = par.zmax - par.zmin;

[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    %t_ind = nearest_index(time,tc);

    %x_p(nn+1,1) = xyz_p(t_ind,1);
    if nn == 0
        inds = 1:length(time);
    end
    y_p(:,nn+1) = xyz_p(inds,2);
    %z_p(nn+1,1) = xyz_p(t_ind,3);
end
time = time(inds);

dx = Ly / par.NYM;
yy = linspace(par.ymin, par.ymax-dx, par.NYM)';
R = 0.5; % radius of particle

% calculate the particle cross-section for all times
for ii = inds
    part_vol = pi * (R^2 - (yy - y_p(ii,:)).^2);
    part_vol(part_vol<0) = 0;

    part_frac = sum(part_vol,2);
    local_frac(:,ii) = part_frac / Lx / Lz;
    
    completion(ii,inds(end))
end

save('volume_frac_hor', 'time', 'yy', 'local_frac')
