% plot the separation velocity for 2 side-by-side particles

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

figure(134)
clf
hold on

for mm = 1:length(dirs)
    cd([base,dirs{mm}])

    par = read_params();
    ymin = par.ymin;

    [time, y_p, vel] = particle_settling();
    [time, sep, sep_vel] = particle_separation();

    % find time when particles are 10 Dp above the bottom
    tf_ind = nearest_index(y_p, ymin+10);
    tf = time(tf_ind);
    yf = y_p(tf_ind);
    if abs(yf - (ymin+10)) > 0.25
        disp(['simulation ',dirs{mm},' not within 10 Dp of bottom'])
    end

    plot(time(1:tf_ind), sep_vel(1:tf_ind))
end

plot([0 40],[0 0],'Color',[0 0 0 0.3])

xlabel('$t/\tau$')
ylabel('$u_\mathrm{sep}/w_s$','Interpreter','latex')
%ylabel('$u_\mathrm{sep}/w_s~(\times10^{-3})$','Interpreter','latex')

legend(leg)
legend('boxoff')

figure_defaults()

cd('../figures')
print_figure('2part_sepvel','size',[7 4],'format','pdf')
cd('..')
