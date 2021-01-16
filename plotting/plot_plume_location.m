function [] = plot_plume_location()
% PLOT_PLUME_LOCATION  plot the positions of the particle
%  plumes as they change over time
%
% Inputs:
%   - none
%
% Outputs:
%   - none


% calculate plume locations
[time, p_locs] = plume_location();
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
