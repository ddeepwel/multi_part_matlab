function inds = lowest_particles(tc)
% list of particle IDs from lowest to highest
%
% Inputs:
%   - 'tc' - time to sort particles (double)
%
% Outputs:
%   'inds' - list of particle IDs, ordered from lowest to highest
%            (1 is left most particle, Np is rightmost)
%            (vector of integers)

% number of particles
[part0, Np] = particle_initial_positions();

if tc == 0
    [~,inds] = sort(part0(:,2));
else
    % load particle positions
    for nn = 0:Np-1
        p_file = sprintf('mobile_%d', nn);
        p_data = check_read_dat(p_file);
        y_p(:,nn+1) = p_data.y;
    end
    time = p_data.time;

    tind = nearest_index(time, tc);
    [~, inds] = sort(y_p(tind,:)');
end
