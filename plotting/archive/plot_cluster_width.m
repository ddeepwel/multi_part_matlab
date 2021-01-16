function [] = plot_cluster_width(save_plot, multi_plot)
    % plot the time evolution of the particle cluster size

if nargin == 0
    save_plot = false;
    multi_plot = false;
elseif nargin == 1
    multi_plot = false;
end

[time,~,dist_x] = cluster_size();
Dmat = FiniteDiff(time,1,2,true,false);
dist_x_deriv = Dmat * dist_x;

figure(58)
if ~multi_plot
    clf
end

subplot(2,1,1)
hold on
plot(time,dist_x)
%xlabel('$t/\tau$')
ylabel('$d_{x,avg}/D_p$')

subplot(2,1,2)
hold on
plot(time,dist_x_deriv)
xlabel('$t/\tau$')
ylabel('$\frac{d d_{x,avg}}{dt} / w_s$','interpreter','latex')


figure_defaults();

if save_plot
    check_make_dir('figures')
    cd('figures')
    print_figure('cluster_width','format','pdf','size',[6 4])
    cd('..')
end
