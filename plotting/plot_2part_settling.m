% plot the separation velocity for 2 side-by-side particles

%base = '/scratch/ddeepwel/multi_part/row/Frinf/';
base = [pwd,'/'];
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

figure(135)
clf
hold on

for mm = 1:length(dirs)
    cd([base,dirs{mm}])

    [time, y_p, vel] = particle_settling();

    % check if particles are 10 Dp above the bottom
    if ~reached_bottom(10)
        disp('simulation not within 10 Dp of bottom')
    end

    if mm == length(dirs)
        p_hand(mm) = plot(time(1:tf_ind), -vel(1:tf_ind),'k');
    else
        p_hand(mm) = plot(time(1:tf_ind), -vel(1:tf_ind));
    end

    % save in structures to be used in second plot
    if mm < length(dirs)
        dist{mm} = strrep(dirs{mm}(4:end),'.','');
        s.(dist{mm}).time = time;
        s.(dist{mm}).vel  = vel;
        s.(dist{mm}).tf   = tf;
    else
        dist{mm} = dirs{mm};
        s.(dist{mm}).time = time;
        s.(dist{mm}).vel  = vel;
        s.(dist{mm}).tf   = tf;
    end
end

plot([0 40],[0 0],'Color',[0 0 0 0.3])

xlabel('$t/\tau$')
ylabel('$w/w_s$','Interpreter','latex')
%ylabel('$u_\mathrm{sep}/w_s~(\times10^{-3})$','Interpreter','latex')

legend(leg)
legend('boxoff')
legend('location','SouthEast')

figure_defaults()

cd('../figures')
print_figure('2part_settling','size',[7 4],'format','pdf')
cd('..')


figure(125)
clf
hold on
for mm = 1:length(dirs)-1
    sep0(mm) = str2num(dirs{mm}(5:end));

    t1 = s.N1.time;
    v1 = s.N1.vel;
    tf = s.s05.tf;

    v = interp1(s.(dist{mm}).time, s.(dist{mm}).vel, t1);
    v_ratio = v./v1;
    plot(t1,v_ratio)

    t1ind = nearest_index(t1,10);
    t2ind = nearest_index(t1,tf);
    v_avg_ratio(mm) = mean(v_ratio(t1ind:t2ind));
    fprintf('%s: v_ratio = %g\n',dirs{mm}, v_avg_ratio(mm));
end



figure(126)
clf
plot(sep0, v_avg_ratio,'o-')

xlabel('$s_0/D_p$')
ylabel('average settling speed relative to $N_p=1$')
grid on
figure_defaults()

cd('../figures')
print_figure('2part_settling','size',[7 4],'format','pdf')
cd('..')
