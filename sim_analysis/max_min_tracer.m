function [] = max_min_tracer(field)
% find the maximum of the tracer field from output files

if nargin == 0
    field = '0';
end

%% maximum from full fields
first_out = 0;
last_out = last_output();
outputs = first_out:last_out;
N_outputs = length(outputs);

max_c_3d  = zeros(1,N_outputs);
min_c_3d  = zeros(1,N_outputs);

disp('Starting 3D')
for jj = 1:N_outputs
    ii = outputs(jj);
    filename = sprintf('Data_%d.h5',ii);
    c0 = h5read(filename, ['/Conc/',field]);
    vf = h5read(filename, '/vfc');
    max_c_3d(jj) = max(c0(:).*(1-vf(:)));
    min_c_3d(jj) = min(c0(:).*(1-vf(:)));

    completion(jj,N_outputs)
end
time_3d = get_output_times('Data');

%% maximum from 2D cross-sections
first_out = 0;
last_out = last_output('Data2d');
outputs = first_out:last_out;
N_outputs = length(outputs);

max_c_2d  = zeros(1,N_outputs);
min_c_2d  = zeros(1,N_outputs);

disp('Starting 2D')
for jj = 1:N_outputs
    ii = outputs(jj);
    filename = sprintf('Data2d_%d.h5',ii);
    c0 = h5read(filename, ['/xy1/c',field]);
    vf = h5read(filename, '/xy1/vf');
    max_c_2d(jj) = max(c0(:).*(1-vf(:)));
    min_c_2d(jj) = min(c0(:).*(1-vf(:)));

    completion(jj,N_outputs)
end
time_2d = get_output_times('Data2d');

save(['max_c',field],'time_3d','max_c_3d','min_c_3d','time_2d','max_c_2d','min_c_2d','field')
