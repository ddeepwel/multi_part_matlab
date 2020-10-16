function parms = sim_parameters(Re, Fr, s, theta, Dp_dx)
% create list of parameters to keep fixed and functions to get the correct varied parameters
% for 2 particles in linear stratification
% Re: Reynolds number
% theta: orientation angle of the particles
% s: spacing between particle edges divided by the particle diameter
% Fr: Froude number
% Dp_dx: points per particle diameter


if nargin < 4
    error('not enough input arguments')
elseif nargin == 4
    Dp_dx = 16;
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
W = 10;
%Lx = (s+1)*sind(theta) + 2*W; % width
Lx = (s+1) + 2*W; % width
Delta = 30;     % distance for particle to fall
LT = 10;        % buffer depth
Ly = Delta + 2*LT; % depth with added upper buffer
Lz = 2*W;       % spanwise length
%Lz = s+1;

% resolutions
Nx = Lx * Dp_dx;
Ny = Ly * Dp_dx;
Nz = Lz * Dp_dx;
%Nx = ceil(Nx);
%Lx = Nx / Dp_dx;

% particle positions
xp1 = 0;
yp1 = 0
xp2 = (s+1) * sind(theta);
yp2 = -(s+1) * cosd(theta);

parms.rho_0 = rho_0;
parms.nu    = nu;
parms.g     = g;
parms.Dp    = Dp;
parms.rho_p = rho_p;
parms.gtilde= gtilde;
parms.Ri    = Ri;
parms.Pe    = Pe;

fprintf('xmin    = %0.4g\n', -W);
fprintf('xmax    = %0.6g\n',  Lx-W);
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
fprintf('%4.5g %4.5g %4.5g %4.5g\n', xp1, yp1, 0, 0.5);
fprintf('%4.5g %4.5g %4.5g %4.5g\n', xp2, yp2, 0, 0.5);

figure(301)
clf
viscircles([xp1 xp2; yp1 yp2]', ones(2,1)*0.5);
axis image
xlim([-1 1]*Lx/2)
figure_defaults()
