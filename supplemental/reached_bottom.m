function reach_bottom = reached_bottom(H)
% check if particles have reached the bottom
% in the simulation

particle_files = dir('mobile_*.dat');
N_files = length(particle_files);

par = read_params();
ymin = par.ymin;

% height above bottom
% when particle 'feels' the bottom
if nargin == 0
    H = 4;
end

height = zeros(1,N_files);
for mm = 1:N_files
    fname = sprintf('mobile_%d', mm-1);
    p = check_read_dat(fname);
    height(mm) = min(p.y);
end

if min(height) < H + ymin
    reach_bottom = true;
else
    reach_bottom = false;
end

