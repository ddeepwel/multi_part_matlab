% plot the settling velocity for 2 side-by-side particles
% in different stratifications

base = '/scratch/ddeepwel/multi_part/row/';
strats = {'Frinf/','Fr2/'};
strat_lab = {'$Fr=\infty$','$Fr = 2$'};
Nstrats = length(strats);
dirs = {
    'N2_s0.5',...
    'N2_s1',...
    'N2_s1.5',...
    'N2_s2',...
    'N2_s2.5',...
    ...%'N2_s3',...
    ...%'N2_s3.5',...
    ...%'N2_s4',...
    ...%'N2_s4.5',...
    ...%'N2_s5',...
    'N1',...
    };
seps = 0.5:0.5:2.5;
leg = {
    '$s/D_p=0.5$',...
    '$s/D_p=1$',...
    '$s/D_p=1.5$',...
    '$s/D_p=2$',...
    '$s/D_p=2.5$',...
    ...%'$s/D_p=3$',...
    ...%'$s/D_p=3.5$',...
    ...%'$s/D_p=4$',...
    ...%'$s/D_p=4.5$',...
    ...%'$s/D_p=5$',...
    '$N_p = 1$',...
    };


% time for secondary subplot
t_steady = 15;

figure(135)
clf

for nn = 1:Nstrats
    subplot(2,Nstrats,nn)
    hold on
    for mm = 1:length(dirs)
        cd([base,strats{nn},dirs{mm}])

        [time, y_p, vel] = particle_settling();
        % find settling speed after the initial acceleration
        t_ind = nearest_index(time, t_steady);
        v_steady(nn,mm) = vel(t_ind);

        % find time when particles are 10 Dp above the bottom
        if ~reached_bottom(10)
            disp('simulation not within 10 Dp of bottom')
        end

        if mm == length(dirs)
            p_hand(mm) = plot(time(1:tf_ind), -vel(1:tf_ind),'k');
        else
            p_hand(mm) = plot(time(1:tf_ind), -vel(1:tf_ind));
        end
    end

    axis([0 30 0 1.2])
    xlabel('$t/\tau$')
    if nn == 1
        ylabel('$w_p/w_s$','Interpreter','latex')
        %ylabel('$u_\mathrm{sep}/w_s~(\times10^{-3})$','Interpreter','latex')
        xlab = -0.2;
    else
        yticklabels([])
        xlab = -0.1;
    end

    title(strat_lab{nn})
    text(gca,xlab,0.9,subplot_labels(nn),...
        'Color','k','Units','normalized','Interpreter','Latex')
end

subplot(2,2,1)
legend(leg)
legend('boxoff')
legend('location','SouthEast')

for nn = 1:Nstrats
    subplot(2, Nstrats, nn+2)
    hold on
    plot(seps, v_steady(nn,1:end-1)/v_steady(nn,end),'ko-')
    plot([0 3],[1 1],'Color',[0 0 0 0.3])
    axis([0 3 0.9 1.2+eps])
    if nn == 1
        ylabel('$w_p/w_1$')
        xlab = -0.2;
    else
        yticklabels([])
        xlab = -0.1;
    end
    xlabel('$s/D_p$')
    text(gca,xlab,0.9,subplot_labels(nn+2),...
        'Color','k','Units','normalized','Interpreter','Latex')
end

figure_defaults()

cd('../figures')
print_figure('2part_settling_multiFr','size',[7 5],'format','pdf')
cd('..')

