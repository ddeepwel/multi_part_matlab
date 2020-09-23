function [] = plot_centre_of_mass()
% plot the centre of mass of all particles over time

[time,x_com,y_com,z_com] = particle_centre_of_mass();

Dmat = FiniteDiff(time,1,2);

u_com = Dmat * x_com;
v_com = Dmat * y_com;
w_com = Dmat * z_com;

figure(74)
clf

subplot(2,3,1)
plot(time,x_com)
ylabel('$x_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,4)
plot(time,u_com)
xlabel('$t/\tau$')
ylabel('$u_\mathrm{COM}/w_s$','Interpreter','latex')

subplot(2,3,2)
plot(time,y_com)
ylabel('$y_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,5)
plot(time,v_com)
ylabel('$v_\mathrm{COM}/w_s$','Interpreter','latex')

subplot(2,3,3)
plot(time,z_com)
xlabel('$t/\tau$')
ylabel('$z_\mathrm{COM}/D_p$','Interpreter','latex')

subplot(2,3,6)
plot(time,w_com)
xlabel('$t/\tau$')
ylabel('$w_\mathrm{COM}/w_s$','Interpreter','latex')

figure_defaults()
