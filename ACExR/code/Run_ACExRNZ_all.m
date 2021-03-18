%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run_ACExRNZ_all
%
% script to run the AC model for all estuaries
% in the NZ estuary database.
%
% Phil Gillibrand 
% April 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on loch names from the catalogue
% Name of sea loch catalogue database file
filename = 'est_summary4.csv';
fid = fopen(filename);
    % specify data format
    rformat='%s%n%s%s%s%n%n%n%n%n%n%n%n%n%n%*[^\n]';
    % Read data file
    [Est_names,Est_nos,Reg_Council,Island,Est_types, ...
    data(:,1),data(:,2),data(:,3),data(:,4),data(:,5), ...
    data(:,6),data(:,7),data(:,8),data(:,9),data(:,10)] = ...
    textread(filename,rformat,'headerlines',1,'delimiter',','); 
fclose(fid);

% Get the number of estuaries in database
num_est = length(Est_names);
Est_mean_depth = data(:,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare output file
fid = fopen('results/ACExR_results.csv','w');
headerstring = [' Estuary, Name, T1(mean), T1(std), S1(mean), S1(std),',...
                ' N1(mean), N1(std), P1(mean), P1(std), T2(mean),',...
                ' T2(std), S2(mean), S2(std), N2(mean), N2(std),',...
                ' P2(mean), P2(std)'];
fprintf(fid,'%s\r\n',headerstring);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Work through all estuaries, calling ACExR for each

for iest = 103:num_est
  if Est_mean_depth(iest) >= 0.5
    % Assign loch name
    Estname = Est_names{iest};
    disp([num2str(iest),' ',Estname])

    % call model
    ACExRNZ(Estname);
    if LochData.Hmax < 0.5 | LochData.LWvol < 0; continue; end
        
    % Calculate mean parameter values for each layer
    T1mean = mean(Param.T(:,1));
    T1std = std(Param.T(:,1));
    S1mean = mean(Param.S(:,1));
    S1std = std(Param.S(:,1));
    C11mean = mean(Param.C1(:,1));
    C11std = std(Param.C1(:,1));
    C21mean = mean(Param.C2(:,1));
    C21std = std(Param.C2(:,1));
    T2mean = mean(Param.T(:,2));
    T2std = std(Param.T(:,2));
    S2mean = mean(Param.S(:,2));
    S2std = std(Param.S(:,2));
    C12mean = mean(Param.C1(:,2));
    C12std = std(Param.C1(:,2));
    C22mean = mean(Param.C2(:,2));
    C22std = std(Param.C2(:,2));
    
    % Some summarising of the results is required here e.g. calculate the
    % mean flushing rates for each layer.
    E1 = mean((E.Qe + E.Qf + E.Kz12) ./ Param.V(:,1));
    E2 = mean((E.Qe + E.Qt + E.Kz12 + E.Kz23) ./ Param.V(:,2));
    E1p2 = mean((E.Qe + E.Qt + E.Qf + E.Kz23) ./ ...
        (Param.V(:,1) + Param.V(:,2)));

    % output to file
    outputstring = [num2str(Est_nos(iest)),', ',Estname,', ', ...
                    num2str(T1mean),', ',num2str(T1std),', ', ...
                    num2str(S1mean),', ',num2str(S1std),', ', ...
                    num2str(C11mean),', ',num2str(C11std),', ', ...
                    num2str(C21mean),', ',num2str(C21std),', ', ...
                    num2str(T2mean),', ',num2str(T2std),', ', ...
                    num2str(S2mean),', ',num2str(S2std),', ', ...
                    num2str(C12mean),', ',num2str(C12std),', ', ...
                    num2str(C22mean),', ',num2str(C22std)];
    fprintf(fid,'%s\r\n',outputstring);
    clear data Estname outputstring E1 E2 E1p2 T* S* N* P1* P2*
    clear Reg_Council Island Est_types
  end
end

% close output file
fclose(fid);

clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end function
