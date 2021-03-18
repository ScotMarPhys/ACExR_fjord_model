function ACconfigure(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function ACconfigure(varargin)
%
% Parameterisation of physical Exchange Rates in
% Scottish fjords for Assimilative Capacity modelling.
%
% This module set the switches to configure the model.
%
% Phil Gillibrand
% July 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loch name (if not supplied to ACExR)
nargin = length(varargin);
if nargin == 0;
    LochData.Name = 'Linnhe';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify entrance sill (default = 1).
Param.Esill = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Year of simulation
Param.Year = 1978;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nominal length of simulation (d), not including spin-up period
Param.Ndays = 365;
Param.ndays_spin_up = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include surface heat flux in temperature routine.
% Default = No (Param.SHFlux = 0)
% If Yes (Param.SHFlux = 1), data for wind speed, sea surface pressure, air
% temperature, dew-point temperature, wet-bulb temperature, relative
% humidity and cloud cover are needed.
% Here, provide the data file name and the height of the data station above
% MSL.
Param.SHFlux = 1;
Bdata.SHF_file = 'ACmodel_heatflux_database_Dunstaffnage.csv';
Bdata.StHgt = 9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include time-varying wind forcing in the simulation ?
% Default = No (Param.WindData = 0)
% If Yes (Param.WindData = 1), a filename containing wind data is needed.
% Specify boundary forcing data files
% 1. Wind data
Param.WindData = 1;
Bdata.Wind_file = 'ACmodel_windspeed_database_editted.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include time-varying rainfall or river flow in the simulation ?
% Default = No (Param.QfData = 0)
% If Yes (Param.QfData = 1 or 2), a filename containing data is needed.
Param.QfData = 0;
% Comment out EITHER the statements in 2a or 2b
% 2a. Rainfall data
%Param.QfData = 1;
%Bdata.Qf_file = 'ACmodel_rainfall_database.csv';

% 2b. Riverflow data
% Param.QfData = 2;
% Bdata.Qf_file = 'Climatology_riverflow_1977-1997.csv';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify boundary forcing data files
% 3. Boundary T & S data
Param.OBdata = 1;
Bdata.OB_file = 'ukhoclimatology (edit).csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify initial conditions if required
Param.ICswitch = 0;
%Param.H(1,:) = [5.0 10.0 30.15];
%Param.S(1,:) = [31.5 31.9 32.3];
%Param.T(1,:) = [8.1 8.1 8.2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify conservative tracers
Param.Ntracer = 0;
if Param.Ntracer > 0; Param.C1(1,1:3) = [0 0 0]; end
if Param.Ntracer > 1; Param.C2(1,1:3) = [0 0 0]; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

