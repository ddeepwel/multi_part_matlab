function strat = get_background_strat(ii,file_prefix)
% return the background stratification

if nargin == 1
    file_prefix = 'Data2d';
end

filename = sprintf('%s_%d.h5',file_prefix,ii);
if strncmp(filename,'Data2d',6)
    data = h5read(filename, '/xy1/c0');
    strat = squeeze(data(1,:));
else
    data = h5read(filename, '/Conc/0');
    strat = squeeze(data(1,:,1));
end


