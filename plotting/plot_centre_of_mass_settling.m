function p_h = plot_centre_of_mass_settling(multi_plot)
% plot the vertical position and settling speed
% of the centre of mass of all particles

% if false, clear figure before adding to it
if nargin == 0
    multi_plot = false;
end

% compute the centre of mass and its settling speed
[time, x_com, y_com, z_com, u_com, v_com, w_com] = particle_centre_of_mass();

% make figure
figure(75)
if ~multi_plot
    clf
end

subplot(2,1,1)
hold on
plot(time,y_com)
ylabel('$y_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,1,2)
hold on
plot(time,v_com)
xlabel('$t/\tau$')
ylabel('$v_\mathrm{COM}/w_s$','Interpreter','latex')

figure_defaults()
