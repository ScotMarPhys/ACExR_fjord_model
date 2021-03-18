%% Statistics of model runs
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2010

load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2010/processed/Microcat/BF_2010_5511_p.mat
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2010/processed/sbe16plus/BF_2010_6472_p.mat
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2010/processed/sbe16plus/BF_2010_6101_p.mat
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2010/processed/sbe16plus/BF_2010_6066_p.mat

sbe_12m_2010     = BF_2010_6472_p;
sbe_18m_2010     = BF_2010_6066_p;
sbe_28m_2010     = BF_2010_6101_p;
mc_185m_2010     = BF_2010_5511_p;

%% 2011
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2011/processed/sbe16plus/d3_6472.mat
sbe_26m_2011     = d3_6472;
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2011/processed/Microcat/BF_2011_5509.mat
mc_16m_2011      = [mtime' raw_5509];
load ../../../Dropbox/Billefjorden_mooring/Billefjorden/BF_2011/processed/Microcat/BF_2011_5510.mat
mc_182m_2011     = [mtime' raw_5510];

%% FILTER
[b,a] = butter(4,0.001,'low');

%% DEEP DATA
Dtemp10 = mc_185m_2010(:,2); 
Dtemp10 = filtfilt(b,a,Dtemp10); 

Dtemp11 = mc_182m_2011(:,2); 
Dtemp11 = filtfilt(b,a,Dtemp11);

deep_obs = [ Dtemp10; Dtemp11];
deep_time = [ mc_185m_2010(:,1);mc_182m_2011(:,1)];

%% INTERMEDIATE DATA

Itemp10 = sbe_28m_2010(:,2); 
Itemp10= filtfilt(b,a,Itemp10);   

Itemp11 = sbe_26m_2011(:,2);
Itemp11 = filtfilt(b,a,Itemp11); 

int_obs = [ Itemp10; Itemp11];
int_time = [sbe_28m_2010(:,1);sbe_26m_2011(:,1)];

%% SURFACE DATA

Stemp10 = sbe_18m_2010(:,2); 
Stemp10 = filtfilt(b,a,Stemp10);

Stemp11 = mc_16m_2011(:,2); 
Stemp11 = filtfilt(b,a,Stemp11);


surf_obs = [Stemp10; Stemp11];
surf_time = [sbe_18m_2010(:,1);mc_16m_2011(:,1)];

%% Interpolation

obs_T = NaN(365,3);
obs_S = NaN(365,3);

startt = datenum(1,1,2011);
endt   = datenum(31,12,2012);

