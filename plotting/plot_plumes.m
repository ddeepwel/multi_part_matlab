function [] = plot_plumes()
% PLOT_PLUMES  plot the positions and settling speeds of the particle
%  plumes as they change over time
%
% Inputs:
%   - none
%
% Outputs:
%   - none


% calculate plume locations
[time, p_locs, p_depths] = plume_locations();
[Npks, ~] = size(p_locs);

% make figure 
figure(45)
clf
hold on

for nn = 1:Npks
    plot(p_locs(nn,:), time)
end

xlabel('$x/D_p$')
ylabel('$t/\tau$')

figure_defaults()

check_make_dir('figures')
cd('figures')
print_figure('plume_locations','format','pdf')
cd('..')


%% plume speeds

Dmat = FiniteDiff(time, 1, 2, true, false);
p_speeds = Dmat * p_depths';

% make figure 
figure(46)
clf
hold on

plot(time, p_speeds)

xlabel('$t/\tau$')
ylabel('$w_{plume}/w_s$')

figure_defaults()

check_make_dir('figures')
cd('figures')
print_figure('plume_speed','format','pdf')
cd('..')


