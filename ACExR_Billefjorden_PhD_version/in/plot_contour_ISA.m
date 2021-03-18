clear all; close all;
load ISA_CORRECTED.mat
pres = 1:91'; pres = pres';

figure(1)
AX1 = subplot(2,1,1);
[c,h] = contourf(date,pres,T);
axis ij
AX1.YLim = [0 100];
h.LineColor = 'k';
tick_locations = date(1:20:end);
set(AX1,'XTick',tick_locations)
datetick(gca,'x','mmm-yy','keepticks')

colormap(AX1,brewermap([14],'*RdBu'));
c = colorbar; ylabel(c,['Temperature C', char(176)]);


AX2 = subplot(2,1,2);
[c,h] = contourf(date,pres,S);
axis ij
AX2.YLim = [0 100];
h.LineColor = 'k';
tick_locations = date(1:20:end);
set(AX2,'XTick',tick_locations)
datetick(gca,'x','mmm-yy','keepticks')
set(gca, 'Clim', [31.1 34.9]);
colormap(AX2,brewermap([16],'Blues'));
c = colorbar; ylabel(c,['Salinity']);

figureHandle = gcf;
set(figureHandle,'color',[1 1 1]);   
set(figureHandle,'paperpositionmode','auto'); 
set(figureHandle,'pos',[9         513        1581         598]);
set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold');
set(findall(figureHandle,'type','axes'),'fontSize',14,'fontWeight','bold');
fname=sprintf('%s','ISA_ALL_DATA.pdf'); 
export_fig(['../../Writing/Thesis/svalbard_oceangraphy/figures/',fname])    


% d1 = datenum(2013,1,1);
% d2 = datenum(2013,12,31);
% idx = find(date >=d1 & date <= d2)
% pres = 1:91'; pres = pres';
% contourf(date(idx), pres, T(:,idx));
% axis ij;
% h = colorbar;set(gca,'clim',[-2 7]);ylabel(h,'Temperature ^o C');
% datetick('x',12,'keepticks','keeplimits');
% colormap(brewermap([9],'*RdBu')); 
% set(gcf, 'color', [1 1 1],'pos',[145 117 1145 972]);
% ylabel('Depth (m)');
% fname = sprintf('ISA_2013_temp');
% print('-dpng',['..\..\Writing\Thesis\Figures\',fname]);
% close all
% contourf(date(idx), pres, S(:,idx));
% axis ij;
% h = colorbar;set(gca,'clim',[32 35]);ylabel(h,'Salinity');
% datetick('x',12,'keepticks','keeplimits');
% colormap(brewermap([6],'Blues')); 
% set(gcf, 'color', [1 1 1],'pos',[145 117 1145 972]);
% ylabel('Depth (m)');
% fname = sprintf('ISA_2013_sal');
% print('-dpng',['..\..\Writing\Thesis\Figures\',fname]);