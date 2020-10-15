function [time,u_induce,v_induce,w_induce, tf_min] = induced_vel(particle_ID)
% compute the induced velocity of a neighbouring particle relative to the settling
% of an independent particle

if nargin == 0
    particle_ID = 0;
end

% read particle data
file_name = sprintf('mobile_%d',particle_ID);
particle_data = check_read_dat(file_name);

% get data
time = particle_data.time;
x_p  = particle_data.x;
y_p  = particle_data.y;
z_p  = particle_data.z;

time = time + 9;

% calculate velocity
Dmat = FiniteDiff(time, 1, 2, true, false); % some cases have variable time step 
u_p = Dmat * x_p;
v_p = Dmat * y_p;
w_p = Dmat * z_p;




%%%%%% get velocity of a single settling particle %%%%%

% read particle data
orig_dir = cd('../1prt');
file_name = sprintf('mobile_%d',0);
particle_data = check_read_dat(file_name);
cd(orig_dir);

% get data
time1 = particle_data.time;
x_p1  = particle_data.x;
y_p1  = particle_data.y;
z_p1  = particle_data.z;

% calculate velocity
Dmat = FiniteDiff(time1, 1, 2, true, false); % some cases have variable time step 
u_p1 = Dmat * x_p1;
v_p1 = Dmat * y_p1;
w_p1 = Dmat * z_p1;

% interpolate the velocity onto the time for the particle pair
u_p1_interp = interp1(time1, u_p1, time, 'pchip');
v_p1_interp = interp1(time1, v_p1, time, 'pchip');
w_p1_interp = interp1(time1, w_p1, time, 'pchip');


u_induce = u_p - u_p1_interp;
v_induce = v_p - v_p1_interp;
w_induce = w_p - w_p1_interp;

tf_min = min([time(end) time1(end)]);
