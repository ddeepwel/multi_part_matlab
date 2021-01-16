function [time, part0, dev] = row_particle_offset()
% ROW_PARTICLE_OFFSET    calculate the deviation of each particle
%    from its expected location - that is, where the particle
%    would be if settling in an infinitely periodic row without 
%    perturbation
%
%  Inputs:
%    - none
%    
%  Outputs:
%    'time'  - the simulation time (vector)
%    'part0' - initial particle positions (x y z Rp) (matrix)
%    'dev'   - deviation of particle position (matrix)

% number of particles
[part0, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

% set time info
time = p_data.time;

% find average initial horizontal particle separation
% (distance between particle centres)
sep = mean(diff(x_p(1,:)));

% get particle position from periodic row
N1_dir = sprintf('../N1_s%d_periodic',round(sep));
orig_dir = cd(N1_dir);
p_data = check_read_dat('mobile_0');
%x_per = p_data.x;
y_per = p_data.y;
%z_per = p_data.z;
time_per = p_data.time;
cd(orig_dir)
% interpolate the periodic row data
% onto the perturbed time 
%x_per = interp1(time_per, x_per, time);
y_per = interp1(time_per, y_per, time);
%z_per = interp1(time_per, z_per, time);

% separation of each particle from it's expected location
x_dist = x_p - x_p(1,:); % particle doesn't move horizontally in periodic array
y_dist = y_p - y_per;
z_dist = z_p - z_p(1,:); % particle doesn't move horizontally in periodic array

% calculate deviation distance
dev = sqrt(x_dist.^2 + y_dist.^2 + z_dist.^2);

