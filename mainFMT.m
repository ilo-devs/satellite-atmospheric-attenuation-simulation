clc
clear all
%% Ici on ne va faire ici que la liaison descendant mais la méthode est la même pour une liaison montant
%Paramétre station au sol
lat=19;
lon=47;
Gr=53;
To=290;%[°K]
nu=0.7;%[rendement]
NFlna=1; %[figure de bruits LNA][dB]
TLNA=((10^(NFlna/10))-1)*To; %[K]
Lfeedr=3;%[dB];
NFsys=15;%[figure de bruit systeme][dB]


%Parametre satellite
Gt=43;%[dBi]
Lfeeds=0;%[db]
Pout=35.531980368770150;%[dBm]

%Parametre longueur du trajet
h=36000;

%Paramétre atmosphérique et radioélctrique
fd=30;%[GHz]
elev=45;%[Ghz]
tau=0;%[H]
p=0.01;%[dispo de la pluie,gaz,...:99,99%]

%Parmétre trasmissionn
TEB=1e-5;
mod='psk';
etat=4;
Rb=26*10^6;%[26Mbps]
B=36*10^6;%[Mhz]

Ro_o1=taux_precipitation(p,lat,lon)%[mm/h]
hr=valHr(lat,lon); %hauteur de la pluie 
hs=valHs2(lat,lon); %Km 




%% calcule de l'affaiblissement par l'amtosphere (considérons juste pluie pour ici)
%Calcule de l'affaiblissement du a la pluie
[gamaR,Ap]=AffPluie( fd,elev,tau,Ro_o1,hr,lat,hs,p)
Ag=0;
An=0;
As=0;

%Affaiblissement totale
LAt=Ag+sqrt((Ap+An)^2+(As^2))

%% Calcule de calcule du températture de system(prenant en compte le bruit atmosphériques)
%Calcule du température de brillance
Tciel=Temp_bruit(LAt,'pluvieux');
%Température de bruit equivalent a la sortie de l'antenne de reception 
Ta=Tciel+(To*(1-nu));%[K]
%température system
Tsys=(Ta/(10^(Lfeedr/10)))+((1-(1/(10^(Lfeedr/10))))*To)+TLNA %[K]
%% 1-Calcule de sensibilité du recepteur
[sens_recep4,CsurNdesire4,EbNo4]=sensibilite(TEB,B,Rb,NFlna,Tsys,mod,etat)

% Calcule liaison
%% calcule du path loss
pl=fspl(h*1e3,physconst('LightSpeed')/(fd*1e9));%[dB]

%-Fin%
%% caluler bilan de liaison avec forte pluie
rain=10;%[mm/h]
%calcule de la puissance du porteuse
[gamaR,Ap]=AffPluie(fd,elev,tau,rain,hr,lat,hs,p)
Ag=0;
An=0;
As=0;

%Affaiblissement totale
LAt=Ag+sqrt((Ap+An)^2+(As^2))

%% calcule du puissance recue
pr=Pout-Lfeeds+Gt-pl-LAt+Gr-Lfeedr%Ici Pout=Pt puisque Lfeeds=0

%FMT trnsmission,but comparée débit obtenue avec mod 16 et 8 PSK
if pr-(sens_recep4)<0
    %icion va calculée C/n requ vaovao
    %Calcule du Tsys vaovao
    Tciel=Temp_bruit(LAt,'pluvieux');
    %Température de bruit equivalent a la sortie de l'antenne de reception 
    Ta=Tciel+(To*(1-nu));%[K]
    %température system
    Tsys=(Ta/(10^(Lfeedr/10)))+((1-(1/(10^(Lfeedr/10))))*To)+TLNA ;%[K]
    N=10*log10((1.38*10^-23)*Tsys*B)+30;
    CsNvaoreq=pr-N-NFlna
    %Resulatat attendue,debit
    %pour 16 psk
    %1-Calcule de sensibilité du recepteur
    [~,~,EbNo16]=sensibilite(TEB,B,Rb,NFlna,Tsys,mod,16)
    D16=10^((CsNvaoreq-EbNo16+(10*log10(B)))/10)
    
    %pour 8PSK
    %1-Calcule de sensibilité du recepteur
    [~,~,EbNo8]=sensibilite(TEB,B,Rb,NFlna,Tsys,mod,8)
    D8=10^((CsNvaoreq-EbNo8+(10*log10(B)))/10)
    
    %pour 4 psk
    %1-Calcule de sensibilité du recepteur
    D4=10^((CsNvaoreq-EbNo4+(10*log10(B)))/10)
    
end