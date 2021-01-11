function [time, aspect_ratio] = cluster_aspect_ratio()
% find the cluster aspect ratio as a function of time

[time, x_com, y_com, z_com, Np] = particle_centre_of_mass();

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

ymax = max(y_p - y_com, [], 2);
ymin = min(y_p - y_com, [], 2);
xmax = max(x_p - x_com, [], 2);
xmin = min(x_p - x_com, [], 2);

aspect_ratio = (ymax - ymin) ./ (xmax - xmin);
