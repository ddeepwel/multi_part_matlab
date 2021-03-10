function [] = plot_lowest_particle()
% plot the depth and velocity of the lowest particle

params = read_params();

[time, y_p, v_p] = lowest_particle();

% make figure
figure(98)
%clf
subplot(2,1,1)
hold on
plot(time, y_p,'-')
ylabel('$h_p/D_p$')
title('lowest particle height')
grid on

subplot(2,1,2)
hold on
plot(time, -v_p,'-')
ylabel('$w_p/w_s$')
xlabel('$t/\tau$')
title('lowest particle velocity')
grid on

figure_defaults()
