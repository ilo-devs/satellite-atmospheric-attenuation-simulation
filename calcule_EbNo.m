clc 
clear all

%% Paramétre Initiale du station emetrice
% Pt=61; %[dBm,1.2 kW]
% Gt=61.3; %[dBm]
% Lfeedt=3; %[dB]
% lat1=-25;
% lon1=28;


%Paramétre satellite
%Gsu=15; %[dB]
%Gs=100; %[dB] %Gain d'amplification
Pts=20; %[dBW] % 100 Watt
Gsd=50; %[dB]
%Lfeedsatr=0; %[dB]
Lfeedsate=0; %[dB]
h=36000; %[Km]


%Paramétre Initiale du station terrien receptrice
Gr=40; %[dB]
Lfeedr=3; %[dB]
lat=19; %[Degrée]
lon=47; %[Degrée]
elev=45; %[Degrée]
nu=0.6;
TLNA=275; %[K] [représente le température equivalente a l'entrée du LNA(sans Température de bruits de l'antenne)]selon P372, Trmp.ref
To=290; %[K]selon P372,am le température apparente


%Paramétre atmosphérique, saison et radio
saison='été';
% mois='avril';
%fu=6; %[Ghz]
fd=12; %[Ghz]
tau=0;
p=0.01;
Ro_o1=50 %mm/h
hr=valHr(lat,lon); %hauteur de la pluie 
hs=valHs2(lat,lon); %Km %Tokiny "valhs" ra ntokiny izy
% lwc=valLred(lat,lon,p)%Kg/m2,valeur annuel
% [T,P,rho]=get_TPe2(lat,lon,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob) %[K][HPa][g/m3]


%% Calcule affaiblssement totale
%Affaiblissement Gaz
Ag=0;

%Affaiblissement Pluie
[gamaR,Ap]=AffPluie( fd,elev,tau,Ro_o1,hr,lat,hs,p);
Ap
%Affaiblissement Nuage et brouillard
Ac=0;

%Affaiblissement scintillation
As=0;


% Ag
% Ap
% Ac
% As
LAt=Ag+sqrt((Ap+Ac)^2+(As^2))
%At2=Ag+As+Ap+Ac;

%% Calcule du température de brillance
Tbrillance=Temp_bruit(LAt,'pluvieux')
%% Température de bruit equivalent a la sortie de l'antenne de reception 
Ta=Tbrillance+(To*(1-nu))%[K] %Mety misy diso
%Tsys
Tsys=10*log10((Ta/(10^(Lfeedr/10)))+(To*(1-(1/(10^(Lfeedr/10)))))+TLNA )%[dBK]

%% Calcule du path loss
% %Liaison montant
% Lpathu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));

%Liaison descendant
Lpathd=fspl(h*1e3,physconst('LightSpeed')/(fd*1e9));

%% Début du programme
%paramétre en entrée
BP=36*1e6;
Rb=26*1e6;
%Calcule de CNo liasion descendant
CNo=Pts-Lfeedsate+Gsd-Lpathd-LAt+Gr-Tsys-Lfeedr+228.6 %[dbHz]
%Calcule de CN liasion descendant
CN=Pts-Lfeedsate+Gsd-Lpathd-LAt+Gr-Tsys-Lfeedr+228.6-(10*log10(BP)) %[dbHz]

%Calcule de EbNo
EbNo=CNo-10*log10(Rb)
EbNo=CN-(10*log10(Rb))+(10*log10(BP))

%Cacule du BER pour modulation:QPSK,8-PSK,16-PSK et QAM
berQPSK=berawgn(EbNo,'psk',4,'nondiff')
ber8QPSK=berawgn(EbNo,'psk',8,'nondiff')
ber16QPSK=berawgn(EbNo,'psk',16,'nondiff')
berQAM=berawgn(EbNo,'qam',16)
