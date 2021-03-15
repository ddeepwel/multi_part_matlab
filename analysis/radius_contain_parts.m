%function [] = 
%
% for each particle find the minimum radius that contains 2,3,4...
% particles

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

tc = 0.5;
% Find the distances between all particles for each time step
for ii = 1:Nt
    % setup a matrix of particle positions
    X =      [x_p(:,ii)    y_p(:,ii) z_p(:,ii)];
    X_neg  = [x_p(:,ii)-Lx y_p(:,ii) z_p(:,ii)];
    X_plus = [x_p(:,ii)+Lx y_p(:,ii) z_p(:,ii)];
    %X =      x_p(:,ii);   % y_p(:,ii) z_p(:,ii)]; % just x component
    %X_neg  = x_p(:,ii)-Lx;% y_p(:,ii) z_p(:,ii)]; % just x component
    %X_plus = x_p(:,ii)+Lx;% y_p(:,ii) z_p(:,ii)]; % just x component
    X = [X_neg; X; X_plus];
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    pair_dists(pair_dists==0) = NaN;    % remove zeros
    sorted_dists = sort(pair_dists);    % sort list
    particle_radii(:,:,ii) = sorted_dists(1:Np-1, Np+1:2*Np); % ignore the extended periodic particles

    
    if time(ii)>tc && time(ii)<22 % time when particles near the bottom
        figure(33)
        % plot the radius of the smallest sphere
        imagesc(squeeze(particle_radii(:,:,ii)))
        % plot the particles per radius
        %Np_vec = 2:Np;
        %imagesc(Np_vec' ./ squeeze(particle_radii(:,:,ii)))
        
        % make pretty
        cb = colorbar;
        title(time(ii))
        xlabel('particle ID')
        ylabel('number of particles in cluster (less 1)')
        cb.Label.String = '$r/D_p$';
        caxis([0 16])
        figure_defaults()
        drawnow
        tc=tc+0.5;
    end
end

if reached_bottom(10)
    [t_bot, t_bot_ind] = reach_bottom_time(10);
end


% find the mean radius for each cluster size over time
mean_radii = squeeze(mean(particle_radii,2));
min_radii  = squeeze(min(particle_radii,[],2));

figure(34)
clf
plot(time, mean_radii)
xlabel('$t/\tau$')
ylabel('$r_{mean}/D_p$')
figure_defaults()

t_start_ind = nearest_index(time,0);


figure(35)
clf
plot(time, mean_radii-mean_radii(:,t_start_ind))
xlabel('$t/\tau$')
ylabel('$(r-r_0)/D_p$')
figure_defaults()


% plot the minimum radius for each cluster size over time
figure(36)
clf
plot(time, min_radii)
xlabel('$t/\tau$')
ylabel('$r_{min}/D_p$')
figure_defaults()