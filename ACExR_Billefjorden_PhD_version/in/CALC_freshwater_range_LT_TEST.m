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

test_range = [20e8];
Mplr = [1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5...
    2.6 2.7 2.8 2.9 3.0]'
for i=1:20;
QF(1:365,i) =  zeros(365,1);

d     = [1:1:length(136:300)] ;

const = [1:1:100000000];

total_discharge     = test_range*Mplr(i);

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

save QF_LT QF

