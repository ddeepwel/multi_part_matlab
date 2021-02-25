function [time, avg_speed] = avg_settling_speed
% calculate the average settling speed of all particles in the simulation

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
  p_file = sprintf('mobile_%d',nn);
  p_data = check_read_dat(p_file);
  v_p(nn+1,:)  = p_data.v;
end

% set time info
time = p_data.time;

avg_speed = mean(v_p);