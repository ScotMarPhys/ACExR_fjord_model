clear all;
infile  = 'Climatology_heatflux_2012_2063_MASTER.csv';
fuldata = dlmread(infile,',',1,0);

% years in column 1, Tair in column 7
% Number of years
yrs         = unique(fuldata(:,1));
yr_rnge     = [min(min(yrs)):1:max(max(yrs))];

% low impact change - air temperature
temp_change = [0.1:0.1:1*(max(max(yrs-2000)/10))] 

% update the dataset with LOW impact increase
for i = 1:length(yrs)
    [ids idx] = find(fuldata(:,1)==yr_rnge(i));
    fuldata(ids,7) = fuldata(ids,7)+temp_change(i);
end

% HEADER = [{'Year'},{'Month'},{'Day'},{'Daynumber'},{'WindSpeed'},...
%     {'Pressure'},{'Mean_Temp'},{'Relative Humidity'},...
%     {'Cloud Cover'},{'Irradiation'},{'FDD'},{'FDD_ald'}];
HEADER = [0,0,0,0,0,...
    0,0,0,...
    0,0,0,0];
dlmwrite('Climatology_heatflux_Longyearbyen_2012_2063_MASTER_LOW.csv',...
    HEADER,'delimiter',',');

dlmwrite('Climatology_heatflux_Longyearbyen_2012_2063_MASTER_LOW.csv',...
    fuldata,'-append',...
'delimiter',',')
%%
clear all;
infile  = '../in/Climatology_heatflux_2012_2063_MASTER.csv';
fuldata = dlmread(infile,',',1,0);

% years in column 1, Tair in column 7
% Number of years
yrs         = unique(fuldata(:,1));
yr_rnge     = [min(min(yrs)):1:max(max(yrs))];

% high impact change - air temperature
temp_change = [0.13:0.13:1.3*(max(max(yrs-2000)/10))] 

% update the dataset with HIGH impact increase
for i = 1:length(yrs)
    [ids idx] = find(fuldata(:,1)==yr_rnge(i));
    fuldata(ids,7) = fuldata(ids,7)+temp_change(i);
end

HEADER = ['Year','Month','Day','Daynumber','WindSpeed',...
    'Pressure','Mean_Temp','Relative Humidity',...
    'Cloud Cover','Irradiation','FDD','FDD_ald'];
HEADER = [0,0,0,0,0,...
    0,0,0,...
    0,0,0,0];
dlmwrite('Climatology_heatflux_Longyearbyen_2012_2063_MASTER_HIGH.csv',...
    HEADER,'delimiter',',');

dlmwrite('Climatology_heatflux_Longyearbyen_2012_2063_MASTER_HIGH.csv',...
    fuldata,'-append',...
'delimiter',',')
