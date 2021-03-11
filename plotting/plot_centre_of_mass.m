function p_h = plot_centre_of_mass(multi_plot)
% plot the position of the centre of mass 
% of all particles over time

% if false, clear figure before adding to it
if nargin == 0
    multi_plot = false;
end

% compute centre of mass
[time,x_com,y_com,z_com,u_com,v_com,w_com] = particle_centre_of_mass();

% figure setup
figure(74)
if ~multi_plot
    clf
end

subplot(2,3,1)
hold on
plot(time,x_com)
ylabel('$x_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,4)
hold on
plot(time,u_com)
xlabel('$t/\tau$')
ylabel('$u_\mathrm{COM}/w_s$','Interpreter','latex')

subplot(2,3,2)
hold on
plot(time,y_com)
ylabel('$y_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,5)
hold on
plot(time,v_com)
xlabel('$t/\tau$')
ylabel('$v_\mathrm{COM}/w_s$','Interpreter','latex')

subplot(2,3,3)
hold on
plot(time,z_com)
ylabel('$z_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,6)
hold on
p_h = plot(time,w_com);
xlabel('$t/\tau$')
ylabel('$w_\mathrm{COM}/w_s$','Interpreter','latex')

figure_defaults()
