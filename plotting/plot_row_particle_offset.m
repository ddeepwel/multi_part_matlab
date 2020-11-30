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

[cx,cy] = find_contour(part0(:,1), time, dev, cont);

figure(134)
clf
plot(cx, cy)

% find slope of contour
% this is the rate at which the perturbation spreads 
% to other particles
xr = 4;
xlind = nearest_index(cx, 0);
xrind = nearest_index(cx, xr);

xx = cx(xlind:xrind);
tt = cy(xlind:xrind);

[p,S] = polyfit(xx,tt,1);
fprintf('expansion rate = %.5g\n', p(1))

hold on
plot([0 xr],p(1)*[0 xr]+p(2), 'r')


