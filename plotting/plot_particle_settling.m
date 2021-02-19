function [] = plot_particle_settling(particle_ID)
% plot the settling of a single particle

if nargin == 0
    particle_ID = 0;
end

params = read_params();

[time, xyz_p, uvw_p] = particle_position(particle_ID);

y_p = xyz_p(:,2);
v_p = uvw_p(:,2);

% make figure
figure(62)
%clf
subplot(2,1,1)
hold on
plot(time, y_p,'-')
fprintf('Initial particle position: %g D_p\n',y_p(1))
ylabel('$h_p/D_p$')
title('particle height')
grid on

subplot(2,1,2)
hold on
plot(time, v_p,'-')
ylabel('$w_p/w_s$')
xlabel('$t/\tau$')
title('particle velocity')
grid on

figure_defaults()
