%function build_IC()
% build the initial conditions by adding the flow properties of 
% multiple single particles together

% new simulations parameters
Delta = 3; % spacing between particle centres
ymax_new = 10;
ymin_new = -30;

% choose time
time = 9;
touts = get_output_times('Data');
ii = nearest_index(touts,time) - 1;
% select file
filename = sprintf('Data_%d.h5',ii);
filename_f = filename;


%%%%% Read Data %%%%%

% velocities, pressure, and concentration field (density)
u  = h5read(filename, '/u');
v  = h5read(filename, '/v');
w  = h5read(filename, '/w');
p  = h5read(filename, '/p');
time  = h5read(filename, '/time')
c0 = h5read(filename, '/Conc/0');

% volume fractions
vfc = h5read(filename, '/vfc');
vfu = h5read(filename, '/vfu');
vfv = h5read(filename, '/vfv');
vfw = h5read(filename, '/vfw');

% grid
Nx = h5read(filename, '/grid/NX');
Ny = h5read(filename, '/grid/NY');
Nz = h5read(filename, '/grid/NZ');
xc = h5read(filename, '/grid/xc');
xu = h5read(filename, '/grid/xu');
yc = h5read(filename, '/grid/yc');
yv = h5read(filename, '/grid/yv');
zc = h5read(filename, '/grid/zc');
zw = h5read(filename, '/grid/zw');


% make new directory
direc = '../2prt_combine2';
mkdir(direc)
orig_dir = cd(direc);
system(['rm Resume*.h5 Data*.h5 Particle*.h5']);

% new grid
% x
dx = xc(2) - xc(1);
Nx_new = Nx + Delta/dx;
xu_new = xu(1):dx:(xu(end)+Delta);
xc_new = xu_new + dx/2;
% y
Ly_new = ymax_new - ymin_new;
Ny_new = Ly_new / dx + 1;
yv_new = ymin_new:dx:ymax_new;
yc_new = yv_new + dx/2;


u_new = zeros(Nx_new, Ny_new, Nz);
v_new = u_new;
w_new = u_new;
p_new = u_new;
c0_new = u_new;
vfc_new = u_new;
vfu_new = u_new;
vfv_new = u_new;
vfw_new = u_new;


% sum the full domain onto the new domain
xi = nearest_index(xu_new,Delta/2);

u_new(1:Nx,end-Ny+1:end,:) = u;
v_new(1:Nx,end-Ny+1:end,:) = v;
w_new(1:Nx,end-Ny+1:end,:) = w;
p_new(1:xi,end-Ny+1:end,:) = p(1:xi,:,:);
c0_new(1:xi,end-Ny+1:end,:) = c0(1:xi,:,:);
vfc_new(1:Nx,end-Ny+1:end,:) = vfc;
vfu_new(1:Nx,end-Ny+1:end,:) = vfu;
vfv_new(1:Nx,end-Ny+1:end,:) = vfv;
vfw_new(1:Nx,end-Ny+1:end,:) = vfw;

u_new(Nx_new-Nx+1:end,end-Ny+1:end,:) =     u_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + u;
v_new(Nx_new-Nx+1:end,end-Ny+1:end,:) =     v_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + v;
w_new(Nx_new-Nx+1:end,end-Ny+1:end,:) =     w_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + w;
p_new(Nx_new-xi+1:end,end-Ny+1:end,:) =             p(Nx-xi+1:end,end-Ny+1:end,:);
c0_new(Nx_new-xi+1:end,end-Ny+1:end,:) =           c0(Nx-xi+1:end,end-Ny+1:end,:);
vfc_new(Nx_new-Nx+1:end,end-Ny+1:end,:) = vfc_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + vfc;
vfu_new(Nx_new-Nx+1:end,end-Ny+1:end,:) = vfu_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + vfu;
vfv_new(Nx_new-Nx+1:end,end-Ny+1:end,:) = vfv_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + vfv;
vfw_new(Nx_new-Nx+1:end,end-Ny+1:end,:) = vfw_new(Nx_new-Nx+1:end,end-Ny+1:end,:) + vfw;


%%%%% write into new file %%%%%
%system(['cp ../1prt/',filename,' .'])
filename = sprintf('Data_0.h5');

h5create(filename,'/time', 1)
h5write(filename, '/time', time)

h5create(filename,'/u',size(u_new))
h5create(filename,'/v',size(v_new))
h5create(filename,'/w',size(w_new))
h5create(filename,'/p',size(p_new))
h5create(filename,'/Conc/0',size(c0_new))

h5write(filename, '/u', u_new)
h5write(filename, '/v', v_new)
h5write(filename, '/w', w_new)
h5write(filename, '/p', p_new)
h5write(filename, '/Conc/0', c0_new)

h5create(filename,'/vfc',size(u_new))
h5create(filename,'/vfu',size(u_new))
h5create(filename,'/vfv',size(u_new))
h5create(filename,'/vfw',size(u_new))

