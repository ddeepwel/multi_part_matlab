% make a plot of the induced velocity for the case when the particles are combined


[t,ui,vi,wi,tf] = induced_vel();

figure(66)

subplot(2,1,1)
hold on
plot(t,ui)
ylabel('$u_{induced}$')

subplot(2,1,2)
hold on
plot(t,vi)
ylabel('$v_{induced}$')
xlabel('$t/\tau$')

figure_defaults();
