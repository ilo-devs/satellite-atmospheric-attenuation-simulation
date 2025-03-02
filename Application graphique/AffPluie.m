function [ gamaR,Apluie ] = AffPluie( f,elev,tau,Ro_o1,hr,lat,hs,p)
% Calcule de l'atténuation du a la pluie selon le R-P618
%   Entrée
%f Gzh
%elev Degrée
%tau Degrée
%Ro-o1 Taux de precipitation pour une ourcentage de temps dépassée pendant 0.01%
%hr hauteur de la pluie
%lat latitude de la station terrien
%hs hauteur de la station terrien
%p pourcentage de temps considérée

%   Sortie
%gamaR:Affaiblissment linéique du a la pluie dB/Km
%Apluie:Affaiblissemt due a la pluie dépassée pendant "p" du temps dB

Re=8500; % 4/3 du rayon de la terre
%% Detemination des coefficient k et alpha
[k,alpha]=coefficientPrecipitation(f,elev,tau);

%% Calcule de l'affaiblissement linéique 
 gamaR=k*(Ro_o1.^alpha);
 
%% Calcule de l'affaiblissemnt par la pluie pour f=[6 11 22] pour 0.01%<= p <=1%
if elev >=5
    Ls=(hr-hs)/(sind(elev)); % slant-path length below the rain height (km)
elseif elev<5
    Ls=(2*(hr-hs))/(((((sind(elev))^2)+((2*(hr-hs))/Re))^0.5)+sind(elev));
end

LG=Ls.*cosd(elev); % The horizontal projection of the slant path length (km).

% Calculation of the horizontal reduction factor for 0.01% of the time
c=0.78*sqrt((LG*gamaR)/f);
d=0.38*(1-exp(-2*LG));
ro_o1=1/(1+c-d);

% Calculation of the vertical adjustment factor for 0.01% of the time
eta=atand((hr-hs)/LG*ro_o1);
if eta >elev
    LR=(LG*ro_o1)/cosd(elev);
else
    LR=(hr-hs)/sind(elev);
end;
abslat=abs(lat);
if abslat<36
    kye=36-abslat;
else
    kye=0;
end;
e=31*(1-exp(-elev/(1+kye)));
fff=sqrt(LR*gamaR)/f.^2;
vo_o1=1/(1+(sqrt(sind(elev)).*( (e*fff)-0.45)));

% Effective path length (km)
LE=LR*vo_o1;
% Rain attenuation at P=0.01% of time (dB)
RAtt01=LE*gamaR;

% Calculation of rain attenuation at different percentages of time
if p >=(1)||(abs(lat)>=36)
    beta=0;
elseif p <(1)&& (abs(lat)<36)&&(elev>=25)
    beta=-0.005*(abs(lat)-36);
else
    beta=-0.005*(abs(lat)-36)+1.8-4.25*sind(elev);
end
if p >=(0.001) && (p <=5)
    pu=(-1)*(0.655+(0.033*log(p))-(0.045*log(RAtt01))-(beta*(1-p).*sind(elev)));
    Apluie=RAtt01*(p/0.01)^(pu);
else
    error('Le pourcentage de temps dépassée doit être entre 0.001 et 0.5');
end

end

