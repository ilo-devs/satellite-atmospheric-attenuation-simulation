clc


% %Paramétre Initiale du station emetrice
Pt=61; %[dBm,1.2 kW]
Gt=55; %[dBi]
Lfeedt=3; %[dB]
lat1=-19.53;
lon1=47.27;
De=1.3;
nu=0.7; %70%


%Paramétre satellite
Gsu=20; %[dBi]
Gs=100; %[dB] %Gain d'amplification
Gsd=35; %[dBi]
Lfeedsatr=0; %[dB]
Lfeedsate=0; %[dB]
h=35786; %[Km]


%Paramétre Initiale du station terrien receptrice
Gr=52; %[dBi]
Lfeedr=3; %[dB]
lat2=35; %[Degrée]
lon2=135.46; %[Degrée]
Dr=1.5;

% Donée atmosphérique a importée
load itur836_4_vapd
load data_Nwet
load data_rain_rate
load data_topo
load data_hauteur_pluie

%Paramétre atmosphérique, saison et radio
saison='été';
fu=14; %[Ghz]
fd=12; %[Ghz]
p=0.01;
elev=45; %[Degrée]
tau=0;% Horizontal

[T1,P1,rho1]=get_TPe2(lat1,lon1,0,p,'été',topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
[T2,P2,rho2]=get_TPe2(lat2,lon2,0,p,'hiver',topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);

lwc1=valLred(lat1,lon1,p);
lwc2=valLred(lat2,lon2,p);

Nwet1=valNwet(lat1,lon1,Lat_1dot5,Long_1dot5,Nwet_1dot5);
Nwet2=valNwet(lat2,lon2,Lat_1dot5,Long_1dot5,Nwet_1dot5);

Ro_o1_1=taux_precipitation(p,lat1,lon1);
Ro_o1_2=taux_precipitation(p,lat2,lon2);

hr1=valHr(lat1,lon1);
hr2=valHr(lat2,lon2);

hs1=valHs2(lat1,lon1);
hs2=valHs2(lat2,lon2);

%% Calcule du path loss
%Liaison montant
Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));

%Liaison descendant
Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
%% affaiblissement gaz    
    %Calcule de l'afaiblissement du aux gaz liaison montant
    [Lo,Lw,Agazup]=AffGaz(lat1,lon1,'été',fu,elev,T1,P1,rho1,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
    %Calcule de l'afaiblissement du aux gaz liaison descendant
    [Lo,Lw,Agazdwn]=AffGaz(lat2,lon2,'hiver',fd,elev,T2,P2,rho2,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%     % Calcule de la puissance recue par l'antenne receptrice
%     Pr=Pt-Lfeedt+Gt-Lpthu-Agazup+Gsu-Lfeedsatr+Gs-Lfeedsate+Gsd-Lpthd-Agazdwn+Gr-Lfeedr
%% Afaiblissement du aux nuages
    %Calcule de l'afaiblissement du aux gaz liaison montant
    [Kl,Anuageup]=AffNuage( fu,T1,elev,lwc1 );
    %Calcule de l'afaiblissement du aux nuage liaison descendant
    [Kl,Anuagedwn]=AffNuage( fd,T2,elev,lwc2 );
%% Affablissement sintiilation
    %Calcule de l'afaiblissement du aux gaz liaison montant
    Ascintup=scintillation(fu,elev,De,nu,p,Nwet1);
    %Calcule de l'afaiblissement du aux nuage liaison descendant
    Ascintdwn=scintillation(fd,elev,Dr,nu,p,Nwet2);   
%% Affaiblissement pluie
        %Calcule de l'afaiblissement du aux gaz liaison montant
        [gamaR,Apluieup]=AffPluie(fu,elev,tau,Ro_o1_1,hr1,lat1,hs1,p );
        %Calcule de l'afaiblissement du aux gaz liaison descendant
        [gamaR,Apluiedwn]=AffPluie(fd,elev,tau,Ro_o1_2,hr2,lat2,hs2,p);
%% Hypsogramme
%Hyspo sans atmosphére
bilan=[Pt -Lfeedt Gt -(Lpthu) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd) Gr -Lfeedr];
y=[];
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end
plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'LineWidth',2);
hold on
grid on
ylabel('[dBm]')

%Hypso Gaz
bilan=[Pt -Lfeedt Gt -(Lpthu+Agazup) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd+Agazdwn) Gr -Lfeedr];
y=[];
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end

plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'--','LineWidth',2,'Color','red');
%Hypso nuage
bilan=[Pt -Lfeedt Gt -(Lpthu+Anuageup) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd+Anuagedwn) Gr -Lfeedr];
y=[];
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end

plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'--','LineWidth',2,'Color','green');

%Scintillation
bilan=[Pt -Lfeedt Gt -(Lpthu+Ascintup) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd+Ascintdwn) Gr -Lfeedr];
y=[];
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end

plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'--','LineWidth',2,'Color','yellow');

%Pluie
bilan=[Pt -Lfeedt Gt -(Lpthu+Apluieup) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd+Apluiedwn) Gr -Lfeedr];
y=[];
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end

plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'--','LineWidth',2,'Color','cyan');

%Total cumulée
bilan=[Pt -Lfeedt Gt -(Lpthu+Agazup+Anuageup+Ascintup+Apluieup) Gsu -Lfeedsatr Gs -Lfeedsate Gsd -(Lpthd+Agazdwn+Anuagedwn+Ascintdwn+Apluiedwn) Gr -Lfeedr];
y=[];   
Pr2=0;
for i=1:1:numel(bilan)
    Pr2=Pr2+bilan(i);
    y=[y Pr2];
end

plot([0 1 2 5 6 7 8 9 10 13 14 15],y,'--','LineWidth',2,'Color',[1 0.5 0]);

legend('Hyspogramme sans Attenuation Atm','Hypsogramme-Attenuation gaz','Hypsogramme-Attenuation nuage','Hyspogramme-Attenuation scintillation','Hyspogramme-Attenuation Pluie','Hyspogramme-Attenuation Totale')
title('Hypsogramme Liaison Antananarivo-Kyoto pour une disponibilitée p =99,9%') 
hold off