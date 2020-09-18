function plot_background_strat(file_prefix)
% plot the space-time plot of the background stratification

if nargin == 0
    file_prefix = 'Data2d';
end

[time, y, strat_ty] = background_strat_ty(file_prefix);

figure(98)
clf
contour(time, y , strat_ty')

colormap(darkjet)
colorbar
xlabel('$t/\tau$')
ylabel('$z/D_p$')

figure_defaults()

