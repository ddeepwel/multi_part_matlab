% combine particles and make a superposition

base = '/home/ddeepwel/scratch/multi_part/superposition/';
dir12 = [base,'p12'];
dir23 = [base,'p23'];
dir13 = [base,'p13'];
diral = [base,'all'];

cd(dir12)
p12_1 = check_read_dat('mobile_0');
p12_2 = check_read_dat('mobile_1');
cd(dir13)
p13_1 = check_read_dat('mobile_0');
p13_3 = check_read_dat('mobile_1');
cd(dir23)
p23_2 = check_read_dat('mobile_0');
p23_3 = check_read_dat('mobile_1');
cd(diral)
pal_1 = check_read_dat('mobile_0');
pal_2 = check_read_dat('mobile_1');
pal_3 = check_read_dat('mobile_2');

t12 = p12_1.time;
Dmat1 = FiniteDiff(t12,1,2,true,false);
Dmat2 = FiniteDiff(t12,2,4,true,false);


figure(23)
clf
hold on

plot(p12_1.x, p12_1.y, 'r')
plot(p12_2.x, p12_2.y, 'r')
plot(p13_1.x, p13_1.y, 'g')
plot(p13_3.x, p13_3.y, 'g')
plot(p23_2.x, p23_2.y, 'b')
plot(p23_3.x, p23_3.y, 'b')
plot(pal_1.x, pal_1.y, 'k')
plot(pal_2.x, pal_2.y, 'k')
plot(pal_3.x, pal_3.y, 'k')

% superposition of paths
p13_1_new.x = interp1(p13_1.time, p13_1.x, t12, 'pchip');
p13_1_new.y = interp1(p13_1.time, p13_1.y, t12, 'pchip');
p13_3_new.x = interp1(p13_3.time, p13_3.x, t12, 'pchip');
p13_3_new.y = interp1(p13_3.time, p13_3.y, t12, 'pchip');
p23_2_new.x = interp1(p23_2.time, p23_2.x, t12, 'pchip');
p23_2_new.y = interp1(p23_2.time, p23_2.y, t12, 'pchip');
p23_3_new.x = interp1(p23_3.time, p23_3.x, t12, 'pchip');
p23_3_new.y = interp1(p23_3.time, p23_3.y, t12, 'pchip');

if false
    p1.x = (p12_1.x + p13_1_new.x) - p13_1_new.x(1);
    p1.y = (p12_1.y + p13_1_new.y) - p13_1_new.y(1);
    p2.x = (p12_2.x + p23_2_new.x) - p23_2_new.x(1);
    p2.y = (p12_2.y + p23_2_new.y) - p23_2_new.y(1);
    p3.x = (p13_3_new.x + p23_3_new.x) - p23_3_new.x(1);
    p3.y = (p13_3_new.y + p23_3_new.y) - p23_3_new.y(1);
elseif false
    p1.x = (p12_1.x + p13_1_new.x)/2;
    p1.y = (p12_1.y + p13_1_new.y)/2;
    p2.x = (p12_2.x + p23_2_new.x)/2;
    p2.y = (p12_2.y + p23_2_new.y)/2;
    p3.x = (p13_3_new.x + p23_3_new.x)/2;
    p3.y = (p13_3_new.y + p23_3_new.y)/2;
else
    p1.x = (p12_1.x + p13_1_new.x) - p13_1_new.x(1);
    p1.y = (p12_1.y + p13_1_new.y)/2;
    p2.x = (p12_2.x + p23_2_new.x) - p23_2_new.x(1);
    p2.y = (p12_2.y + p23_2_new.y)/2;
    p3.x = (p13_3_new.x + p23_3_new.x) - p23_3_new.x(1);
    p3.y = (p13_3_new.y + p23_3_new.y)/2;
end

plot(p1.x, p1.y, 'k--')
plot(p2.x, p2.y, 'k--')
plot(p3.x, p3.y, 'k--')

xlabel('$x/D_p$')
ylabel('$z/D_p$')
title('mean paths')

warning('the y distance needs to be handled differently!!')
%return

figure(24)
clf
hold on

plot(p12_1.x, p12_1.y, 'r')
plot(p12_2.x, p12_2.y, 'r')
plot(p13_1.x, p13_1.y, 'g')
plot(p13_3.x, p13_3.y, 'g')
plot(p23_2.x, p23_2.y, 'b')
plot(p23_3.x, p23_3.y, 'b')
plot(pal_1.x, pal_1.y, 'k')
plot(pal_2.x, pal_2.y, 'k')
plot(pal_3.x, pal_3.y, 'k')

