function [] = plot_lowest_particle()
% plot the depth and velocity of the lowest particle

params = read_params();

try
    load('lowest_particle.mat')
    p0 = check_read_dat('mobile_0');
    if p0.time(end) > time(end)
        disp('Simulation has been restarted, re-running lowest particle calculation')
        [time, y_p, v_p] = lowest_particle();
    end
catch
    [time, y_p, v_p] = lowest_particle();
end

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
