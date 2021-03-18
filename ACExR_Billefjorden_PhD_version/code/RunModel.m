clear all;
close all;


%%
% mkdir ( ['..\results\METHODS_RUNS' ] )
% Global variables
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
LochData.fname= sprintf('CH8_test_14');
LochData.dir = ( ['..\results\'] );
% FF FORCING FILE
%%
% RUN
prompt = 'Do you want to run ACExR? Y/N [Y]: ';
str = input(prompt,'s');
if isempty(str)
    str = 'Y';
    ACExR;
end




