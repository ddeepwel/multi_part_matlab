function parms = sim_parameters_volume(Re, Fr, s, Npx, Npy, Npz, Dp_dx, ep, type)
% create list of parameters to keep fixed and functions to get the correct varied parameters
% for a vertical array of particles in linear stratification
% Re: Reynolds number
% Fr: Froude number
% s: spacing between particle edges divided by the particle diameter
% Npx: number of particles in horizontal (lengthwise)
% Npy: number of particles in vertical
% Npz: number of particles in horizontal (spanwise)
% Dp_dx: points per particle diameter
% ep: epsilon, small parameter for perturbing particle location
% type: type of particle initialization to use
%       - can be either 'pert' or 'rand'
%       - pert is perturbation on the regular grid, rand is a random
%       configuration


if nargin < 6
    error('not enough input arguments')
elseif nargin == 6
    Dp_dx = 16;
    ep = 0.3;
    type = 'rand';
elseif nargin == 7
    ep = 0.3;
    type = 'rand';
end

% fixed parameters
rho_0 = 1.0;   % g/mL
nu    = 1e-6;  % m^2/s
g     = 9.81;  % m/s^2
Dp    = 80e-6; % m
Sc    = 7;   % m^2/s
Np = Npx * Npy * Npz;

% density of particle
rho_p = rho_0 * (1 + 18 * nu^2 * Re / g / Dp^3);

% non-dim gravity
gtilde = 18 * rho_0 / (rho_p - rho_0) / Re;

% Richardson number
Ri = Fr^(-2);

% Peclet number
Pe = Re * Sc;

% domain dimensions
Lx  = Npx * (s+1); % width
%Ly  = Npy * (s+1); % width
Lz  = Npz * (s+1); % spanwise length
Delta = 40;     % distance for particle to fall
H_eq = 18 * Fr^2 / Re;  % distance to depth of equivalent fluid density
LT = 10;        % buffer depth
Ly = Delta + 2*LT; % depth with added upper buffer

% resolutions
Nx = Lx * Dp_dx;
Ny = Ly * Dp_dx;
Nz = Lz * Dp_dx;
%Nx = ceil(Nx);
%Lx = Nx / Dp_dx;

% particle positions
rng('shuffle') % use the time to seed the random number generator

if strncmp(type, 'pert',4)
    if strcmp(type, 'pert_abs')
        ep_val = ep;
    elseif strcmp(type, 'pert_rel')
        % relative perturbation magnitude
        % epsilon = r * s
        ep_val = ep * s;
    else
        error('perturbation type not specified')
    end    

    Lpart = (s+1) * (Npx-1);
    Hpart = (s+1) * (Npy-1);
    Wpart = (s+1) * (Npz-1);
    xp = (-Lpart/2):(s+1):(Lpart/2);
    yp = (-Hpart):(s+1):0;
    zp = (-Wpart/2):(s+1):(Wpart/2);
    xp = xp' + normrnd(0,ep_val,[Npx,Npy,Npz]);
    yp = yp  + normrnd(0,ep_val,[Npx,Npy,Npz]);
    zp = reshape(zp,1,1,Npz) + normrnd(0,ep_val,[Npx,Npy,Npz]);
    xp_orig = xp;
    yp_orig = yp;
    zp_orig = zp;
    
    % check if any particles intersect
    xp(Npx+1,:,:) = xp(1,:,:) + Lx;
    yp(Npx+1,:,:) = yp(1,:,:);
    zp(Npx+1,:,:) = zp(1,:,:);
    xp(:,Npy+1,:) = xp(:,1,:);
    yp(:,Npy+1,:) = yp(:,1,:) + Ly;
    zp(:,Npy+1,:) = zp(:,1,:);
    xp_flat = xp(:);
    yp_flat = yp(:);
    zp_flat = zp(:);
    X = [xp_flat yp_flat zp_flat];
    pair_dists = squareform(pdist(X));  % create a matrix of pair distances
    pair_dists(pair_dists==0) = NaN;    % remove zeros
    min_dist = min(pair_dists(:));
    if min_dist < 1
        error('particles are too close')
    else
        fprintf('Min dist: %0.4g\n', min_dist);
    end
    
    xp = xp_orig(:);
    yp = yp_orig(:);
    zp = zp_orig(:);
        
elseif strcmp(type, 'rand')
    Hpart = (s+1) * (Npy-1);
    for nn = 1:Np
        xp_new = Lx*rand() - Lx/2;
        zp_new = Lz*rand() - Lz/2;
        yp_new = Hpart*rand() - Hpart;
        if nn ~= 1
            dist  = sqrt((xp-xp_new).^2 + (yp-yp_new).^2 +  (zp-zp_new).^2);
            distx = sqrt((xp+Lx-xp_new).^2 + (yp-yp_new).^2 +  (zp-zp_new).^2);
            distz = sqrt((xp-xp_new).^2 + (yp-yp_new).^2 +  (zp+Lz-zp_new).^2);
            while min(dist) <= 1 || min(distx) <= 1 || min(distz) <= 1
                xp_new = Lx*rand() - Lx/2;
                zp_new = Lz*rand() - Lz/2;
                yp_new = Hpart*rand() - Hpart;
                dist = sqrt((xp-xp_new).^2 + (yp-yp_new).^2 +  (zp-zp_new).^2);
                distx = sqrt((xp+Lx-xp_new).^2 + (yp-yp_new).^2 +  (zp-zp_new).^2);
                distz = sqrt((xp-xp_new).^2 + (yp-yp_new).^2 +  (zp+Lz-zp_new).^2);
            end
        end
        xp(nn,1) = xp_new;
        yp(nn,1) = yp_new;
        zp(nn,1) = zp_new;
    end
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
    fprintf('%4.5g %4.5g %4.5g %4.5g\n', xp(nn), yp(nn), zp(nn), 0.5);
end

figure(301)
clf
viscircles([xp yp], ones(Np,1)*0.5);
axis image
xlim([-1 1]*Lx/2)
xlabel('$x/D_p$')
ylabel('$y/D_p$')
figure_defaults()

figure(302)
clf
viscircles([zp yp], ones(Np,1)*0.5);
axis image
xlim([-1 1]*Lz/2)
xlabel('$z/D_p$')
ylabel('$y/D_p$')
figure_defaults()

figure(303)
clf
viscircles([xp zp], ones(Np,1)*0.5);
axis image
xlim([-1 1]*Lx/2)
ylim([-1 1]*Lx/2)
xlabel('$x/D_p$')
ylabel('$z/D_p$')
figure_defaults()
