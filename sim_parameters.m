function parms = sim_parameters(Re, Np, s, Fr, Dp_dx, ep, pert_type)
% create list of parameters to keep fixed and functions to get the correct varied parameters
% Re: Reynolds number
% Np: Number of particles
% s: spacing between particle edges divided by the particle diameter
% Fr: Froude number
% Dp_dx: points per particle diameter
% ep: epsilon, small parameter for perturbing particle location
% pert_type: the type of perturbation to use
%       - random: particles are randomly place anywhere along the z=0 line
%                   without overlapping and with vertical perturbation of ep
%       - xpert:  particles are perturbed horizontaly by amount on the order ep
%       - ypert:  particles are perturbed vertically  by amount on the order ep
%       - xypert: particles are perturbed horizontally and vertically  by amount on the order ep
%       - regular: particles are regularly spaced


if nargin < 4
    error('not enough input arguments')
elseif nargin == 4
    Dp_dx = 16;
    perturb = true;
    ep = 0.3;
    pert_type = 'xypert';
elseif nargin == 5
    perturb = true;
    ep = 0.3;
    pert_type = 'xypert';
elseif nargin == 6
    perturb = true;
    pert_type = 'xypert';
else
    perturb = true;
end

% fixed parameters
rho_0 = 1.0;   % g/mL
nu    = 1e-6;  % m^2/s
g     = 9.81;  % m/s^2
Dp    = 80e-6; % m
Sc    = 7;   % m^2/s

% density of particle
rho_p = rho_0 * (1 + 18 * nu^2 * Re / g / Dp^3);

% non-dim gravity
gtilde = 18 * rho_0 / (rho_p - rho_0) / Re;

% Richardson number
Ri = Fr^(-2);

% Peclet number
Pe = Re * Sc;

% domain dimensions
Lx = Np * (s+1); % width
Delta = 18 * Fr^2 / Re;  % distance to depth of equivalent fluid density
LT = round(0.2*Delta);
Ly = Delta + 2*LT; % depth with added upper buffer
Lz = s+1;      % spanwise length

% resolutions
Nx = Lx * Dp_dx;
Ny = Ly * Dp_dx;
Nz = Lz * Dp_dx;

if perturb
    rng('shuffle') % use the time to seed the random number generator
    switch pert_type
        case 'random'
            for nn = 1:Np
                xp_new = Lx*rand() - Lx/2;
                if nn ~= 1
                    while min(abs(xp - xp_new)) <= 1 || min(abs(Lx+xp - xp_new)) <= 1
                        xp_new = Lx*rand() - Lx/2;
                    end
                end
                xp(nn) = xp_new;
            end
            yp = normrnd(0,ep,[1,Np]);

        case 'xpert'
            xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
            xp = xp + normrnd(0,ep,[1,Np]);
            yp = 0 * xp;

        case 'ypert'
            xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
            yp = normrnd(0,ep,[1,Np]);

        case 'xypert'
            xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
            xp = xp + normrnd(0,ep,[1,Np]);
            yp = normrnd(0,ep,[1,Np]);

        case 'regular'
            xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
            yp = 0 * xp;

    end
else
    xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
    yp = 0 * xp;
end

parms.rho_0 = rho_0;
parms.nu    = nu;
parms.g     = g;
parms.Dp    = Dp;
parms.rho_p = rho_p;
parms.gtilde= gtilde;
parms.Ri    = Ri;
parms.Pe    = Pe;
parms.xp    = xp;
parms.yp    = yp;

fprintf('xmin    = %0.4g\n', -Lx/2);
fprintf('xmax    = %0.4g\n',  Lx/2);
fprintf('ymin    = %0.4g\n', -(Delta+LT));
fprintf('ymax    = %0.4g\n',  LT);
fprintf('zmin    = %0.4g\n', -Lz/2);
fprintf('zmax    = %0.4g\n',  Lz/2);
fprintf('Nx      = %0.4g\n',  Nx);
fprintf('Ny      = %0.4g\n',  Ny);
fprintf('Nz      = %0.4g\n',  Nz);
fprintf('Re      = %0.4g\n',  Re);
fprintf('rho_s   = %0.4g\n', rho_p/rho_0);
fprintf('grav    = %0.4g\n', gtilde);
fprintf('Pe      = %0.4g\n', Pe);
fprintf('Ri      = %0.5g\n', Ri);
fprintf('particle positions:\n');
for nn = 1:Np
    fprintf('%4.5g %4.5g %4.5g %4.5g\n', xp(nn), yp(nn), 0, 0.5);
end
fprintf('ep      = %0.5g\n', ep);
fprintf('pert_type= %s\n', pert_type);

figure(301)
clf
viscircles([xp; yp]', ones(Np,1)*0.5);
axis image
xlim([-1 1]*Lx/2)
figure_defaults()
