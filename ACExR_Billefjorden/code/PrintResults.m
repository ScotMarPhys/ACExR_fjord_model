%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This contains all the code to produce figures from the saved results
% following a model run of the ACExR model
%
% Please make sure to label everything clearly and not leave any ambiguous 
% code
% 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
figure(3);

ax(1)=subplot(2,2,1);
plot(Temperature,....
    'LineWidth',2);
grid on
title('(1) Billefjorden Temperature','fontsize',14);
legend('layer 1','layer 2', 'layer 3');
xlabel('Day Number','fontsize',14);
ylabel('Temperature ^o C','fontsize',14);

ax(2)=subplot(2,2,2);
plot(Salinity,....
    'LineWidth',2);
grid on
title('(2) Billefjorden Salinity','fontsize',14);
legend('layer 1','layer 2', 'layer 3');
xlabel('Day Number','fontsize',14);
ylabel('Salinity','fontsize',14);

ax(3)=subplot(2,2,3);
plot(LayerH,....
    'LineWidth',2);
grid on
title('(3) Billefjorden Layer Thickness','fontsize',14);
legend('layer 1','layer 2', 'layer 3');
xlabel('Day Number','fontsize',14);
ylabel('(m)','fontsize',14);

ax(4)=subplot(2,2,4);
plot(Ice,....
    'LineWidth',2);
grid on
title('(4) Billefjorden Ice','fontsize',14);
legend('');
xlabel('Day Number','fontsize',14);
ylabel('m','fontsize',14);



for i=1:4
set(ax(i),'TickDir','in',...
    'visible', 'on',....
    'LineWidth',2,...
    'FontSize',14,...
    'FontName','Arial',...
    'Clipping','off',...
    'Color',[1 1 1])
end

figureHandle = gcf;

set(findall(figureHandle,'type','text'),'fontSize',12,'fontWeight','bold','fontname','arial')

set(findall(figureHandle,'type','axes'),'fontSize',12,'fontWeight','bold','fontname','arial')

set(gcf, 'color', [1 1 1],'pos',[145 117 1145 972], 'paperpositionmode', 'auto');

export_fig(figure(3),['..\..\Writing\Thesis\Figures\model_TSD_',fname,'.pdf']);

export_fig(figure(3),['..\..\Writing\Isotope_work\Figures\model_TSD_',fname,'.pdf']);

%%
figure(4)

hAx(1)=subplot(5,2,1);

hLine1 = plot(Time,QW12,':k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);
ylabel('Tidal Entrainment layers 1-2','fontsize',14);

%%
hAx(2)=subplot(5,2,2);

hLine1 = plot(Time,QW23,'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel('Tidal Entrainment layers 2-3','fontsize',14);
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);

%%
hAx(3)=subplot(5,2,3);

hLine1 = plot(Time,QG,'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);
ylabel('Estuarine Exchange','fontsize',14);

%%
hAx(4)=subplot(5,2,4);

hLine1 = plot(Time,IceV,'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel({'Volume flux m^{3}S^{-1}'; 'due to ice growth '},'fontsize',14);grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);

%%
hAx(5)=subplot(5,2,5);

hLine1 = plot(Time,QH(:,1),'-k'); 

set(hLine1,'LineStyle','-',...
    'linewidth', 2)
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);
ylabel('Wind Driven Entrainment Layer 1','fontsize',14);

%%
hAx(6)=subplot(5,2,6);

hLine1 = plot(Time,QT,'-k'); 

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel('Tidal Exchange','fontsize',14);
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);


%%
hAx(7)=subplot(5,2,7);

hLine1 = plot(Time,KZ(:,1),'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);
ylabel('K_Z (1-2)','fontsize',14);

%%
hAx(8)=subplot(5,2,8);

hLine1 = plot(Time,KZ(:,2),'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel('K_Z (2-3)','fontsize',14);
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);

%%
hAx(9)=subplot(5,2,9);

hLine1 = plot(Time,Ri(:,1),'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel('Ri_1','fontsize',14);
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);

%%
hAx(10)=subplot(5,2,10);

hLine1 = plot(Time,Ri(:,2),'-k');

set(hLine1,'LineStyle','-',...
    'linewidth', 2)

ylabel('Ri_2','fontsize',14);
grid on
title('','fontsize',14);
xlabel('Day Number','fontsize',14);

%%
figureHandle = gcf;

set(findall(figureHandle,'type','text'),'fontSize',12,'fontWeight','bold','fontname','arial')

set(findall(figureHandle,'type','axes'),'fontSize',10,'fontWeight','bold','fontname','arial')

set(gcf, 'color', [1 1 1],'pos',[145 117 1145 972], 'paperpositionmode', 'auto');

export_fig(figure(3),['..\Figures\model_TSDL_',fname,'.pdf']);

export_fig(figure(4),['..\Figures\model_PARAMS_',fname,'.pdf']);

export_fig(figure(3),['..\..\Writing\Thesis\Figures\model_TSDL_',fname,'.pdf']);

export_fig(figure(4),['..\..\Writing\Thesis\Figures\model_PARAMS_',fname,'.pdf']);


