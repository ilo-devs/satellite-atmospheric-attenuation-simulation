clc 
clear all


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
h=35786; %[Km]


%Paramétre Initiale du station terrien receptrice
Gr=52; %[dB]
Lfeedr=3; %[dB]
lat2=19; %[Degrée]
lon2=47; %[Degrée]

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
for fd=[1.6,6,8,14,30]
    %Liaison descendant
    Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));

    Prt=[];
    for rho=0:1:20
        %Calcule de l'afaiblissement du aux gaz liaison descendant
        [Lo,Lw,Agazdwn]=AffGaz(lat2,lon2,saison,fd,elev,T1,P1,rho,p,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
        % Calcule de la puissance recue par l'antenne receptrice
        Pr=Pts+Gsd-Lpthd-Agazdwn+Gr-Lfeedr;
        Prt=[Prt Pr];
%         if rho==10
%             text(rho,Pr,'Bande');
%         end

    end
    plot([0:1:20],Prt,'LineWidth',2);
    xlabel('Concentration en vapeur d''eau [g/m3]');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction du concentration en vapeur d''eau');
    hold on
    grid on
end
hold off
legend('Bande S','Bande C','Bande X','Bande Ku','Bande Ka');




