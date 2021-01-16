function p_h = plot_avg_drift_vel(sep,particle_ID)
% plot the average drift velocity of a particle
% as a comparison between different orientation angles

if nargin == 1
    particle_ID = 0;
end

sep_str = sprintf('s%d',sep);
if strcmp(particle_ID,'com')
    fname = sprintf('avg_drift_vel_com');
else
    fname = sprintf('avg_drift_vel_%d',particle_ID);
end

%base = '/scratch/ddeepwel/multi_part/2part/Fr2/';
base = [pwd,'/'];
%direcs = {[sep_str,'_th0'],...
%    [sep_str,'_th22.5'],...
%    [sep_str,'_th45'],...
%    [sep_str,'_th67.5'],...
%    [sep_str,'_th90']};
%theta = [0 22.5 45 67.5 90];
direcs = {[sep_str,'_th22.5'],...
    [sep_str,'_th45'],...
    [sep_str,'_th67.5']};
theta = [22.5 45 67.5];


figure(44)
%clf
hold on

for mm = 1:length(direcs)
    cd([base,direcs{mm}])

    load(fname)
    plot(theta(mm), avg_drift_vel,'kd')
end

th = 0:0.1:90;
[m,n] = kynch_factor(1/(sep+1));
u_h = m * sind(th).*cosd(th);
plot(th,u_h,'k')

xlabel('$\theta~(^\circ)$')
ylabel('$u_h/w_s$')
xlim([0 90])

figure_defaults()
