function [time, yy, local_frac] = plot_vol_frac_hor(tc)
% plot the horizontal average of the volume fraction

if nargin == 0
    tc = 'video';
end

load('volume_frac_hor.mat')

if tc == 'video'
    ts = 0:0.5:time(end);
    inds = nearest_index(time, ts);
else
    inds = nearest_index(time, tc);
end

vol_frac_max = max(local_frac(:));

figure(33)
clf

for ii = inds
    plot(local_frac(:,ii), yy)

    xlabel('$\phi$')
    ylabel('$y/D_p$')
    ttl = sprintf('Horizontal volume fraction, $t/\\tau=%3.1f$', time(ii));
    title(ttl)
    xlim([0 vol_frac_max])

    figure_defaults()
    drawnow
end
