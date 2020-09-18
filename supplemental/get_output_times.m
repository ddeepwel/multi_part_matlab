function time = get_output_times(file_prefix)
% get the output times from the data files

tinds = 0:last_output(file_prefix); 
Noutputs = length(tinds);
time = zeros(Noutputs,1);

for ii = tinds
    filename = sprintf('%s_%d.h5', file_prefix, ii);
    time(ii+1) = h5read(filename,'/time');
end

