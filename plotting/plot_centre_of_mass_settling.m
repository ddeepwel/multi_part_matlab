function p_h = plot_centre_of_mass_settling(multi_plot)
% plot the centre of mass of all particles over time

if nargin == 0
    multi_plot = false;
end

[time,x_com,y_com,z_com] = particle_centre_of_mass();
Dmat = FiniteDiff(time,1,2,true,false);
v_com = Dmat * y_com;

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
