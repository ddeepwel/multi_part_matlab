function [time, x_com, y_com, z_com, Np] = particle_centre_of_mass()
% find the centre of mass of the particles as a function of time

% number of particles
[part0, Np] = particle_initial_positions;

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

time = p_data.time;

x_com = mean(x_p,2);
y_com = mean(y_p,2);
z_com = mean(z_p,2);
