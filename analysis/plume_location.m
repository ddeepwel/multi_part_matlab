function [time, p_locs] = plume_location()
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
  p_file = sprintf('data/mobile_%d',nn);
  p_data = check_read_dat(p_file);
  x_p(nn+1,:)  = p_data.x;  % along-length position
  y_p(nn+1,:)  = p_data.y;  % vertical position
  z_p(nn+1,:)  = p_data.z;  % across-span position (could be neglected)
end

% set time info
time = p_data.time;
Nt = length(time);

% find average initial horizontal particle separation
% (distance between particle centres)
sep = mean(diff(x_p(:,1)));

% Initialize plume location matrix
p_locs = zeros(10, Nt); % initialize plume location matrix

% calculate valleys in the particle row for each time index 
% require that peaks must be twice the particle separation distance apart
% doesn't handle periodic yet (peak could be on edge and be double counted)
for ii = 1:Nt
    [~,inds] = sort(x_p(:,ii));
    depths = -y_p(inds,ii);
    x_pos  =  x_p(inds,ii);
    [pks, locs] = findpeaks(depths, x_pos,...
        'MinPeakDistance', 2*sep); 
    p_locs(1:length(locs),ii) = locs;
end

% remove unwanted peaks that did not exist for very long
for nn = 1:10
    if sum(p_locs(nn,:) ~= 0) < 50
        p_locs = p_locs(1:nn-1,:);
        break
    end
end
