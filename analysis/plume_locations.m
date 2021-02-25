function [time, p_locs_new, p_depths_new] = plume_locations()
% PLUME_LOCATION  Find the locations of each plume
%
%  Inputs:
%    - none
%
%  Outputs:
%    'time'   - the simulation time (vector)
%    'p_locs' - horizontal plume locations (2D matrix)

% number of particles
[~, Np] = particle_initial_positions;

% load particle positions
for nn = 0:Np-1
    [time, xyz_p, ~] = particle_position(nn);
    x_p(nn+1,:) = xyz_p(:,1);
    y_p(nn+1,:) = xyz_p(:,2);
    z_p(nn+1,:) = xyz_p(:,3);
end

% set time info
Nt = length(time);

% find average initial horizontal particle separation
% (distance between particle centres)
sep = mean(diff(x_p(:,1)));

% Initialize plume location matrix
p_locs = nan(10, Nt); % initialize plume location matrix
p_depths = nan(10, Nt); % initialize plume location matrix

% calculate valleys in the particle row for each time index 
% peaks must be separated by three times the particle separation distance
% doesn't handle periodic yet (peak could be on edge and be double counted)
for ii = 1:Nt
    [~,inds] = sort(x_p(:,ii));
    depths = -y_p(inds,ii);
    x_pos  =  x_p(inds,ii);
    [pks, locs] = findpeaks(depths, x_pos,...
        'MinPeakDistance', 3*sep);

    % input into the particle location and depth matrices
    if ii > 1
        for mm = 1:length(locs)
            nn = 1;
            while abs(p_locs(nn,ii-1) - locs(mm)) > 1*sep && ~isnan(p_locs(nn,ii-1))
                nn = nn+1;
            end
            p_locs(nn,ii) = locs(mm);
            p_depths(nn,ii) = pks(mm);
        end
    else
        p_locs(1:length(locs),ii) = locs;
        p_depths(1:length(pks),ii) = pks;
    end
end

% remove unwanted peaks that did not exist for very long
mm = 1;
for nn = 1:10
    if length(p_locs) - sum(isnan(p_locs(nn,:))) > 100
        p_locs_new(mm,:) = p_locs(nn,:);
        p_depths_new(mm,:) = p_depths(nn,:);
        mm = mm + 1;
    end
end
