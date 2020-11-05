function [] = multiplot(style,save_plot)
% compare the plots to particle positions
% relative to the centre of mass for multiple
% particle numbers

if nargin == 1
    save_plot = false;
end

base = pwd;

direcs = {...
    %'N1',...
    %'N2_s1',...
    'N3_s1',...
    'N4_s1',...
    'N5_s1',...
    'N6_s1',...
    'N7_s1',...
    'N8_s1',...
    'N9_s1',...
    'N10_s1',...
    'N11_s1',...
    'N12_s1',...
    'N13_s1',...
    'N14_s1'
    };

for mm = 1:length(direcs)
    cd([base,'/',direcs{mm}])
    switch style
        case 'positions_rel_CoM'
            if mm == 1
                figure(55), clf
            end
            subplot(3,4,mm)
            plot_positions_rel_CoM(true);
            axis([-15 15 -5 5])
            grid on
        case 'centre_of_mass_settling'
            if mm == 1
                figure(75), clf
            end
            plot_centre_of_mass_settling(true);
        case 'cluster_size'
            if mm == 1
                figure(59), clf
            end
            plot_cluster_size(false,true);
        case 'cluster_size_interior'
            if mm == 1
                figure(59), clf
            end
            plot_cluster_size_interior(false,true);
        case 'cluster_width'
            if mm == 1
                figure(58), clf
            end
            plot_cluster_width(false,true);
        case 'particle_settling_middle'
            if mm == 1
                figure(62), clf
            end
            plot_particle_settling_middle(true);
    end
end

if ~strcmp(style,'positions_rel_CoM')
    subplot(2,1,1)
    legend(strrep(direcs,'_',' '))
else
    pos = get(gcf,'position');
    pos(3) = 900;
    set(gcf,'position',pos);
end
figure_defaults()

cd('..')
if save_plot
    cd('figures')
    fname = style;
    print_figure(fname,'format','pdf')
    cd('..')
end
