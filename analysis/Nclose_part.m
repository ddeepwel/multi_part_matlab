function [time, Ncounts] = Nclose_part(dist)
% count the number of particles that are close together
% dist is distance between particle centres

if nargin == 0
    dist = 1.5;
end

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    if nn == 0
        inds = 1:length(time);
    end
    x_p(nn+1,:) = xyz_p(inds,1);
    y_p(nn+1,:) = xyz_p(inds,2);
    z_p(nn+1,:) = xyz_p(inds,3);
end
time = time(inds);

for ii = inds
    X = [x_p(:,ii) y_p(:,ii) z_p(:,ii)];
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    pair_dists(pair_dists==0) = NaN;
    Ncounts(ii) = sum(min(pair_dists) <= dist); 
end
