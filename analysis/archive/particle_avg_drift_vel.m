function avg_drift_vel = particle_avg_drift_vel(t1,t2,com,particle_ID)
% find the average drift velocity from a linear fit of the
% particle position

if nargin == 0
    t1 = 0;
    t2 = 1000;
    com = false;
    particle_ID = 0;
elseif nargin == 2
    com = false;
    particle_ID = 0;
end

% read data
if com
    p1_file = sprintf('mobile_0');
    p1_data = check_read_dat(p1_file);
    p2_file = sprintf('mobile_1');
    p2_data = check_read_dat(p2_file);
    % get particle position and time
    time = p1_data.time;
    x = (p1_data.x + p2_data.x)/2;
    y = (p1_data.y + p2_data.y)/2;
    x = x - x(1);
    y = y - y(1);
else
    p_file = sprintf('mobile_%d', particle_ID);
    p_data = check_read_dat(p_file);
    % get particle position and time
    time = p_data.time;
    x = p_data.x;
    y = p_data.y;
    x = x - x(1);
    y = y - y(1);
end

% choose time to use
t1ind = nearest_index(time, t1);
t2ind = nearest_index(time, t2);
t1 = time(t1ind);
t2 = time(t2ind);
inds = t1ind:t2ind;

% setup curve fit
func = @(c,x) c(1) + c(2) * x;
c0 = [0 y(end)/x(end)];
[coeff, resnorm, residual, exitflag, output] = lsqcurvefit(func,c0,x(inds),y(inds));


avg_drift_vel = 1/coeff(2) * (y(t2ind) - y(t1ind)) / (t2 - t1);





figure(81)
clf

subplot(2,1,1)
hold on
plot(x,y)
plot(x(inds),func(coeff,x(inds)))
legend('path','fit')
ylabel('$y/D_p$')
xrange = xlim();

subplot(2,1,2)
hold on
plot(x(inds),residual)
ylabel('residual')
xlabel('$x/D_p$')
xlim(xrange)

figure_defaults()

figure(62)
clf
if ~com
    plot_particle_settling(particle_ID);
end
plot_particle_separation;
plot_particle_positions;

if com
    fname = sprintf('avg_drift_vel_com');
else
    fname = sprintf('avg_drift_vel_%d',particle_ID);
end
save(fname,'avg_drift_vel','t1','t2')
