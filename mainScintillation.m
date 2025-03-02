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
hr=valHr(lat2,lon2); %hauteur de la pluie 
hs=valHs2(lat2,lon2);
D=1.2 % M
nu=0.5


%Paramétre atmosphérique, saison et radio
saison='été';
% mois='avril';
p=0.01;
tau=0;
elev=45; %[Degrée]


%[T1,P1]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc1=valLred(lat1,lon1,p);
T2=convtemp(15,'C','K');
%lwc2=valLred(lat2,lon2,p);

%% Calcule du path loss
% %Liaison montant
% Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));



%% Calcule de la bilan de liaison ou bilan de puissance avec taux de precipitation variant =0:1:100 mm/h (p=0.01)
for fd=[1.6,6,8,14,30]
    Prt=[];
    %Liaison descendant
    Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
    for Nwet=0:1:30
        %Calcule de l'afaiblissement du aux gaz liaison descendant
        Ascintdwn=scintillation(fd,elev,D,nu,p,Nwet)
        % Calcule de la puissance recue par l'antenne receptrice
        Pr=Pts+Gsd-Lpthd-Ascintdwn+Gr-Lfeedr;
        Prt=[Prt Pr];

    end
    plot([0:1:30],Prt,'LineWidth',2);
    xlabel('Terme Humide du coinicide de réfraction');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction de Nhum');
    hold on
     grid on
    
end
hold off
legend('Bande S','Bande C','Bande X','Bande Ku','Bande Ka');


