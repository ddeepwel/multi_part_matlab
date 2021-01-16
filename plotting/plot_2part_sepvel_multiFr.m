function [] = plot_2part_sepvel()
% plot the separation velocity for 2 side-by-side particles
% for different stratifications

% select cases to plot
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
    };
% legend labels
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
    };

% setup the figure
figure(134)
clf

% loop through stratifications
for nn = 1:Nstrats
    subplot(1,Nstrats,nn)
    hold on

    % loop through separation distance
    for mm = 1:length(dirs)
        cd([base,strats{nn},dirs{mm}])

        % load data
        [time, y_p, vel] = particle_settling();
        [time, sep, sep_vel] = particle_separation();

        % find time when particles are 10 Dp above the bottom
        % plot only until this point
        if ~reached_bottom(10)
            disp('simulation not within 10 Dp of bottom')
        end

        p_hand(mm) = plot(time(1:tf_ind), sep_vel(1:tf_ind));
    end

    % add thin grey line
    plot([0 40],[0 0],'Color',[0 0 0 0.3])

    % improve look of plot
    axis([0 30 -0.01 0.025])
    xlabel('$t/\tau$')
    if nn == 1
        ylabel('$w/w_s$','Interpreter','latex')
        xlab = -0.25;
    else
        yticklabels([])
        xlab = -0.15;
    end

    title(strat_lab{nn})
    text(gca,xlab,0.9,subplot_labels(nn),...
        'Color','k','Units','normalized','Interpreter','Latex')
end

% add legend
subplot(1,Nstrats,1)
legend(leg)
legend('boxoff')
legend('location','SouthEast')

figure_defaults()

% print figure
cd('../figures')
print_figure('2part_sepvel_multiFr','size',[7 2.8],'format','pdf')
cd('..')

