function [time, theta] = particle_angle(p1, p2)
% PARTICLE_ANGLE    return the orientation angle as a time series
%
%  Inputs:
%    'p1' - ID for 1st particle
%    'p2' - ID for 2nd particle
%
%  Outputs:
%    'time'   - a vector of the simulation time
%    'theta'  - a vector of the orientation angle (as measured from the vertical)
%               in degrees

% default input arguments
if nargin == 0
    p1 = 0;
    p2 = 1; 
end

% load particle positions
p1_file = sprintf('mobile_%d', p1);
p2_file = sprintf('mobile_%d', p2);
p1_data = check_read_dat(p1_file);
p2_data = check_read_dat(p2_file);

% find time and relative positions
time = p1_data.time;
x =   p2_data.x - p1_data.x;
y = -(p2_data.y - p1_data.y);

% calculate orientation angle
theta = atand(x./y);
