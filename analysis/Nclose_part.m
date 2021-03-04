function [time, Ncounts] = Nclose_part(dist)
% count the number of particles that are close together

if nargin == 0
    dist = 1.5;
end

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    x_p(nn+1,:) = xyz_p(:,1);
    y_p(nn+1,:) = xyz_p(:,2);
    z_p(nn+1,:) = xyz_p(:,3);
end

for ii = 1:length(time)
    X = [x_p(:,ii) y_p(:,ii) z_p(:,ii)];
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    pair_dists(pair_dists==0) = NaN;
    Ncounts(ii) = sum(min(pair_dists) <= dist); 
end