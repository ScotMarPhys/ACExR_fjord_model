% This script compares the paramteristaion of Markus 1998 of incident solar
% radiation with observations from svalbard airport
clear all; close all;
fname =('Climatology_heatflux_Longyearbyen_2004_2013.csv');    
SHF_data = dlmread(fname,',',1,0);
 ncol = size(SHF_data,2);

    Tair = SHF_data(1:365,7);
    Relh = SHF_data(1:365,8);
    Clcover = SHF_data(1:365,9);
    QHin = SHF_data(1:365,10);


r       = 7.5;           %Constant
b       = 237.3;         %Constant
So      = 1353;          %The sun constant in W/m2
albedo  = 0.1;          %Albedo of open water
psi  = 77.75;         %Latitude of the polynya in Degrees
k  = 1-0.6*(Clcover/8).^3;                     %Cloud correction term
vp = (Relh/100)*6.11.*10.^(r*Tair./(b+Tair));
d=[1:365];
i  = 23.44*cos((360/365)*(172-d)*pi/180)';
ts = 12;                               %Sun hour = 2 hours behind local time
t  = (12-ts)*15;                          %Sun hour angle
%The suns zenith angle, z, cos(z) = sin(psi)*sin(i)+cos(psi)*cos(i)*cos(t);
cosz = sin(psi*pi/180).*sin(i*pi/180)+cos(psi*pi/180).*cos(i*pi/180).*cos(t);
%Only the positive zenith angles are used in the calculation of FS
coszp = zeros(size(cosz));
coszp(find(cosz>=0)) = cosz(find(cosz>=0));
Q0 = ((So.*coszp.^2)./(1.085.*coszp+(2.7+coszp).*vp*1e-3+0.1));
FS_12 = (1-albedo)*k.*Q0;

ts = 24;                               %Sun hour = 2 hours behind local time
t  = (12-ts)*15;                          %Sun hour angle
%The suns zenith angle, z, cos(z) = sin(psi)*sin(i)+cos(psi)*cos(i)*cos(t);
cosz = sin(psi*pi/180).*sin(i*pi/180)+cos(psi*pi/180).*cos(i*pi/180).*cos(t);
%Only the positive zenith angles are used in the calculation of FS
coszp = zeros(size(cosz));
coszp(find(cosz>=0)) = cosz(find(cosz>=0));
Q0 = ((So.*coszp.^2)./(1.085.*coszp+(2.7+coszp).*vp*1e-3+0.1));
FS_24 = (1-albedo)*k.*Q0;
AVERAGE_FS = (FS_12+FS_24)/2;
figure
hLine1 = plot(FS_12,'k:','LineWidth',6);
hold all
hLine2 = plot(FS_24,'k:','LineWidth',6);
hLine3 = plot(AVERAGE_FS,'b-','LineWidth',6);
hLine4 = plot(QHin,'ro','LineWidth',4);
text(165,475,'Midday', 'fontsize',14);
text(165,195,'Midnight','fontsize',14);
hold off
legend([hLine3,hLine4],...
    {'Mean of 12 and 24 hr values','Observations'},'fontsize',14)
set(gcf, 'color', [1 1 1],'pos',[145 117 1145 972]);
figname = sprintf('QS_obs_vs_QS_param');
print('-dpng',['..\..\Writing\Thesis\figures\',figname]);
