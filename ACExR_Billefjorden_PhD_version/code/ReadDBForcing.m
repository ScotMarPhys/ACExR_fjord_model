function ReadDBForcing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function = ReadDBForcing;
%
% Reads boundary forcing data for 'loch' from 
% database sources e.g. daily wind speed, daily rainfall/
%    river flow, coastal density profile
% Assumes daily values of data over 1 year.
%
% Usage:    LochData contains the catalogue data.
%           Bdata is a structured array containing 
%                   boundary data.
%
% Phil Gillibrand
% 14/3/2006 
% change log (Lewis):
% 19/06/2015 Change the way the code finds forcing data by using ismember
% to find the year (e.g. line 52/3 and subsequent iterations)
% 20/07/2015 Chenge the way the forcing data is extarcted. Now ratrher than
% picking just one year I set the code to take all data from the year start
% to the end. 
% 20/07/2015 change to the wrapping code. in order to increase resolution
% of profiles I take the last value fo prof_daya nd add 15.
% IMPROTANT NOTE ON FORCING. This is now set up to take full datasets
% including year. This way the data will be read from the first year noted
% in ACconfigure.m and run from that year onwards.
% 22/07/2015 Wet bulb temperature is no longer used and so is removed from
% the data set and the loop. Look towards older versions of the model for
% the inclusion of this variable. Dew point has also been removed
% (commented out) as I can't find anywhere it is used.
% 22/07/2015 Changed the way CTD is read. Now reads all data available from
% the start year. Also the data is extended using the last value + some
% number rather than an absolute number. Look for cmoparisons withe the old
% model to see changes
% 30/08/2016 made changes to the freshwater input based on annual discharge
% that is then dsitributed during summer only.
% 26/09/2016
% Commented out line increasing spin up of Bdata.Texternal and s sexternal
% line 335 and 336
% 01/11/2016 The wind data is smoothed with a buttrworth filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');
disp('Reading boundary forcing data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set simulation length
Ndays = Param.Ndays + Param.ndays_spin_up;
ndays_spin_up = Param.ndays_spin_up;
Param.Ndays = Ndays;
ny = ceil(Param.Ndays/365); 
sy = ceil(ndays_spin_up/365); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read freshwater input data.
% if Bdata.Qf_switch = 1, use rainfall data and convert to runoff
% if Bdata.Qf_switch = 2, use riverflow data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set default
Bdata.Qf = LochData.Qf * ones(Param.Ndays,1);

if Param.QfData > 0
    % Read rainfall/discharge data
	Qf_data = dlmread(Bdata.Qf_file,',',2,0);
	ncol = size(Qf_data,2);

	% Select data for required year
        yyyy = Qf_data(:,1);
        tmp = ismember(yyyy,Param.Year);
        iyr=find(tmp);
%         iyr = yyyy == Param.Year;
        if yyyy == 0
        yyyy = yyyy + Param.Year;
        elseif length(iyr) == 0
        disp('ERROR: Mis-match between open boundary data and specified simulation year')
        return
        end
    % READ ALL DATA FROM START OF YEAR
% 	Bdata.Qf = Qf_data(iyr,Date_cols+icol_Qf);
	Bdata.Qf = Qf_data(iyr(1):end,5); % 
    
	if Param.QfData == 1
	    % Convert from (mm/day) to river flow (m3/s) assuming conversion 
	    % of 70% of rainfall into river discharge.
	    rainfall = Bdata.Qf;
        % Bdata.Qf = 0.7 * rainfall * LochData.Wshed / (1000 * 86400);
        Bdata.Qf =   1 * rainfall * LochData.Wshed / (1000 * 86400);
	    % Apply a 3-day smoothing filter
	    a = 1;
	    b = ones(3,1)/3;
	    qff = filter(b,a,Bdata.Qf);
	    Bdata.Qf = qff;
	    % Add direct rainfall onto the water surface
	    Bdata.Qf = Bdata.Qf + rainfall * Hypso.A(1) / (1000 * 86400);
    elseif Param.QfData == 2
         rainfall = Bdata.Qf;
         Bdata.Qf = rainfall(1:365) * Hypso.A(1) / (1000 * 86400);
        % convert from km3/yr to m3/s
        % BLOCK CONVERSION
        %         tmp  = ((149000000/(120*24*60*60))*1.5); %from Nilsen, 1% of total fjord volume
        %         tmpr = (149000000/2)/(120*24*60*60); %sea ice melt 0.5% of fjord water volume
        %         tmp  = tmp + tmpr;
        %         tmp  = repmat(tmp,1,120);
        %         QF(121:240,1) = tmp;

        % SINE CONVERSION
        % Calculate and distribute discharge over the summer period in a 
        % sine shape
        QF=zeros(365,1);
        % rainfall across drainage area  
        tmp  = (0.175*1e+09);
        tmp = (0.336*1e+09)*2;
          % 0.336km3 - average from delta 18O
        tmp = (0.336*1e+09)*3;
        
        % days to be distributed over
        d = [1:1:length(100:300)] ;
        
        const = [7877586:1:7877590];
                
        total_discharge = tmp;

        for ii = 1:length(const);
        % distribute the water in a sine curve
        discharge = (const(ii))*sin(d*pi/201);
        q_discharge = discharge/(24*60*60);   
        if sum(discharge) > total_discharge;
            QF(100:300,1) = discharge/(24*60*60);
            break       
        end
        end

        QF = QF;

        Bdata.Qf = Bdata.Qf + QF;
        
    elseif Param.QfData == 3
         
         rainfall = Bdata.Qf;
         Bdata.Qf = rainfall * Hypso.A(1) / (1000 * 86400);
         
        Bdata.F_file = '../in/QF';
        load(Bdata.F_file);
        nyear = ceil(length(Bdata.Qf)/365);
        Bdata.F = repmat(QF(:,16),nyear,1);
        Bdata.Qf = Bdata.F +Bdata.Qf;
        
        % for LT scenario
%         Bdata.F_file = '../in/QF_LT';
%         load(Bdata.F_file);
%         nyear = ceil(length(Bdata.Qf)/365);
%         Bdata.F = QF(:);
%         Bdata.Qf = Bdata.F +Bdata.Qf(1:7300);
	end

	% Add spin-up period to data
	Bdata.Qf = [repmat(Bdata.Qf(1:365),sy,1); Bdata.Qf];
    % extend the forcing to include all years
%     Bdata.Qf = repmat(Bdata.Qf,ny,1);
    % Constrain excessively low flows to prevent model instability
	Bdata.Qf(Bdata.Qf < 1) = 1; 
    

    % If data record is shorter than simulation length, extend record using
    % final data value.
    if length(Bdata.Qf) < Param.Ndays
        Bdata.Qf(end:Param.Ndays) = Bdata.Qf(end);
    end
    
% 	% Read and print header line
% 	fid = fopen(Bdata.Qf_file);
% 	format = repmat('%s',1,ncol);
% 	header = textscan(fid,format,1,'delimiter',',');
% 	Source = header{1,Date_cols+icol_Qf};
% 	fclose(fid);
% 	disp(['Freshwater discharge data from ',Source{1,1}]);
else
    disp(['Default freshwater discharge = ',num2str(LochData.Qf), ...
        ' cumecs']);

end

% Print river tracer loads
if Param.Ntracer > 0
    C1tmp = LochData.QC1 * 365 * 86400 / 1000;
    disp(['Riverine loading (C1) = ',num2str(C1tmp,'%10.2f'),' tonnes/yr']);
end
if Param.Ntracer > 1
    C2tmp = LochData.QC2 * 365 * 86400 / 1000;
    disp(['Riverine loading (C2) = ',num2str(C2tmp,'%10.2f'),' tonnes/yr']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read wind speed input data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set default
Bdata.Uw = zeros(Param.Ndays,1);

if Param.WindData > 0

    % Read wind speed data
	WS_data = dlmread(Bdata.Wind_file,',',1,0);
	ncol = size(WS_data,2);
	yyyy = WS_data(:,1);
    tmp = ismember(yyyy,Param.Year);
    iyr=find(tmp);
% 	iyr = yyyy == Param.Year;
    if yyyy == 0
        yyyy = yyyy + Param.Year;
    elseif length(iyr) == 0
        disp('ERROR: Mis-match between open boundary data and specified simulation year')
        return
    end
% Make the forcing data from the start year to the end fo the data set.
    Bdata.Uw = WS_data(iyr(1):end,5);
%     [b,a] = butter(4,0.01,'low');           % IIR filter design
%     Bdata.Uw = filtfilt(b,a,Bdata.Uw);  
	Ndays = length(Bdata.Uw);
    Ndays=Param.Ndays;
	% Add spin-up period to data
%      Bdata.Uw = repmat(Bdata.Uw,ny,1);

	% Add spin-up period to data
	Bdata.Uw = [repmat(Bdata.Uw(1:365),sy,1); Bdata.Uw];    
    % If data record is shorter than simulation length, extend record using
    % final data value.
    if length(Bdata.Uw) < Param.Ndays
        Bdata.Uw(end:Param.Ndays) = Bdata.Uw(end);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specify coastal salinity and density profiles
% Data from data file, interpolated to 1m depth intervals.
% Now, due to incorrect terminology usage by Phil and I, what you need to do is to set (in the model)
% Define the expansion coefficients
Const.alpha = 0.019;
% saline contraction coefficient
Const.beta = 0.81;
% Reference density
Const.rho0 = 1025.6;

if Param.OBdata == 1
% 	disp(['Loading ocean boundary data from ',Bdata.OB_file]);
% 	format = '%n %n %n %n %n %n %n %n%*[^\n]';
% 	[lon,lat,year,month,day,depth,T,S] = ...
% 	    textread(Bdata.OB_file,format, ...
%              	'delimiter',',','headerlines',1);
% USE MAT FILE
    infile =(Bdata.OB_file);
    load(infile);
       
    id = find(year == Param.Year); % LEWIS CHANGE
    if year == 0
%          year = year + Param.Year; % ORIGINAL CODE
        year = year + Param.Year(1);% LEWIS CHANGE
        
    elseif length(id) == 0
        disp('ERROR: Mis-match between open boundary data and specified simulation year')
        return
%             year=zeros(size(year));
    end

	% Get all data for chosen climatology station, find first year value
	% and get all data to end of dataset
	ctd_z       = depth(id(1):end);
	ctd_year    = year(id(1):end);
	ctd_mon     = month(id(1):end);
	ctd_day     = day(id(1):end);
	ctd_t       = T(id(1):end);
	ctd_s       = S(id(1):end);
	
    % get the dates of each data profile relative to 1st January
	dayno = [datenum(ctd_year,ctd_mon,ctd_day) - datenum(Param.Year(1),1,1) + 1]';
	iday = dayno(1);
	iprof = 0;

	% For each survey, specify profile of salinity and density
	% and increase vertical spatial resolution to 1-m interval
	% Get profile data
	while iday <= dayno(end)
	    iprof = iprof + 1;
	    id = find(dayno == iday);
	    sal = ctd_s(id);
	    tem = ctd_t(id);
	    z = ctd_z(id);
	    prof_day(iprof) = iday;
	   
        % Interpolate profiles to 1m depth intervals
	    z_1m = [1:z(end)]';  n_z = length(z_1m);
	    sal_1m(1:n_z,iprof) = interp1(z,sal,z_1m,'PCHIP');
	    tem_1m(1:n_z,iprof) = interp1(z,tem,z_1m,'PCHIP');
        
        % The max interp depth needs to be greater than the depth of the
        % hypsographic function, which is defined in Hyspograohy line 81
% 	    if max(z_1m) < 250 %
%         	sal_1m(n_z+1:250,iprof) = max(sal_1m(n_z,iprof));
%         	tem_1m(n_z+1:250,iprof) = max(tem_1m(n_z,iprof));
%         	z_1m = [1:250]';
%         end
	    if max(z_1m) < 200 %
        	sal_1m(n_z+1:200,iprof) = max(sal_1m(n_z,iprof));
        	tem_1m(n_z+1:200,iprof) = max(tem_1m(n_z,iprof));
        	z_1m = [1:200]';
        end
                
        % get next profile
    	if iday < dayno(end); 
	        iday = dayno(id(end)+1); 
	    else
        	iday = dayno(end) + 1;
    	end
	end

	% Increase resolution from monthly to daily intervals. First, if the data 
	% only extend from January - December, extend the
	% boundary data by wrapping around the first and last profiles i.e. insert
	% the December profile at the beginning and add the January profile to the
	% end.
	if ctd_mon(end) == 12
	    lastday = prof_day(end) + 15;
	    prof_day = [prof_day lastday];
	    sal_1m = [sal_1m sal_1m(:,1)];
	    tem_1m = [tem_1m tem_1m(:,1)];
	end
	if ctd_mon(1) == 1
	    prof_day = [1 prof_day];
	    sal_1m = [sal_1m(:,12) sal_1m];
	    tem_1m = [tem_1m(:,12) tem_1m];
	end

	% Interpolate monthly profiles into daily datasets
	dayint = [1:Ndays];
	Bdata.S_ext = interp2(prof_day,z_1m,sal_1m,dayint,z_1m,'linear');
	Bdata.T_ext = interp2(prof_day,z_1m,tem_1m,dayint,z_1m,'linear');
% 	Bdata.T_ext = Bdata.T_ext.*0.7;

 elseif Param.OBdata == 2
    load('IF_BNDRY_CLIM.mat')     
    S0 = sal_int_1';
    T0 = temp_int_1';
    H0=1:198';
    maxdepth = LochData.Hmax;
    
    dep_rnge = 1:1:maxdepth';
    depth    = NaN(2,365);
    depth(1,1:end) = 1;
    depth(2,1:end) = maxdepth;
    
    for id = 1:length(depth(1,:));
       Bdata.S_ext(:,id) = interp1(depth(:,id),S0(:,id),dep_rnge,'spline');
       Bdata.T_ext(:,id) = interp1(depth(:,id),T0(:,id),dep_rnge,'spline');
    end

    Bdata.S_ext = repmat(Bdata.S_ext,1,2);
    Bdata.T_ext = repmat(Bdata.T_ext,1,2);
    % add spin-up period data
    Bdata.S_ext = [repmat(Bdata.S_ext,1,round(ndays_spin_up/365)) Bdata.S_ext];
    Bdata.T_ext = [repmat(Bdata.T_ext,1,round(ndays_spin_up/365)) Bdata.T_ext];
else
    % load boundary data from a matlab file. The file should contain the
    % following variables: Bdata.T0(:,2), Bdata.S0(:,2), Bdata.rho0(:,2).
%     load(Bdata.OB_file);    
    S0 = [33 34 34.9]';
    T0 = [3 2 1]';
    H0=  [20 50 200 ];
    maxdepth = LochData.Hmax;    
    Bdata.S_ext = zeros(maxdepth,size(S0,2));
    Bdata.T_ext = zeros(maxdepth,size(S0,2));
    % Build a layered profile from the layer parameter values, not very
    % reliable as it only uses the 2 layer temperatures in the forst 2 m of
    % water. Could do with some upgrading! - Lewis.
    for ic = 1:size(S0,2); % size of the columns of S0
        ndep1 = min([floor(H0(ic,1)) maxdepth]);
        Bdata.S_ext(1:ndep1,ic) = repmat(S0(1,ic),ndep1,1);
        Bdata.T_ext(1:ndep1,ic) = repmat(T0(1,ic),ndep1,1);
        ndep2 = min([floor(H0(ic,2)) maxdepth]);
        Bdata.S_ext(ndep1+1:ndep2,ic) = repmat(S0(2,ic),ndep2-ndep1,1);
        Bdata.T_ext(ndep1+1:ndep2,ic) = repmat(T0(2,ic),ndep2-ndep1,1);
        ndep3 = max([maxdepth - ndep2 0]);
        Bdata.S_ext(ndep2+1:maxdepth,ic) = repmat(S0(3,ic),ndep3,1);
        Bdata.T_ext(ndep2+1:maxdepth,ic) = repmat(T0(3,ic),ndep3,1);
    end
    
    Bdata.S_ext = repmat(Bdata.S_ext(:,1),1,720);
    Bdata.T_ext = repmat(Bdata.T_ext(:,1),1,720); 
    % add spin-up period data
    Bdata.S_ext = [repmat(Bdata.S_ext(:,1),1,ndays_spin_up) Bdata.S_ext];
    Bdata.T_ext = [repmat(Bdata.T_ext(:,1),1,ndays_spin_up) Bdata.T_ext];
end

% Derive the external density profile
% Bdata.rho_ext = Const.rho0 - Const.alpha * (Bdata.T_ext - 10) ...
%     + Const.beta * (Bdata.S_ext - 35);
Bdata.rho_ext = sw_dens0(Bdata.S_ext, Bdata.T_ext);   
% Specify external tracer concentrations
if Param.Ntracer > 0
    Bdata.C1_ext = zeros(size(Bdata.S_ext));
end
if Param.Ntracer > 1
    Bdata.C2_ext = zeros(size(Bdata.S_ext));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Surface Heat Flux data if specified
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Param.SHFlux == 1
    % Read data
    disp(['Loading surface heat flux data from ',Bdata.SHF_file]);
    SHF_data = dlmread(Bdata.SHF_file,',',1,0);
    ncol = size(SHF_data,2);
    % Select data for required year
    yyyy = SHF_data(:,1);
    tmp = ismember(yyyy,Param.Year);
    iyr=find(tmp);
%     iyr = yyyy == Param.Year;
        if yyyy == 0
        yyyy = yyyy + Param.Year;
    elseif length(iyr) == 0
        disp('ERROR: Mis-match between open boundary data and specified simulation year')
        return
    end
    Bdata.Mslp  = SHF_data(iyr(1):end,6);
    Bdata.Tair  = SHF_data(iyr(1):end,7);
    [b,a]       = butter(4,0.1,'low');      
    Bdata.Tair    = filtfilt(b,a,Bdata.Tair);  

%     Bdata.Tdew = SHF_data(iyr(1):end,8);
    Bdata.Relh = SHF_data(iyr(1):end,10);
    Bdata.Clcover = SHF_data(iyr(1):end,11);
    Bdata.QHin = SHF_data(iyr(1):end,12);
    Bdata.FDD = SHF_data(iyr(1):end,12);
    
    
%     Bdata.Mslp = repmat(Bdata.Mslp,ny,1);
%     Bdata.Tair = repmat(Bdata.Tair,ny,1);
%     Bdata.Tair = Bdata.Tair;
% %     Bdata.Tdew = repmat(Bdata.Tdew,ny,1);
% %     Bdata.Twet = repmat(Bdata.Twet,ny,1);
%     Bdata.Relh = repmat(Bdata.Relh,ny,1);
%     Bdata.Clcover = repmat(Bdata.Clcover,ny,1);
%     Bdata.QHin = repmat(Bdata.QHin,ny,1);
%     Bdata.FDD = repmat(Bdata.FDD,ny,1);


    % Add spin-up period to data
    Bdata.Mslp = [repmat(Bdata.Mslp(1:365),sy,1); Bdata.Mslp];
    Bdata.Tair = [repmat(Bdata.Tair(1:365),sy,1); Bdata.Tair];
%     Bdata.Tdew = [repmat(Bdata.Tdew(1:365),sy,1); Bdata.Tdew];
%     Bdata.Twet = [repmat(Bdata.Twet(1:365),sy,1); Bdata.Twet];
    Bdata.Relh = [repmat(Bdata.Relh(1:365),sy,1); Bdata.Relh];
    Bdata.Clcover = [repmat(Bdata.Clcover(1:365),sy,1); Bdata.Clcover];
    Bdata.QHin = [repmat(Bdata.QHin(1:365),sy,1); Bdata.QHin];
    Bdata.FDD = [repmat(Bdata.FDD(1:365),sy,1); Bdata.FDD];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify variability of coastal density. These variables
% are depth-dependent.
Bdata.sigmarho(1:200,1:Ndays) = zeros;
Bdata.deltaM(1:250,1:Ndays) = zeros;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify the contribution of the M2 + S2 tide to
% the total tidal forcing.
phi = 1.0;
% Specify daily tidal amplitude. Assume a spring-neap 
% cycle where the neap range = 40% of the spring range.
t = [1:Param.Ndays]';
Rmean = 0.7 * LochData.Range;
Ramp = 0.3 * LochData.Range;
Bdata.a0 = phi * 0.5 * (Rmean + Ramp * cos(2 * pi * t / 15));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save('ABC_tmp','Bdata', 'Param','Const'); % !da
end
