function [] = plot_entrain_mass(save_plot, multi_plot)
% plot the mass entrainment
% the integral of (rho_background - rho) * phi_f

if nargin == 0
    save_plot = true;
    multi_plot = false;
end

par = read_params();
Ri = par.richardson;
Re = par.Re;
rho_s = par.rho_s;
Ly = par.ymax - par.ymin;

load('entrained_tracer')
mass = volume * 6/pi/Ly;

% make figure
figure(77)
if ~multi_plot
    clf
end
hold on

plot(time, mass);

ylabel('entrained fluid (unitless)','Interpreter','latex')
xlabel('$t/\tau$')
%xlim([0 50])

figure_defaults();

if save_plot
    check_make_dir('figures')
    cd('figures')
    %print_figure('entrain_mass','format','pdf','size',[6 4])
    cd('..')
end
