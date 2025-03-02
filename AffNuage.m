function [ Kl,Anuage ] = AffNuage( f,T,elev,lwc )
%Calcule de l'affaiblseemnt due aux nuage selon R.P840
%  Entrée
%f:Frequence [Ghz]
%T: Température considérée [K]
%elev:angle d'élévation [Degrée]
%lwc:contenue intégrée en eau liquide [Kg/m2]

%   Sortie
%Kl:Affaiblissement linéique spécifique
%Anuage:Affaiblissement due aux nuage et brouillard [dB]

theta=300/(T);
eo=77.6+(103.3.*(theta-1));
e1=0.0671*eo;
e2=3.52;
fp=20.20-(146.*(theta-1))+(316.*(theta-1)^2); %GHz
fs=39.8.*(fp); %GHz
eta2=((f*(eo-e1))/(fp*(1+((f/fp)^2)))) + ((f*(e1-e2))/(fs*(1+((f/fs)^2))));
eta1=((eo-e1)/(1+((f/fp)^2))) + ((e1-e2)/(1+((f/fs)^2)))+e2;
n=(2+eta1)/eta2;
% Affaiblissement Linéique specifique Kl ((dB/km)/(g/m^3))
Kl=(0.819.*f)/(eta2.*(1+n^2));

%Cacule de l'attenuation due aux nuage ou brouillard
Anuage=(lwc*Kl)/sind(elev);


end

