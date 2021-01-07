function [] = plot_row_particle_offset(cont)
% plot contours of the distance a particle is from its
% expected location (from the periodic array)

if nargin == 0
    cont = 0.5;
end

[time, part0, dev] = row_particle_offset;

figure(133)
clf
contour(part0(:,1), time, dev, 'showtext','on')
xlabel('$x_p(t=0)$')
ylabel('$t/\tau$')
figure_defaults()

check_make_dir('figures')
cd('figures')
print_figure('pert_growth','format','pdf')

%%%%% 2nd plot of just the selected contour

[cx,cy] = find_contour(part0(:,1), time, dev, cont);

figure(134)
clf
plot(cx, cy)

% find slope of contour
% this is the rate at which the perturbation spreads 
% to other particles
xr = 2;
xlind = nearest_index(cx, 0);
xrind = nearest_index(cx, xr);

xx = cx(xlind:xrind);
tt = cy(xlind:xrind);

[p,S] = polyfit(xx,tt,1);
exp_rate_str = sprintf('expansion rate (non-dim dist/time) = %.5g \n', 1/p(1)); % invert p(1) to get a distance over time
fprintf(exp_rate_str);

hold on
plot([0 xr],p(1)*[0 xr]+p(2), 'r')

xlabel('$x_p(t=0)$')
ylabel('$t/\tau$')
title(['Contour: ', num2str(cont)])
text(gca,0.3,0.1,exp_rate_str,...
    'Color','k','Units','normalized','Interpreter','Latex')
figure_defaults()

print_figure(['pert_contour_',strrep(num2str(cont),'.',''),'_growth'],'format','pdf')
cd('..')
