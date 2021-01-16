function onset_time = perturbation_onset_time(val)
% PERTURBATION_ONSET_TIME  Find the time for any particle to be 
%    perturbed from its expected position by 'val'
%
%  Inputs:
%    'val' - perturbation value (double)
%
%  Outputs:
%    'onset_time' - first time at which a particle is offset by 'val'

% default input arguments
if nargin == 0
    val = 0.5;
end

% calculate offset values 
[time, part0, dev] = row_particle_offset;
% find indices for which the deviation equals val
inds = nearest_index(dev, val);
% take the minimum
onset_time = min(time(inds));
