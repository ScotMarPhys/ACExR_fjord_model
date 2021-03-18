clear all; close all;
%% COMPUTE RAINFALL INTO FJORD
	% Read rainfall/discharge data
    m3rain          = ones(365,1);
	Qf_data         = dlmread('../in/Climatology_rainfall_2004_2063.csv',',',2,0);
	ncol            = size(Qf_data,2);
    rainfall        = Qf_data(1:365,5);
    m3rain          = rainfall * 190000000 / (1000 * 86400);
    
%% COMPUTE GLACIAL DISCHARGE INTO FJORD    
QF_mat              =   NaN(365,40);
QF                  =   zeros(365,1);
FW_change           =   [0:0.1:3]; % add 10% each year
exday               =   [2:2:80]; % add day extra melt season each year 

for i=1:length(FW_change);
QF                  =   zeros(365,1);
% 1.5% of total fjord volume  
% tmp                 = (149000000*(1.5+FW_change(i)));
% tmp                 = (149000000*1.5);
% isotope tiems 300 %
tmp                 = ((0.336*1e+09)*(3+FW_change(i)));
% tmp                 = (0.336*1e+09)*3;
% days to be distributed over
% d                   = [1:1:length(100-exday(i):270+exday(i))] ;
d                   = [1:1:length(100:300)] ;

const               = [7877586:1:18877590];

total_discharge     = tmp;

for ii = 1:length(const);
    
% distribute the water in a sine curve
% discharge           = (const(ii))*sin(d*pi/(270+exday(i)-(100-exday(i))+1));
        discharge = (const(ii))*sin(d*pi/201);
        q_discharge = discharge/(24*60*60);   
        if sum(discharge) > total_discharge;
            QF(100:300,1) = discharge/(24*60*60);
            break       
        end
end

QF                  = m3rain+QF;
QF_mat(:,i)         = QF;
clear QF
end

QF                  = QF_mat(:);

save QF_LOW QF QF_mat



