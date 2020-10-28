function [] = plot_positions_rel_CoM(subplots)
% plot the positions of each particle relative to the centre of mass

if nargin == 0
    subplots = false;
end

% number of particles
[part0, Np] = particle_initial_positions;

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
    y_p(:,nn+1) = p_data.y;
    z_p(:,nn+1) = p_data.z;
end

time = p_data.time;

x_com = mean(x_p,2);
y_com = mean(y_p,2);
z_com = mean(z_p,2);

% positions relative to CoM
x_p_rel = x_p - x_com;
y_p_rel = y_p - y_com;
z_p_rel = z_p - z_com;

if ~subplots
    figure(55)
    clf
end
hold on

for nn = 1:Np
    plot(x_p_rel(:,nn), y_p_rel(:,nn))
    plot(x_p_rel(1,nn), y_p_rel(1,nn),'ko')
    plot(x_p_rel(end,nn), y_p_rel(end,nn),'kx')
end

xlabel('$x/D_p$')
ylabel('$y/D_p$')

figure_defaults()