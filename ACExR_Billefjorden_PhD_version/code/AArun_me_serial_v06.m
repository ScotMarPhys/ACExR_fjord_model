clear all
close all
%% Elapsed time is 117319.334966 seconds. for 1000-1050 millenium GKSS run
% v04: 18.12.2009: updated values for kz12 and kz23.m used 50
% fcopy ('Entrain12_v01.m','Entrain12.m'); fcopy ('Entrain23_v01.m','Entrain23.m');
% fcopy ('kz12_50.m','kz12.m'); fcopy ('kz23_50.m','kz23.m'); %
%v05: the TS input data adjiusted to nothernmpore values, using  21.12.2009:
% .. \GKSS_data\read_GKSS\mk_1a_mat_GKSS_TS_interp.m
  fcopy ('Initialise002.m','Initialise.m');
% fcopy ('Initialise002.m','Initialise.m');

mkdir ( ['.\results\sunart_v06' ] )
global Ry
Ry = [];
%     Ry.yb0=1050; Ry.ye0=1100; % 18255 50 641571631.4228 700912254.2703 731214203.5499 463.3524 0 -62.392 1728
   %  Ry.yb0=1000;  Ry.ye0=1050;
      Ry.yb0=1000;  Ry.ye0=1050;
 Ry.dy=Ry.ye0-Ry.yb0;
          Ry.ny=1000/50;
%         Ry.ny=2;
          ny=Ry.ny;
 for iy=1:ny,...
         
          Ry.yb=Ry.yb0+(iy-1)*Ry.dy;
          Ry.ye=Ry.yb + Ry.dy;
          if Ry.yb == 1950, Ry.ye=1990; end
          
          Ry.fnm = [num2str(Ry.yb) '_' num2str(Ry.ye) ]; 
%         mkdir ( ['.\results\sunart_' Ry.fnm ] )
fcopy ('ACconfigure_GKSS_sunart_d365_serial.m','ACconfigure.m');
[ E, Sunart] = ACExR(Ry);
end;