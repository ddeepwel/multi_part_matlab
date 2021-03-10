function [time, yp_lowest, vp_lowest] = lowest_particle()
% Give the time series of the vertical position of the
% lowest particle
%
% Outputs:
%   'time' - time series (vector)
%   'yp_lowest' - vertical position of lowest particle (vector)
%   'vp_lowest' - vertical velocity of lowest particle (vector)

% number of particles
[~, Np] = particle_initial_positions();

% load particle positions
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    if nn == 0
        time = p_data.time;
        inds = 1:length(time);
    end
    y_p(:,nn+1) = p_data.y(inds);
end

yp_lowest = min(y_p,[],2);

Dmat = FiniteDiff(time,1,2,true,false);
vp_lowest = Dmat * yp_lowest;
