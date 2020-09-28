function [] = plot_centre_of_mass(multi_plot)
% plot the centre of mass of all particles over time

if nargin == 0
    multi_plot = false;
end

[time,x_com,y_com,z_com] = particle_centre_of_mass();

Dmat = FiniteDiff(time,1,2,true,false);

u_com = Dmat * x_com;
v_com = Dmat * y_com;
w_com = Dmat * z_com;

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
plot(time,w_com)
xlabel('$t/\tau$')
ylabel('$w_\mathrm{COM}/w_s$','Interpreter','latex')

figure_defaults()
