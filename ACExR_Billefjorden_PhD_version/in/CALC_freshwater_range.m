clear all; close all;
%COMPUTE RAINFALL INTO FJORD
	% Read rainfall/discharge data
    m3rain          = ones(365,1);
	Qf_data         = dlmread('../in/Climatology_rainfall_2004_2063.csv',',',2,0);
	ncol            = size(Qf_data,2);
    rainfall        = Qf_data(1:365,5);
    m3rain          = rainfall * 190000000 / (1000 * 86400);
    windowSize      = 28; 
    b               = (1/windowSize)*ones(1,windowSize);
    a               = 1;    
    m3rain          = filter(b,a,m3rain); 
%% COMPUTE GLACIAL DISCHARGE INTO FJORD    
QF_mat              =   NaN(365,40);
QF                  =   zeros(365,1);
FW_change           =   [0:0.1:3]; % add 10% each year
exday               =   [2:2:80]; % add day extra melt season each year 

test_range = [ 6e7 8e7 1.2e8 1.58e8 1.75e8 2.23e8 3.36e8 4e8 6e8 8e8 10e8 12e8 14e8 16e8 18e8 20e8 22e8 24e8];
for i=1:length(test_range);
QF(1:365,i) =  zeros(365,1);

d     = [1:1:length(136:300)] ;

const = [1:1:100000000];

total_discharge     = test_range(i);

for ii = 1:length(const);
        discharge = (const(ii))*sin(d*pi/165);
        q_discharge = discharge/(24*60*60);  
        
        if sum(discharge) > total_discharge;
            QF(136:300,i) = discharge/(24*60*60);
            break       
        end
end

QF(1:365,i)    = m3rain+QF(1:365,i);

end

save QFT QF

