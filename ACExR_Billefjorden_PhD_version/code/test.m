clear all; close all; 
load BF_TIMESERIES_08_13;
daystrt = datenum('1-1-2012');

idx = find(timeseries==daystrt);

start = 11;
fin   = 20;

% SET ARRAYS
RunNum = [start:1:fin];
rsq    = NaN(length(RunNum),6);
rmse   = NaN(length(RunNum),6);


%% SUBPLOTS

linecolors = parula(20);
linecolors = flipud(linecolors);

close all
figure(1)
for i =start:fin;

% STANDARD RUNS   
fname = sprintf(['mr_std_',num2str(i)]);
load(['../results/',fname]) 
svenme=sprintf('%s','linear_regression_std.pdf');
% AIR TEMP SIMULATIONS
% fname = sprintf(['air_tmp_',num2str(i)]);
% load(['../results/airtmp_runs/',fname]) 
% svenme=sprintf('%s','linear_regression_air.pdf');

strt = datenum('01-01-2009');
tmp = 1:Param.Ndays;
mtime_mdl = tmp+strt;

ids = find(mtime_mdl==daystrt);



figure(1);
positionVector1 = [0.05, 0.55, 0.25, 0.4];
AX(1) = subplot('Position',positionVector1);
h(i) =  plot(Param.S(ids:ids+365,1),L1_SAL(idx:idx+365),'+k');
h(i).Color = linecolors(i,:);h(i).MarkerSize = 3;
AX(1).XLim = [31 34.9];
AX(1).YLim = [31 34.9];
hold on
lm1s = fitlm(Param.S(ids:ids+365,1),L1_SAL(idx:idx+365));
legendInfo{i,1} = ['R^2 = ',num2str(lm1s.Rsquared.ordinary)];

end