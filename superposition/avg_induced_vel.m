function avg_induced_vel(t1,t2,particle_ID)
% save the average induced flow for a particle

if nargin == 0
    particle_ID = 0;
end

[t,ui,vi,wi,tf_min] = induced_vel(particle_ID);

if t2 > tf_min
    fprintf('t2 > final time (%0.5g). Choose something less than this\n',tf_min)
    return
end

inds = 1:nearest_index(t,tf_min)-1;
t = t(inds);
ui = ui(inds);
vi = vi(inds);
wi = wi(inds);

t1ind = nearest_index(t,t1);
t2ind = nearest_index(t,t2);

figure(45)
clf

subplot(3,1,1)
hold on
plot(t,ui)
plot([1 1]*t1, [min(ui) max(ui)],'k')
plot([1 1]*t2, [min(ui) max(ui)],'k')
ylabel('$u_{induced}$')

subplot(3,1,2)
hold on
plot(t,vi)
plot([1 1]*t1, [min(vi) max(vi)],'k')
plot([1 1]*t2, [min(vi) max(vi)],'k')
ylabel('$v_{induced}$')

subplot(3,1,3)
hold on
plot(t,wi)
plot([1 1]*t1, [min(wi) max(wi)],'k')
plot([1 1]*t2, [min(wi) max(wi)],'k')
ylabel('$w_{induced}$')
xlabel('$t/\tau$')


figure_defaults()

u_avg_induced = mean(ui(t1ind:t2ind));
v_avg_induced = mean(vi(t1ind:t2ind));
w_avg_induced = mean(wi(t1ind:t2ind));

fprintf('u_avg_induced = %0.5g\n', u_avg_induced);
fprintf('v_avg_induced = %0.5g\n', v_avg_induced);
fprintf('w_avg_induced = %0.5g\n', w_avg_induced);

fname = sprintf('induced_vel_%d',particle_ID);
save(fname,'t1','t2','particle_ID','u_avg_induced','v_avg_induced','w_avg_induced');
