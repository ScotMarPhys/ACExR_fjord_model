function metIsfjorden(sta,slu,years);

phi0 = [45 135];   %Most effective wind direction for polynya (closing and) opening in Isfjorden.

nyears=length(years);
for ny=1:nyears;
    start=[years(ny)-1 sta]
    slutt=[years(ny) slu]
    [Ta,phi,U,RH,CL,aar,mnd,dag,tim]=Isfjorden(start,slutt);
    cumTa=cumsum(Ta);
    
    if ny==1
        Uhist=U;
        phihist=phi;
    else
        Uhist=[Uhist;U];
        phihist=[phihist;phi];
    end

    dato=datenum(aar,mnd,dag,tim,0,0)-datenum(aar(1)-1,12,31,0,0,0);
    if aar(1)==aar(end);
        dagnum=datenum(aar(1),1:6,1);
    else
        dagnum=datenum(aar(1),9:18,1);
    end

    %Temperature
    %%%%%%%%%%%%
    MeanTa(ny)=mean(Ta);
    sdTa(ny)=std(Ta);
    if ny==1;
        s={'k--','k-','g-','r-','c-','b-','b--'};
        figure(1);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['Air temp. ( ^oC)'],'fontsize',12);
        axis([floor(dato(1)) ceil(dato(end)) -35 5]);
        grid;
    else
        figure(1);hold on;
    end
    Tag=glidemiddel(Ta,4*7);
    plot(dato,Tag,cell2mat(s(ny)));
    if ny==nyears
        legend(num2str(years'),'location','SouthEast');
%        text(340,2,num2str(MeanTa));
        MeanTa'
        sdTa'
    end


    %Cumulative sum of Temperature
    %%%%%%%%%%%%
    if ny==1;
        s={'k--','k-','g-','r-','c-','b-','b--'};
        figure(100);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['Cumulative sum of air temp. ( ^oC)'],'fontsize',12);
        axis([floor(dato(1)) ceil(dato(end)) -10000 1000]);
        grid;
    else
        figure(100);hold on;
    end
%     Tag=glidemiddel(Ta,4*7);
    plot(dato,cumTa,cell2mat(s(ny)));
    if ny==nyears
        legend(num2str(years'),'location','SouthWest');
%         text(340,2,num2str(MeanTa));
%         MeanTa'
%         sdTa'
    end
%     plot(dato,ones(size(dato))*mean(Ta),':k');
%     plot(dato,zeros(size(dato)),'k--');


    %Wind component of most effective wind direction for opening of the polynya
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ny==1;
        figure(3);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['\phi_0 wind component (ms^{-1})'],'fontsize',12);
        axis([floor(dato(1)) ceil(dato(end)) -15 15]);
        grid;
    else
        figure(3);
    end
    if length(phi0)==2
        Phi0=phi0(2).*ones(size(U));
        phii=find(phi>180 & phi<270);
        Phi0(phii)=phi0(1).*ones(length(phii),1);
        phii=find(phi>0 & phi<90);
        Phi0(phii)=phi0(1).*ones(length(phii),1);
    else
        Phi0=phi0;
    end
    NS = U.*cos((phi-Phi0)*pi/180);
    cumNS=cumsum(NS);
    NSg=glidemiddel(NS,4*7);
    MeanNS(ny)=mean(NS);
    plot(dato,NSg,cell2mat(s(ny)));
    sdNS(ny) = std(NS);
%     Isd = find(NSg>=2*sd);
%     datestr(dato(Isd))
%     plot(dato(Isd),ones(size(Isd))*15,'k.','MarkerSize',16);
%     plot(dato,ones(size(NSg))*sd*2,'k:');
%     legend('North-south wind component','Winds higher than 2std','2*Standard deviation',0);
%     plot(dato,zeros(size(dato)),'k--');
    if ny==nyears
        legend(num2str(years'),'location','SouthEast');
        text(340,12,num2str(MeanNS));
        MeanNS'
        sdNS'
    end

    if ny==1;
        figure(300);clf;
    else
        figure(300);hold on;
    end
    plot(phi,U,'.');
    grid;
    
    %Cumulative sum of opening and closing wind
    %%%%%%%%%%%%
    if ny==1;
        s={'k--','k-','g-','r-','c-','b-','b--'};
        figure(350);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['Cumulative sum of  \phi_0 wind component (ms^{-1})'],'fontsize',12);
        axis([floor(dato(1)) ceil(dato(end)) -500 3000]);
        grid;
    else
        figure(350);hold on;
    end
%     Tag=glidemiddel(Ta,4*7);
    plot(dato,cumNS,cell2mat(s(ny)));
    if ny==nyears
        legend(num2str(years'),'location','NorthWest');
%         text(340,2,num2str(MeanTa));
%         MeanTa'
%         sdTa'
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Estimates the net heat flux and frazil ice growth in open water
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constants
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rhoa = 1.3;           %Air density in kg/m3
    C    = 2.0e-3;        %Heat transfer coefficient (sensible + latent heat flux including evaporation effects)
    cp   = 1004;          %Specific heat at constant pressure for dry air in J/(deg kg)
    Ts   = -1.8;          %Freezing temperature for seawater in degree Celsius
    es   = 0.98;          %Sea surface emissivity
    sig  = 5.67e-8;       %Stefan-Boltzmann constant
    alpha = 0.1;          %Albedo of open water
    S0   = 1353;          %The sun constant in W/m2
    psi  = 77.75;         %Latitude of the polynya in Degrees
    %RH   = 0.95;         %Constant relative humidity (Haarpaintner et al.)
    r    = 7.5;           %Constant
    b    = 237.3;         %Constant
    %hc   = 0.20;         %Collection thickness, 20 cm (Haarpaintner et al.)
    hc   = (1+0.1.*U)/15; %Collection thickness linearly dependent on wind direction (Winsor&Bjork,2000)
    T    = -1.865;        %Freezing point for surface seawater with salinity Sw = 34.
    Sw   = 34;            %Salinity of freezing seawater.
    rhof = 950;           %Density of frazil ice in kg/m3.
    dt   = 6*3600;        %Time step between met. observations in seconds (6 hours).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Salinity in frazil ice expressed as mass fraction where 10 psu corresponds to 0.01 in Ls below
    Si    = (0.31*Sw)/1000;

    %Latent heat of fusion of sea ice in J/kg, Yen et al. (1991) og Ono (1967)
    Ls    = 4.187*(79.68-0.505*T-27.3*Si+4311.5*(Si/T)+0.8*Si*T-0.009*T^2)*1000;

    %Estimation of the net heat flux, Fnet
    FT = -(rhoa*C*cp)*U.*(Ta-Ts);             %Ta-Ts, differensial=>can use degree Celsius
    FL = es*(sig*(Ts+273.15)^4);              %Ts+273.15=degree Kelvin
    ea = 0.7829*(1+0.2232*(CL/8).^(2.75));    %The effective air emissivity
    FB = (ea.*(sig*(Ta+273.15).^4));          %Simonsen & Haugan (1996), in deg. Kelvin
    k  = 1-0.6*(CL/8).^3;                     %Cloud correction term
    vp = (RH/100)*6.11.*10.^(r*Ta./(b+Ta));
    d=[];
    for n=1:length(aar)
        d(n)=sum(eomday(aar(n),1:mnd(n)-1))+dag(n); %Day of the year
    end
    i  = 23.44*cos((360/365)*(172-d)*pi/180)';
    ts = tim+2;                               %Sun hour = 2 hours behind local time
    t  = (12-ts)*15;                          %Sun hour angle
    %The suns zenith angle, z, cos(z) = sin(psi)*sin(i)+cos(psi)*cos(i)*cos(t);
    cosz = sin(psi*pi/180).*sin(i*pi/180)+cos(psi*pi/180).*cos(i*pi/180).*cos(t);
    %Only the positive zenith angles are used in the calculation of FS
    coszp = zeros(size(cosz));
    coszp(find(cosz>=0)) = cosz(find(cosz>=0));
    Q0 = ((S0.*coszp.^2)./(1.085.*coszp+(2.7+coszp).*vp*1e-3+0.1));
    FS = (1-alpha)*k.*Q0;
    Fnet = FT+FL-FB-FS;

    %Frazil ice growth
    dhf = (Fnet/(rhof*Ls))*dt;
    %Use only the positive frazil ice growth
    dhf(find(dhf<0))=0;
    %Accumulated frazil ice growth
    Hf(1) = 0;
    for n = 2:length(dhf)
        Hf(n) = Hf(n-1) + dhf(n);
    end

    if ny==1;
        figure(4);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['Net heat exchange (Wm^{-2})'],'fontsize',12);
       axis([floor(dato(1)) ceil(dato(end)) -100 500]);
        grid;
    else
        figure(4);
    end
    Fnetg=glidemiddel(Fnet,4*7);
    MeanFnet(ny)=mean(Fnet);
    plot(dato,Fnetg,cell2mat(s(ny)));
    sdFnet(ny) = std(Fnet);
    if ny==nyears
        legend(num2str(years'),'location','NorthEast');
        text(340,12,num2str(MeanFnet));
        MeanFnet'
        sdFnet'
    end

    if ny==1;
        figure(400);clf;
        hold on;
        set(gca,'XTick',dagnum-datenum(aar(1)-1,12,31,0,0,0),'XTicklabel',datestr(dagnum',6),'fontsize',12);
        xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
            '/',num2str(mnd(end))],'fontsize',12);
        ylabel(['Cumulative sum of net heat exchange (kWm^{-2})'],'fontsize',12);
        axis([floor(dato(1)) ceil(dato(end)) -20 140]);
        grid;
    else
        figure(400);
    end
%     Fnetg=glidemiddel(Fnet,4*7);
%     MeanFnet(ny)=mean(Fnet);
    plot(dato,cumsum(Fnet)./1e3,cell2mat(s(ny)));
%     sdFnet(ny) = std(Fnet);
    if ny==nyears
        legend(num2str(years'),'location','NorthWest');
%         text(340,12,num2str(MeanFnet));
%         MeanFnet'
%         sdFnet'
    end

%         %Cloud cover
%     %%%%%%%%%%%%%
%     if ny==1;
%         figure(2);clf;
%         hold on;
%     else
%         figure(2);
%     end
%     %subplot(1,2,1);
%     CLg=glidemiddel(CL,4);
%     Habar=bar(dato,CLg);
%     plot(dato,ones(length(dato))*8,'-k','LineWidth',1.5);
%     set(Habar,'EdgeColor',[0.7 0.7 0.7],'FaceColor',[0.7 0.7 0.7])%,'Color',[0.5 0.5 0.5]);
%     set(gca,'XTick',dagnum,'XTicklabel',datestr(dagnum',6),'fontsize',12);
%     xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
%         '/',num2str(mnd(end)),' ', num2str(aar(1)),'-',num2str(aar(end))],'fontsize',12);
%     ylabel(['Cloud cover (eighth of parts)'],'fontsize',12);
%     axis([dagnum(1) dagnum(end) 0 9]); 
% 
%     %Relative humidity
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if ny==1;
%         figure(22);clf;
%         hold on;
%     else
%         figure(22);
%     end
%     %subplot(1,2,2);
%     RHg=glidemiddel(RH,4);
%     plot(dato,RHg,'k-');
%     set(gca,'XTick',dagnum,'XTicklabel',datestr(dagnum',6),'fontsize',12);
%     xlabel(['Time ',num2str(dag(1)),'/',num2str(mnd(1)),'-',num2str(dag(end)),...
%         '/',num2str(mnd(end)),' ', num2str(aar(1)),'-',num2str(aar(end))],'fontsize',12);
%     ylabel(['Adjusted rel. humidity'],'fontsize',12);
%     axis([dagnum(1) dagnum(end) 50 100]);
%     plot(dato,ones(size(dato))*mean(RH),'k--');
end

figure(5);clf;
rose(phihist);
view(90,-90);

figure(500);clf;
% polar(270-phihist,Uhist,'.');
compass(-Uhist.*sin(pi./180.*phihist),-Uhist.*cos(pi./180.*phihist),'k.');
