% plot the settling speed versus the distance to the nearest particle

% number of particles
[~, Np] = particle_initial_positions;

% get settling velocity
for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1)  = p_data.x;  % along-length position
    y_p(:,nn+1)  = p_data.y;  % vertical position
    z_p(:,nn+1)  = p_data.z;  % across-span position (could be neglected)
    
    % calculate velocity
    if nn == 0
        time = p_data.time;
        Dmat = FiniteDiff(time, 1, 2, true, false);
    end
    vel_p(:,nn+1) = Dmat * y_p(:,nn+1);
end

% find nearest neighbour distance
[~, part0, p_dist] = neighbour_dist();