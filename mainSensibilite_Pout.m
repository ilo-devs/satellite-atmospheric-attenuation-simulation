clc
clear all
%% Ici on ne va faire ici que la liaison descendant mais la méthode est la même pour une liaison montant
%Paramétre station au sol
lat2=-23.43;
lon2=133.46;
Gr=53;
To=290;%[°K]
nu=0.7;%[rendement]
NFlna=0.3; %[figure de bruits LNA][dB]
TLNA=((10^(NFlna/10))-1)*To; %[K]
Lfeedr=3;%[dB];
NFsys=15;%[figure de bruit systeme][dB]
Dr=1.5;


%Parametre satellite
Gt=43;%[dBi]
Lfeeds=0;%[db]

%Parametre longueur du trajet
h=10500;

%Paramétre atmosphérique et radioélctrique
fd=20;%[GHz]
elev=45;%[Ghz]
tau=90;%[V]
p=0.01;%[dispo de la pluie,gaz,...:99,99%]

%Parmétre trasmissionn
TEB=1e-5;
mod='psk';
etat=16;
Rb=26*10^6;%[26Mbps]
B=36*10^6;%[Mhz]

% Donée atmosphérique a importée
load itur836_4_vapd
load data_Nwet
load data_rain_rate
load data_topo
load data_hauteur_pluie

[T2,P2,rho2]=get_TPe2(lat2,lon2,0,p,'été',topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob)


lwc2=valLred(lat2,lon2,p)

Nwet2=valNwet(lat2,lon2,Lat_1dot5,Long_1dot5,Nwet_1dot5)


Ro_o1_2=taux_precipitation(p,lat2,lon2) 


hr2=valHr(lat2,lon2);


hs2=valHs2(lat2,lon2);



%% affaiblissement gaz    
    %Calcule de l'afaiblissement du aux gaz liaison descendant
    [Lo,Lw,Agazdwn]=AffGaz(lat2,lon2,'été',fd,elev,T2,P2,rho2,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%     % Calcule de la puissance recue par l'antenne receptrice
%     Pr=Pt-Lfeedt+Gt-Lpthu-Agazup+Gsu-Lfeedsatr+Gs-Lfeedsate+Gsd-Lpthd-Agazdwn+Gr-Lfeedr
%% Afaiblissement du aux nuages
    %Calcule de l'afaiblissement du aux nuage liaison descendant
    [Kl,Anuagedwn]=AffNuage( fd,T2,elev,lwc2 );
%% Affablissement sintiilation
    %Calcule de l'afaiblissement du aux nuage liaison descendant
    Ascintdwn=scintillation(fd,elev,Dr,nu,p,Nwet2);   
%% Affaiblissement pluie
        %Calcule de l'afaiblissement du aux gaz liaison descendant
        [gamaR,Apluiedwn]=AffPluie(fd,elev,tau,Ro_o1_2,hr2,lat2,hs2,p);
%% Affaiblissement totale
LAt=Agazdwn+sqrt((Apluiedwn+Anuagedwn)^2+(Ascintdwn^2))

%% Calcule de calcule du températture de system(prenant en compte le bruit atmosphériques)
%Calcule du température de brillance
Tciel=Temp_bruit(LAt,'pluvieux');
%Température de bruit equivalent a la sortie de l'antenne de reception 
Ta=Tciel+(To*(1-nu));%[K]
%température system
Tsys=(Ta/(10^(Lfeedr/10)))+((1-(1/(10^(Lfeedr/10))))*To)+TLNA; %[K]
%% 1-Calcule de sensibilité du recepteur
[sens_recep,CsurNdesire,EbNoreq]=sensibilite(TEB,B,Rb,NFlna,Tsys,mod,etat)
%% Calcule liaison
% calcule du path loss
pl=fspl(h*1e3,physconst('LightSpeed')/(fd*1e9));%[dB]

%% Calcule de Puissance fournit
marge=0;%(consideration de perte en feeder considérée comme 0 en sate)
Pout=sens_recep-Gt-Gr+pl+LAt+Lfeedr+marge %[dBm]

%sens=Pout+Gt+Gr-pl-LAt-Lfeedr-marge-(10*log10((1.38*10^-23)*Tsys*B)+30)-NFlna

%calceule debit max
Rmax=B*log2(1+10^(CsurNdesire/10));
