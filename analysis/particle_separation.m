function [time, sep, sep_vel] = particle_separation(p1, p2)
% PARTICLE_SEPARATION    return the separation distance between two particles
%
%  Inputs:
%    'p1' - ID for 1st particle
%    'p2' - ID for 2nd particle
%
%  Outputs:
%    'time'     - the simulation time (vector)
%    'sep'      - the particle separation distance
%                 as measured from particle centres (vector)
%    'sep_vel'  - separation velocity - time derivative of 'sep' (vector)

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

% find time and separation distance
time = p1_data.time;
sep = sqrt( (p1_data.x - p2_data.x).^2 ...
           +(p1_data.y - p2_data.y).^2 ...
           +(p1_data.z - p2_data.z).^2 );
% create derivative matrix and calculate separation velocity
Dmat = FiniteDiff(time,1,2,true,false);
sep_vel = Dmat * sep;
