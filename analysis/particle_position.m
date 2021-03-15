function [time, xyz_p, uvw_p] = particle_position(pID)
% PARTICLE_POSITION Load the particle position and velocity for a particular particle
%
%  Inputs:
%    'pID' - particle ID
%
%  Outputs:
%    'time'   - a vector of the simulation time
%    'xyz_p'  - a vector of the position
%    'uvw_p'  - a vector of the velocity

% default input arguments
if nargin == 0
    pID = 0;
end

% load data
p_file = sprintf('mobile_%d', pID);
p_data = check_read_dat(p_file);
x_p = p_data.x;
y_p = p_data.y;
z_p = p_data.z;
u   = p_data.u;
v   = p_data.v;
w   = p_data.w;

% load parameters
time = p_data.time;
Nt = length(time);
par = read_params();
Ly = par.ymax - par.ymin;

% handle vertical periodicity
if max(diff(y_p)) > Ly/2
    if sum(diff(y_p) > Ly/2) % check if particle has passed through boundary
        idx = find(diff(y_p) > Ly/2);
        for mm = 1:length(idx) % loop through the times the particle passes the boundary
            y_p(idx(mm)+1:end) = y_p(idx(mm)+1:end) - Ly;
        end
    end
end

xyz_p = [x_p y_p z_p];
uvw_p = [u v w];
