function onset_time = perturbation_onset_time(val)
% find the time for the first particle to be perturbed by value 'val'

if nargin == 0
    val = 0.5;
end

[time, part0, dev] = row_particle_offset;
inds = nearest_index(dev, val);

onset_time = min(time(inds));
