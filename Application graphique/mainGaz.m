function Prt=mainGaz(rho,fd,h,lat2,lon2)

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

% Donée atmosphérique a importée
load itur836_4_vapd

%Paramétre atmosphérique, saison et radio
saison='été';
p=0.01;
elev=45; %[Degrée]

% [T,P]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
[T1,P1]=get_TPe2(lat2,lon2,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);

%% Calcule du path loss
% %Liaison montant
% Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));

%% Calcule de la bilan de liaison ou bilan de puissance avec concentration en vapeur d'eau variant =0:1:35 g/m3 (p=0.01)
%Liaison descendant
Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
Prt=[];
for rhoo=rho
    %Calcule de l'afaiblissement du aux gaz liaison descendant
    [~,~,Agazdwn]=AffGaz(lat2,lon2,saison,fd,elev,T1,P1,rhoo,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
    % Calcule de la puissance recue par l'antenne receptrice
    Pr=Pts+Gsd-Lpthd-Agazdwn+Gr-Lfeedr;
    Prt=[Prt Pr];
%         if rho==10
%             text(rho,Pr,'Bande');
%         end

end

end



