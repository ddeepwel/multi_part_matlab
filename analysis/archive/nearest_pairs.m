function nearest_pairs(Np, sep)
%==========================================================================
% nearest_triple(N,s)
%
% uncompleted work. No point in looking for triple
% distance between doubles works, but is a generalization of the neighbour_dist function
% which only looks at two initially neighbouring particles
%
%-------------
% Find the particle triple that is most compact
%-------------
% INPUTS:
%  Np  - number of particles in simulation (eg Np=11)
%  sep - mean initial separation between particles, in number of Dp (eg sep=1)
%        from points of closest contact rather than particle centres
%==========================================================================

Rdist = 3;

% by default assume particle diameter is 1 "unit"
Dp=1;
Rp=Dp/2;


%==============================================================================
% Get data

par = read_params();
Lx = par.xmax - par.xmin;

for nn = 1:Np
  p_file = sprintf('data/mobile_%d',nn-1);
  p_data = check_read_dat(p_file);
  xp(nn,:)  = p_data.x;  % along-length position
  yp(nn,:)  = p_data.y;  % vertical position
  zp(nn,:)  = p_data.z;  % across-span position (could be neglected)
end

time = p_data.time;
Nt = length(time);

%==============================================================================
% Find nearest-neighbour distances for each particle at each time

for ii = 1:Nt
    % setup a matrix of particle positions, accounting for periodicity
    Xp = [xp(:,ii) yp(:,ii) zp(:,ii)];
    X_neg  = [xp(:,ii)-Lx yp(:,ii) zp(:,ii)];
    X_plus = [xp(:,ii)+Lx yp(:,ii) zp(:,ii)];
    Xp = [X_neg; Xp; X_plus];
    
    % create a matrix of pair distances
    pair_dists = squareform(pdist(Xp));
    pair_dists(pair_dists==0) = NaN;        % remove zeros
    pair_dists = pair_dists(:,Np+1:2*Np);   % remove periodic particles
    % measures distance of the nearest 2 particles
    sort_pd = sort(pair_dists);
    triple_size(:,ii) = sum(sort_pd(1:2,:));
    % find the distance between the particle and it's neighbour on the
    % right (only useful at the beginning when particles remain ordered)
    double_size(:,ii) = diag(pair_dists,-Np-1); 
    
    %dmin(:,ii) = sum(pair_dists(:,Np+1:2*Np) <= Rdist);
end