h5write(filename, '/vfc', vfc_new)
h5write(filename, '/vfu', vfu_new)
h5write(filename, '/vfv', vfv_new)
h5write(filename, '/vfw', vfw_new)

h5create(filename,'/grid/NX', 1)
h5create(filename,'/grid/NY', 1)
h5create(filename,'/grid/NZ', 1)
h5create(filename,'/grid/xc', size(xc_new))
h5create(filename,'/grid/xu', size(xc_new))
h5create(filename,'/grid/yc', size(yc_new))
h5create(filename,'/grid/yv', size(yv_new))
h5create(filename,'/grid/zc', size(zc))
h5create(filename,'/grid/zw', size(zw))

h5write(filename, '/grid/NX', Nx_new);
h5write(filename, '/grid/NY', Ny_new);
h5write(filename, '/grid/NZ', Nz);
h5write(filename, '/grid/xc', xc_new);
h5write(filename, '/grid/xu', xu_new);
h5write(filename, '/grid/yc', yc_new);
h5write(filename, '/grid/yv', yv_new);
h5write(filename, '/grid/zc', zc);
h5write(filename, '/grid/zw', zw);


%%%%% create new Particles_XX.h5 file %%%%%

cd(orig_dir)
filename = sprintf('Particle_%d.h5',ii);

time  = h5read(filename, '/time');
periodic = h5read(filename, '/domain/periodic');
xmax = h5read(filename, '/domain/xmax');
xmin = h5read(filename, '/domain/xmin');
ymax = h5read(filename, '/domain/ymax');
ymin = h5read(filename, '/domain/ymin');
zmax = h5read(filename, '/domain/zmax');
zmin = h5read(filename, '/domain/zmin');
F    = h5read(filename, '/mobile/F');
F_IBM    = h5read(filename, '/mobile/F_IBM');
F_coll    = h5read(filename, '/mobile/F_coll');
F_rigid    = h5read(filename, '/mobile/F_rigid');
Fc    = h5read(filename, '/mobile/Fc');
Int_Omega_old = h5read(filename, '/mobile/Int_Omega_old');
Int_U_old = h5read(filename, '/mobile/Int_U_old');
Omega = h5read(filename, '/mobile/Omega');
R = h5read(filename, '/mobile/R');
Rotn = h5read(filename, '/mobile/Rotn');
T = h5read(filename, '/mobile/T');
T_IBM = h5read(filename, '/mobile/T_IBM');
T_coll = h5read(filename, '/mobile/T_coll');
T_rigid = h5read(filename, '/mobile/T_rigid');
Tc = h5read(filename, '/mobile/Tc');
U = h5read(filename, '/mobile/U');
X = h5read(filename, '/mobile/X');
collision_data = h5read(filename, '/mobile/collision_data');

orig_dir = cd(direc);
filename = sprintf('Particle_0.h5');


h5create(filename,'/time', 1)
h5write(filename, '/time', time)

h5create(filename,'/domain/periodic', 3)
h5create(filename,'/domain/xmax', 1)
h5create(filename,'/domain/xmin', 1)
h5create(filename,'/domain/ymax', 1)
h5create(filename,'/domain/ymin', 1)
h5create(filename,'/domain/zmax', 1)
h5create(filename,'/domain/zmin', 1)

h5write(filename, '/domain/periodic', periodic)
h5write(filename, '/domain/xmax', max(xu_new))
h5write(filename, '/domain/xmin', min(xu_new))
h5write(filename, '/domain/ymax', max(yv_new))
h5write(filename, '/domain/ymin', min(yv_new))
h5write(filename, '/domain/zmax', zmax)
h5write(filename, '/domain/zmin', zmin)

h5create(filename,'/mobile/F', [3 2])
h5create(filename,'/mobile/F_IBM', [3 2])
h5create(filename,'/mobile/F_coll', [3 2])
h5create(filename,'/mobile/F_rigid', [3 2])
h5create(filename,'/mobile/Fc', [3 2])
h5create(filename,'/mobile/Int_Omega_old', [3 2])
h5create(filename,'/mobile/Int_U_old', [3 2])
h5create(filename,'/mobile/Omega', [3 2])
h5create(filename,'/mobile/R', [1 2])
h5create(filename,'/mobile/Rotn', [9 2])
h5create(filename,'/mobile/T', [3 2])
h5create(filename,'/mobile/T_IBM', [3 2])
h5create(filename,'/mobile/T_coll', [3 2])
h5create(filename,'/mobile/T_rigid', [3 2])
h5create(filename,'/mobile/Tc', [3 2])
h5create(filename,'/mobile/U', [3 2])
h5create(filename,'/mobile/X', [3 2])
h5create(filename,'/mobile/collision_data', [2 2])
X2 = [X(1)+Delta; X(2:end)];

