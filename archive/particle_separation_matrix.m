function sep_mat = particle_separation_matrix()
% create a matrix of the particle separation

% number of particles
[~, Np] = particle_initial_positions;

par = read_params();
Lx = par.xmax - par.xmin;

for nn = 0:Np-1
    p_file = sprintf('mobile_%d', nn);
    p_data = check_read_dat(p_file);
    x_p(:,nn+1) = p_data.x;
end

x_p_diff = diff(x_p,[],2);
x_p_diff(:,Np) = Lx - (x_p(:,Np) - x_p(:,1));
[~,ind] = min(x_p_diff,[],2);

x_p2 = [x_p(:,1:ind-1) x_p(:,ind+2:end)];
x_p_diff2 = diff(x_p2,[],2);
x_p_diff2(:,Np-2) = Lx - (x_p2(:,Np-2) - x_p2(:,1));
[~,ind] = min(x_p_diff2,[],2);


keyboard

%ind0 = ind;

%x_p_diff2 = [x_p_diff(:,1:ind-2) x_p_diff(:,ind+2:end)];
%[~,ind] = min(x_p_diff2,[],2);


