function [t_snapshot, xyz_p] = particle_snapshot(tc)
% PARTICLE_SNAPSHOT  Find the position of the particles at t=tc
%
%  Inputs:
%    'tc' - time for snapshot
%
%  Outputs:
%    'time'   - a vector of the simulation time
%    'theta'  - a vector of the orientation angle (as measured from the vertical)

if nargin == 0
    error('no input arguments given, one expected: time of snapshot')
end

[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    t_ind = nearest_index(time,tc);

    x_p(nn+1,1) = xyz_p(t_ind,1);
    y_p(nn+1,1) = xyz_p(t_ind,2);
    z_p(nn+1,1) = xyz_p(t_ind,3);
end

t_snapshot = time(t_ind);
xyz_p = [x_p, y_p, z_p];