v12_1.x = Dmat1 * p12_1.x;
v13_1.x = Dmat1 * p13_1_new.x;
v12_1.y = Dmat1 * p12_1.y;
v13_1.y = Dmat1 * p13_1_new.y;

v12_2.x = Dmat1 * p12_2.x;
v23_2.x = Dmat1 * p23_2_new.x;
v12_2.y = Dmat1 * p12_2.y;
v23_2.y = Dmat1 * p23_2_new.y;

v13_3.x = Dmat1 * p13_3_new.x;
v23_3.x = Dmat1 * p23_3_new.x;
v13_3.y = Dmat1 * p13_3_new.y;
v23_3.y = Dmat1 * p23_3_new.y;

v1.x = v12_1.x + v13_1.x;
v1.y = v12_1.y + v13_1.y;
v2.x = v12_2.x + v23_2.x;
v2.y = v12_2.y + v23_2.y;
v3.x = v13_3.x + v23_3.x;
v3.y = v13_3.y + v23_3.y;

p1_tot.x = cumtrapz(t12, v1.x) + p1.x;
p2_tot.x = cumtrapz(t12, v2.x) + p2.x;
p3_tot.x = cumtrapz(t12, v3.x) + p3.x;
p1_tot.y = cumtrapz(t12, v1.y) + p1.y;
p2_tot.y = cumtrapz(t12, v2.y) + p2.y;
p3_tot.y = cumtrapz(t12, v3.y) + p3.y;

%plot(p1_tot.x, p1_tot.y, 'k--')
%plot(p2_tot.x, p2_tot.y, 'k--')
%plot(p3_tot.x, p3_tot.y, 'k--')

xlabel('$x/D_p$')
ylabel('$z/D_p$')
%title('sum of velocities')


figure_defaults();




return

figure(25)
clf
hold on


plot(p12_1.x, p12_1.y, 'r')
plot(p12_2.x, p12_2.y, 'r')
plot(p13_1.x, p13_1.y, 'g')
plot(p13_3.x, p13_3.y, 'g')
plot(p23_2.x, p23_2.y, 'b')
plot(p23_3.x, p23_3.y, 'b')
plot(pal_1.x, pal_1.y, 'k')
plot(pal_2.x, pal_2.y, 'k')
plot(pal_3.x, pal_3.y, 'k')

% superposition using acceleration (F=ma)
a12_1.x = Dmat2 * p12_1.x;
a13_1.x = Dmat2 * p13_1_new.x;
a12_1.y = Dmat2 * p12_1.y;
a13_1.y = Dmat2 * p13_1_new.y;

a12_2.x = Dmat2 * p12_2.x;
a23_2.x = Dmat2 * p23_2_new.x;
a12_2.y = Dmat2 * p12_2.y;
a23_2.y = Dmat2 * p23_2_new.y;

a13_3.x = Dmat2 * p13_3_new.x;
a23_3.x = Dmat2 * p23_3_new.x;
a13_3.y = Dmat2 * p13_3_new.y;
a23_3.y = Dmat2 * p23_3_new.y;

a1.x = a12_1.x + a13_1.x;
a1.y = a12_1.y + a13_1.y;
a2.x = a12_2.x + a23_2.x;
a2.y = a12_2.y + a23_2.y;
a3.x = a13_3.x + a23_3.x;
a3.y = a13_3.y + a23_3.y;
a1.x = a12_1.x;
a1.y = a12_1.y;
a2.x = a23_2.x;
a2.y = a23_2.y;
a3.x = a13_3.x;
a3.y = a13_3.y;

p1_tot.x = cumtrapz(t12, cumtrapz(t12, a1.x)) + p1.x;
p2_tot.x = cumtrapz(t12, cumtrapz(t12, a2.x)) + p2.x;
p3_tot.x = cumtrapz(t12, cumtrapz(t12, a3.x)) + p3.x;
p1_tot.y = cumtrapz(t12, cumtrapz(t12, a1.y)) + p1.y;
p2_tot.y = cumtrapz(t12, cumtrapz(t12, a2.y)) + p2.y;
p3_tot.y = cumtrapz(t12, cumtrapz(t12, a3.y)) + p3.y;

plot(p1_tot.x, p1_tot.y, 'k--')
plot(p2_tot.x, p2_tot.y, 'k--')
plot(p3_tot.x, p3_tot.y, 'k--')

xlabel('$x/D_p$')
ylabel('$z/D_p$')
title('sum of accelerations')


warning('differentiation/integration schemes are REALLY bad!')
