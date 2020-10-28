function [] = plot_positions_rel_CoM_multi()
% compare the plots to particle positions
% relative to the centre of mass for multiple
% particle numbers


base = pwd;

direcs = {...%'N2_s1',...
    'N3_s1',...
    'N4_s1',...
    'N5_s1',...
    'N6_s1',...
    'N7_s1',...
    'N8_s1'};

figure(55)
clf

for mm = 1:length(direcs)
    cd([base,'/',direcs{mm}])
    subplot(2,3,mm)
    plot_positions_rel_CoM(true);
end

cd('..')
