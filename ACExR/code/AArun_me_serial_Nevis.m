clear all
close all
global Ry
Ry = [];
       Ry.res_dir=['./results/Eriboll/' ];

mkdir (Ry.res_dir);
mkdir (Ry.out_dir);

      Ry.yb0=1970;   Ry.ye0=1971;
      Ry.dy = Ry.ye0-Ry.yb0;
      Ry.ny = 1;
         ny = Ry.ny;
 for iy=1:ny,...
          Ry.yb=Ry.yb0+(iy-1)*Ry.dy;
          Ry.ye=Ry.yb + Ry.dy;
%         if Ry.yb == 2000, Ry.ye=2011; end
          Ry.fnm = [num2str(Ry.yb) '_' num2str(Ry.ye) ];

%% fcopy('acconfigure_eribol_climatology.m','ACconfigure.m');
%% !copy acconfigure_eriboll_climatology.m ACconfigure.m
   !copy acconfigure_nevis_climatology.m ACconfigure.m
        ACExR
%% =========
% Prepare output file
 %% =========

 close all;
fclose all;
end; %iy
close all;
fclose all;

%% Elapsed time  for eriball is 233.303217 seconds.