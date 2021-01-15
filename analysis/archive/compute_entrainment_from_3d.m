function [times, entrain] = compute_entrainment_from_3d()
% compute the entrainment field

true_background = true;

gd = read_grid();
par = read_params();
ymin = par.ymin;
ymax = par.ymax;
fieldname = 'c0';
h = (ymax - ymin) / par.NYM;

inds = 0:last_output('Data');
Nt = length(inds);
for mm = 1:Nt;
    ii = inds(mm);
    % get stratification with particles
    [rho, vf, time] = read_variable_3d(fieldname, ii);
    [Nx,Ny,Nz] = size(rho);

    if true_background
        % get background strat (0 particles)
        disp('true background')
        direc0 = '/scratch/ddeepwel/bsuther/multi_part/row/test_Np0_s2_Fr1';
        %direc0 = '../0prt';
        orig_dir = cd(direc0);
        [rho0, vf0, time0] = read_variable_3d(fieldname, ii);
        cd(orig_dir)
        rho_bg_vec = rho0(1,:,1);
        if abs(time - time0) > 0.25
        %    error('time between sims is different')
            % this WILL need fixing
        end
    else
        % get background strat from far field
        disp('far field')
        rho_bg_vec = rho(1,:,1);
    end
    rho_bg = repmat(rho_bg_vec,[Nx,1,Nz]);

    entrain(mm) = sum((rho_bg(:) - rho(:)) .* (1-vf(:))) * h^3;

    completion(mm,Nt)
end

times = get_output_times('Data');

if true_background
    fname = sprintf('entrain_matlab_true_backgrnd');
else
    fname = sprintf('entrain_matlab_far_field');
end

save(fname,'true_background','times','entrain')
