function [time, part0, p_dist] = neighbour_dist()
% NEIGHBOUR_DIST    find the distance between two particles initially
% side by side for each particle as a function of time
%
%  Inputs:
%    - none
%    
%  Outputs:
%    'time'   - a vector of the simulation time
%    'part0'  - a matrix of the initial particle positions (x y z Rp)
%    'p_dist' - a matrix of distance between neighbouring particles
%               1st column is distance between p0 and p1
%               2nd column is distance between p1 and p2
%               .
%               .
%               .
%               last column is distance between p(Np-1) and p0


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

% load other parameters
time = p_data.time;
par = read_params();
Lx = par.xmax - par.xmin;

% component distances between particles
xdiff = diff(x_p, [], 2);
ydiff = diff(y_p, [], 2);
zdiff = diff(z_p, [], 2);
% add the edge particle components
xedge = Lx + x_p(:,1) - x_p(:,end);
yedge =      y_p(:,1) - y_p(:,end);
zedge =      z_p(:,1) - z_p(:,end);
xdiff = [xdiff xedge];
ydiff = [ydiff yedge];
zdiff = [zdiff zedge];
% find euclidean distance
p_dist = sqrt(xdiff.^2 + ydiff.^2 + zdiff.^2);
