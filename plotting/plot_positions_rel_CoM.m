function [] = plot_positions_rel_CoM(subplots)
% plot the positions of each particle relative to the centre of mass

if nargin == 0
    subplots = false;
end

% number of particles
[part0, Np] = particle_initial_positions;
par = read_params();

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

time = p_data.time;

x_com = mean(x_p,2);
y_com = mean(y_p,2);
z_com = mean(z_p,2);

% positions relative to CoM
x_p_rel = x_p - x_com;
y_p_rel = y_p - y_com;
z_p_rel = z_p - z_com;

% limit plot until CoM is 10 Dp above the bottom
loc = par.ymin + 10;
if min(y_com) < loc
    yind = nearest_index(y_com, loc);
    reach_bot = true;
else
    yind = length(time);
    disp('particles have not reached the desired level yet for case:')
    disp(pwd)
    reach_bot = false;
end
inds = 1:yind;
x_p_rel = x_p_rel(inds,:);
y_p_rel = y_p_rel(inds,:);
z_p_rel = z_p_rel(inds,:);
time = time(inds);

if ~subplots
    figure(56)
    clf
end
hold on

col = lines();
for nn = 1:Np
    plot(x_p_rel(:,nn), y_p_rel(:,nn),'-','Color',col(nn,:))
    plot(x_p_rel(1,nn), y_p_rel(1,nn),'ko','MarkerSize',4)
    if reach_bot
        plot(x_p_rel(end,nn), y_p_rel(end,nn),'kx','MarkerSize',4)
    end
    % add dots every 10 time units
    for tt = 10:10:30
        if time(end) > tt
            tind = nearest_index(time,tt);
            plot(x_p_rel(tind,nn), y_p_rel(tind,nn), 'ko', 'MarkerSize', 2, 'MarkerFaceColor','k');
        end
    end
end
fprintf('t_f = %0.5g\n', time(end))

xlabel('$x/D_p$')
ylabel('$y/D_p$')
%title(sprintf('$N_p=%d,~t_f/\\tau=%.3g$',Np,time(yind)))
title(sprintf('$N_p=%d$',Np))

figure_defaults()
