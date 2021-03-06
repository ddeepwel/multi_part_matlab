function [time, sep, sep_vel] = particle_separation_x(p1, p2)
% return the horizontal separation distance (in x) and velocity as a time series

if nargin == 0
    p1 = 0;
    p2 = 1; 
end

p1_file = sprintf('mobile_%d', p1);
p2_file = sprintf('mobile_%d', p2);
p1_data = check_read_dat(p1_file);
p2_data = check_read_dat(p2_file);

time = p1_data.time;

sep = abs( p1_data.x - p2_data.x );

Dmat = FiniteDiff(time,1,2,true,false);
sep_vel = Dmat * sep;
