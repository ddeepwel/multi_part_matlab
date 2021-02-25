% plot the time histogram of the nearest neighbour distances
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
  z_p(nn+1,:)  = p_data.z;  % across-span positiown (could be neglected)
end

% set time info
time = p_data.time;
Nt = length(time);


% bin information for counting in shells
dr = 0.5;
edges = 1:dr:22;
centres = edges(1:end-1) + (edges(2) - edges(1))/2;

for ii = 1:length(time)
    X =      [x_p(:,ii)    y_p(:,ii) z_p(:,ii)];
    Xx=      x_p(:,ii);
    
    % does not handle periodic boundary, may get discontinuities if a
    % particle crosses this boundary
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    %dists = triu(pair_dists,1);         % only count distances once
    dists = pair_dists;
    dists(dists==0) = NaN;
    dist_min(ii,:) = min(dists);
    [N_counts, edges] = histcounts(dist_min(ii,:), edges);
    N_list(ii,:) = N_counts; % ./ dA;
    
    pair_distsx= squareform(pdist(Xx));  % create a matrix of pair distances
    distsx = pair_distsx;
    distsx(distsx==0) = NaN;
    dist_minx(ii,:) = min(distsx);

    % gaussian fit of histogram
%     if ii == 1
%         % function and initial parameters
%         fit_gauss = @(par, x) par(1) * exp(-(x-1).^2 / par(2)^2);
%         par0 = [0.75*Np 1];
%     else
%         par0 = par;
%     end
%     warning('off','all')
%     [par, resnorm, ~, exitflag, output] = lsqcurvefit(fit_gauss, par0, centres, N_list(ii,:));
%     warning('on','all')
%     gauss_width(ii) = par(2);
end

%%%% Make Plots

mean_dist_minx = mean(dist_minx,2);
figure(72)
clf
plot(time, mean_dist_minx)
xlabel('$t/\tau$')
ylabel('Mean of Minimum $d_x$ per particle')
title('mean horizontal min separation')
figure_defaults()


% plot the mean minimum particle distance of the closest 50 %
%short_dist = 2;
%dist_min_short = dist_min;
%dist_min_short(dist_min_short > short_dist) = NaN;
%mean_dist_min = mean(dist_min_short, 2, 'omitnan');
%% sum the number of particles closer than this dist
%count_short_dist = sum(~isnan(dist_min_short),2);
sort_dist = sort(dist_min,2);
mean_dist_min = mean(sort_dist(:,1:round(Np/2)),2);
figure(73)
clf
plot(time, mean_dist_min)
xlabel('$t/\tau$')
%ylabel('mean minimum distance ($d<2.5 D_p$)')
ylabel('mean minimum distance (closest 50\%)')
figure_defaults

% plot the median minimum particle distance
median_dist_min = median(dist_min,2);
figure(74)
clf
plot(time, median_dist_min)
xlabel('$t/\tau$')
ylabel('median minimum distance')
figure_defaults

% figure(75)
% clf
% plot(time, gauss_width)
% xlabel('$t/\tau$')
% ylabel('fit width')
% figure_defaults


figure(76)
clf
hold on
plot(centres, N_list(1,:))
plot(centres, N_list(end,:))
legend('$t=0$','$t=t_f$')
xlabel('$d/D_p$')
ylabel('counts')
figure_defaults



figure(77)
clf
imagesc(centres, time, N_list)
xlabel('$d/D_p$')
ylabel('$t/\tau$')
cb = colorbar;
cb.Label.String = 'Counts';
figure_defaults()
