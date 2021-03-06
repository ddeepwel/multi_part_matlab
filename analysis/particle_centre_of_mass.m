function [time, x_com, y_com, z_com, u_com, v_com, w_com, Np] = particle_centre_of_mass()
% PARTICLE_CENTRE_OF_MASS       Finds the centre of mass of a
%    cluster of particles as a function of time
%
%  Inputs:
%    - none
%
%  Outputs:
%    'time'  - the simulation time (vector)
%    'x_com' - x-component of the Centre-Of-Mass (vector)
%    'y_com' - y-component of the Centre-Of-Mass (vector)
%    'z_com' - z-component of the Centre-Of-Mass (vector)
%    'u_com' - x-component of the Centre-Of-Mass velocity (vector)
%    'v_com' - y-component of the Centre-Of-Mass velocity (vector)
%    'w_com' - z-component of the Centre-Of-Mass velocity (vector)
%    'Np'    - number of particles (integer)

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
    u_p(:,nn+1) = p_data.u;
    v_p(:,nn+1) = p_data.v;
    w_p(:,nn+1) = p_data.w;
end

% get time and centre of mass
% assumes all particles are same size and density
time = p_data.time;
x_com = mean(x_p,2);
y_com = mean(y_p,2);
z_com = mean(z_p,2);
u_com = mean(u_p,2);
v_com = mean(v_p,2);
w_com = mean(w_p,2);
