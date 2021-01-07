function [] = plot_perturbation_onset_time(val)
% plot the perturbation onset time vs perturbation

if nargin == 0
    val = 0.5;
end

base = [pwd,'/'];
dirs = {'N11_s1_y-03_periodic',...
        'N11_s1_y-02_periodic',...
        'N11_s1_y-01_periodic',...
        'N11_s1_y01_periodic',...
        'N11_s1_y02_periodic',...
        'N11_s1_y03_periodic',...
    };
perts = [-0.3 -0.2 -0.1 0.1 0.2 0.3];

for mm = 1:length(dirs)
    cd([base,dirs{mm}])
    onset_time(mm) = perturbation_onset_time(val);
end

figure(89)
clf
plot(perts, onset_time, 'o-')

xlabel('y perturbation')
ylabel('$t_{onset}/\tau$')
ttl = sprintf('onset time for pert %0.3g',val);
title(ttl)
figure_defaults()

yl = ylim();
ylim([0 yl(2)])

cd('../figures')
fname = ['onset_time_',strrep(num2str(val),'.','')];
print_figure(fname,'format','pdf')
cd('..')
