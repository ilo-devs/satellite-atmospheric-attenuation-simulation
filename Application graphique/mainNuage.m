function Prt=mainGaz(lwc,fd,h,lat2,lon2)

% Don�e atmosph�rique a import�e
load itur836_4_vapd

% %Param�tre Initiale du station emetrice
% Pt=61; %[dBm,1.2 kW]
% Gt=61.3; %[dBm]
% Lfeedt=3; %[dB]
% lat1=-25;
% lon1=28;


% %Param�tre satellite
% Gsu=15; %[dB]
% Gs=100; %[dB] %Gain d'amplification
Pts=50;%[dBm]
Gsd=30; %[dB]
% Lfeedsatr=0; %[dB]
% Lfeedsate=0; %[dB]
% h=35786; %[Km]


%Param�tre Initiale du station terrien receptrice
Gr=52; %[dB]
Lfeedr=3; %[dB]


%Param�tre atmosph�rique, saison et radio
saison='�t�';
% mois='avril';
p=0.01;
elev=45; %[Degr�e]


%[T1,P1]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc1=valLred(lat1,lon1,p);
[T2,~]=get_TPe2(lat2,lon2,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc2=valLred(lat2,lon2,p);

%% Calcule du path loss
% %Liaison montant
% Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));




%% Calcule de la bilan de liaison ou bilan de puissance avec eau liquide int�gr�e variant =0:1:35 g/m3 (p=0.01)

%Liaison descendant
Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
Prt=[];
for lwcc=lwc
    %Calcule de l'afaiblissement du aux gaz liaison descendant
    [Kl,Anuagedwn]=AffNuage( fd,T2,elev,lwcc );
    % Calcule de la puissance recue par l'antenne receptrice
    Pr=Pts+Gsd-Lpthd-Anuagedwn+Gr-Lfeedr;
    Prt=[Prt Pr];

end