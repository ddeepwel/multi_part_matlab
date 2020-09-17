function parms = sim_parameters(Re, Np, s, Fr, Dp_dx, ep)
% create list of parameters to keep fixed and functions to get the correct varied parameters
% Re: Reynolds number
% Np: Number of particles
% s: spacing between particle edges divided by the particle diameter
% Fr: Froude number
% Dp_dx: points per particle diameter
% ep: epsilon, small parameter for perturbing particle location


if nargin < 4
    error('not enough input arguments')
elseif nargin == 4
    Dp_dx = 15;
    perturb = false;
elseif nargin == 5
    perturb = false;
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
LT = 6;
Ly = Delta + 2*LT; % depth with added upper buffer
Lz = s+1;      % spanwise length

% resolutions
Nx = Lx * Dp_dx;
Ny = Ly * Dp_dx;
Nz = Lz * Dp_dx;

% particle locations
xp = (-Lx/2+(s+1)/2):(s+1):(Lx/2-(s+1)/2);
yp = 0* xp;

if perturb
    % probably need to look into a seed here!
    xpert = normrnd(0,ep,[1,Np]);
    ypert = normrnd(0,ep,[1,Np]);

    %xp = xp + xpert;
    %yp = yp + ypert;

    xp = xp + xpert.*[0 1 0];
    %yp = yp + ypert;

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
for nn = 1:length(xp)
    fprintf('  P%d:    %6.5g %6.5g\n', nn, xp(nn), yp(nn));
end
