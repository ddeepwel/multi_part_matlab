function [time, part0, dev] = row_particle_offset()
% find the deviation of each particle from its location
% if it were settling in an infinitely periodic row

% number of particles
[part0, Np] = particle_initial_positions;

% get particle positions
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

time = p_data.time;

% get particle position from periodic row
s0 = part0(2) - part0(1) - 1;
N1_dir = sprintf('../N1_s%d_periodic',s0);
orig_dir = cd(N1_dir);
p_data = check_read_dat('mobile_0');
%x_per = p_data.x;
y_per = p_data.y;
%z_per = p_data.z;
time_per = p_data.time;
cd(orig_dir)
% interpolate onto the finite particle row times
%x_per = interp1(time_per, x_per, time);
y_per = interp1(time_per, y_per, time);
%z_per = interp1(time_per, z_per, time);

% separation of each particle from it's expected location
x_dist = x_p - x_p(1,:);
z_dist = z_p - z_p(1,:);
y_dist = y_p - y_per;

dev = sqrt(x_dist.^2 + y_dist.^2 + z_dist.^2);

