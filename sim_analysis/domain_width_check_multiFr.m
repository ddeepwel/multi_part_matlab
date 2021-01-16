% plot the settling velocity of an individual isolated particle
% for various domain widths 
% and different stratifications

base = '/scratch/ddeepwel/multi_part/row/';
%base = '/scratch/ddeepwel/multi_part/row/';
strats = {'Frinf/','Fr2/'};
strat_lab = {'$Fr=\infty$','$Fr = 2$'};
Nstrats = length(strats);
dirs = {'Lx05',...
        'Lx10',...
        'Lx20',...
        'Lx30',...
        'Lx40',...
       };
leg = {'$L_x/D_p = 5$',...
    '$L_x/D_p = 10$',...
    '$L_x/D_p = 20$',...
    '$L_x/D_p = 30$',...
    '$L_x/D_p = 40$',...
    };

figure(184)
clf

for nn = 1:Nstrats
    subplot(1,Nstrats,nn)
    hold on
    for mm = 1:length(dirs)
        try
            cd([base,strats{nn},'domain_width/',dirs{mm}])
        catch
            disp(['directory ',strats{nn},'domain_width/',dirs{mm},' not found'])
            continue
        end

        [time, y_p, vel] = particle_settling();

        % find time when particles are 10 Dp above the bottom
        if ~reached_bottom(10)
            disp(['simulation ',strats{nn},'domain_width/',dirs{mm},' not within 10 Dp of bottom'])
        end

        p_hand(mm) = plot(time, -vel);
    end

    xlabel('$t/\tau$')
    if nn == 1
        ylabel('$w/w_s$','Interpreter','latex')
        %ylabel('$u_\mathrm{sep}/w_s~(\times10^{-3})$','Interpreter','latex')
        xlab = -0.25;
    else
        yticklabels([])
        xlab = -0.15;
    end

    title(strat_lab{nn})
    text(gca,xlab,0.9,subplot_labels(nn),...
        'Color','k','Units','normalized','Interpreter','Latex')

    if nn == 1
        subplot(1,Nstrats,1)
        legend(p_hand(end:-1:1),leg{end:-1:1})
        legend('boxoff')
        legend('location','SouthEast')
    end
end

figure_defaults()

cd('../figures')
print_figure('domain_multiFr','size',[7 2.8],'format','pdf')
cd('..')

