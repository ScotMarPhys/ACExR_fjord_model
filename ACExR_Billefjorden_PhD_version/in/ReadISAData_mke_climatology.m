clear all; close all; clc

load ..\in\ISA.mat; whos 

% 93 records of profiles (max depth 91m)
ISA_mat = nan(length(PR(:,1)),8);
ISA_mat = repmat(ISA_mat,[93,1]);

% keep all data
fileout = ['ISA_clim_121314.csv'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNCOMMENT TO EXCLUDE LAST YEAR OF DATA
fileout = ['ISA_clim_1213.csv'];
tmp = date(1);
tmp = (tmp+(365*2)); 
val = abs(date-tmp);
[id id] = min(val)

date    = date(:,1:id);
PR   	= PR(:,1:id);
T       = T(:,1:id);
S       = S(:,1:id);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get year month day
[Y, M, D] =datevec(date);

% make zeros NANS
T(find(T==0)) = NaN;

% months of the year
mnth = 1:12;

tmp_temp = NaN(length(PR(:,1)),12);
tmp_sal  = NaN(length(PR(:,1)),12);
tmp_mnth = NaN(length(PR(:,1)),12);
tmp_pr = NaN(length(PR(:,1)),12);
std_temp = NaN(length(PR(:,1)),12);
std_sal = NaN(length(PR(:,1)),12);

for ii = 1:length(mnth);

    [idx ids]        = find(M==mnth(ii));
    tmp_temp(:,ii)   = nanmean(T(:,ids),2);
    tmp_sal (:,ii)   = nanmean(S(:,ids),2);
    std_temp(:,ii)   = std(T(:,ids),0,2,'omitnan');
    std_sal (:,ii)   = std(S(:,ids),0,2,'omitnan');
    tmp_mnth(:,ii)   = mnth(ii);
    tmp_pr (:,ii)   = nanmean(PR(:,ids),2);

end

temp = tmp_temp(:);
sal  = tmp_sal(:);
mnth = tmp_mnth(:);
pr   = tmp_pr(:);



ISA_mat(:,1) = -13.2;
ISA_mat(:,2) = 78.5;
ISA_mat(:,3) = 0 ;
ISA_mat(1:length(mnth),4) = mnth ;
ISA_mat(:,5) = 15 ;
ISA_mat(1:length(mnth),6) = pr ;
ISA_mat(1:length(mnth),7) = temp ;
ISA_mat(1:length(mnth),8) = sal ;

ISA_mat(any(isnan(ISA_mat),2),:)=[];

HEADER = [0, 0, 0, 0, 0, 0, 0, 0];
dataout = [HEADER; ISA_mat];

dlmwrite(fileout,dataout,'delimiter',',','precision','%7.1f');


%% MAKE INTO READABLE BOUNDARY DATA

% how many years for data
yr_rng = [2005:1:2065];
yrs    = length(yr_rng);
tmp    = length(ISA_mat(:,1));
tmp_yr = NaN(tmp,yrs);
% make arrays
depth   = NaN(365*yrs,1);
year    = NaN(365*yrs,1);
month   = NaN(365*yrs,1);
day     = NaN(365*yrs,1);
T       = NaN(365*yrs,1);
S       = NaN(365*yrs,1);

% populate arrays
for ii = 1:length(yr_rng)
   tmp_yr(:,ii) = repmat(yr_rng(ii),tmp,1);
end

depth   = repmat(ISA_mat(:,6),yrs,1);
year    = tmp_yr(:);
month   = repmat(ISA_mat(:,4),yrs,1);
day     = repmat(ISA_mat(:,5),yrs,1);
T       = repmat(ISA_mat(:,7),yrs,1);
S       = repmat(ISA_mat(:,8),yrs,1);

save ISA_2005_2065_ex14 depth year month day T S

clear depth year month day T S 

%% AND FOR ONE SD
temp = std_temp(:)+ tmp_temp(:) ;
sal  = std_sal(:) +tmp_sal(:);
mnth = tmp_mnth(:);
pr   = tmp_pr(:);

ISA_mat(:,1) = -13.2;
ISA_mat(:,2) = 78.5;
ISA_mat(:,3) = 0 ;
ISA_mat(1:length(mnth),4) = mnth ;
ISA_mat(:,5) = 15 ;
ISA_mat(1:length(mnth),6) = pr ;
ISA_mat(1:length(mnth),7) = temp ;
ISA_mat(1:length(mnth),8) = sal ;

ISA_mat(any(isnan(ISA_mat),2),:)=[];

HEADER = [0, 0, 0, 0, 0, 0, 0, 0];
dataout = [HEADER; ISA_mat];

dlmwrite(fileout,dataout,'delimiter',',','precision','%7.1f');


%% MAKE INTO READABLE BOUNDARY DATA

% how many years for data
yr_rng = [2005:1:2065];
yrs    = length(yr_rng);
tmp    = length(ISA_mat(:,1));
tmp_yr = NaN(tmp,yrs);
% make arrays
depth   = NaN(365*yrs,1);
year    = NaN(365*yrs,1);
month   = NaN(365*yrs,1);
day     = NaN(365*yrs,1);
T       = NaN(365*yrs,1);
S       = NaN(365*yrs,1);

% populate arrays
for ii = 1:length(yr_rng)
   tmp_yr(:,ii) = repmat(yr_rng(ii),tmp,1);
end

depth   = repmat(ISA_mat(:,6),yrs,1);
year    = tmp_yr(:);
month   = repmat(ISA_mat(:,4),yrs,1);
day     = repmat(ISA_mat(:,5),yrs,1);
T       = repmat(ISA_mat(:,7),yrs,1);
S       = repmat(ISA_mat(:,8),yrs,1);

save ISA_2005_2065_ex14_sdpos depth year month day T S

clear depth year month day T S 

%% AND FOR ONE SD
temp = tmp_temp(:)-std_temp(:) ;
sal  = tmp_sal(:)-std_sal(:) ;
mnth = tmp_mnth(:);
pr   = tmp_pr(:);

ISA_mat(:,1) = -13.2;
ISA_mat(:,2) = 78.5;
ISA_mat(:,3) = 0 ;
ISA_mat(1:length(mnth),4) = mnth ;
ISA_mat(:,5) = 15 ;
ISA_mat(1:length(mnth),6) = pr ;
ISA_mat(1:length(mnth),7) = temp ;
ISA_mat(1:length(mnth),8) = sal ;

ISA_mat(any(isnan(ISA_mat),2),:)=[];

HEADER = [0, 0, 0, 0, 0, 0, 0, 0];
dataout = [HEADER; ISA_mat];

dlmwrite(fileout,dataout,'delimiter',',','precision','%7.1f');


%% MAKE INTO READABLE BOUNDARY DATA

% how many years for data
yr_rng = [2005:1:2065];
yrs    = length(yr_rng);
tmp    = length(ISA_mat(:,1));
tmp_yr = NaN(tmp,yrs);
% make arrays
depth   = NaN(365*yrs,1);
year    = NaN(365*yrs,1);
month   = NaN(365*yrs,1);
day     = NaN(365*yrs,1);
T       = NaN(365*yrs,1);
S       = NaN(365*yrs,1);

% populate arrays
for ii = 1:length(yr_rng)
   tmp_yr(:,ii) = repmat(yr_rng(ii),tmp,1);
end

depth   = repmat(ISA_mat(:,6),yrs,1);
year    = tmp_yr(:);
month   = repmat(ISA_mat(:,4),yrs,1);
day     = repmat(ISA_mat(:,5),yrs,1);
T       = repmat(ISA_mat(:,7),yrs,1);
S       = repmat(ISA_mat(:,8),yrs,1);

save ISA_2005_2065_ex14_sdneg depth year month day T S


