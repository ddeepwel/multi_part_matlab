function avg_drift_vel = particle_avg_drift_vel(t1,t2,particle_ID)
% find the average drift velocity from a linear fit of the
% particle position

if nargin == 0
    t1 = 0;
    t2 = 1000;
    particle_ID = 0;
elseif nargin == 2
    particle_ID = 0;
end

% read data
p_file = sprintf('mobile_%d', particle_ID);
p_data = check_read_dat(p_file);
% get particle position and time
time = p_data.time;
x = p_data.x;
y = p_data.y;
x = x - x(1);
y = y - y(1);

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
plot(x,func(coeff,x))
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
plot_particle_settling(particle_ID);
plot_particle_separation;
plot_particle_positions;

fname = sprintf('avg_drift_vel_%d',particle_ID);
save(fname,'avg_drift_vel','t1','t2')
