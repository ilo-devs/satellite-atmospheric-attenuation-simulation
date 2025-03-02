function Prt=mainPluie(Ro_o1,fd,h,lat,lon)
% Donée atmosphérique a importée
load itur836_4_vapd


% %Paramétre Initiale du station emetrice
% Pt=61; %[dBm,1.2 kW]
% Gt=61.3; %[dBm]
% Lfeedt=3; %[dB]
% lat1=-25;
% lon1=28;


% %Paramétre satellite
% Gsu=15; %[dB]
% Gs=100; %[dB] %Gain d'amplification
Pts=50;%[dBm]
Gsd=30; %[dB]
% Lfeedsatr=0; %[dB]
% Lfeedsate=0; %[dB]
% h=35786; %[Km]



%Paramétre Initiale du station terrien receptrice
Gr=52; %[dB]
Lfeedr=3; %[dB]
hr=valHr(lat,lon); %hauteur de la pluie 
hs=valHs2(lat,lon);


%Paramétre atmosphérique, saison et radio
saison='été';
% mois='avril';
p=0.01;
tau=0;
elev=45; %[Degrée]


%[T1,P1]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc1=valLred(lat1,lon1,p);
% [T2,P2]=get_TPe2(lat2,lon2,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc2=valLred(lat2,lon2,p);

%% Calcule du path loss
% %Liaison montant
% Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));



%% Calcule de la bilan de liaison ou bilan de puissance avec taux de precipitation variant =0:1:100 mm/h (p=0.01)
Prt=[];
%Liaison descendant
Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
for Ro_o11=Ro_o1
%     %Calcule de l'afaiblissement du aux gaz liaison montant
%     [gamaR,Agazup]=AffPluie(fu,T1,elev,lwc );
    %Calcule de l'afaiblissement du aux gaz liaison descendant
    [~,Apluiedwn]=AffPluie(fd,elev,tau,Ro_o11,hr,lat,hs,p);
    % Calcule de la puissance recue par l'antenne receptrice
    Pr=Pts+Gsd-Lpthd-Apluiedwn+Gr;
    Prt=[Prt Pr];

end

end

