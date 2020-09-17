function [time, y_p, vel] = particle_settling(particle_ID)
% get the settling velocity and depth of a particle

if nargin == 0
    particle_ID = 0;
end

% Read data
try
    file_name = sprintf('mobile_%d',particle_ID);
    particle_data = check_read_dat(file_name);
catch
    file_name = sprintf('mobile');
    particle_data = check_read_dat(file_name);
end

% get data
time = particle_data.time;
y_p  = particle_data.y;

% calculate velocity
Dmat = FiniteDiff(time, 1, 2, true, false); % some cases have variable time step 
vel = Dmat * y_p;

