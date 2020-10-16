function [time, theta] = particle_angle(p1, p2)
% return the orientation angle as a time series

if nargin == 0
    p1 = 0;
    p2 = 1; 
end

p1_file = sprintf('mobile_%d', p1);
p2_file = sprintf('mobile_%d', p2);
p1_data = check_read_dat(p1_file);
p2_data = check_read_dat(p2_file);

time = p1_data.time;

x =   p2_data.x - p1_data.x;
y = -(p2_data.y - p1_data.y);

theta = atand(x./y);
