clc 
clear all

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
h=35786; %[Km]



%Param�tre Initiale du station terrien receptrice
Gr=52; %[dB]
Lfeedr=3; %[dB]
lat2=19; %[Degr�e]
lon2=47; %[Degr�e]
hr=valHr(lat2,lon2); %hauteur de la pluie 
hs=valHs2(lat2,lon2);


%Param�tre atmosph�rique, saison et radio
saison='�t�';
% mois='avril';
p=0.01;
tau=0;
elev=45; %[Degr�e]


%[T1,P1]=get_TPe2(lat1,lon1,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc1=valLred(lat1,lon1,p);
[T2,P2]=get_TPe2(lat2,lon2,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
%lwc2=valLred(lat2,lon2,p);

%% Calcule du path loss
% %Liaison montant
% Lpthu=fspl(h*1e3,physconst('LightSpeed')/(fu*10e9));



%% Calcule de la bilan de liaison ou bilan de puissance avec taux de precipitation variant =0:1:100 mm/h (p=0.01)
for fd=[1.6,6,8,14,30]
    Prt=[];
    %Liaison descendant
    Lpthd=fspl(h*1e3,physconst('LightSpeed')/(fd*10e9));
    for Ro_o1=0:1:90
    %     %Calcule de l'afaiblissement du aux gaz liaison montant
    %     [gamaR,Agazup]=AffPluie(fu,T1,elev,lwc );
        %Calcule de l'afaiblissement du aux gaz liaison descendant
        [gamaR,Apluiedwn]=AffPluie(fd,elev,tau,Ro_o1,hr,lat2,hs,p);
        % Calcule de la puissance recue par l'antenne receptrice
        Pr=Pts+Gsd-Lpthd-Apluiedwn+Gr;
        Prt=[Prt Pr];

    end
    plot([0:1:90],Prt,'LineWidth',2);
    xlabel('Taux de precipitation [mm/h]');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction taux de precipitation');
    hold on
     grid on
end
hold off

legend('Bande S','Bande C','Bande X','Bande Ku','Bande Ka');

