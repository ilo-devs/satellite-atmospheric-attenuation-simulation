clc
clear all
%% Simulation d'une transmission par satellite en liaison descendante avec un schéma de modulation 16-PSK. En sortie, nous obtiendrons les valeurs suivantes :
%   - Affaiblissement atmosphérique (Gaz, Nuage, Scintillation, Pluie) [Lat]
%   - Eb/No requis [EbNoreq]
%   - C/N désirer [CsurNdesire]
%   - Sensibilité du récepteur [sens_recep]
%   - Puissance d'émission nécessaire pour le satellite [Pout]
% Lien code source complet : https://github.com/ilo-devs/satellite-atmospheric-attenuation-simulation

%Paramètre station au sol
lat2=-23.43;
lon2=133.46;
Gr=53;
To=290; %[°K]
nu=0.7; %[rendement]
NFlna=0.3; %[figure de bruits LNA][dB]
TLNA=((10^(NFlna/10))-1)*To; %[K]
Lfeedr=3; %[dB]
NFsys=15; %[figure de bruit systeme][dB]
Dr=1.5;

%Paramètre satellite
Gt=43; %[dBi]
Lfeeds=0; %[db]
%Paramètre longueur du trajet
h=10500;
%Paramètre atmosphérique et radioélctrique
fd=20; %[GHz]
elev=45; %[Ghz]
tau=90; %[V]
p=0.01; %[dispo de la pluie,gaz,...:99,99%]

%Paramètre transmission
TEB=1e-5;
mod='psk';
etat=16;
Rb=26*10^6; %[26 Mbps]
B=36*10^6; %[Mhz]

% Donée atmosphérique a importée
load itur836_4_vapd % ITU-R P.836-5
load data_Nwet % ITU-R 453-10
load data_rain_rate % ITU-R P.837-5
load data_topo % ITU-R P.1511-1
load data_hauteur_pluie % ITU-R 839-4

[T2,P2,rho2]=get_TPe2(lat2,lon2,0,p,'été',topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob)
lwc2=valLred(lat2,lon2,p)
Nwet2=valNwet(lat2,lon2,Lat_1dot5,Long_1dot5,Nwet_1dot5)
Ro_o1_2=taux_precipitation(p,lat2,lon2) 
hr2=valHr(lat2,lon2);
hs2=valHs2(lat2,lon2);

%% Affaiblissement gaz    
% Calcule de l'affaiblissement dû aux gaz
[Lo,Lw,Agazdwn]=AffGaz(lat2,lon2,'été',fd,elev,T2,P2,rho2,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%% Affaiblissement dû aux nuages
% Calcule de l'affaiblissement dû aux nuages
[Kl,Anuagedwn]=AffNuage( fd,T2,elev,lwc2 );
%% Affablissement scintillation
% Calcule de l'afaiblissement dû aux scintillations
Ascintdwn=scintillation(fd,elev,Dr,nu,p,Nwet2);   
%% Affaiblissement pluie
%Calcule de l'affaiblissement du a la pluie 
[gamaR,Apluiedwn]=AffPluie(fd,elev,tau,Ro_o1_2,hr2,lat2,hs2,p);
%% Affaiblissement totale en liaison descendant
LAt=Agazdwn+sqrt((Apluiedwn+Anuagedwn)^2+(Ascintdwn^2));

%% Calcule du températture de system (prenant en compte le bruit atmosphériques)
% Calcule de la température de brillance
Tciel=Temp_bruit(LAt,'pluvieux');
% Température de bruit equivalent a la sortie de l'antenne de reception 
Ta=Tciel+(To*(1-nu));%[K]
% Température Système
Tsys=(Ta/(10^(Lfeedr/10)))+((1-(1/(10^(Lfeedr/10))))*To)+TLNA; %[K]

%% Calcule de sensibilité du recepteur
[sens_recep,CsurNdesire,EbNoreq]=sensibilite(TEB,B,Rb,NFlna,Tsys,mod,etat);

%% calcule du path loss
pl=fspl(h*1e3,physconst('LightSpeed')/(fd*1e9));%[dB]

%% Calcule puissance nécessaire à l'émission du satellite
marge=0; %(Perte en feeder considérée comme 0 dans le satellite)
Pout=sens_recep-Gt-Gr+pl+LAt+Lfeedr+marge; %[dBm]
