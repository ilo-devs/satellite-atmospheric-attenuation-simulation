function [ Ascint ] = scintillation( f,elev,D,nu,p,Nwet)
%% fonction qui calcule l'evanouissement du a la scintillation selon UIT-R-618 
%   Entrée
% f: fréquence Ghz
% elev: Elevation %Degré
% D: Diamétre % m
% nu: Efficacité antenne (si pas connu alors nu=0.5)
% p: Pourcentage de temps 
% Lat_1dot5: Latitude de résolution 1.125°
% Long_1dot5: Longitude de résolution 1.125°
% Nwet_1dot5: Carte numérique contenant Nhum de résolution 1.125°

%   Sortie
% Ascint: dB

%% Calcule de l'evanouissement due a la scintillation

%% cas où on entre t,H ou en fonction de de TPe
% %Calcule de l'index latitude et longitude du coins gauche des 4 points le
% %plus proche
% [r,c]=find(Mlong_1dot125<=lon);
% coins_j=max(c);
% [r,c]=find(Mlat_1dot125>=lat);
% coins_i=max(r);

% [T,P,rho,e]=get_TPe2(lat,lon,0,p,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j ); %Atmosphére de référence aux niveau du sol
% T=convtemp(T,'K','C'); %Doit être en °C
% %Calcule es et H
% EFeau=1+(1e-4*(7.2+P*(0.00320+(5.9*(1e-7)*(T^2)))));
% es=EFeau*6.1121*exp(((18.678-(T/234.5))*T)/(T+257.14));
% H=(100*e)/es;

% %Calcule de Nhum
% Nhum=((72*H*es)/(100*(convtemp(T,'C','K'))))+((3.75*1e5*H*es)/(((convtemp(T,'C','K'))^2)*100));

Nhum=Nwet;

%Ecart type du signal de référence
ecartRef=(3.6*1e-3)+(1e-4*Nhum);

%Longueur equivalent du trajet
hl=1000;
L=(2*hl)/((sqrt((sind(elev)^2)+(2.35*1e-4))) + sind(elev));

%Diamétre equivalent de l'antenne
Deff=sqrt(nu)*D;

%facteur de moyennage
x=1.22*(Deff^2)*(f/L);
g=sqrt((3.86*((x^2+1)^(11/12))* sind((11/6)*atand(1/x)))-(7.08*(x^(5/6))));

%Ecart type
ecart=ecartRef*(f^(7/12))*(g/(sind(elev)^1.2));

%calculefacteur de pourcentage de temps
a=(-0.061*((log10(p))^3))+(0.072*(log10(p)^2))-(1.71*log10(p))+3.0;

%Profondeur d'evanouissement
Ascint=a*ecart;



end
%% Tokiny miapy if (angle(g)<0) => Ascint=0; Nefn le iz ar ts met o negatif d otran tsy mila apetaka
