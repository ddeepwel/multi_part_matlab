function [time, part0, p_dist] = nearest_neighbour_dist()
% for each particle find the distance to the nearest
% neighbour

% number of particles
[part0, Np] = particle_initial_positions;

% get particle positions
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

time = p_data.time;
par = read_params();
s0 = x_p(1,2) - x_p(1,1);
Lx = par.xmax - par.xmin;

% distance between particles
xdiff = diff(x_p, [], 2);
ydiff = diff(y_p, [], 2);
zdiff = diff(z_p, [], 2);
% add the edge particle distance
xedge = Lx + x_p(:,1) - x_p(:,end);
yedge =      y_p(:,1) - y_p(:,end);
zedge =      z_p(:,1) - z_p(:,end);
xdiff = [xdiff xedge];
ydiff = [ydiff yedge];
zdiff = [zdiff zedge];

p_dist = sqrt(xdiff.^2 + ydiff.^2 + zdiff.^2);

% find max of nearest neighbours
%for nn = 1:Np-1
%    max_dist(:, nn+1) = max(p_dist(:,nn:nn+1), [], 2);
%end
%max_dist(:, 1) = max([p_dist(:,1) p_dist(:,end)], [], 2);

% remove particle diameter
% so that distance is from points of closest contact
%max_dist = max_dist - 1;

