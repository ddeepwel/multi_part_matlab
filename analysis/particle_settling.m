function [time, y_p, vel] = particle_settling(pID)
% PARTICLE_SETTLING  Calculate the particle settling velocity
%
%  Inputs:
%    'pID' - particle ID
%
%  Outputs:
%    'time'   - a vector of the simulation time
%    'theta'  - a vector of the orientation angle (as measured from the vertical)

% default input arguments
if nargin == 0
    pID = 0;
end

% load data
p_file = sprintf('mobile_%d', pID);
p_data = check_read_dat(p_file);

% get data
time = p_data.time;
y_p  = p_data.y;

% calculate velocity
Dmat = FiniteDiff(time, 1, 2, true, false);
vel = Dmat * y_p;

