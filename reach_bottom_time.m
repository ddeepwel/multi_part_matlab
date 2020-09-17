function [t_bottom, t_bottom_ind] = reach_bottom_time(H)
% time when a particle first nears the bottom

particle_files = dir('mobile_*.dat');
N_files = length(particle_files);

% height above bottom
% when particle 'feels' the bottom
if nargin == 0
    H = 4;
end

ts = zeros(1,N_files);
for mm = 1:N_files
    fname = sprintf('mobile_%d', mm-1);
    p = check_read_dat(fname);
    height = min(p.y);
    if height <= H
        t_ind = nearest_index(p.y,H);
        ts(mm) = p.time(t_ind);
    end
end

t_bottom = min(ts(ts>0));
t_bottom_ind = nearest_index(p.time, t_bottom);

