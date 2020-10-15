% plot the difference between a combined case and a true case with 2 particles


dir1 = '/home/ddeepwel/scratch/multi_part/2part/Fr2/2prt_combine';
dir2 = '/home/ddeepwel/scratch/multi_part/2part/Fr2/s2_th90';

dirs = {dir1, dir2};
col = default_line_colours;

figure(43)
clf
hold on

figure(44)
clf
hold on

for ii = 1:2
    cd(dirs{ii})

    % read particle files
    Np = 2;
    p = cell(1, Np);
    for mm = 1:Np
        fname = sprintf('mobile_%d', mm-1);
        p{mm} = check_read_dat(fname);
    end

    %plot_particle_positions();

    figure(43)
    plot(p{1}.x,p{1}.y,'Color',col(ii,:))
    plot(p{2}.x,p{2}.y,'Color',col(ii,:))

    if ii == 1
        y_restart = p{1}.y(1);
        ind = 1;
    else
        ind = nearest_index(p{1}.y, y_restart);
    end

    figure(44)
    plot(p{1}.x-p{1}.x(ind), p{1}.y,'Color',col(ii,:))
    plot(p{2}.x-p{2}.x(ind), p{2}.y,'Color',col(ii,:))

end
