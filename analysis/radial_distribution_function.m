%radial_distribution_function
clear all

% number of particles
[~, Np] = particle_initial_positions;

% load parameters
par = read_params();
Lx = par.xmax - par.xmin;

% load particle positions
for nn = 0:Np-1
  p_file = sprintf('mobile_%d',nn);
  p_data = check_read_dat(p_file);
  x_p(nn+1,:)  = p_data.x;  % along-length position
  y_p(nn+1,:)  = p_data.y;  % vertical position
  z_p(nn+1,:)  = p_data.z;  % across-span position (could be neglected)
end

% set time info
time = p_data.time;
Nt = length(time);

% time to begin calculations
% to remove initial transients
t0 = nearest_index(time,0);

% bin information for counting in shells
dr = 0.5;
edges = 1:dr:45;
centres = edges(1:end-1) + (edges(2) - edges(1))/2;
% use dV for 3D, and dA for 2D
%dV = 4*pi/3 * ( edges(2:end).^3 - edges(1:end-1).^3 );
dA = pi/2 * ( edges(2:end).^2 - edges(1:end-1).^2 );

% plume radial distribution (without scaling)
plume1_inds = 1:9;
plume2_inds = 10:18;
plume3_inds = 19:22;
plume_inds = {plume1_inds, plume2_inds, plume3_inds};

% loop over all time steps
for ii = t0:Nt
    % particle position matrix
    X =      [x_p(:,ii)    y_p(:,ii) z_p(:,ii)];
    %X_neg  = [x_p(:,ii)-Lx y_p(:,ii) z_p(:,ii)];
    %X_plus = [x_p(:,ii)+Lx y_p(:,ii) z_p(:,ii)];
    %X = [X_neg; X];%; X_plus];
    
    % global radial distribution (without scaling)
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    dists = triu(pair_dists,1);         % only count distances once
    dists = dists(dists ~= 0);          % remove the zeros
    %dists = dists(:,Np+1:2*Np);         % remove the periodic images
    
    % histogram over all particles
    [N_counts,edges] = histcounts(dists, edges);
    N_list(ii,:) = N_counts; % ./ dA;
    
%     for mm = 1:length(plume_inds)
%         x_local = X(plume_inds{mm},:);              % use particle in local plume
%         pair_dists = squareform(pdist(x_local));    % create a matrix of pair distances
%         dists = triu(pair_dists,1);                 % only count distances once
%         dists(dists==0) = NaN;                      % remove zeros
%         plume_dists{mm} = dists;
%         [Nhist, edges] = histcounts(dists(:), bin_centres+dr/2);      % count in each histogram
%         Nn = length(x_local);
%         Ncounts(mm,:) = Nhist / Nn / (Nn-1) ./ dA;
%         %Ncounts(mm,:) = Nhist;% / Nn / (Nn-1) ./ dA;
%     end
%   Ncounts_mean(ii-t0+1,:) = mean(Ncounts);
end

% moving average over time of the counts for each radius
% this averages over 1000 time steps (which are not all equal!)
% so the window size slightly changes with time
N_smooth = movmean(N_list, 1000, 1);

% plot the number of particles that are r+-dr/2 apart
figure(99)
clf
imagesc(centres, time(t0:end), N_smooth)
xlabel('$r/D_p$')
ylabel('$t/\tau$')
colorbar
figure_defaults()

%figure(100)
%plot(centres, N_list(1,:))



% %plot the average over all plumes of the radial distribution function (RDF)
% %for every non-dimensional time unit
% figure(6)
% clf
% hold on
% for ii = 0:22:22
%     nn = nearest_index(time,ii);
%     plot(centres, N_list(nn,:))
%     title(time(t0+ii-1))
%     xlabel('$r/D_p$')
%     ylabel('$G(r)$')
%     ylim([0 0.014])
%     drawnow
% end
% figure_defaults()
% 
% %plot the space-time plot of the mean RDF over the plumes
% figure(7)
% imagesc(centres, time(t0:end), Ncounts_mean)
% xlabel('$r/D_p$')
% ylabel('$t/\tau$')
% colorbar