% NEED TO RUN TO START WITH HOTSTART FILE, THUS ALL RUNS STRAT AT SAME
% CONDITIONS
% populate set of arrays of free parameters
clear all;

mkdir ( ['..\results\test_change2' ] )
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

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063.csv';
Bdata.OB_file = '../in/ISA_2005_2065_ex14';
Bdata.F_file = '../in/QF';
for i =1
LochData.fname= sprintf(['L_1',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_LOW.csv';
Bdata.OB_file = '../in/ISA_2005_2065_ex14';
Bdata.F_file = '../in/QF';
for i =1
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_HIGH.csv';
Bdata.OB_file = '../in/ISA_2005_2065_ex14';
Bdata.F_file = '../in/QF';
for i =2
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF';
for i =3
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_LOW.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF';
for i =4
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_HIGH.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF';
for i =5
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_LOW.csv';
Bdata.OB_file = '../in/ISA_2012_2065_HIGH';
Bdata.F_file = '../in/QF';
for i =6
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_HIGH.csv';
Bdata.OB_file = '../in/ISA_2012_2065_HIGH';
Bdata.F_file = '../in/QF';
for i =7
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063.csv';
Bdata.OB_file = '../in/ISA_2005_2065_ex14';
Bdata.F_file = '../in/QF_LOW';
for i =8
LochData.fname= sprintf(['L_1',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063.csv';
Bdata.OB_file = '../in/ISA_2005_2065_ex14';
Bdata.F_file = '../in/QF_LOW_EXTSEASON';
for i =9
LochData.fname= sprintf(['L_1',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_LOW.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF_LOW';
for i =10
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_LOW.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF_LOW_EXTSEASON';
for i =11
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

Bdata.SHF_file = '../in/Climatology_heatflux_Longyearbyen_2012_2063_HIGH.csv';
Bdata.OB_file = '../in/ISA_2012_2065_LOW';
Bdata.F_file = '../in/QF_LOW';
for i =12
LochData.fname= sprintf(['L_',num2str(i)]);
LochData.dir = ( ['..\results\test_change2' ] )
ACExR_LT;
end

