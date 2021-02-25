function u_cyl_stokes = cylinder_settle_speed(rho_s)
% CYLINDER_SETTLE_SPEED  Calculate the settling speed of an infinitely
%                        long cylinder
%
%    Uses a balance of the gravitational and drag forces for a cylinder
%    where the drag coefficient for a cylinder from Bachelor's textbook is
%       C_d = 8 pi / Re / ln(7.4 / Re)
%
% Inputs:
%   'rho_s' - particle density relative to fluid density (rho_p/rho_f)
%
% Outputs:
%   'u_settling' - particle settling speed


% Defaul parameters
g = 9.81;   % acceleration due to gravity (m/s^2)
Dp = 80e-6; % particle diameter (m) 
nu = 1e-6;  % kinematic viscosity (m^2/s)

% solve equation for Re
syms Re
eqn = Re - g * Dp^3 * (rho_s - 1) / 16 /nu^2 * log(7.4/Re) == 0;
Re_settling = vpasolve(eqn, Re, [-Inf Inf]);

fprintf('Calculated Re = %0.3g\n',Re_settling)
fprintf('Should be << 1\n')

% get settling velocity relative to stokes settling
u_settling = Re_settling * nu / Dp;
u_stokes = 1/18 * (rho_s - 1) * g * Dp^2 / nu;
u_cyl_stokes = u_settling / u_stokes;