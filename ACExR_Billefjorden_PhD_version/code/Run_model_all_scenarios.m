clear all;
close all;

%% AIR TEMP HIGH
global LochData SillData Hypso Bdata Const D E Param 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise arrays
LochData = [];
SillData = [];
Hypso = [];
Bdata = [];
Const = [];
D = [];
E = [];
Param = [];

%% results filename        
LochData.fname= sprintf('CH7_LT_FW_HIGH');
LochData.dir = ( ['..\results\'] );
% Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_MASTER_HIGH.csv';
% FF FORCING FILE
    ACExR;

%%
% clear all;
% close all;
% 
% 
% %% AIR TEMP LOW
% global LochData SillData Hypso Bdata Const D E Param 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Initialise arrays
% LochData = [];
% SillData = [];
% Hypso = [];
% Bdata = [];
% Const = [];
% D = [];
% E = [];
% Param = [];
% 
% %% results filename        
% LochData.fname= sprintf('CH7_LT_AIR_LOW');
% LochData.dir = ( ['..\results\'] );
% Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_MASTER_LOW.csv';
% % FF FORCING FILE
%     ACExR;
