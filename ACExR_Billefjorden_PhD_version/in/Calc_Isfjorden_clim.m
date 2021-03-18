clear all; close all;

% load data
load('ctd_Isfjorden_2010_2015.mat');
%% information on profiles per month
[Y,M,D]  = datevec(ctd.date);
ind_month = datenum(Y,M,D);
uni_prof = unique(ind_month, 'stable') ;
[~,M,~] = datevec(uni_prof);
m_actual = [4 9 4 9 4 5 9 10 4 8 9 10 8 9 10 1 ...
    9 10 9 4 7 6 8 9 10 5 1 2 3 4 5 6 7 8 10 12 ...
    11 9 4 5 6 7 8 10 12 4 1 2 3 4 5 6 7 8 9 10 ...
    11 12 2 4 5 6 7 8 9 10 11 1 3 4 6 7 8 9 10 7 ...
    10 7 11 3 7 8 11 3 4 5 8 11 12 10 7 11 12 8 1 8 9 8 9]

figure(1); svenme = ['IF_CTD_HISTOGRAM'];
H = categorical(m_actual,[1 2 3 4 5 6 7 8 9 10 11 12],{'Jan','Feb','Mar','Apr',...
    'May','Jun','Jul','Aug',...
    'Sep','Oct','Nov','Dec'});
AX(1) = histogram(H)
ylabel('Number of profiles');
xlabel('Month');
figureHandle = gcf; 
set(gcf,'pos',[1          41        1600        1084],'color','w');
set(findall(figureHandle,'type','text'),'color','k',...
    'fontSize',20);
set(findall(figureHandle,'type','axes'),...
    'fontSize',20);
export_fig(['../../Writing/Thesis/Figures/',svenme,'.pdf']) 

%%
% convert to day-month
tmp = cellstr(datestr(ctd.date,'mmm'));

% convert to new mat time
% new_date = datenum(tmp);

% find the days that had CTDs
uni_date = unique(tmp, 'stable') ;

% create a matrix of nans to populatye with data
date 	= NaN(500,length(uni_date));
sal     = NaN(500,length(uni_date));
depth   = NaN(500,length(uni_date));
temp    = NaN(500,length(uni_date));

for i = 1:length(uni_date);
   [ids,idx] = find(strcmp([tmp], uni_date(i)));
  
   
        sal(1:length(ids),i)    = ctd.S(ids);
        temp(1:length(ids),i)   = ctd.T(ids);
        depth(1:length(ids),i)  = ctd.depth(ids);
        date(1:length(ids),i)   = ctd.date(ids);

end

% just need one day per profile
date = date(1,:);

% sort into date order
tmp = datestr(date,'dd-mmm');
date = datenum(tmp);
date = date';
[idx,ids] = sort(date);
date = date(ids);
temp = temp(:,ids);
sal  = sal(:,ids);
depth= depth(:,ids);

% sort data and index by depth
for c = 1:12
    
 [id,ic] = sort(depth(:,c));   
 
 temp(:,c)  = temp(ic,c);
 dep(:,c)  = depth(ic,c);
 sal(:,c)  = sal(ic,c);

end


% find rows that are all nans
[idx, ids] = find(~any(~isnan(temp), 2) ==1);

% remove nans
temp(idx,:) = [];
sal(idx,:) = [];
dep(idx,:) = [];

%% match each by depth and make into  mothly profiles
tmp = max(max(depth));

% create a temporary matrix of nans
D = NaN(500,length(uni_date));
S = NaN(500,length(uni_date));
T = NaN(500,length(uni_date));

v = 80; %value to find
    
for cc = 1:length(uni_date);
    
%     then get the duplicate depths
    dup_deps = unique(dep(:,cc), 'stable') ;
    
    for ccc = 1:length(dup_deps);
        
        [idx ids]= find(dep(:,cc)==dup_deps(ccc));
        
        D(ccc,cc) = nanmean(dep(idx,cc));
        S(ccc,cc) = nanmean(sal(idx,cc));
        T(ccc,cc) = nanmean(temp(idx,cc));
    
    end 
    
    % find index of closest value to 80
    tmp = abs(D(:,cc)-50);
    [id id] = min(tmp); %index of closest value
    
    tmp = abs(D(:,cc)-200);
    [idk idf] = min(tmp); %index of closest value
    
    surf_temp(cc) = nanmean(T(1:id,cc));
    surf_temp_std(cc) = nanstd(T(1:id,cc));
    int_temp(cc)  = nanmean(T(id:end,cc));
    int_temp_std(cc)  = nanstd(T(id:end,cc));

    
    surf_sal(cc) = nanmean(S(1:id,cc));
    surf_sal_std(cc) = nanstd(S(1:id,cc));

    int_sal(cc)  = nanmean(S(id:end,cc));
    int_sal_std(cc)  = nanstd(S(id:end,cc));


