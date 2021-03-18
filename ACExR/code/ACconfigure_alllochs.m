function ACconfigure(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function ACconfigure
%
% Parameterisation of physical Exchange Rates in
% Scottish fjords for Assimilative Capacity modelling.
%
% This module set the switches to configure the model.
%
% This version is the default version, which should be used in 
% tandem with the allloch_acexr.m script to run the moel for 
% all lochs in the catalogue. Hence, in this version, the name 
% of the loch (LochData.Name) is not specified.
%
% Phil Gillibrand
% July 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify entrance sill (default = 1).
Param.Esill = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Year of simulation
Param.Year = 1970;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nominal length of simulation (d), not including spin-up period
Param.Ndays = 365;
Param.ndays_spin_up = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hot- or cold-start
Param.hotstart = 0;
%Param.hotstartfile = 'hotstart.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include surface heat flux in temperature routine.
% Default = No (Param.SHFlux = 0)
% If Yes (Param.SHFlux = 1), data for wind speed, sea surface pressure, air
% temperature, dew-point temperature, wet-bulb temperature, relative
% humidity and cloud cover are needed.
% Here, provide the data file name and the height of the data station above
% MSL.
Param.SHFlux = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify boundary forcing data files
% 1. Wind data
Param.WindData = 1;
Bdata.Wind_file = 'Climatology_windspeed_1970-2004.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify boundary forcing data files
% Comment out EITHER the statements in 2a or 2b
% 2a. Rainfall data
Param.QfData = 1;
Bdata.Qf_file = 'Climatology_rainfall_1970-2004.csv';

% 2b. Riverflow data
%Bdata.Qf_switch = 1;
%Bdata.Qf_file = 'Climatology_riverflow_2000-2004.csv';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify boundary forcing data files
% 3. Boundary T & S data
Param.OBdata = 1;
Bdata.OB_file = 'ukhoclimatology (edit).csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify initial conditions (Not required).
Param.ICswitch = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify conservative tracers
Param.Ntracer = 0;

end