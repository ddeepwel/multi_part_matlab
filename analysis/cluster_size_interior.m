function [time,dist,dist_x] = cluster_size_interior()
% find the cluster size of the interior points as a function of time

[time, x_com, y_com, z_com, Np] = particle_centre_of_mass_interior();

for nn = 1:Np
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn) = p_data.x;
    y_p(:,nn) = p_data.y;
    z_p(:,nn) = p_data.z;
end

dist = 1/Np * sum(sqrt(...
    (x_p - x_com).^2 + ...
    (y_p - y_com).^2 + ...
    (z_p - z_com).^2), 2);

dist_x = 1/Np * sum(sqrt(...
    (x_p - x_com).^2), 2);
