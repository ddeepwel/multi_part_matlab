function [m, n] = kynch_factor(d_s)
% drift factor from Kynch 1959 (eq 4.4, using 3.24)
% d_s is Dp divided by distance between particle centres

a = d_s/2; % Dp/2R

P = 1/( 1 -     a^6 * (5-12*a^2)^2 );
Q = 1/( 1 - 1/4*a^6 * (5-16*a^2)^2 );
K = 1 - 2*a^6*Q;
L = -15/4*a^4*P*(1-8/5*a^2);
M = 1/4*(3+2*a^2) + 8/5*a^10 * Q * (5-16*a^2);
N = 3/4*(1-2*a^2) + 3/8*a^6  * ( 10*P*(1-8/5*a^2)^2*(5-12*a^2) - Q*8^2/15*a^4*(5-16*a^2) );

m = L + a*N;
n = K + a*M;
