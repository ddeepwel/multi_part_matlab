function parms = sim_parameters_vplane(Re, Fr, s, Npx, Npy, Dp_dx, ep)
% create list of parameters to keep fixed and functions to get the correct varied parameters
% for a vertical array of particles in linear stratification
% Re: Reynolds number
% Fr: Froude number
% s: spacing between particle edges divided by the particle diameter
% Npx: number of particles in horizontal
% Npy: number of particles in vertical
% Dp_dx: points per particle diameter
% ep: epsilon, small parameter for perturbing particle location


if nargin < 5
    error('not enough input arguments')
elseif nargin == 5
    Dp_dx = 16;
    ep = 0.3;
elseif nargin == 6
    ep = 0.3;
end

% fixed parameters
rho_0 = 1.0;   % g/mL
nu    = 1e-6;  % m^2/s
g     = 9.81;  % m/s^2
Dp    = 80e-6; % m
Sc    = 7;   % m^2/s
Np = Npx * Npy;

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
%Lx = (Npx-1)*(s+1) + 2*W; % width
Lx  = Npx * (s+1); % width
Lpy = Npy * (s+1); % particle depth
Delta = 30;     % distance for particle to fall
H_eq = 18 * Fr^2 / Re;  % distance to depth of equivalent fluid density
LT = 10;        % buffer depth
Ly = Delta + Lpy + 2*LT; % depth with added upper buffer
Lz = 2*W;       % spanwise length
%Lz = s+1;

% resolutions
Nx = Lx * Dp_dx;
Ny = Ly * Dp_dx;
Nz = Lz * Dp_dx;
%Nx = ceil(Nx);
%Lx = Nx / Dp_dx;

% particle positions
rng('shuffle') % use the time to seed the random number generator
Lpart = (s+1) * (Npx-1);
Hpart = (s+1) * (Npy-1);
xp = (-Lpart/2):(s+1):(Lpart/2);
yp = (-Hpart/2):(s+1):(Hpart/2);
xp = xp + normrnd(0,ep,[Npy,Npx]);
yp = yp' + normrnd(0,ep,[Npy,Npx]);
xp = xp(:);
yp = yp(:);

% check if any particles intersect
xp2 = [xp; xp(1:Npy)+Lx];
yp2 = [yp; yp(1:Npy)];
X = [xp2 yp2];
pair_dists = squareform(pdist(X));  % create a matrix of pair distances
pair_dists(pair_dists==0) = NaN;    % remove zeros
min_dist = min(pair_dists(:));
if min_dist < 1
    error('particles are too close')
else
    fprintf('Min dist: %0.4g\n', min_dist);
end

parms.rho_0 = rho_0;
parms.nu    = nu;
parms.g     = g;
parms.Dp    = Dp;
parms.rho_p = rho_p;
parms.gtilde= gtilde;
parms.Ri    = Ri;
parms.Pe    = Pe;

fprintf('Depth of equivalent density: %0.4g\n\n', H_eq);
fprintf('xmin    = %0.4g\n', -Lx/2);
fprintf('xmax    = %0.6g\n',  Lx/2);
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
fprintf('Np = %d\n',Np);
fprintf('particle positions:\n');
for nn = 1:Np
    fprintf('%4.5g %4.5g %4.5g %4.5g\n', xp(nn), yp(nn), 0, 0.5);
end

figure(301)
clf
viscircles([xp yp], ones(Np,1)*0.5);
axis image
xlim([-1 1]*Lx/2)
figure_defaults()
