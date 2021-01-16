function [] = plot_2part_sepvel()
% plot the separation velocity for 2 side-by-side particles


% select cases to plot
%base = '/scratch/ddeepwel/multi_part/row/Frinf/';
base = [pwd,'/'];
dirs = {
    'N2_s0.5',...
    'N2_s1',...
    'N2_s1.5',...
    'N2_s2',...
    'N2_s2.5'};%,...
    %'N2_s3',...
    %'N2_s3.5',...
    %'N2_s4',...
    %'N2_s4.5',...
    %'N2_s5',...
    %};
% legend labels
leg = {
    '$s/D_p=0.5$',...
    '$s/D_p=1$',...
    '$s/D_p=1.5$',...
    '$s/D_p=2$',...
    '$s/D_p=2.5$'};%,...
    %'$s/D_p=3$',...
    %'$s/D_p=3.5$',...
    %'$s/D_p=4$',...
    %'$s/D_p=4.5$',...
    %'$s/D_p=5$',...
    %};

% setup the figure
figure(134)
clf
hold on

% loop through cases
for mm = 1:length(dirs)
    cd([base,dirs{mm}])

    % load data
    [time, y_p, vel] = particle_settling();
    [time, sep, sep_vel] = particle_separation();

    % check if particles are 10 Dp above the bottom
    % plot only until this point
    if ~reached_bottom(10)
        disp('simulation not within 10 Dp of bottom')
    end

    plot(time(1:tf_ind), sep_vel(1:tf_ind))
end

% add thin grey line
plot([0 40],[0 0],'Color',[0 0 0 0.3])

% labels, legend, and beautify
xlabel('$t/\tau$')
ylabel('$u_\mathrm{sep}/w_s$','Interpreter','latex')

legend(leg)
legend('boxoff')

figure_defaults()

% print figure
cd('../figures')
print_figure('2part_sepvel','size',[7 4],'format','pdf')
cd('..')
