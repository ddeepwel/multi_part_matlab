function p_h = plot_avg_drift_vel_from_com(sep,particle_ID)
% plot the average drift velocity of a particle
% relative to the centre of mass
% as a comparison between different orientation angles

if nargin == 1
    particle_ID = 0;
end

sep_str = sprintf('s%d',sep);
fname = sprintf('avg_drift_vel_%d',particle_ID);

base = '/scratch/ddeepwel/multi_part/2part/Fr2/';
direcs = {[sep_str,'_th0'],...
    [sep_str,'_th22.5'],...
    [sep_str,'_th45'],...
    [sep_str,'_th67.5'],...
    [sep_str,'_th90']};
theta = [0 22.5 45 67.5 90];


figure(44)
%clf
hold on

for mm = 1:length(direcs)
    cd([base,direcs{mm}])

    p_vel = load(fname);
    com_vel = load('avg_drift_vel_com');
    drift_vel = p_vel.avg_drift_vel - com_vel.avg_drift_vel;

    plot(theta(mm), drift_vel,'sb')
end

