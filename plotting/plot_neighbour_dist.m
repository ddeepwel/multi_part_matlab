function [] = plot_neighbour_dist
% plot contours of the distance a particle is from its
% expected location (from the periodic array)

[time, part0, p_dist] = neighbour_dist;
s = part0(2,1) - part0(1,1);
p_dist = p_dist - 1;

figure(133)
clf
contour([part0(1,1)-s; part0(:,1)] + s/2, time, [p_dist(:,end) p_dist], 'showtext', 'on')
xlabel('$x_p(t=0)/D_p$')
ylabel('$t/\tau$')
figure_defaults()
