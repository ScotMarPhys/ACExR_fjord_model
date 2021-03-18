%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read ISA data and organise into format for ACExR model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc

load ..\in\ISA.mat; whos 

ISA_mat = nan(length(PR(:,1)),8);
ISA_mat = repmat(ISA_mat,[93,1]);

ISA_mat(1:end,1) = -13.2;

ISA_mat(1:end,2) = 78.5;

[Y, M, D] =datevec(date);

for i = 1:length(Y);
    
    tmp_y = repmat(Y(i),91,1);
    if i == 1
    date_mat = tmp_y;
    else
    date_mat = [date_mat; tmp_y];
    end
end

ISA_mat(1:end,3) = date_mat;

clear date_mat

for i = 1:length(M)
    
    tmp_m = repmat(M(i),91,1);
    if i == 1;
    date_mat = tmp_m;
    else
    date_mat = [date_mat; tmp_m];
    end
end

ISA_mat(1:end,4) = date_mat;

clear date_mat

for i = 1:length(D);
    
    tmp_d = repmat(D(i),91,1);
    if i == 1
    date_mat = tmp_d;
    else
    date_mat = [date_mat; tmp_d];
    end
end

ISA_mat(1:end,5) = date_mat;

ISA_mat(1:end,6) =repmat(PR(:,1),length(Y),1);

for i=1:length(T(1,:));
    tmp_t = T(:,i);
    if i==1;
        t_mat = tmp_t ;
    else
        t_mat = [t_mat; tmp_t];
    end
end

ISA_mat(1:end,7) =t_mat;


for i=1:length(S(1,:));
    tmp_s = S(:,i);
    if i==1;
        s_mat = tmp_s ;
    else
        s_mat = [s_mat; tmp_s];
    end
end

ISA_mat(1:end,8) =s_mat;

%PRINT TO CSV FILE

ISA_mat(~any(isnan(ISA_mat),2),:);
HEADER = [0, 0, 0, 0, 0, 0, 0, 0];

dlmwrite('ISA_full.csv',HEADER,'delimiter',' ');

dlmwrite('ISA_full.csv',ISA_mat,'-append',...
'delimiter',' ','roffset',1)