end

surf_temp = surf_temp';
int_temp  = int_temp';
surf_temp_std = surf_temp_std'
int_temp_std = int_temp_std'

surf_sal = surf_sal';
int_sal  = int_sal';
surf_sal_std = surf_sal_std'
int_sal_std = int_sal_std'

%% plot mean values and std

figure(2);figureHandle = gcf; 
set(gcf,'pos',[1          41        1600        1084],'color','w');
set(findall(figureHandle,'type','text'),'color','k',...
    'fontSize',20);
set(findall(figureHandle,'type','axes'),...
    'fontSize',20);
date_range = datenum({'01-Jan-2015','15-Feb-2015','15-Mar-2015','15-Apr-2015',...
    '15-May-2015','15-Jun-2015','15-Jul-2015','15-Aug-2015',...
    '15-Sep-2015','15-Oct-2015','15-Nov-2015','31-Dec-2015'})
positionVector = [0.2, 0.6, 0.6, 0.3];
AX(1) = subplot('Position',positionVector);
h1 = plot(date_range,int_sal,'-sk')
hold on
h2 = plot(date_range,int_sal+int_sal_std,':sk')
hold on
h3 = plot(date_range,int_sal-int_sal_std,':sk')
hold on
h4 = plot(date_range,surf_sal,'-sb')
hold on
h5 = plot(date_range,surf_sal+surf_sal_std,':sb')
hold on
h6 = plot(date_range,surf_sal-surf_sal_std,':sb')
datetick(gca,'x','mmm','keepticks')
ylabel('S_E');
axis tight; grid on

positionVector = [0.2, 0.1, 0.6, 0.3];
AX(2) = subplot('Position',positionVector);
h1 = plot(date_range,int_temp,'-sk')
hold on
h2 = plot(date_range,int_temp+int_temp_std,':sk')
hold on
h3 = plot(date_range,int_temp-int_temp_std,':sk')
hold on
h4 = plot(date_range,surf_temp,'-sb')
hold on
h5 = plot(date_range,surf_temp+surf_temp_std,':sb')
hold on
h6 = plot(date_range,surf_temp-surf_temp_std,':sb')
datetick(gca,'x','mmm','keepticks')
ylabel('T_E');
axis tight; grid on
svenme = ['IF_mean_std_CTD'];
export_fig(['../../Writing/Thesis/Figures/',svenme,'.pdf']) 

%% interpolate data into daily values across year
startdate = datenum('01-Jan-2015');
enddate   = datenum('31-dec-2015');
int_int = ([startdate:1:enddate])';



% creat matrix to store values
sal_int_1     = NaN(length(int_int),2);
temp_int_1    = NaN(length(int_int),2);

sal_int_1(1:length(int_int),1) = interp1(date_range,surf_sal,int_int,'spline');
sal_int_1(1:length(int_int),2) = interp1(date_range,int_sal,int_int,'spline');

temp_int_1(1:length(int_int),1) = interp1(date_range,surf_temp,int_int,'spline');
temp_int_1(1:length(int_int),2) = interp1(date_range,int_temp,int_int,'spline');


cd ..\code
save IF_BNDRY_CLIM surf_temp int_temp  surf_temp_std...
    int_temp_std surf_sal int_sal surf_sal_std int_sal_std temp_int_1 sal_int_1

clear all

load IF_BNDRY_CLIM.mat
%% combine with ISA data

load ISA.mat;

[Y,M,D]  = datevec(date);
T(find(T==0)) = NaN;
S(find(S==0)) = NaN;
PR(find(PR==0)) = NaN;
TEMP = nan(91,12);
for ii = 1:12;
    [id,ids] = find(M==ii);
    tmp = nanmean(S(:,ids),2);
    SAL(1:length(tmp),ii) = tmp;
    
    tmp = nanmean(S(:,ids),2);
    SAL(1:length(tmp),ii) = tmp;    
end
for cc = 1:12;

    % find index of closest value to 80
    tmp = abs(PR(:,cc)-50);
    [id id] = min(tmp); %index of closest value

    
    surf_tempISA(cc) = nanmean(T(1:id,cc));
    surf_tempISA_std(cc) = nanstd(T(1:id,cc));
    int_tempISA(cc)  = nanmean(T(id:end,cc));
    int_tempISA_std(cc)  = nanstd(T(id:end,cc));

    
    surf_salISA(cc) = nanmean(S(1:id,cc));
    surf_salISA_std(cc) = nanstd(S(1:id,cc));
    int_salISA(cc)  = nanmean(S(id:end,cc));
    int_salISA_std(cc)  = nanstd(S(id:end,cc));

