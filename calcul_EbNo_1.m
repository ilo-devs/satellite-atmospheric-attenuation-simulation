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
Pts=0; %[dBW] % 1 Watt
Gsd=21.7; %[dB]
%Lfeedsatr=0; %[dB]
Lfeedsate=0; %[dB]
h=36000; %[Km]


%Paramétre Initiale du station terrien receptrice
Gr=15; %[dB]
Lfeedr=3; %[dB]
lat2=19; %[Degrée]
lon2=47; %[Degrée]
hr=valHr(lat2,lon2); %hauteur de la pluie 
hs=valHs2(lat2,lon2);


%Paramétre atmosphérique, saison et radio
saison='été';
% mois='avril';
%fu=6; %[Ghz]
fd=1.5; %[Ghz]
p=0.01;
tau=0;
elev=45; %[Degrée]
Tsys=24.8 %[dBK] [300]


%[T1,P1]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc1=valLred(lat1,lon1,p);
% T2=convtemp(15,'C','K');
%lwc2=valLred(lat2,lon2,p);

%% Calcule du path loss
% %Liaison montant
% Lpathu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));

%Liaison descendant
Lpathd=fspl(h*1e3,physconst('LightSpeed')/(fd*1e9));

%% Début du programme
%paramétre en entrée
BP=36*1e6;
Rb=25*1e6;
%Calcule de CNo liasion descendant
CNo=Pts-Lfeedsate+Gsd-Lpathd+Gr-Tsys-Lfeedr+228.6 %[dbHz]
%Calcule de CN liasion descendant
CN=Pts-Lfeedsate+Gsd-Lpathd+Gr-Tsys-Lfeedr+228.6-(10*log10(BP)) %[db]

%Calcule de EbNo
EbNo=CNo-(10*log10(Rb))
EbNo=CN-(10*log10(Rb))+(10*log10(BP))

%Cacule du BER pour modulation:QPSK,8-PSK,16-PSK et QAM
berQPSK=berawgn(EbNo,'psk',4,'nondiff')
ber8QPSK=berawgn(EbNo,'psk',8,'nondiff')
ber16QPSK=berawgn(EbNo,'psk',16,'nondiff')
berQAM=berawgn(EbNo,'qam',16)
