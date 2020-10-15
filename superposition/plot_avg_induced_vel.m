% plot the average induced velocities

direcs = {'s1_th90','../s2_90','../s3_90'};

figure(77)
clf

for mm = 1:length(direcs)
    cd(direcs{mm})
    load('induced_vel_0')

    subplot(2,1,1)
    hold on
    plot(mm,u_avg_induced,'ok')
    ylabel('$u_{induced}/w_s$')
    xlim([0 4])

    subplot(2,1,2)
    hold on
    plot(mm,v_avg_induced,'ok')
    ylabel('$v_{induced}/w_s$')
    xlabel('$s/D_p$')
    xlim([0 4])
end

figure_defaults()