end

surf_tempISA = surf_tempISA';
int_tempISA  = int_tempISA';
surf_tempISA_std = surf_tempISA_std';
int_tempISA_std = int_tempISA_std';

surf_salISA = surf_salISA';
int_salISA  = int_salISA';
surf_salISA_std = surf_salISA_std';
int_salISA_std = int_salISA_std';


%%
figure(3);figureHandle = gcf; 
set(gcf,'pos',[1          41        1600        1084],'color','w');
set(findall(figureHandle,'type','text'),'color','k',...
    'fontSize',20);
set(findall(figureHandle,'type','axes'),...
    'fontSize',20);
date_range = datenum({'01-Jan-2015','15-Feb-2015','15-Mar-2015','15-Apr-2015',...
    '15-May-2015','15-Jun-2015','15-Jul-2015','15-Aug-2015',...
    '15-Sep-2015','15-Oct-2015','15-Nov-2015','31-Dec-2015'})
positionVector = [0.2, 0.6, 0.6, 0.3];
AX(1) = subplot('Position',positionVector);
h1 = plot(date_range,int_salISA,'-sk')
hold on
h2 = plot(date_range,int_salISA+int_salISA_std,':sk')
hold on
h3 = plot(date_range,int_salISA-int_salISA_std,':sk')
hold on
h4 = plot(date_range,surf_salISA,'-sb')
hold on
h5 = plot(date_range,surf_salISA+surf_salISA_std,':sb')
hold on
h6 = plot(date_range,surf_salISA-surf_salISA_std,':sb')
datetick(gca,'x','mmm','keepticks')
ylabel('S_E');
axis tight; grid on

positionVector = [0.2, 0.1, 0.6, 0.3];
AX(2) = subplot('Position',positionVector);
h1 = plot(date_range,int_tempISA,'-sk')
hold on
h2 = plot(date_range,int_tempISA+int_tempISA_std,':sk')
hold on
h3 = plot(date_range,int_tempISA-int_tempISA_std,':sk')
hold on
h4 = plot(date_range,surf_tempISA,'-sb')
hold on
h5 = plot(date_range,surf_tempISA+surf_tempISA_std,':sb')
hold on
h6 = plot(date_range,surf_tempISA-surf_tempISA_std,':sb')
datetick(gca,'x','mmm','keepticks')
ylabel('T_E');
axis tight; grid on
svenme = ['ISA_mean_std_CTD'];
export_fig(['../../Writing/Thesis/Figures/',svenme,'.pdf']) 

%% COMBINE BOTH CIMATOLOGIES


CLIM_INT_SAL = nanmean([int_salISA int_sal],2);
CLIM_SURF_SAL = nanmean([surf_salISA surf_sal],2);

CLIM_INT_TEMP = nanmean([surf_tempISA surf_temp],2);
CLIM_SURF_TEMP = nanmean([int_tempISA int_temp],2);


figure(4); figureHandle = gcf; 
set(gcf,'pos',[1          41        1600        1084],'color','w');
set(findall(figureHandle,'type','text'),'color','k',...
    'fontSize',20);
set(findall(figureHandle,'type','axes'),...
    'fontSize',20);
date_range = datenum({'01-Jan-2015','15-Feb-2015','15-Mar-2015','15-Apr-2015',...
    '15-May-2015','15-Jun-2015','15-Jul-2015','15-Aug-2015',...
    '15-Sep-2015','15-Oct-2015','15-Nov-2015','31-Dec-2015'})

positionVector = [0.2, 0.6, 0.6, 0.3];
AX(1) = subplot('Position',positionVector);
h1 = plot(date_range,CLIM_SURF_SAL,':');
h1.Color = 'k';h1.LineWidth = 2;
hold on; 
h2 = plot(date_range,CLIM_INT_SAL,'-');
h2.Color = 'k';h7.LineWidth = 2;
datetick(gca,'x','mmm','keepticks')
ylabel('S_E');
axis tight; grid on
legend('Layer 1','Layer 2')

positionVector = [0.2, 0.1, 0.6, 0.3];
AX(2) = subplot('Position',positionVector);
h6 = plot(date_range,CLIM_SURF_TEMP,':');
h6.Color = 'k';h6.LineWidth = 2;
hold on; 
h7 = plot(date_range,CLIM_INT_TEMP,'-');
h7.Color = 'k';h7.LineWidth = 2;
datetick(gca,'x','mmm','keepticks')
ylabel('T_E');
axis tight; grid on
legend('Layer 1','Layer 2')
svenme = ['IF_MEAN_CLIM'];
export_fig(['../../Writing/Thesis/Figures/',svenme,'.pdf']) 
