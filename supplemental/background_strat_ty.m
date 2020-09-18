function [time, y, strat_ty] = background_strat_ty(file_prefix)
% create the space-time plot of the background stratification

if nargin == 0
    file_prefix = 'Data2d';
end

tf = last_output(file_prefix);
par = read_params();
gd = read_grid();
Ny = par.NYM;
ts = 0:tf;
Nt = length(ts);

strat_ty = zeros(Nt,Ny+1);
y = gd.yc;
time = get_output_times(file_prefix);

for jj = 1:Nt
    ii = ts(jj);
    strat_ty(ii+1,:) = get_background_strat(ii,file_prefix)';
end


