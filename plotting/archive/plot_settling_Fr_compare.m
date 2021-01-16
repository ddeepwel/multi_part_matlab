% compare the settling velocity of a single particle for different Froude number

base = '/scratch/ddeepwel/multi_part/2part/';
dirs = {'Fr0.25','Fr0.75','Fr1','Fr2'};
% 'Frinf' has multiple different Reynolds number (Re=1/16 and 1/32)

Ndir = length(dirs);

figure(34)
clf
hold on

figure(35)
clf
hold on

Re = 1/4;
nu = 1e-6;
Dp = 80e-6;
ws = Re * nu / Dp;
g = 9.81;

for mm = 1:Ndir
    cd([base,dirs{mm},'/1prt'])

    par = read_params();
    rho_s = par.rho_s;
    Ri = par.richardson;
    Fr = 1/sqrt(Ri);
    N = ws / Fr / Dp;
    gam_rho0 = N^2/g;

    [time, y_p, vel] = particle_settling(0);

    rp = -y_p;
    rho_f = 1 + gam_rho0 * Dp * rp;
    vel_prime = vel * (rho_s - 1) ./ (rho_s - rho_f);

    figure(34)
    plot(time,vel)

    figure(35)
    plot(time,vel_prime)
end

xlabel('$t/\tau$')
ylabel('$w/w_s''$')
legend('$\mathrm{Fr} = 0.25$','$\mathrm{Fr} = 0.75$','$\mathrm{Fr} = 1$','$\mathrm{Fr} = 2$')
figure_defaults()

figure(34)
xlabel('$t/\tau$')
ylabel('$w/w_s$')
legend('$\mathrm{Fr} = 0.25$','$\mathrm{Fr} = 0.75$','$\mathrm{Fr} = 1$','$\mathrm{Fr} = 2$')
figure_defaults()
