function [time, mean_dist_minx] = mean_hor_part_neighbours()
% calculate the mean of the horizontal distance between nearest
% horizontally neighbouring particles

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    x_p(nn+1,:) = xyz_p(:,1);
end

for ii = 1:length(time)
    Xx = x_p(:,ii);
    pair_distsx= squareform(pdist(Xx));  % create a matrix of pair distances
    pair_distsx(pair_distsx==0) = NaN;
    dist_minx(ii,:) = min(pair_distsx);
end

mean_dist_minx = mean(dist_minx,2);

