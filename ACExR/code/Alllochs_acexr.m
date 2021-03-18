%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AllLochs_ACExR
%
% script to run the AC model for all lochs
% in the sea loch catalogue.
%
% Phil Gillibrand 
% July 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables
global LochData SillData Hypso Bdata Const D E Param

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on loch names from the catalogue
% Name of sea loch catalogue database file
filename = '../Catalogue/Sealochs.csv';
fid = fopen(filename);
% specify data format
format='%n%s%s%s%n%n%s%s';
format = [format,repmat('%n',1,19)];

% Read data file
data = textscan(fid,format,'headerlines',1,'delimiter',',');
fclose(fid);

AllLochNames = data{2};
Nloch = length(AllLochNames);
Nsill = data{25};
Hmax = data{11};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare output file
fid = fopen('ACExR_results.csv','w');
%headerstring = 'Loch, Name, E1p2(med), Ew(med), E1p2 (90%ile), Ew (90%ile)';
headerstring = 'Loch, Name, Area, Qe, Qt, Kz12, Kz23, Qh, Qw12, Qw23, Tf_med, Tf_95';
fprintf(fid,'%s\r\n',headerstring);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Work through all lochs, calling model for silled lochs only.

for iloch = 1:Nloch
    % Assign loch name
    E1p2 = 0; Ew = 0;
    E1p2_90 = 0; Ew_90 = 0;
    Ebar = [NaN NaN NaN NaN NaN NaN NaN];
    Estd = [NaN NaN NaN NaN NaN NaN NaN];
    
    Lochname = AllLochNames{iloch};
    disp([num2str(iloch),' ',Lochname]);

    % if Nsill(iloch) == 0; continue; end
    %if iloch == 18; continue, end
    if Hmax(iloch) < 10; continue; end

    % call model
    ACExR(Lochname);
    
    % Some summarising of the results is required here e.g. calculate the
    % mean flushing rates for each layer.
    %E1p2 = (E.Qe + E.Qf + E.Qt + E.Kz23) ./ (Param.V(:,1)+Param.V(:,2));
    %Ew = (E.Qe + E.Qf + E.Qt) ./ sum(Param.V,2);    
    %E1p2 = sort(E1p2);
    %Ew = sort(Ew);
    %E1p2_90 = 0.5 * (E1p2(36) + E1p2(37));
    %Ew_90 = 0.5 * (Ew(36) + Ew(37));
    
    % output to file
    %outputstring = [num2str(iloch),', ',Lochname,', ', num2str(median(E1p2)), ...
    %    ', ',num2str(median(Ew)),', ',num2str(E1p2_90),', ',num2str(Ew_90)];
    %fprintf(fid,'%s\r\n',outputstring);
    %clear Lochname outputstring E1 E2
    
    Ebar(1) = mean(E.Qe + E.Qf);
    Ebar(2) = mean(E.Qt);
    Ebar(3) = mean(E.Kz12);
    Ebar(4) = mean(E.Kz23);
    Ebar(5) = mean(abs(E.Qh(:,1)));
    Ebar(6) = mean(abs(E.Qw12));
    Ebar(7) = mean(abs(E.Qw23));
    Estd(1) = std(E.Qe + E.Qf);
    Estd(2) = std(E.Qt);
    Estd(3) = std(E.Kz12);
    Estd(4) = std(E.Kz23);
    Estd(5) = std(E.Qh(:,1));
    Estd(6) = std(E.Qw12);
    Estd(7) = std(E.Qw23);
    Tf = (Param.V(:,1) + Param.V(:,2)) ./ ((E.Qe + E.Qf + E.Qt)*86400);
    Tf = sort(Tf);
    Tf_med = median(Tf);
    Tf_95 = 0.75 * Tf(347) + 0.25 * Tf(346);

    outputstring = [num2str(iloch),', ',Lochname,', ',num2str(Hypso.A(1),'%10d')];
    for ic = 1:7
        %outputstring = [outputstring,', ', num2str(Ebar(ic)),' (',num2str(Estd(ic)),')'];
        outputstring = [outputstring,', ', num2str(Ebar(ic),'%6.1f')];
    end
    outputstring = [outputstring,', ',num2str(Tf_med,'%6.1f'),', ',num2str(Tf_95,'%6.1f')];
    fprintf(fid,'%s\r\n',outputstring);

end


% close output file
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end function
