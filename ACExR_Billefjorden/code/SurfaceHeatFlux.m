function Q = SurfaceHeatFlux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function Q = SurfaceHeatFlux(Ts);
%
% Calculates surface heat flux to surface layer.
%
% Usage: Q (W/m2) is the net heat flux INTO the surface layer      
%        Ts is the current surface layer temperature
%
% Phil Gillibrand
% 7/08/2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE
% 01/06/2015 -- Lewis
%     Add a turbulent heat flux paramterisation that combines sensible and
%     latent heat fluxes into on value. This is because the Fairlall
%     parameteristaion is too complex for such a simple model. 
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Day
day = Param.day;
% Surface Temperature
Ts = D.T(1);
% Assign local variables
ur = Bdata.Uw(day);
z = Bdata.StHgt;
Ta = Bdata.Tair(day);
rh = Bdata.Relh(day);
Pa = Bdata.Mslp(day);
nc = Bdata.Clcover(day)/8; % divided by 8 to make fraction of 1
% Incident radiation
QI = Bdata.QHin(day);
% Latent and Sensible heat fluxes
A = hfbulktc(ur,z,Ta,z,rh,z,Pa,Ts);
% Sensible heat flux (W/m2) into the ocean
% QS = A(1);
% Haarpainter et al 2001 solar radiation after Markus. See methods chapter
r       = 7.5;           %Constant
b       = 237.3;         %Constant
So      = 1353;          %The sun constant in W/m2
albedo  = 0.1;          %Albedo of open water
psi     = 77.75;         %Latitude of the model in Degrees
k       = 1-0.6*(nc).^3;                     %Cloud correction term
vp      = (rh/100)*6.11.*10.^(r*Ta./(b+Ta));
d      =[];
d       = Param.day; 
if Param.day >365; 
d = Param.day - 365; 
end
i       = 23.44*cos((360/365)*(172-d)*pi/180)';
ts      = Param.t/day/60/60;                    %Sun hour = 2 hours behind local time
t       = (12-ts)*15;                          %Sun hour angle
%The suns zenith angle, z, cos(z) = sin(psi)*sin(i)+cos(psi)*cos(i)*cos(t);
cosz = sin(psi*pi/180).*sin(i*pi/180)+cos(psi*pi/180).*cos(i*pi/180).*cos(t);
%Only the positive zenith angles are used in the calculation of FS
coszp = zeros(size(cosz));
coszp(find(cosz>=0)) = cosz(find(cosz>=0));
Q0 = ((So.*coszp.^2)./(1.085.*coszp+(2.7+coszp).*vp*1e-3+0.1));
FS = (1-albedo)*k.*Q0;

%% Latent heat flux (W/m2) into the ocean
% QL = A(2);
% % Long-wave radiation
sigma = 5.7e-8;
Tskelv = Ts + 273;
Takelv = Ta + 273;
es   = 0.98;          %Sea surface emissivity
% Longwave raditaion(in Haarpaintner et al 2001
% I use the calculation for emissivity from Haarpaintner but use the 
% equation for longwave radiation described in the model
ea = 0.7829*(1+0.2232*(nc).^(2.75));
lw_up = 0.985 * sigma * (Tskelv ^ 4);
QB = lw_up * (0.39 - 0.05 * sqrt(ea)) * k;

%% Turbulent heat flux (in Haarpaintner et al 2001)
rho_air = 1.3;  % air density in kg-1 m^3
C       = 2.0e-3; % heat transfer coefficent 
Cp      = 1004;  % specific heat of air at constant pressue J-1 deg-1 kg-1

%% Sensible heat flux; do we need to include a latent heat term?
QT =rho_air*C*Cp*ur*(Ta - Ts); 

%% Net heat flux (W/m2) using Haarpaintner et al 2001
% Q =  QI + QT - QB;
Q =  FS + QT - QB;

end



