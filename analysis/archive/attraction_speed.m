function [time, dist, speed] = attraction_speed()
% ATTRACTION_SPEED    find the speed of attraction (or repulsion)
% of the particle to the right of the perturbed particle
% this is assumed to be the middle particle (odd number of particles only)
%
%  Inputs:
%    - none
%    
%  Outputs:
%    'time'  - the simulation time (vector)
%    'dist'  - distance between the two particles (vector)
%    'speed' - speed of attraction/repulsion (vector)

% number of particles
[~, Np] = particle_initial_positions;

if mod(Np,2)
    pL = (Np-1)/2;
    pR = pL + 1;
else
    error('odd number of particles only')
end

[time, dist, speed] = particle_separation(pL, pR);