h5write(filename, '/mobile/F', [F F])
h5write(filename, '/mobile/F_IBM', [F_IBM F_IBM])
h5write(filename, '/mobile/F_coll', [F_coll F_coll])
h5write(filename, '/mobile/F_rigid', [F_rigid F_rigid])
h5write(filename, '/mobile/Fc', [Fc Fc])
h5write(filename, '/mobile/Int_Omega_old', [Int_Omega_old Int_Omega_old])
h5write(filename, '/mobile/Int_U_old', [Int_U_old Int_U_old])
h5write(filename, '/mobile/Omega', [Omega Omega])
h5write(filename, '/mobile/R', [R R])
h5write(filename, '/mobile/Rotn', [Rotn Rotn])
h5write(filename, '/mobile/T', [T T])
h5write(filename, '/mobile/T_IBM', [T_IBM T_IBM])
h5write(filename, '/mobile/T_coll', [T_coll T_coll])
h5write(filename, '/mobile/T_rigid', [T_rigid T_rigid])
h5write(filename, '/mobile/Tc', [Tc Tc])
h5write(filename, '/mobile/U', [U U])
h5write(filename, '/mobile/X', [X X2])
h5write(filename, '/mobile/collision_data', [collision_data collision_data])



%%%%% Create the Resume file %%%%%

cd(orig_dir)
filename = sprintf('Resume_%d.h5',ii);
dt = h5read(filename, '/dt');
dt_old = h5read(filename, '/dt_old');
timers = h5read(filename, '/timer');

cd(direc);

filename = sprintf('Resume_%d.h5',ii);
system(['cp ../1prt/',filename,' .']);
system(['mv ',filename,' Resume_0.h5']);
system(sprintf('ln -s Resume_0.h5 Resume.h5'));
filename = sprintf('Resume_0.h5');

%h5create(filename,'/dp_dx', 1)
%h5create(filename,'/dt', 1)
%h5create(filename,'/dt_old', 1)
%h5create(filename,'/noutput', 1)
%h5create(filename,'/noutput_2d', 1)
%h5create(filename,'/noutput_part', 1)
%h5create(filename,'/ntime', 1)
%h5create(filename,'/output_time', 1)
%h5create(filename,'/output_time_2d', 1)
%h5create(filename,'/time', 1)
%h5create(filename,'/timer', 34)

h5write(filename, '/dp_dx', 0)
h5write(filename, '/dt', dt)
h5write(filename, '/dt_old', dt_old)
h5write(filename, '/noutput', int32(0))
h5write(filename, '/noutput_2d', int32(0))
h5write(filename, '/noutput_part', int32(0))
h5write(filename, '/ntime', int32(1))
h5write(filename, '/output_time', 0)
h5write(filename, '/output_time_2d', 0)
h5write(filename, '/time', time)
h5write(filename, '/timer', timers)




% move parties files
system('cp ../1prt/*.inp .');
system('cp ../1prt/parties .');
system('cp ../1prt/submit.sh .');

system(['sed -i -e ''s/^xmax.*$/xmax = ',num2str(max(xu_new)),'/'' parties.inp']);
system(['sed -i -e ''s/^NXM.*$/NXM = ',num2str(Nx_new-1),'/'' parties.inp']);
system(['sed -i -e ''s/^resume.*$/resume = 1    # if 0 =  start from t=0/'' parties.inp']);
%system(['sed -i -e ''$a\'' p_mobile.inp'])
system(['sed -i -e ''1 s/^.*$/2/'' p_mobile.inp']);
system(['echo ''',num2str(Delta),' 0 0 0.5'' >> p_mobile.inp']);



%%%%% visual checks %%%%%

%v_sl = squeeze(v_new(:,:,round(Nz/2)));
v_sl = squeeze(vfc_new(:,:,round(Nz/2)));
%v_sl = squeeze(c0_new(:,:,round(Nz/2)));
%c0_sl = squeeze(c0_new(:,:,round(Nz/2)));

figure(55)
clf

keyboard
pcolor(xu_new,yv_new,v_sl')
shading flat
colormap(cmocean('balance'))
colorbar
%caxis([-1 1]*0.8)
figure_defaults()


cd('../s2_th90')
gd2 = read_grid();
v2  = h5read(filename_f, '/v');
v2_sl = squeeze(v2(:,:,round(Nz/2)));

figure(56)
clf
pcolor(gd2.xc,gd2.yc,v2_sl')
shading flat
colormap(cmocean('balance'))
colorbar
caxis([-1 1]*0.8)
figure_defaults()

figure(57)
clf
vdiff = v_sl(:,end-Ny+1:end,:) - v2_sl;
pcolor(gd2.xc, gd2.yc, vdiff')
shading flat
colormap(cmocean('balance'))
colorbar
%caxis([-1 1]*0.8)
figure_defaults()

