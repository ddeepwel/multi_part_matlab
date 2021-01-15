function [time,dist,dist_x] = cluster_size()
% find the cluster size as a function of time

[time, x_com, y_com, z_com, Np] = particle_centre_of_mass();

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

dist = 1/Np * sum(sqrt(...
    (x_p - x_com).^2 + ...
    (y_p - y_com).^2 + ...
    (z_p - z_com).^2), 2);

dist_x = 1/Np * sum(sqrt(...
    (x_p - x_com).^2), 2);
